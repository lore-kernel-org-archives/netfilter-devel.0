Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62548C64ED6
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Feb 2023 13:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjBZNiZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Feb 2023 08:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjBZNiZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2023 08:38:25 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2108.outbound.protection.outlook.com [40.107.14.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCC37AA5
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2023 05:38:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmbPSi6jc3C8rqAwQW9lnYFFcSjBvqUGYSD0zmd9vbJfOPLZU4XpGsZNaWdzzfV9q6VoHD6OEO4HDG8LGKlMeK46nw68s3WrAtyZLf5/+d6ZhrUEeTK/I0eL+WvvVh3AMCnHPoya5Ex3QWt0OWE5B6wAT/+sWdvtIvULfO7LszqovC4NkqKkcw1WxKS8h758novFLUVIWxNyutjvfUhvsAKCiTqiOYhFNaepZ3N6XeJvqYu3PQgk9IovMN1zfRjXR3x16t56YZmRSIhWZdjLRDDN8KNoxVyc92FKjgoodw2sOe8ZhOeFqtyd84RwIgthdBY6nK3nsL/J0lsYN7xN5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwkWbI4n5yP13a50UCONaub02Te1Y+kW99YDrVY6tTA=;
 b=YmAxwnLz1HvLW0p3zQsyenO8wnRoCWkSXrbJPSTFPoBpzHs6qftaiKpDN2wXBHp11e9p3Guln8BQxPEIWzXDUoJc7Oas1HzxLHLlFMSeTW05kP4J+r/aSph/tKbuKKDVqx83cOmYBnoUsjD7DgRo/N1vZ6lnonQvuZD5BJ9X//ebXYTxQFPwjrHoTwCclnoNr1MuM6aBqJ/R24HOBlcO0V41U4G56wgqEt5R1JX045fMueJUGnJCFXC1wZwJ+eV06H4KASK7cnxc+uidLk4EP2LAUbab5RhwoxOF/larCsTws6J3HUznpGGz9+GFNt9mrXGEXT2y2udXRoUGh+rWtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwkWbI4n5yP13a50UCONaub02Te1Y+kW99YDrVY6tTA=;
 b=eVw6bzbHpTtCuVqoLQOuHD9DE1SN/yb5Um8wJXimoD0+fziQjtbXdsyl5FffiG9lCHmX2Z8i+3K9nKmXNx2lBLQENCJkx3sjSbVoSNKxVlLjwml04UyLe3slEHZg4W75X/FCpQXFjihiMVBJiFQB0vfnxxJA8d4jN13PDgxqgvQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DBAPR05MB7319.eurprd05.prod.outlook.com (2603:10a6:10:1b2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Sun, 26 Feb
 2023 13:38:19 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6%8]) with mapi id 15.20.6134.027; Sun, 26 Feb 2023
 13:38:19 +0000
