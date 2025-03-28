type apiLogType = Request | Response | NoResponse | Method | Err
type logType = DEBUG | INFO | ERROR | WARNING | SILENT
type logCategory = API | USER_ERROR | USER_EVENT | MERCHANT_EVENT

type eventName =
  | APP_RENDERED
  | PAYMENT_METHOD_CHANGED
  | PAYMENT_DATA_FILLED
  | PAYMENT_ATTEMPT
  | PAYMENT_SUCCESS
  | PAYMENT_FAILED
  | INPUT_FIELD_CHANGED
  | RETRIEVE_CALL_INIT
  | RETRIEVE_CALL
  | AUTHENTICATION_CALL_INIT
  | AUTHENTICATION_CALL
  | CONFIRM_CALL_INIT
  | CONFIRM_CALL
  | CONFIRM_PAYOUT_CALL_INIT
  | CONFIRM_PAYOUT_CALL
  | SESSIONS_CALL_INIT
  | SESSIONS_CALL
  | PAYMENT_METHODS_CALL_INIT
  | SAVED_PAYMENT_METHODS_CALL_INIT
  | PAYMENT_METHODS_CALL
  | SAVED_PAYMENT_METHODS_CALL
  | CUSTOMER_PAYMENT_METHODS_CALL_INIT
  | CUSTOMER_PAYMENT_METHODS_CALL
  | CREATE_CUSTOMER_PAYMENT_METHODS_CALL_INIT
  | CREATE_CUSTOMER_PAYMENT_METHODS_CALL
  | TRUSTPAY_SCRIPT
  | PM_AUTH_CONNECTOR_SCRIPT
  | GOOGLE_PAY_SCRIPT
  | APPLE_PAY_FLOW
  | GOOGLE_PAY_FLOW
  | PAYPAL_FLOW
  | PAYPAL_SDK_FLOW
  | KLARNA_CHECKOUT_FLOW
  | APP_INITIATED
  | APP_REINITIATED
  | LOG_INITIATED
  | LOADER_CALLED
  | ORCA_ELEMENTS_CALLED
  | PAYMENT_OPTIONS_PROVIDED
  | BLUR
  | FOCUS
  | CLEAR
  | CONFIRM_PAYMENT
  | CONFIRM_CARD_PAYMENT
  | SDK_CRASH
  | INVALID_PK
  | DEPRECATED_LOADSTRIPE
  | REQUIRED_PARAMETER
  | UNKNOWN_KEY
  | UNKNOWN_VALUE
  | TYPE_BOOL_ERROR
  | TYPE_INT_ERROR
  | TYPE_STRING_ERROR
  | INVALID_FORMAT
  | SDK_CONNECTOR_WARNING
  | VALUE_OUT_OF_RANGE
  | HTTP_NOT_ALLOWED
  | INTERNAL_API_DOWN
  | REDIRECTING_USER
  | DISPLAY_BANK_TRANSFER_INFO_PAGE
  | DISPLAY_QR_CODE_INFO_PAGE
  | DISPLAY_VOUCHER
  | DISPLAY_THREE_DS_SDK
  | THREE_DS_METHOD
  | THREE_DS_METHOD_RESULT
  | PAYMENT_METHODS_RESPONSE
  | LOADER_CHANGED
  | PAYMENT_SESSION_INITIATED
  | POLL_STATUS_CALL_INIT
  | POLL_STATUS_CALL
  | COMPLETE_AUTHORIZE_CALL_INIT
  | COMPLETE_AUTHORIZE_CALL
  | PLAID_SDK
  | PAYMENT_METHODS_AUTH_EXCHANGE_CALL_INIT
  | PAYMENT_METHODS_AUTH_EXCHANGE_CALL
  | PAYMENT_METHODS_AUTH_LINK_CALL_INIT
  | PAYMENT_METHODS_AUTH_LINK_CALL
  | PAYMENT_MANAGEMENT_ELEMENTS_CALLED
  | DELETE_SAVED_PAYMENT_METHOD
  | DELETE_PAYMENT_METHODS_CALL_INIT
  | DELETE_PAYMENT_METHODS_CALL
  | EXTERNAL_TAX_CALCULATION
  | POST_SESSION_TOKENS_CALL
  | POST_SESSION_TOKENS_CALL_INIT
  | PAZE_SDK_FLOW
  | SAMSUNG_PAY_SCRIPT
  | SAMSUNG_PAY
  | CLICK_TO_PAY_SCRIPT
  | CLICK_TO_PAY_FLOW
  | PAYMENT_METHOD_TYPE_DETECTION_FAILED

