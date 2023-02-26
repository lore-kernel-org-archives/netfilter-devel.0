Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 425DAC64ED6
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Feb 2023 18:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjBZSeW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Feb 2023 13:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBZSeV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2023 13:34:21 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2104.outbound.protection.outlook.com [40.107.20.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AB910A88
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2023 10:34:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTnpCZsDEIu71S9Db8nppti/TRz6lopNDOTNdIE4Bulm49WBp4epfGJKDXijDNATms3kDsXI3H4+NZXzxUevDWYiO28Muo5fpwJAZtw4jm4z4WkiJW91XL2+Qebug8GJmJfvTGxjJQcLuaABsIZLG86MFKPmfIXdsveQJ77hBYuPtRIWyGerh5OVa4ztAXVMuhQ4G9nFAKDbGlPBxFpoddSmEOkBp7uN9bJjudM18xxI2gkI2IG6CArrr3TKPd64fl9NfgJ6+Izc5gg8vOv1HoIuDlK6A/k82ZLBMvsHXqlA9jmx9O9YdH2wmjiKgpzlwnSPPwH3WI1t6YjbOQFEZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RLOTS19tZzW8xQ3shF0eiK7O7vlYpblwrV/rL+nSRSs=;
 b=JISX7vmaluAz+i77QQ0O5pumiDIS/s47GwmlFipAPwS8/l0CmCQ43IxtcSVMP/3LyOph35jODER1E8j+cvzUYIDmouox6FfVEn2mfir7JrTKxZL7Xlu/VLVCR6e5qE5P7UJoXh/QpDg1DsHq8wdWWpT3iQijU+iNYsBMsV3fSrNW4SVGTPU0JBoBMQbseoUkjJizn1gmscrbieGM9vBnnn9GVClFz4KUspjy7fG21fUZ7MJqdMdCuMwEwhOjGB09Kq6m/V32xwXJbVIIatj87cemggy9sCAJX+sNncRfgBGd6mXMUEwy8Yxzu4DqtMid8SxHvCGgQ6Ss5uwkbrQN6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLOTS19tZzW8xQ3shF0eiK7O7vlYpblwrV/rL+nSRSs=;
 b=ChWS2HNWCSqcf5E5nCrqmjO7L9obg9UBnjK+IGHyhjl0lcg1FA2ehq3E+FrJgmn2N4GkWDmWNvCknXkCXl3YmrTyRr9vOsCKngZ6KUURPWj2FrfFjMNjkYYQ9lQ6Y1quPKrrVfBoNCE8qs+aEDvKp2vwKsK4VjpxuYFWpsmiZTg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DB9PR05MB7962.eurprd05.prod.outlook.com (2603:10a6:10:23d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Sun, 26 Feb
 2023 18:34:17 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6%8]) with mapi id 15.20.6134.027; Sun, 26 Feb 2023
 18:34:17 +0000
