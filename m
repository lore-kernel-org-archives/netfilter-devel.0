Return-Path: <SRS0=4QBM=ZU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F131C432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 01:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7696215A5
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 01:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="PazsMB4X";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="MuVlK79Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfK1BWW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 20:22:22 -0500
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:45982 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfK1BWW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 20:22:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=5062; q=dns/txt; s=iport;
  t=1574904141; x=1576113741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ifIIRycKuyTiyGKlTQUeB//4AzGFYzXh6hh60R9oT6k=;
  b=PazsMB4XSoeV4dvlPy1DiqlQJ9Iy9nYVwO37+H3s37uWFXLHBidQsafR
   9ipkJXMtSgOv/ut0CjGGDQ2KOqtP47dD0TMOcVKmwVMSeLklNFcdNJtRK
   v8a6qIoQsH4Kx7iizKum2K82vl+6noRoUZo1slFJS8pbYDSYi2WoYgGt1
   E=;
IronPort-PHdr: =?us-ascii?q?9a23=3AV3a5xxXEW7xTzSkiSFKvFJL6jJTV8LGuZFwc94?=
 =?us-ascii?q?YnhrRSc6+q45XlOgnF6O5wiEPSA9yJ8OpK3uzRta2oGXcN55qMqjgjSNRNTF?=
 =?us-ascii?q?dE7KdehAk8GIiAAEz/IuTtankhFslQSlJ//FmwMFNeH4D1YFiB6nA=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CJAAAXIN9d/49dJa1lGQEBAQEBAQE?=
 =?us-ascii?q?BAQEBAQEBAQEBEQEBAQEBAQEBAQEBgX6BSyknBWxYIAQLKgqEIYNGA4prgjo?=
 =?us-ascii?q?lmASCUgNUCQEBAQwBASUIAgEBhEACF4FpJDgTAgMNAQEEAQEBAgEFBG2FNwy?=
 =?us-ascii?q?FUgEBAQECARIREQwBATcBDwIBCBgCAiYCAgIwFRACBA4FIoMAAYJGAw4gAQI?=
 =?us-ascii?q?Mpz8CgTiIYHWBMoJ+AQEFhR4YghcDBoEOKIUbhnsagUE/gTgMFIIeLj6CZAK?=
 =?us-ascii?q?BeoJ5MoIsjVWCCjmeJQqCLYcdjjkbgkCHa4s2hD6XBJFYAgQCBAUCDgEBBYF?=
 =?us-ascii?q?pIoFYcBU7KgGCQVARFIZIgScBBwKCQopTdIEojAsBgQ8BAQ?=
X-IronPort-AV: E=Sophos;i="5.69,251,1571702400"; 
   d="scan'208";a="673040119"
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 28 Nov 2019 01:22:20 +0000
Received: from XCH-RCD-004.cisco.com (xch-rcd-004.cisco.com [173.37.102.14])
        by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id xAS1MKjS030465
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 28 Nov 2019 01:22:20 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-RCD-004.cisco.com
 (173.37.102.14) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Nov
 2019 19:22:19 -0600
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Nov
 2019 19:22:18 -0600
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 27 Nov 2019 20:22:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DH3QFXl1QsYQYxCj/j87Ni9XLu4gxDr7qJhuw+mhiZYf77vggK0hsQnJGyQ0AHWisOsREWCFifHQRW7ak59IuEoNozS5hzdSrhHYgMEq0/PdlwLiou1XYb9hnDsPy0qZEJpMjkmLVM3GEB4JJLR8EfYvN1A6rWens7+0FAZgNka4Kg4ryCYUgDz4k/USkpB6QNYB/5NydCtCfUY7e/2Voe9TVg7B2MQloMlumC7Gjzl2eiN5lw9emiQOs96TLEgXQoXCdEErlY5lj/JZnUV4E41mfz10+zOx+zA78U2IPz4fBixuKDp3CpI3tajVWhYVeziUcJk6jGmhX6xgQrW5lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifIIRycKuyTiyGKlTQUeB//4AzGFYzXh6hh60R9oT6k=;
 b=WxASfhGIvt7kd6/CISFQYGszPnSVlvdOz8mAy/zg2JXw1XCkWJfDHLQGVGBGg2PtYbHl78kCPESwQa1NLO5/6ojbLkYtMYeCu0OEkjfVnx2UGYC6av2tuZKtWseei8erT06J0cf8EEx8f1S2IcY3p7LZsLlpd+RWKG3FovGPVp4/Z+BAmjVoTACIf4IL4U2SvZMkn6dsNEgQ6jrSpmUKgu5ME5Ut2auTp3/Lq7adZvV0Q6Im5BwN14OiK2uwO9cUDGl6B9IEDgakpGKXUc9xPqE8P/IVFPXhJB0Ewz6HLQdi6z8Y0FKlwIl1mu0NmVyKpHdc58DjXu+R/13b7Em2jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifIIRycKuyTiyGKlTQUeB//4AzGFYzXh6hh60R9oT6k=;
 b=MuVlK79YU5Pj7c61VvqYXVpjgmTtmQ4p5vMBsVW0E6kL/dzvBFvw/LrY2EXkSoncRu7be3OJ5QYtIC+5YmT1NkzHGmi9EMEXuBdvZPIL7cqAFbwnOrC6g5aLNePqIpt9zlZar89+F6KaQVjKf5Gu62jTl+0BR3p+8PvVm1yBQbo=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB3294.namprd11.prod.outlook.com (52.135.109.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Thu, 28 Nov 2019 01:22:17 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d%7]) with mapi id 15.20.2474.023; Thu, 28 Nov 2019
 01:22:17 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Laura Garcia" <nevola@gmail.com>
