Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A08AC43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 19:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEFFE206D8
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 19:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="S+1ao4LT";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="bDRSXrQr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLRToG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 14:44:06 -0500
Received: from alln-iport-4.cisco.com ([173.37.142.91]:21157 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLRToG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 14:44:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1614; q=dns/txt; s=iport;
  t=1576698245; x=1577907845;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aVYIchAlktB0G9uPVcJCdXlrwmbOauSsQEld/iXHkBw=;
  b=S+1ao4LT9Pit4Ctm2AcGBLkwOkwE58D6rDUUlDOX3KgTizW5cYm9owj0
   xvqJKyPwUaA/nY5drs1WRyUtdRKx1nLptJzIEgzmekVI/FlS55tYc01Pj
   lUNkv3bS08rbED1ikGo+SgdMaWG18x0Kl3Uby6o3lN6sq5Qj8IxuYs+Nd
   o=;
IronPort-PHdr: =?us-ascii?q?9a23=3Ajdd8ZRbag02FajBQKZ/15c3/LSx94ef9IxIV55?=
 =?us-ascii?q?w7irlHbqWk+dH4MVfC4el20gabRp3VvvRDjeee87vtX2AN+96giDgDa9QNMn?=
 =?us-ascii?q?1NksAKh0olCc+BB1f8KavxZSEoAslYV3du/mqwNg5eH8OtL1A=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CnAAAhgfpd/4kNJK1kHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgWoFAQELAYFMUAWBRCAECyoKg3qDRgOKcoJfmAaBLoEkA1QJAQE?=
 =?us-ascii?q?BDAEBLQIBAYRAAheCAiQ2Bw4CAw0BAQQBAQECAQUEbYU3DIVfAQEBAxIREQw?=
 =?us-ascii?q?BATcBDwIBCBgCAiYCAgIwFRACBA4FIoMAgkcDLgGjBAKBOIhhdYEygn4BAQW?=
 =?us-ascii?q?FEhiCEAmBDigBjBcagUE/gTgggkw+hGCCeTKCLJA3nlYKgjWWExuaTqkcAgQ?=
 =?us-ascii?q?CBAUCDgEBBYFYATKBWHAVZQGCQVAYDY0Sg3OKU3SBKIx1AYEPAQE?=
X-IronPort-AV: E=Sophos;i="5.69,330,1571702400"; 
   d="scan'208";a="385345905"
Received: from alln-core-4.cisco.com ([173.36.13.137])
  by alln-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 18 Dec 2019 19:44:04 +0000
Received: from XCH-ALN-008.cisco.com (xch-aln-008.cisco.com [173.36.7.18])
        by alln-core-4.cisco.com (8.15.2/8.15.2) with ESMTPS id xBIJi1lQ024927
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 18 Dec 2019 19:44:02 GMT
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by XCH-ALN-008.cisco.com
 (173.36.7.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Dec
 2019 13:44:01 -0600
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-rtp-003.cisco.com
 (64.101.210.230) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Dec
 2019 14:43:59 -0500
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 18 Dec 2019 13:43:59 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8rRU5xHgF41MqfPa1eN2BAXTP1WlJgRuguYiBQDnRFERE9fdI/IsIhOpc5URGFFTRXpDWH2H4LdHUlXc337wo2S+dTeIu+91PNSXejOUBE5rQvfs2f9bt/hGkpDquVggyUqDNpBx0B9xO3KWmaKy9sJN69CjIUAi/TtK8vzy62DTLldDHujeB+R9MJRVv36cPoFtCxH0nSyxl50VIc0NZRq2scAC/khYMvVpkV31Xm/rI5Q0NNsMBLVZf1qUc62xH3ZH0yszGsasT2honwkeh4PD+oAsJc06s1nixlXIQW4BxKKjt+JEAC3pRJ4lWU+J6WGzE39Q34ofQiSB4j3iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVYIchAlktB0G9uPVcJCdXlrwmbOauSsQEld/iXHkBw=;
 b=EnLy5pmrOq0LitI8rWvHldzGN8FSSA7Rp0jKbdmxUmSO/h9qTEvLHf64RZLOxR6D+ghO4EvptDHcaUgM17Z7Q5GyothYjI9/eBNt48iZcVWoHxSq0E6ebd7H0zESWs5cyPiNH0HAWobNVnZms7q7+ZOkw0O5V4XDl9qY9oWRuk2HpteZD4kkvOoyq6AI4CfHDCn+YOrhqpRT+ofacUzWWLiSjKeAcKMwgonu7cspCy8vR4L7CSOvl/fp9qpv1XLHlRhfXsLQfyxbxi4/h5TBnK6FJAM18YpCX59O+EM++gMnZACrGvd3RoLQRU5WLMSJ1SJs/hrlHl+qHi4dLy6XGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVYIchAlktB0G9uPVcJCdXlrwmbOauSsQEld/iXHkBw=;
 b=bDRSXrQrSKvXe9ZpjvBgPczP8mt0JIYn99ulTqmFIQRA62EEJi3/jpqckvABEXeGjxiSf2OcK8xMvWRCuVE7KDOBGGE5Fa5wM1aLfEXzcMKJk9BNrfrbceopxCdWDTm3GnBJgpEF2Ml1eItP2XyfUhxBZX3mz09w/dA1Val537w=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB1642.namprd11.prod.outlook.com (10.172.36.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Wed, 18 Dec 2019 19:43:58 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26%10]) with mapi id 15.20.2538.019; Wed, 18 Dec
 2019 19:43:58 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyAgABX04CAABp3AIAAVCiAgBKu9ACAARbtgP//xyeAAA/qeAAAKIIrgAALSEoA///THgA=
Date:   Wed, 18 Dec 2019 19:43:58 +0000
Message-ID: <36EA0652-C146-4ED4-A004-2D729AB69BA7@cisco.com>
References: <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
 <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
 <20191204223215.GX14469@orbyte.nwl.cc>
 <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
 <20191217122925.GD8553@orbyte.nwl.cc>
 <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
 <20191217164140.GE8553@orbyte.nwl.cc>
 <6F72FC38-4238-4CCC-BAEB-A7F4B07817D7@cisco.com>
 <20191218172436.GA24932@orbyte.nwl.cc>
In-Reply-To: <20191218172436.GA24932@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.20.0.191208
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 46ed2dd6-1a4c-41fa-141d-08d783f2a002
x-ms-traffictypediagnostic: DM5PR11MB1642:
x-microsoft-antispam-prvs: <DM5PR11MB164290BAA3613257ADCBF755C4530@DM5PR11MB1642.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(346002)(39860400002)(376002)(136003)(189003)(199004)(4001150100001)(8676002)(33656002)(4744005)(2616005)(26005)(64756008)(186003)(6506007)(81156014)(36756003)(5660300002)(478600001)(6512007)(54906003)(71200400001)(66446008)(6486002)(81166006)(316002)(86362001)(76116006)(66556008)(6916009)(91956017)(2906002)(66476007)(8936002)(66946007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1642;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1i1nLvrTW+ZbkZF2OZ8MDcVpybRNELnwfa/x+eaJu8t3Gz7uDMrNOqJPNlek1cnAnCB5JpkJ2U0Nseao4hoAe+pcrjnWRyJiLWAPv6DbCTa19BL6nVmlCrOmclbIxhq6Z0eQBvmtr9q9awl+wnupDb/gVql+dxJpuJ6R+rwtgxTRnGAsyCHJFzifd5CRglgFRsCAciOJNu7HbRpF5HKgqojSOWTmWkMlwX8/+T3J+SwxHZxLGLmKc1eNpo2FNnZ6CLKo2TrHj4uSGDfhD3S1mCVD8UPgBEnprQiorrkZVuGkWnOv/kAPZ8oV/qAzXN7c5jKfP7t/PRjJ0am9DBTzsBLJN35WKl/R1wiNkBgxyECsuwCLq0Rk0Embgqwlaro2ijMRlYpOku3YB0r7MiG1MDrVv14MmsdSCay+wlR9oBJYW95fMEUXwINeTmKcfcrb
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A508F86E3773E74CA4467A1DC422030B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 46ed2dd6-1a4c-41fa-141d-08d783f2a002
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 19:43:58.4580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jA7GmJctT3fU8IxEMY/D3swN4uGBD+Yyq7kZd/NA8f3t2tjik9pgmUs+wgugzC251mhkaVWjSiLq7cBQDk227Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1642
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.18, xch-aln-008.cisco.com
X-Outbound-Node: alln-core-4.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

RXJyb3I6IHN5bnRheCBlcnJvciwgdW5leHBlY3RlZCB0aA0KDQphZGQgcnVsZSBpcHY0dGFibGUg
azhzLWZpbHRlci1zZXJ2aWNlcyBpcCBwcm90b2NvbCAuIGlwIGRhZGRyIC4gdGggZHBvcnQgdm1h
cCBAbm8tZW5kcG9pbnRzLXNlcnZpY2VzDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXl4NCnNiZXp2ZXJrQGRldi11YnVudHUtMTptaW1pYy1maWx0ZXIk
IHN1ZG8gbmZ0IC12DQpuZnRhYmxlcyB2MC45LjEgKEhlYWRsZXNzIEhvcnNlbWFuKQ0KDQpBbnkg
Y2x1ZXM/IEFtIEkgdXNpbmcgb2xkIHZlcnNpb24/DQoNClRoYW5rIHlvdQ0KU2VyZ3VlaQ0K77u/
T24gMjAxOS0xMi0xOCwgMTI6MjQgUE0sICJuMC0xQG9yYnl0ZS5ud2wuY2Mgb24gYmVoYWxmIG9m
IFBoaWwgU3V0dGVyIiA8bjAtMUBvcmJ5dGUubndsLmNjIG9uIGJlaGFsZiBvZiBwaGlsQG53bC5j
Yz4gd3JvdGU6DQoNCiAgICBIaSBTZXJndWVpLA0KICAgIA0KICAgIE9uIFdlZCwgRGVjIDE4LCAy
MDE5IGF0IDA1OjAxOjMzUE0gKzAwMDAsIFNlcmd1ZWkgQmV6dmVya2hpIChzYmV6dmVyaykgd3Jv
dGU6DQogICAgPiBJIGNhbWUgYWNyb3NzIGEgc2l0dWF0aW9uIHdoZW4gSSBuZWVkIHRvIG1hdGNo
IGFnYWluc3QgTDQgcHJvdG8gKHRjcC91ZHApLCBMMyBkYWRkciBhbmQgTDQgcG9ydChwb3J0IHZh
bHVlKSB3aXRoIHZtYXAuDQogICAgPiANCiAgICA+IFZtYXAgbG9va3MgbGlrZSB0aGlzOg0KICAg
ID4gDQogICAgPiAJbWFwIG5vLWVuZHBvaW50cy1zZXJ2aWNlcyB7DQogICAgPiAJCXR5cGUgaW5l
dF9wcm90byAuIGlwdjRfYWRkciAuIGluZXRfc2VydmljZSA6IHZlcmRpY3QNCiAgICA+IAl9DQog
ICAgPiANCiAgICA+IEkgd2FzIHdvbmRlcmluZyBpZiBzb21lYm9keSBjb3VsZCBjb21lIHVwIHdp
dGggYSBzaW5nbGUgbGluZSBydWxlIHdpdGggcmVmZXJlbmNlIHRvIHRoYXQgdm1hcC4NCiAgICAN
CiAgICBTaG91bGQgd29yayB1c2luZyB0aCBoZWFkZXIgZXhwcmVzc2lvbjoNCiAgICANCiAgICB8
IGlwIHByb3RvY29sIC4gaXAgZGFkZHIgLiB0aCBkcG9ydCB2bWFwIEBuby1lbmRwb2ludHMtc2Vy
dmljZXMNCiAgICANCiAgICBDaGVlcnMsIFBoaWwNCiAgICANCg0K
