Return-Path: <SRS0=4QBM=ZU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0D2C43215
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 11:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F4DA21787
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 11:58:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="cbfy6yL2";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="tXsDW4Dk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfK1L6b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 06:58:31 -0500
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:4510 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfK1L6a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 06:58:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=8450; q=dns/txt; s=iport;
  t=1574942309; x=1576151909;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZvYsBtfAoJEhx0PtIzIMpLEA4IK3DhYR6UDXgnyDQi0=;
  b=cbfy6yL2GUaCGdRfqyyWZyoYsBW9axCaX9KrLTkJpRivuu2y/SC0beEI
   sDBMr+TDoU7Nq+GvXSn5edvXF4LDBLy5v3NRcZry+Ocb6aW5mfmkeWUdc
   s1M7hAcGOA6JLCXYkbErJ5Mw1bOeciUP3njHtrfyH35tNFLczewdDRwsz
   c=;
IronPort-PHdr: =?us-ascii?q?9a23=3AFaMkkB/SqxmjHf9uRHGN82YQeigqvan1NQcJ65?=
 =?us-ascii?q?0hzqhDabmn44+8ZR7E/fs4iljPUM2b8P9Ch+fM+4HYEW0bqdfk0jgZdYBUER?=
 =?us-ascii?q?oMiMEYhQslVdWPBF/lIeTpRyc7B89FElRi+iLzPA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CAAAAEtt9d/5BdJa1mGQEBAQEBAQE?=
 =?us-ascii?q?BAQEBAQEBAQEBEQEBAQEBAQEBAQEBgX6BSyknBWxYIAQLKgqEIYNGA4psgl+?=
 =?us-ascii?q?JW44pglIDVAkBAQEMAQElCAIBAYRAAheBbSQ4EwIDDQEBBAEBAQIBBQRthTc?=
 =?us-ascii?q?MhVIBAQEBAgESEREMAQE3AQ8CAQgOCgICJgICAh8RFRACBA4FIoMAAYJGAw4?=
 =?us-ascii?q?gAQIMpyACgTiIYHWBMoJ+AQEFhR4NC4IXAwaBDiiFG4Z7GoFBP4E4IIIeLj6?=
 =?us-ascii?q?CG0kCgWMXgnkygiyNKyyCCjmPFY5RQgqCLoceiiCEGxuCQYdtizeEPpAMhnq?=
 =?us-ascii?q?CFI9HAgQCBAUCDgEBBYFpIoFYcBU7KgGCQVARFIpsgScBBwKCQopTdIEoj0c?=
 =?us-ascii?q?BgQ8BAQ?=
X-IronPort-AV: E=Sophos;i="5.69,253,1571702400"; 
   d="scan'208";a="659425003"