Subject: Re: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLts6edYHQA///QMACAAGcLAP//rq8AgABU1YD//91EAAAL5rgA///LmgCAAStKAP//9huAgABc5QD//7OUAIAAXK0A//+4hIAAC5GiAAAGSjgA
Date:   Thu, 28 Nov 2019 01:22:17 +0000
Message-ID: <739A821F-2645-41B2-AADA-AA6C34A17335@cisco.com>
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
In-Reply-To: <20191127172210.GM8016@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.77]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19411ec6-0043-49de-e6ad-08d773a168ac
x-ms-traffictypediagnostic: SN6PR11MB3294:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <SN6PR11MB3294CB6F358FC804BCC73F99C4470@SN6PR11MB3294.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(199004)(189003)(71200400001)(71190400001)(256004)(86362001)(102836004)(66476007)(229853002)(8936002)(66556008)(66446008)(64756008)(966005)(76176011)(66946007)(76116006)(91956017)(2906002)(14454004)(4001150100001)(6506007)(478600001)(36756003)(6116002)(3846002)(66066001)(6246003)(4326008)(58126008)(54906003)(5660300002)(33656002)(25786009)(305945005)(7736002)(81156014)(81166006)(6486002)(446003)(11346002)(2616005)(6436002)(8676002)(6512007)(6916009)(6306002)(186003)(99286004)(316002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3294;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 46CY/3qppEHeqvHWU+iTpPyAxdRgzwHH8oB9+PLANeL0+MHXg7VV+XJR1+9EnE2uwOvveReR9T+36L9DWtbITMuG6HNkVGB4WXRMn7CQJ4VYTLnLYv/kuzT00uIc4Mzylh/GHCMS2el2UCIwGI5b4a6qxSykqDDdMz8z5Lvo7gSatB3luWUcqpdDzRXqAokAgfdF44PECaLWtMfKD2c0AF9iG/6NqB9khoxvhzHNch2NzG+OkG6XQEki0XChWr7pjpUz2CoBGqsCz3nIFGzHUbpTBUZhPyrVD5m+OKbQczIacAtv93gic7q3yffEQAgsvL34faL+tWNfDZksa6CLKQb4vzc3RVz1iF2oiKEBBMNxHl9ZDhloMWnn712pzEpM5DVxcnlrbs+cn41cKI+73G0XmCl9SxeFJh5E1qroBEBicA2MdjgHstv+dGb5sbO4SFTQu1YXFTl2T6Cv0rwLrsh0FImplwd7ndXlVQPsrNA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <64F1CA51DFB5E94ABF768B142FEE5910@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 19411ec6-0043-49de-e6ad-08d773a168ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 01:22:17.5627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RjfYDsiKWHwh4kq0J5WrebXPN77rLgEurOr/XRwCzAw+NQiz4zuj9J3BS9ekeBAwr/EZkctmvYHTLrCfUh9Dzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3294
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.14, xch-rcd-004.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8gUGhpbCwNCg0KUGxlYXNlIHNlZSBiZWxvdyB0aGUgbGlzdCBvZiBuZnRhYmxlcyBydWxl
cyB0aGUgY29kZSBnZW5lcmF0ZSB0byBtaW1pYyBvbmx5IGZpbHRlciBjaGFpbiBwb3J0aW9uIG9m
IGt1YmUgcHJveHkuDQoNCkhlcmUgaXMgdGhlIGxvY2F0aW9uIG9mIGNvZGUgcHJvZ3JhbW1pbmcg
dGhlc2UgcnVsZXMuIA0KaHR0cHM6Ly9naXRodWIuY29tL3NiZXp2ZXJrL25mdGFibGVzbGliLXNh
bXBsZXMvYmxvYi9tYXN0ZXIvcHJveHkvbWltaWMtZmlsdGVyL21pbWljLWZpbHRlci5nbw0KDQpN
b3N0IG9mIHJ1bGVzIGFyZSBzdGF0aWMsIHdpbGwgYmUgcHJvZ3JhbWVkICBqdXN0IG9uY2Ugd2hl
biBwcm94eSBjb21lcyB1cCwgd2l0aCB0aGUgZXhjZXB0aW9uIGlzIDIgcnVsZXMgaW4gazhzLWZp
bHRlci1zZXJ2aWNlcyBjaGFpbi4gVGhlIHJlZmVyZW5jZSB0byB0aGUgbGlzdCBvZiBwb3J0cyBj
YW4gY2hhbmdlLiBJZGVhbGx5IGl0IHdvdWxkIGJlIGdyZWF0IHRvIGV4cHJlc3MgdGhlc2UgdHdv
IHJ1bGVzIHdpdGggYSBzaW5nbGUgcnVsZSBhbmQgYSB2bWFwLCB3aGVyZSB0aGUga2V5IG11c3Qg
YmUgc2VydmljZSdzIGlwIEFORCBzZXJ2aWNlIHBvcnQsIGFzIGl0IGlzIHBvc3NpYmxlIHRvIGhh
dmUgYSBzaW5nbGUgc2VydmljZSBJUCB0aGF0IGNhbiBiZSBhc3NvY2lhdGVkIHdpdGggc2V2ZXJh
bCBwb3J0cyBhbmQgc29tZSBvZiB0aGVzZSBwb3J0cyBtaWdodCBoYXZlIGFuIGVuZHBvaW50IGFu
ZCBzb21lIGRvIG5vdC4gU28gZmFyIEkgY291bGQgbm90IGZpZ3VyZSBpdCBvdXQuIEFwcHJlY2lh
dGUgeW91ciB0aG91Z2h0L3N1Z2dlc3Rpb25zL2NyaXRpY3MuIElmIHlvdSBjb3VsZCBmaWxlIGFu
IGlzc3VlIGZvciBhbnl0aGluZyB5b3UgZmVlbCBuZWVkcyB0byBiZSBkaXNjdXNzZWQsIHRoYXQg
d291bGQgYmUgZ3JlYXQuDQoNCg0Kc3VkbyBuZnQgbGlzdCB0YWJsZSBpcHY0dGFibGUNCnRhYmxl
IGlwIGlwdjR0YWJsZSB7DQoJc2V0IHN2YzEtbm8tZW5kcG9pbnRzIHsNCgkJdHlwZSBpbmV0X3Nl
cnZpY2UNCgkJZWxlbWVudHMgPSB7IDg5ODkgfQ0KCX0NCg0KCWNoYWluIGZpbHRlci1pbnB1dCB7
DQoJCXR5cGUgZmlsdGVyIGhvb2sgaW5wdXQgcHJpb3JpdHkgZmlsdGVyOyBwb2xpY3kgYWNjZXB0
Ow0KCQljdCBzdGF0ZSBuZXcganVtcCBrOHMtZmlsdGVyLXNlcnZpY2VzDQoJCWp1bXAgazhzLWZp
bHRlci1maXJld2FsbA0KCX0NCg0KCWNoYWluIGZpbHRlci1vdXRwdXQgew0KCQl0eXBlIGZpbHRl
ciBob29rIG91dHB1dCBwcmlvcml0eSBmaWx0ZXI7IHBvbGljeSBhY2NlcHQ7DQoJCWN0IHN0YXRl
IG5ldyBqdW1wIGs4cy1maWx0ZXItc2VydmljZXMNCgkJanVtcCBrOHMtZmlsdGVyLWZpcmV3YWxs
DQoJfQ0KDQoJY2hhaW4gZmlsdGVyLWZvcndhcmQgew0KCQl0eXBlIGZpbHRlciBob29rIGZvcndh
cmQgcHJpb3JpdHkgZmlsdGVyOyBwb2xpY3kgYWNjZXB0Ow0KCQlqdW1wIGs4cy1maWx0ZXItZm9y
d2FyZA0KCQljdCBzdGF0ZSBuZXcganVtcCBrOHMtZmlsdGVyLXNlcnZpY2VzDQoJfQ0KDQoJY2hh
aW4gazhzLWZpbHRlci1leHQtc2VydmljZXMgew0KCX0NCg0KCWNoYWluIGs4cy1maWx0ZXItZmly
ZXdhbGwgew0KCQltZXRhIG1hcmsgMHgwMDAwODAwMCBkcm9wDQoJfQ0KDQoJY2hhaW4gazhzLWZp
bHRlci1zZXJ2aWNlcyB7DQoJCWlwIGRhZGRyIDE5Mi4xNjguODAuMTA0IHRjcCBkcG9ydCBAc3Zj
MS1uby1lbmRwb2ludHMgcmVqZWN0IHdpdGggaWNtcCB0eXBlIGhvc3QtdW5yZWFjaGFibGUNCgkJ
aXAgZGFkZHIgNTcuMTMxLjE1MS4xOSB0Y3AgZHBvcnQgQHN2YzEtbm8tZW5kcG9pbnRzIHJlamVj
dCB3aXRoIGljbXAgdHlwZSBob3N0LXVucmVhY2hhYmxlDQoJfQ0KDQoJY2hhaW4gazhzLWZpbHRl
ci1mb3J3YXJkIHsNCgkJY3Qgc3RhdGUgaW52YWxpZCBkcm9wDQoJCW1ldGEgbWFyayAweDAwMDA0
MDAwIGFjY2VwdA0KCQlpcCBzYWRkciA1Ny4xMTIuMC4wLzEyIGN0IHN0YXRlIGVzdGFibGlzaGVk
LHJlbGF0ZWQgYWNjZXB0DQoJCWlwIGRhZGRyIDU3LjExMi4wLjAvMTIgY3Qgc3RhdGUgZXN0YWJs
aXNoZWQscmVsYXRlZCBhY2NlcHQNCgl9DQp9DQoNClRoYW5rIHlvdQ0KU2VyZ3VlaQ0KDQrvu79P
biAyMDE5LTExLTI3LCAxMjoyMiBQTSwgIm4wLTFAb3JieXRlLm53bC5jYyBvbiBiZWhhbGYgb2Yg
UGhpbCBTdXR0ZXIiIDxuMC0xQG9yYnl0ZS5ud2wuY2Mgb24gYmVoYWxmIG9mIHBoaWxAbndsLmNj
PiB3cm90ZToNCg0KICAgIEhpLA0KICAgIA0KICAgIE9uIFdlZCwgTm92IDI3LCAyMDE5IGF0IDA0
OjUwOjU2UE0gKzAwMDAsIFNlcmd1ZWkgQmV6dmVya2hpIChzYmV6dmVyaykgd3JvdGU6DQogICAg
PiBBY2NvcmRpbmcgdG8gYXBpIGZvbGtzIGt1YmUtcHJveHkgbXVzdCBzdXN0YWluIDVrIG9yIGFi
b3V0IHRlc3Qgb3RoZXJ3aXNlIGl0IHdpbGwgbmV2ZXIgc2VlIHByb2R1Y3Rpb24gZW52aXJvbm1l
bnQuIEltcGxlbWVudGluZyBvZiBudW1nZW4gZXhwcmVzc2lvbiBpcyByZWxhdGl2ZWx5IHNpbXBs
ZSwgdGhhbmtzIHRvICJuZnQgLS1kZWJ1ZyBhbGwiIG9uY2UgaXQncyBkb25lLCBhIHVzZXIgY2Fu
IHVzZSBpdCBhcyBlYXNpbHkgYXMgIHdpdGgganNvbiBfXw0KICAgID4gDQogICAgPiBSZWdhcmRp
bmcgY29uY3VycmVudCB1c2FnZSwgc2luY2UgbXkgcHJpbWFyeSBnb2FsIGlzIGt1YmUtcHJveHkg
SSBkbyBub3QgcmVhbGx5IGNhcmUgYXQgdGhpcyBtb21lbnQsIGFzIGs4cyBjbHVzdGVyIGlzIG5v
dCBhbiBhcHBsaWNhdGlvbiB5b3UgY28tbG9jYXRlIGluIHByb2R1Y3Rpb24gd2l0aCBzb21lIG90
aGVyIGFwcGxpY2F0aW9ucyBwb3RlbnRpYWxseSBhbHRlcmluZyBob3N0J3MgdGFibGVzLiBJIGFn
cmVlIGZpcmV3YWxsZCBtaWdodCBiZSBpbnRlcmVzdGluZyBhbmQgbW9yZSBnZW5lcmljIGFsdGVy
bmF0aXZlLCBidXQgc2VlaW5nIGhvdyBxdWlja2x5IHRoaW5ncyBhcmUgZG9uZSBpbiBrOHMsICBt
YXliZSBpdCB3aWxsIGJlIGRvbmUgYnkgdGhlIGVuZCBvZiAyMXN0IGNlbnR1cnkgX18NCiAgICAN
CiAgICBJIGFncmVlLCBpbiBkZWRpY2F0ZWQgc2V0dXAgdGhlcmUncyBubyBuZWVkIGZvciBjb21w
cm9taXNlcy4gSSBndWVzcyBpZg0KICAgIHlvdSBtYW5hZ2UgdG8gcmVkdWNlIHJ1bGVzZXQgY2hh
bmdlcyB0byBtZXJlIHNldCBlbGVtZW50IG1vZGlmaWNhdGlvbnMsDQogICAgeW91IGNvdWxkIG91
dHBlcmZvcm0gaXB0YWJsZXMgaW4gdGhhdCByZWdhcmQuIFJ1bi10aW1lIHBlcmZvcm1hbmNlIG9m
DQogICAgdGhlIHJlc3VsdGluZyBydWxlc2V0IHdpbGwgb2J2aW91c2x5IGJlbmVmaXQgZnJvbSBz
ZXQvbWFwIHVzZSBhcyB0aGVyZQ0KICAgIGFyZSBtdWNoIGZld2VyIHJ1bGVzIHRvIHRyYXZlcnNl
IGZvciBlYWNoIHBhY2tldC4NCiAgICANCiAgICA+IE9uY2UgSSBnZXQgZmlsdGVyIGNoYWluIHBv
cnRpb24gaW4gdGhlIGNvZGUgSSB3aWxsIHNoYXJlIGEgbGluayB0byByZXBvIHNvIHlvdSBjb3Vs
ZCByZXZpZXcuDQogICAgDQogICAgVGhhbmtzISBJJ20gYWxzbyBpbnRlcmVzdGVkIGluIHNlZWlu
ZyB3aGV0aGVyIHRoZXJlIGFyZSBhbnkNCiAgICBpbmNvbnZlbmllbmNlcyBkdWUgdG8gbmZ0YWJs
ZXMgbGltaXRhdGlvbnMuIE1heWJlIHNvbWUgcHJvYmxlbXMgYXJlDQogICAgZWFzaWVyIHNvbHZl
ZCBvbiBrZXJuZWwtc2lkZS4NCiAgICANCiAgICBDaGVlcnMsIFBoaWwNCiAgICANCg0K
