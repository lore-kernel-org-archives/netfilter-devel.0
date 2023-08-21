Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D40EE49A4
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 02:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjHUCUQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Aug 2023 22:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbjHUCUQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Aug 2023 22:20:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B1FAF
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Aug 2023 19:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692584411; x=1724120411;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=k7reiIE2HDXPvp9sS3jSXKngy8Lt+bVpLpQ0EW2CwFo=;
  b=HpDdMmhYaNSKN6CTOrpLPKbA3+j6xUKmG89jleuPP9XH9Vg2cL1FiIJx
   j4qXOzQLDGq53iWWTerZBAzdcDbLj9yT/Iobmj5p716BhY1UODIxqCt33
   Kwxl12+5R74M+R6qaErNzmT3HBnHYPjR0haD5/QpWbhwGI/M9VcwcVpps
   zYGIoSv66gdb2ZKAoDQnUb4aG1F4LTCfaaQOSE45QDdyoEVuEpRHk1Q+s
   GWdvKLFKUQLVuXvE8IN2rXu4dNP/fE0Y+Gu6gBXrKLplQGZknlg16iJ7+
   YYV7BBRxZ/pdtZLkTyI0SvTPX+1cAiuPvzfmWtyZWhWD83iMHSOKi/37k
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10808"; a="377214110"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="377214110"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2023 19:20:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10808"; a="909523426"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="909523426"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 20 Aug 2023 19:20:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 20 Aug 2023 19:20:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 20 Aug 2023 19:20:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 20 Aug 2023 19:20:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 20 Aug 2023 19:20:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9gMZjPjaL/9YHehckgyhqFy8JiGvCvMhDFkgXTPXx4wSsH7yXg2yGWvzSUdE+KLoTb+ExbO74v1elg6OBoOLOcYhIoUBVqlK/3lgBHq9Rl63sZhgsSBaX5JqVnQcPKByJb2i5eaWaRLHr8h5Idfz4yrguJq92+hZtBlyLnTmECGnNLwsdv77FCbd8ak/4Op8O9VUYgbcQQheE61xFcMZN00DICh34jnPnVo/WcufnIu3cSLJedT6ZN19CyiK8zY9SNB2k3XByO9Mqd+MIhsIMoJv5VDATlY+tcuKBHvi3Ghj9GzKGufgaAnH1FJiv6Zd/mKQtsuQmmq1ZzCBlgkZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k7reiIE2HDXPvp9sS3jSXKngy8Lt+bVpLpQ0EW2CwFo=;
 b=PkKibMbgkso8mMXfJxlRsENTrCPe0nu5uQq91pXgaajRQ8U31PrRTd3vdu8nd7t3SMrmW7H/EFx0I6/m2V4n5dF+6SdC+lN9Hnbr0nSq3UYU6aSBYZG3BmvJ7H2+SemuHGJ8js3f5qb3rvDOd91klj/YfWTWZXglNxfHtskcpBl7J9GnUuen6udOdmA3ON87cOUuHTRbTgH7NmZPYfGoRvMShCoH4Q5tg8QwBqyN2zuXZgj6xbNWySjPuQezJIHAjzgP51AJOHRcJed3RXd9YfJcfTEZcy0/Z1uA0aDbCF6cwGtgvTFdxxzFNFJJzihi2/RByeNSs6+XeFmJ70wjlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by PH0PR11MB5807.namprd11.prod.outlook.com (2603:10b6:510:140::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20; Mon, 21 Aug
 2023 02:20:07 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::d35:d16b:4ee3:77e5]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::d35:d16b:4ee3:77e5%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 02:20:07 +0000
From:   "Liu, Yujie" <yujie.liu@intel.com>
To:     "pablo@netfilter.org" <pablo@netfilter.org>
CC:     "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>, lkp <lkp@intel.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: GC transaction race with abort
 path
Thread-Topic: [PATCH nf] netfilter: nf_tables: GC transaction race with abort
 path
