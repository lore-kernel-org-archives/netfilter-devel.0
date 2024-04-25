Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2095.outbound.protection.outlook.com [40.107.104.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD3A1BF40
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 12:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714047197; cv=fail; b=Luribu2IOKcBS0o379FrFu6HixWbyt5PNm1aBVvB71RJ+8wT5nZ6ZORuKRwnMUR6aRS+VHCPNAP41vSyfHDFhDMR+oxEArD203glcGjhTSdz9FQGOnWi3+aUFVH6Gj74qYb8qvbktJy7hNX8dwxZPfYWBaukIH8SVisA9H4tJ94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714047197; c=relaxed/simple;
	bh=sndB5KOBTwH/2Arj4PZqPQPH1Vzn8aDIkvmU3MGnuK4=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Tzrc9yN0EfIcs0Cawn1zZLobgi/nTug5X+sKxXF0QamU9zeRz0RiYH/VH/BFCApFlEIdcfU6viEcfhca7LewvTtm0/H/5IDRfoVTqRh4lki8xCqqkuz+pU1ybZFmSOe5htXpZocECURfQcTAE8ETnEFCPHETPKTQqeaMJpIaEVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=keba.com; spf=pass smtp.mailfrom=keba.com; dkim=pass (2048-bit key) header.d=keba.com header.i=@keba.com header.b=tEnFbxLo; arc=fail smtp.client-ip=40.107.104.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=keba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=keba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=keba.com header.i=@keba.com header.b="tEnFbxLo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7McYu8EwYN72AF4z4jCW5rRHdmuAoDHkBW1FoaBogn68VysSj0OFhLCUkFytg17oTABTpmng7Mo3ZM9iHmeJysvKfDRZWAvTmTX8pk+S+OeJGiKTfwQ10inlk8UH9JJNvXYQL4crzStLQTGRts+XoOU+41xf1FSi7fAxKvvwoQaRtscIpF2hBJ3s0CYXn37OhsF+drr4G7Is4BYX8psZDAMYdefign5Pker44QSUcwYy62QrD8mjkDvB24l/nAJ0uqX+yJ73yd5VOW6M/b8tCN0ZF4n5afK6ShVVTE+TcVdVH6RFCpR4Y1ETM3fSuMcRKJ34iAXXAIOG7TXLVUXaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSsVdr0F1unKIRh3SKYPUlfXr4cp63BIxN4Abv2dyF4=;
 b=OVDvnhMawFHVtx5Ma6+BgmTX7dYhF8KUeO8XwDwLjCZv2tHHRABq1lNOUKaSFgO3ebgkFA7bQhr1CGIy/qiDPTkQ7bjYWfCOIy3JQSrY0X+qdsjwrC1b2iwiYA35NIVs3mzBJPnpOlbCwuUoiIV2NdxfaOgvgJgaN52XYX7Vv/PZV7TqNgqV/ZejPdUqngG5CriXsUHcldGExO5jCN9y1ZYRCZa+/MmszMCjnTXjyvujVVLMQ/wwv11cYBinW3IrHk7HZ+HlG3CTQrYghFXVttux9z/IMCVOC+kHson2kCX9wXcxDqkN60sFz2EXQqDJj53MnkmLr/HNtlJMx9AfaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=keba.com; dmarc=pass action=none header.from=keba.com;
 dkim=pass header.d=keba.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=keba.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSsVdr0F1unKIRh3SKYPUlfXr4cp63BIxN4Abv2dyF4=;
 b=tEnFbxLo0wRre0PJC+nUIf6SIhiLfZkaRWWzVDGxMVxbEMVTUO+ZowhKq+ectgyf/J1vRXGRSqt8sOsh8CMDiyGqeqz93uFcJvXg6syizIWsvSFSpeWtKbfgN7tNwQoTzrmRWuHMFKBFAVv37TfvLfBch6kJgbUm9JzdQg6gdG254UzJSLxNMwa7VGqU6rwmnafrZj1l30st+BqBbVm38BZLJO7u7oJSqA7/R1r0BIP21To6BizQRsx+l8A9OQxkPbIXP07ifwad9SMmRfycv3ZnrHpUJ7EiQn+1AbOyWJQ9jzUo0fyoPitXtLmk0rVmqFiTCv7/h9WtUb0wtZ8BcQ==
Received: from DUZPR07MB9841.eurprd07.prod.outlook.com (2603:10a6:10:4d8::7)
 by DBAPR07MB6536.eurprd07.prod.outlook.com (2603:10a6:10:18e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Thu, 25 Apr
 2024 12:13:12 +0000
Received: from DUZPR07MB9841.eurprd07.prod.outlook.com
 ([fe80::f7fe:ad89:7c1b:fb8d]) by DUZPR07MB9841.eurprd07.prod.outlook.com
 ([fe80::f7fe:ad89:7c1b:fb8d%5]) with mapi id 15.20.7472.044; Thu, 25 Apr 2024
 12:13:11 +0000
From: pda Pfeil Daniel <pda@keba.com>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: [PATCH] conntrackd: helpers/rpc: Don't add expectation table entry
 for portmap port
Thread-Topic: [PATCH] conntrackd: helpers/rpc: Don't add expectation table
 entry for portmap port
Thread-Index: AdqXCOniFtq9Dyz6TEmv+uvqfOYRYw==
Date: Thu, 25 Apr 2024 12:13:11 +0000
Message-ID:
 <DUZPR07MB9841A3D8BEF10EB04F33636BCD172@DUZPR07MB9841.eurprd07.prod.outlook.com>
Accept-Language: de-AT, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_ActionId=c7a1aaa0-e124-4718-a8fb-c24e3fa1d5fd;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_ContentBits=0;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_Enabled=true;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_Method=Standard;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_Name=Confidential;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_SetDate=2024-04-25T12:05:10Z;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_SiteId=83e2508b-c1e1-4014-8ab1-e34a653fca88;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=keba.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DUZPR07MB9841:EE_|DBAPR07MB6536:EE_
x-ms-office365-filtering-correlation-id: 9906b0da-4f71-485a-82e1-08dc652113b6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?GOeyHupLDyoN2/lkE9w/c88Cjpioc/2lQMjKhk+ObXn4g+w+DECR6Zz0t2OW?=
 =?us-ascii?Q?KhexstsGv7CtmUVZ7awaWVJFyZZlJw2bxYfNnh540pSvNH20tRxbGyPPr7GI?=
 =?us-ascii?Q?/ibxSHb+TW8rvBgTnTwslpCH3Hsq9sU+D4ir/4AubFakjT9KASqvhNi+BnTA?=
 =?us-ascii?Q?31QGcRtaRu6OEQ4JyhiYBDtGerudq+pax5HVDEAwBbF1VAVlwXm1uF/N8pwa?=
 =?us-ascii?Q?tgDlKqDBo38884nWz13+G1u0VPbvL143Gpn4D4Y/nrd/ad3Y+JHI5XasQKqF?=
 =?us-ascii?Q?5uVB9ILdQA0j9+B/BA4rnH+Apt4pOSxPyykapd+l++t1sKTIPXU20C31sne2?=
 =?us-ascii?Q?4PBNJXIi/yVEeqs9r3XBRtYjOL10Vahbp+t/YDivnyaLaJksweWjocOaJFgW?=
 =?us-ascii?Q?cXnNfxHJY8TWKnhT5uTQJ6+NSbjEwlnvVkbd9EmNI1W2fEk9m8n4OSuYmPXu?=
 =?us-ascii?Q?LfvN1gJzHgLukeZu5gU9TbLT/EaeRtZQNdUxd2g8vtWIob6nZABzWudsteOv?=
 =?us-ascii?Q?CFnITmrUQhhAknk8pb3L07lgmOY7pw1QxrWJKRdSlxFQAlxR0jFG3JY4rUud?=
 =?us-ascii?Q?a6CdNoPs6li4fMGzrY3cxL0zhg0GzPOkCAekgVJBsxz0VtKSec1bn/vKsK0k?=
 =?us-ascii?Q?iUzQs0ezB0wrqBIeIy8In/6wU0OsuziN52+uElgct7dXveum3XIxDvY1e5iW?=
 =?us-ascii?Q?cqaqpIBVS5Sstm/MT51qw+187Ke7Jxu2a/1IdaipKKGNogC/D74VtiMZlG2/?=
 =?us-ascii?Q?wE1r4pvlaEy8yiNTlU/5rm1K3U4gn37kIvsfjHoFQ3nT7XmqWBq0omialda1?=
 =?us-ascii?Q?JoGmYqhBxbDOpB6LnrzBWPBOcVDZ5U8WyDmBfuB9v0IeU7vGeuLb66c8OaAw?=
 =?us-ascii?Q?ZpV21xooEpmakntfwnwwxd9LCsCVSabdlzFb/vwos6YHwa0HQT7aFFn/VNKH?=
 =?us-ascii?Q?6Unw9XK5xN8OQwfrL8YJHFqcV1A9Cp7d3DemGYn6v29+htP3B7V5D7Du6GmA?=
 =?us-ascii?Q?cIiqpGIS1r25f8j5LOMv9vv+CwAx5JdOQCI2mTw+DHoFjE3VHTF0q/kC7ST8?=
 =?us-ascii?Q?8CU+ncK/Ibb2HvH5T64dPeVPfdLXgsK82k+pBVP090A+WsVjvoBY+O1T8yg7?=
 =?us-ascii?Q?wN98/R/+xpGNg9cZVo9QIw9xnJtfFP1VTz2k9l0JT23dTQmnynJCIbtoK/F1?=
 =?us-ascii?Q?dURIUDC3hYunlSTKxiRo+7/kslJsTqzd8DWlVetHchdVCmFcFvN4/jSO3Lax?=
 =?us-ascii?Q?QFNVzMGBIL2YgGN5nBobSdY/RePJjQ41074EWx8o8u9C/nziNoDWyI6DDaa8?=
 =?us-ascii?Q?ynO0KQBXWD9lcT1+n98cTBoAjj1r2BKo73kYuMJwwegi+g=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DUZPR07MB9841.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?OmfCr6E+n7O/03T/d7dAqaX981pKmd1IfLNrMr9ParSzNIPV1pTAyCV2wO/k?=
 =?us-ascii?Q?iY0R7MJclbNQxIQzkjkBjJIBWavFAEeptHAGw6A089MRaq6w7FqOS5VAi3Qn?=
 =?us-ascii?Q?dNtHQ3IvsW6YrkAhuPdv6RGMWoqz0qJwbxQn8DDMC5XCkmPhom1P6TnkOoI1?=
 =?us-ascii?Q?EOdcFrMXOJ+SA0ntCoaF6o9j2lxSlOgLl80FjPyRemeOTn4KbtaEutz+cbsd?=
 =?us-ascii?Q?F638KGNQYJFIRetHleV9cN6DFBYrjuGmWIOAi5I+hUJw7qbgxkWf2FmHD9oC?=
 =?us-ascii?Q?SO2Iw1Vu3uY2x6XKfqpMQyaL/gR9oUJB2TTKWriv5xmi3WN7HUkOOFBNAZjF?=
 =?us-ascii?Q?WCSFVJAr5ImR68/YfMUHASJYus2HYAsicdvNy2igxPdIVNrXEvTzxGbUTWHK?=
 =?us-ascii?Q?OEI6isMO+t5DeyTzkj67+2j9Fqxxj90qi64pW7IQZf6Z2W/p/Bo3F+YN9oJn?=
 =?us-ascii?Q?2HyLxSOUsyy/Ns8eiytJKaUYQ1tAmJTb3Mhp7pTM7BPnwsZm2wjN4gTCBDX/?=
 =?us-ascii?Q?YXVmCC2/w4gk7e6CbRQOwI1lU3VdGSrO4J8OrRuSRND6cusErgk7Q9RLvoHj?=
 =?us-ascii?Q?4isCE/iU7hEOOvhvljwUbLNCdtjg8/NEBuU1kQTYEsUCN56Fv+9wEdMyTXrd?=
 =?us-ascii?Q?0mFRKkFdSLGQmPyFBEmApOvj9EKx1a/IEmu1mOkpmnxRiabgLc7M1/OR6q4h?=
 =?us-ascii?Q?r+WvGHCWLC4k8lm/lNhBmKm+sX2FxtBRNtNFJCqI5U0lCB53sFEcAqZO0Ifr?=
 =?us-ascii?Q?xQUM5r0VU7/I8u76B/fo99ywJZLczXkLhmY4bWMRVkQ2miFs6G9GNJ0RrllE?=
 =?us-ascii?Q?eb+ArBMwAdYSKgBvBg/pXr1z77rTlAs/7AmZZGJ0DTSgnrTY2grrG6aTBGue?=
 =?us-ascii?Q?/plSsT754Iurrh4cCSl3sSbDKGZiYK62xAyMBYAWXCxK+pY2Cu5EwYz+ZKw3?=
 =?us-ascii?Q?dtIPMgXBRroqk41gxmR+o6eovGyi9YMJHrv6lHe74GFIlENXK4K2+NC0EvJ/?=
 =?us-ascii?Q?i7l2xNLhqZQng3ECUI0ZbgjpvUSRYIc3HXIO8U4Dhb7XAgCN9oVUNtbc11gT?=
 =?us-ascii?Q?y8V4nqckDxQLz/U8ZIuizyGfKHZJYwJXBua5Vf+MptXBaMojVwc+2x04tSY8?=
 =?us-ascii?Q?u9AqJ+8M6nKlldX2nFfScq5UAsURuUWkiFxhwh85xUsPvUZm2q/6fd4pue7m?=
 =?us-ascii?Q?372OQIxKqf/rNretF5cEJKn9QN8UlvxAOlaZ4pFD+bMGalX3x191kweBYzK6?=
 =?us-ascii?Q?xWKZp7dQDckhcCfUuhQDZi2pKLAEIZw8yorulOgV9yopCQzf7zDC80tls0T3?=
 =?us-ascii?Q?vwv4/2RmQd2IPTpt5G/ULQh+ljhIXuGqhraEwP+ta8sxa3R8ByjYF8ahTfv8?=
 =?us-ascii?Q?2gegOW1uu8aBQle22PSW8L2U+fxbaI2IGqwelPyfT91lOx4z90F/r5SPpLGj?=
 =?us-ascii?Q?3dy4xohp4vYRhvb+YWk39JCyokJNSUzAfbZ13KI3CAzMKCuF1+xGKwukmzgh?=
 =?us-ascii?Q?JT4a+J+5/wv/VfMWq1FLnpsRI3U0NnClsux5U0bgvoy42uc/1DfN+2Nx4Yw/?=
 =?us-ascii?Q?gJEIFHZTa6KIXprkI28=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: keba.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DUZPR07MB9841.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9906b0da-4f71-485a-82e1-08dc652113b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 12:13:11.8431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2508b-c1e1-4014-8ab1-e34a653fca88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DPjyS9djAVahrPW7ZMaLTebeZrhUSIxv8dhgf6R8SSO93UgBTfdSgfdfiDhd+WKu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR07MB6536

After an RPC call to portmap using the portmap program number (100000),
subsequent RPC calls are not handled correctly by connection tracking.
This results in client connections to ports specified in RPC replies
failing to operate.

This issue arises because after an RPC call to portmap using the
program number 100000, conntrackd adds an expectation table entry
for the portmap port (typically 111). Due to this expectation table
entry, subsequent RPC call connections are treated as sibling
connections. Due to kernel restrictions, the connection helper for
sibling connections cannot be changed. This is enforced in the kernel's
handling in "net/netfilter/nf_conntrack_netlink.c", within the
"ctnetlink_change_helper" function, after the comment:
/* don't change helper of sibling connections */.
Due to this kernel restriction, the private RPC data (struct rpc_info)
sent from conntrackd to kernel-space is discarded by the kernel.

To resolve this, the proposed change is to eliminate the creation of
an expectation table entry for the portmap port. The portmap port has
to be opened via an iptables/nftables rule anyway, so adding an
expectation table entry for the portmap port is unnecessary.

Why do our existing clients make RPC calls using the portmap program
number? They use these calls for cyclic keepalive messages to verify
that the link between the client and server is operational.

Signed-Off-By: Daniel Pfeil <pda@keba.com>
---
 src/helpers/rpc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/helpers/rpc.c b/src/helpers/rpc.c
index 732e9ba..d8e4903 100644
--- a/src/helpers/rpc.c
+++ b/src/helpers/rpc.c
@@ -399,6 +399,11 @@ rpc_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
 				 xid, rpc_info->xid);
 			goto out;
 		}
+		/* Ignore portmap program number */
+		if (rpc_info->pm_prog =3D=3D PMAPPROG) {
+			pr_debug("RPC REPL: ignore portmap program number %lu\n", PMAPPROG);
+			goto out;
+		}
 		if (rpc_reply(data, offset, datalen, rpc_info, &port_ptr) < 0)
 			goto out;
=20
--=20
2.30.2
