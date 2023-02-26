Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3857FC64ED6
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Feb 2023 13:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjBZNW1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Feb 2023 08:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBZNW0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2023 08:22:26 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2112.outbound.protection.outlook.com [40.107.247.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F39B462
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2023 05:22:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjjtN0O47AdTU8o0tkW9aMK8F2/UztLoEDOAH1kuhsCo6fksMAgco6O4LnK4hSj/MneD0+PEVpPHijGSe/xxQtxV4miTeYTfQxsQID+mJS1s6astUXUDKuswBUOh07Y0BEW3zrsbspX0sOlSzI2i9xDoLpHE5Eq2dhovtzUuLW4tJAEBBC8NntX/DPcuwL01K4i3oqtBjIroOkP7s5wc+6AnYESgLMn0XHw3l7ZZwwjRyVDKJ4zrI5zgyYxoWc4FAht6r8212nCPFY7J+8AL2aiAvFazsVqiF4J71zPrNtHx0RAcAZGF9/JmHQ8w9Rlh+orI4FTUQQFFhAyfBt2L6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwM8MrL5lhRJDgTBJjLJJwLF/Udigw1A84UP+uIO0lE=;
 b=A0U3NUax7CVzjTuuYl3fzO6COtZTdw4sO7SgwkqGg7I4GBJ5KdAQ3c74WsxqmHwv3WFOL4dLSYkzWTisJT3bYUq1PmS7z+A0afsNqn5qjsDvzAAVA2tf6RflUYzeOKi9qo/I1WRdfsIzGmnWCTH8DnvCl8/Q/UAblRvgPyiOZM7bV5d8HQXtfGCwSa2cPuUsBSvxDM5fpEhtLLOZgQEjHfGA0IlLy/SC/CXXp1YKaqbIUNAuk6K0diBj4yeHzBNTUr8sIEA//TUJG104E2Yip9nDCk9v4LnboJPMFDY2V4k8IeWqh193QVoSzHG7LNXmMzyan9ZpUnMKtJAj/9pfKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwM8MrL5lhRJDgTBJjLJJwLF/Udigw1A84UP+uIO0lE=;
 b=WVguaPkohl+keQGB4/qzhDAixMR3uwtP3PY7soy1aynI8eOfAuvQHwlVanRtBLGjsSr+Taf9URdewRtgJH2VyLjUGoroaPp6/ZektWpEIKXn01KBDKuGodZnoOkDnMG9jB/HDpGCLcT7ewuBK+sblRC07Z5YrHsPwjby3T/S05o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DB9PR05MB7931.eurprd05.prod.outlook.com (2603:10a6:10:25b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Sun, 26 Feb
 2023 13:22:18 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6%8]) with mapi id 15.20.6134.027; Sun, 26 Feb 2023
 13:22:18 +0000
Date:   Sun, 26 Feb 2023 14:22:14 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "abdelrahmanhesham94@gmail.com" <abdelrahmanhesham94@gmail.com>
Subject: Re: [PATCH] netfilter: nf_flow_table: count offloaded flows
Message-ID: <20230226132214.ad2qnyarcafxbacv@Svens-MacBookPro.local>
References: <20230226064436.hr4obihsi5o4hiqk@Svens-MacBookPro.local>
 <afee3af4-c85d-4daf-1f91-2017eaeaae5@ssi.bg>
 <20230226094048.zpxmsb4ljrjlfdwo@Svens-MacBookPro.local>
 <5ab636c-d52b-6aaa-6ebc-9a8f52a88844@ssi.bg>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ab636c-d52b-6aaa-6ebc-9a8f52a88844@ssi.bg>
