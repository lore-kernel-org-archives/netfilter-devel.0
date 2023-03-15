Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458C2C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 11:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCOLpo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 07:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjCOLpm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 07:45:42 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2092.outbound.protection.outlook.com [40.107.247.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17B936099
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 04:45:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMb7EMwD6dNorxVJAZ/vZU3YK4D3aqS6Z6HpxjWWxq8ByerIJevfJBfjh+7NkMcYFPr+IGrJ/qDUZAYO215kZWkV5gXvoWWvCzAgMDv9BSEkT7W8PkynwLrfofp8ELA6tqQJeRYBvfmrgauR0IcKy7rTZ4Juz0Y2xhm52sQUZrmnT+t5pPv5JqFxEN8Jxxa8xYjjFZzTknkF+GPy/iok6HLyVFxPJ6ShjBVZsJ0tjcKkzJJvNNhWz3hXcyNrIWwnD+zMOJoCUIUbC6KTN6U4Aa2/aLeHw7V1/ruIJSDVnrmwpLCoGuZUcXoVyGLSgvwnAG8a5UUl6Qqnbr08WfTkQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CIMdrlLX5ByHz/ugJnWw9tbnRqWn83jSJOAZQHeSixI=;
 b=CDSPsHjjERVModPgRz80I9EAFSqehPb6fyBBDbU/LxrlM5+fAdrrq2/c56h0whji14MS63wHYyMBL7WvdNy4gUlq8fqRiYEh8kQ/LFgsLX0PzjZ2fRRNmJRsJU3igtnO8WjMNeBY+4eIFuEuEazN+7ZSAMmEeEXDmOn65vtncKR+sW7aIZRJNnl11PQ+5eGjr+pcHA7UBYqoPMP/1PUx2WfRxBxhDmQz0wpa8xBNffmlizvweSgHfjKaGByswfzJtQv7Hpilvg+a9nUrM9hVl3lsFDUNXHXmCQGWVbj0lm+LBUMd3d4fVplPdmbRNCu4YB+B0NSVaL8xQ5VtcfPZ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIMdrlLX5ByHz/ugJnWw9tbnRqWn83jSJOAZQHeSixI=;
 b=AJeaaLxp2aIBEk7iZQDMd1TiqDQnKy6e0VSRbLWDUTuTlNnhSy8hMo2dcWSHuSQtEtBMCDzd2FijHLv/rQJSs3ZJ35RzLYy+rIMF3ytVDqZOO5yKtJwC78HQ6AC3OPQEMcekuhJhCpaMMKljw7lqrxYi24hJ+CA9qvKmSYDmiw8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by AS8PR05MB8628.eurprd05.prod.outlook.com (2603:10a6:20b:349::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 11:45:37 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%8]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 11:45:37 +0000
Date:   Wed, 15 Mar 2023 12:45:33 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, abdelrahmanhesham94@gmail.com,
        ja@ssi.bg
Subject: Re: [PATCH v4] netfilter: nf_flow_table: count offloaded flows
Message-ID: <20230315114533.p5nrnjimlg2jktpe@SvensMacbookPro.hq.voleatech.com>
References: <20230228101413.tcmse45valxojb2u@SvensMacbookPro.hq.voleatech.com>
 <ZBGugrmYyUeyTLqr@salvia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBGugrmYyUeyTLqr@salvia>
X-ClientProxiedBy: FR2P281CA0076.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::18) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|AS8PR05MB8628:EE_
X-MS-Office365-Filtering-Correlation-Id: 4488c5ff-d968-4218-f1ab-08db254acb61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WEcKzKvavgVhDxV4pFeWNqzJXlJbshbhdGqBcQtU3X2GYc9zp4zcCE02zHJT9au6U3PSzOTbohdknTwci4axgmwOKmwRTVcDjrPhDAunk1QUNT8XnIscFVnexJYzrI3eVVxKvcgxJytv9MVWbBJyVfKTurhxuQ5rb9jB7oTUkpT94eboybz3wRA2BiAI/dtfw2dPScRAZLm+1Z1//WJQHBjyOA0BL/OmWPzmmlLPtEjtawkmfKEA7zd/LeJs5g3IrAyZ4TyqHvXKTIviP99dNLy9yaX+MNq7P4O/grDy/LvcxCcgcIU7pwb+aMNUgpOPw/GoKyVPePr7Xr7scilk3i0kLaLYCyIRCznNSi4sO/ud575bzj12FYZaT6FMIlO5VANBnQRv1OnqnWg2fVVluhZQ34TSNpAhGIt1fqT5bLO3INPC999EJa/A4jD9/xJpIW83dcLB0L80B47lZkLhpu71nCnu+WVtSjIFBZMPp6UCeFzVMP4eeRudqcizH7zRm/2+n2X6Pviel1qWH2RbfK7bGm6edDZ/a+YyuZ9ZuyejANPX0w+FwN78yJOY3Rfdt4nq7hM0SZG6JGCmtQ8k3e3+HA/6bKRmhGPGGPBSnhEd23hGE9A1k6KpGQhaYXOssq5DFenKuz7gJt7Cj5YBoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39840400004)(366004)(346002)(396003)(451199018)(86362001)(38100700002)(44832011)(2906002)(5660300002)(41300700001)(8936002)(4326008)(186003)(6512007)(26005)(6506007)(9686003)(1076003)(83380400001)(316002)(8676002)(6916009)(66476007)(66946007)(66556008)(6666004)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t96ihtvasq3r8r1avFEDG00MiT3IENZtFC5JHtG+6A7GAPC3oiSYtISF9Jpv?=
 =?us-ascii?Q?IKAqb5OvFDQdLS+FFNikxz+iCv3Taj9wPPlBUkHQy7L3QhjNWJ8QvmfGTUCF?=
 =?us-ascii?Q?FS1yD0AT+2vUmKhoeqFyGYNg0dAsDiWOm9ztSNFpTqK7WcfQ5bBcFo2ukAxT?=
 =?us-ascii?Q?ZVm5bAYUyn/IF27pDYBb1UDsj+6GwT9QTp9Jw79iL8roE6VVMRcpZmmoq4yu?=
 =?us-ascii?Q?PQgLuxB2iePsxrvESMmtGnCvdd5edIzU/qXKqbnchdSI2SAPOENYlUQGbeMK?=
 =?us-ascii?Q?iBMNWb/SS7oiWX9VSbWBvFij6RXsiNu7bzYFVf3etRcAWlPmDxXb3t1jtye4?=
 =?us-ascii?Q?zHONZS6C/SCS6TaoEix+EomGziWdrahtlqXxQdD8O23Y/E2pnVU98Ho2IfJx?=
 =?us-ascii?Q?I7HI/GRaz00UQcLDdzQmSb7v3OMZYQaGvYGS0ACv7lWxVjLqkJcmxJaRIO3Z?=
 =?us-ascii?Q?OROEw7YJQJx7+2klau8cxVxuQjex9GbV/eJTqewAdMLNQmED6uoda+8LRZfO?=
 =?us-ascii?Q?KkmZVfH6x24/nvwSjGL7plsZ/A3OdDtUD6DhO82+R5TSQFgTUfD9BjgaA/Or?=
 =?us-ascii?Q?h+xhIuyYQvWVUJik8luKTBjk4+ugCl+WxFU/10O02d4FQlFNMC9SovvZsRt3?=
 =?us-ascii?Q?hqSPtnhi93bl+kDS2jPbZn36sI9i9HbzFMfoXce3jkqXzrAiUdSLhrIAyFpx?=
 =?us-ascii?Q?5tCfhvgOG39yGRzCbn1Hhk0xXgTNzePVDp+ht3BcqlzzdJBeKz5F0K7G8zr7?=
 =?us-ascii?Q?vgo1lZxAzIjBrSOpEervsX8u1nSLzG9SmRrHMyu0CBhNH16BDztlmXdIfKAc?=
 =?us-ascii?Q?SQLQbrUFKU4IHJUmlXSBoJMWGeb4UxQEm12YIuHJY3IKE6OLZO8b+wK7T85/?=
 =?us-ascii?Q?6OSYeD61xxOrjBmeeqW7+vdy7zahG/1sblcp3zclvsVP3oMguS31vCYZqAam?=
 =?us-ascii?Q?MZNfzhoZKDV/XPmOtBNTXd6aeIWUghKyW7lprNMVaTX4bW3FIoFIZkuMFjF5?=
 =?us-ascii?Q?6FM3rMOagpl7KoIfPFavY7pZV9La3URFOMJYqJNEfTHwnzCyjz//XrZ7Gay/?=
 =?us-ascii?Q?vo7//CfsC3HWkleBHFmETdlo2E+lN+dvSxB3M5fyEq4aUqa9y7RwbLYWNCAh?=
 =?us-ascii?Q?uRwahLK6Tl7ReubKj52O3DtIypURnis2Aww2dde7lb9CoL1/1EpQ8Q4CKK3x?=
 =?us-ascii?Q?vyn4wfG3Fy4QZ+FNt4ubUaGWjxscnDNmklafAdWNbJ4CHpGJQHQECq/yR4ab?=
 =?us-ascii?Q?dSX68m+6Y/d+zmO3qjbC4FGN4VE3pqQTWYXVT4M/1dn/q5xQR00TZauUKYMK?=
 =?us-ascii?Q?A5BZGaX1QUJr9HFjUR+408y83E3WJUAIojp1ywJ9J316Xy5HLTdAX7plP2FC?=
 =?us-ascii?Q?9sNi/9vU2cO7wxwtkfSGiCXaRu6nBGqzC8UMpEsWnL8EvkwvfsLof0peoj0g?=
 =?us-ascii?Q?bos+6aY7SZeg+BVEFExU+nwIB1iK0C+hmiRSQ1imVHH/hcd+WMih0sRrMggt?=
 =?us-ascii?Q?Clh/1As4VajPryPOvAKlNEhxXCeMpVP6/wx+cb5N1qi8uVwl107tkUIKKWoC?=
 =?us-ascii?Q?HvJzO6vVa8/1mxuvBJtsmZfIS279My5D5g9WeRzq0Gw6StsCFoOf1gDYe0JY?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 4488c5ff-d968-4218-f1ab-08db254acb61
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 11:45:37.4633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YncSxe9d+agkMPwwZDVbZynyu0zDYcpvQD3lr1sM5aqkKn3k4oryaFk75PrZVAefJ243G4V44No00Ee6PwCb4U/V+CniJzFt+f+wQytlXAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR05MB8628
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 15, 2023 at 12:39:46PM +0100, Pablo Neira Ayuso wrote:
> Hi Sven,

