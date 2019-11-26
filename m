Return-Path: <SRS0=M/8g=ZS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D08EDC432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 18:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8314320835
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 18:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="VJoe3FLZ";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="naHh2TFu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfKZSrO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Nov 2019 13:47:14 -0500
Received: from alln-iport-7.cisco.com ([173.37.142.94]:3622 "EHLO
        alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfKZSrN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 13:47:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3068; q=dns/txt; s=iport;
  t=1574794032; x=1576003632;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=stfxjQQbrUbrOyllKCZ8GFW5xf3Xatubl1c1ucXFbhU=;
  b=VJoe3FLZu7ytEXkrGAnZchAam6L0V6AJfyTUngLJxjjKpVTgMToBd94g
   lPrjaBGXN5qPh/lIWmoVxutWwh7RckE/CYznjzLW/QhQOYyIYOHf7mWGW
   JTApCMPkDUM5W+XJzqdBEx2S7SSDgDFDneZfMIw4mt1DRRwMER94s3CGZ
   A=;
IronPort-PHdr: =?us-ascii?q?9a23=3AeCXCExWxKnYlFAMph2d6x3ca1BbV8LGuZFwc94?=
 =?us-ascii?q?YnhrRSc6+q45XlOgnF6O5wiEPSA9yJ8OpK3uzRta2oGXcN55qMqjgjSNRNTF?=
 =?us-ascii?q?dE7KdehAk8GIiAAEz/IuTtankhFslQSlJ//FmwMFNeH4D1YFiB6nA=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DFDABGct1d/4YNJK1hAxsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgX6BS04CBWxYIAQLKgqEIYNGA4pwgl+BAZcDglIDVAk?=
 =?us-ascii?q?BAQEMAQEtAgEBhEACF4FfJDgTAgMNAQEEAQEBAgEFBG2FNwyFUwEBAQMSERE?=
 =?us-ascii?q?MAQE3AQ8CAQgYAgImAgICMBUQAgQOBRQOgwABgkYDLgECqA8CgTiIYHWBMoJ?=
 =?us-ascii?q?+AQEFhRkYghcJgQ4ojBYagUA/gRABJyCCFwcuPoRJFwomgkkygiyQF54hCoI?=
 =?us-ascii?q?slVYbgj+Hao90qFoCBAIEBQIOAQEFgWkigVhwFWUBgkFQERSGSAwXg1CKU3S?=
 =?us-ascii?q?BKI04AYEOAQE?=
X-IronPort-AV: E=Sophos;i="5.69,246,1571702400"; 
   d="scan'208";a="371450868"
Received: from alln-core-12.cisco.com ([173.36.13.134])
  by alln-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 26 Nov 2019 18:47:12 +0000
Received: from XCH-ALN-005.cisco.com (xch-aln-005.cisco.com [173.36.7.15])
        by alln-core-12.cisco.com (8.15.2/8.15.2) with ESMTPS id xAQIlCEG019460
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 26 Nov 2019 18:47:12 GMT
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by XCH-ALN-005.cisco.com
 (173.36.7.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Nov
 2019 12:47:11 -0600
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-rcd-002.cisco.com
 (173.37.227.247) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Nov
 2019 12:47:10 -0600
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Nov 2019 12:47:10 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvJgIQG+7qleOLbbb5Ly72rhCRg55SmzcJvQx1WRI1GE4YHMZD7VpFSZedYFMGAJ//7TnRTkwQ1ksXJX2/r0NbyVofCecx57FsuuP4bGjQ5NEU+fVAO6bRzTj6PVl9uoAUgQTsfe0oYKh7/bZfIW572izc3T/FmWQRsk0bfNLx2B5E6hag9lnFYAXsbxn7FWJo8bpvIsEQYZ/3e8WMWAIOEU0HGsP2rmCOIWDMowJNy9r8yczXIBrlnUSFy+vJ1W3tehx5a6hxHvZ0RGT4JIwHblehVcodDqzvFWKt716mDVoV6f710qEcaHH2zafb7XR4yknRVyIavNElgbZG8nag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=stfxjQQbrUbrOyllKCZ8GFW5xf3Xatubl1c1ucXFbhU=;
 b=oXKezd2hQggg81wmWnf+6y724wreg4KWzSgMQTrhoJn8/asIpNzt8+rkG75Uk/wMxO/eVEqVLERkn19t/IQwZoys2rKsHjugW/64f5WJZ8y+8f4d4na6/tKWtmosfvz3Oa+2ZTQWdHjT7HHXu0BVgB5vLpXpdCWjx443Akt9nWXlSFgj9U6OiNgY3QVCtsefS6J4PAM/c/EBcpZY7JOF7Eafw4JckdTs00LNiOsCqSifK4TFoIvFPciO/sjP1BptW+GBCnXrz5kH+JdX+g/lgQxmh5IaKq6Mh0hR1kTvBUa9ie2Zvit5DeZdxPgClTTq1B7qZpiZueTArYmkQBC17g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=stfxjQQbrUbrOyllKCZ8GFW5xf3Xatubl1c1ucXFbhU=;
 b=naHh2TFufHVCTxSGT5LSgy11gPjbZsnUJu/PPS8RiLajxNKvt8uCHnKGB1uUQ2+z+W55wZ7nHbXgL57xmiWSJifl0k2m+9lG56iYkJub0xPgxlDvngghZQp2psi9PchU7NCkRpvgSBmGlWBaAL2/ukdi+wKPReRwpH2sHk0Sq7o=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB2800.namprd11.prod.outlook.com (52.135.93.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.23; Tue, 26 Nov 2019 18:47:09 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d%7]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 18:47:09 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLts6edYHQA///QMACAAGcLAP//rq8AgABU1YD//91EAA==
Date:   Tue, 26 Nov 2019 18:47:09 +0000
Message-ID: <0A92D5EA-B158-4C7A-B85C-1692AE7C828B@cisco.com>
References: <5248B312-60A9-48A7-B4CF-E00D1BDF1CD2@cisco.com>
 <20191126122110.GD795@breakpoint.cc>
 <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
 <20191126153850.pblaoj4xklfz5jgv@salvia>
 <427E92A6-2FFA-47CF-BF3B-C08961C978C9@cisco.com>
 <20191126155125.GD8016@orbyte.nwl.cc>
In-Reply-To: <20191126155125.GD8016@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c762293-7957-49b6-5ebe-08d772a10b2a
x-ms-traffictypediagnostic: SN6PR11MB2800:
x-microsoft-antispam-prvs: <SN6PR11MB2800FD9BAB2BDDF8B4727C95C4450@SN6PR11MB2800.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(199004)(189003)(7736002)(5660300002)(305945005)(76116006)(66476007)(66556008)(64756008)(66446008)(66946007)(91956017)(26005)(76176011)(71200400001)(2616005)(54906003)(36756003)(99286004)(256004)(446003)(11346002)(71190400001)(33656002)(4001150100001)(316002)(229853002)(81166006)(81156014)(6436002)(102836004)(3846002)(66066001)(2906002)(6116002)(58126008)(14454004)(6486002)(6916009)(6512007)(6246003)(554214002)(6506007)(4326008)(478600001)(25786009)(8936002)(86362001)(186003)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2800;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rt+0OLuIgJeq9Wg6xQjPkj9t8CtatQzRtadgEtgdSNHs4+NlW4j8A7iWidFYErnZ9WGfJGst8x3USojsa4YM65U/ZrmK30P00Fn6aTyvWb8qhHsBeo2WHXYx+gKyBdOurvKvIcr4oX2eK72g6+5+HbwtxoS6AOtIasi/JTE6vgBjrNw7qC3IJIjHF7+9Nq8i/sMAFh5NzIwLwbot/5Mw99Kchkf3z2n97BH8F9t2HVUKfQws8rInxHUfttAD5I6fCDxzc23pmQhvLd+ZdhHzUcrf88dk+9FdPLl2IAGlQbHgGEC7kdhqUD8vIhXub+GKP8w6bv3yWfuGA0lRYJ/qR18MIBKGDz9UU9+IGOzh35naoP79LKbooPtkSckfEMyolqSZxoc8BULeS92cvtWGuUDzA/czuEYCd4dRUV82VBncmn36idkUH8AM8CqKMuTS
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B52ABDF51621E4999BAE99DC72E221C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c762293-7957-49b6-5ebe-08d772a10b2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 18:47:09.7862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ESz3kQDHM9IiXvXvpH090JRR6cm8gfUbzVV1GAX5SZY6y2A3yq4gh4eJ0rTE7SSBc5BiTdK2pAlgzqDhBiYfbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2800
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.15, xch-aln-005.cisco.com
X-Outbound-Node: alln-core-12.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

T2ssIEkgZ3Vlc3MgSSB3aWxsIHdvcmsgYXJvdW5kIGJ5IHVzaW5nIGlucHV0IGFuZCBvdXRwdXQg
Y2hhaW4gdHlwZXMsIGV2ZW4gdGhvdWdoIGl0IHdpbGwgcmFpc2Ugc29tZSBicm93cyBpbiBrOHMg
bmV0d29ya2luZyBjb21tdW5pdHkuDQoNCkkgaGF2ZSBhIHNlY29uZCBpc3N1ZSBJIGFtIHN0cnVn
Z2xpbmcgdG8gc29sdmUgd2l0aCBuZnRhYmxlcy4gSGVyZSBpcyBhIHNlcnZpY2UgZXhwb3NlZCBm
b3IgdGNwIHBvcnQgODAgd2hpY2ggaGFzIDIgY29ycmVzcG9uZGluZyBiYWNrZW5kcyBsaXN0ZW5p
bmcgb24gYSBjb250YWluZXIgcG9ydCA4MDgwLg0KDQohDQohIEJhY2tlbmQgMQ0KIQ0KLUEgS1VC
RS1TRVAtRlMzRlVVTEdaUFZENFZZQiAtcyA1Ny4xMTIuMC4yNDcvMzIgLWogS1VCRS1NQVJLLU1B
U1ENCi1BIEtVQkUtU0VQLUZTM0ZVVUxHWlBWRDRWWUIgLXAgdGNwIC1tIHRjcCAtaiBETkFUIC0t
dG8tZGVzdGluYXRpb24gNTcuMTEyLjAuMjQ3OjgwODANCiENCiEgQmFja2VuZCAyDQohDQotQSBL
VUJFLVNFUC1NTUZaUk9RU0xRM0RLT1FBIC1zIDU3LjExMi4wLjI0OC8zMiAtaiBLVUJFLU1BUkst
TUFTUQ0KLUEgS1VCRS1TRVAtTU1GWlJPUVNMUTNES09RQSAtcCB0Y3AgLW0gdGNwIC1qIEROQVQg
LS10by1kZXN0aW5hdGlvbiA1Ny4xMTIuMC4yNDg6ODA4MA0KIQ0KISBTZXJ2aWNlDQohDQotQSBL
VUJFLVNFUlZJQ0VTIC1kIDU3LjE0Mi4yMjEuMjEvMzIgLXAgdGNwIC1tIGNvbW1lbnQgLS1jb21t
ZW50ICJkZWZhdWx0L2FwcDpodHRwLXdlYiBjbHVzdGVyIElQIiAtbSB0Y3AgLS1kcG9ydCA4MCAt
aiBLVUJFLVNWQy01N1hWT0NGTlRMVFIzUTI3DQohDQohIExvYWQgYmFsYW5jaW5nIGJldHdlZW4g
MiBiYWNrZW5kcw0KIQ0KLUEgS1VCRS1TVkMtNTdYVk9DRk5UTFRSM1EyNyAtbSBzdGF0aXN0aWMg
LS1tb2RlIHJhbmRvbSAtLXByb2JhYmlsaXR5IDAuNTAwMDAwMDAwMDAgLWogS1VCRS1TRVAtRlMz
RlVVTEdaUFZENFZZQg0KLUEgS1VCRS1TVkMtNTdYVk9DRk5UTFRSM1EyNyAtaiBLVUJFLVNFUC1N
TUZaUk9RU0xRM0RLT1FBDQoNCkkgYW0gbG9va2luZyBmb3IgbmZ0YWJsZXMgZXF1aXZhbGVudCBm
b3IgdGhlIGxvYWQgYmFsYW5jaW5nIHBhcnQgYW5kIGFsc28gaW4gdGhpcyBjYXNlIHRoZXJlIGFy
ZSBkb3VibGUgZG5hdCB0cmFuc2xhdGlvbiwgIGRlc3RpbmF0aW9uIHBvcnQgZnJvbSA4MCB0byA4
MDgwIGFuZCBkZXN0aW5hdGlvbiBJUDogIDU3LjExMi4wLjI0NyBvciA1Ny4xMTIuMC4yNDguDQpD
YW4gaXQgYmUgZXhwcmVzc2VkIGluIGEgc2luZ2xlIG5mdCBkbmF0IHN0YXRlbWVudCB3aXRoIHZt
YXBzIG9yIHNldHM/DQoNClRoYW5rIHlvdQ0KU2VyZ3VlaQ0KDQoNCu+7v09uIDIwMTktMTEtMjYs
IDEwOjUzIEFNLCAibjAtMUBvcmJ5dGUubndsLmNjIG9uIGJlaGFsZiBvZiBQaGlsIFN1dHRlciIg
PG4wLTFAb3JieXRlLm53bC5jYyBvbiBiZWhhbGYgb2YgcGhpbEBud2wuY2M+IHdyb3RlOg0KDQog
ICAgSGkgU2VyZ3VlaSwNCiAgICANCiAgICBPbiBUdWUsIE5vdiAyNiwgMjAxOSBhdCAwMzo0Nzo0
OVBNICswMDAwLCBTZXJndWVpIEJlenZlcmtoaSAoc2JlenZlcmspIHdyb3RlOg0KICAgID4gSSB0
b3RhbGx5IGdldCBpdCB0aGF0IGl0IGlzIG5vdCBwb3NzaWJsZSBpbiB0aGVvcnksIGJ1dCB0aGUg
bWF0dGVyIG9mIGZhY3QgaXMgaW4ga3ViZXJuZXRlcyBzb21laG93IGl0IHdvcmtzLCBtYXliZSBp
biBzb21lIGNhc2VzIHRoaXMgY2hlY2sgaXMgbm90IGVuZm9yY2VkLCBJIGRvIG5vdCBrbm93LiBJ
ZiB5b3UgYXJlIGludGVyZXN0ZWQgdG8gaW52ZXN0aWdhdGUgaXQgZnVydGhlciwgcGxlYXNlIGxl
dCBtZSBrbm93IGFzIEkgc2FpZCBJIGhhdmUgYSBjbHVzdGVyIHdpdGggdGhlc2UgMiBydWxlcyBj
b25maWd1cmVkLg0KICAgIA0KICAgIEluIGFub3RoZXIgY2FzZSBJIG5vdGljZWQgdGhhdCB1c2Vy
LWRlZmluZWQgY2hhaW5zIGFyZSBhIHdheSB0bw0KICAgIGNpcmN1bXZlbnQgdGhlc2UgdHlwZXMg
b2YgZnVuY3Rpb25hbCByZXN0cmljdGlvbnMuIElmIHRoYXQncyBnb29kIG9yIGJhZA0KICAgIGlz
IHVwIHRvIHlvdSB0byBkZWNpZGUuIDspDQogICAgDQogICAgUmVnYXJkaW5nIHRoZSBkZXNpcmVk
IGZ1bmN0aW9uYWxpdHksIEkgZ3Vlc3MgeW91J3JlIHdhbmRlcmluZyB0aGUNCiAgICBzaW5raG9s
ZS1maWxsZWQgcGxhaW5zIG9mIHVuZGVmaW5lZCBiZWhhdmlvdXIuDQogICAgDQogICAgQ2hlZXJz
LCBQaGlsDQogICAgDQoNCg==
