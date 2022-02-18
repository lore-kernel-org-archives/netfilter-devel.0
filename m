Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3418DC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Feb 2022 23:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbiBRXjO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Feb 2022 18:39:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbiBRXjN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Feb 2022 18:39:13 -0500
X-Greylist: delayed 486 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Feb 2022 15:38:54 PST
Received: from mx5.sophos.com (mx5.sophos.com [195.171.192.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A1B27B489
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Feb 2022 15:38:54 -0800 (PST)
Received: from mx5.sophos.com (localhost.localdomain [127.0.0.1])
        by localhost (Postfix) with SMTP id C11AAF22FE;
        Fri, 18 Feb 2022 23:30:46 +0000 (GMT)
Received: from abn-exch5b.green.sophos (unknown [10.224.64.46])
        by mx5.sophos.com (Postfix) with ESMTPS id AE9FFF225B;
        Fri, 18 Feb 2022 23:30:46 +0000 (GMT)
Received: from EUW1-EXCH7B.green.sophos (10.240.64.122) by
 abn-exch5b.green.sophos (10.224.64.46) with Microsoft SMTP Server (TLS) id
 15.0.1497.26; Fri, 18 Feb 2022 23:30:45 +0000
Received: from EUW1-EXCH7B.green.sophos (10.240.64.122) by
 EUW1-EXCH7B.green.sophos (10.240.64.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Feb 2022 23:30:44 +0000
Received: from GBR01-LO2-obe.outbound.protection.outlook.com (104.47.21.56) by
 EUW1-EXCH7B.green.sophos (10.240.64.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Fri, 18 Feb 2022 23:30:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JT5Xs0rQc5iZyrjAGUAvRPpqQU0EqikIZ9DNqP5ERzkIZtl3urN2W4+KlUOcmF3XWmMUNybl7W8Pi89gFi2v1iJtfyKUGDOYrOIq9uM5Ue4cFtxVgsl4pvFX7w4CqGj6m2Bqy5neH6ywmUCFZXSN6YX1UaUk2E0DZZLSzQ5NcqK6ZSt4GNIHQqSKZhbAYRrgw7mSm6v1ytncSCdj8adU4dFHyeUFD54351RKVdpWr6X9XZHy6BhvDENkuDb0tTLEmpF5rrghh9YSR1ASyifgLsZKKatkyL1racqSjaJtX1WqkpI3hIocNa/V/DIuDObFJSPoLh+aWbZgpzgTKa4HGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uXDtvZIZ5quISiWDdLq3n2vm/ynqJjE+D/cEaUvVCok=;
 b=Na1cJqcqxzMyEu272u0czx4JPNgiihjRGH/IqiQ64FlGqBCrir9Vefla9cO0WL7U6zSwQS/RTX8/AqSaaEOkwrWXPmz4UmXqUyje/sCZ9jVBEOlAv46glsCS7wrYeoPqnoLuj/pHGkUASS2CuqqroXQFVyaVai5n6WRmMVcblX7FxrWZY9oL4JYP7wv4tQ+Xg8zumf5CU1rrNIVWEj46I9h+VhWVQ5+Re0j2GCfrGeCFs/gv1KHAj1R5Gkmj9RhPRW+GI/zhNfg1b9zNkA1Lk28TBbtPO2Jz8QgDCozTVZmGeVBhXzUOQ2AmzR97hwRkY/tSKRNma2ywnf80GBJ4Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sophos.com; dmarc=pass action=none header.from=sophos.com;
 dkim=pass header.d=sophos.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sophosapps.onmicrosoft.com; s=selector1-sophosapps-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXDtvZIZ5quISiWDdLq3n2vm/ynqJjE+D/cEaUvVCok=;
 b=B0VmZZyOrhMujmJz7NY5aVkpbpTLR18yBwImdF/Kpni/+XyEo94ZI2GAWV7rXlyozISK7gzTUS9zqveN2THrk2H2YV8bsxj9idXTDl7b7HaoGKhif2p0rhkUiD+A7Lttqpsc5PDiEVCP/02lgu45VZ66bDumXYtRTXcPzUsSECo=
Received: from CWLP265MB4972.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:13f::13)
 by LNXP265MB2537.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:134::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 23:30:40 +0000
Received: from CWLP265MB4972.GBRP265.PROD.OUTLOOK.COM
 ([fe80::d529:cb1f:53f7:f580]) by CWLP265MB4972.GBRP265.PROD.OUTLOOK.COM
 ([fe80::d529:cb1f:53f7:f580%3]) with mapi id 15.20.4995.016; Fri, 18 Feb 2022
 23:30:40 +0000
From:   Nick Gregory <Nick.Gregory@Sophos.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] netfilter: nf_tables_offload: incorrect flow offload
 action array size
Thread-Topic: [PATCH nf] netfilter: nf_tables_offload: incorrect flow offload
 action array size
Thread-Index: AQHYJFH2oPoQyb/RKk29IKFSD90uc6yZ9nAA
Date:   Fri, 18 Feb 2022 23:30:40 +0000
Message-ID: <6C36BEB8-D8B1-4A1F-9649-55670CCF547C@sophos.com>
References: <20220217225826.2722097-1-pablo@netfilter.org>
In-Reply-To: <20220217225826.2722097-1-pablo@netfilter.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=Sophos.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8bfb6bd-9f1d-40f8-c2bd-08d9f336acff
x-ms-traffictypediagnostic: LNXP265MB2537:EE_
x-microsoft-antispam-prvs: <LNXP265MB2537D24CD81B3B242DB4557FFF379@LNXP265MB2537.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CnsSLaCxhavNBFRw1DUN9ukfCccq4HYwrwvKTSROCB4LQV/86Ck5HWneLL6SJ7Ofgfw3mjHZQokNf9VL1hi5n/saudHg0pcqlE7LF369+smB7q9jdpz7D65si2qByfjfiUxZhan+eb28QCkQOmqY4gjAIOnWx46249qkzkbv+i0p3b47Mbyzg4iGl9i7duZT+u5dKYbhONBZznCOPsAmZ+XNMZqPPkmMp/ss5NLg7JGKmy+nIUn4n331tL1x6IvSDWYcPpb98Di96mFa6YSs2UnAMZdcJ5q3szKL99le0ZkrohfWey951p88mMfj9o2zOy1sct+1iBW7qQ9dDHFAG5fEZYbwNVqzQx7gktW9abL/zX6J8zYUm6WBEvVbrevB/ATAuqHKu0GWbE2uhJRt0NYu2obnZTaS0OdOGH3RhzzZk1f7dHEBxFv0pmaBgzPzamxrGf/yeKZts42K3JcURv7nuX1IU5poaM6yagwLgWUcYLCVPQezWlXpTWJ9d3eGTeDsAm2A9WyhTw8t7grzRwvmUychlZlQJ2jFPbLwxBmiymCv8Xa7sxIv7IXBbh7q/r+5AjNbof2cgMMLGAMyvQ4z99+XV6VrvDKrR8ccw+ulB71KapkJgEtOLkauyLk1CznNf8mXZmdFfPZY6ZyvwL/jncVBhBEqPKNT/1/Y0mntBw6KOwfEbyNuI/9drZm/kDfKfz3rNALSmk+ExTLtHrZQ/Z2OulzEjfkV42zbX/tVj4+8t0p65v1x72iD+LqI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB4972.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(33656002)(122000001)(38100700002)(38070700005)(86362001)(6486002)(316002)(2906002)(91956017)(6916009)(76116006)(5660300002)(8676002)(66946007)(4326008)(66446008)(8936002)(66556008)(66476007)(64756008)(2616005)(6512007)(186003)(26005)(53546011)(508600001)(36756003)(6506007)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YlqVdTtvHbMsr88d19KuSEjGfg9azEjnwDGOLIU7XI5N/eNz36RO/mk59G4t?=
 =?us-ascii?Q?+AqcTzjNvHbX+1uh4YQqzjo9x0rdU7FwRufLqP+2GCH0sgmyConu72Uj/AaH?=
 =?us-ascii?Q?NAw9174D8zToNnW8RZSazM0bUMaxJBptp8Pb2Tyc0OoY0menSSF1tx6JijPg?=
 =?us-ascii?Q?v5GtQB1szRcmYyLsbz423NlunSX9FRoFJxOQkdVVI+u2OoR4xsd8GtizSS7r?=
 =?us-ascii?Q?j+62vqIDE6Veij304FPYmKtXi1gGSt4vrnkL9Xz0p8pmYjPbvzxIfwHBreiE?=
 =?us-ascii?Q?4Qic21jYTyDMA+bqCAlvfbpFF+r+fXU7Wk1GGyhuN+Kx+dhfD7ZDrsEAc+/e?=
 =?us-ascii?Q?jM0MxOBfRjp1IqYQZbMJ80CwoScFWXKTNb3zHQnwl8eVGFtS+QtCyUZWtDh0?=
 =?us-ascii?Q?NXgDPb/HYmR4+DdEUsOnH+d12txX853hPUbssnAuoskCBT2z1XrBk5JBbIrL?=
 =?us-ascii?Q?AthRk/uZxZ917FWN6nKWT8e8MeQq6CfJoXKBeB8MmvKpXuO4FRPF3FcnWyFt?=
 =?us-ascii?Q?lj3oj4LtJricCTuDeilMkLBLN/0SnOCvkAZqaF+UsHgxWbiVQE+C8FVw8kan?=
 =?us-ascii?Q?GQG/IT9NwsULfW7A3MTL+cgG0bqWT7L9eLg+jGJjThK5SDXRmaAGJCeY60g0?=
 =?us-ascii?Q?sX3AOYZNbvxNY67JJG17ArU5svx++wIZZLgWVAFG8WYnm2/mm8jMrTd1WuDo?=
 =?us-ascii?Q?9TNAuqStZQoyI3dnOYYuoHLsTZQQ6hmlISOUhHQkW/TbiziiV/EcAE7Hy4vx?=
 =?us-ascii?Q?5ekjIrSXOfqzxMRSL4FwWwdQcwS/mvKpSoTYqJHXJaznEJtBGZsRlqEJR66x?=
 =?us-ascii?Q?VXhM8aWDyHlZS2ouIl/+lmhehS7RdNVWYjE8POQ3zFfAeedJgT1fQMCgP/Za?=
 =?us-ascii?Q?UXQvd5p0wDaIe8cCe7TVYpCnX2cpMnZN6xPlFjK7bPPOhNtl5293SLKuCn8f?=
 =?us-ascii?Q?rG3MZWVwukHB6zFaIGpQeSluRsvc+NKd+oeTqkKgy489ueRpJZVbFIFdAkb6?=
 =?us-ascii?Q?liY5lzyTpJtw3aBQYsE2Ev1Nhx67em8LRCzhROWVqiafnyW0Vu2N5toScrhF?=
 =?us-ascii?Q?QcJjJ1RTs2/hQr/PP5w9JNP79XvusvJmeWo0wPniZiBrB3kgnRm3RIiL0vC/?=
 =?us-ascii?Q?OAidWu3IcY1bLFJYIEEDZjhlXZS7GomzcR4nyT7ycknaceAZWYq+FctmQP5L?=
 =?us-ascii?Q?1/n2rsyPnryTERhnWoxFqFn7YaoC9UfBjtIz0Jd2WQws9ZrxcnRkqZi2co1I?=
 =?us-ascii?Q?KBMbxDUgbPNX9jvV7+h6hvqDfrE3dLGCsSK0C1EeyVUuXqMbQwixeWQaL/q7?=
 =?us-ascii?Q?265GIVyw6644TG/Sn5xd5/gHoBRJ2p7ypWzcQve1RFV6Kk4FlwA8PKhahk8q?=
 =?us-ascii?Q?3YLPNkPv5frQLFjXloah5UX2Nwx7Trcfa8Ef9ewmHb9yb8fVhGKf5u8LAPmM?=
 =?us-ascii?Q?hJmZrXcEGgdk8EbhIyKhOTAWUDzilUupys+v295HkSUKNQK9J0obe6eFB8bp?=
 =?us-ascii?Q?6OUA2TZC7aqPUtMQEB7izKCw/zJ1OXO2B1AVMyVq/hByZ7sF5eI5K6INwXSN?=
 =?us-ascii?Q?RDbr+k2imYTVxRxWXOpVBfIBUpGmtrNEpXkDbCzvWHUtbZWwU27QKx/3OL9U?=
 =?us-ascii?Q?8V/Ee0Q5KtXyAquFlNVNA/k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A5C2819CE329C54AAF5B51B5C29895FD@GBRP265.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB4972.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e8bfb6bd-9f1d-40f8-c2bd-08d9f336acff
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 23:30:40.5549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 358a41ff-46d9-49d3-a297-370d894eae6a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zBHMe3408VvDB3gc982u5CYX+Dcgbb31BKJzbzF0dWrRqz8dbN/Xn7/WudZ2eGfM75cuOJZ9qCvETF/Oz0/1WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP265MB2537
X-OriginatorOrg: sophos.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sophos.com; h=from:to:cc:subject:date:message-id:references:in-reply-to:content-type:content-id:content-transfer-encoding:mime-version; s=global; bh=uXDtvZIZ5quISiWDdLq3n2vm/ynqJjE+D/cEaUvVCok=; b=PJKdQTmqrER1ed/3Ot8GMpJMNul0VsPviApoKEMgb4ei/yP0T0QdRDw8ruVDXuGLk06SCMTe36bGSAXkbVxujNuvGiHxYSc+mkLiKcdNe3nHNGIz/BsC4B/7HmNG4o+SH2muR6c1q4y5IfANfRhTNr5cwNQMkaG/odwawA8VU1w=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tested-by: Nick Gregory <Nick.Gregory@Sophos.com>

> On Feb 17, 2022, at 5:58 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
>=20
> immediate verdict expression needs to allocate one slot in the flow offlo=
ad
> action array, however, immediate data expression does not need to do so.
>=20
> fwd and dup expression need to allocate one slot, this is missing.
>=20
> Add a new offload_action interface to report if this expression needs to
> allocate one slot in the flow offload action array.
>=20
> Fixes: be2861dc36d7 ("netfilter: nft_{fwd,dup}_netdev: add offload suppor=
t")
> Reported-by: Nick Gregory <Nick.Gregory@Sophos.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> include/net/netfilter/nf_tables.h         |  2 +-
> include/net/netfilter/nf_tables_offload.h |  2 --
> net/netfilter/nf_tables_offload.c         |  3 ++-
> net/netfilter/nft_dup_netdev.c            |  6 ++++++
> net/netfilter/nft_fwd_netdev.c            |  6 ++++++
> net/netfilter/nft_immediate.c             | 12 +++++++++++-
> 6 files changed, 26 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf=
_tables.h
> index eaf55da9a205..c4c0861deac1 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -905,9 +905,9 @@ struct nft_expr_ops {
> 	int				(*offload)(struct nft_offload_ctx *ctx,
> 						   struct nft_flow_rule *flow,
> 						   const struct nft_expr *expr);
> +	bool				(*offload_action)(const struct nft_expr *expr);
> 	void				(*offload_stats)(struct nft_expr *expr,
> 							 const struct flow_stats *stats);
> -	u32				offload_flags;
> 	const struct nft_expr_type	*type;
> 	void				*data;
> };
> diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netf=
ilter/nf_tables_offload.h
> index f9d95ff82df8..797147843958 100644
> --- a/include/net/netfilter/nf_tables_offload.h
> +++ b/include/net/netfilter/nf_tables_offload.h
> @@ -67,8 +67,6 @@ struct nft_flow_rule {
> 	struct flow_rule	*rule;
> };
>=20
> -#define NFT_OFFLOAD_F_ACTION	(1 << 0)
> -
> void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
> 				 enum flow_dissector_key_id addr_type);
>=20
> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_=
offload.c
> index 9656c1646222..2d36952b1392 100644
> --- a/net/netfilter/nf_tables_offload.c
> +++ b/net/netfilter/nf_tables_offload.c
> @@ -94,7 +94,8 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *=
net,
>=20
> 	expr =3D nft_expr_first(rule);
> 	while (nft_expr_more(rule, expr)) {
> -		if (expr->ops->offload_flags & NFT_OFFLOAD_F_ACTION)
> +		if (expr->ops->offload_action &&
> +		    expr->ops->offload_action(expr))
> 			num_actions++;
>=20
> 		expr =3D nft_expr_next(expr);
> diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netde=
v.c
> index bbf3fcba3df4..5b5c607fbf83 100644
> --- a/net/netfilter/nft_dup_netdev.c
> +++ b/net/netfilter/nft_dup_netdev.c
> @@ -67,6 +67,11 @@ static int nft_dup_netdev_offload(struct nft_offload_c=
tx *ctx,
> 	return nft_fwd_dup_netdev_offload(ctx, flow, FLOW_ACTION_MIRRED, oif);
> }
>=20
> +static bool nft_dup_netdev_offload_action(const struct nft_expr *expr)
> +{
> +	return true;
> +}
> +
> static struct nft_expr_type nft_dup_netdev_type;
> static const struct nft_expr_ops nft_dup_netdev_ops =3D {
> 	.type		=3D &nft_dup_netdev_type,
> @@ -75,6 +80,7 @@ static const struct nft_expr_ops nft_dup_netdev_ops =3D=
 {
> 	.init		=3D nft_dup_netdev_init,
> 	.dump		=3D nft_dup_netdev_dump,
> 	.offload	=3D nft_dup_netdev_offload,
> +	.offload_action	=3D nft_dup_netdev_offload_action,
> };
>=20
> static struct nft_expr_type nft_dup_netdev_type __read_mostly =3D {
> diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netde=
v.c
> index fa9301ca6033..619e394a91de 100644
> --- a/net/netfilter/nft_fwd_netdev.c
> +++ b/net/netfilter/nft_fwd_netdev.c
> @@ -79,6 +79,11 @@ static int nft_fwd_netdev_offload(struct nft_offload_c=
tx *ctx,
> 	return nft_fwd_dup_netdev_offload(ctx, flow, FLOW_ACTION_REDIRECT, oif);
> }
>=20
> +static bool nft_fwd_netdev_offload_action(const struct nft_expr *expr)
> +{
> +	return true;
> +}
> +
> struct nft_fwd_neigh {
> 	u8			sreg_dev;
> 	u8			sreg_addr;
> @@ -222,6 +227,7 @@ static const struct nft_expr_ops nft_fwd_netdev_ops =
=3D {
> 	.dump		=3D nft_fwd_netdev_dump,
> 	.validate	=3D nft_fwd_validate,
> 	.offload	=3D nft_fwd_netdev_offload,
> +	.offload_action	=3D nft_fwd_netdev_offload_action,
> };
>=20
> static const struct nft_expr_ops *
> diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.=
c
> index 90c64d27ae53..d0f67d325bdf 100644
> --- a/net/netfilter/nft_immediate.c
> +++ b/net/netfilter/nft_immediate.c
> @@ -213,6 +213,16 @@ static int nft_immediate_offload(struct nft_offload_=
ctx *ctx,
> 	return 0;
> }
>=20
> +static bool nft_immediate_offload_action(const struct nft_expr *expr)
> +{
> +	const struct nft_immediate_expr *priv =3D nft_expr_priv(expr);
> +
> +	if (priv->dreg =3D=3D NFT_REG_VERDICT)
> +		return true;
> +
> +	return false;
> +}
> +
> static const struct nft_expr_ops nft_imm_ops =3D {
> 	.type		=3D &nft_imm_type,
> 	.size		=3D NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
> @@ -224,7 +234,7 @@ static const struct nft_expr_ops nft_imm_ops =3D {
> 	.dump		=3D nft_immediate_dump,
> 	.validate	=3D nft_immediate_validate,
> 	.offload	=3D nft_immediate_offload,
> -	.offload_flags	=3D NFT_OFFLOAD_F_ACTION,
> +	.offload_action	=3D nft_immediate_offload_action,
> };
>=20
> struct nft_expr_type nft_imm_type __read_mostly =3D {
> --=20
> 2.30.2
>=20

