Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB3BC25B0D
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Aug 2022 16:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244081AbiHHQie (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Aug 2022 12:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244063AbiHHQia (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Aug 2022 12:38:30 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EE8E01E
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2022 09:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659976708; x=1691512708;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vtIya//EyPp/giBCEYOKe/StXV/DsDlZ1jIHstkQuH0=;
  b=Fy13HIThl7wgNJLeUZZxX5r6Q5qzQVfWS4DqyS0zSZB33aUoQLTYGTyg
   QOwmrgJjPqZ/BzKeTYSgXKruVHkaw78fIQYRQH/BSaI68eTpouzY6gfT4
   Jv2aSY1Na8ej93sExsqqc6OdrP9T61AKxU3VoVEKwhwiiQClOJMG1Fl/+
   eLDH9s7q/A87XG+aEQPyAAn8SKjrTsbnR6ViKdvKk3+yS3uQs9WMMh6pT
   SJsp5xE1e5Y4s/GxOuo0WNlOsRsl1X4QzRbifHYWSlwKuTs7Prgn6GPh7
   ZYfiCFrqw+P4iE+ngJuNGkl0d3cJCQQRxIoYJaKViQ5xVrO8vG4Cz4c6z
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="288202815"
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="288202815"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 09:38:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="730797502"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 08 Aug 2022 09:38:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 09:38:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 09:38:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 8 Aug 2022 09:38:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 8 Aug 2022 09:38:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOox0NXN/IJ5TLQE+gpWxJDIOGIXtNMZ9MFuW8BkNPEw81BVEAB+rTzvlIrRo09zY6aOdPju6h1VhnDjGDOq8la5FiPN41JB5eGTUID1ddQBAh8xf+oTPgRobX6ohmSuGtOkaJfqzWvPgkCT0Gpvt1WEEhoDFxmiZu1K49AJhqbTclpnrib2brjpMaV3mkFUlAopybBqwub+nI4HkN+XaDQ2+S6l1zv9rzejplwy0vYZraneaFyMtAUYTJKq73ysNIHjgxJOmpX0HTVIpReJ/rHpvoKgh1ux+EeIxkoUOMlUcB4wwEU1ChClmc2Et8bnL0TXiaIAIEKtqUdozcffFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtIya//EyPp/giBCEYOKe/StXV/DsDlZ1jIHstkQuH0=;
 b=QhG56PG+wnzqKSimizHroBwiCp2Jqhu731OUnIczQoH8oXXkyxrP8tv8bNZQWhTxvvYDIHShXVU9YZc3bj1Lxm63C/GB4FP0wM217nGNOk8evcDizURnoc4yGPfAv2Plr9+eMpj+OomGDwyhrn1fl/eDzmZQ2WsQb+CRcDAys9HEmm5R38BhUOO2cTiYo+H5TSiTgJ2WKO4LI0IKXSbfVkOuGZ1HS6w4zXrqFM1ko+dVVB+QC6CIyQWgAerELHDD+fae2wrh+ntW5f/uRfb1NlyHBOuSDkeP3bj/eChfFJSP1P7GggLd7nFEUAeYLnJhdPAI8MffUDZ1mdJy741GPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by CY4PR11MB1974.namprd11.prod.outlook.com (2603:10b6:903:126::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 8 Aug
 2022 16:38:18 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::6d2c:6e35:bb16:6cdf]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::6d2c:6e35:bb16:6cdf%9]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 16:38:18 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: RE: [PATCH libmnl v2 2/2] libmnl: add support for signed types
Thread-Topic: [PATCH libmnl v2 2/2] libmnl: add support for signed types
Thread-Index: AQHYqQ58gtU1e0AQu0uFtNlWlf3QRa2lDsyAgAApiWA=
Date:   Mon, 8 Aug 2022 16:38:18 +0000
Message-ID: <PH0PR11MB5095596DD7710EDE54F7C221D6639@PH0PR11MB5095.namprd11.prod.outlook.com>
References: <20220805210040.2827875-1-jacob.e.keller@intel.com>
 <20220805210040.2827875-2-jacob.e.keller@intel.com> <YvEZEcLT5t1SBVcc@salvia>
In-Reply-To: <YvEZEcLT5t1SBVcc@salvia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91d0e35b-9c60-45b4-5ea2-08da795c6658
x-ms-traffictypediagnostic: CY4PR11MB1974:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1hjG9aocVPxtWkVUdKfAuJh2UhdrU4HBG1I/QR9onXzLY1bTHoyw+Dtf0pfMCyFHbQ0FZ3fnYjS8TFeh3UxxGlG/JfnlysC4n9aW5pEm+okXwDi03WwRWs5vYS6pv86mwWq382mh3QM071CPeMb39K7Zduhkmrxch2WE7M7Y+UaVXAvVdF/G/oH/13+ylZzg/ugC9eCzvw8dRUjE4r3Lo00uRSS6cax1QS4CNCcPbQlvBCVWC6NYH/gzuCqeirYUQmQuTbXtEwbCpmQRimjoBgFLperb6PoBlRaE+yCXuHmTffQoxsrSzBVs4//aTU4+sogDbWeNbFweNZJWWYK6kjjDyn/zoOkvOw7EoKLE/e4GjA5+f7W9P4QYEc4NtHdPqOozgDXeW7llGR29NPmgcoT9b59F7XPmuSZ1dkLnu999hsT3bmu2zRAPrp8cGavPip4WtL2bmdu/LR4wRu9wPhwEMOU+07Z4jRvDinfUVDf4xaOuUAz6zEE6436e1txFF5qTSFAX7BKORKtgbtJPq0nKcMhdxJOkrEmyOnMjJ+SlnfUGNSq+GAJp7k91bHd8Sn0jeMJXlrCxqDIt3tdDKLP3U7oTI+4M7JKaxL0FzNBfWsEYH5a4wPWCekimejJ8b/xJzcE+ff9/A94WEflO98jEAQfn8hTP+O/86vUVc4uYGNmfEjd1OlGnKKeuP8stIwIn8JClJbovmEnuO4sUuvzes8vkehCnPG7GTawTh72DfcpFyK+GCpvHXPdT6ToBKy7whRRvY09Wl6LoCu6/BJobuqoqA9mdU2VlNib7bjnKA2UCaYOohgwF5RySIq1y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(366004)(346002)(39860400002)(396003)(66446008)(66476007)(38100700002)(66556008)(122000001)(71200400001)(66946007)(64756008)(478600001)(82960400001)(38070700005)(8676002)(8936002)(55016003)(52536014)(5660300002)(54906003)(316002)(6916009)(86362001)(4326008)(76116006)(33656002)(9686003)(26005)(83380400001)(186003)(6506007)(41300700001)(53546011)(2906002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZERjbUFHWkZOMTliYmFHYVo0RFNsM0NMQ1I2RFd6ODRCUGRNd21OT3hmUU9r?=
 =?utf-8?B?eXhabkVrTW8xVlIyZmVoRlg3SWRqcXNpUWlVT09PajBFMVZNVVE3ZVMyT0Vk?=
 =?utf-8?B?QVd4dUtjaENUeUpqTUR0dkx2aGhpZlRnYk1DOE5ycUlaRWhZU3g5aUt2ZnZM?=
 =?utf-8?B?T1dxVXA4T0creDJBOVRJZWliRE00TzNrMFBsSWlLRWw4cDF5MFArVTdpZ1pI?=
 =?utf-8?B?TEl0K2Vxa1FTMkthY29UcmpUTlpwNmtMRXJkeXlBdzdEMjRTaGtVcU9rNjdn?=
 =?utf-8?B?YVRKU3loZUF1TTRFejNsekJQSTJBTUtIM1loREtweklObTQ0Q05kd3JldzZi?=
 =?utf-8?B?VjdONys2RTZ3eTQ1SmFMaDgxTVhyVkFJa2xDd3hHdGorMUtDUUZxV0dBWndp?=
 =?utf-8?B?TGJoSXNJeTdIZFNxV0lNdkZLY29UOER1MFAvbWpDbllkcUQzQy9kR3huRWxp?=
 =?utf-8?B?Z3BYT3lrSkQ3MEJxSHpTNUZUT2M0YVdRTlN0SUt0anlWWXpVVUpuSFRYaEFi?=
 =?utf-8?B?SVVjYW5MalNkNFE5aEd2R1hUNGVneC80clhrRG51akV1OXF2TDdJNzhCTEpy?=
 =?utf-8?B?UTRYb1ZaU1hhT2RjZ0FqeFRXbkRTZDI4K013ZWVXbFVibW1PRFljcnpnSWVa?=
 =?utf-8?B?ZlhLL0JEODZZRzErWEhDd2ExeVVvS0l0enZaWnJ2T3Qyb21EcWRSZ2JHSm90?=
 =?utf-8?B?dzluU2ZUTkdVVlJueEdCeE4zYWNnQUNVbHJ5SDJVMWdPWGRvL1NqQVI1MEtC?=
 =?utf-8?B?SjRVNEVyRUk3cDE3RGhQcGhYRVpKSExQRXZhS2o2VjJoQ2xvczBtZ0o0SVg3?=
 =?utf-8?B?Zm5yclVlenJxTHBVZGs5Ykp4b1MzdERPa3g0SkIzV1lscEpkREFZUTFTbnAz?=
 =?utf-8?B?MUpENUVtZjZuOXg2YzRvbGUzOUR1eG1LTi9CQkVoYktLVkZiMElqS0tqS2xs?=
 =?utf-8?B?YW5aUG9MQ04vcFVnWUM0Smp2MExHUFR5VEduWEV4SXh3MHh0ZUlLbXFuQU1P?=
 =?utf-8?B?RWlBQWdMSFhhcWY5RnAzVXd1Q1pkaG9jQnhQY2lDM2IvTkpwNUxQYlo0bExQ?=
 =?utf-8?B?VU5zcm0vYnBNNmlKbjYwNXA3RGplSEdvNWVGS2VLZVJvS0pFYTRobHh3L0NW?=
 =?utf-8?B?czlZZmpxWkZNQmFnVnZVaHplQ3BJam9kSlJTVUFBSStKb3E2NG1yeXB1QVVY?=
 =?utf-8?B?YUZEZzJuK3VtRzFYL1VleUxrNjlDMU0vMkxBOTR1MnRBYjAxdVJFQnFYaUFl?=
 =?utf-8?B?WlNiS3p4ZXdxK01RY3A1aW9ubHAwT3lwb0dWTlg0SWJOSXF4dFZyNEk0ajZG?=
 =?utf-8?B?TTJRdDU0UTVRUEMzMDA4Mk1EZVFWRGhwVkIrRFJndzhhYjFvUnNvTFJlSmRX?=
 =?utf-8?B?dEFyRnAweWdkZHdReDZWSzZzbXBMZENTTHhhaVFkYlVYNkg3N2dSZ29PNWRi?=
 =?utf-8?B?UkRTNGVxWXg1a1A5TXRPSGlQSE5IejkzckRuL3Mwek9TcXNEd1p1YnlKVmo1?=
 =?utf-8?B?SE5wdEFzTjNSckMxRUphdDRabDZTWm13YjVCRkJoT25MUm5UOEUrS3VvenhG?=
 =?utf-8?B?SGkyWXNhVzdtaDJuREFBUFBhWEp1NDQwUCs4T2grU1ZjOTVCM1Q3d2QwSHFN?=
 =?utf-8?B?KzNOL1k4SEpweG5Pa29nbGloUlE3TVB0b2xqb2FMWHB6bG9kZFV5TE5JTGl5?=
 =?utf-8?B?QWFtYnNDMUFYS1djU25SNnVSOUNodXNYWEQ5M3ZXOHhyQVp6MEZOeG1NTm9M?=
 =?utf-8?B?ZzhkejJEQjhnRjBtbkVjbWNNVlIyV1JmUUp1d1BlVkhRWm8rOHBPUVRWZTkv?=
 =?utf-8?B?RXRscENoRWJsQ3J1UFpSZUhXemVtNFhva2F0aGdIeW9FSDlhZTZqOHVlMVYy?=
 =?utf-8?B?RGhOcG41L2tjZTVQNElRcDcrdGo3ZVh5NFpKQjdsUnVRNFZMWWI0RXE5VWJz?=
 =?utf-8?B?c1VoM0N2LytiZjFVZzN4YSttbzRvckxkbTAwV2tZeGkrdkF5cjhLaXJEMlE4?=
 =?utf-8?B?Q1krK2lwdzB2dXVBTG56emN2Mk9yOTlzUWJPelE0eEVmb3NObGdMSzBPSzVn?=
 =?utf-8?B?WWJkWUpjMUFGRG1pVDRXYUtiZ3dtZjVSNk9YRkxXcWwzTUNtV1VpbFJHd2ZH?=
 =?utf-8?Q?jHOPheyAc41mPe+Wr9YzLGTiD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d0e35b-9c60-45b4-5ea2-08da795c6658
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 16:38:18.6741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f12gz/K1n/AXgbZEf7PEmN2DJplJnYjZyqWnFtUL2YjKQyADI5S5OrTzqXBE7m6GZJdBW52kV+h1isezH6LTfiamUd+byf4JJEJP4YSKo24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1974
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFibG8gTmVpcmEgQXl1
c28gPHBhYmxvQG5ldGZpbHRlci5vcmc+DQo+IFNlbnQ6IE1vbmRheSwgQXVndXN0IDA4LCAyMDIy
IDc6MDkgQU0NCj4gVG86IEtlbGxlciwgSmFjb2IgRSA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29t
Pg0KPiBDYzogTmV0ZmlsdGVyIERldmVsIDxuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3Jn
PjsgRHVuY2FuIFJvZQ0KPiA8ZHVuY2FuX3JvZUBvcHR1c25ldC5jb20uYXU+DQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0ggbGlibW5sIHYyIDIvMl0gbGlibW5sOiBhZGQgc3VwcG9ydCBmb3Igc2lnbmVk
IHR5cGVzDQo+IA0KPiBIaSwNCj4gDQo+IE9uIEZyaSwgQXVnIDA1LCAyMDIyIGF0IDAyOjAwOjQw
UE0gLTA3MDAsIEphY29iIEtlbGxlciB3cm90ZToNCj4gPiBsaWJtbmwgaGFzIGdldCBhbmQgcHV0
IGZ1bmN0aW9ucyBmb3IgdW5zaWduZWQgaW50ZWdlciB0eXBlcy4gSXQgbGFja3MNCj4gPiBzdXBw
b3J0IGZvciB0aGUgc2lnbmVkIHZhcmlhdGlvbnMuIE9uIHNvbWUgbGV2ZWwgdGhpcyBpcyB0ZWNo
bmljYWxseQ0KPiA+IHN1ZmZpY2llbnQuIEEgdXNlciBjb3VsZCB1c2UgdGhlIHVuc2lnbmVkIHZh
cmlhdGlvbnMgYW5kIHRoZW4gY2FzdCB0byBhDQo+ID4gc2lnbmVkIHZhbHVlIGF0IHVzZS4gSG93
ZXZlciwgdGhpcyBtYWtlcyByZXN1bHRpbmcgY29kZSBpbiB0aGUgYXBwbGljYXRpb24NCj4gPiBt
b3JlIGRpZmZpY3VsdCB0byBmb2xsb3cuIEludHJvZHVjZSBzaWduZWQgdmFyaWF0aW9ucyBvZiB0
aGUgaW50ZWdlciBnZXQNCj4gPiBhbmQgcHV0IGZ1bmN0aW9ucy4NCj4gPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEphY29iIEtlbGxlciA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiA+IC0tLQ0K
PiA+ICBpbmNsdWRlL2xpYm1ubC9saWJtbmwuaCB8ICAxNiArKysrDQo+ID4gIHNyYy9hdHRyLmMg
ICAgICAgICAgICAgIHwgMTk0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAyMDkgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPiA+DQo+IFsuLi5dDQo+ID4gQEAgLTEyNyw2ICsxMzksMTAgQEAgZW51bSBtbmxfYXR0cl9k
YXRhX3R5cGUgew0KPiA+ICAJTU5MX1RZUEVfVTE2LA0KPiA+ICAJTU5MX1RZUEVfVTMyLA0KPiA+
ICAJTU5MX1RZUEVfVTY0LA0KPiA+ICsJTU5MX1RZUEVfUzgsDQo+ID4gKwlNTkxfVFlQRV9TMTYs
DQo+ID4gKwlNTkxfVFlQRV9TMzIsDQo+ID4gKwlNTkxfVFlQRV9TNjQsDQo+IA0KPiBUaGlzIGJy
ZWFrcyBBQkksIHlvdSBoYXZlIHRvIGFkZCBuZXcgdHlwZXMgYXQgdGhlIGVuZCBvZiB0aGUNCj4g
ZW51bWVyYXRpb24uDQo+IA0KDQpPaC4gUmlnaHQuLiBXaWxsIGZpeCBpdC4NCg0KVGhhbmtzLA0K
SmFrZQ0KDQo+ID4gIAlNTkxfVFlQRV9TVFJJTkcsDQo+ID4gIAlNTkxfVFlQRV9GTEFHLA0KPiA+
ICAJTU5MX1RZUEVfTVNFQ1MsDQo+IA0KPiBUaGFua3MuDQo=
