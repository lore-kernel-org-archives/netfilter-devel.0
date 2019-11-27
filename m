Return-Path: <SRS0=TrSD=ZT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BCAC432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F6A920674
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:36:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="CS6+nDuh";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="Yxr3SqRL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfK0OgM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:36:12 -0500
Received: from rcdn-iport-6.cisco.com ([173.37.86.77]:31239 "EHLO
        rcdn-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfK0OgM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 09:36:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=5140; q=dns/txt; s=iport;
  t=1574865371; x=1576074971;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=d4JavF1tu5qwMrwgxdEkUVX8f4UKQQvBBAVH8rPwPaE=;
  b=CS6+nDuhktkUhVFKz1cV9IR3fvSe1izKzdsC2qrLZqNGdqiEwU51nzkb
   hzdhS/6FdFCkS4VQmk6dJg4CKtU8ELqKRaGtWaJg27CJNs59Zz0VYxkxo
   JqeXVb4rQMM5dvK8mwmpSRgr6uf+28tOGdir4GckSWGnsePY6ywuG68nA
   k=;
IronPort-PHdr: =?us-ascii?q?9a23=3An4YoNxdo6/oSX9yuCbbzgC8glGMj4e+mNxMJ6p?=
 =?us-ascii?q?chl7NFe7ii+JKnJkHE+PFxlwGQD57D5adCjOzb++D7VGoM7IzJkUhKcYcEFn?=
 =?us-ascii?q?pnwd4TgxRmBceEDUPhK/u/dCY3DtpPTlxN9HCgOk8TE8H7NBXf?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CAAADViN5d/4oNJK1LGhkBAQEBAQE?=
 =?us-ascii?q?BAQEBAQEBAQEBAREBAQEBAQEBAQEBAYF+gUtQBWxYIAQLKgqEIYNGA4pxgl+?=
 =?us-ascii?q?BAZcDglIDVAkBAQEMAQElCAIBAYRAAheBaSQ4EwIDDQEBBAEBAQIBBQRthTc?=
 =?us-ascii?q?MhVIBAQEBAgESEREMAQE3AQ8CAQgYAgImAgICMBUQAgQOBRQOgwABgkYDDiA?=
 =?us-ascii?q?BAgw6pmECgTiIYHWBMoJ+AQEFhR4YghcJgQ4ohRsRXIIbg3MagUE/gREnIII?=
 =?us-ascii?q?XBy4+gmQCAoFhF4J5MoIsj185niUKgi2HHY45G4JAc4Z4j3SWTDiRWAIEAgQ?=
 =?us-ascii?q?FAg4BAQWBaSI3gSFwFWUBgkEJCT4RFIZIg3OFFIU/dAGBJ4pWK4EEAYEPAQE?=
X-IronPort-AV: E=Sophos;i="5.69,249,1571702400"; 
   d="scan'208";a="673481547"
Received: from alln-core-5.cisco.com ([173.36.13.138])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 27 Nov 2019 14:36:10 +0000
Received: from XCH-ALN-003.cisco.com (xch-aln-003.cisco.com [173.36.7.13])
        by alln-core-5.cisco.com (8.15.2/8.15.2) with ESMTPS id xAREaAKd019532
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 27 Nov 2019 14:36:10 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-ALN-003.cisco.com
 (173.36.7.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Nov
 2019 08:36:09 -0600
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Nov
 2019 08:36:08 -0600
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 27 Nov 2019 08:36:08 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgUsE2NyNzHsvi/6tiQOIWkVSjXSPym8UklltXODdpTlvfRCp0dUb1MQVnlSYgJF/p9Bsd2prPkLG1QqFDXb46gdL2IbFoXUsJhrXSvEKID0xh2Xpb//c0Wt1CtT/dxirXDxt3LrmpyFixw8pz+4UunpuIHXCmAGzoxvSgRQVPvaHImPVIkHW80nzFUwGTBP24R3d/thnu9ApcpLWxt//WQFFuqFoHmq2+fpvaDZrx2+MR5J+ZiZB3JpsX81VKdsvbUC3yo6anbPliM2gYZ/8B4MYRA0HSongnGD+1n81Lq8mmhNlp+cbKC2MfP9goBhE4X3wZZ2CPNbp6d/k9NM7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4JavF1tu5qwMrwgxdEkUVX8f4UKQQvBBAVH8rPwPaE=;
 b=O16kzSeDhzG8QMdPCHpje2LcNMpSWEwa8Tu3k0WwPSteGslGsCLEgSAfIN8v/r8bv0aa5vg6jun+j7ZTD943r9LOAtxGesG6b1MypzjdB106/fTR2+4EovIFIKRw7rFznKxE4PN7Hy8KS3vO1DIYZyhOEA132aJT4I6MzAJlsCHh5Lr3+1lIIphkzAN28iKAPRT+R9KJp3iflGBuFibxz7c9+/7Ay1lDfZPK7yWGutK3urq0WCknLN1J4HpC3FiowRWUp0tpou4r8T3+KHVuvmJq+hnpixyy3Hi3VelUQDd/KJE9VC5YIQlN7NwFUghhLb+ztPu48iyhDLWpThaBSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4JavF1tu5qwMrwgxdEkUVX8f4UKQQvBBAVH8rPwPaE=;
 b=Yxr3SqRLvkS6o5By1cK7+h7n+IOmKMAcDa7/njlI/6DZ7DPA1SMmOaTgJZJTPmaItEPVgk3FrhfxizdDhYXpPlGNwsqle1pKqyDW09PRpc1xPvegWHIZfJhJcmT3kXrOfxY//eAwdC3ziqgaASqnRW6cCYCfsZWBWBT5uDn8CVs=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 27 Nov 2019 14:36:07 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d%7]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 14:36:07 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
CC:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Laura Garcia <nevola@gmail.com>
Subject: Re: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLts6edYHQA///QMACAAGcLAP//rq8AgABU1YD//91EAAAL5rgA///LmgCAAStKAP//9huA
Date:   Wed, 27 Nov 2019 14:36:07 +0000
Message-ID: <89C24159-37F8-4D2F-B391-8A1D6AE403E7@cisco.com>
References: <5248B312-60A9-48A7-B4CF-E00D1BDF1CD2@cisco.com>
 <20191126122110.GD795@breakpoint.cc>
 <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
 <20191126153850.pblaoj4xklfz5jgv@salvia>
 <427E92A6-2FFA-47CF-BF3B-C08961C978C9@cisco.com>
 <20191126155125.GD8016@orbyte.nwl.cc>
 <0A92D5EA-B158-4C7A-B85C-1692AE7C828B@cisco.com>
 <20191126192752.GE8016@orbyte.nwl.cc>
 <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
 <3a457e5b-be8f-e99d-fb0d-4826a15a4a55@netfilter.org>
In-Reply-To: <3a457e5b-be8f-e99d-fb0d-4826a15a4a55@netfilter.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [24.200.205.158]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 268f7193-b2ec-446c-dccd-08d7734723b6
x-ms-traffictypediagnostic: SN6PR11MB3358:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <SN6PR11MB33584B60D1573130B3041B8BC4440@SN6PR11MB3358.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(189003)(199004)(2906002)(5660300002)(256004)(33656002)(14444005)(26005)(186003)(2616005)(6506007)(25786009)(446003)(11346002)(14454004)(347745004)(71200400001)(71190400001)(76176011)(966005)(478600001)(91956017)(76116006)(53546011)(7736002)(66476007)(6486002)(66556008)(64756008)(66446008)(102836004)(66946007)(305945005)(229853002)(554214002)(36756003)(6246003)(66066001)(6116002)(3846002)(4326008)(6916009)(6436002)(8676002)(6512007)(6306002)(81156014)(81166006)(8936002)(316002)(58126008)(86362001)(99286004)(4001150100001)(16799955002)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3358;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OUQdqPbEOrFBxi1N/zggITN1AjlALa+NKG67J/R4bsSFOlBakV1ZwYqqIPjeGRc3SvsJg8H6GHUkTAdhdnFLongUHjyXQmO+BY9lTQYnN/EYSbNptH4x6pps154DX/HSuEYHpYl/1RtKF4SisJwSOnZvTvKZDoNYUfI26Lr6faXpNq0/xzKoV1BtPRvjHqGOVUfzI+v7pMtLRSLN7Nybloau77XxfXWOQx9AHxoJG4QR8tLu5Ui8wDRehEhqnQK+Arv6B2LOV5/77Lu7F1dhGFqZ+OhU9jxe981FkWaP+nQbuP77vQQAxUSLUlh+VLrdsQh1TPXmelRG5ktQYqnSiXwWGl/DUrN4JyrNmm9aPOn5/W8y5d3gjEYMkHTWK0AMYswYTbu7s60yK8G9p6DuTYk6bNIeA2H++1vcokk+Po2LS1LMAVaorxesFTtpParqwdqG+LbeS4rx/CQGosHlDNf2t6quV8wv1bheWumwd3g=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F739785F0174E14FA71DA952CBB73C93@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 268f7193-b2ec-446c-dccd-08d7734723b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 14:36:07.2974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y8+msAahw6gj3aIY8suHnl7KqA4OF9hglJpf8jjHoovnNxIrPylpjX/be/YJfhe+oiYzo7rC+fO+lw7WaSbjjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3358
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.13, xch-aln-003.cisco.com
X-Outbound-Node: alln-core-5.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8gQXJ0dXJvLA0KDQpUaGFua3MgYSBsb3QgZm9yIHlvdXIgcmVwbHksIG15IHVsdGltYXRl
IGdvYWwgaXMgdG8gZGV2ZWxvcCBrdWJlLXByb3h5IHdoaWNoIGlzIGJ1aWxkaW5nICBuZnRhYmxl
cyBydWxlcyBpbnN0ZWFkIG9mIGlwdGFibGVzLCBpbiBhZGRpdGlvbiB0aGUgZ29hbCBpcyB0byB1
c2UgZGlyZWN0IEFQSSBjYWxscyB0byBuZXRsaW5rIHdpdGhvdXQgYW55IGV4dGVybmFsIGRlcGVu
ZGVuY2llcyBhbmQgb2YgY291cnNlIHRvIHRyeSB0byBsZXZlcmFnZSBuZnRhYmxlcycgYWR2YW5j
ZWQgZmVhdHVyZXMgdG8gYWNoaWV2ZSB0aGUgYmVzdCBwZXJmb3JtYW5jZS4NCg0KSSBhbSBpbiB0
aGUgcHJvY2VzcyBvZiBpZGVudGlmeWluZyBnYXBzIGluIGZ1bmN0aW9uYWxpdHkgYXZhaWxhYmxl
IGluIGdpdGh1Yi5jb20vZ29vZ2xlL25mdGFibGVzIGFuZCBnaXRodWIuY29tL3NiZXp2ZXJrL25m
dGFibGVzbGliIGxpYnJhcmllcywgZXhhbXBsZSB5ZXN0ZXJkYXkgSSBmb3VuZCBvdXQgdGhhdCBu
ZWl0aGVyIG9mIHRoZXNlIGxpYnJhcmllcyBzdXBwb3J0cyAibnVtZ2VuIiwgd2hpY2ggd291bGQg
YmUgYSBtYW5kYXRvcnkgZmVhdHVyZSB0byBzdXBwb3J0IGxvYWQgYmFsYW5jaW5nIGJldHdlZW4g
c2VydmljZSdzIG11bHRpcGxlIGVuZCBwb2ludHMuICBJIHdpbGwgaGF2ZSB0byBhZGQgaXQgdG8g
Ym90aCB0byBiZSBhYmxlIHRvIG1vdmUgZm9yd2FyZC4NCkkgdXNlIGlwdGFibGVzIGZyb20gYSB3
b3JraW5nIGNsdXN0ZXIgYW5kIHRyeSB0byBidWlsZCBhIGNvZGUgd2hpY2ggd291bGQgcHJvZ3Jh
bSBuZnRhYmxlcyB0aGUgc2FtZSB3YXkgKHdpdGggb3B0aW1pemF0aW9uKS4gT25jZSBpdCBpcyBk
b25lLCB0aGVuIGl0IGNhbiBiZSBhcnJhbmdlZCBpbnRvIGEgY29udHJvbGxlciBsaXN0ZW5pbmcg
Zm9yIHN2Yy9lbmRwb2ludHMgYW5kIHByb2dyYW0gIGludG8gbmZ0YWJsZXMgYWNjb3JkaW5nbHku
DQoNCkkgYW0gbG9va2luZyBmb3IgcGVvcGxlIGludGVyZXN0ZWQgaW4gdGhlIHNhbWUgdG9waWMg
dG8gYmUgYWJsZSB0byBkaXNjdXNzIGRpZmZlcmVudCBhcHByb2FjaGVzLCBsaWtlIGl0IHdhcyBk
b25lIHllc3RlcmRheSB3aXRoIFBoaWwgYW5kIHNlbGVjdCB0aGUgYmVzdCBhcHByb2FjaCB0byBt
YWtlIG5mdGFibGVzIHRvIHNoaW5lICgNCg0KUGxlYXNlIGxldCBtZSBrbm93IGlmIHlvdSBhcmUg
aW50ZXJlc3RlZCBpbiBmdXJ0aGVyIGRpc2N1c3Npb25zLg0KDQpUaGFuayB5b3UNClNlcmd1ZWkN
Cg0K77u/T24gMjAxOS0xMS0yNywgNToxMiBBTSwgIkFydHVybyBCb3JyZXJvIEdvbnphbGV6IiA8
YXJ0dXJvQG5ldGZpbHRlci5vcmc+IHdyb3RlOg0KDQogICAgT24gMTEvMjYvMTkgMTA6MjAgUE0s
IFNlcmd1ZWkgQmV6dmVya2hpIChzYmV6dmVyaykgd3JvdGU6DQogICAgPiAgICAgT24gVHVlLCBO
b3YgMjYsIDIwMTkgYXQgMDY6NDc6MDlQTSArMDAwMCwgU2VyZ3VlaSBCZXp2ZXJraGkgKHNiZXp2
ZXJrKSB3cm90ZToNCiAgICA+ICAgICA+IE9rLCBJIGd1ZXNzIEkgd2lsbCB3b3JrIGFyb3VuZCBi
eSB1c2luZyBpbnB1dCBhbmQgb3V0cHV0IGNoYWluIHR5cGVzLCBldmVuIHRob3VnaCBpdCB3aWxs
IHJhaXNlIHNvbWUgYnJvd3MgaW4gazhzIG5ldHdvcmtpbmcgY29tbXVuaXR5Lg0KICAgID4gICAg
ID4gDQogICAgDQogICAgQFNlcmdlaSwgdGhhbmtzIGZvciByZWFjaGluZyBvdXQgYWJvdXQgdGhp
cyB0b3BpYy4NCiAgICANCiAgICBJJ20gdXNpbmcgazhzIGEgbG90IGxhdGVseSBhbmQgd291bGQg
YmUgaW50ZXJlc3RlZCBpbiBrbm93aW5nIG1vcmUgYWJvdXQgd2hhdA0KICAgIHlvdSBhcmUgdHJ5
aW5nIHRvIGRvIHdpdGgga3ViZXJuZXRlcyBhbmQgbmZ0YWJsZXMuDQogICAgDQogICAgSW4gYW55
IGNhc2UsIGlmIHRoZSBzb21lYm9keSBpbiBrdWJlcm5ldGVzIGlzIHBsYW5uaW5nIHRvIGludHJv
ZHVjZSBuZnQgZm9yDQogICAga3ViZS1wcm94eSBvciBvdGhlciBjb21wb25lbnQsIEkgd291bGQg
c3VnZ2VzdCB0aGUgZ2VuZXJhdGVkIHJ1bGVzZXQgaXMNCiAgICB2YWxpZGF0ZWQgaGVyZSB0byBy
ZWFsbHkgYmVuZWZpdCBmcm9tIG5mdGFibGVzLiBJcyB0aGlzIHdoYXQgeW91IGFyZSBkb2luZywg
cmlnaHQ/DQogICAgDQogICAgUmVjZW50bHkgSSBoYWQgdGhlIGNoYW5jZSB0byBhdHRlbmQgYSB0
YWxrIGJ5IEBMYXVyYSAoaW4gQ0MpIGFib3V0IHRoZSBpcHRhYmxlcw0KICAgIHJ1bGVzZXQgZ2Vu
ZXJhdGVkIGJ5IGRvY2tlciBhbmQga3ViZS1wcm94eS4gU3VjaCBydWxlc2V0cyBhcmUgdGhlIG9w
cG9zaXRlIG9mDQogICAgc29tZXRoaW5nIG1lYW50IHRvIHNjYWxlIGFuZCBwZXJmb3JtIHdlbGwu
IFRoZW4gcGVvcGxlIGNvbXBhcmUgc3VjaCBydWxlc2V0cw0KICAgIHdpdGggb3RoZXIgbmV0d29y
a2luZyBzZXR1cHMuLi4gYW5kIHVuZmFpciBjb21wYXJlLg0KICAgIA0KICAgIFdvcnRoIG1lbnRp
b25pbmcgYXQgdGhpcyBwb2ludCB0aGlzIFBvQyB0b286DQogICAgDQogICAgaHR0cHM6Ly9naXRo
dWIuY29tL3pldmVuZXQva3ViZS1uZnRsYg0KICAgIA0KICAgIFRyeWluZyB0byBtaW1pYyAxOjEg
d2hhdCBpcHRhYmxlcyB3YXMgZG9pbmcgaXMgYSBtaXN0YWtlIGZyb20gbXkgcG9pbnQgb2Ygdmll
dy4NCiAgICBJIGJlbGlldmUgeW91IGFyZSBhd2FyZSBvZiB0aGlzIGFscmVhZHkgOi0pDQogICAg
DQogICAgPiAgICAgDQogICAgPiAgICAgS2VlcGluZyBib3RoIHRhcmdldCBhZGRyZXNzIGFuZCBw
b3J0IGluIGEgc2luZ2xlIG1hcCBmb3IgKk5BVCBzdGF0ZW1lbnRzDQogICAgPiAgICAgaXMgbm90
IHBvc3NpYmxlIEFGQUlLLg0KICAgIA0KICAgIEBQaGlsLCBJIHRoaW5rIGl0IGlzIHBvc3NpYmxl
ISBleGFtcGxlcyBpbiB0aGUgd2lraToNCiAgICANCiAgICBodHRwczovL3dpa2kubmZ0YWJsZXMu
b3JnL3dpa2ktbmZ0YWJsZXMvaW5kZXgucGhwL011bHRpcGxlX05BVHNfdXNpbmdfbmZ0YWJsZXNf
bWFwcw0KICAgIA0KICAgIEl0IHdvdWxkIGJlIHNvbWV0aGluZyBsaWtlOg0KICAgIA0KICAgICUg
bmZ0IGFkZCBydWxlIG5hdCBwcmVyb3V0aW5nIGRuYXQgXA0KICAgICAgICAgIHRjcCBkcG9ydCBt
YXAgeyAxMDAwIDogMS4xLjEuMSwgMjAwMCA6IDIuMi4yLjIsIDMwMDAgOiAzLjMuMy4zfSBcDQog
ICAgICAgICAgOiB0Y3AgZHBvcnQgbWFwIHsgMTAwMCA6IDEyMzQsIDIwMDAgOiAyMzQ1LCAzMDAw
IDogMzQ1NiB9DQogICAgDQogICAgDQogICAgPiAgICAgDQogICAgPiAgICAgSWYgSSdtIG5vdCBt
aXN0YWtlbiwgeW91IG1pZ2h0IGJlIGFibGUgdG8gaG9vayB1cCBhIHZtYXAgdG9nZXRoZXIgd2l0
aA0KICAgID4gICAgIHRoZSBudW1nZW4gZXhwcmVzc2lvbiBhYm92ZSBsaWtlIHNvOg0KICAgID4g
ICAgIA0KICAgID4gICAgIHwgbnVtZ2VuIHJhbmRvbSBtb2QgMHgyIHZtYXAgeyBcDQogICAgPiAg
ICAgfAkweDA6IGp1bXAgS1VCRS1TRVAtRlMzRlVVTEdaUFZENFZZQiwgXA0KICAgID4gICAgIHwJ
MHgxOiBqdW1wIEtVQkUtU0VQLU1NRlpST1FTTFEzREtPUUEgfQ0KICAgID4gICAgIA0KICAgID4g
ICAgIFB1cmUgc3BlY3VsYXRpb24sIHRob3VnaC4gOikNCiAgICA+ICAgICANCiAgICANCiAgICBU
aGlzIHdvcmtzIGluZGVlZC4gSnVzdCBhZGRlZCB0aGUgZXhhbXBsZSB0byB0aGUgd2lraToNCiAg
ICANCiAgICBodHRwczovL3dpa2kubmZ0YWJsZXMub3JnL3dpa2ktbmZ0YWJsZXMvaW5kZXgucGhw
L0xvYWRfYmFsYW5jaW5nI1JvdW5kX1JvYmluDQogICAgDQogICAgDQogICAgDQoNCg==
