Return-Path: <SRS0=yud9=WI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0144C31E40
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 18:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 519052067D
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 18:14:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="SLHpcJ2E";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="txMi/RVN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfHLSOr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Aug 2019 14:14:47 -0400
Received: from alln-iport-4.cisco.com ([173.37.142.91]:45740 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfHLSOq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Aug 2019 14:14:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=728; q=dns/txt; s=iport;
  t=1565633685; x=1566843285;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=+JzxhMbzsghLcAqcywlzi2e7UEKRX5i2zGjkvLDd5yw=;
  b=SLHpcJ2E4g3bMeggXGG3gx+gJ9eD/JRzwwU1Y0ykt1e9NHHMhSi+Qdlv
   GEVDamYvOd6lTd1z4HAd6IKdNByOhuGLwG8xx/y59mwn/yeiM1KZZRZNu
   vfBYErnDhcsOu4oEURndBoMYlNxPcgnsDceKqEUWb4qgZ2BpsD2J6xzBH
   k=;
IronPort-PHdr: =?us-ascii?q?9a23=3AWL3x3hKbf8hodKmb6NmcpTVXNCE6p7X5OBIU4Z?=
 =?us-ascii?q?M7irVIN76u5InmIFeBvKd2lFGcW4Ld5roEkOfQv636EU04qZea+DFnEtRXUg?=
 =?us-ascii?q?Mdz8AfngguGsmAXFbxIez0YjY5NM9DT1RiuXq8NBsdFQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0B2AADtq1Fd/5ldJa1mGwEBAQEDAQE?=
 =?us-ascii?q?BBwMBAQGBVQQBAQELAYFEUAOBQiAECyoKhBSDRwOLDkyBapgHgS6BJANUCQE?=
 =?us-ascii?q?BAQwBAS0CAQGEPwIXglcjNgcOAQQBAQQBAQQBCm2FJwyFSwIBAxIREQwBATg?=
 =?us-ascii?q?PAgEiAiYCAgIwFRACBAE0gwCBawMdAaEzAoE4iGBzgTKCegEBBYR9GIIUCYE?=
 =?us-ascii?q?MKAGEcoZxF4FAP4E4DBOKWTKCJo8RhS+XCwkCgh2UMhuCIJYdhhKHQ5gDAgQ?=
 =?us-ascii?q?CBAUCDgEBBYFXBC2BWHAVZQGCQYJCg3KKU3KBKY0DAYEgAQE?=
X-IronPort-AV: E=Sophos;i="5.64,378,1559520000"; 
   d="scan'208";a="305588355"
Received: from rcdn-core-2.cisco.com ([173.37.93.153])
  by alln-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 12 Aug 2019 18:14:45 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by rcdn-core-2.cisco.com (8.15.2/8.15.2) with ESMTPS id x7CIEisk013805
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 12 Aug 2019 18:14:45 GMT
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Aug
 2019 13:14:44 -0500
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-rtp-001.cisco.com
 (64.101.210.228) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Aug
 2019 14:14:43 -0400
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 12 Aug 2019 13:14:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4Bl4qkKcjgtGwOC4h21KZpSDD26xB3UvJ64X9K2EHpjfoeAuSLV4pm5g4533k83HFZ5UwL+EfYh0Pn6hX8Gxk9VOwPJjVW86Bl9YJxOuDZUAaF7D9fbJ8Y7PgR8M4ztu3yKFNplioEZPy6geTTEhDiOmTARL0QuYxqCMfHdAuIgjuaAFVMkF+tJ19QicCk0j9B6WrI4iL39OH6TYhgvZRDY8kxT0JGCxGpgZkpIaTG1p/MoTpqk2iOB3Fj5tXIGEmW7exjzb6El5QJP0sPl6+tetCL3lGK/WxjMQIU1JykQNfsp6LCJEDDdD8vHaZ9ZJZtoNkkPvmnxIimkhdcicA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JzxhMbzsghLcAqcywlzi2e7UEKRX5i2zGjkvLDd5yw=;
 b=lfwU+1uNlR2QbqNhJhPWzqDAsh7KFjXn9B0lSJpWJF1bN/ongXxbuy6jC8PPnx0j+PvDYnAdevEC+cEHN8w0Y1c2n0rjY80WvDfNV76FbD0nP+RJ4Jac2A2FTy3aq6M+ZoJ0flpOJEv3X1joSH9ILfyogRmOOgOxRECH00nYfw7GPREQfq3LEtxmekKTURQIrknmHoRBNG5jhZwDloDzaDUhnMMq26+NZ1+Bl3dkDYWLS/nwsmbqoXvGiUOMzPSlCU9bxqpRhEWaMbJwVgnxVyHqMYZA8SFuGsmO70LqxEzXRYBVdHuqSw0GXiMF/wJj8hZWGRuRfoGE6aEaODnX6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JzxhMbzsghLcAqcywlzi2e7UEKRX5i2zGjkvLDd5yw=;
 b=txMi/RVNtTrqVDqTHTpXlgrn0eTNUrbXDwy0XB1RY0pnOjv9ACKzk/RYP6FgnO7vrRmZJw6wPN/XA7fZudHSo0hq1Nze2Tvnx/zY1zeUtysqAj9t+W28DWNEGt9QBmxXKtUiLVNslsbOCngKg71H70dlWBs7tnSCyNnhMU+/Vqk=
Received: from BN6PR11MB1460.namprd11.prod.outlook.com (10.172.21.136) by
 BN6PR11MB1507.namprd11.prod.outlook.com (10.172.20.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Mon, 12 Aug 2019 18:14:42 +0000
Received: from BN6PR11MB1460.namprd11.prod.outlook.com
 ([fe80::531:1342:6daf:28d5]) by BN6PR11MB1460.namprd11.prod.outlook.com
 ([fe80::531:1342:6daf:28d5%11]) with mapi id 15.20.2157.022; Mon, 12 Aug 2019
 18:14:42 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Missing SetID
Thread-Topic: Missing SetID
Thread-Index: AQHVUTiqMapV4nAw+ESvm9gdClVkyab3jh+A
Date:   Mon, 12 Aug 2019 18:14:41 +0000
Message-ID: <60AFF2FD-1567-4D49-B870-580520BEF17A@cisco.com>
References: <372F88D9-353F-428C-9B59-A8D4D7BF5438@cisco.com>
In-Reply-To: <372F88D9-353F-428C-9B59-A8D4D7BF5438@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1b.0.190715
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cff71c57-1831-4537-4330-08d71f50f25f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1507;
x-ms-traffictypediagnostic: BN6PR11MB1507:
x-microsoft-antispam-prvs: <BN6PR11MB15079EEC01BB5CDD80705D39C4D30@BN6PR11MB1507.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(199004)(189003)(3480700005)(7116003)(36756003)(2501003)(305945005)(7736002)(86362001)(33656002)(5660300002)(71190400001)(71200400001)(6512007)(6436002)(99286004)(110136005)(316002)(58126008)(6486002)(8936002)(2906002)(81166006)(8676002)(446003)(25786009)(186003)(81156014)(11346002)(26005)(476003)(486006)(2616005)(53936002)(76176011)(66946007)(6506007)(102836004)(6116002)(14454004)(256004)(3846002)(76116006)(91956017)(4744005)(478600001)(221733001)(66446008)(66556008)(64756008)(66476007)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1507;H:BN6PR11MB1460.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FDJYR3Gl2ZKH36uGTfVuWhnPh7TJDZ1WF4lBFLrvjWHJZkSpaP2mJSpNr6iy/c1FFRE8Dl/6nTU2UH1p0va1NdG085UlyIhNaZtTRYvgk5q9XIRkBz2D1oSYYL0SXlJIK9hNuTwhsAnm6Sq/cx9JADY5V8LKk+WgvUIAO2dSVRD9HzJQ81q0elOW+zXHhSPay/DkHxkcrUl1AtbTbOq67o/+sntHY4EvaxWEQpsMtxsILv4/AuKiZgdlEyYt56hed4F3CUE85Wp61JnxTchsWsPX/uj2EzP+ZzZX1ArEGN/Yyyijqvm+07k+eFON1c6YzRWJl++hWvHuGNWtFthg4uYO69zpEcouxhbGtj++4xl+N+x0y7r24mGnG+xVjibQvU2vVay2djiNFPZxNB66RuM0fTJI4SlTGSNc5IgnZlw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA8BD66DA5A22248B5262027E9861E6F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cff71c57-1831-4537-4330-08d71f50f25f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2019 18:14:41.9389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N6Kple5sKeS9tegRU1pa3TxDvdYwHIhYze71mNVeIl05Ttycw273cM3/UPh3Nux4m9Q/ul8/59CUJq5Du4mVzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1507
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: rcdn-core-2.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8sDQrCoA0KSSBhbSBvYnNlcnZpbmcgYSBzdHJhbmdlIGNvbmRpdGlvbiBhdCBsZWFzdCBp
bWhvLCB3aGVuIGEgc2V0IGdldHMgcHJvZ3JhbW1lZCBvciBsb29rdXAgZXhwcmVzc2lvbiB3aXRo
IHNldGlkIGlzIHByb2dyYW1tZWQsIHdoZW4gSSBkbyBHRVRTRVRTIG9yIEdFVFJVTEVTLCB0aGUg
c2V0IElEIGlzIGFsd2F5cyAwLCBidXQgU2V0IG5hbWUgaXMgY29ycmVjdGx5IHByZXNlcnZlZC4g
SWYgU2V0SUQgaXMgbm90IHByZXNlcnZlZCB0aGVuIGhvdyB3b3VsZCBiZSBwb3NzaWJsZSB0byBk
aWZmZXJlbnRpYXRlIGJldHdlZW4gbXVsdGlwbGUgYW5vbnltb3VzIHNldHMgZGVmaW5lZCBmb3Ig
dGhlIHNhbWUgdGFibGU/DQpJIHdvdWxkIGFwcHJlY2lhdGUgc29tZSBjbGFyaWZpY2F0aW9uLiBJ
IGFtIHBvc2l0aXZlIHRoYXQgSUQgZ2V0cyBzZW50IHRvIGtlcm5lbCBpbiBib3RoIGNhc2VzLCBi
dXQgcmV0dXJuIG1lc3NhZ2VzIGlzIG1pc3NpbmcgU0VUX0lEIGF0dHJpYnV0ZS4NCsKgDQpUaGFu
ayB5b3UNClNlcmd1ZWkNCg0K