Thread-Index: AQHZ0aiTmBdDuBA3NEav2Vqx2S8KSa/vxCKAgARDMYA=
Date:   Mon, 21 Aug 2023 02:20:07 +0000
Message-ID: <c6f61377bad2e555777822d3d7a9b22851912d2e.camel@intel.com>
References: <20230817231352.8412-1-pablo@netfilter.org>
         <202308181545.lZbeE7Lm-lkp@intel.com> <ZN81Vz8/yIBm201d@calendula>
In-Reply-To: <ZN81Vz8/yIBm201d@calendula>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR11MB6392:EE_|PH0PR11MB5807:EE_
x-ms-office365-filtering-correlation-id: cac98c74-007c-4f45-da81-08dba1ed2318
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sZqQxv0qZLcouRpwnbs500eWFUXzsIiNO2DTLyXKIBhWYcwR7VHyVjDHWDmx9RBw2BTVZT5FiTpOvS1kS2dnNgAphd7iYjGcJtECSzAKPNQQQDlzmNDgXUrnXUsBgCJyMIMUtnI9l+GTnLzrpsfKYo6b6Ew155Afe5Z6l9G9cU3ApNlSN5oeWClKzXdZyqFhh4lPOnvcWLne2tTnDBwqfGgkNGupnL2CPCNTixwFO9h484V26/Qn5lWJZJbVjIoHRp+mvD6ouu8X53FVjB1yPIF1UIEJL+moZQ6eFOJQlcxDFytBh9kqntuanG6SLEK3vd+XwAVvt52eUumxBIuFWLl30C9d0cAIMAsQwuP4TyZ26P9XG03dmSKqnPSFWF0yNZGzPyFhKMTu7Xtausx0Mve0+3uG4OrKHgs8bk5vKul8XClxjJMeJ1cJWD5n7fKaYNyOOx9qHLpv8ck4h5nXYTnDvgpW/rxLXp85ffUMXc07gLHr0Bf0NwxGGXbWoKjpacmUdqUSOU4Qb4gzcCwE0DkVsgTpFvZMtha4eBWgDTvPHn8ZKtHCRsGOZBigsTrUenB1l8YUimEjCsW4of5udO2UpILluKQ6v/uF7qbgl4ZpaMlTIhDRr7asFuF1nHDGcFz8b1YULw8x3EbBNG09pw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(346002)(366004)(39860400002)(186009)(1800799009)(451199024)(66446008)(66476007)(64756008)(6916009)(54906003)(76116006)(66556008)(66946007)(316002)(6512007)(82960400001)(91956017)(8676002)(8936002)(2616005)(4326008)(41300700001)(36756003)(122000001)(478600001)(966005)(71200400001)(38070700005)(38100700002)(6506007)(6486002)(4744005)(2906002)(83380400001)(86362001)(5660300002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGZsT1R0a1pIQnEyOVRWVDcraWhWVS8wdWJNSGxuQjRpazZhaENhelhWeVhU?=
 =?utf-8?B?TU5aWjBrbzNwY2VVd2Q3Mk5GelBjMmo4YXI1bVY4b0hjckhHNGJIUXcrY203?=
 =?utf-8?B?d05ueGZSUWFvbkRQUG9Od0c0ajBteHNiV29acU5zRWN4cXR6SE41UTI4UWxa?=
 =?utf-8?B?WW90eW9ZQzdseUZBUGVPaW96Qyt0K2ZLTjdneW5ZbVp2N0IveTF3VWRSbTBY?=
 =?utf-8?B?b3hGL0RpTWdmeHdYMUVacytUaXVKZHUxdWFGMHpQY1R0Y1BySGVNQWxtUE13?=
 =?utf-8?B?NExXb2tWdEM5bm9FdjdnK2MzUlZ3UFVjaG5BaS9WWWVLcDdRSGdya0RKSW1p?=
 =?utf-8?B?d09TRjZBc2UxN0JJRGZkVXR5MXhOUllpM0R3cXdIOTI1NDg0VmFpRVRPYkxr?=
 =?utf-8?B?T2xkZm1uaUhsbm5pSkZ0QVhaenpwbmM0SmdDU2VpZVNkZ0pOVGs5MDk5bXBF?=
 =?utf-8?B?RzVGdXlYUVU2dlRqVjRORnduR0FobnhrdEQ0T0FIRWNuU0VUWkZQdmh1dFVP?=
 =?utf-8?B?cWluZ3R4bGFFSGZLem16eTZrWXVDUlBZYnlPRkFTM2RUWnJXc20va3RoejFM?=
 =?utf-8?B?MVVhaysyNC8zNjkyTXJhdnJidmJDYzhpMk41OVdsWkdRNk5yVG1lWWhyT3Bl?=
 =?utf-8?B?UmZlTkkzdktWdi8vRWdGeFg0OEl0bHk5WFZ4Qm9Pb0hETU5weTNJWWVDVXg3?=
 =?utf-8?B?c290ZVlFMlpsVGczZ0JUUFMxKzV6cUJyZ3A0TjJFZWw4WWxJS0VsMXB4T2w1?=
 =?utf-8?B?UUFWWEtlQndBTUdzYUNjTHRHbjQvZkJjSWY4d3hBRmhkMTlNZFhBMTF3OVZH?=
 =?utf-8?B?TXA0azhaMmdGU29BeUxvK3RhQlNtc3NJWXd3OElUamJMcm5HZFhscFQ5ejFH?=
 =?utf-8?B?bmg0UHVOY09xTXpjZ2R0MDR5dHlrTmZLUGh2QS92K1dud1QvdWZsWEhlNDdK?=
 =?utf-8?B?azdjQkt0aFk5TDNwc1M1b25oNzljb2V4ZytkYlVlNE9WNkZJUmhieFY0WVF2?=
 =?utf-8?B?anIxVkt5SlQ4SndhSXBqaVZNbDhKbDR4dVkreG5tY1ljd0VVMnRhR2hhWmZI?=
 =?utf-8?B?OU5HVXRKMVZYOUQ3QnhvakNJeGZUZXhqZjhlUG56dG5Lb0tHWkFWV2VZd0sx?=
 =?utf-8?B?VlhKZmF0THRsbnlyRTRkOFh5clR1dktYVWZvYlF5WVRtdHYwQXYwdmFxVDhK?=
 =?utf-8?B?SWswdGdIZWI1b3k0OFdYdGkrc0dXRngwZUJENlplcDQ5YUpMUkNld1pIYkNw?=
 =?utf-8?B?Z3NEb09NNm44M2N4anhKN3d6WkdkS0EydVdqY3JLbDY3MVFkV09oQW5XTjNN?=
 =?utf-8?B?bjFya1B4clFnU1ROZHFPdWp2NUpMWGJkTUlFenIvR3FMTzZPZFZyT3lGNU9J?=
 =?utf-8?B?YzBVNWJhZjNSTC9JcTNZdWplaFRHQXF5eDZmUC9uQnpsWG5PYU9xTWxSaEZO?=
 =?utf-8?B?NWJ4eWpwL1E1SDJFd0M3SGZqN0hrMHpRdEFZTVQ1VHNoZWx1SUI2RHE1NFpG?=
 =?utf-8?B?RXpUbHJNcDdZNW1kSC9uTTVxSGhETThvRFBMTG8yVGpVTG5lM25kK0ZEelNB?=
 =?utf-8?B?c3h5UjNpU2ZySHMreXNxV1JySXdaTWI1TG1kZGFJOFRSeEp4aXJvaUZEcW1y?=
 =?utf-8?B?cGhSQkFHZ2JseWRmSUtOM3F2WGNrS05Ca05HYnZrVXhZdUhOZUN0OThZd1lL?=
 =?utf-8?B?b0tIRGpkTVBtejZCTmNJMEFHbE5JN3J0dVY5NEx2ZDhUaWJ5T2lkTS9WcmZv?=
 =?utf-8?B?K2x3OFdjV3lPMVovWngvajFaSTR6dEJXUnZqVWFzOGJaclZCQmJPcENFak9D?=
 =?utf-8?B?bzcveUpaNHkrdk92SVNZRGw2Vkl6SnFzZXhJVEViQm9OREtSMEVxT3VLc2dv?=
 =?utf-8?B?cFVmQ1BqU1BlWGluVmU2YjNUL1hsajBJLzlCc3dkVmQrQ0RzT205Mks3a1BG?=
 =?utf-8?B?aVp5ZHd1OTRqRWppL3Q2YXF4QUlYYU9rUXFSazdOT1hHbGkxbHVXd3R3NGJ6?=
 =?utf-8?B?UnNUOUhGYXk1OWtobTNYTFNpOXA2M2txSnV3SDdQQ0hvdkFyYWxCZGdUL0pT?=
 =?utf-8?B?MXFjVmM4NzQzeW1WZGNudURaWWVsMDFESERLMmdrbmVJV29VYnljanUweGVQ?=
 =?utf-8?Q?jUUfP3l5X+/gQti//LeRGr2fd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1BC36ADEE5CFA48B74F600E547A864D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac98c74-007c-4f45-da81-08dba1ed2318
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2023 02:20:07.0935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3z2iRh6WBM2OpwiBW8jXhIQP/yZNr6jDCTDZY8ZPxyy+FYBQ4lRahGuzXK5aEO+reKZXoJZni1YrEqviSXpodg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5807
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

T24gRnJpLCAyMDIzLTA4LTE4IGF0IDExOjA5ICswMjAwLCBQYWJsbyBOZWlyYSBBeXVzbyB3cm90
ZToNCj4gT24gRnJpLCBBdWcgMTgsIDIwMjMgYXQgMDM6NDg6NDhQTSArMDgwMCwga2VybmVsIHRl
c3Qgcm9ib3Qgd3JvdGU6DQo+ID4gSGkgUGFibG8sDQo+ID4gDQo+ID4ga2VybmVsIHRlc3Qgcm9i
b3Qgbm90aWNlZCB0aGUgZm9sbG93aW5nIGJ1aWxkIGVycm9yczoNCj4gPiANCj4gPiBbYXV0byBi
dWlsZCB0ZXN0IEVSUk9SIG9uIG5mL21hc3Rlcl0NCj4gPiANCj4gPiB1cmw6wqDCoMKgDQo+ID4g
aHR0cHM6Ly9naXRodWIuY29tL2ludGVsLWxhYi1sa3AvbGludXgvY29tbWl0cy9QYWJsby1OZWly
YS1BeXVzby9uZXRmaWx0ZXItbmZfdGFibGVzLUdDLXRyYW5zYWN0aW9uLXJhY2Utd2l0aC1hYm9y
dC1wYXRoLzIwMjMwODE4LTA3MTU0NQ0KPiA+IGJhc2U6wqDCoA0KPiA+IGh0dHBzOi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3BhYmxvL25mLmdpdMKgbWFzdGVyDQo+
IA0KPiBXcm9uZyB0cmVlLCB3ZSBtb3ZlZCB0bzoNCj4gDQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L25ldGZpbHRlci9uZi5naXTCoG1haW4NCg0KVGhh
bmtzIGZvciB0aGUgaW5mbyBhbmQgc29ycnkgZm9yIHRoZSB3cm9uZyByZXBvcnQuIFdlJ3ZlIGNv
bmZpZ3VyZWQNCnRoZSBib3QgdG8gdGVzdCBuZXRmaWx0ZXIgcGF0Y2hlcyBhZ2FpbnN0IHRoZSBu
ZXcgdHJlZS4NCg0KLS0NCkJlc3QgUmVnYXJkcywNCll1amllDQo=
