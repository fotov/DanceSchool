
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФиксацияПосещенийПосещения.Абонемент
	|ИЗ
	|	Документ.ФиксацияПосещений.Посещения КАК ФиксацияПосещенийПосещения
	|ГДЕ
	|	ФиксацияПосещенийПосещения.Ссылка = &Ссылка
	|	И ФиксацияПосещенийПосещения.Абонемент.ВидАбонемента.КоличествоЗанятий > 0";
	
	АбонементыСКонтролемКоличестваЗанятий = Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		АбонементыСКонтролемКоличестваЗанятий.Добавить(Выборка.Абонемент);
		
		Запись = Движения.ОстаткиПосещений.ДобавитьРасход();
		Запись.Период = Дата;
		Запись.Абонемент = Выборка.Абонемент;
		Запись.Количество = 1;
		
	КонецЦикла;
	
	Движения.ОстаткиПосещений.Записать();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("АбонементыСКонтролемКоличестваЗанятий", АбонементыСКонтролемКоличестваЗанятий);
	Запрос.УстановитьПараметр("Абонементы", Посещения.ВыгрузитьКолонку("Абонемент"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОстаткиПосещенийОстатки.Абонемент,
	|	NULL,
	|	NULL
	|ИЗ
	|	РегистрНакопления.ОстаткиПосещений.Остатки(&Период, Абонемент В (&АбонементыСКонтролемКоличестваЗанятий)) КАК
	|		ОстаткиПосещенийОстатки
	|ГДЕ
	|	ОстаткиПосещенийОстатки.КоличествоОстаток < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	NULL,
	|	СтатусыАбонементовСрезПоследних.Абонемент,
	|	СтатусыАбонементовСрезПоследних.Статус
	|ИЗ
	|	РегистрСведений.СтатусыАбонементов.СрезПоследних(&Период, Абонемент В (&Абонементы)) КАК
	|		СтатусыАбонементовСрезПоследних";

КонецПроцедуры
