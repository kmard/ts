
Процедура PrintRoGaS(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(PrintRoGaS)
	Макет = Документы.ReceiptOfGoodsAndServises.ПолучитьМакет("PrintRoGaS");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ReceiptOfGoodsAndServises.Contractor,
	|	ReceiptOfGoodsAndServises.Deal,
	|	ReceiptOfGoodsAndServises.Storage,
	|	ReceiptOfGoodsAndServises.Дата,
	|	ReceiptOfGoodsAndServises.Номер,
	|	ReceiptOfGoodsAndServises.GoodsAndServices.(
	|		НомерСтроки,
	|		GaS,
	|		UoM,
	|		Amount,
	|		Price,
	|		Summ
	|	)
	|ИЗ
	|	Документ.ReceiptOfGoodsAndServises КАК ReceiptOfGoodsAndServises
	|ГДЕ
	|	ReceiptOfGoodsAndServises.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьGoodsAndServicesШапка = Макет.ПолучитьОбласть("GoodsAndServicesШапка");
	ОбластьGoodsAndServices = Макет.ПолучитьОбласть("GoodsAndServices");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ТабДок.Вывести(ОбластьGoodsAndServicesШапка);
		ВыборкаGoodsAndServices = Выборка.GoodsAndServices.Выбрать();
		Пока ВыборкаGoodsAndServices.Следующий() Цикл
			ОбластьGoodsAndServices.Параметры.Заполнить(ВыборкаGoodsAndServices);
			ТабДок.Вывести(ОбластьGoodsAndServices, ВыборкаGoodsAndServices.Уровень());
		КонецЦикла;

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры
