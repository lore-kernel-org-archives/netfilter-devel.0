Return-Path: <SRS0=M/8g=ZS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCC5C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 14:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 872EF20727
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 14:37:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="XajLYwR4";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="VP6oRSgf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfKZOhb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Nov 2019 09:37:31 -0500
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:47612 "EHLO
        rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfKZOha (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 09:37:30 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Nov 2019 09:37:30 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1812; q=dns/txt; s=iport;
  t=1574779050; x=1575988650;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iGnDLMWLm2C5HWmKbNkjGCONYqMxXLlW7AiGaM2+Xj4=;
  b=XajLYwR49pc27FJ5nE+ROGUP97ujhyaFFUwKIoEIonJQQmrsx9zExLBN
   4xnmAt0pWGFzlfwpCoqWdu/bdOy0PImqKVwc9V8TAUzD3Jil2WopfDED6
   3FSS/7YkrDlOTrxIhiQiZ49HlEP9beJ+qpmqgLawP2mm/NBZR6vMnpNkk
   g=;
IronPort-PHdr: =?us-ascii?q?9a23=3A5B/oLxKeLp558lbnodmcpTVXNCE6p7X5OBIU4Z?=
 =?us-ascii?q?M7irVIN76u5InmIFeBvKd2lFGcW4Ld5roEkOfQv636EU04qZea+DFnEtRXUg?=
 =?us-ascii?q?Mdz8AfngguGsmAXFbxIez0YjY5NM9DT1RiuXq8NBsdFQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0ApAABfNt1d/4wNJK1kGgEBAQEBAQE?=
 =?us-ascii?q?BAQMBAQEBEQEBAQICAQEBAYFtAgEBAQELAYFKUAWBRCAECyoKhCGDRgOKboJ?=
 =?us-ascii?q?fmASCUgNUCQEBAQwBAS0CAQGEQAIXgV8kNwYOAgMNAQEEAQEBAgEFBG2FNwy?=
 =?us-ascii?q?FUwEBAQMSEREMAQE3AQ8CAQgOCgICJgICAjAVEAIEDgUigwCCRwMuAQKndwK?=
 =?us-ascii?q?BOIhgdYEygn4BAQWFDxiCFwmBDigBhRqGexqBQD+BEScggh4uPoRggnkygiy?=
 =?us-ascii?q?QF54hCoIslVYbgj+Haos2hD6oWgIEAgQFAg4BAQWBaCOBWHAVZQGCQVARFIZ?=
 =?us-ascii?q?Ig3OKU3SBKI04AYEOAQE?=
X-IronPort-AV: E=Sophos;i="5.69,246,1571702400"; 
   d="scan'208";a="583892188"
Received: from alln-core-7.cisco.com ([173.36.13.140])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 26 Nov 2019 14:30:15 +0000
Received: from XCH-ALN-008.cisco.com (xch-aln-008.cisco.com [173.36.7.18])
        by alln-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id xAQEU5VH006486
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 26 Nov 2019 14:30:14 GMT
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by XCH-ALN-008.cisco.com
 (173.36.7.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Nov
 2019 08:30:04 -0600
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by xhs-rcd-003.cisco.com
 (173.37.227.248) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Nov
 2019 08:30:04 -0600
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-001.cisco.com (64.101.210.228) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Nov 2019 09:30:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbWrc0CiwqicEobTDLMn99Anpx1KJM2DJq5iPhGHxlsqfQ7G1tdZpdcKbRpGpZzts3FEC3xvXZj/Q+SoTi2+LItAwSNwNfYcgq+0JOJHak7r/AkbpvQS6LRzp6V4QYuEPk+bsLJXwpUZwqPwdcX2e1etrt1ME3NVIIvMZHldNC0L3ddVo+L6sc374yTPaO3rY50sb5rStmHlsHE6EskCRalNW3P/+Bjp9WzDT8bvP5AxPhQIJfTqhdssaJgsE2O4X/FybGnkWXgmKk7iRMJGIAaUfXbjV6VYXcTTJJYK2YfkbsFETbxpn3pM+KGvF2l2cL3GrTZlyi3t5wHilZlO5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGnDLMWLm2C5HWmKbNkjGCONYqMxXLlW7AiGaM2+Xj4=;
 b=XP7br3fwg1iV+YGCejoO2MnfF6fetOuW9O8CLEbDa3btrUPp+dKtma/gU45S1efLuNL2aomj7Kzydg8zAo/m0RtDhU1YeTS5VPGvSzqy0NyOpNP8oHcMfd41Fk0f7WtA+ahw5b2mWEqRq069tm0i+TGj/mgsZnSixVCHTUyCLTMRIyRDz/wZb5PgXbglBSYn/cR5OEREBqosGtYnJeEtenFjYBIOjMFs0SWFGVQG59sVJl+hfnf4DVRR9jKuyWiMOX+Senayrxygl0cT2quPRk4wNEBM6BtYw1VBEDPqS/QGFrGkkjQpC8R5G5Ef9NbT2uBdaQ6/xeAGfYwhmOQslA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGnDLMWLm2C5HWmKbNkjGCONYqMxXLlW7AiGaM2+Xj4=;
 b=VP6oRSgfHH5Jy7P2B/sFlqslTf8wnNQs8SUQhKz+apDWskYXHhwrlV53eFrT/BDS1ON9kntvDfb/PCN2MlExbiSaPhCnYuN9SUJlq8XDVES/7z1mbp4or3IOpDDJIxi5eT0DaC1u7COaRqqaKi12Qwv2EcEILzwGLWrrFe+bqjw=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB3120.namprd11.prod.outlook.com (52.135.127.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Tue, 26 Nov 2019 14:30:02 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d%7]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 14:30:02 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLts6edYHQA///QMAA=
Date:   Tue, 26 Nov 2019 14:30:02 +0000
Message-ID: <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
References: <5248B312-60A9-48A7-B4CF-E00D1BDF1CD2@cisco.com>
 <20191126122110.GD795@breakpoint.cc>
In-Reply-To: <20191126122110.GD795@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a54ecad-12e5-457e-fb3b-08d7727d1ff8
x-ms-traffictypediagnostic: SN6PR11MB3120:
x-microsoft-antispam-prvs: <SN6PR11MB3120C889D398A54E9E376949C4450@SN6PR11MB3120.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(189003)(199004)(66946007)(66446008)(4326008)(6916009)(66556008)(64756008)(66476007)(76116006)(91956017)(478600001)(102836004)(2906002)(33656002)(71200400001)(256004)(6116002)(71190400001)(3846002)(25786009)(305945005)(7736002)(76176011)(6506007)(8936002)(81156014)(81166006)(8676002)(86362001)(6486002)(6512007)(5660300002)(6436002)(11346002)(2616005)(66066001)(36756003)(229853002)(446003)(26005)(54906003)(186003)(6246003)(316002)(14454004)(99286004)(4001150100001)(58126008);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3120;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cbqepAWuOmWQOhCmUvd8wIwTitYkkUMabb4BFM0lcR5KQXBk4dynnimBSxsDdVwyMvQlQvuan2wtGWRgFFhHgTZWcI9GzEQF4HV5kLEYvgHevxZEhY9fQGxC7n8xpZAbbDM86L3yFthxmIxfGVB2jALDKfcdEtAXXbplqGoepuaBFTnLbZyvNWMDEjWaXh3AYD0EyALIm6KJIZ1WE3LK5canuPk4gkNVCJisVPJzQAXwVVmrXRO/+RGvNnqBtks/ADjrxKRMRjH3BSEQ/l41A/kQ0dCL5T2gZHseRfLnYJlZt9GBLB5WgbYSjKm/QF2R1qGC/2nEdEeN7QxRDNdEvetIIXxPElI+zgb6MY/TqwOu6hn6y0ZjRobVKHdt0+GVjQZ3Qo0QuDP8jvxDSc3mwENnMqXvgcetkgNGCMKPEVTPGb9MyAXLZFwQE3Hhlj/r
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0465809ECE34B441A126145B16940512@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a54ecad-12e5-457e-fb3b-08d7727d1ff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 14:30:02.7844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a63UiT5L8A94/FuPrXBYutCNkNDMdbQZfhoBDSf/GajhHW2x+7c5oCFrLMs727mArCCPspALn5JxrwBFNL1Bhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3120
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.18, xch-aln-008.cisco.com
X-Outbound-Node: alln-core-7.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8gRmxvcmlhbiwNCg0KVGhhbmsgeW91IHZlcnkgbXVjaCBmb3IgeW91ciByZXBseS4gT25j
ZSBJIGNoYW5nZWQgdG8gSW5wdXQgY2hhaW4gdHlwZSwgdGhlIHJ1bGUgd29ya2VkLiBJdCBzZWVt
cyBpcHRhYmxlcyBETyBhbGxvdyB0aGUgc2FtZSBydWxlIGNvbmZpZ3VyYXRpb24gc2VlIGJlbG93
Og0KDQotQSBQUkVST1VUSU5HIC1tIGNvbW1lbnQgLS1jb21tZW50ICJrdWJlcm5ldGVzIHNlcnZp
Y2UgcG9ydGFscyIgLWogS1VCRS1TRVJWSUNFUw0KLUEgS1VCRS1TRVJWSUNFUyAtZCA1Ny4xMzEu
MTUxLjE5LzMyIC1wIHRjcCAtbSBjb21tZW50IC0tY29tbWVudCAiZGVmYXVsdC9wb3J0YWw6cG9y
dGFsIGhhcyBubyBlbmRwb2ludHMiIC1tIHRjcCAtLWRwb3J0IDg5ODkgLWogUkVKRUNUIC0tcmVq
ZWN0LXdpdGggaWNtcC1wb3J0LXVucmVhY2hhYmxlDQoNClRoaXMgY29uZmlnIGlzIGZyb20gd29y
a2luZyBrdWJlcm5ldGVzIGNsdXN0ZXIgZm9yIHRoZSBzZXJ2aWNlIHdoaWNoIGhhcyBubyBlbmRw
b2ludHMuIERvIHlvdSBrbm93IGlmIHRoaXMgY2hhbmdlIGluIGJlaGF2aW9yIHdhcyBhIGRlc2ln
biBkZWNpc2lvbiBvciBpdCBpcyBhIGJ1Zz8NCg0KVGhhbmsgeW91DQpTZXJndWVpDQoNCg0K77u/
T24gMjAxOS0xMS0yNiwgNzoyMSBBTSwgIkZsb3JpYW4gV2VzdHBoYWwiIDxmd0BzdHJsZW4uZGU+
IHdyb3RlOg0KDQogICAgU2VyZ3VlaSBCZXp2ZXJraGkgKHNiZXp2ZXJrKSA8c2JlenZlcmtAY2lz
Y28uY29tPiB3cm90ZToNCiAgICA+IEhlbGxvIFBhYmxvLA0KICAgID4gDQogICAgPiBQbGVhc2Ug
c2VlIGJlbG93ICB0YWJsZS9jaGFpbi9ydWxlcy9zZXRzIEkgcHJvZ3JhbSwgIHdoZW4gSSB0cnkg
dG8gYWRkIGp1bXAgZnJvbSBpbnB1dC1uZXQsIGlucHV0LWxvY2FsIHRvIHNlcnZpY2VzICBpdCBm
YWlscyB3aXRoICIgT3BlcmF0aW9uIG5vdCBzdXBwb3J0ZWQiICwgSSB3b3VsZCBhcHByZWNpYXRl
IGlmIHNvbWVib2R5IGNvdWxkIGhlbHAgdG8gdW5kZXJzdGFuZCB3aHk6DQogICAgPiANCiAgICA+
IHN1ZG8gbmZ0IGFkZCBydWxlIGlwdjR0YWJsZSBpbnB1dC1uZXQganVtcCBzZXJ2aWNlcw0KICAg
ID4gRXJyb3I6IENvdWxkIG5vdCBwcm9jZXNzIHJ1bGU6IE9wZXJhdGlvbiBub3Qgc3VwcG9ydGVk
DQogICAgPiBhZGQgcnVsZSBpcHY0dGFibGUgaW5wdXQtbmV0IGp1bXAgc2VydmljZXMNCiAgICA+
IF5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl4NCiAgICANCiAgICBp
aXJjICJyZWplY3QiIG9ubHkgd29ya3MgaW4gaW5wdXQvZm9yd2FyZC9wb3N0cm91dGluZyBob29r
cy4NCiAgICANCg0K
