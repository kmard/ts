
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаОбъект 			= ОбъектОбработки();
	Объект.ДоступныеТипыДанных	= ОбработкаОбъект.Метаданные().Реквизиты.ДоступныеТипыДанных.Тип;
	Объект.ПутьКФормам 			= ОбработкаОбъект.Метаданные().ПолноеИмя() + ".Форма";
	
	Элементы.ВидГраницы.СписокВыбора.Добавить("Включая");
	Элементы.ВидГраницы.СписокВыбора.Добавить("Исключая");
	ВидГраницыФормы = Элементы.ВидГраницы.СписокВыбора.Получить(0).Значение;
	
	// Получение списка типов и его фильтрация.
	СписокТипов = ОбъектОбработки().СформироватьСписокТипов();
	ОбъектОбработки().ФильтрацияСпискаТипов(СписокТипов, "Граница");
	
	// Считывание параметров передачи.
	ПараметрыПередачи 	= ПолучитьИзВременногоХранилища(Параметры.АдресХранилища);
	Объект.Запросы.Загрузить(ПараметрыПередачи.Запросы);	
	Объект.Параметры.Загрузить(ПараметрыПередачи.Параметры);
	Объект.ИмяФайла 	= ПараметрыПередачи.ИмяФайла;
	ИдентификаторТекущегоЗапроса 	= ПараметрыПередачи.ИдентификаторТекущегоЗапроса;
	ИдентификаторТекущегоПараметра	= ПараметрыПередачи.ИдентификаторТекущегоПараметра;
	
	ЗаполнитьЗначения();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПолучениеМоментаВремени" Тогда 
		ПолучениеМоментаВремени(Параметр);
	КонецЕсли;	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ТипНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ТипЗавершениеВыбора", ЭтотОбъект);
	СписокТипов.ПоказатьВыборЭлемента(ОписаниеОповещения, НСтр("ru = 'Выбрать тип'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗавершениеВыбора(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		
		ТекущийТип = ВыбранныйЭлемент;
		
		Если ТекущийТип.Значение = "МоментВремени" Тогда 
			Тип 			= ТекущийТип.Представление;
			Значение    	= Тип;
			ЗначениеВФорме 	= Тип;
		Иначе
			Тип 		= ТекущийТип.Представление;
			
			Массив 		= Новый Массив;
			Массив.Добавить(Тип(ТекущийТип.Значение));
			Описание	= Новый ОписаниеТипов(Массив);
			
			ЗначениеВФорме	= Описание.ПривестиЗначение(ТекущийТип.Значение);
			Значение		= Описание.ПривестиЗначение(ТекущийТип.Значение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеВФормеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПередаваемыеЗапросы = ПередачаЗапросов();
	ПередаваемыеЗапросы.Вставить("Значение",Значение);
	
	Если Тип =  НСтр("ru = 'Момент времени'") Тогда
		Путь = Объект.ПутьКФормам + "." + "МоментВремени";
		ОткрытьФорму(Путь, ПередаваемыеЗапросы, ЭтотОбъект);
	Иначе
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеВФормеПриИзменении(Элемент)
	ИзменениеЗначенияВФорме();
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// КОМАНДЫ

&НаКлиенте
Процедура ЗаписатьГраницу(Команда)
	ВыгрузитьГраницуСервер();
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

// Передача табличной части "Запросы", "Параметры" в виде структуры.
//
&НаСервере
Функция ПередачаЗапросов()
	АдресХранилища		= ОбъектОбработки().ПоместитьЗапросыВоВременноеХранилище(Объект, ИдентификаторТекущегоЗапроса,ИдентификаторТекущегоПараметра);
	ПараметрАдрес		= Новый Структура;
	ПараметрАдрес.Вставить("АдресХранилища", АдресХранилища);
	Возврат ПараметрАдрес;
КонецФункции

&НаСервере
Процедура ПолучениеМоментаВремени(СтруктураПередачи)
	Значение  		= СтруктураПередачи.ВнутрМоментВремени;
	ЗначениеВФорме	= СтруктураПередачи.ПредставлениеМоментаВремени;
КонецПроцедуры	

&НаКлиенте
Процедура ВыгрузитьГраницуСервер()
	ПараметрыПередачи = ПоместитьЗапросыВСтруктуру(ИдентификаторТекущегоЗапроса, ИдентификаторТекущегоПараметра);
	Закрыть(); 
	Владелец 					= ЭтотОбъект.ВладелецФормы;
	Владелец.Модифицированность = Истина;
	Владелец.ВыгрузитьЗапросыВРеквизиты(ПараметрыПередачи);
КонецПроцедуры	

&НаСервере
Функция ВнутрЗначениеОбъектаГраницы()
	ВидГран	= ОбъектОбработки().ОпределениеВидаГраницы(ВидГраницыФормы);
	ГраницаФормы 	= Новый Граница(ЗначениеИзСтрокиВнутр(Значение),ВидГран);
	
	Возврат ЗначениеВСтрокуВнутр(ГраницаФормы);
КонецФункции

&НаСервере
Функция ПоместитьЗапросыВСтруктуру(ИдентификаторЗапроса, ИдентификаторПараметра)
	ПараметрыФормы 	= Объект.Параметры;
	
	ПредставлениеГраницы = СформироватьГраницу();
	
	Для каждого Стр Из ПараметрыФормы Цикл
		Если Стр.Идентификатор = ИдентификаторТекущегоПараметра Тогда
			Стр.Тип		 		= "Граница";
			Стр.Значение 		= ВнутрЗначениеОбъектаГраницы();
			Стр.ТипВФорме		= НСтр("ru ='Граница'");
			Стр.ЗначениеВФорме	= ПредставлениеГраницы;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыПередачи = Новый Структура;
	ПараметрыПередачи.Вставить("АдресХранилища", ОбъектОбработки().ПоместитьЗапросыВоВременноеХранилище(Объект,ИдентификаторЗапроса,ИдентификаторПараметра));
	Возврат ПараметрыПередачи;
КонецФункции	

&НаСервере
Процедура ЗаполнитьЗначения()
	ПараметрыФормы = Объект.Параметры;
	Для каждого ТекущийПараметр Из ПараметрыФормы Цикл
		Если ТекущийПараметр.Идентификатор = ИдентификаторТекущегоПараметра Тогда
			Значение = ТекущийПараметр.Значение;
			Если ПустаяСтрока(Значение) Тогда
				Возврат;
			Иначе
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Граница = ЗначениеИзСтрокиВнутр(Значение);
	Если ТипЗнч(Граница) <> Тип("Граница") Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеЗагруженное = Граница.Значение;
	ТипЗ = ОбъектОбработки().ИмяТипаИзЗначения(ЗначениеЗагруженное);
	Тип = СписокТипов.НайтиПоЗначению(ТипЗ).Представление;
	Если Тип <> НСтр("ru = 'Момент времени'") Тогда
		ЗначениеВФорме = ЗначениеЗагруженное;
	Иначе
		ЗначениеВФорме = ОбъектОбработки().ФормированиеПредставленияЗначения(ЗначениеЗагруженное);
	КонецЕсли;
	Значение = ЗначениеВСтрокуВнутр(ЗначениеЗагруженное);
	
	Если Граница.ВидГраницы = ВидГраницы.Включая Тогда
		ВидГраницыФормы = элементы.ВидГраницы.СписокВыбора.Получить(0).Значение;
	Иначе
		ВидГраницыФормы = элементы.ВидГраницы.СписокВыбора.Получить(1).Значение;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СформироватьГраницу()
	ВидГран	= ОбъектОбработки().ОпределениеВидаГраницы(ВидГраницыФормы);
	ГраницаФормы 	= Новый Граница(ЗначениеИзСтрокиВнутр(Значение),ВидГран);
	
	Представление = ОбъектОбработки().ФормированиеПредставленияЗначения(ГраницаФормы);
	
	Возврат Представление;
КонецФункции	

&НаСервере
Процедура ИзменениеЗначенияВФорме()
	Значение = ЗначениеВСтрокуВнутр(ЗначениеВФорме);
КонецПроцедуры	

#КонецОбласти