let eventNameToStrMapper = (eventName: eventName) => (eventName :> string)

let getPaymentId = clientSecret =>
  String.split(clientSecret, "_secret_")->Array.get(0)->Option.getOr("")

let convertToScreamingSnakeCase = text => {
  text->String.trim->String.replaceRegExp(%re("/ /g"), "_")->String.toUpperCase
}

let toSnakeCaseWithSeparator = (str, separator) => {
  str->Js.String2.unsafeReplaceBy0(%re("/[A-Z]/g"), (letter, _, _) =>
    `${separator}${letter->String.toLowerCase}`
  )
}

type maskableDetails = Email | CardDetails
type source = Loader | Elements(CardThemeType.mode) | Headless

type logFile = {
  timestamp: string,
  logType: logType,
  category: logCategory,
  source: string,
  version: string,
  value: string,
  internalMetadata: string,
  sessionId: string,
  merchantId: string,
  paymentId: string,
  appId: string,
  platform: string,
  browserName: string,
  browserVersion: string,
  userAgent: string,
  eventName: eventName,
  latency: string,
  firstEvent: bool,
  paymentMethod: string,
  metadata: JSON.t,
  ephemeralKey: string,
}

type setlogApiValueType =
  | ArrayType(array<(string, JSON.t)>)
  | StringValue(string)

type setLogInfo = (
  ~value: string,
  ~internalMetadata: string=?,
  ~eventName: eventName,
  ~timestamp: string=?,
  ~latency: float=?,
  ~logType: logType=?,
  ~logCategory: logCategory=?,
  ~paymentMethod: string=?,
) => unit

type loggerMake = {
  setLogInfo: setLogInfo,
  setLogError: setLogInfo,
  setLogApi: (
    ~value: setlogApiValueType,
    ~internalMetadata: setlogApiValueType,
    ~eventName: eventName,
    ~timestamp: string=?,
    ~logType: logType=?,
    ~logCategory: logCategory=?,
    ~paymentMethod: string=?,
    ~apiLogType: apiLogType=?,
    ~isPaymentSession: bool=?,
  ) => unit,
  setLogInitiated: unit => unit,
  setConfirmPaymentValue: (~paymentType: string) => JSON.t,
  sendLogs: unit => unit,
  setSessionId: string => unit,
  setClientSecret: string => unit,
  setMerchantId: string => unit,
  setMetadata: JSON.t => unit,
  setSource: string => unit,
  setEphemeralKey: string => unit,
}

let defaultLoggerConfig = {
  sendLogs: () => (),
  setClientSecret: _x => (),
  setEphemeralKey: _x => (),
  setConfirmPaymentValue: (~paymentType as _) => {Dict.make()->JSON.Encode.object},
  setLogError: (
    ~value as _,
    ~internalMetadata as _=?,
    ~eventName as _,
    ~timestamp as _=?,
    ~latency as _=?,
    ~logType as _=?,
    ~logCategory as _=?,
    ~paymentMethod as _=?,
  ) => (),
  setLogApi: (
    ~value as _,
    ~internalMetadata as _,
    ~eventName as _,
    ~timestamp as _=?,
    ~logType as _=?,
    ~logCategory as _=?,
    ~paymentMethod as _=?,
    ~apiLogType as _=?,
    ~isPaymentSession as _=?,
  ) => (),
  setLogInfo: (
    ~value as _,
    ~internalMetadata as _=?,
    ~eventName as _,
    ~timestamp as _=?,
    ~latency as _=?,
    ~logType as _=?,
    ~logCategory as _=?,
    ~paymentMethod as _=?,
  ) => (),
  setLogInitiated: () => (),
  setMerchantId: _x => (),
  setSessionId: _x => (),
  setMetadata: _x => (),
  setSource: _x => (),
}