X-ClientProxiedBy: FR2P281CA0160.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::9) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DB9PR05MB7931:EE_
X-MS-Office365-Filtering-Correlation-Id: 14d8eec1-8dad-4fa0-90c1-08db17fc7bf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: erbOxHrOEI3GhT/1rgtUFwlPZRrhQ9Wk1YoLeLdllud3pLj3Tt2q1GufbJEbdULDLWZd4eo+7SLY2SbH91G+G/AICmDPT+vaH2Q/bW7YZT7cs3CSuyTp9oVL+R3soR8cGIcTbNrekHrbKfJ6nqV0WMU1sPiMAqWb5oU2nrm3AEKleHn9KcRkJWr+1ginQN8aMnleFhkfZw972eGRMsqU/Cn8US3/YKzznt4gIpWh5E3htPLtIyLrHd8mP0QaOd/or+eMzdgELdILYmZnSNT53ig/uf8YqDokhexQMyXtOht0RN/yG0TIeAdq/E448kfgesXTNJRK85+u2uL3yn4L5E8OFUIq4xxB5MPUO4cmAjVb3244tPdIiiZwXbENsfNOEtpp77pxzoVxv4h59KOjKahH7Iqa+SiMPe1H0YE9DByExeaQAe6XhRlbl4PfMlBUfUU9S2ag43YQjKXrwLoCsjBJNZoijDyq8Vb+h5WF6cIjQbY1ydmC8/4UFjDz9ezYVe4U1HZUfbVsC7169PrrJvkcXFXavzDYP+OhFo6iL5X15872QFcAQLq/Ku0Q82tmnD0Yi64OjfyM99TQZjuqNYE1OuvUW5jcgWcDK89BJiWPQSUbCPpSH2uUTYK3OKBD71EhcJp+wNsrGqIR6ym5oA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(396003)(346002)(39830400003)(451199018)(66556008)(66476007)(66946007)(4326008)(6916009)(54906003)(41300700001)(8676002)(2906002)(8936002)(44832011)(5660300002)(6486002)(478600001)(6506007)(1076003)(6666004)(26005)(186003)(316002)(6512007)(9686003)(86362001)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3MQVKcvxdfQ10kYKNH2ZBDnrYga/XvSO/fCr5kI1Y2W8uAudVrwYMF9SGyCW?=
 =?us-ascii?Q?UY50Sdl93SVzSWmiWu//ZP23pLxcxmfCODleaEKGXTL5LZxpNu4kxlC5287N?=
 =?us-ascii?Q?oYl2TiI/RPUO6Az9hpjz2J/bhpQSHVecWhg+xPdNlvFCPXjeQ1CZfLdef1JG?=
 =?us-ascii?Q?DOj6joW9A+Fu/7B3eejjPWzY3Hjq/toA703hwypWuTw4EIqXRXZIMD5lvmoQ?=
 =?us-ascii?Q?KMhHhvu3YVm7lQLxj1tvsJfgXKtKq+LpqwUlj2h/vYTND6niJBkVtbeWFQUf?=
 =?us-ascii?Q?82WBEZ0o5IdacVuDg2VdR+2iZovNBJHQMQI134VVyuvuWuZbDYRDBzKZX/NB?=
 =?us-ascii?Q?UyaTeEeMETPBGDPsoD4X6apWouRG/JXtjJRupo5JSxod7HNZLJaEfweMBUK2?=
 =?us-ascii?Q?AS1WTDNDxAQVuPCP6N2oUxcBXed1pChQmhArUAIgNXaUnA6Vt7S3AEsRajVm?=
 =?us-ascii?Q?nyiQoMswXfQWYmRQOUDMohrnx5pakoUBZ1Xpg+0bsb8HVUvg2zNyMsTGAcBm?=
 =?us-ascii?Q?u1HfaZumvoGYnHLT+3Hc9XWM1nRcF1ZQP+AIbojSQVnf8+THPUC7Qol0g7vE?=
 =?us-ascii?Q?H0kt82mMq8QMzfpjtb4MORELD9pb699VTXf3QrezGmKwnnajqsR/kOpTAfsH?=
 =?us-ascii?Q?VCsX5NmxkM/+QUeDJJq/g5bNEuoI1MSFk2/tLDKGgumcSgk8VnEe6WNrcm02?=
 =?us-ascii?Q?FgJj2Zl00tS9/lFGbDE59qThOtInJxw7AyjUoqqENk5euGIMZ1aG/uFezpMn?=
 =?us-ascii?Q?5zECJarQei/X8mE3LT5Y3pNMOEpRXlqMeeo+fko38HjAA6YXE+aFsuqb5CGM?=
 =?us-ascii?Q?avcF6XzXjUfWRox65reZWmD/A3l/u+RaXdsAGJnloh++Iwlis5g9wEXouA1x?=
 =?us-ascii?Q?JhXIk6o6Wg/u5mbA+UnjymR3ygyvQBhB3R4QqdFKBSKxb0fSaOMDUGOthE3Q?=
 =?us-ascii?Q?ydJ6HE7Z0LChyfCEhlCCbzqZhTyESWGtq66hda1WYLKyRGPgVwkUFLohfh9x?=
 =?us-ascii?Q?zwBAOlN61QQXspXnk6/3nLPYTlfUUPmAnDDh8nYeIWXI/vMecinoh2zIK4aK?=
 =?us-ascii?Q?ubzRe0S8v5fXiPV9ieMH2ssH3uju5uKu9viPz8vEMzQNG5iTedicbzf9DGNV?=
 =?us-ascii?Q?cD03uuzr3+QLkYNFYqpxzfHNP7pRMZy4gPkPypxJlrt0RcdISpfAknAcSXky?=
 =?us-ascii?Q?12P+kW5uGPOnwqg3pCQTdb9tMK4lP7nZWj+de9+SI42BAPFlhNCmv6u1OT2M?=
 =?us-ascii?Q?lVseGEMlpt6+t0LC8e6ezuR5eM2m9nJa/bPr+LU1JLiTlAbK8D6x9uX6ezo7?=
 =?us-ascii?Q?9KmkmDvQHsuxjxmH52G551I3sa/efe2vaD/BPSxpcf5xL9nMhm44wgIRGjGX?=
 =?us-ascii?Q?lpBrq1yES2v27AVzpwzUFhjCab7WnuNLQaEdx6fmqHpmI3X+6zSP65zbTIjy?=
 =?us-ascii?Q?0rXv8MXjnm8VFrlOMdk5hL6Bzyw3XtdoH4fenQvEywG3CBAZ5txqJsVfRaXR?=
 =?us-ascii?Q?fNStHnRrc3xuXIXpaBAGvZjC9rH/bTg4hGaUUEH87sMzt2KmZbdMpf4pz8XH?=
 =?us-ascii?Q?6Rjb02Slo2SfrBIxIGxIw6M/xkCBl99CRFGoOVC78Y+u/QduyVX62TJknEEz?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d8eec1-8dad-4fa0-90c1-08db17fc7bf2
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 13:22:18.3467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZc9ScRH26azF26XduqsM8rKeNNYW41aJozbcIJk7tvNLPPW7k4oJDnXEPxBJ89+uhgxrTBKvfUeb2gmCL4wHveIEXoMjXd4woIoKgvZPt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB7931
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Feb 26, 2023 at 01:28:17PM +0100, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Sun, 26 Feb 2023, Sven Auhagen wrote:
> 
> > On Sun, Feb 26, 2023 at 10:53:58AM +0200, Julian Anastasov wrote:
> > > 
> > > > diff --git a/net/netfilter/nf_flow_table_procfs.c b/net/netfilter/nf_flow_table_procfs.c
> > > > index 159b033a43e6..cff9ad58c7c9 100644
> > > > --- a/net/netfilter/nf_flow_table_procfs.c
> > > > +++ b/net/netfilter/nf_flow_table_procfs.c
> > > > @@ -64,6 +64,16 @@ static const struct seq_operations nf_flow_table_cpu_seq_ops = {
> > > >  	.show	= nf_flow_table_cpu_seq_show,
> > > >  };
> > > >  
> > > > +static int nf_flow_table_counter_show(struct seq_file *seq, void *v)
> > > > +{
> > > > +	struct net *net = seq_file_net(seq);
> > > > +
> > > > +	seq_printf(seq, "%lld\n",
> > > > +		   atomic64_read(&net->ft.count_flowoffload)
> > > > +		);
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  int nf_flow_table_init_proc(struct net *net)
> > > >  {
> > > >  	struct proc_dir_entry *pde;
> > > > @@ -71,6 +81,9 @@ int nf_flow_table_init_proc(struct net *net)
> > > >  	pde = proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
> > > >  			      &nf_flow_table_cpu_seq_ops,
> > > >  			      sizeof(struct seq_net_private));
> > > 
> > > 	Result should be checked, pde is not needed:
> > > 
> > 
> > pde is needed to free the per cpu stat structure in nf_flow_table_fini_net
> 
> 	Nothing is needed to add in nf_flow_table_fini_net(),
> only in nf_flow_table_fini_proc() which is called by
> nf_flow_table_pernet_exit().
> 
> > in the error case. This was implemented before this patch though.
> > I understand that some kind of error check would be good.
> > Since there is no consequence when this does not work I did not implement one
> > and let the old error checking go along.
> 
> 	The checking tools will warn for such leaks, so
> every module should cleanup everything on init error.
> 
> > Do you have any ideas how to solve the problem more?
> 
> 	Nothing more is needed except the missing
> remove_proc_entry("nf_flowtable_counter", net->proc_net_stat);
> in nf_flow_table_fini_proc(). The var 'pde' is not needed.
> On error in nf_flow_table_init_proc() it should free everything
> allocated there and nf_flow_table_fini_proc() should free
> everything that is allocated in nf_flow_table_init_proc().

Got it and you are correct about nf_flow_table_fini_proc but it is also
called from nf_flow_table_pernet_init in case of a nf_flow_table_init_proc
error which is checking the return of the pde variable.
That what I was referring to.

I will send a v2 with your proposed changes.

> 
> > Best
> > Sven
> > 
> > > 	if (!proc_create_net())
> > > 		goto err;
> > > 
> > > > +	proc_create_net_single("nf_flowtable_counter", 0444,
> > > > +			net->proc_net, nf_flow_table_counter_show, NULL);
> > > 
> > > 	if (!proc_create_net_single())
> > > 		goto err_net;
> > > 	return 0;
> > > 
> > > err_net:
> > > 	remove_proc_entry("nf_flowtable", net->proc_net_stat);
> > > 
> > > err:
> > > 	return -ENOMEM;
> > > 
> > > > +
> > > >  	return pde ? 0 : -ENOMEM;
> > > >  }
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 
