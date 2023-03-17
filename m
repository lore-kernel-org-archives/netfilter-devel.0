Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A3FC6FD1D
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Mar 2023 16:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCQQdQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Mar 2023 12:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjCQQdP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2023 12:33:15 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2097.outbound.protection.outlook.com [40.107.104.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA173FBBE
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2023 09:33:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uec7S1tpppT/Uo7ibCeZzLmIszXoyiNszpySmVzrOVBsSAYbxuAVj6f4SteFOL79RoEBfydcnR5mcK1z/eKNrPxckjImq6i+geu5/CXVSLJRQZ11GGYEMpKDnoqSngZFXkssP3YO6Mq/cVGsjN9ZsGJU4snXqdv4GxXv1es4aCNRhJmDRkHYCvCQN5FQdYa5omDRDLNP6g4ZJJee6F7xe5LiNIoozJnFMevQ+lwc3eXP+K2/ApiWWjrvF81AseII+TpZenDXl0nBcL99Cq57Pwv2pIJV37sxYrtS4LTLAa0WHWuf4t4+6kJTQuTg26dx/LFbdYhdAqrlRrVyMf40Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+R8f36Eu1WrVFXyMbowuqvFDAOhMChIsfoQIMwFgN8U=;
 b=m4nTatZlx7DuvLKgAS3ZbQmuwzd3KzLyAEjg0f488nJ1xf9To/aizWiKSpacUXHVaqjuFjdY6fanqP230hCvjmKTeQamUo9i4Ppu+coqcKMf2o8f/ug+wikU3UWr1EvlQovCXEFi323BDqKyqlVN0zaH9cqRqFmEYNwKppc3s2iMDilPANhCfnbaeIxC6ZE1LSpFJCajGqWbR24k+96GMHj+6teF0sAKmCFeV32XjVWTPZ0htajeH7HFopx9nF6ZsAyJRrpRUH+0pQKQoscbfj11X6IZnvTcY89uwGEwRrvLkRgBZUSy1qiGdCtUM3QqC0Cr9HV448wsIXRbb5twew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+R8f36Eu1WrVFXyMbowuqvFDAOhMChIsfoQIMwFgN8U=;
 b=NBibJkrIxw0wXTX00H4KY+/lOtSnzc/zS+Gf13aZjIgGbfZ1AUWadHSg0VpDlwpeA55diVw7S7qFoj4GTZvxK11bvYcCgLeiN+9NmNtLR+52PD7ACt/5JONzlh5c+idj1XIAQvwmxoVJbDxdIJ0l0cdi9QIOz4v0maY/dFXBzSE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by AS2PR05MB10828.eurprd05.prod.outlook.com (2603:10a6:20b:647::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 16:33:09 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%9]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:33:09 +0000
Date:   Fri, 17 Mar 2023 17:33:00 +0100
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, abdelrahmanhesham94@gmail.com, ja@ssi.bg
Subject: [PATCH v5] netfilter: nf_flow_table: count offloaded flows
Message-ID: <20230317163300.gary4wtvrbyyhyow@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR2P281CA0073.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::15) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|AS2PR05MB10828:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d630d62-9d5e-41d1-ebb2-08db27054ae8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jJsIpos//NqTycfOZVrLOkXMd+yrF8cSNFopbKCabLaHaA5P5wgh2nj0Er2/kfPocDQDlRlc+H843g2lfrpOEi57PH+QGxfO4Asa8j/O5TQcy2Dbclswx87xD8MqQzxproTKXmv0m2LVM6lSTVMtIFCwu5GpGYtS0SZrFuK3USGEmiG7DDIamUdRr2BP0Mmn2rCwwQMdmIxskNdcqgvz+qyi6lHlU3qAM6CIZWG+c76YJNBXqyHl7l8eUwE3IqFIHGEavF540RKPMCM34XQdlpAAVkAUa6nkSIUPaKHZt3BgAKWP5r6ATaXnhqbbtHSC9hSXTE3CA8ythYZlu2KZTtWR8kG8CdoId8GxNB7zcxUpScu3EolMUJUcPBeR8jmVfElIkKD5UXO3gQo74lErsZ9MD4pnrseISNMm94Wdy6PN76JMszRNbbZQ/8Te4W2uBHXXp3pNRMev9Zqapk7060G2WSwaSfsgANE3C4ZCM5IiEPfbxrJRV3ZDjzB1LD6OAJo9eVKL1IvErA49IPWDlOW0vmCYNp27ETx9glZBlqFQW5ad+zQGZBI/lcJniZGkcW7iEgQiPcSTmz/Rh99qXFVx6m96XmHZk1jHX0jc+Nj5+I1CEORRSykcsTaXVgDPUzGZ1LSNnBWtZTAknL/dPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(366004)(39840400004)(346002)(451199018)(6486002)(86362001)(186003)(9686003)(8936002)(66946007)(4326008)(2906002)(8676002)(6916009)(66556008)(41300700001)(26005)(5660300002)(6666004)(66476007)(6512007)(1076003)(6506007)(316002)(38100700002)(478600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zkh0D57WaHwNStynb3WFK3LSK2fMHjJVWKD/0Svb9XbYb43cuW5utQgd3DAa?=
 =?us-ascii?Q?UHyeIjm9mWOGRxchPeB4+j+8R+t8fk1aDco4nE5oPKuOphcnWf5aH6W9GiD6?=
 =?us-ascii?Q?2mCtmnP7/Z273DuIpoNIUx4W3luVV6gCn+7p/vAFPWSgB8VURo9kzgnOaI/u?=
 =?us-ascii?Q?Kw8GMZ2YptlkeKdapOkiJQto82+RJtP+niVwH6gH+gPtEtfZO5ejqBwdf+2D?=
 =?us-ascii?Q?bpWBPidfoEpF//iVsBZ/+U/oQG0bVxfP+IgFmKehHWnAgj8xLYIH8vz9v/RD?=
 =?us-ascii?Q?EUKyez085lFgpK8cZ7Ic5t5bsGjxTYI6B9wa36VyXLfEJ4abfM0Mo6X5gMkE?=
 =?us-ascii?Q?SdgNWtDiPH8nrob2b7RBfNpI5fxpO9MRlkSY4e1ep6AQ97qbu10d+FfFFcJ7?=
 =?us-ascii?Q?rxu8JpdfCdXXkOFGnFtSUvNWTNtALZr0rGNr4bcPBeb2sFGpCsE0/KWJvehU?=
 =?us-ascii?Q?GPjmMzcb3UpPCzfM2oZsdB3re6vMnhqbEJOTouKo1sHo3dKwyeD+o/H3rFjB?=
 =?us-ascii?Q?1uYQ3Bl3xWf3KIwh/pSxpu44w+fI8mw1LeDdenE7mSe9iHtbvyeUnWkDnz/N?=
 =?us-ascii?Q?N08ElJ1i+vrlc0kaD3aThLbwxNHaHog5i5U133x9WodVpzi7wX6dT+zzikJY?=
 =?us-ascii?Q?TBLYrtg4qu00+6tVHOSvHSwOkAjRA67qcqJ9thu4BXcmBObI7dtmBlo1dVqg?=
 =?us-ascii?Q?Mvo7KLiEFYLrJqZidH+FUFOfWfYEIRpdLibiWESk/hSOPjGoWcOnm0l7Lx9k?=
 =?us-ascii?Q?51V4b5enQbn8So3aBjgY8iB3dicq54ZsDUHaA9Cb4L1afvD26X4ZP2crVrhB?=
 =?us-ascii?Q?ZwewdtMPsqOvc4mymEed3eyWUXgmBsdgNU83tRvDdkm9gwrx8S3vyY3dVzOj?=
 =?us-ascii?Q?tCZv9Efz3WDXhHuUcdjhgQz2hP63KlnKPJDhXilkZijDdL3ouAStQ/GDVpYk?=
 =?us-ascii?Q?f9WeEhW9V8g7HpEAI6XUSwRAgf7iICYt3BmGZmRSo5vV7bwvXe3v8z9RpFXG?=
 =?us-ascii?Q?pYvXq/okxOg3qNMUekG3k2ia2GmLM5GvCYW+YAIr9Z3BIPmqBdXSD8veJDCW?=
 =?us-ascii?Q?VwvWlwgf1FOUfDJdA7cEqJSPLoQV5ca4cV29EvtegI6vaPTj2pPuiSB/f1fl?=
 =?us-ascii?Q?HJU3tfx4Qb8R5VJf8Fh/mjP9XkSMRhwXC0mtBgj4OjMdiJw4K1Acqblumufz?=
 =?us-ascii?Q?kqu15YWICtLcHaOWMLixBXDfCxZqwYK7pyAOi5dRx6ZNB/loMV+gKSkvz2pn?=
 =?us-ascii?Q?j/hpxlkdMCJUXLc4r3hRLLKL6bsrmgYN/H96yd41q7gS03/fQvPCYCDe3n1e?=
 =?us-ascii?Q?Z3/ZQYH+GQWjNZfMQUwc5+RIUnKiiEJ25KJ8/RIBVVFQWUYTCE6w6x60IU97?=
 =?us-ascii?Q?8juFLajQkZkM0H07Qh3KZkORERm9/foyNEjgyZ+JBkFX2xNzD6YLSHWYFh2X?=
 =?us-ascii?Q?NzLT5EeCBY5HrZ+d+BWVLfU2l3X/mVEIeX4/SB2CwPQ9wXJNWWX1VOyyYRdZ?=
 =?us-ascii?Q?fhldkurl+FuAkk6V9ZvZkN1kwJaNSMMEdKqwaqRScA5ZRaM6ILZ7Le6DmGNW?=
 =?us-ascii?Q?/BfZU4d6zeyMAc8T7bXytltp5/hTarY2kQDcIuAGqdHfiysqwuSyQ++2itqF?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d630d62-9d5e-41d1-ebb2-08db27054ae8
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:33:08.9562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RPPknfCAJDEEyze+CltS0TDqzqfwmaN0yZ3juer2hQTd3wpZBpiWCQRwv3AhmfmajTZMy6avYQpX1u1/O+i5bW6uJx+TrWKM2fZ2UOxIUsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR05MB10828
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a counter per namespace so we know the total offloaded
flows.

