Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42937C6FA8E
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Feb 2023 09:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjBZJk7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Feb 2023 04:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBZJk6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2023 04:40:58 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2131.outbound.protection.outlook.com [40.107.21.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D44812F23
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2023 01:40:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVXfss5vvRNt2IAj0r1vLV0zol0Uhb1kPGQV0ZuJjBRGAb/62DTnQDvmD+CEjyvRZd7fkRI0W2FcNamhPgDVajohDRr8QofOat8/mE7oOyEkpD2YdAqO15m7eYBrdmXCNWLvREpPf+CzL9YhTBf90l24XbF6ipJVJfnSM4kR1JKKy1qpPVDzcKyGAMKbRd67bmwWK/wpA/zvgO85RMEJisi/I3rzhxY4cHbR5atN1hufJxgld6m5K5nenbCu8xTkglV6S7kbvDraS7yamF+44THNU0jIviotJBLzB7SSDG4xFtZ/tsgmJgKvf32wxxQOLmSmIB2D+Tex/UUtdcuXig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAcGyqO+tXIHomvHrjufBB5d9haTY/LlWYKFzyxqMwo=;
 b=ZisoZhwURcAFnrARb9hggyBB/RR/mLzC63HFiPCXhxoYeF3trCa3N8a9CpnPNbdXIC0PsXfvCrTEoBK2M/n/pIdGmxZ2v7PVHvnt/hv+yW/P3gEU6U1iEeII8oc2zLnxOAt76pguVKOUTDit5nluRk5jOq4gjbcGOXtmx1HQPXj+4wO+n4vJ7owoQ9pX6IlRzn78d2mSVydT3XwXioXA49WlR7LhTBCVn0fZ+oyZ4U403WPUSC7mwqqgV6mRX+n33ZK8ZZrtz28JDxwyM5edr1K5F+kI7sA/o/ImhXNcFevNjJt9bPsbx4tlSv8CZabNv3W5BPFcT90kJSh7fnROhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAcGyqO+tXIHomvHrjufBB5d9haTY/LlWYKFzyxqMwo=;
 b=V1RXt+os6gZIHFs3xqsKA01oPukTZa61blmebBj6t+ptJOw+uO5+EGiI8YJGI7UU3GfBTU8LwSIGyg4sb8Me5OK+LJKepLpMTRwqFxQH4DHdWuMOLTAwFMom37G9hUE34RyYR6BPz0EGhUxmtTmK4da5log9iwhLfA3ZLxTurc0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by PAXPR05MB8954.eurprd05.prod.outlook.com (2603:10a6:102:2b8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Sun, 26 Feb
 2023 09:40:52 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6%8]) with mapi id 15.20.6134.027; Sun, 26 Feb 2023
 09:40:52 +0000
Date:   Sun, 26 Feb 2023 10:40:48 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        abdelrahmanhesham94@gmail.com
Subject: Re: [PATCH] netfilter: nf_flow_table: count offloaded flows
Message-ID: <20230226094048.zpxmsb4ljrjlfdwo@Svens-MacBookPro.local>
References: <20230226064436.hr4obihsi5o4hiqk@Svens-MacBookPro.local>
 <afee3af4-c85d-4daf-1f91-2017eaeaae5@ssi.bg>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afee3af4-c85d-4daf-1f91-2017eaeaae5@ssi.bg>
