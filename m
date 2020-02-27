Return-Path: <SRS0=BYf1=4P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D94CC3F2C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Feb 2020 21:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB0C0246A0
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Feb 2020 21:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="bPm6IeX2";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="f1hNn0/s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgB0VZF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 16:25:05 -0500
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:64839 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729697AbgB0VZF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 16:25:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2546; q=dns/txt; s=iport;
  t=1582838704; x=1584048304;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TdOdxc1GgWV0w6f3QCZflgAby7DcFCaYHPmWz6bjUX0=;
  b=bPm6IeX2g9b+Yhoyi6amtr0YSXkDoCo4DgIN0LB8IlrL65S6MatRy707
   L9wcnygqYAwtHJWWp98RCjEYhqs/iuw07Em/cuXEfL4SfgB2dkUJAp+Ad
   DHmGxTmAoSuEFUNn4kNlRxtPctJ+U0HbaP3R/BVn1cSLW4dR6oaBhuWlQ
   M=;
IronPort-PHdr: =?us-ascii?q?9a23=3A9MzGxRcy3Cts1bDZKK45QULflGMj4e+mNxMJ6p?=
 =?us-ascii?q?chl7NFe7ii+JKnJkHE+PFxlwGQD57D5adCjOzb++D7VGoM7IzJkUhKcYcEFn?=
 =?us-ascii?q?pnwd4TgxRmBceEDUPhK/u/dCY3DtpPTlxN9HCgOk8TE8H7NBXf?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BXAQCiMlhe/4ENJK1mHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgWoEAQELAYFTUAWBRCAECyqEFINGA4pmgl+YFIJSA1QJAQEBDAE?=
 =?us-ascii?q?BLQIEAQGEQAIXgXEkNwYOAgMNAQEFAQEBAgEFBG2FNwyFZAEBAQMSEREMAQE?=
 =?us-ascii?q?3AQ8CAQgOCgICJgICAjAVEAIEDgUigwSCSwMuAaULAoE5iGJ1gTKCfwEBBYJ?=
 =?us-ascii?q?EgkgYggwJgQ4qAYUfDIZ5GoFBP4E4IIJMPoRLF4J6MoIskGWfNQqCPJZlHJs?=
 =?us-ascii?q?uqjcCBAIEBQIOAQEFgWgjgVhwFWUBgkFQGA2OHQkag1CKVXSBKY4KAQE?=
X-IronPort-AV: E=Sophos;i="5.70,493,1574121600"; 
   d="scan'208";a="732365664"