Change from v4:
	* use per cpu counters instead of an atomic variable

Change from v3:
	* seq_file_net has to be seq_file_single_net

Change from v2:
	* Add remove proc entry on nf_flow_table_fini_proc
	* Syntax fixes

Change from v1:
	* Cleanup proc entries in case of an error

Signed-off-by: Abdelrahman Morsy <abdelrahman.morsy@voleatech.de>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/include/net/netns/flow_table.h b/include/net/netns/flow_table.h
index 1c5fc657e267..1496a6af6ac4 100644
--- a/include/net/netns/flow_table.h
+++ b/include/net/netns/flow_table.h
@@ -6,6 +6,8 @@ struct nf_flow_table_stat {
 	unsigned int count_wq_add;
 	unsigned int count_wq_del;
 	unsigned int count_wq_stats;
+	unsigned int count_flowoffload_add;
+	unsigned int count_flowoffload_del;
 };
 
 struct netns_ft {
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 81c26a96c30b..d6bc8f0ff51d 100644
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
+	NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_flowoffload_add);
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
+	NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_flowoffload_del);
 }
 
 void flow_offload_teardown(struct flow_offload *flow)
diff --git a/net/netfilter/nf_flow_table_procfs.c b/net/netfilter/nf_flow_table_procfs.c
index 159b033a43e6..c4d15bd1a0f0 100644
--- a/net/netfilter/nf_flow_table_procfs.c
+++ b/net/netfilter/nf_flow_table_procfs.c
@@ -64,17 +64,49 @@ static const struct seq_operations nf_flow_table_cpu_seq_ops = {
 	.show	= nf_flow_table_cpu_seq_show,
 };
 
+static int nf_flow_table_counter_show(struct seq_file *seq, void *v)
+{
+	struct net *net = seq_file_single_net(seq);
+	struct nf_flow_table_stat *st;
+	unsigned int counter_add = 0;
+	unsigned int counter_del = 0;
+	int cpu;
+
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
+		if (!cpu_possible(cpu))
+			continue;
+
+		st = per_cpu_ptr(net->ft.stat, cpu);
+		counter_add += st->count_flowoffload_add;
+		counter_del += st->count_flowoffload_del;
+	}
+
+	seq_printf(seq, "%d\n",
+		   (counter_add - counter_del)
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
 
-	pde = proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
-			      &nf_flow_table_cpu_seq_ops,
-			      sizeof(struct seq_net_private));
-	return pde ? 0 : -ENOMEM;
+	if (!proc_create_net_single("nf_flowtable_counter", 0444,
+				    net->proc_net, nf_flow_table_counter_show, NULL))
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
 {
 	remove_proc_entry("nf_flowtable", net->proc_net_stat);
+	remove_proc_entry("nf_flowtable_counter", net->proc_net);
 }
-- 
2.33.1

