Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92ED4CA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 14:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DB3720656
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 14:33:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="AKkrhI02";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="ApEDIpd+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfJ3Odr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 10:33:47 -0400
Received: from alln-iport-1.cisco.com ([173.37.142.88]:32844 "EHLO
        alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfJ3Odq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 10:33:46 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Oct 2019 10:33:45 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1890; q=dns/txt; s=iport;
  t=1572446025; x=1573655625;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=WpgGqV0JXLGdeS+QHcpfNkYP7u2Z8c+N26LSypvAkxg=;
  b=AKkrhI02+4AA1vAkOnyJ3j0OX8Uh04xSzS+JBOzsShAjsLOJgAAGwyG8
   yNX0Dl6nHmK1lP+JAl5AO1MolnNQ75JJkbWy6+MINWo8waGEpLNerO53r
   yJZqLmhGHeDQXIlO6m/7dFOx3ysZMyc9MMaDCn79RuDCiqhkdaeUY4vEa
   A=;
IronPort-PHdr: =?us-ascii?q?9a23=3AgtaFfRKDM5PI/1zu09mcpTVXNCE6p7X5OBIU4Z?=
 =?us-ascii?q?M7irVIN76u5InmIFeBvKd2lFGcW4Ld5roEkOfQv636EU04qZea+DFnEtRXUg?=
 =?us-ascii?q?Mdz8AfngguGsmAXFbxIez0YjY5NM9DT1RiuXq8NBsdFQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DCAgCtnLld/51dJa1kHQEBAQkBEQU?=
 =?us-ascii?q?FAYFsBQELAQGBSVAFgUQgBAsqCoQeg0YDim+COYQPlAGCUgNUCQEBAQwBAS0?=
 =?us-ascii?q?CAQGEQBmDTyQ3Bg4CAwkBAQQBAQECAQUEbYU3AQtCARABhQAWEREMAQE3ARE?=
 =?us-ascii?q?BIgImAgQwFRIEDieDAIJHAy4BAqgsAoE4iGB1gTKCfgEBBYUVGIIXCYEOKAG?=
 =?us-ascii?q?FF4Z5GIFAP4E4DBOCHwEsiBMygiyNIIJdnXUKgiQDhimPIII8jAiLGo5AmU4?=
 =?us-ascii?q?CBAIEBQIOAQEFgWgjgVhwFWUBgkFQEBSDBoNzilN0gSiGToVoAYENAQE?=
X-IronPort-AV: E=Sophos;i="5.68,247,1569283200"; 
   d="scan'208";a="353645330"
Received: from rcdn-core-6.cisco.com ([173.37.93.157])
  by alln-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 30 Oct 2019 14:26:37 +0000
Received: from XCH-ALN-012.cisco.com (xch-aln-012.cisco.com [173.36.7.22])
        by rcdn-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id x9UEQbCA002532
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 30 Oct 2019 14:26:37 GMT
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by XCH-ALN-012.cisco.com
 (173.36.7.22) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Oct
 2019 09:26:37 -0500
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-rcd-001.cisco.com
 (173.37.227.246) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Oct
 2019 09:26:36 -0500
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 30 Oct 2019 09:26:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tvu2DcUT5XH2mbLKNukuw8U+LkYAFebfcxSTy7Ml0sBASp661CVyEYNmHOsTCpnWeqph+K9enI/F14t2ROeCwJtDLiQTGDbhSSG1AUIHDjpNxMMf6KuiJAmldnnh1ZG00fvjkwU0L7I0k3Q8D+CjFv0Vnu7TBh7PjDmsB17Hlodf50zEm+8JGNybwuzyNkiJLsT3KI0jS5CaZUrL9Hd3JNv07fg5s3gR3pVR0eMIOZQtVlbRZvEEIBip+t5Qm3VJVPhewIgZEeUOnzBV22eT6ic4AoDwn8K43zwmDZQc5WzNjHs6NZ3IWup8xFzN6ih3AIkWfvMHJTS0jhORESKtEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpgGqV0JXLGdeS+QHcpfNkYP7u2Z8c+N26LSypvAkxg=;
 b=RBUrvo5LzKX1S+d/HS5vLgswsOi4c0xgVgs/dbYPhmWnEpqQo8rjZHhZq29F3nmHgcv2vgdX0XNOUffh2gWHU6zA6I0X0rlYJa1CHny6IRv4xB0sFr4k/WfuoTFphOpmOtzKQdfA+lMHBBtM7NTnmTU3fUdOObzDvjUpPNxDnEVo8Qez4fnZSLR3iqS9piYPXlUxdcLhN5R8ZLJMqoExXAWLe3sBQq0+tB8FWkFMuVgL4wzGNGgOkPMYvxr/EsWATLNLjK4SBkDPFFeDgjZiAPOEtAcVTUyo4xhZhaHHfZkDHbIACKVRwJCZuncY10sfs5NIXOX2cp5/elgVJPcAiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpgGqV0JXLGdeS+QHcpfNkYP7u2Z8c+N26LSypvAkxg=;
 b=ApEDIpd+okBX0EuMLmsY58+ADWeI5MtRUcjdlzSx9TVzg1qbmnog0yzPTrw0smciq0VU/ikHNTp1BbPnteRsJcVEq3E4jC9l0MgaP+RF7PnGtuTY5OzKK3O7VVBPNjdT0AADdJKvCz7OIhV9FgAgGtOsZtd0Gp/EAyNimwAsWcw=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB3421.namprd11.prod.outlook.com (52.135.127.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Wed, 30 Oct 2019 14:26:35 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::518c:fb3f:5839:fd38]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::518c:fb3f:5839:fd38%7]) with mapi id 15.20.2387.025; Wed, 30 Oct 2019
 14:26:35 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Michael Stapelberg <michael@stapelberg.ch>
