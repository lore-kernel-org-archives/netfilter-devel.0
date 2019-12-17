Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42169C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 00:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE38B2465E
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 00:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="JDaU1i3v";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="xzueidYj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfLQAvV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 19:51:21 -0500
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:48404 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLQAvV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 19:51:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=5872; q=dns/txt; s=iport;
  t=1576543879; x=1577753479;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Zwzwig1JxfSq1uwHLnlT7M773IX+P2uUO0D8KPeUh/o=;
  b=JDaU1i3vFFg9MvdXxSA2regBEIzmWh5hTCeSxGR0xKf96rc+90Nqo+CG
   Sexr2DAUUCXJEpJAcWLQCOniF/TvVkesOUCK4/1aXz/lnITLl2EQ5+MBh
   pANNraBuGJPsn0iMcRvdXqg2Vyq/IBQQ6tmD5bm+JQaJNlh6mp2h8HM/u
   U=;
IronPort-PHdr: =?us-ascii?q?9a23=3Ax5/9yhVZc6IRQObiwduN8Bt1RsnV8LGuZFwc94?=
 =?us-ascii?q?YnhrRSc6+q45XlOgnF6O5wiEPSA9yJ8OpK3uzRta2oGXcN55qMqjgjSNRNTF?=
 =?us-ascii?q?dE7KdehAk8GIiAAEz/IuTtankhFslQSlJ//FmwMFNeH4D1YFiB6nA=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DFBQBAJvhd/4sNJK1lHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgX6BS1AFbFggBAsqCoN6g0YDiw+CX5gGgUKBEANUCQEBAQwBASU?=
 =?us-ascii?q?IAgEBhEACF4F9JDgTAgMNAQEEAQEBAgEFBG2FNwyFXwEBAQMSEREMAQE3AQ8?=
 =?us-ascii?q?CAQgYAgIRFQICAjAVEAIEAQ0FIoMAAYJGAy4BDqRWAoE4iGF1gTKCfgEBBYE?=
 =?us-ascii?q?1ARNBQIJPGIIXAwaBDiiMGBqBQT+BEScggkw+gmQCAhqBAkUXKIJRMoIskDO?=
 =?us-ascii?q?eSwqCNIcpjlwbgkOYBY5MgUaHCZF6AgQCBAUCDgEBBYFpIjeBIXAVZQGCQVA?=
 =?us-ascii?q?RFI0Sg3OKU3SBKJAqAYEPAQE?=
X-IronPort-AV: E=Sophos;i="5.69,323,1571702400"; 
   d="scan'208";a="671889721"
Received: from alln-core-6.cisco.com ([173.36.13.139])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 17 Dec 2019 00:51:11 +0000
Received: from XCH-RCD-006.cisco.com (xch-rcd-006.cisco.com [173.37.102.16])
        by alln-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id xBH0pBTr023568
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 17 Dec 2019 00:51:11 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-RCD-006.cisco.com
 (173.37.102.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Dec
 2019 18:51:10 -0600
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Dec
 2019 19:51:09 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-003.cisco.com (173.37.227.248) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 16 Dec 2019 18:51:09 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhLAO8hgibTAXz2osLbRImHr5F5TQqge8GfHB+aaKqBbOSYebOXgWxHSKW4d9liaXpmDR3D3f9kWBbjeBFjJazfHySsEl+iJxmh6NsLgvfdhM4dBdSk2pCObOrUELp76YqIocDkgmliXlf7wIygBfRwA8Auc79HTmH2SNB9jp5NkD/PIxliwgFWiktKhaRf40yihsyqahVMJtoeYr48jWGTkcZ448KtTL9OOJcu8DEC/Ynxqb+5RJ2XLQqyOeBTZMrxKVe/50teVcOlC1+3L5fsLHL5jwdz7K6a3eLxBW4cJu/N8GDLWUlwUT6uTHTHLxZyxD6q+bhD4Jn5gYibDbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zwzwig1JxfSq1uwHLnlT7M773IX+P2uUO0D8KPeUh/o=;
 b=Qp7tNp4D74Lx1pjaVgIt4VIn50HUEQAm5Ce5j1Gn0zAr/oCtWIFIdtZaHWzJppc1vgnKo8tOMFwmfXrYfE/I/D611MFMeNT1SK6YsEGL/Or3pZYckqZTLlVmj2J2uNamQqKlTHvdK0zZSEOPGoQ03NSj6H/5HdOV5i0gs1Kd49LUIQfUS4w+z7jokIL3vERQqdkGv7t69NIfvK6fR1sicijvzn/8ZZUefbW4SvNjYfUCZVzz45n9/zvoq+8epLNpf3sggFkmqHAP0J/sn0sJ9zvA+NojJ7LgRCz9t4cblXbmztlLlNsFm6XyJM8akGGK+ga/RShMS/2PLiCqlZ4OQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zwzwig1JxfSq1uwHLnlT7M773IX+P2uUO0D8KPeUh/o=;
 b=xzueidYjP/8XnzBQJ/Ri64/V62GwPZL/gJaHqc4viBs1Ep+6T4FNBQTGx8EkUxDSbP6/g7Td2RmOoSz4+dt7NCm3J4HFq2U6IV57w6b8jlNSsWtj4wsVZ9IiNXeFpxa2lkRT6GWBmK5h/JZVHBwevqZJaiLl60s1ZGMWmhgoVPo=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB1435.namprd11.prod.outlook.com (10.172.35.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 00:51:07 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26%10]) with mapi id 15.20.2538.019; Tue, 17 Dec
 2019 00:51:07 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyAgABX04CAABp3AIAAVCiAgBKu9AA=
Date:   Tue, 17 Dec 2019 00:51:07 +0000
Message-ID: <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
 <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
 <20191204223215.GX14469@orbyte.nwl.cc>
In-Reply-To: <20191204223215.GX14469@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.20.0.191208
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6f11c53-4b95-43ef-ed95-08d7828b339e
x-ms-traffictypediagnostic: DM5PR11MB1435:
x-microsoft-antispam-prvs: <DM5PR11MB14358B40DCE10BC7E6405929C4500@DM5PR11MB1435.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(39860400002)(346002)(136003)(376002)(189003)(199004)(91956017)(76116006)(66946007)(64756008)(66446008)(66556008)(5660300002)(66476007)(71200400001)(966005)(186003)(2616005)(478600001)(33656002)(86362001)(316002)(6512007)(8936002)(81156014)(81166006)(2906002)(6506007)(8676002)(110136005)(53546011)(6486002)(26005)(4326008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1435;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YVPRPPpXhuY07a0y9ccGd3AJA4DaRLKSBZ1PVM5+xll/pY+d5tJbYKzsISUzSAX46A6DnEFDkXefEUg5wpywc8i0VAaYlxKMt7EHnSs6KT805ho3aX+N7baSRMRgFw28MTz+xIRYjW1M06JryQeIiA/3RX/flzo7suZyEzPSbtO68a8mJD+W2RtqNUNuddbwzqYHjJ8l45QvRWUc8QH9YZWRFBx5Kosm5+JbiOvsWmK7kjBpIu4u0U0mCLSOBSd19ZmMgaA9XEegUggfSvkbYPHuLFwhy9dkwKFbS4mo5PWLIlyI0tRk71NGuQ33MaqmtTahvNiKfBX95G7BocUTRCNSul20YDBsfb/fFIV332NUA5Mulz0FvHy4KwDCdyaZ0EDS8I+ciOsuOZHW4kiDWApa6JTM26qN3MoJuawD2ZENWc08U0yfugnYfWRrd69l0tfrlT9HuYsVLwp9wI1QRNftrgbXB62+uJ/pdPG1dUg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <00BBB76C4D95CF48BD23F1DE35D90068@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e6f11c53-4b95-43ef-ed95-08d7828b339e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 00:51:07.3473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: seLe4Jix138vP0akLo9qx0CzyDx8YPyeOa25if4dD15hZwDOxMisW3X/MxvSPvw8WdgNsVeL457/GUthet1V0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1435
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.16, xch-rcd-006.cisco.com
X-Outbound-Node: alln-core-6.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGkgUGhpbCwNCg0KSW4gdGhpcyBnb29nbGUgZG9jLCBzZWUgbGluazogaHR0cHM6Ly9kb2NzLmdv
b2dsZS5jb20vZG9jdW1lbnQvZC8xMjhnbGxicl9vLTQwcEQyaTBEMTR6TU5kdEN3UllSN1lNNDlU
NEwyRXlhYy9lZGl0P3VzcD1zaGFyaW5nDQoNClRoZXJlIGlzIGEgcXVlc3Rpb24gYWJvdXQgcG9z
c2libGUgb3B0aW1pemF0aW9ucy4gSSB3YXMgd29uZGVyaW5nIGlmIHlvdSBjb3VsZCBjb21tZW50
L3JlcGx5LiBBbHNvIEkgZ290IG9uZSBtb3JlIHF1ZXN0aW9uIGFib3V0IHVwZGF0ZXMgb2YgYSBz
ZXQuIExldCdzIHNheSB0aGVyZSBpcyBhIHNldCB3aXRoIDEwayBlbnRyaWVzLCBob3cgY29zdGx5
IHdvdWxkIGJlIHRoZSB1cGRhdGUgb2Ygc3VjaCBzZXQuDQoNClRoYW5rcyBhIGxvdA0KU2VyZ3Vl
aQ0KDQrvu79PbiAyMDE5LTEyLTA0LCA1OjMyIFBNLCAibjAtMUBvcmJ5dGUubndsLmNjIG9uIGJl
aGFsZiBvZiBQaGlsIFN1dHRlciIgPG4wLTFAb3JieXRlLm53bC5jYyBvbiBiZWhhbGYgb2YgcGhp
bEBud2wuY2M+IHdyb3RlOg0KDQogICAgSGkgQXJ0dXJvLA0KICAgIA0KICAgIE9uIFdlZCwgRGVj
IDA0LCAyMDE5IGF0IDA2OjMxOjAyUE0gKzAxMDAsIEFydHVybyBCb3JyZXJvIEdvbnphbGV6IHdy
b3RlOg0KICAgID4gT24gMTIvNC8xOSA0OjU2IFBNLCBQaGlsIFN1dHRlciB3cm90ZToNCiAgICA+
ID4gT0ssIHN0YXRpYyBsb2FkLWJhbGFuY2luZyBiZXR3ZWVuIHR3byBzZXJ2aWNlcyAtIG5vIGJp
ZyBkZWFsLiA6KQ0KICAgID4gPiANCiAgICA+ID4gV2hhdCBoYXBwZW5zIGlmIGNvbmZpZyBjaGFu
Z2VzPyBJLmUuLCBpZiBvbmUgb2YgdGhlIGVuZHBvaW50cyBnb2VzIGRvd24NCiAgICA+ID4gb3Ig
YSB0aGlyZCBvbmUgaXMgYWRkZWQ/IChUaGF0J3MgdGhlIHRoaW5nIHdlJ3JlIGRpc2N1c3Npbmcg
cmlnaHQgbm93LA0KICAgID4gPiBhcmVuJ3Qgd2U/KQ0KICAgID4gDQogICAgPiBpZiB0aGUgbm9u
LWFub24gbWFwIGZvciByYW5kb20gbnVtZ2VuIHdhcyBhbGxvd2VkLCB0aGVuIG9ubHkgZWxlbWVu
dHMgd291bGQgbmVlZA0KICAgID4gdG8gYmUgYWRqdXN0ZWQ6DQogICAgPiANCiAgICA+IGRuYXQg
bnVtZ2VuIHJhbmRvbSBtb2QgMTAwIG1hcCB7IDAtNDkgOiAxLjEuMS4xLCA1MC05OSA6IDIuMi4y
LjIgfQ0KICAgID4gDQogICAgPiBZb3UgY291bGQgYWx3YXlzIHVzZSBtb2QgMTAwIChvciAxMDAw
MCBpZiB5b3Ugd2FudCkgYW5kIGp1c3QgcGxheSB3aXRoIHRoZSBtYXANCiAgICA+IHByb2JhYmls
aXRpZXMgYnkgdXBkYXRpbmcgbWFwIGVsZW1lbnRzLiBUaGlzIGlzIGEgdmFsaWQgdXNlIGNhc2Ug
SSB0aGluay4NCiAgICA+IFRoZSBtb2QgbnVtYmVyIGNhbiBqdXN0IGJlIHRoZSBtYXggbnVtYmVy
IG9mIGFsbG93ZWQgZW5kcG9pbnRzIHBlciBzZXJ2aWNlIGluDQogICAgPiBrdWJlcm5ldGVzLg0K
ICAgID4gDQogICAgPiBAUGhpbCwNCiAgICA+IA0KICAgID4gSSdtIG5vdCBzdXJlIGlmIHRoZSB0
eXBlb2YoKSB0aGluZ3kgd2lsbCB3b3JrIGluIHRoaXMgY2FzZSwgc2luY2UgdGhlIGludGVnZXIN
CiAgICA+IGxlbmd0aCB3b3VsZCBkZXBlbmQgb24gdGhlIG1vZCB2YWx1ZSB1c2VkLg0KICAgID4g
V2hhdCBhYm91dCBpbnRyb2R1Y2luZyBzb21ldGhpbmcgbGlrZSBhbiBleHBsaWNpdCB1MTI4IGlu
dGVnZXIgZGF0YXR5cGUuIFBlcmhhcHMNCiAgICA+IGl0J3MgdXNlZnVsIGZvciBvdGhlciB1c2Ug
Y2FzZXMgdG9vLi4uDQogICAgDQogICAgT3V0IG9mIGN1cmlvc2l0eSBJIGltcGxlbWVudGVkIHRo
ZSBiaXRzIHRvIHN1cHBvcnQgdHlwZW9mIGtleXdvcmQgaW4NCiAgICBwYXJzZXIgYW5kIHNjYW5u
ZXIuIEl0J3MgYSBiaXQgY2x1bXN5LCBidXQgaXQgd29ya3MuIEkgY2FuIGRvOg0KICAgIA0KICAg
IHwgbmZ0IGFkZCBtYXAgdCBtMiAneyB0eXBlIHR5cGVvZiBudW1nZW4gcmFuZG9tIG1vZCAyIDog
dmVyZGljdDsgfScNCiAgICANCiAgICAoVGhlICdyYW5kb20gbW9kIDInIHBhcnQgaXMgaWdub3Jl
ZCwgYnV0IG5lZWRlZCBhcyBvdGhlcndpc2UgaXQncyBub3QgYQ0KICAgIHByaW1hcnlfZXhwci4g
OkQpDQogICAgDQogICAgVGhlIG91dHB1dCBpczoNCiAgICANCiAgICB8IHRhYmxlIGlwIHQgew0K
ICAgIHwgCW1hcCBtMiB7DQogICAgfCAJCXR5cGUgaW50ZWdlciA6IHZlcmRpY3QNCiAgICB8IAl9
DQogICAgfCB9DQogICAgDQogICAgU28gaW50ZWdlciBzaXplIGluZm9ybWF0aW9uIGlzIGxvc3Qs
IHRoaXMgd29uJ3Qgd29yayB3aGVuIGZlZCBiYWNrLg0KICAgIFRoZXJlIGFyZSB0d28gb3B0aW9u
cyB0byBzb2x2ZSB0aGlzOg0KICAgIA0KICAgIEEpIFB1c2ggZXhwcmVzc2lvbiBpbmZvIGludG8g
a2VybmVsIHNvIHdlIGNhbiBjb3JyZWN0bHkgZGVzZXJpYWxpemUgdGhlDQogICAgICAgb3JpZ2lu
YWwgaW5wdXQuDQogICAgDQogICAgQikgQXMgeW91IHN1Z2dlc3RlZCwgaGF2ZSBzb21ldGhpbmcg
bGlrZSAnaW50MzInIG9yIG1heWJlIGJldHRlciAnaW50KDMyKScuDQogICAgDQogICAgSSBjb25z
aWRlciAoQikgdG8gYmUgd2F5IGxlc3MgdWdseS4gQW5kIGlmIHdlIHdlbnQgdGhhdCByb3V0ZSwg
d2UgY291bGQNCiAgICBhY3R1YWxseSB1c2UgdGhlICdpbnQzMicvJ2ludCgzMiknIHRoaW5nIGlu
IHRoZSBmaXJzdCBwbGFjZS4gQWxsIHVzZXJzDQogICAgaGF2ZSB0byBrbm93IGlzIGhvdyBsYXJn
ZSBpcyAnbnVtZ2VuJyBkYXRhIHR5cGUuIE9yIHdlJ3JlIGV2ZW4gc21hcnQNCiAgICBoZXJlLCB0
YWtpbmcgaW50byBhY2NvdW50IHRoYXQgc3VjaCBhIG1hcCBtYXkgYmUgdXNlZCB3aXRoIGRpZmZl
cmVudA0KICAgIGlucHV0cyBhbmQgbWFzayBpbnB1dCB0byBmaXQgbWFwIGtleSBzaXplLiBJSVJD
LCB3ZSBtYXkgZXZlbiBoYXZlIGhhZA0KICAgIHRoaXMgZGlzY3Vzc2lvbiBpbiBhbiBpbmNvbnZl
bmllbnRseSBjb2xkIHJvb20gaW4gTWFsYWdhIG9uY2UuIDopDQogICAgDQogICAgPiBAU2VyZ3Vl
aSwNCiAgICA+IA0KICAgID4ga3ViZXJuZXRlcyBpbXBsZW1lbnRzIGEgY29tcGxleCBjaGFpbiBv
ZiBtZWNoYW5pc21zIHRvIGRlYWwgd2l0aCB0cmFmZmljLiBXaGF0DQogICAgPiBoYXBwZW5zIGlm
IGVuZHBvaW50cyBmb3IgYSBnaXZlbiBzdmMgaGF2ZSBkaWZmZXJlbnQgcG9ydHM/IEkgZG9uJ3Qg
a25vdyBpZg0KICAgID4gdGhhdCdzIHN1cHBvcnRlZCBvciBub3QsIGJ1dCB0aGVuIHRoaXMgYXBw
cm9hY2ggd291bGRuJ3Qgd29yayBlaXRoZXI6IHlvdSBjYW4ndA0KICAgID4gdXNlIGRuYXQgbnVt
Z2VuIHJhbmRtbyB7IDAtNDkgOiA8aXA+Ojxwb3J0PiB9Lg0KICAgID4gDQogICAgPiBBbHNvLCB3
ZSBoYXZlIHRoZSBtYXNxdWVyYWRlL2Ryb3AgdGhpbmcgZ29pbmcgb24gdG9vLCB3aGljaCBuZWVk
cyB0byBiZSBkZWFsDQogICAgPiB3aXRoIGFuZCB0aGF0IGN1cnJlbnRseSBpcyBkb25lIGJ5IHll
dCBhbm90aGVyIGNoYWluIGp1bXAgKyBwYWNrZXQgbWFyay4NCiAgICA+IA0KICAgID4gSSdtIG5v
dCBzdXJlIGluIHdoaWNoIHN0YXRlIG9mIHRoZSBkZXZlbG9wbWVudCB5b3UgYXJlLCBidXQgdGhp
cyBpcyBteQ0KICAgID4gc3VnZ2VzdGlvbjogVHJ5IHRvIGRvbid0IG92ZXItb3B0aW1pemUgaW4g
dGhlIGZpcnN0IGl0ZXJhdGlvbi4gSnVzdCBnZXQgYQ0KICAgID4gd29ya2luZyBuZnQgcnVsZXNl
dCB3aXRoIHRoZSBmZXcgb3B0aW1pemF0aW9uIHRoYXQgbWFrZSBzZW5zZSBhbmQgYXJlIGVhc3kg
dG8NCiAgICA+IHVzZSAoYW5kIHVuZGVyc3RhbmQpLiBGb3IgaXRlcmF0aW9uICMyIHdlIGNhbiBk
byBiZXR0ZXIgb3B0aW1pemF0aW9ucywgaW5jbHVkaW5nDQogICAgPiBwYXRjaGluZyBtaXNzaW5n
IGZlYXR1cmVzIHdlIG1heSBoYXZlIGluIG5mdGFibGVzLg0KICAgID4gSSByZWFsbHkgd2FudCBh
IHJ1bGVzZXQgd2l0aCB2ZXJ5IGxpdHRsZSBydWxlcywgYnV0IHdlIGFyZSBzdGlsbCBjb21wYXJp
bmcgd2l0aA0KICAgID4gdGhlIGlwdGFibGVzIHJ1bGVzZXQuIEkgc3VnZ2VzdCB3ZSBsZWF2ZSB0
aGUgaGFyZCBvcHRpbWl6YXRpb24gZm9yIGEgbGF0ZXIgcG9pbnQNCiAgICA+IHdoZW4gd2UgYXJl
IGNvbXBhcmluZyBuZnQgdnMgbmZ0IHJ1bGVzZXRzLg0KICAgIA0KICAgICsxIGZvciBvcHRpbWl6
ZSBub3QgKHlldCkuIEF0IGxlYXN0IHRoZXJlJ3MgYSBjZXJ0YWluIGNoYW5jZSB0aGF0IHdlJ3Jl
DQogICAgc3BlbmRpbmcgbXVjaCBlZmZvcnQgaW50byBvcHRpbWl6aW5nIGEgcGF0aCB3aGljaCBp
c24ndCBldmVuIHRoZQ0KICAgIGJvdHRsZW5lY2sgbGF0ZXIuDQogICAgDQogICAgQ2hlZXJzLCBQ
aGlsDQogICAgDQoNCg==