Date:   Sun, 26 Feb 2023 14:38:15 +0100
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, abdelrahmanhesham94@gmail.com, ja@ssi.bg
Subject: [PATCH v2] netfilter: nf_flow_table: count offloaded flows
Message-ID: <20230226133815.bjcovi4lw2c2fnos@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR2P281CA0042.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::15) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DBAPR05MB7319:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a053a86-9195-4af2-a2d5-08db17feb8a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O4T6ARaSl7AslbkMZA802GlJzviFdlDj4BH4GgPzbR9J9USFQ9CRQFU3fWW0IhFO+ckVNvTaBU9GDPHbW47HaE1lGPiNNmkX4maoevS0Cec36RmE3oV/D48C7LkG1dtSRqCfSljY/dOfvojYWie7B8G9/ETCNpj3ZeU7MPo8fEtzIhwqtzzDCtpvCmrv7frZM3vUvb+Cg0lxUmfJ/oOd5wq3wd+k6x6MCXOtM5I6aXMV/k6xKY8fzGqxVjrateHHLwjRGSh0+NoTUtKoNaMw7fLVtS8xBwfCYx6nQOW+KhBbgro4D2MZj4T+Siw0T19tizht8rmDRRu6nzsokf0UWA9KmNLWySGBL2HzNPqSbmN5vP1CKjKvn82mQZcJQer+opq8Fs43+3ny86v+20iAb4E78SkhVXztWUGXOyrAhpr7guKzshTkZMRmG5swiJj2UXV6mLfWceo1jyWnpkOlKodl7FYkDnw5XYhgc+hT+i62rVPUFuN4q8WKbXn8j75F63SuTDMA7v0qLvds+mH/9tUHMRBR6y/zqmS/Bj0pc5g5XIFLzNBBP6WWFo2GJGDTOP/MenAb3ZH/VbrTkwawtonlsGJFI2Iimf2/M22IM0xb9Xl7/sUvVRhF5xLBy2qxw1UC4NzAg7fbuvUiIF76rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39830400003)(136003)(366004)(346002)(376002)(451199018)(6666004)(1076003)(6506007)(6486002)(186003)(26005)(9686003)(6512007)(316002)(41300700001)(4326008)(6916009)(66476007)(66946007)(66556008)(2906002)(8936002)(86362001)(478600001)(5660300002)(38100700002)(83380400001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oevD+3n9IGOurtI+Npovu7v+CRDgWHLHhJV0K8vLI1ET1hGdWuGfe+ETPamY?=
 =?us-ascii?Q?YGHR0FhUwXmd6jhiZQ7trvTspqcGFJ385DC8FgAiTSzJmrT4USLX/P10j6/S?=
 =?us-ascii?Q?gNN1LwjhwFkv5YXD4hlGaf9e8nwRsSZTK3juy1ONKVNI/XfWC9u7pdB+5b0d?=
 =?us-ascii?Q?PZIO05qRcOlzwkTS6q+TJk0g4MNIwTjSD6iYbOZbZfA0JO9o5obi531lR9gY?=
 =?us-ascii?Q?1tHJg62QsXoAyu0wkoAXdfozNTzkVvX2Eql8QrvNNGefTuC1OrREDZ9uXFVE?=
 =?us-ascii?Q?I3NoAuebEI991NTPiNrDwAOGR9HSQ4YW1+sCCdioVH1YqtZagqzGTwPfj7y5?=
 =?us-ascii?Q?3aNZdIG048CHU2L7vI2c1mnM2iaMpyAQAeiLRyisUY9MlKJJbHdq1uKCnhQk?=
 =?us-ascii?Q?vM6n80hlrXDZ3H2wcQ1Dq2PMr7gw5SCZ1WIPnZ3SSs/AW0ES7hxYn3fwORGM?=
 =?us-ascii?Q?QuaK+f0Fx2iLtOfUmsffw8Uh/+zLWDN1k8x+ho4VXxV4KEwNYg0FjWAT5unu?=
 =?us-ascii?Q?01EqyqLnTSWnjcDWKc6OT9SW/urXW0UtfhNeyzKdFRE+oiXckgcO8MNAes6j?=
 =?us-ascii?Q?4vCI0z7TCwz9BNk8dV02QcWQ7S1hMu2/rWdhXzI4pCVFK9IWCjVV0EvJdDIl?=
 =?us-ascii?Q?MhH2/dcM3RvTgi3gmq4j0LSNqztxpsx1hQeyiRx/eeBsiyQVCQjw/XxcgLvO?=
 =?us-ascii?Q?TZhOwPQsCshfNQOioKStty2f91Ky/AaDIG1znMsyQ2U87C4eBGuR6ISQUWEB?=
 =?us-ascii?Q?mr4bp908RCslegCeosIvdcwalODDdi8xx5xzBLJWuhqno7Z6bojQwQxz+9TP?=
 =?us-ascii?Q?0t/9ysJNxrCn7pGTDv7d7Avnvl+4norIxG0MaJGMSjythoSaAtdHT7zQJXKw?=
 =?us-ascii?Q?iMyHaiUVFeU9PN4BqHHjMJSi9WEF2HE8BeVQlH9O0Mf+5UQgHXH8tCuX1TN0?=
 =?us-ascii?Q?7kLb6WvLBhE7JX/unW9BpYsctB5OW/cEngS6B9AP4QivbH8JazuCG482QsiE?=
 =?us-ascii?Q?VtXEhSsn9tVS9dXeZcNZKKp07wIIFpTO5QunsHvNWWDbLd70+RhcWtkdua3m?=
 =?us-ascii?Q?nAk6yu7dULgjp5EpNioZHUioWC2x1hxKI993o3CpWVXX1xVuGdVdvR5yeCCe?=
 =?us-ascii?Q?WW7Pcm+q79JeDZXTH4h9rNJNjrhtbLJv3iKrlxOFZw3Bn2CkIOMPaL6q4F8N?=
 =?us-ascii?Q?FGE9AyvMYtp9aC0RvRxPJFHjVy3A4MkP9n94iBIHFgBDqXskJLFFBQdaodRM?=
 =?us-ascii?Q?3YQqDlRjMUVWZbvnXdfCfFUxHRJvkmhJzLTKHJurhpQd4i0cDjWFYWgrxN19?=
 =?us-ascii?Q?xfbOkkIXM/VEUiZH+eX2nWyyxC9S96VLpcL3yHyxIZAzXzlME5nLc4NZsQjI?=
 =?us-ascii?Q?PAbsBgQMmU7UBNfTsPs4BgIDjmMKAhnLFeKWUtEMw53nsFwldrvJ5sQeaziF?=
 =?us-ascii?Q?ctn/ySTmuEclSvMy6uwgiuzMdoRBgeNAYGDJne8+TBYLshRC1iqIlnVZkZ5x?=
 =?us-ascii?Q?ozzhGHnEPbruV2gXTxxIhkTjGmyz3Bb1FDFVKi+fzJq/09amNErryFQlH3RH?=
 =?us-ascii?Q?MQpZjJ/ErkE9Px4RjN3gw5ahvbcXheXV2koZtNeXgXwNVY2xDZdGYFiTMKkC?=
 =?us-ascii?Q?kA=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a053a86-9195-4af2-a2d5-08db17feb8a2
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 13:38:19.1417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w9gm5Gg+SO0o/JngwnwLaYwStZaqLqG1QAgGGKvfsM+jxr8BVVsAgb4X1QpZQvNezWJn/TEMeF4CnBFo4ER6MJQzTEPKRUVzSqEwFSeY0zw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR05MB7319
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a counter per namespace so we know the total offloaded
flows.

Change from v1:
 	* Cleanup proc entries in case of an error

Signed-off-by: Abdelrahman Morsy <abdelrahman.morsy@voleatech.de>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/include/net/netns/flow_table.h b/include/net/netns/flow_table.h
index 1c5fc657e267..235847a9b480 100644
--- a/include/net/netns/flow_table.h
+++ b/include/net/netns/flow_table.h
@@ -10,5 +10,6 @@ struct nf_flow_table_stat {
 
 struct netns_ft {
 	struct nf_flow_table_stat __percpu *stat;
+	atomic64_t count_flowoffload;
 };
 #endif
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 81c26a96c30b..907307a44177 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -282,6 +282,7 @@ unsigned long flow_offload_get_timeout(struct flow_offload *flow)
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
+	struct net *net;
 	int err;
 
 	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
@@ -304,6 +305,9 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 
 	nf_ct_offload_timeout(flow->ct);
 
+	net = read_pnet(&flow_table->net);
+	atomic64_inc(&net->ft.count_flowoffload);
+
 	if (nf_flowtable_hw_offload(flow_table)) {
 		__set_bit(NF_FLOW_HW, &flow->flags);
 		nf_flow_offload_add(flow_table, flow);
@@ -339,6 +343,8 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 static void flow_offload_del(struct nf_flowtable *flow_table,
 			     struct flow_offload *flow)
 {
+	struct net *net = read_pnet(&flow_table->net);
+
 	rhashtable_remove_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
 			       nf_flow_offload_rhash_params);
@@ -346,6 +352,8 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 			       nf_flow_offload_rhash_params);
 	flow_offload_free(flow);
+
+	atomic64_dec(&net->ft.count_flowoffload);
 }
 
 void flow_offload_teardown(struct flow_offload *flow)
@@ -617,6 +625,7 @@ EXPORT_SYMBOL_GPL(nf_flow_table_free);
 static int nf_flow_table_init_net(struct net *net)
 {
 	net->ft.stat = alloc_percpu(struct nf_flow_table_stat);
+	atomic64_set(&net->ft.count_flowoffload, 0);
 	return net->ft.stat ? 0 : -ENOMEM;
 }
 
diff --git a/net/netfilter/nf_flow_table_procfs.c b/net/netfilter/nf_flow_table_procfs.c
index 159b033a43e6..aba4dbfc7a37 100644
--- a/net/netfilter/nf_flow_table_procfs.c
+++ b/net/netfilter/nf_flow_table_procfs.c
@@ -64,14 +64,33 @@ static const struct seq_operations nf_flow_table_cpu_seq_ops = {
 	.show	= nf_flow_table_cpu_seq_show,
 };
 
-int nf_flow_table_init_proc(struct net *net)
+static int nf_flow_table_counter_show(struct seq_file *seq, void *v)
 {
-	struct proc_dir_entry *pde;
+	struct net *net = seq_file_net(seq);
 
-	pde = proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
+	seq_printf(seq, "%lld\n",
+		   atomic64_read(&net->ft.count_flowoffload)
+		);
+	return 0;
+}
+
+int nf_flow_table_init_proc(struct net *net)
+{
+	if (!proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
 			      &nf_flow_table_cpu_seq_ops,
-			      sizeof(struct seq_net_private));
-	return pde ? 0 : -ENOMEM;
+			      sizeof(struct seq_net_private)))
+		goto err;
+
+	if (!proc_create_net_single("nf_flowtable_counter", 0444,
+			net->proc_net, nf_flow_table_counter_show, NULL))
+		goto err_net;
+
+	return 0;
+
+err_net:
+	remove_proc_entry("nf_flowtable", net->proc_net_stat);
+err:
+	return -ENOMEM;
 }
 
 void nf_flow_table_fini_proc(struct net *net)
-- 
2.33.1

