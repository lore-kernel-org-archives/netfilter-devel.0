Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68AA6C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Feb 2022 06:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiB1Gkn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Feb 2022 01:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiB1Gkl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Feb 2022 01:40:41 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30108.outbound.protection.outlook.com [40.107.3.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EB73CFFB
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Feb 2022 22:40:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CACTnXlGSHFzSBs7BfH/ks9TwlAP5EAywcUcNzb2exQTjpKw8rxltrWbZE1pCAurs5Vw9F7B+m4jxH+uQfA/gofEtvgpJuTgIIyw3jPRXYAx8+smWK7xwWJHUh/LLtmuQR/vy6mwd88Xd+RDkGxkw8gjV5xf3p8bvw2HsSMGLGWmW+VuFALgmTAHxvSZopL838IR2erENbDfVKZS1B7Gsi7r2+3kaeinJY0smtnaxfRBDGRVzaFqBpqlTlpJQ9gftARjthXI2PVfqzALkodPVAsAZ4VcMI3BxJm+fZ0njk6rqJ35b4o+zuq50pXig6nr/1sQMGeWTePLQm0/g70MTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9sUpoLWic4TAHJRENZjhXgcSYKelHItv+jsbhDyo/o=;
 b=USfpWf3HOGO5P0GpSUzaEVj1IB8d9JhJR5/9uDU8WVjdZQ/9n/xr9DS0720U7Ab6AgzTT5U6CHH5AKVF/Iu7Q++zlfsDAHbTbVdhtb8yWujd+KyNxL5HkZJx4yLRHtae+WOd3/Zx2RUl2wF5Lu5v0zOZOseAoFfn1s2oz1TfmG0JFi9RWVsZdDYGW9nFBseFNlwbMjseUs0WR0l4MlBFRRnEBETmiyK/Bmw446HJkcFZLpYFhGk8fPR8M2BM71t3LULM4xPQiGXuahPeue1uLkWzMISDH4+IlsH6LmN9KjuSmhOAFNm+nDMcDWrCx/XxuJGAUZyoWhzV+jGbYRx8eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9sUpoLWic4TAHJRENZjhXgcSYKelHItv+jsbhDyo/o=;
 b=Y6a1eM35Z93/AaMJqtkqigC+o4/5yP8/Rdu360MDl0+GPfh8s9TYLlwqZIdECj/1/SJ0Da//pTxhvnv4xO1qsMIA/UHyDGJpkDcVcIsDXH4me0WfH8IRrOTLuV7YYVxrPiLiyhgQXZHw1C+wBXs7Ikkba+VMciztMal0BWJXLcA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from VI1PR08MB3245.eurprd08.prod.outlook.com (2603:10a6:803:48::20)
 by DB7PR08MB3340.eurprd08.prod.outlook.com (2603:10a6:5:20::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 06:39:59 +0000
Received: from VI1PR08MB3245.eurprd08.prod.outlook.com
 ([fe80::4007:6de5:a0b9:1533]) by VI1PR08MB3245.eurprd08.prod.outlook.com
 ([fe80::4007:6de5:a0b9:1533%6]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 06:39:59 +0000
Message-ID: <81d734aa-7a0f-81b4-34fb-516b17673eac@virtuozzo.com>
Date:   Mon, 28 Feb 2022 09:39:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH RFC] memcg: Enable accounting for nft objects
To:     Roman Gushchin <roman.gushchin@linux.dev>,
        Linux MM <linux-mm@kvack.org>
Cc:     kernel@openvz.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>, kernel@openvz.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0009.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::19) To VI1PR08MB3245.eurprd08.prod.outlook.com
 (2603:10a6:803:48::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b14d1ded-8e10-42c4-5673-08d9fa85236b
X-MS-TrafficTypeDiagnostic: DB7PR08MB3340:EE_
X-Microsoft-Antispam-PRVS: <DB7PR08MB3340852D79BAA0B6710814A8AA019@DB7PR08MB3340.eurprd08.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Gmpch8ULgvDYaaGijL90FkUhJdz4evgO4ANNwIsGP+KIrrLuGBFMSwn+1eXWEwuSg9k+jasMaUdvKxKUl22fiNs1Wz27RfskAazrEar4/rU1kugbauOBnMTN1TiVH7PjSj+P74FFcaQDtXq2j48/UmZT0nUYQAIjn7zzcbYPQ05LJhnZ779HGkYEFfE2zPQzQSNMvYteNfozkwT0HItMrznDLnR1MmNH80AFzAZ96i1DJVBKYOq4gr/k/XbLwFjBrSyNdmbp5L3qF80A2/vml/I3LgChIe8rP8BewcO0xdmPuO6qwrrWxd8/O4JyviUH/VlxeMiI583OvN4RMb2EsY6Z1zTe6gg8V39Xep2yG+xw0AspWFbu8Xdg/HcfvuT+iHyrYtDr9RB+/HyWIQn07E8lSOZEIYraKceb7lJ3npAkVP4LB0tlupTkNRW5xl7JXzuwU1aO9uVzwLq72NcBHHSB5q8dDPoJNr+znlELgY8DR6JVRoCW/H4rx4Gmwojks52Id4stMv/8ZvfRrQLNP1gPPEqXfZ+vvQRGqEP6RebM8xtoZkacn36tGCvQLCSb7EIu4aV3norIHJaQx/cULVLcPbth9ZhVAoFmAmW0ZXerbzSP92yOKRNPXWNaF7wlTcLVHufxMCC0hA9rhyQNyZqKpYi6v7+Lk9g12X/Uxwk9Jx6hATafLFCTfoKHDX0lGFKeGC0SPbHR1NmLLSiu1CeRJjeWntNDQ8lwunXx7rtrTkNIDbWxh25hkMiDHL01h5TB7uOUpTQxbMXDj/HIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3245.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(6486002)(2906002)(508600001)(110136005)(31696002)(6506007)(5660300002)(2616005)(8936002)(36756003)(38100700002)(38350700002)(31686004)(107886003)(316002)(52116002)(6512007)(66476007)(66946007)(4326008)(66556008)(8676002)(186003)(26005)(6666004)(86362001)(83380400001)(15650500001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmVBbDAyOSszN2paSnoyTTV2WU1jTkpUam03SHE3MDhyZnJCNWphUTNTejY5?=
 =?utf-8?B?dnlHcW5lV3BYRkdQdVpKTFAwUHNzRGR2K1prZXN1VytnaEFyTk9uMy96S1lm?=
 =?utf-8?B?cUlmVVpoYUJLeU5MVm9QalVJUFpWaXB1MmlUTTRrditDdWVrT1ppdTNPbjJx?=
 =?utf-8?B?dWNXeld3bjg1czBrUHlobmN1RUNGVlVjMEdNb3JPUFJ2TkE3VlV6eHVNZVph?=
 =?utf-8?B?ZEN1aUpVeDhYZUo2Y1ZZTjhSbFhldGZjN04yWnk4enRWcUx1NjZzeEJBVlNv?=
 =?utf-8?B?cENrVnZ3clJYSVdVSTV2ZEpYcnRZWEtRVm5nRFU3bHRKaFlnanQxeDJ2aWNB?=
 =?utf-8?B?Yitnc09kazZNd0p2aWZGN1dHTWZLNElLMDBOUnFKUUEzdFRoREJQVjk0OU5t?=
 =?utf-8?B?Yk9XcnFjcWpWYXN1YWdEcitVc1ZUODIzcCtJMHo5R3M4bVJzcllycVJ2ZGw3?=
 =?utf-8?B?YlZVQlphT2tFdnl3UDhVTmJzeHRPU3hGTDF0cGtIK2VueFg4RG1PQUJnbytl?=
 =?utf-8?B?QUI5aFVSTThyOTcyQjcydWNXcGNBS29zdTNNbjNqT0lkVG4xbGNZcS9ORTAz?=
 =?utf-8?B?K1hGRU9zYWYrdE5rZTJxOXkyYUlMazZGUWF0T29UaE0yU0FIS3dnSWRaNUV1?=
 =?utf-8?B?elZxVDFOeWkzWFk4bmdQdXVIQVkvRTRrdzdyemtoMG1aMGVNRjhSRElpcDMx?=
 =?utf-8?B?cEpIUlBGOEtnQ1RGdjNlbHF3b1kxeTgvZ092Q2ViWDNEeER4ZkE4NU01YTcv?=
 =?utf-8?B?TnMzKzRReWpUOFErbm53V3NCNUNLc0pnUFZFNTlUbU5LK01YaVZxZGljWlpT?=
 =?utf-8?B?bE9mL3o0RlMxUW80cUhIRDE4N3NrVkZ3YVcreTNRN3I1Mm1xN2taVllaZDhH?=
 =?utf-8?B?UkFtc3BSZjRzN2tMZnFNQUlmMlhUeC92ajA1Qnkva3FuR2NCN2xwTVhLdlhK?=
 =?utf-8?B?Q0RZdjU3Q2I4eWNVNy95QlFGR2dYNmU2MXBHWkxYelJOcDd4YXorTC9KRW9y?=
 =?utf-8?B?b1VDRUtKcXBIcVJRQWF3RW83c1A2eHB2aXJzSmI2ck13MDlrV21sUmNWSjkw?=
 =?utf-8?B?aTQ5UTNtaEJXbHR0SWRFbWFReU1mN1R2OGYvQnB0bis0aFZSMExRcC9rWnpn?=
 =?utf-8?B?MGhJNWdEYW83YzRGREUzOUZhbVJEZTZvMU5CNVZJdEJ6a3E1c3ZnMUxsMXN5?=
 =?utf-8?B?Qi9pWlpiQXpxeU9ZbW1zOFlqWjBod2dXTlUwMGRWOE9vMURzN1l2bklxTE5h?=
 =?utf-8?B?QjBrcXc4K2J3N3NVdzVFNHhDeXBSaXFKMTF4a1NreVNjZ1FYeGI4UVQ4bklW?=
 =?utf-8?B?ZFdLc3paNWR4dk5SWVNCVHlWUTF3dGdOalRva0V5WEU4M2pXcEZpaWNmWFdP?=
 =?utf-8?B?MEVaOGdLbTVBbTNnRjhsaFRQQk1CdytRS3IvNjdXelNidjFFbEdZVVVqTkFB?=
 =?utf-8?B?blFoZ2NFNmJvME5oMFRUOXoyNncvNFF5b0xidWswU1ZneUVGS1Z6eFJrR3JP?=
 =?utf-8?B?Nnl2cmgram15TE9OdUVieTJPb0ZPY3VXNGQxUksyYWpHZmNSL1lWMDRHb3hm?=
 =?utf-8?B?TXBqeUtOZnRwTkoyQmtBL3Y4bmo3dllPU1hrT3J3MU4xTlF3c0pnM1ZaTk9B?=
 =?utf-8?B?WmlVT09xWWtvTzZhVkZaYnlWTngrYmtyZk1Ib3NraTVUWEtIZzhKVlROUGgz?=
 =?utf-8?B?c1ZtK1ROUExtaUxPMWMyazRJVk9kTnRiQ1B3cko1a1pIVzBHT0lCVUQ2TytU?=
 =?utf-8?B?MFd5Y0ExY0tab2ZyNFR1NnZaekdETEp3eWlWenh0ckJpWEU4TDRDWHhkOEtF?=
 =?utf-8?B?Ym5wOS9LWkY1VVRpVTgvei9zYnlpZ3g3ZVF2eE5SeHVKdnZIaTRvUDJObDgw?=
 =?utf-8?B?L1VURndrMGg3TVF4b0dpVmN1VUd1Z3ppM2dkd01hbDJKNEIveXNnd0F2M2NB?=
 =?utf-8?B?QlZWUit2VW51WDdWTi9jZ1pRZ3dodDBGNndXbmF0RCtFSmxpS282NSsrNXZt?=
 =?utf-8?B?NFZ2RXY2SnR1V0lBLytxeks1RW9sOUIyUndreXBMN1dqTWF0Wjk1UERFbDU1?=
 =?utf-8?B?SThvQ0UzMUlraWRqNnlqZEJKQnhaTFJMWWtDTkNrQ2l6QnpZVW14QUNlQzNT?=
 =?utf-8?B?YnNqSkVEbTF5NUNVZENJN3UrblUza21CRnFDalFhTkZtYkwxN3IxN2RxNUpK?=
 =?utf-8?Q?peHcHL0wK2X96x3C1GmFefE=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b14d1ded-8e10-42c4-5673-08d9fa85236b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3245.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 06:39:59.2560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VvPiEKYqcQow71Ocvw0HuP0zcPmEeOYBOaQ4B4TAYBH5XwAfCD24/kBXN+VeiuegghZB9hdJVs9UrA/y2SaF4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3340
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nftables replaces iptables but still lacks memcg accounting.

This patch account most part of nft-related allocation and should protect host from nft misuse
inside memcg-limited container.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
  net/netfilter/core.c          |  2 +-
  net/netfilter/nf_tables_api.c | 51 +++++++++++++++++++----------------
  2 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 354cb472f386..6a2b57774999 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -58,7 +58,7 @@ static struct nf_hook_entries *allocate_hook_entries_size(u16 num)
  	if (num == 0)
  		return NULL;
  
-	e = kvzalloc(alloc, GFP_KERNEL);
+	e = kvzalloc(alloc, GFP_KERNEL_ACCOUNT);
  	if (e)
  		e->num_hook_entries = num;
  	return e;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5fa16990da95..5e1987ec9715 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -149,7 +149,7 @@ static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
  {
  	struct nft_trans *trans;
  
-	trans = kzalloc(sizeof(struct nft_trans) + size, gfp);
+	trans = kzalloc(sizeof(struct nft_trans) + size, gfp | __GFP_ACCOUNT);
  	if (trans == NULL)
  		return NULL;
  
@@ -1084,6 +1084,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
  	struct nft_table *table;
  	struct nft_ctx ctx;
  	u32 flags = 0;
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
  	int err;
  
  	lockdep_assert_held(&nft_net->commit_mutex);
@@ -1113,16 +1114,16 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
  	}
  
  	err = -ENOMEM;
-	table = kzalloc(sizeof(*table), GFP_KERNEL);
+	table = kzalloc(sizeof(*table), gfp);
  	if (table == NULL)
  		goto err_kzalloc;
  
-	table->name = nla_strdup(attr, GFP_KERNEL);
+	table->name = nla_strdup(attr, gfp);
  	if (table->name == NULL)
  		goto err_strdup;
  
  	if (nla[NFTA_TABLE_USERDATA]) {
-		table->udata = nla_memdup(nla[NFTA_TABLE_USERDATA], GFP_KERNEL);
+		table->udata = nla_memdup(nla[NFTA_TABLE_USERDATA], gfp);
  		if (table->udata == NULL)
  			goto err_table_udata;
  
@@ -1803,7 +1804,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
  	struct nft_hook *hook;
  	int err;
  
-	hook = kmalloc(sizeof(struct nft_hook), GFP_KERNEL);
+	hook = kmalloc(sizeof(struct nft_hook), GFP_KERNEL_ACCOUNT);
  	if (!hook) {
  		err = -ENOMEM;
  		goto err_hook_alloc;
@@ -2026,7 +2027,7 @@ static struct nft_rule_blob *nf_tables_chain_alloc_rules(unsigned int size)
  	if (size > INT_MAX)
  		return NULL;
  
-	blob = kvmalloc(size, GFP_KERNEL);
+	blob = kvmalloc(size, GFP_KERNEL_ACCOUNT);
  	if (!blob)
  		return NULL;
  
@@ -2110,6 +2111,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
  	struct nft_trans *trans;
  	struct nft_chain *chain;
  	unsigned int data_size;
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
  	int err;
  
  	if (table->use == UINT_MAX)
@@ -2126,7 +2128,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
  		if (err < 0)
  			return err;
  
-		basechain = kzalloc(sizeof(*basechain), GFP_KERNEL);
+		basechain = kzalloc(sizeof(*basechain), gfp);
  		if (basechain == NULL) {
  			nft_chain_release_hook(&hook);
  			return -ENOMEM;
@@ -2156,7 +2158,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
  		if (flags & NFT_CHAIN_HW_OFFLOAD)
  			return -EOPNOTSUPP;
  
-		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
+		chain = kzalloc(sizeof(*chain), gfp);
  		if (chain == NULL)
  			return -ENOMEM;
  
@@ -2169,7 +2171,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
  	chain->table = table;
  
  	if (nla[NFTA_CHAIN_NAME]) {
-		chain->name = nla_strdup(nla[NFTA_CHAIN_NAME], GFP_KERNEL);
+		chain->name = nla_strdup(nla[NFTA_CHAIN_NAME], gfp);
  	} else {
  		if (!(flags & NFT_CHAIN_BINDING)) {
  			err = -EINVAL;
@@ -2177,7 +2179,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
  		}
  
  		snprintf(name, sizeof(name), "__chain%llu", ++chain_id);
-		chain->name = kstrdup(name, GFP_KERNEL);
+		chain->name = kstrdup(name, gfp);
  	}
  
  	if (!chain->name) {
@@ -2186,7 +2188,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
  	}
  
  	if (nla[NFTA_CHAIN_USERDATA]) {
-		chain->udata = nla_memdup(nla[NFTA_CHAIN_USERDATA], GFP_KERNEL);
+		chain->udata = nla_memdup(nla[NFTA_CHAIN_USERDATA], gfp);
  		if (chain->udata == NULL) {
  			err = -ENOMEM;
  			goto err_destroy_chain;
@@ -2349,7 +2351,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
  		char *name;
  
  		err = -ENOMEM;
-		name = nla_strdup(nla[NFTA_CHAIN_NAME], GFP_KERNEL);
+		name = nla_strdup(nla[NFTA_CHAIN_NAME], GFP_KERNEL_ACCOUNT);
  		if (!name)
  			goto err;
  
@@ -2797,7 +2799,7 @@ static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
  		goto err1;
  
  	err = -ENOMEM;
-	expr = kzalloc(expr_info.ops->size, GFP_KERNEL);
+	expr = kzalloc(expr_info.ops->size, GFP_KERNEL_ACCOUNT);
  	if (expr == NULL)
  		goto err2;
  
@@ -3405,7 +3407,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
  	}
  
  	err = -ENOMEM;
-	rule = kzalloc(sizeof(*rule) + size + usize, GFP_KERNEL);
+	rule = kzalloc(sizeof(*rule) + size + usize, GFP_KERNEL_ACCOUNT);
  	if (rule == NULL)
  		goto err_release_expr;
  
@@ -3818,7 +3820,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
  		free_page((unsigned long)inuse);
  	}
  
-	set->name = kasprintf(GFP_KERNEL, name, min + n);
+	set->name = kasprintf(GFP_KERNEL_ACCOUNT, name, min + n);
  	if (!set->name)
  		return -ENOMEM;
  
@@ -4239,6 +4241,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
  	int err, i;
  	u16 udlen;
  	u64 size;
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
  
  	if (nla[NFTA_SET_TABLE] == NULL ||
  	    nla[NFTA_SET_NAME] == NULL ||
@@ -4382,11 +4385,12 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
  	alloc_size = sizeof(*set) + size + udlen;
  	if (alloc_size < size || alloc_size > INT_MAX)
  		return -ENOMEM;
-	set = kvzalloc(alloc_size, GFP_KERNEL);
+
+	set = kvzalloc(alloc_size, gfp);
  	if (!set)
  		return -ENOMEM;
  
-	name = nla_strdup(nla[NFTA_SET_NAME], GFP_KERNEL);
+	name = nla_strdup(nla[NFTA_SET_NAME], gfp);
  	if (!name) {
  		err = -ENOMEM;
  		goto err_set_name;
@@ -5921,7 +5925,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
  	err = -ENOMEM;
  	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data,
  				      elem.key_end.val.data, elem.data.val.data,
-				      timeout, expiration, GFP_KERNEL);
+				      timeout, expiration, GFP_KERNEL_ACCOUNT);
  	if (elem.priv == NULL)
  		goto err_parse_data;
  
@@ -6165,7 +6169,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
  	err = -ENOMEM;
  	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data,
  				      elem.key_end.val.data, NULL, 0, 0,
-				      GFP_KERNEL);
+				      GFP_KERNEL_ACCOUNT);
  	if (elem.priv == NULL)
  		goto fail_elem;
  
@@ -6477,7 +6481,7 @@ static struct nft_object *nft_obj_init(const struct nft_ctx *ctx,
  	}
  
  	err = -ENOMEM;
-	obj = kzalloc(sizeof(*obj) + ops->size, GFP_KERNEL);
+	obj = kzalloc(sizeof(*obj) + ops->size, GFP_KERNEL_ACCOUNT);
  	if (!obj)
  		goto err2;
  
@@ -6638,7 +6642,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
  	obj->key.table = table;
  	obj->handle = nf_tables_alloc_handle(table);
  
-	obj->key.name = nla_strdup(nla[NFTA_OBJ_NAME], GFP_KERNEL);
+	obj->key.name = nla_strdup(nla[NFTA_OBJ_NAME], GFP_KERNEL_ACCOUNT);
  	if (!obj->key.name) {
  		err = -ENOMEM;
  		goto err_strdup;
@@ -7364,6 +7368,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
  	struct net *net = info->net;
  	struct nft_table *table;
  	struct nft_ctx ctx;
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
  	int err;
  
  	if (!nla[NFTA_FLOWTABLE_TABLE] ||
@@ -7399,7 +7404,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
  
  	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
  
-	flowtable = kzalloc(sizeof(*flowtable), GFP_KERNEL);
+	flowtable = kzalloc(sizeof(*flowtable), gfp);
  	if (!flowtable)
  		return -ENOMEM;
  
@@ -7407,7 +7412,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
  	flowtable->handle = nf_tables_alloc_handle(table);
  	INIT_LIST_HEAD(&flowtable->hook_list);
  
-	flowtable->name = nla_strdup(nla[NFTA_FLOWTABLE_NAME], GFP_KERNEL);
+	flowtable->name = nla_strdup(nla[NFTA_FLOWTABLE_NAME], gfp);
  	if (!flowtable->name) {
  		err = -ENOMEM;
  		goto err1;
-- 
2.25.1