Received: from rcdn-core-8.cisco.com ([173.37.93.144])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 28 Nov 2019 11:58:26 +0000
Received: from XCH-ALN-003.cisco.com (xch-aln-003.cisco.com [173.36.7.13])
        by rcdn-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id xASBwQXM001945
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 28 Nov 2019 11:58:26 GMT
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by XCH-ALN-003.cisco.com
 (173.36.7.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Nov
 2019 05:58:25 -0600
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-rcd-002.cisco.com
 (173.37.227.247) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Nov
 2019 05:58:24 -0600
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 28 Nov 2019 06:58:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMboM5BIWBwKx/RT+7Up45uIX4T92g8ioP/0rjT762MQ1U51dt/MBT4qmRKudFsj1gwnMzZ/q+h3JMXpf5WvF0jOQi8JPpEzLocmDakd82fk/KEsYbcSVvig4ioC/tNtL2/BJp952Ep5fAsPOWcYHSqq4gKI6zzTA261YfGotdxH5dJobgPARpDxmMAthUnLrS+IcVRbScJizX+NDKrsyz/Xi83Go28mpTWky2QaUSGJfHcmcOSXV0i1vpoNhoQ5FMewULaVB8rrSw/7JXz4EHvZkU81ZegvAcaumHOAuYo9oXbOpkCndTI37vq9G+jg02zxvyqOrTBhEtiYBmjwXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZvYsBtfAoJEhx0PtIzIMpLEA4IK3DhYR6UDXgnyDQi0=;
 b=Pb7eqbuhncXbV3v54yUdVDcT5Vs2apbdEWF9B7L6uIOrBXvK69/E7o5tCa6CP/qXEd75KP8DnioIf/magX1HIn5mdYX3NJGbbujzU8RskAnxyeBkO350hQKUgyC89QdvnfMh+4W6rupj4YaT2k4Nssi82c0cTXeAK+t+EblHvVGjJCBI8VQAAJJrgrI+f9707PMRptbQTLInog7vT/H+Qca/WlIbCf+3hE38sxmaTm4FmtxULhscd8VWgCt4VBmdGI9kZn0FuVkObDkZyI0cD0yHsSshEoLh5Rm8gnArP2fNvmQesDCi+tHK4foAbgch7DBZdZToyrvdklb5h4Rv8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZvYsBtfAoJEhx0PtIzIMpLEA4IK3DhYR6UDXgnyDQi0=;
 b=tXsDW4DkqyszE3K4LbFRa+eWLRDMITN6AxhCLTve1giOLss8tACcw2zcp1ImDqg6sgoUPAcnCOxlUJhTblfd8pRBkhyaJqTocK9vmAYEmcAm3fpPw721H/ILKcFVcFUSsbEXUALvc/GeGkByGFufR+Wcr9shQ57Hryk/+0Z8LKs=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB3328.namprd11.prod.outlook.com (52.135.111.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Thu, 28 Nov 2019 11:58:23 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d%7]) with mapi id 15.20.2474.023; Thu, 28 Nov 2019
 11:58:22 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Laura Garcia <nevola@gmail.com>
CC:     Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLts6edYHQA///QMACAAGcLAP//rq8AgABU1YD//91EAAAL5rgA///LmgCAAStKAP//9huAgABc5QD//7OUAIAAXK0A//+4hIAAC5GiAAAGSjgAABrQOIAABJkwgA==
Date:   Thu, 28 Nov 2019 11:58:22 +0000
Message-ID: <17B23B3C-DAC4-433D-802F-F03B81F7B405@cisco.com>
References: <20191126155125.GD8016@orbyte.nwl.cc>
 <0A92D5EA-B158-4C7A-B85C-1692AE7C828B@cisco.com>
 <20191126192752.GE8016@orbyte.nwl.cc>
 <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
 <3a457e5b-be8f-e99d-fb0d-4826a15a4a55@netfilter.org>
 <89C24159-37F8-4D2F-B391-8A1D6AE403E7@cisco.com>
 <20191127150836.GJ8016@orbyte.nwl.cc>
 <3AE9B74A-37FB-4CDA-86FB-143F506D6C77@cisco.com>
 <20191127160646.GK8016@orbyte.nwl.cc>
 <7C2EF59A-57A3-4E55-92EB-7D64BC0A8417@cisco.com>
 <20191127172210.GM8016@orbyte.nwl.cc>
 <739A821F-2645-41B2-AADA-AA6C34A17335@cisco.com>
 <CAF90-WiPoqEWn45taW0WqSMp5cW75VBJyVN9rn13jd8d_Mys-A@mail.gmail.com>