X-ClientProxiedBy: FR2P281CA0014.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::24) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|PAXPR05MB8954:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bf9ce7c-cf3f-469f-62ab-08db17dd8cc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UAnaemPvk0oUaHiIpMo6f2yLjiySsEp6ruLA1icxQ14hkRVR4Fway8hqJOQfNMr909d23m3UrlD/q5LneJII6rR/7cSsa3DRRiemaD79q8XngIRjNPrj4Ys/oYDhBorEZwmVoK3/R3eWO/QSuXFjKlQ8oR1m5elRvO6xBT8tEYb5WLSVwgR47Al5oZV71E8BML5evSFceOfyrIQUMnIl+VuifnJFsoraXY1r1Yiuk8S1s52yyBf6bqHf2gql6MXpe0jDvlxxKkIPgaKjB7toqLBviQnA7vxJKJojsPv9Q0Z/TQnJg6qtGu7AALa/Iu1ocS06zYix+hr8at3Onf/QdbaqtX7rc4pgn02eu88DydnJT3+pJMM/IzTZLi69HE3CG9sQaNxR60d8l0bXs8/YGnYNvL7X34R5rpQjopfGVHpz7bs6pDIpvSSTLs85svPdHEP8flZ8PuVudr185oR+2mNWnvj76Fq1+YV9zZnSXd5wU+jhEOuSTxh+keYmmkVNNSt9cGhKYzpKi7QZrRfBng3SDkFACK96wQqQ6X2GuNuNXJZWA24F736RSJ3cC5J9lU5E47j+jRah7DMyScTaK1VuRZVFa71mbx73eF8fSe7pypPeILDHH+IqHW2aQ8V+nCpVv6iF1XQTst2ot30y+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39830400003)(136003)(366004)(396003)(376002)(451199018)(6486002)(316002)(83380400001)(86362001)(9686003)(2906002)(44832011)(5660300002)(66556008)(66946007)(66476007)(8936002)(6916009)(41300700001)(8676002)(6512007)(1076003)(6506007)(478600001)(6666004)(186003)(26005)(4326008)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zTbI/ZBKkv81NrCRUCDQLeMv/shRq2CmOHKyR3tEc7YEeX+ZlG0UfJPVQMnM?=
 =?us-ascii?Q?rB+jNW+TDwYbRXOM4Y9yfBXZJGofe04pAuAZhPTZr5uSGG+TcF/C68gQgFYl?=
 =?us-ascii?Q?oxFSF3Ufdpr8B4uFppKV0OQTKUe51kP2wChLOGZu4vKrYj6MMybTQfD/Gz2W?=
 =?us-ascii?Q?6SsOV/kgzCkW0ZxEO/sF3+nXZ+oNBUoqjPVczs5+t1UEEmPWGVNNb9uZz6MG?=
 =?us-ascii?Q?dduSrDVNgDQoT6v421rEXyIOM4hGnogxQ7zeLNlSxZKBAdP8aNIhXwpvS4Uk?=
 =?us-ascii?Q?Ppe4lB3kgn9w2LqH00m0nN3sY+/aLc9rXduObHticeX9fPU1qmXvtC+rO07a?=
 =?us-ascii?Q?a4uk787DDE9TbLWZDunbl6O4GIGBgLXUVto6UTyMy1S3teUVLrR3J4xN7j+i?=
 =?us-ascii?Q?kIKKleVfLrvwZsr3e3q1Dq4q5NX0eNbjOUv5LvPtJ2hhVkXdKow9MDMejCdf?=
 =?us-ascii?Q?boS6pb25kzEkJ3skhIUByU48GwFByzRaUmwvBfxICZBhy3XfsTpzVtrkgxRk?=
 =?us-ascii?Q?ANawdtaiiqhBPr6jEVuW+pbcyYXL5R2+lT2tlwh9Buc6elMI5W61dgLgujCd?=
 =?us-ascii?Q?GVgBg0F8UQSgYcnm49N9o7BrnP+xqrUqrCgtV3kP3gQAE4DkPiiD2LzhNI8B?=
 =?us-ascii?Q?K2pBPActPvAUOmMM+MNmUKIGfk4ms2gsnJ8IvEKW+ku9AAS8Rw9JWkPyjeRL?=
 =?us-ascii?Q?UBLx1NZzz71ScIG1XH24PdY2FV+x0nXNW48kvvPyjhfKpxKXtKtqjDT6W5Hc?=
 =?us-ascii?Q?BKjSEoRczHxnQWmyyRUQvX5qWdguwAIROjoMp/0iTXrQIe1/E0CIN6q/0OHT?=
 =?us-ascii?Q?LYKSIkSf9gWFiGPpYN6zNepIbJDBLBQbiECd4rNtBTeHdIEXquB7uEug3PxJ?=
 =?us-ascii?Q?PflEka9BV8HGkAzRsdvrbwyzuG8A8aarG6jR8A8HeZNd0CsE5V6nUKEXRpla?=
 =?us-ascii?Q?aOkA0+xnjyA/+xCwXyYYK1/C951QVfWfcTcGYtG6SkQt7J0Ag8tIZD1cw4+Q?=
 =?us-ascii?Q?sVja4CPHNqto5g+xBbQ/lFtH/EC/eu7LTw1ljvJc2kkeO/e/xardV2Q9oxB4?=
 =?us-ascii?Q?9/Gf7JsuZ8XApb7ktQDYrO41AD5PieugZZjzypZxYk8IHPKyic9OZxqsdveB?=
 =?us-ascii?Q?WUfHpXgDluaABf57Bsr8rHEg+Do1qZ7eOMdiSofM+X/tYDm6gnm0lNITkkMk?=
 =?us-ascii?Q?WxQ+iO+8kpUXyn6A/7pOmFqdydXBO2cnE/otuLaI2J0Ag/S7ukl3Rmx/Bv5y?=
 =?us-ascii?Q?hYt1YCM4kv0fiyRWWDFDr28s8idxnFbI/bXZlxh285mc0nSRNplPnbv2aDSr?=
 =?us-ascii?Q?mq13+JGHmogt7rKwaNF7hQDxyWErcV+PXCYeBCxKHzQYVrRrTVjnzrT3Kfg8?=
 =?us-ascii?Q?1lwPFm6EowHKzlAT54FmriNtizvD/zbx92iofR8H0vVvsYH1sVAqVVrBm60v?=
 =?us-ascii?Q?U9LmB3JwkQo6vchs2Khn0wpqq4EFMtLV2lwAytz6d+eUWYPU0uAMir7y1CJL?=
 =?us-ascii?Q?Zqzr4TQTCavCa1eT5k7WpRXgTb3h1LtDSZ5HPSvSKo+3MUPCKsNiCNSC3/i5?=
 =?us-ascii?Q?eo0567dqHOowN2d19j8JAt29sigohKINJ9U4Ta0+Vc63WVJOTlMr2pQ+SLre?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf9ce7c-cf3f-469f-62ab-08db17dd8cc4
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 09:40:52.1667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OjY6uOUGG3kSrGAxIJPpZ+PHOlK5NRCovUyt/D8ArCRX/jJMja6fNQvipELLTkhnLHlzOACF7rijIQrGEkkdwS0DrvqwtM4V6g2bGYnCcEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB8954
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Feb 26, 2023 at 10:53:58AM +0200, Julian Anastasov wrote:
> 
> 	Hello,

