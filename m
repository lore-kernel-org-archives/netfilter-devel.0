Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8DFC6FA8E
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Feb 2023 18:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjBZSdJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Feb 2023 13:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBZSdH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2023 13:33:07 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2133.outbound.protection.outlook.com [40.107.20.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4796FBDF5
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2023 10:33:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8RZbsmWxzZCskkvmPastmKfCn4umWwDy1ae9FG12MknninjIOY3YsUapXJl0Yx6VPUK5eB0VtsRAp0NVuCMgwoZ74xIo/2SsNBG6xbhPgnRxtaQMw80MX5bfd2+5YefGEwBpdx6KnMNM6MnqpKNozc62LVygNS1d5h883AE1cNwSV8dlhZKP0xyB0Zi2NJ69+NV13IM+1NqNtOdgdw6fXtnPgLDRYQFhC38sPJQSyfUyFDqElq7IB6zv3LbARGjTydwzfiKOrshNaVE+RsXrAA4+dcO4TYIwzjOj1hwKafd9TTRykZCKmsW5HSZPr0pcpG3ZG0mXSBkMaPf9vFYCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/FZq3xt0w47JMnNFNj7ZGl6AHaw8sBsW+MMFh1mGqE=;
 b=QniC8A3cHn91sOWya2m119lP+p641TGjCBolD8jEWmKI4bgCtgh8GNURfH7QJOnYN7Db87FYf1oav4pjWR+3Yu5C74pVRGot0+DXmnW9jwMbVHWAJp8iSE+pB0r+n9kVYAnMe1/Ts0QNNV0NiLOK+LUn96dGVt/esgX8gEBi2jz/0gSwXUfA4tE+fTiYlEpaW29t/J+MH40/SUfAHUsCxZvj8OL4xKY4YtXNV5gd3HR5L/XZi/F9xyOeGUB+/VjD3S/JpUubjVvV/VlqNG7RK0snZAD1XMa9fA6bFlik8ilc0lYB08nXaJpuvcyYfGx0pIpw6LXmyv1rJ4B+XenS4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/FZq3xt0w47JMnNFNj7ZGl6AHaw8sBsW+MMFh1mGqE=;
 b=ICcts0fh6GppGXzkSFFfQUteKMHeHfm1yizmVWLwWtOv4uUUbpQfKwG4v4n4bIE45bMRO4MphWL0dwgDyDy1YLE7OSq+gCtGS9ww/q/R4JoHBXCH1Rz7nmkGRKizHBjWXNngG21VLNe9Cp15BX6248PNf5R9S0Mb0OojMtfrWSM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DB9PR05MB7962.eurprd05.prod.outlook.com (2603:10a6:10:23d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Sun, 26 Feb
 2023 18:33:01 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6%8]) with mapi id 15.20.6134.027; Sun, 26 Feb 2023
 18:33:00 +0000
Date:   Sun, 26 Feb 2023 19:32:57 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "abdelrahmanhesham94@gmail.com" <abdelrahmanhesham94@gmail.com>
Subject: Re: [PATCH v2] netfilter: nf_flow_table: count offloaded flows
Message-ID: <20230226183257.m5hoehhcw4ct4pnl@Svens-MacBookPro.local>
References: <20230226133815.bjcovi4lw2c2fnos@Svens-MacBookPro.local>
 <b6821c29-d85c-117-faa4-3d1d1625bcb2@ssi.bg>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6821c29-d85c-117-faa4-3d1d1625bcb2@ssi.bg>