let logFileToObj = logFile => {
  [
    ("timestamp", logFile.timestamp->JSON.Encode.string),
    (
      "log_type",
      switch logFile.logType {
      | DEBUG => "DEBUG"
      | INFO => "INFO"
      | ERROR => "ERROR"
      | WARNING => "WARNING"
      | SILENT => "SILENT"
      }->JSON.Encode.string,
    ),
    ("component", "WEB"->JSON.Encode.string),
    (
      "category",
      switch logFile.category {
      | API => "API"
      | USER_ERROR => "USER_ERROR"
      | USER_EVENT => "USER_EVENT"
      | MERCHANT_EVENT => "MERCHANT_EVENT"
      }->JSON.Encode.string,
    ),
    ("source", logFile.source->convertToScreamingSnakeCase->JSON.Encode.string),
    ("version", logFile.version->JSON.Encode.string),
    ("value", logFile.value->JSON.Encode.string),
    ("internal_metadata", logFile.internalMetadata->JSON.Encode.string),
    ("session_id", logFile.sessionId->JSON.Encode.string),
    ("merchant_id", logFile.merchantId->JSON.Encode.string),
    ("payment_id", logFile.paymentId->JSON.Encode.string),
    ("app_id", logFile.appId->JSON.Encode.string),
    ("platform", logFile.platform->convertToScreamingSnakeCase->JSON.Encode.string),
    ("user_agent", logFile.userAgent->JSON.Encode.string),
    ("event_name", logFile.eventName->eventNameToStrMapper->JSON.Encode.string),
    ("browser_name", logFile.browserName->convertToScreamingSnakeCase->JSON.Encode.string),
    ("browser_version", logFile.browserVersion->JSON.Encode.string),
    ("latency", logFile.latency->JSON.Encode.string),
    ("first_event", (logFile.firstEvent ? "true" : "false")->JSON.Encode.string),
    ("payment_method", logFile.paymentMethod->convertToScreamingSnakeCase->JSON.Encode.string),
  ]
  ->Dict.fromArray
  ->JSON.Encode.object
}

let getRefFromOption = val => {
  let innerValue = val->Option.getOr("")
  ref(innerValue)
}
let getSourceString = source => {
  switch source {
  | Loader => "hyper_loader"
  | Elements(paymentMode) => {
      let formattedPaymentMode =
        paymentMode
        ->CardThemeType.getPaymentModeToStrMapper
        ->toSnakeCaseWithSeparator("_")
      "hyper" ++ formattedPaymentMode
    }
  | Headless => "headless"
  }
}

let findVersion = (re, content) => {
  let result = Js.Re.exec_(re, content)
  let version = switch result {
  | Some(val) => Js.Re.captures(val)
  | None => []
  }
  version
}