Date:   Sun, 26 Feb 2023 19:34:12 +0100
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, abdelrahmanhesham94@gmail.com, ja@ssi.bg
Subject: [PATCH v3] netfilter: nf_flow_table: count offloaded flows
Message-ID: <20230226183412.6pvt7town4jsuem7@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR0P281CA0138.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::7) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DB9PR05MB7962:EE_
X-MS-Office365-Filtering-Correlation-Id: c4cab208-51ab-49cd-6b7a-08db18281119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ocG4Zdxh6X+ywaTjRcRCLFBYH0ejkWaHhzu2zzKlPHYDM99uuiN2iGRJvx+TzR1AhaLNZ/h3VcdEWw+FZGnHANkZVIItT5OSLzSiljGmEg0P5ExG57UPIx1acGA11WDrK0+nbt5BPUUoGxzuAQZnbu49wtXr6g5iTNcR3M05IH2ClgZetGhLOd4TyuOKfT2oL3/mJJxyCjRXUHfAp+ilkoDXJBe1zXOkpSXqIRRov2yrJnJgkvx4TK72ccSYTPexn6yJ2fF6+nRb26H1YIbM7IfIRIlVdt+xz89LBaEbU6wBeEjzANUBZxG680JQ0DgaSrvtWWJswpQlQCVOFOBcCNsBCzd/EwWiWWuKDmwDvFSEzcS6riaJ+FxwrxsJx08aVnyxotHdL886hUCY32+hLRPA6oX2DU3nxbIEjHY+bWx4QrWt06GjZwEthJd8iI4Fjrj2HMZP8uNKwr0Bx6NcnNlB63AbgsBBuLgGOLEfQlCqiZcZCO3Fn6+NNF6zwFfYFV3JOXuLwfeM4QshMVoUowKqKXzidY6sY1KDQp7B9k7z7KqKC3y5VUdA9gQ3EM3gkETzJmfHU4/STnzLK8kEhn/iFJMoRlkx0gmDifiuFbaepYIfAxBx/Ds9yE8GJf2nW3kIXuC8tZAM3FH09Of8PA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39840400004)(366004)(396003)(451199018)(8936002)(316002)(9686003)(8676002)(6512007)(26005)(186003)(478600001)(86362001)(6486002)(1076003)(6666004)(6506007)(2906002)(38100700002)(5660300002)(4326008)(6916009)(66556008)(66946007)(66476007)(83380400001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mgx4eyxluCzLEaHJbzyShRBkBPaABawin3rgayOJiIV4w0jvGMu8Eoechg//?=
 =?us-ascii?Q?5/EGsQPAcVzQu17bJNcq4pA3wA2nJFUNxm/GiuknPEuCQR/H4XSW3igM8+XH?=
 =?us-ascii?Q?L5VV87UvDA8Obm6qiaky1Bge0mfZGksrzll7MW6JsuVCtHG+c85kXhOg5mDO?=
 =?us-ascii?Q?0k3s/skbnhEhAgHrKBy2f2qHs/DG7OJrPVxUC3W27VyO5dq7ZBeDSGKQUu9l?=
 =?us-ascii?Q?3suaCsjRWyySqdig0rc/byRTLUMRONpkj2hAVyThFjYkYYIIL0FqNtpTSIM/?=
 =?us-ascii?Q?x73in726OMBauP/vYwK8ZIDRXf8MiLc/uTtV3uTaaLXD6EnW2L/Wa7NPSs+i?=
 =?us-ascii?Q?dTCGvnGXFRiFVowDOb2BddYmhG9/DBaHQhPJup50X8IzrS0KeoGp+SfYiyYQ?=
 =?us-ascii?Q?NnrHhZSZLbs4VrdVOtqqe2PFFglmYb1HoVhPtByICjOnikc05fbr6N/5Hvs5?=
 =?us-ascii?Q?0WeqfCJBlFHIKTS45qgFf3S8rmd+04VwLu6erWunn5MhO7aSxIALegZ4DsMp?=
 =?us-ascii?Q?rxFlqhjbt9+ieQm3/LV7Kuo2gwOYOQFYW8AjTeJTR7cqyuVZnO3XS72CYXDV?=
 =?us-ascii?Q?EP7nVl+cgKbPUCkd7rKMItt+09Q37cBJoMgalqtzyU8dDc61ZvVVPc7QF89o?=
 =?us-ascii?Q?K1PK0j0JFwmVZ6qMchdcR5KuEHkC8mNX6gPJYZHNEaBKW6NuuF2QBu1Zv4Nq?=
 =?us-ascii?Q?hHgM989tE5tYjb2M9Hf3h4VTFElG6uajM81XiPVM/uEjohXqSt1Qb6ToFsAA?=
 =?us-ascii?Q?dKi45M270DMlbLv4s+XvFWdCICgJq2i01lIXGXembudI3iJfBH67E0RnPOKR?=
 =?us-ascii?Q?W1LVnL8y5K9sMHeHc/yvR3DYWEFD75lOYKEBoWRBseuayk/hUFzaUv/rrX+R?=
 =?us-ascii?Q?78FmqxLsSdXNCabDFAtsRGbKsO0xgaJ0CYuHa2hSmy7Tm3D+opeyQONfjjN1?=
 =?us-ascii?Q?u7Yz060YX15XO53uof23DwEkmgimf1Z5xK5G2SMK72+60KV/UCr3U57rB7Y0?=
 =?us-ascii?Q?cWz1+MYSWCFpAeBc98BO7/xlkcZKWR7YwDOPSmqyXTWxi+Qpo2cQq0eauBDP?=
 =?us-ascii?Q?iqEeMulK7pRwAlQvIUZ81DvgMbnjxU7aSkcti90tt2K7K7LsNU8vn54F3ObS?=
 =?us-ascii?Q?azstgtfxWD40f+ealCdIMm8vGaALmViMsO3ELrUUIddUk7558J1CIX5awj+q?=
 =?us-ascii?Q?szeYyLOW2yDil5GGYqml1S9+nDNHi2HSsRiC/fYclTQTte9wM2Wy1TufW2mG?=
 =?us-ascii?Q?upg8lubJ2aqYaCARrUB8Q360zHhXRud5gmzVI7GJpzNkQeYhZAWAKVQZPkos?=
 =?us-ascii?Q?w/MNPJX2VXepM9dMBFFYGA+5eGR0HHlmfKvvGIaS4JXqfTyAVoL5eVVdw5Ou?=
 =?us-ascii?Q?BtIH73cg1DONGfOTiL0BO06K0K/sr9vBbckP6izIaP7azvHiCqX7d4o2Y30f?=
 =?us-ascii?Q?Iv+F9eZyuJzrcmgCwgDKB7s478ivw9eBRJnDcAr5yuorHr/9PPX9gYkU/iHg?=
 =?us-ascii?Q?QDsMvB2HAfCN32I7L7GaVVTigKNg1alfKzw0Y6Vr2CqK127KDSX0OXZMbOyy?=
 =?us-ascii?Q?zdu8HxxGk1PCNF8JFxy7C9FNjss8C17TK8hZm1slcuFzIVIyeTM+wGGOhzfe?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: c4cab208-51ab-49cd-6b7a-08db18281119
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 18:34:16.9099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8J2H9ycfK096eT0B9ebL/8UgHVl2jjTSw5oJcavcpQb6X2yDDh1gVw4mDYsiJvY57JpBdMOyf/2hmXfGPEFKjr5rRydcYo87rylUy9hw6sk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB7962
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a counter per namespace so we know the total offloaded
flows.

Change from v2:
	* Add remove proc entry on nf_flow_table_fini_proc
	* Syntax fixes

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
index 81c26a96c30b..267f5bd192a2 100644
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
@@ -616,6 +624,7 @@ EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
 static int nf_flow_table_init_net(struct net *net)
 {
+	atomic64_set(&net->ft.count_flowoffload, 0);
 	net->ft.stat = alloc_percpu(struct nf_flow_table_stat);
 	return net->ft.stat ? 0 : -ENOMEM;
 }
diff --git a/net/netfilter/nf_flow_table_procfs.c b/net/netfilter/nf_flow_table_procfs.c
index 159b033a43e6..124ddf9ec6c7 100644
--- a/net/netfilter/nf_flow_table_procfs.c
+++ b/net/netfilter/nf_flow_table_procfs.c
@@ -64,17 +64,36 @@ static const struct seq_operations nf_flow_table_cpu_seq_ops = {
 	.show	= nf_flow_table_cpu_seq_show,
 };
 
+static int nf_flow_table_counter_show(struct seq_file *seq, void *v)
+{
+	struct net *net = seq_file_net(seq);
+
+	seq_printf(seq, "%lld\n",
+		   atomic64_read(&net->ft.count_flowoffload)
+		);
+	return 0;
+}
+
 int nf_flow_table_init_proc(struct net *net)
 {
-	struct proc_dir_entry *pde;
+	if (!proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
+			     &nf_flow_table_cpu_seq_ops, sizeof(struct seq_net_private)))
+		goto err;
+
+	if (!proc_create_net_single("nf_flowtable_counter", 0444,
+				    net->proc_net, nf_flow_table_counter_show, NULL))
+		goto err_net;
 
-	pde = proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
-			      &nf_flow_table_cpu_seq_ops,
-			      sizeof(struct seq_net_private));
-	return pde ? 0 : -ENOMEM;
+	return 0;
+
+err_net:
+	remove_proc_entry("nf_flowtable", net->proc_net_stat);
+err:
+	return -ENOMEM;
 }
 
 void nf_flow_table_fini_proc(struct net *net)
 {
 	remove_proc_entry("nf_flowtable", net->proc_net_stat);
+	remove_proc_entry("nf_flowtable_counter", net->proc_net);
 }
-- 
2.33.1