Received: from alln-core-9.cisco.com ([173.36.13.129])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 27 Feb 2020 21:25:03 +0000
Received: from XCH-RCD-001.cisco.com (xch-rcd-001.cisco.com [173.37.102.11])
        by alln-core-9.cisco.com (8.15.2/8.15.2) with ESMTPS id 01RLP3SN006923
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 27 Feb 2020 21:25:03 GMT
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by XCH-RCD-001.cisco.com
 (173.37.102.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Feb
 2020 15:25:02 -0600
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by xhs-rtp-003.cisco.com
 (64.101.210.230) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Feb
 2020 16:25:01 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-001.cisco.com (173.37.227.246) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 27 Feb 2020 15:25:01 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQZFravgBbJ9fINQaCP4rUjQ3AZUm1LsBYivIit7p6m5R2QyJ2cDnNPfSQc7V6ufY/9sc/N97smXOTT/7DB4nx55/AHHsJ40ujgadoE23m86CJKdK8A1zZw3aXwePfmaz9pVSejxlD0UW93AQEfiwDt8z4r0MGQjMFOwy01oPOF7uHxcrjp8UZRtoXQrdMgZpILP+9tpO5QjewXhUKra3zyflWF4ADjN2/QtY1TLG8Y1Lj8luEJpsbRq5b5ISep3z1RvI/ELcLG8oyBq4pqP4EVYlh7umurobCiBZbe0U16D3OnQsOxP4mxAaBvKvSXYEKgVNr7+RgpohlSX9aTN3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TdOdxc1GgWV0w6f3QCZflgAby7DcFCaYHPmWz6bjUX0=;
 b=AQ1O1DHeiJL2WDvEhMZ0PudISV9SG51u+0afMd0lBoeWC+JnfUrqRX5rB2dARYE3gabWkBCglMZQ5iMJMX/gXSUMbfwNvnf8aiRPhKQMvccla4OAWESVgguQAEICABufl4RGopvtLemLoZjVAYyMxjkGDErizt2/pOyDhSiVaZDi22Hgl9COTkGYtvNtXlK9j/SQdDY3lnqwDh18PKr0u3xjMe/blyxR35emQxkpm7ihWbYQKD1krSwNWjVS1O82j1kkoLE3KKvqdNNXLQJ7ON5BcFfQfrBZCVZ3Br10CjL/ZmCTinfPCU3KeDQi1jw/Eq0k6ye914ALPhMjixvETw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TdOdxc1GgWV0w6f3QCZflgAby7DcFCaYHPmWz6bjUX0=;
 b=f1hNn0/sHo/VA6kyA3Lb2jDAGoOQpCvcwlWi6JaBSrmuJASycKfBcovE0s+3+H8uiOFA97phkFYEw7zZ1PrKroypbbojuYnpYQmCmCj6BixTmOMGZ0yWK84j8zP+Kgm2Z/B/4QaV2iowOSeC2uhJv/LLTO/7adPgFVT4yV7a53s=
Received: from MN2PR11MB3598.namprd11.prod.outlook.com (2603:10b6:208:f0::28)
 by MN2PR11MB4270.namprd11.prod.outlook.com (2603:10b6:208:18c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Thu, 27 Feb
 2020 21:25:00 +0000
Received: from MN2PR11MB3598.namprd11.prod.outlook.com
 ([fe80::ccd9:1946:3cb2:d495]) by MN2PR11MB3598.namprd11.prod.outlook.com
 ([fe80::ccd9:1946:3cb2:d495%2]) with mapi id 15.20.2750.021; Thu, 27 Feb 2020
 21:25:00 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Phil Sutter <phil@nwl.cc>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Ipv6 address in concatenation
Thread-Topic: Ipv6 address in concatenation
Thread-Index: AQHV7Yn9ikf1UKam/UKNuCgsdX0Y1agvcQKA///I0oA=
Date:   Thu, 27 Feb 2020 21:25:00 +0000
Message-ID: <C3A34108-BD5F-41CB-835B-277494505E85@cisco.com>
References: <54A7EDF2-F83D-44D7-994C-2C8E35E586AD@cisco.com>
 <20200227194229.GP19559@breakpoint.cc>
In-Reply-To: <20200227194229.GP19559@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.22.0.200209
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [2001:470:b16e:20::200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c2603aa-a6fe-4587-e5eb-08d7bbcb807b
x-ms-traffictypediagnostic: MN2PR11MB4270:
x-microsoft-antispam-prvs: <MN2PR11MB4270811E034793A96D113528C4EB0@MN2PR11MB4270.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 03264AEA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(199004)(189003)(186003)(36756003)(5660300002)(66946007)(66556008)(54906003)(64756008)(6486002)(86362001)(76116006)(6916009)(66476007)(66446008)(316002)(2906002)(4326008)(8936002)(33656002)(8676002)(478600001)(81156014)(81166006)(71200400001)(6506007)(6512007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4270;H:MN2PR11MB3598.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6mq5imwhjSnz8d3fctS9EkzDuGXKZmAvLJmWiwUKynj/+ySjjczPqAqQsAcu9QAmFXOoq7nTRQkDJkOTp2Fl9HUuJVoslw4M64jMTmG8Szuv2Xc23D/qImVeAmWSuxxokAoQ6SQEaDFIcFuRj6TEHK/Cv8VP/CuZJ1QBNjY+kvnJfDCVjica6v39wdnGWzboKYGM27DworIt7SZqw2iCYefhGF3R5TWnX9++szSRMAwE1eIzEFZR+PIdRVZA5LFbcE2ct4vOGSgJmL+xq8HY2yrBQok4ceRaxIUP7hGOQkR4l/DHpOSTLN/W/ZiRPGL6mi9LAVzYFz4/eLZKWLNwf+To5HMLWTxRt/p1m6AVIzOvJ415HS/LUf/KbsbJwjMeJhOdzWiNJfyw/lDRW43C3aw9NSCa9nFd/MUP+eDAQ6KPHHZrrLtD1NHutcv5x2Sy
x-ms-exchange-antispam-messagedata: OzhzD5DQdHV1Ubw9ES3do8pI5mhIlaHWsTvX3fLo3BLzQBEPq90/FYQ8ZbVm1yGZwPZHlUdCI7mQ28ZfwCtFa89lDQGdlLWpKkrU3ejqPP2cbFlfyZVESfsRBVipMOJmuJe+jJZrPSjZoSN39K4biaqAcnQb5IscpLPXO+NafNM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F68811D7B744014CBF3C64752EBD46B7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2603aa-a6fe-4587-e5eb-08d7bbcb807b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2020 21:25:00.3233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7zs8Ymi9BMUzW2rfMEWgJ/2I13fd8Hsu9U/SxnOU6C7RzUePF7L23FZwtEYRqaE2DtJD67iF7lEVRnKyuIWccg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4270
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.11, xch-rcd-001.cisco.com
X-Outbound-Node: alln-core-9.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

T2ssIEkgZmlndXJlZCBvdXQgdGhlIG1hcCBpc3N1ZSwgaXQgd2FzIGEgbGVuZ3RoIG9mIHRoZSBr
ZXkgaW4gYml0cywgZGFtbiBjb3B5L3Bhc3RlICgNCg0KQXBwcmVjaWF0ZSBpZiBzb21lYm9keSBj
b3VsZCBjb21tZW50IGFib3V0IHRoZSBmb2xsb3dpbmc6DQoNCnN1ZG8gbmZ0IC0tZGVidWc9bmV0
bGluayBpbnNlcnQgcnVsZSBpcDYga3ViZS1uZnByb3h5LXY2IGs4cy1uYXQtc2VydmljZXMgaXA2
IG5leHRoZHIgLiBpcDYgZGFkZHIgLiB0aCBkcG9ydCB2bWFwIEBjbHVzdGVyLWlwLXNldA0KaXA2
IGt1YmUtbmZwcm94eS12NiBrOHMtbmF0LXNlcnZpY2VzIA0KICBbIHBheWxvYWQgbG9hZCAxYiBA
IG5ldHdvcmsgaGVhZGVyICsgNiA9PiByZWcgMSBdDQogIFsgcGF5bG9hZCBsb2FkIDE2YiBAIG5l
dHdvcmsgaGVhZGVyICsgMjQgPT4gcmVnIDkgXS4gICAgICAgPCAtLSBJcyBpdCBsb2FkaW5nIHJl
ZyA5IDQtYnl0ZXMsIHJlZyAxMCA0IGJ5dGVzIGV0YyB1bnRpbCByZWcgMTI/IE9yIGJlY2F1c2Ug
dGhlIGRhdGEgMTYgYnl0ZXMgbG9uZyBpdCBoYXMgdG8gc2tpcCAzIG1vcmUgcmVnaXN0ZXI/DQog
IFsgcGF5bG9hZCBsb2FkIDJiIEAgdHJhbnNwb3J0IGhlYWRlciArIDIgPT4gcmVnIDEzIF0NCiAg
WyBsb29rdXAgcmVnIDEgc2V0IGNsdXN0ZXItaXAtc2V0IGRyZWcgMCBdDQoNCkkgYW0ganVzdCB0
cnlpbmcgdG8gZmlndXJlIG91dCBob3cgdG8gY2FsY3VsYXRlIG5leHQgcmVnaXN0ZXIgdG8gdXNl
LiAgICBJZiB0aGVyZSBpcyBhbGdvcml0aG0gZm9yIGJvdGggaXB2NCBhbmQgaXB2NiB0aGF0IHdv
dWxkIGJlIGF3ZXNvbWUgdG8ga25vdy4NCg0KVGhhbmsgeW91DQpTZXJndWVpDQoNCu+7v09uIDIw
MjAtMDItMjcsIDI6NDIgUE0sICJGbG9yaWFuIFdlc3RwaGFsIiA8ZndAc3RybGVuLmRlPiB3cm90
ZToNCg0KICAgIFNlcmd1ZWkgQmV6dmVya2hpIChzYmV6dmVyaykgPHNiZXp2ZXJrQGNpc2NvLmNv
bT4gd3JvdGU6DQogICAgPiBIZWxsbywNCiAgICA+IA0KICAgID4gSSBzdGFydGVkIHRlc3Rpbmcg
IG5mcHJveHkgaW4gaXB2NiBlbmFibGVkIGt1YmVybmV0ZXMgY2x1c3RlciBhbmQgaXQgc2VlbXMg
aXB2NiBhZGRyZXNzIGNhbm5vdCBiZSBhIHBhcnQgb2YgY29uY2F0ZW5hdGlvbiBleHByZXNzaW9u
LiBJcyB0aGVyZSBhIGtub3duIGlzc3VlIG9yIGl0IGlzIG1lIGRvaW5nIHNvbWV0aGluZyBpbmNv
cnJlY3Q/DQogICAgPiBGcm9tIG15IHNpZGUgdGhlIGNvZGUgaXMgdGhlIHNhbWUsIEkganVzdCBj
aGFuZ2UgaXA0X2FkZHIgdG8gaXA2X2FkZHIgd2hlbiBJIGJ1aWxkIHNldHMuDQogICAgDQogICAg
dHlwZXMgYXJlIGlycmVsdmFudCBmb3IgdGhlIGtlcm5lbC4gIFRoZXkgYXJlIE9OTFkgdXNlZCBi
eSB0aGUgbmZ0IHRvb2wNCiAgICBzbyBpdCBrbm93cyBob3cgdG8gZm9ybWF0IG91dHB1dC4NCiAg
ICANCiAgICBJIHN1c3BlY3QgeW91IG5lZWQgdG8gZml4IHVwIHRoZSBnZW5lcmF0ZWQgcGF5bG9h
ZCBleHByZXNzaW9ucw0KICAgIGZvciBpcHY2LiAgRXNzZW50aWFsbHksIGluIHRoZSBpcHY2IGNh
c2UsIHlvdSBoYXZlIGEgY29uY2F0ZW5hdGlvbg0KICAgIA0KICAgIGlwdjRfYWRkciAuIGlwdjRf
YWRkciAuIGlwNF9hZGRyIC4gaXB2NF9hZGRyIC4gaW5ldF9zZXJ2aWNlDQogICAgDQogICAgKGlw
djYgYWRkcmVzcyBuZWVkcyA0IDMyLWJpdCByZWdpc3RlcnMpDQogICAgDQogICAgaS5lLiwgeW91
IG5lZWQgdG8gdXNlIGEgZGlmZmVyZW50IGRlc3RpbmF0aW9uIHJlZ2lzdGVyIHdoZW4geW91IHN0
b3JlDQogICAgdGhlIHRjcC91ZHAgcG9ydCwgZWxzZSB5b3Ugd2lsbCBjbG9iYmVyIGEgcGFydCBv
ZiB0aGUgaXB2NiBhZGRyZXNzLg0KICAgIA0KICAgIA0KDQo=