Hi Pablo,

> 
> On Tue, Feb 28, 2023 at 11:14:13AM +0100, Sven Auhagen wrote:
> > Add a counter per namespace so we know the total offloaded
> > flows.
> 
> Thanks for your patch.
> 
> I would like to avoid this atomic operation in the packet path, it
> should be possible to rewrite this with percpu counters.
> 

Isn't it possible though that a flow is added and then removed
on two different CPUs and I might end up with negative counters
on one CPU?

> But, you can achieve the same effect with:
> 
>   conntrack -L | grep OFFLOAD | wc -l
> 

Yes, we are doing that right now but when we have like
10 Mio. conntrack entries this ends up beeing a very long
and expensive operation to get the number of offloaded
flows. It would be really beneficial to know it without
going through all conntrack entries.

> ?
> 
> > Change from v3:
> > 	* seq_file_net has to be seq_file_single_net
> > 
> > Change from v2:
> > 	* Add remove proc entry on nf_flow_table_fini_proc
> > 	* Syntax fixes
> > 
> > Change from v1:
> > 	* Cleanup proc entries in case of an error
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
> > index 81c26a96c30b..267f5bd192a2 100644
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
> > @@ -616,6 +624,7 @@ EXPORT_SYMBOL_GPL(nf_flow_table_free);
> >  
> >  static int nf_flow_table_init_net(struct net *net)
> >  {
> > +	atomic64_set(&net->ft.count_flowoffload, 0);
> >  	net->ft.stat = alloc_percpu(struct nf_flow_table_stat);
> >  	return net->ft.stat ? 0 : -ENOMEM;
> >  }
> > diff --git a/net/netfilter/nf_flow_table_procfs.c b/net/netfilter/nf_flow_table_procfs.c
> > index 159b033a43e6..45b054b435ec 100644
> > --- a/net/netfilter/nf_flow_table_procfs.c
> > +++ b/net/netfilter/nf_flow_table_procfs.c
> > @@ -64,17 +64,36 @@ static const struct seq_operations nf_flow_table_cpu_seq_ops = {
> >  	.show	= nf_flow_table_cpu_seq_show,
> >  };
> >  
> > +static int nf_flow_table_counter_show(struct seq_file *seq, void *v)
> > +{
> > +	struct net *net = seq_file_single_net(seq);
> > +
> > +	seq_printf(seq, "%lld\n",
> > +		   atomic64_read(&net->ft.count_flowoffload)
> > +		);
> > +	return 0;
> > +}
> > +
> >  int nf_flow_table_init_proc(struct net *net)
> >  {
> > -	struct proc_dir_entry *pde;
> > +	if (!proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
> > +			     &nf_flow_table_cpu_seq_ops, sizeof(struct seq_net_private)))
> > +		goto err;
> > +
> > +	if (!proc_create_net_single("nf_flowtable_counter", 0444,
> > +				    net->proc_net, nf_flow_table_counter_show, NULL))
> > +		goto err_net;
> >  
> > -	pde = proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
> > -			      &nf_flow_table_cpu_seq_ops,
> > -			      sizeof(struct seq_net_private));
> > -	return pde ? 0 : -ENOMEM;
> > +	return 0;
> > +
> > +err_net:
> > +	remove_proc_entry("nf_flowtable", net->proc_net_stat);
> > +err:
> > +	return -ENOMEM;
> >  }
> >  
> >  void nf_flow_table_fini_proc(struct net *net)
> >  {
> >  	remove_proc_entry("nf_flowtable", net->proc_net_stat);
> > +	remove_proc_entry("nf_flowtable_counter", net->proc_net);
> >  }
> > -- 
> > 2.33.1
> > 