Subject: Rearranging expressions in the rule
Thread-Topic: Rearranging expressions in the rule
Thread-Index: AQHVjy4IfxUlVgrH4EapvOH07c2odA==
Date:   Wed, 30 Oct 2019 14:26:34 +0000
Message-ID: <FCE200C6-A84D-4689-B1E4-3174C52999F6@contoso.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1e.0.191013
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d96d4bf8-1f0e-45f5-942c-08d75d452b0b
x-ms-traffictypediagnostic: SN6PR11MB3421:
x-microsoft-antispam-prvs: <SN6PR11MB34213055CDF99CDA301B305FC4600@SN6PR11MB3421.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(189003)(199004)(9686003)(14454004)(6512007)(86362001)(3846002)(6506007)(2351001)(6116002)(2906002)(6436002)(316002)(36756003)(478600001)(6486002)(25786009)(2501003)(58126008)(99286004)(4326008)(5640700003)(81166006)(102836004)(33656002)(54906003)(81156014)(71200400001)(8676002)(14444005)(66946007)(64756008)(66446008)(256004)(66556008)(8936002)(76116006)(5660300002)(91956017)(66476007)(305945005)(486006)(6916009)(66066001)(186003)(71190400001)(7736002)(476003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3421;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l5FriFQRIJl6zolXztGZkvAGc813Oee3cyKqpH5Uno+fChs8UITRjKgdYNu6zz4XEE9ATNDzc5jyan7nyJ1CA8uyrD/ccwnoVeqdq0wyl7OcZMV9vxg8C7k2vyttRbRXIOoi+20VKtH/3wV4EoSzA4d0SzALU3C1c0YLA9eTfHZZs3Lwdc6fEPr8lNgmsUe0NHddhFvq1ZkQK334ymteJqd+0aqcGrgw95KrS2u9qcR6SG1qdD+0zQMh9wO/WEb6nRZA1lyKb70wJrysaQsCC4bpeafjATziT/bhGLoPjMqb6MdmCn1lgaM02wLb8PdgQ8gOzYGTnGCJqmY1hgeWMddnnUDKpHglrc2EK9X0G3fyiYDPpawGPOHf/67uLp3xXKog6SVMRTjm8xwQakapB4gQ8QxoFwwAJojD5De+cZMXkzKjhkmaeLzRMXqKeW8c
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D2F76D6FBC4AF4EABA42D6A68F7B76C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d96d4bf8-1f0e-45f5-942c-08d75d452b0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 14:26:34.9651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zzE/byGX+8xgn3ADm5MZk0MRMww26h+SY4bNgX2SSSGC0LGlkd6Fhm8i6RdznCB909UO9Ub7+rYee2FjWxCQqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3421
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.22, xch-aln-012.cisco.com
X-Outbound-Node: rcdn-core-6.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8sDQoNCkkgY2FtZSBhY3Jvc3MgYW4gYW5vbWFseSAoYXQgbGVhc3QgSSB0aGluayBpdCBp
cyBhbm9tYWx5KSwgYnV0IHdhbnRlZCB0byBjb25maXJtIG15IG9ic2VydmF0aW9uLiAgDQoNClRo
ZSBmb2xsb3dpbmcgc2VxdWVuY2Ugb2YgZXhwcmVzc2lvbnM6DQpbDQp7IkRlc3RSZWdpc3RlciI6
MSwiQmFzZSI6ImV4cHIuUGF5bG9hZEJhc2VOZXR3b3JrSGVhZGVyIiwiTGVuIjoxLCJPZmZzZXQi
Ojl9LCANCnsiT3AiOiJleHByLkNtcE9wRXEiLCJSZWdpc3RlciI6MSwiRGF0YSI6WyIweDEiXX0s
DQp7IkRlc3RSZWdpc3RlciI6MSwiQmFzZSI6ImV4cHIuUGF5bG9hZEJhc2VOZXR3b3JrSGVhZGVy
IiwiTGVuIjo0LCJPZmZzZXQiOjE2fSwNCnsiU291cmNlUmVnaXN0ZXIiOjEsIkRlc3RSZWdpc3Rl
ciI6MSwiTGVuIjo0LCJNYXNrIjpbIjB4ZmYiLCIweGZmIiwiMHgwIiwiMHgwIl0sIlhvciI6WyIw
eDAiLCIweDAiLCIweDAiLCIweDAiXX0sDQp7Ik9wIjoiZXhwci5DbXBPcEVxIiwiUmVnaXN0ZXIi
OjEsIkRhdGEiOlsiMHgxIiwiMHgxIiwiMHgwIiwiMHgwIl19LA0KeyJLaW5kIjoiMHgwIn0NCl0N
Cg0KY29ycmVjdGx5IGdlbmVyYXRlcyBuZnQgbGlrZSBydWxlOg0KDQppcCBwcm90b2NvbCBpY21w
IGlwIGRhZGRyIDEuMS4wLjAvMTYgZHJvcA0KDQpUaGVuIEkgcmVxdWVzdCBuZXRsaW5rIHRvIGdl
dCBtZSB0aGUgc2FtZSBydWxlIGJhY2sgKEkgYW0gdGVzdGluZyBmdW5jdGlvbmFsaXR5IHRvIHJl
YWQgYW5kIGFic29yYiBhbHJlYWR5IGV4aXN0aW5nIG5mdCBydWxlcyksIEkgZ2V0IGRpZmZlcmVu
dCBzZXQgb2YgZXhwcmVzc2lvbnMgZm9yIHRoZSBzYW1lIHJ1bGUuIEhlcmUgaXMgd2hhdCBJIGdl
dDoNClsNCnsiRGVzdFJlZ2lzdGVyIjoxLCJCYXNlIjoiZXhwci5QYXlsb2FkQmFzZU5ldHdvcmtI
ZWFkZXIiLCJMZW4iOjEsIk9mZnNldCI6OX0sDQp7Ik9wIjoiZXhwci5DbXBPcEVxIiwiUmVnaXN0
ZXIiOjEsIkRhdGEiOlsiMHgxIl19LA0KeyJEZXN0UmVnaXN0ZXIiOjEsIkJhc2UiOiJleHByLlBh
eWxvYWRCYXNlTmV0d29ya0hlYWRlciIsIkxlbiI6NCwiT2Zmc2V0IjoxNn0sDQp7Ik9wIjoiZXhw
ci5DbXBPcEVxIiwiUmVnaXN0ZXIiOjEsIkRhdGEiOlsiMHgxIiwiMHgxIiwiMHgwIiwiMHgwIl19
LA0KeyJLaW5kIjoiMHgwIn0NCl0NCg0KSXQgZG9lcyBub3QgbG9vayBjb3JyZWN0IGJlY2F1c2Ug
aXQgbG9zZXMgc3VibmV0IGxlbmd0aCBpbmZvcm1hdGlvbi4gIEkgd291bGQgYXBwcmVjaWF0ZSBp
ZiBzb21lYm9keSBjb3VsZCBjb25maXJtIGlmIGl0IGlzIG5vdCBleHBlY3RlZCBiZWhhdmlvciBh
bmQgaWYgYW55Ym9keSBvYnNlcnZlZCBzb21ldGhpbmcgc2ltaWxhci4NCg0KVGhhbmsgeW91DQpT
ZXJndWVpDQoNCg==
