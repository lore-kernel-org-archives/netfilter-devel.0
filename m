Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C62C64ED6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Feb 2023 10:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjB1KOo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Feb 2023 05:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjB1KOa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2023 05:14:30 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2128.outbound.protection.outlook.com [40.107.241.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BEC2D17C
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2023 02:14:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNIYiYFiBd+rJ3rjh+CmLPZmY/qQ0wSSNgjpL8xOHyfOWHlmvSKiyDZGYt+i3TueI3Wt0f4hKb2eJ/g2SKGlyZ+YiAL6jeK3nVzAQ3a8Up2BRKEJDqtDs9ywOo5jZIobGhwsCAhArTCBn10CGSuMzoOVTOTKoOm+ePQZxXj6Motq9ofLl/UuSLzY5N38S0wAYSpRZseZz5Sqs246KFf8FMoDoDg6KJx2GHQZthZciBvMBUdxWKNZBefs84Fmxg87Qzediyfckfbr9K/LkGXHOTCqOp/BgLWEvFlvO2BJfkGtGANCU79cXndlq0s2kUDwknaQRZyEnatuFP4JjALQDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pnh/9WkoBLLaFaal14WcDAYDUkSWKbeZqiZWoScNoCo=;
 b=KYZwT/aum2A8Ef3jsKSou+gD9nQSYaLr7eubm19LjbA1Tanoar4EYMRLF6d93saOQdR9w9iuzLbFqRj9XQmrsWLkORPbUfjDnq0JVamaLaoJgiiBxqlUXCZSSpl4gttJ9P3TpaHUZ7c40R/Kq2y8tCYTbybFvSQhjksNrRCeUJBhbEvWRVDYH4Ot6jmtApDt07sEmlHseBrdYAuYETdFxAqnyfo65F/Fxb4l6ksNwphoWN2QVesBZjfQ2b/Q+4h5VqX3qeBg0Y2zEwDJI9efLn/Rssec5nqLpEv3PWhYCF8vsHp2elpLLTst4FZVKWsXv+dLueLEUbn9ZVWCM26wSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pnh/9WkoBLLaFaal14WcDAYDUkSWKbeZqiZWoScNoCo=;
 b=J+HTCwmYQ/ewnniB/0J5Xcphs6xZ7dtqzadB6qUpeybhemw/W1zckL7F86gbjQzGeYqok+qs5MS48K38zNNgxdcy8HfnjnJOQZJMLjcfeLWB8iD/tUf0s87Qsvh1Lt3NVM1sXne7sIjK3rPBa0GFziNbSd5tV3AddCDNJe7TBKo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by AM0PR05MB6643.eurprd05.prod.outlook.com (2603:10a6:20b:156::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 10:14:17 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6%8]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 10:14:17 +0000
Date:   Tue, 28 Feb 2023 11:14:13 +0100
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, abdelrahmanhesham94@gmail.com, ja@ssi.bg
Subject: [PATCH v4] netfilter: nf_flow_table: count offloaded flows
Message-ID: <20230228101413.tcmse45valxojb2u@SvensMacbookPro.hq.voleatech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR2P281CA0146.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::7) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|AM0PR05MB6643:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fef9916-9425-4af3-dc14-08db19748c9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2tse3QvOtjRbw3O2cGQNulPRZ2Ll04Z414nx24nN0DVR/X6MOTDQswN0kw25c8cfgajpU365omVzKsFoucDc/aVkkEfP5qwqwVAKCK2CxP+aX6l9kqYrf9d5flU6KB1HbEBnkeecSRyJsCM2eP/VI+97D44MDpWAz6fRegGTRwVW8jXXxr6+t9LBeRpbT+nFtYIEoJQ34RmrmQMlsgsfpjGFdMzY1de+JeKvmZ9uWptHCEDen4/CEh5awIlUbn1mvCmMG+hS7Grf194Zqeihn0RacsEmKhI3/fk957HxHxQb15TSxQImVWbWMKl+RD7YysKlQPnRJRMPCOu/8X/ii8FrCI+BYNFjoNaRrxZ1UVQ/3Ejp1/SYlcs+Vas+ECPfwCwWBX7NYVNgRY2wyA0AH7D8oC1IBsGPsUsz91fMdEHDQKKIMXhNJSG1MxpO2S/49MCf9vBHSEuMPDTDRHw6Pt/eZ3gDHdmEw7uVLDo2CuDLra/liN2/YEZylsRrK3n6MZtmVMJaDc4C8d59qTIFO/YvOI3ghx80IiLRtL9S78ePFnarVr9GpzlxeooSH/XwwUVax68ytIg5CfPPFIbvHbfeAv553noxQObqcc9r/bRLZEMj5BtqwJvLKcChL0jm5plnafRVRQ6DIRt7cDhoNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(396003)(136003)(376002)(346002)(451199018)(38100700002)(86362001)(2906002)(66946007)(41300700001)(5660300002)(4326008)(8676002)(66476007)(66556008)(8936002)(6916009)(6506007)(1076003)(9686003)(6512007)(186003)(26005)(83380400001)(478600001)(316002)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?olcDjY28mQZnYlqYxFq+ipGAVbaheQ4gwjlpjy6LoR16QfqPGQ7HdYiT1eyS?=
 =?us-ascii?Q?jZODyocPIODKfpqo4BhUG8aB8siU5YV1u1upC69WBt/tKQ+zO9eT5GzhtkGu?=
 =?us-ascii?Q?Ppt7yu0N489h71OTYg7LHKj/PBkTF4YoU5iILdoZL2XG0YpzrqSmsJY+W4Ew?=
 =?us-ascii?Q?Xxef1SU46/HnIt7dSugGlxoEghFb+OJKmOblnY7SH3lcJNwXIU45BkkiNwDi?=
 =?us-ascii?Q?3h/hRmwzJL09McWKofmUra6JyFWOhmEnb315Y9UFezrL0dHw8IX57Uu38Alc?=
 =?us-ascii?Q?22hJCbBtp1J8re6vg6TOBSrou0dfL6RqYZQ7vyKtfHMKYkPwaSgFsgqnfAbX?=
 =?us-ascii?Q?UJTa/v6kWA/U91U7XkVLf1LVnpF1YMfGyNsX5alS+4JwBhLNUQbB0pzz4zjI?=
 =?us-ascii?Q?E8l4RYbU3458cxu57nbWDnmcDkSY9CmYE/kdyfY2w/7rOQkffD6aRrAGRXHL?=
 =?us-ascii?Q?SqCyv9BeK0Ozwhh4T6hoQTKg7oMFtFhM0DDQWfbErEs1yym+xTRYoQfuS29w?=
 =?us-ascii?Q?7Zy2nn7Nx9mP/w3eFWHEkRwnA5tSQU+CLpAOZd43jl8aOE/kwsJ5TAr8wb1h?=
 =?us-ascii?Q?r1sk0kvbsWUPZBZhclFZFKe/Fd7ckAOTz09W1ZtNtgXztsre6uxZtrz07L4J?=
 =?us-ascii?Q?ra+/NkEHdRa2MGxuFU1/YLGSJgnQMinioEhkj/gTB59Mhkg2QNmmlyZib02d?=
 =?us-ascii?Q?nwqyVdRAUo5MdsO8XiUvrw0Kvkb7GxReXKgwxou3ogW7DZ8HKKP+cwvhWqlU?=
 =?us-ascii?Q?gbKsZWZRjsATcfVekQITvLMzadJajCcia0sAFyjt63inRbA2m1GoK86P4cA1?=
 =?us-ascii?Q?fE8Zq4ybHaj3MYl36Dbp2tXcIoq1AfeiW74rZhSRZtVAsbxp2J067lmHbSbx?=
 =?us-ascii?Q?IYcnK6XwTnubyPizoV3DN5t8apeI1iQUQ5FrYEqtrLoeh+8Mukwl0ZgBoQwE?=
 =?us-ascii?Q?2uBSSbyDlljnIduKluIM+m5pPRpYuthTJck0Ry4fz4vZsJzmFf/zy3BcT1l7?=
 =?us-ascii?Q?iTVF0Md5QiPxE7nnsJEbQuG42+AX22UqSR6SftWcrIz2CnBLSzQUU5UcrU2D?=
 =?us-ascii?Q?PuTdMKcnB+K3Ige66vlDiPqqz4LYdX8p+sBWo7SbB7fXujkv067wGn6KC0h9?=
 =?us-ascii?Q?5vE0vxB6TG7Wv+tuBxolZVbW5fBbrwoIQz1Dw52Znqr47pDLBdtAqUWJnKIU?=
 =?us-ascii?Q?PwmXFiFXtrOoErK4OP9s+0tqxyqxrHi8BQ+IzrZvvCTJfQR2NP+oPTobV8VX?=
 =?us-ascii?Q?eKwp2d7eb3V4RuHia+FcWMNPLqq/TNDpLm4luOeBYkaecHr9Od+M+IlTAQmc?=
 =?us-ascii?Q?Yp3rsBHwTh3BM4r/W1GZ/rf+6SpZq/PpcI9Zjxo+cyQPxaynfqSLpOwctnAY?=
 =?us-ascii?Q?ygPxyI9LoLLGCKhB3FQz41H10IDBatkuwm89nyVE+3gr8VfVBZRmD+mgDvQv?=
 =?us-ascii?Q?SCLcOHBLXi6GD9Q5TYxsc830mugFvekL5fsx+y7scSd325HSwGLI+VkRwlqf?=
 =?us-ascii?Q?WLUJ4IW0fI1tHplbAG2yICj5kODLYpzNf646HoIKWZ20yWH9jVnY/m21OuCb?=
 =?us-ascii?Q?7fPlu10uXrnRk7WEBPjSPjzBme/tbWIB/jQ4r+c/M/M9dgfVIex67ZqyfUEN?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fef9916-9425-4af3-dc14-08db19748c9a
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 10:14:17.4241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: exH2T00yb3gZHqJNed5X26hdkmZFjBs7W86F7dTCMLPYF+QcjLCdnCwtO6YW+cFaP7hZmzeI62trfbTpS+669Qo5pPD1Zxa8/S3eDa5UYns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6643
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a counter per namespace so we know the total offloaded
flows.

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
index 159b033a43e6..45b054b435ec 100644
--- a/net/netfilter/nf_flow_table_procfs.c
+++ b/net/netfilter/nf_flow_table_procfs.c
@@ -64,17 +64,36 @@ static const struct seq_operations nf_flow_table_cpu_seq_ops = {
 	.show	= nf_flow_table_cpu_seq_show,
 };
 
+static int nf_flow_table_counter_show(struct seq_file *seq, void *v)
+{
+	struct net *net = seq_file_single_net(seq);
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