Hello,

thank you for your feedback.

> 
> On Sun, 26 Feb 2023, Sven Auhagen wrote:
> 
> > Add a counter per namespace so we know the total offloaded
> > flows.
> > 
> > Signed-off-by: Abdelrahman Morsy <abdelrahman.morsy@voleatech.de>
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > 
> > diff --git a/include/net/netns/flow_table.h b/include/net/netns/flow_table.h
> > index 1c5fc657e267..235847a9b480 100644
> > --- a/include/net/netns/flow_table.h
> > +++ b/include/net/netns/flow_table.h
> > @@ -10,5 +10,6 @@ struct nf_flow_table_stat {
> >  
> >  struct netns_ft {
> >  	struct nf_flow_table_stat __percpu *stat;
> > +	atomic64_t count_flowoffload;
> >  };
> >  #endif
> > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > index 81c26a96c30b..907307a44177 100644
> > --- a/net/netfilter/nf_flow_table_core.c
> > +++ b/net/netfilter/nf_flow_table_core.c
> > @@ -282,6 +282,7 @@ unsigned long flow_offload_get_timeout(struct flow_offload *flow)
> >  
> >  int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
> >  {
> > +	struct net *net;
> >  	int err;
> >  
> >  	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
> > @@ -304,6 +305,9 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
> >  
> >  	nf_ct_offload_timeout(flow->ct);
> >  
> > +	net = read_pnet(&flow_table->net);
> > +	atomic64_inc(&net->ft.count_flowoffload);
> > +
> >  	if (nf_flowtable_hw_offload(flow_table)) {
> >  		__set_bit(NF_FLOW_HW, &flow->flags);
> >  		nf_flow_offload_add(flow_table, flow);
> > @@ -339,6 +343,8 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
> >  static void flow_offload_del(struct nf_flowtable *flow_table,
> >  			     struct flow_offload *flow)
> >  {
> > +	struct net *net = read_pnet(&flow_table->net);
> > +
> >  	rhashtable_remove_fast(&flow_table->rhashtable,
> >  			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
> >  			       nf_flow_offload_rhash_params);
> > @@ -346,6 +352,8 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
> >  			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
> >  			       nf_flow_offload_rhash_params);
> >  	flow_offload_free(flow);
> > +
> > +	atomic64_dec(&net->ft.count_flowoffload);
> >  }
> >  
> >  void flow_offload_teardown(struct flow_offload *flow)
> > @@ -617,6 +625,7 @@ EXPORT_SYMBOL_GPL(nf_flow_table_free);
> >  static int nf_flow_table_init_net(struct net *net)
> >  {
> >  	net->ft.stat = alloc_percpu(struct nf_flow_table_stat);
> > +	atomic64_set(&net->ft.count_flowoffload, 0);
> >  	return net->ft.stat ? 0 : -ENOMEM;
> >  }
> >  
> > diff --git a/net/netfilter/nf_flow_table_procfs.c b/net/netfilter/nf_flow_table_procfs.c
> > index 159b033a43e6..cff9ad58c7c9 100644
> > --- a/net/netfilter/nf_flow_table_procfs.c
> > +++ b/net/netfilter/nf_flow_table_procfs.c
> > @@ -64,6 +64,16 @@ static const struct seq_operations nf_flow_table_cpu_seq_ops = {
> >  	.show	= nf_flow_table_cpu_seq_show,
> >  };
> >  
> > +static int nf_flow_table_counter_show(struct seq_file *seq, void *v)
> > +{
> > +	struct net *net = seq_file_net(seq);
> > +
> > +	seq_printf(seq, "%lld\n",
> > +		   atomic64_read(&net->ft.count_flowoffload)
> > +		);
> > +	return 0;
> > +}
> > +
> >  int nf_flow_table_init_proc(struct net *net)
> >  {
> >  	struct proc_dir_entry *pde;
> > @@ -71,6 +81,9 @@ int nf_flow_table_init_proc(struct net *net)
> >  	pde = proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
> >  			      &nf_flow_table_cpu_seq_ops,
> >  			      sizeof(struct seq_net_private));
> 
> 	Result should be checked, pde is not needed:
> 

pde is needed to free the per cpu stat structure in nf_flow_table_fini_net
in the error case. This was implemented before this patch though.
I understand that some kind of error check would be good.
Since there is no consequence when this does not work I did not implement one
and let the old error checking go along.

Do you have any ideas how to solve the problem more?

Best
Sven

> 	if (!proc_create_net())
> 		goto err;
> 
> > +	proc_create_net_single("nf_flowtable_counter", 0444,
> > +			net->proc_net, nf_flow_table_counter_show, NULL);
> 
> 	if (!proc_create_net_single())
> 		goto err_net;
> 	return 0;
> 
> err_net:
> 	remove_proc_entry("nf_flowtable", net->proc_net_stat);
> 
> err:
> 	return -ENOMEM;
> 
> > +
> >  	return pde ? 0 : -ENOMEM;
> >  }
> >  
> > -- 
> > 2.33.1
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 