X-ClientProxiedBy: FR3P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::6) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DB9PR05MB7962:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d275dad-0368-42e6-7628-08db1827e3c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vHdFSq7JhD2rWDrAlNjA0VPF3d+69EPtbco9J5Vu52VtNx5ycb8Sz1ybGlXf5LTys+k8gQitZHm7saRDCvmorAkRh3lTYEciGiOJzCi80JL9pn9xUqIRiCUxHg2aq/uLCrOcbKELfo+XFpAo8Y0umXP20bYVqyX53rBesJd8l5wUuGp5rdW5FHuNy96g/+c0ruldIate1DPedlLDBp9TNpfkM9AK7f70jIiHXMEmlOivIHMx64QHqUYAffs7hmfCA3FBsj31pgf6panjgwsynT+XGV4D9mwJBQXnKUeUtGHFaye4a3f87Mj6Jml6I2snMmHY2QcBxCrQ3G3HgyoX1O06eZtonr5RyQ8yE74Smu3Q33ge0u8ofJU35OckcD5iyQXjWGqm6L+1d7/kl1WHpo+uZ1xHCpjSGTDbiiaY+Nb07DHtrqAumcwo7ONV16jrD0fdDkYphgpKI6pdqiBjuiggaRxrpmw69GCvVOs0jfcBcBqGi9+0kAqaUHGVJ5Q96WoRSItZLrjgyvk78iGUozybEILbVNfoOgobtHpeh4NiCPC7y/9cPQxPfBAysgmd6+LHyXszK57BCoAhiWpR71cjxKZyVDAPJqW2QBm3T1Rz25VNDDsO6lOrAvUcJtrKCOcFvIP5K/Vd5oZe6bxiNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39840400004)(366004)(396003)(451199018)(54906003)(8936002)(316002)(9686003)(8676002)(6512007)(26005)(186003)(478600001)(44832011)(86362001)(6486002)(1076003)(6666004)(6506007)(2906002)(38100700002)(5660300002)(4326008)(6916009)(66556008)(66946007)(66476007)(83380400001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CS+rojLfjT0w5QaRPCq96hYP5O+TPZoEcbBPpAQFcBENy1YN873MhJOJtVf8?=
 =?us-ascii?Q?T/UlOFq/BWQllMX7w0tzceVJPvMxjI6Kwc+/48AoyORZMLprxVg0tSm9ts+m?=
 =?us-ascii?Q?5uZIgaKMU7KOB/Hpn4JUMH/ijLKCuOdHh1ev/r0XBw5fCvWULF1cDzmLgi6l?=
 =?us-ascii?Q?gb14yTwMc6Fymu1GeqLDBd3yAULNnHONBAhvpU9bT13TfpTSXAsEx13cX9ju?=
 =?us-ascii?Q?vEMIiFttok1H+5M+aaiBLXAazcFK/JhuK0MWzgmf0ZbQo2O45/7YKoKaLL9q?=
 =?us-ascii?Q?A7+S+FcSwZB/2mwsNU2wQF/stIK+jLxZDAAXRMav+VjmjExe2pm1JDRzNhgN?=
 =?us-ascii?Q?cvfWpzhmtJeAPKXw342sUyjjl5uZNJtYrKU9OVke3584r0BySHoRTw9lUOS3?=
 =?us-ascii?Q?JylIMlWHubdqxwPc8KjMtcnagRvLoYB9SyDneCQ6YHkFtNPPgve/g+qm0O68?=
 =?us-ascii?Q?TdSGpG6wwb7R3kup6QC9NBVwVgUGzIhhBVOAcSQ2pRPOAweaH1inpe3ysZpm?=
 =?us-ascii?Q?/mY7Izsq0cHeDx/9uofQ2NwKGdHuAMsptNjR6Suzs1FWIwiNZKz/5Idc76w5?=
 =?us-ascii?Q?7Ct3zWurSC+x9FxAAZXdBG7qOZ1TZmrt8ELXrjtt6xdPuL/5ac42WM4xkYT4?=
 =?us-ascii?Q?WYNRdzDbXgupr6SVMIj3fvTIpk1WzlzUtnJY+sHdDTaeuk5Vw4j1AA3D8YKG?=
 =?us-ascii?Q?OVDLs0Bl5PLLnhSrp+kIG9S/u4uHaB91vA71rm2oKgJtFA90lOzNsX7PN7LO?=
 =?us-ascii?Q?YxQ9PL5nE2jF0XdE041lHGIS9blWSeqypyiGzu5uUU1ECwtdaudBt/2+7/+s?=
 =?us-ascii?Q?nQqpjz5zK0KWpxytXluxEbZR/JjnEDltjWzGShG9dyJiv7nGdETrn6MFD93S?=
 =?us-ascii?Q?96TaVnyah/DNNB9Ee8UeEmyauV78M6pv/PAsDA5kQpSlclo32iAc+DyOOuwA?=
 =?us-ascii?Q?kzsZyq5JHpScpsY7NcncVBOQDAK+xFrjiSRdf5z2SiK39KBqSAkxItom1JYV?=
 =?us-ascii?Q?+BulI9NCs0CUSnI58FSIA2j40XIuNqNjlz2+p4b9KM+3+1Sm4p7XkCHDclJ/?=
 =?us-ascii?Q?K7qMVRPHqjoUX4KG8tLnNqcdnUCW14RcX7lqjugpfzqEt6hRe15eQzD1FMko?=
 =?us-ascii?Q?ORVFd5nZzoUsHrfgbabTpNr6xaLcF2+NjrZdaoCL9CfYHZaZ8U+KQSb4nmDG?=
 =?us-ascii?Q?MOTFuLqRgfVKA268OKGxobNBe/gYZiRYxlyVynTF/eU6yO7120779qCvroLc?=
 =?us-ascii?Q?fIqRg+nxNP/v806ZK3pBsPAwk2fQwqZbtoWWOqyWMmQvSzWnaZDh5BHtROAI?=
 =?us-ascii?Q?Jsz7N2oc27+bwwUwf2RdkM69wki/ZaxdRy2pYlTHB4YcLeMYLKDUbCsh28Qy?=
 =?us-ascii?Q?C8AANzTgPWGBO3/Sbby5GNEx/dGwxz/KigeaHwdmUYcJHqUhAce/r8xgGvFl?=
 =?us-ascii?Q?W9cve9+1QK/AgsQWqv5K0QOnSDQ4YAFDHRExTnKWeyXrYeAowUckj0IfVdql?=
 =?us-ascii?Q?679lmDHLh6qoTso7iY7uAT69WFPDighnC5aEkmw+474TqWBUoXP99SsAeJEK?=
 =?us-ascii?Q?iOaPbBncJY+ARH8jxuNju4LHZmgkKhMKJYJcVWBoQC9ZghzdGvTYrciPCf8X?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d275dad-0368-42e6-7628-08db1827e3c0
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 18:33:00.7982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/44DAbJ6Dw1cVuNrMnrMBz8dIt+mqDOjzYfPyAwvkED7t1+bsT7PENmWNMyO+jBJgAujmCX96bT6fe/OPQG4bXbOTXBdwAndy79pWDkJ8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB7962
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Feb 26, 2023 at 03:28:52PM +0100, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Sun, 26 Feb 2023, Sven Auhagen wrote:
> 
> > Add a counter per namespace so we know the total offloaded
> > flows.
> > 
> > Change from v1:
> >  	* Cleanup proc entries in case of an error
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
> 
> 	Better to put this new line as first
> 

Will be in v2.

> >  	return net->ft.stat ? 0 : -ENOMEM;
> >  }
> >  
> > diff --git a/net/netfilter/nf_flow_table_procfs.c b/net/netfilter/nf_flow_table_procfs.c
> > index 159b033a43e6..aba4dbfc7a37 100644
> > --- a/net/netfilter/nf_flow_table_procfs.c
> > +++ b/net/netfilter/nf_flow_table_procfs.c
> > @@ -64,14 +64,33 @@ static const struct seq_operations nf_flow_table_cpu_seq_ops = {
> >  	.show	= nf_flow_table_cpu_seq_show,
> >  };
> >  
> > -int nf_flow_table_init_proc(struct net *net)
> > +static int nf_flow_table_counter_show(struct seq_file *seq, void *v)
> >  {
> > -	struct proc_dir_entry *pde;
> > +	struct net *net = seq_file_net(seq);
> >  
> > -	pde = proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
> > +	seq_printf(seq, "%lld\n",
> > +		   atomic64_read(&net->ft.count_flowoffload)
> > +		);
> > +	return 0;
> > +}
> > +
> > +int nf_flow_table_init_proc(struct net *net)
> > +{
> > +	if (!proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
> >  			      &nf_flow_table_cpu_seq_ops,
> > -			      sizeof(struct seq_net_private));
> > -	return pde ? 0 : -ENOMEM;
> > +			      sizeof(struct seq_net_private)))
> > +		goto err;
> > +
> > +	if (!proc_create_net_single("nf_flowtable_counter", 0444,
> > +			net->proc_net, nf_flow_table_counter_show, NULL))
> 
> 	I hope this is correctly net->proc_net and not net->proc_net_stat.
> Also, scripts/checkpatch.pl --strict /tmp/file.patch has some
> alignment complains.

The net->proc_net is on purpose since the conntrack data are also in this place.

> 
> > +		goto err_net;
> > +
> > +	return 0;
> > +
> > +err_net:
> > +	remove_proc_entry("nf_flowtable", net->proc_net_stat);
> > +err:
> > +	return -ENOMEM;
> >  }
> >  
> >  void nf_flow_table_fini_proc(struct net *net)
> 
> 	This is still missing as first line, with the correct 2nd arg:
> 
> 	remove_proc_entry("nf_flowtable_counter", net->proc_net);
> 

Sorry, will be in v2.

> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 