let browserDetect = content => {
  if RegExp.test("Instagram"->RegExp.fromString, content) {
    let re = %re("/Instagram\/([\d]+\.[\w]?\.?[\w]+)/ig")
    let version = switch findVersion(re, content)
    ->Array.get(1)
    ->Option.getOr(Nullable.null)
    ->Nullable.toOption {
    | Some(a) => a
    | None => ""
    }
    `Instagram-${version}`
  } else if RegExp.test("FBAV"->RegExp.fromString, content) {
    let re = %re("/FBAV\/([\d]+\.[\w]?\.?[\w]+)/ig")
    let version = switch findVersion(re, content)
    ->Array.get(1)
    ->Option.getOr(Nullable.null)
    ->Nullable.toOption {
    | Some(a) => a
    | None => ""
    }
    `Facebook-${version}`
  } else if RegExp.test("Twitter"->RegExp.fromString, content) {
    let re = %re("/iPhone\/([\d]+\.[\w]?\.?[\w]+)/ig")
    let version = switch findVersion(re, content)
    ->Array.get(1)
    ->Option.getOr(Nullable.null)
    ->Nullable.toOption {
    | Some(a) => a
    | None => ""
    }
    `Twitter-${version}`
  } else if RegExp.test("LinkedIn"->RegExp.fromString, content) {
    let re = %re("/LinkedInApp\/([\d]+\.[\w]?\.?[\w]+)/ig")
    let version = switch findVersion(re, content)
    ->Array.get(1)
    ->Option.getOr(Nullable.null)
    ->Nullable.toOption {
    | Some(a) => a
    | None => ""
    }
    `LinkedIn-${version}`
  } else if RegExp.test("Edg"->RegExp.fromString, content) {
    let re = %re("/Edg\/([\d]+\.[\w]?\.?[\w]+)/ig")
    let version = switch findVersion(re, content)
    ->Array.get(1)
    ->Option.getOr(Nullable.null)
    ->Nullable.toOption {
    | Some(a) => a
    | None => ""
    }
    `Microsoft Edge-${version}`
  } else if RegExp.test("Chrome"->RegExp.fromString, content) {
    let re = %re("/Chrome\/([\d]+\.[\w]?\.?[\w]+)/ig")
    let version = switch findVersion(re, content)
    ->Array.get(1)
    ->Option.getOr(Nullable.null)
    ->Nullable.toOption {
    | Some(a) => a
    | None => ""
    }
    `Chrome-${version}`
  } else if RegExp.test("Safari"->RegExp.fromString, content) {
    let re = %re("/Safari\/([\d]+\.[\w]?\.?[\w]+)/ig")
    let version = switch findVersion(re, content)
    ->Array.get(1)
    ->Option.getOr(Nullable.null)
    ->Nullable.toOption {
    | Some(a) => a
    | None => ""
    }
    `Safari-${version}`
  } else if RegExp.test("opera"->RegExp.fromString, content) {
    let re = %re("/Opera\/([\d]+\.[\w]?\.?[\w]+)/ig")
    let version = switch findVersion(re, content)
    ->Array.get(1)
    ->Option.getOr(Nullable.null)
    ->Nullable.toOption {
    | Some(a) => a
    | None => ""
    }
    `Opera-${version}`
  } else if (
    RegExp.test("Firefox"->RegExp.fromString, content) ||
    RegExp.test("fxios"->RegExp.fromString, content)
  ) {
    if RegExp.test("Firefox"->RegExp.fromString, content) {
      let re = %re("/Firefox\/([\d]+\.[\w]?\.?[\w]+)/ig")
      let version = switch findVersion(re, content)
      ->Array.get(1)
      ->Option.getOr(Nullable.null)
      ->Nullable.toOption {
      | Some(a) => a
      | None => ""
      }
      `Firefox-${version}`
    } else {
      let re = %re("/fxios\/([\d]+\.[\w]?\.?[\w]+)/ig")
      let version = switch findVersion(re, content)
      ->Array.get(1)
      ->Option.getOr(Nullable.null)
      ->Nullable.toOption {
      | Some(a) => a
      | None => ""
      }
      `Firefox-${version}`
    }
  } else {
    "Others-0"
  }
}

let arrayOfNameAndVersion = String.split(Window.Navigator.userAgent->browserDetect, "-")