In-Reply-To: <CAF90-WiPoqEWn45taW0WqSMp5cW75VBJyVN9rn13jd8d_Mys-A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.77]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 950894ff-2e1c-4a0d-1934-08d773fa44c0
x-ms-traffictypediagnostic: SN6PR11MB3328:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <SN6PR11MB332848490DECD1E354F11D86C4470@SN6PR11MB3328.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(43544003)(199004)(189003)(6436002)(66066001)(446003)(8936002)(2906002)(66476007)(64756008)(6306002)(91956017)(66556008)(186003)(58126008)(6486002)(4001150100001)(8676002)(6512007)(71190400001)(71200400001)(76116006)(4326008)(229853002)(66946007)(6116002)(25786009)(3846002)(6916009)(102836004)(53546011)(6506007)(36756003)(11346002)(2616005)(7736002)(26005)(5660300002)(54906003)(14444005)(81156014)(33656002)(81166006)(256004)(478600001)(14454004)(305945005)(1411001)(76176011)(86362001)(316002)(966005)(99286004)(6246003)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3328;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yHkdf7nuy41EsM+cxfHb+8FQ+b/Yeuh3EFk+TJBV7t8ktGPtD6vSGLXMmaAudqC5MJ4TVppjIkVrWKlaA03e/Cw8oel3V3CE2EB1FgRp7m8tvq+pT9ryTfRTdYkZUnKW9y1Ny7E2oSJlzsieAA3NsCk+WXmUPJ9mKnCs7B1imvmzQC+mw7ZUaHLk9V5KG9eGkSabLoG+Cyqbt8/jLicscCVMwjbwAJV3KObQpLYr5agRwjpSqNSkiG5zvvIdr6wNCEUVerdOuZwgbH1/claccvwk/pF3ygL082FBRaDosuH01kqHnI2DEy5V4d2I0xT+MdNN/rtqwmFDvAT7r8+TKyS9MFqfxmFXehJwUgQoWNp79zdxFBiabhX8E8fcZWE2zkAIw+5L17aP7mmssc3xtcY2ZvUOdFWbGIrBVmVZsr07/CMg3OOJ+dbv5W4401mZQ25TsIpUDrRzGwtINVJmdYGJiAE9mtb0axRc+SFWbJk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D31C74D0EF229E4A8F3769381E545E88@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 950894ff-2e1c-4a0d-1934-08d773fa44c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 11:58:22.5824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SsfmtlyTWsrzFcS4Hf4uuoL+EljQ8YTXUfS42NTj+7segnbx3MZmQaL3r3ofyekjNWmdNBK3FWWpy2535DRnFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3328
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.13, xch-aln-003.cisco.com
X-Outbound-Node: rcdn-core-8.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8gTGF1cmEsDQoNClRoYW5rIHlvdSBmb3IgeW91ciBjb21tZW50cyBhbmQgbGluay4gTWF5
YmUgSSBoYXZlIG5vdCByZWFjaCB0aGF0IHBvaW50LCBidXQgSSBkbyBub3Qgc2VlIGNvbXBsZXhp
dHkgaW4gcnVsZXMgcmVtb3ZhbC4gTWF5YmUgaXQgaXMgYmVjYXVzZSBpbiBjYXNlIG9mIGpzb24s
IHJ1bGUncyBoYW5kbGUgaGFzIG5vdCBiZWVuIHJlcG9ydGVkIGJhY2sgdG8gdGhlIGNhbGxlcj8g
SW4gbXkgY2FzZSBzaW5jZSBhIHJ1bGUgZ2V0cyBjcmVhdGVkIGluZGl2aWR1YWxseSBhbmQgZGly
ZWN0bHksIEkgZ2V0IGJhY2sgdWludDY0IG9mIHJ1bGUgaGFuZGxlIHdoaWNoIGNhbiBiZSBlYXNp
bHkgYXNzb2NpYXRlZCB3aXRoIGEgc2VydmljZSBvciBlbmRwb2ludCwgc2FtZSBmb3Igc2V0L21h
cC92bWFwLiBBbnkgZnVydGhlciBjaGFuZ2VzIHdpdGggc2VydmljZSBsaWtlIHJlbW92YWwvKGFk
ZCBkZWxldGUpIGVuZHBvaW50cywgdGhlIHJ1bGUgaGFuZGxlIG9yIG1heWJlIGhhbmRsZXMgd2ls
bCBiZSBhdmFpbGFibGUuDQoNCkkgZG8gbm90IGhhdmUgY29kZSB5ZXQgcmVhZHkgZm9yIHRoaXMg
cGFydCwgYnV0IEkgaGF2ZSBkb25lIGEgcnVsZSB1cGRhdGUgYnkgdXNpbmcgcnVsZSdzIGhhbmRs
ZSBmb3Igb3RoZXIgdGhpbmdzIGFuZCBpdCB3b3JrZWQuIA0KDQpUaGFua3MgYWdhaW4gZm9yIHlv
dXIgZmVlZGJhY2suIE9uY2UgSSBoYXZlIGNvZGUgZm9yIHJ1bGVzIG1hbmFnZW1lbnQsIEkgd2ls
bCBhc2sgeW91IHRvIHJldmlldyBpdCBpZiB5b3UgZG8gbm90IG1pbmQuDQpTZXJndWVpDQoNCu+7
v09uIDIwMTktMTEtMjgsIDQ6MTAgQU0sICJMYXVyYSBHYXJjaWEiIDxuZXZvbGFAZ21haWwuY29t
PiB3cm90ZToNCg0KICAgIEhpLCBJIGd1ZXNzIHdlIGhhZCBhIHZlcnkgc2ltaWxhciBjb252ZXJz
YXRpb24gd2l0aCB0aGUgc2lnLW5ldHdvcmsgZ3V5cy4NCiAgICANCiAgICBQbGVhc2Ugc2VlIGJl
bG93IHNvbWUgY29tbWVudHMuDQogICAgDQogICAgT24gVGh1LCBOb3YgMjgsIDIwMTkgYXQgMjoy
MiBBTSBTZXJndWVpIEJlenZlcmtoaSAoc2JlenZlcmspDQogICAgPHNiZXp2ZXJrQGNpc2NvLmNv
bT4gd3JvdGU6DQogICAgPg0KICAgID4gSGVsbG8gUGhpbCwNCiAgICA+DQogICAgPiBQbGVhc2Ug
c2VlIGJlbG93IHRoZSBsaXN0IG9mIG5mdGFibGVzIHJ1bGVzIHRoZSBjb2RlIGdlbmVyYXRlIHRv
IG1pbWljIG9ubHkgZmlsdGVyIGNoYWluIHBvcnRpb24gb2Yga3ViZSBwcm94eS4NCiAgICA+DQog
ICAgPiBIZXJlIGlzIHRoZSBsb2NhdGlvbiBvZiBjb2RlIHByb2dyYW1taW5nIHRoZXNlIHJ1bGVz
Lg0KICAgID4gaHR0cHM6Ly9naXRodWIuY29tL3NiZXp2ZXJrL25mdGFibGVzbGliLXNhbXBsZXMv
YmxvYi9tYXN0ZXIvcHJveHkvbWltaWMtZmlsdGVyL21pbWljLWZpbHRlci5nbw0KICAgID4NCiAg
ICA+IE1vc3Qgb2YgcnVsZXMgYXJlIHN0YXRpYywgd2lsbCBiZSBwcm9ncmFtZWQgIGp1c3Qgb25j
ZSB3aGVuIHByb3h5IGNvbWVzIHVwLCB3aXRoIHRoZSBleGNlcHRpb24gaXMgMiBydWxlcyBpbiBr
OHMtZmlsdGVyLXNlcnZpY2VzIGNoYWluLiBUaGUgcmVmZXJlbmNlIHRvIHRoZSBsaXN0IG9mIHBv
cnRzIGNhbiBjaGFuZ2UuIElkZWFsbHkgaXQgd291bGQgYmUgZ3JlYXQgdG8gZXhwcmVzcyB0aGVz
ZSB0d28gcnVsZXMgd2l0aCBhIHNpbmdsZSBydWxlIGFuZCBhIHZtYXAsIHdoZXJlIHRoZSBrZXkg
bXVzdCBiZSBzZXJ2aWNlJ3MgaXAgQU5EIHNlcnZpY2UgcG9ydCwgYXMgaXQgaXMgcG9zc2libGUg
dG8gaGF2ZSBhIHNpbmdsZSBzZXJ2aWNlIElQIHRoYXQgY2FuIGJlIGFzc29jaWF0ZWQgd2l0aCBz
ZXZlcmFsIHBvcnRzIGFuZCBzb21lIG9mIHRoZXNlIHBvcnRzIG1pZ2h0IGhhdmUgYW4gZW5kcG9p
bnQgYW5kIHNvbWUgZG8gbm90LiBTbyBmYXIgSSBjb3VsZCBub3QgZmlndXJlIGl0IG91dC4gQXBw
cmVjaWF0ZSB5b3VyIHRob3VnaHQvc3VnZ2VzdGlvbnMvY3JpdGljcy4gSWYgeW91IGNvdWxkIGZp
bGUgYW4gaXNzdWUgZm9yIGFueXRoaW5nIHlvdSBmZWVsIG5lZWRzIHRvIGJlIGRpc2N1c3NlZCwg
dGhhdCB3b3VsZCBiZSBncmVhdC4NCiAgICA+DQogICAgPg0KICAgID4gc3VkbyBuZnQgbGlzdCB0
YWJsZSBpcHY0dGFibGUNCiAgICA+IHRhYmxlIGlwIGlwdjR0YWJsZSB7DQogICAgPiAgICAgICAg
IHNldCBzdmMxLW5vLWVuZHBvaW50cyB7DQogICAgPiAgICAgICAgICAgICAgICAgdHlwZSBpbmV0
X3NlcnZpY2UNCiAgICA+ICAgICAgICAgICAgICAgICBlbGVtZW50cyA9IHsgODk4OSB9DQogICAg
PiAgICAgICAgIH0NCiAgICA+DQogICAgPiAgICAgICAgIGNoYWluIGZpbHRlci1pbnB1dCB7DQog
ICAgPiAgICAgICAgICAgICAgICAgdHlwZSBmaWx0ZXIgaG9vayBpbnB1dCBwcmlvcml0eSBmaWx0
ZXI7IHBvbGljeSBhY2NlcHQ7DQogICAgPiAgICAgICAgICAgICAgICAgY3Qgc3RhdGUgbmV3IGp1
bXAgazhzLWZpbHRlci1zZXJ2aWNlcw0KICAgID4gICAgICAgICAgICAgICAgIGp1bXAgazhzLWZp
bHRlci1maXJld2FsbA0KICAgID4gICAgICAgICB9DQogICAgPg0KICAgID4gICAgICAgICBjaGFp
biBmaWx0ZXItb3V0cHV0IHsNCiAgICA+ICAgICAgICAgICAgICAgICB0eXBlIGZpbHRlciBob29r
IG91dHB1dCBwcmlvcml0eSBmaWx0ZXI7IHBvbGljeSBhY2NlcHQ7DQogICAgPiAgICAgICAgICAg
ICAgICAgY3Qgc3RhdGUgbmV3IGp1bXAgazhzLWZpbHRlci1zZXJ2aWNlcw0KICAgID4gICAgICAg
ICAgICAgICAgIGp1bXAgazhzLWZpbHRlci1maXJld2FsbA0KICAgID4gICAgICAgICB9DQogICAg
Pg0KICAgID4gICAgICAgICBjaGFpbiBmaWx0ZXItZm9yd2FyZCB7DQogICAgPiAgICAgICAgICAg
ICAgICAgdHlwZSBmaWx0ZXIgaG9vayBmb3J3YXJkIHByaW9yaXR5IGZpbHRlcjsgcG9saWN5IGFj
Y2VwdDsNCiAgICA+ICAgICAgICAgICAgICAgICBqdW1wIGs4cy1maWx0ZXItZm9yd2FyZA0KICAg
ID4gICAgICAgICAgICAgICAgIGN0IHN0YXRlIG5ldyBqdW1wIGs4cy1maWx0ZXItc2VydmljZXMN
CiAgICA+ICAgICAgICAgfQ0KICAgID4NCiAgICA+ICAgICAgICAgY2hhaW4gazhzLWZpbHRlci1l
eHQtc2VydmljZXMgew0KICAgID4gICAgICAgICB9DQogICAgPg0KICAgID4gICAgICAgICBjaGFp
biBrOHMtZmlsdGVyLWZpcmV3YWxsIHsNCiAgICA+ICAgICAgICAgICAgICAgICBtZXRhIG1hcmsg
MHgwMDAwODAwMCBkcm9wDQogICAgPiAgICAgICAgIH0NCiAgICA+DQogICAgPiAgICAgICAgIGNo
YWluIGs4cy1maWx0ZXItc2VydmljZXMgew0KICAgID4gICAgICAgICAgICAgICAgIGlwIGRhZGRy
IDE5Mi4xNjguODAuMTA0IHRjcCBkcG9ydCBAc3ZjMS1uby1lbmRwb2ludHMgcmVqZWN0IHdpdGgg
aWNtcCB0eXBlIGhvc3QtdW5yZWFjaGFibGUNCiAgICA+ICAgICAgICAgICAgICAgICBpcCBkYWRk
ciA1Ny4xMzEuMTUxLjE5IHRjcCBkcG9ydCBAc3ZjMS1uby1lbmRwb2ludHMgcmVqZWN0IHdpdGgg
aWNtcCB0eXBlIGhvc3QtdW5yZWFjaGFibGUNCiAgICA+ICAgICAgICAgfQ0KICAgID4NCiAgICAN
CiAgICBIZXJlIHlvdSdyZSBnb2luZyB0byBoYXZlIHRoZSBzYW1lIHByb2JsZW1zIHdpdGggaXB0
YWJsZXMsIGxhY2sgb2YNCiAgICBzY2FsYWJpbGl0eSBhbmQgY29tcGxleGl0eSBkdXJpbmcgcnVs
ZXMgcmVtb3ZhbC4gSW4gbmZ0bGIgd2UgY3JlYXRlDQogICAgbWFwcyBhbmQgd2l0aCB0aGUgc2Ft
ZSBydWxlcywgeW91IG9ubHkgaGF2ZSB0byB0YWtlIGNhcmUgb2YgaW5zZXJ0IGFuZA0KICAgIHJl
bW92ZSBlbGVtZW50cyBpbiB0aGVtLg0KICAgIA0KICAgIFNvbWUgZXh0ZW5zaXZlIGV4YW1wbGVz
IGhlcmU6DQogICAgDQogICAgaHR0cHM6Ly9naXRodWIuY29tL3pldmVuZXQvbmZ0bGIvdHJlZS9t
YXN0ZXIvdGVzdHMNCiAgICANCiAgICBJbiByZWdhcmRzIHRvIHRoZSBpcCA6IHBvcnQgbmF0dGlu
ZywgaXMgbm90IHBvc3NpYmxlIHRvIHVzZSAyIG1hcHMNCiAgICBjYXVzZSB5b3UgbmVlZCB0byBn
ZW5lcmF0ZSBudW1nZW4gcGVyIGVhY2ggb25lIGFuZCBpdCB3aWxsIGNvbWUgdG8NCiAgICBkaWZm
ZXJlbnQgbnVtYmVycy4NCiAgICANCiAgICBDaGVlcnMuDQogICAgDQogICAgPiAgICAgICAgIGNo
YWluIGs4cy1maWx0ZXItZm9yd2FyZCB7DQogICAgPiAgICAgICAgICAgICAgICAgY3Qgc3RhdGUg
aW52YWxpZCBkcm9wDQogICAgPiAgICAgICAgICAgICAgICAgbWV0YSBtYXJrIDB4MDAwMDQwMDAg
YWNjZXB0DQogICAgPiAgICAgICAgICAgICAgICAgaXAgc2FkZHIgNTcuMTEyLjAuMC8xMiBjdCBz
dGF0ZSBlc3RhYmxpc2hlZCxyZWxhdGVkIGFjY2VwdA0KICAgID4gICAgICAgICAgICAgICAgIGlw
IGRhZGRyIDU3LjExMi4wLjAvMTIgY3Qgc3RhdGUgZXN0YWJsaXNoZWQscmVsYXRlZCBhY2NlcHQN
CiAgICA+ICAgICAgICAgfQ0KICAgID4gfQ0KICAgID4NCiAgICA+IFRoYW5rIHlvdQ0KICAgID4g
U2VyZ3VlaQ0KICAgID4NCiAgICA+IE9uIDIwMTktMTEtMjcsIDEyOjIyIFBNLCAibjAtMUBvcmJ5
dGUubndsLmNjIG9uIGJlaGFsZiBvZiBQaGlsIFN1dHRlciIgPG4wLTFAb3JieXRlLm53bC5jYyBv
biBiZWhhbGYgb2YgcGhpbEBud2wuY2M+IHdyb3RlOg0KICAgID4NCiAgICA+ICAgICBIaSwNCiAg
ICA+DQogICAgPiAgICAgT24gV2VkLCBOb3YgMjcsIDIwMTkgYXQgMDQ6NTA6NTZQTSArMDAwMCwg
U2VyZ3VlaSBCZXp2ZXJraGkgKHNiZXp2ZXJrKSB3cm90ZToNCiAgICA+ICAgICA+IEFjY29yZGlu
ZyB0byBhcGkgZm9sa3Mga3ViZS1wcm94eSBtdXN0IHN1c3RhaW4gNWsgb3IgYWJvdXQgdGVzdCBv
dGhlcndpc2UgaXQgd2lsbCBuZXZlciBzZWUgcHJvZHVjdGlvbiBlbnZpcm9ubWVudC4gSW1wbGVt
ZW50aW5nIG9mIG51bWdlbiBleHByZXNzaW9uIGlzIHJlbGF0aXZlbHkgc2ltcGxlLCB0aGFua3Mg
dG8gIm5mdCAtLWRlYnVnIGFsbCIgb25jZSBpdCdzIGRvbmUsIGEgdXNlciBjYW4gdXNlIGl0IGFz
IGVhc2lseSBhcyAgd2l0aCBqc29uIF9fDQogICAgPiAgICAgPg0KICAgID4gICAgID4gUmVnYXJk
aW5nIGNvbmN1cnJlbnQgdXNhZ2UsIHNpbmNlIG15IHByaW1hcnkgZ29hbCBpcyBrdWJlLXByb3h5
IEkgZG8gbm90IHJlYWxseSBjYXJlIGF0IHRoaXMgbW9tZW50LCBhcyBrOHMgY2x1c3RlciBpcyBu
b3QgYW4gYXBwbGljYXRpb24geW91IGNvLWxvY2F0ZSBpbiBwcm9kdWN0aW9uIHdpdGggc29tZSBv
dGhlciBhcHBsaWNhdGlvbnMgcG90ZW50aWFsbHkgYWx0ZXJpbmcgaG9zdCdzIHRhYmxlcy4gSSBh
Z3JlZSBmaXJld2FsbGQgbWlnaHQgYmUgaW50ZXJlc3RpbmcgYW5kIG1vcmUgZ2VuZXJpYyBhbHRl
cm5hdGl2ZSwgYnV0IHNlZWluZyBob3cgcXVpY2tseSB0aGluZ3MgYXJlIGRvbmUgaW4gazhzLCAg
bWF5YmUgaXQgd2lsbCBiZSBkb25lIGJ5IHRoZSBlbmQgb2YgMjFzdCBjZW50dXJ5IF9fDQogICAg
Pg0KICAgID4gICAgIEkgYWdyZWUsIGluIGRlZGljYXRlZCBzZXR1cCB0aGVyZSdzIG5vIG5lZWQg
Zm9yIGNvbXByb21pc2VzLiBJIGd1ZXNzIGlmDQogICAgPiAgICAgeW91IG1hbmFnZSB0byByZWR1
Y2UgcnVsZXNldCBjaGFuZ2VzIHRvIG1lcmUgc2V0IGVsZW1lbnQgbW9kaWZpY2F0aW9ucywNCiAg
ICA+ICAgICB5b3UgY291bGQgb3V0cGVyZm9ybSBpcHRhYmxlcyBpbiB0aGF0IHJlZ2FyZC4gUnVu
LXRpbWUgcGVyZm9ybWFuY2Ugb2YNCiAgICA+ICAgICB0aGUgcmVzdWx0aW5nIHJ1bGVzZXQgd2ls
bCBvYnZpb3VzbHkgYmVuZWZpdCBmcm9tIHNldC9tYXAgdXNlIGFzIHRoZXJlDQogICAgPiAgICAg
YXJlIG11Y2ggZmV3ZXIgcnVsZXMgdG8gdHJhdmVyc2UgZm9yIGVhY2ggcGFja2V0Lg0KICAgID4N
CiAgICA+ICAgICA+IE9uY2UgSSBnZXQgZmlsdGVyIGNoYWluIHBvcnRpb24gaW4gdGhlIGNvZGUg
SSB3aWxsIHNoYXJlIGEgbGluayB0byByZXBvIHNvIHlvdSBjb3VsZCByZXZpZXcuDQogICAgPg0K
ICAgID4gICAgIFRoYW5rcyEgSSdtIGFsc28gaW50ZXJlc3RlZCBpbiBzZWVpbmcgd2hldGhlciB0
aGVyZSBhcmUgYW55DQogICAgPiAgICAgaW5jb252ZW5pZW5jZXMgZHVlIHRvIG5mdGFibGVzIGxp
bWl0YXRpb25zLiBNYXliZSBzb21lIHByb2JsZW1zIGFyZQ0KICAgID4gICAgIGVhc2llciBzb2x2
ZWQgb24ga2VybmVsLXNpZGUuDQogICAgPg0KICAgID4gICAgIENoZWVycywgUGhpbA0KICAgID4N
CiAgICA+DQogICAgDQoNCg==