let make = (
  ~sessionId=?,
  ~source: source,
  ~clientSecret=?,
  ~merchantId=?,
  ~metadata=?,
  ~ephemeralKey=?,
) => {
  let loggingLevel = switch GlobalVars.loggingLevelStr {
  | "DEBUG" => DEBUG
  | "INFO" => INFO
  | "WARNING" => WARNING
  | "ERROR" => ERROR
  | "SILENT"
  | _ =>
    SILENT
  }
  let mainLogFile: array<logFile> = []
  let sessionId = getRefFromOption(sessionId)
  let setSessionId = value => {
    sessionId := value
  }
  let sourceString = source->getSourceString

  let events = ref(Dict.make())
  let eventsCounter = ref(Dict.make())

  let timeOut = ref(None)

  let merchantId = getRefFromOption(merchantId)
  let setMerchantId = value => {
    merchantId := value
  }

  let metadata = ref(metadata->Option.getOr(JSON.Encode.null))

  let setMetadata = value => {
    metadata := value
  }

  let calculateAndUpdateCounterHook = eventName => {
    let updatedCounter = switch eventsCounter.contents->Dict.get(eventName) {
    | Some(num) => num + 1
    | None => 1
    }
    eventsCounter.contents->Dict.set(eventName, updatedCounter)
    updatedCounter
  }

  let conditionalLogPush = (log: logFile) => {
    let maxLogsPushedPerEventName = GlobalVars.maxLogsPushedPerEventName
    let conditionalEventName = switch log.eventName {
    | INPUT_FIELD_CHANGED => log.value // to enforce rate limiting for each input field independently
    | _ => ""
    }
    let eventName = log.eventName->eventNameToStrMapper ++ conditionalEventName

    let counter = eventName->calculateAndUpdateCounterHook
    if GlobalVars.enableLogging && counter <= maxLogsPushedPerEventName {
      switch loggingLevel {
      | DEBUG => log->(Array.push(mainLogFile, _))->ignore
      | INFO =>
        [INFO, WARNING, ERROR]->Array.includes(log.logType)
          ? log->(Array.push(mainLogFile, _))->ignore
          : ()
      | WARNING =>
        [WARNING, ERROR]->Array.includes(log.logType)
          ? log->(Array.push(mainLogFile, _))->ignore
          : ()
      | ERROR =>
        [ERROR]->Array.includes(log.logType) ? log->(Array.push(mainLogFile, _))->ignore : ()
      | SILENT => ()
      }
    }
  }

  let beaconApiCall = data => {
    if data->Array.length > 0 {
      let logData = data->Array.map(logFileToObj)->JSON.Encode.array->JSON.stringify
      Window.Navigator.sendBeacon(GlobalVars.logEndpoint, logData)
    }
  }

  let clientSecret = getRefFromOption(clientSecret)
  let ephemeralKey = getRefFromOption(ephemeralKey)

  let setClientSecret = value => {
    clientSecret := value
  }

  let setEphemeralKey = value => {
    ephemeralKey := value
  }

  let sourceRef = ref(source->getSourceString)

  let setSource = value => {
    sourceRef := value
  }

  let rec sendLogs = () => {
    switch timeOut.contents {
    | Some(val) => {
        clearTimeout(val)
        timeOut := Some(setTimeout(() => sendLogs(), 20000))
      }
    | None => timeOut := Some(setTimeout(() => sendLogs(), 20000))
    }
    beaconApiCall(mainLogFile)
    let len = mainLogFile->Array.length
    for _ in 0 to len - 1 {
      mainLogFile->Array.pop->ignore
    }
  }

  let checkForPriorityEvents = (arrayOfLogs: array<logFile>) => {
    let priorityEventNames = [
      APP_RENDERED,
      ORCA_ELEMENTS_CALLED,
      PAYMENT_DATA_FILLED,
      PAYMENT_ATTEMPT,
      CONFIRM_CALL,
      AUTHENTICATION_CALL,
      THREE_DS_METHOD_RESULT,
      SDK_CRASH,
      REDIRECTING_USER,
      DISPLAY_BANK_TRANSFER_INFO_PAGE,
      DISPLAY_QR_CODE_INFO_PAGE,
      DISPLAY_VOUCHER,
      LOADER_CHANGED,
      PAYMENT_METHODS_CALL,
      PAYMENT_METHOD_CHANGED,
      SESSIONS_CALL,
      RETRIEVE_CALL,
      DISPLAY_THREE_DS_SDK,
      APPLE_PAY_FLOW,
      PLAID_SDK,
    ]
    arrayOfLogs
    ->Array.find(log => {
      [ERROR, DEBUG]->Array.includes(log.logType) ||
        (priorityEventNames->Array.includes(log.eventName) && log.firstEvent)
    })
    ->Option.isSome || arrayOfLogs->Array.length > 8
  }

  let checkLogSizeAndSendData = () => {
    switch timeOut.contents {
    | Some(val) => {
        clearTimeout(val)
        timeOut := Some(setTimeout(() => sendLogs(), 20000))
      }
    | None => timeOut := Some(setTimeout(() => sendLogs(), 20000))
    }

    if mainLogFile->checkForPriorityEvents {
      sendLogs()
    }
  }

  let calculateLatencyHook = (~eventName, ~apiLogType=Method) => {
    let currentTimestamp = Date.now()
    let latency = switch eventName {
    | PAYMENT_ATTEMPT => {
        let appRenderedTimestamp = events.contents->Dict.get(APP_RENDERED->eventNameToStrMapper)
        switch appRenderedTimestamp {
        | Some(float) => currentTimestamp -. float
        | _ => 0.
        }
      }
    | _ => {
        let logRequestTimestamp =
          events.contents->Dict.get(eventName->eventNameToStrMapper ++ "_INIT")
        switch (logRequestTimestamp, apiLogType) {
        | (Some(_), Request) => 0.
        | (Some(float), _) => currentTimestamp -. float
        | _ => 0.
        }
      }
    }
    latency > 0. ? latency->Float.toString : ""
  }

  let checkAndPushMissedEvents = (eventName, paymentMethod) => {
    switch eventName {
    | PAYMENT_ATTEMPT => {
        let paymentMethodChangedEventStr = PAYMENT_METHOD_CHANGED->eventNameToStrMapper
        let paymentDataFilledEventStr = PAYMENT_DATA_FILLED->eventNameToStrMapper
        let localTimestamp = Date.now()->Float.toString
        let localTimestampFloat = localTimestamp->Float.fromString->Option.getOr(Date.now())
        let paymentMethodChangedEvent =
          events.contents->Dict.get(paymentMethodChangedEventStr)->Option.isNone
        let paymentDataFilledEvent =
          events.contents->Dict.get(paymentDataFilledEventStr)->Option.isNone
        if paymentMethodChangedEvent {
          {
            logType: INFO,
            timestamp: localTimestamp,
            sessionId: sessionId.contents,
            source: sourceString,
            version: GlobalVars.repoVersion,
            value: "",
            internalMetadata: "",
            category: USER_EVENT,
            paymentId: clientSecret.contents->getPaymentId,
            merchantId: merchantId.contents,
            browserName: arrayOfNameAndVersion->Array.get(0)->Option.getOr("Others"),
            browserVersion: arrayOfNameAndVersion->Array.get(1)->Option.getOr("0"),
            platform: Window.Navigator.platform,
            userAgent: Window.Navigator.userAgent,
            appId: "",
            eventName: PAYMENT_METHOD_CHANGED,
            latency: "",
            paymentMethod,
            firstEvent: true,
            metadata: metadata.contents,
            ephemeralKey: ephemeralKey.contents,
          }
          ->conditionalLogPush
          ->ignore
          events.contents->Dict.set(paymentMethodChangedEventStr, localTimestampFloat)
        }
        if paymentDataFilledEvent {
          {
            logType: INFO,
            timestamp: localTimestamp,
            sessionId: sessionId.contents,
            source: sourceString,
            version: GlobalVars.repoVersion,
            value: "",
            internalMetadata: "",
            category: USER_EVENT,
            paymentId: clientSecret.contents->getPaymentId,
            merchantId: merchantId.contents,
            browserName: arrayOfNameAndVersion->Array.get(0)->Option.getOr("Others"),
            browserVersion: arrayOfNameAndVersion->Array.get(1)->Option.getOr("0"),
            platform: Window.Navigator.platform,
            userAgent: Window.Navigator.userAgent,
            appId: "",
            eventName: PAYMENT_DATA_FILLED,
            latency: "",
            paymentMethod,
            firstEvent: true,
            metadata: metadata.contents,
            ephemeralKey: ephemeralKey.contents,
          }
          ->conditionalLogPush
          ->ignore
          events.contents->Dict.set(paymentDataFilledEventStr, localTimestampFloat)
        }
      }
    | _ => ()
    }
  }

  let setLogInfo = (
    ~value,
    ~internalMetadata="",
    ~eventName,
    ~timestamp=?,
    ~latency=?,
    ~logType=INFO,
    ~logCategory=USER_EVENT,
    ~paymentMethod="",
  ) => {
    checkAndPushMissedEvents(eventName, paymentMethod)
    let eventNameStr = eventName->eventNameToStrMapper
    let firstEvent = events.contents->Dict.get(eventNameStr)->Option.isNone
    let latency = switch latency {
    | Some(lat) => lat->Float.toString
    | None => calculateLatencyHook(~eventName)
    }
    let localTimestamp = timestamp->Option.getOr(Date.now()->Float.toString)
    let localTimestampFloat = localTimestamp->Float.fromString->Option.getOr(Date.now())
    {
      logType,
      timestamp: localTimestamp,
      sessionId: sessionId.contents,
      source: sourceString,
      version: GlobalVars.repoVersion,
      value,
      internalMetadata,
      category: logCategory,
      paymentId: clientSecret.contents->getPaymentId,
      merchantId: merchantId.contents,
      browserName: arrayOfNameAndVersion->Array.get(0)->Option.getOr("Others"),
      browserVersion: arrayOfNameAndVersion->Array.get(1)->Option.getOr("0"),
      platform: Window.Navigator.platform,
      userAgent: Window.Navigator.userAgent,
      appId: "",
      eventName,
      latency,
      paymentMethod,
      firstEvent,
      metadata: metadata.contents,
      ephemeralKey: ephemeralKey.contents,
    }
    ->conditionalLogPush
    ->ignore
    checkLogSizeAndSendData()
    events.contents->Dict.set(eventNameStr, localTimestampFloat)
  }

  let setConfirmPaymentValue = (~paymentType) => {
    [("method", "confirmPayment"->JSON.Encode.string), ("type", paymentType->JSON.Encode.string)]
    ->Dict.fromArray
    ->JSON.Encode.object
  }

  let setLogApi = (
    ~value: setlogApiValueType,
    ~internalMetadata: setlogApiValueType,
    ~eventName,
    ~timestamp=?,
    ~logType=INFO,
    ~logCategory=API,
    ~paymentMethod="",
    ~apiLogType=Request,
    ~isPaymentSession=false,
  ) => {
    let eventNameStr = eventName->eventNameToStrMapper
    let firstEvent = events.contents->Dict.get(eventNameStr)->Option.isNone
    let latency = calculateLatencyHook(~eventName, ~apiLogType)
    let localTimestamp = timestamp->Option.getOr(Date.now()->Float.toString)
    let localTimestampFloat = localTimestamp->Float.fromString->Option.getOr(Date.now())
    {
      logType,
      timestamp: localTimestamp,
      sessionId: sessionId.contents,
      source: isPaymentSession ? getSourceString(Headless) : sourceString,
      version: GlobalVars.repoVersion,
      value: switch value {
      | ArrayType(a) => a->Dict.fromArray->JSON.Encode.object->JSON.stringify
      | StringValue(a) => a
      },
      internalMetadata: switch internalMetadata {
      | ArrayType(a) => a->Dict.fromArray->JSON.Encode.object->JSON.stringify
      | StringValue(a) => a
      },
      category: logCategory,
      paymentId: clientSecret.contents->getPaymentId,
      merchantId: merchantId.contents,
      browserName: arrayOfNameAndVersion->Array.get(0)->Option.getOr("Others"),
      browserVersion: arrayOfNameAndVersion->Array.get(1)->Option.getOr("0"),
      platform: Window.Navigator.platform,
      userAgent: Window.Navigator.userAgent,
      appId: "",
      eventName,
      latency,
      paymentMethod,
      firstEvent,
      metadata: metadata.contents,
      ephemeralKey: ephemeralKey.contents,
    }
    ->conditionalLogPush
    ->ignore
    checkLogSizeAndSendData()
    events.contents->Dict.set(eventNameStr, localTimestampFloat)
  }

  let setLogError = (
    ~value,
    ~internalMetadata="",
    ~eventName,
    ~timestamp=?,
    ~latency=?,
    ~logType=ERROR,
    ~logCategory=USER_ERROR,
    ~paymentMethod="",
  ) => {
    let eventNameStr = eventName->eventNameToStrMapper
    let firstEvent = events.contents->Dict.get(eventNameStr)->Option.isNone
    let latency = switch latency {
    | Some(lat) => lat->Float.toString
    | None => calculateLatencyHook(~eventName)
    }
    let localTimestamp = timestamp->Option.getOr(Date.now()->Float.toString)
    let localTimestampFloat = localTimestamp->Float.fromString->Option.getOr(Date.now())
    {
      logType,
      timestamp: localTimestamp,
      sessionId: sessionId.contents,
      source: sourceString,
      version: GlobalVars.repoVersion,
      value,
      internalMetadata,
      category: logCategory,
      paymentId: clientSecret.contents->getPaymentId,
      merchantId: merchantId.contents,
      browserName: arrayOfNameAndVersion->Array.get(0)->Option.getOr("Others"),
      browserVersion: arrayOfNameAndVersion->Array.get(1)->Option.getOr("0"),
      platform: Window.Navigator.platform,
      userAgent: Window.Navigator.userAgent,
      appId: "",
      eventName,
      latency,
      paymentMethod,
      firstEvent,
      metadata: metadata.contents,
      ephemeralKey: ephemeralKey.contents,
    }
    ->conditionalLogPush
    ->ignore
    checkLogSizeAndSendData()
    events.contents->Dict.set(eventNameStr, localTimestampFloat)
  }

  let setLogInitiated = () => {
    let eventName: eventName = LOG_INITIATED
    let eventNameStr = eventName->eventNameToStrMapper
    let firstEvent = events.contents->Dict.get(eventNameStr)->Option.isNone
    let latency = calculateLatencyHook(~eventName)
    {
      logType: INFO,
      eventName,
      timestamp: Date.now()->Float.toString,
      sessionId: sessionId.contents,
      source: sourceString,
      version: GlobalVars.repoVersion,
      category: USER_EVENT,
      value: "log initiated",
      internalMetadata: "",
      paymentId: clientSecret.contents->getPaymentId,
      merchantId: merchantId.contents,
      browserName: arrayOfNameAndVersion->Array.get(0)->Option.getOr("Others"),
      browserVersion: arrayOfNameAndVersion->Array.get(1)->Option.getOr("0"),
      platform: Window.Navigator.platform,
      userAgent: Window.Navigator.userAgent,
      appId: "",
      latency,
      paymentMethod: "",
      firstEvent,
      metadata: metadata.contents,
      ephemeralKey: ephemeralKey.contents,
    }
    ->conditionalLogPush
    ->ignore
    checkLogSizeAndSendData()
    events.contents->Dict.set(eventNameStr, Date.now())
  }

  let handleBeforeUnload = _event => {
    //event->Window.preventDefault()
    sendLogs()
    switch timeOut.contents {
    | Some(val) => clearTimeout(val)
    | None => ()
    }
  }
  Window.addEventListener("beforeunload", handleBeforeUnload)

  {
    setLogInfo,
    setLogInitiated,
    setConfirmPaymentValue,
    sendLogs,
    setSessionId,
    setClientSecret,
    setMerchantId,
    setMetadata,
    setLogApi,
    setLogError,
    setSource,
    setEphemeralKey,
  }
}
