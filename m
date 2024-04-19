Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2092.outbound.protection.outlook.com [40.107.13.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F062F8BE2
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Apr 2024 07:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.13.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713512887; cv=fail; b=isp3R8zGXWxqbY/uA5JmAC+4HQIIxHCVXV+xy8L+OrYqkteIBT6c53mHin6Zwcv0eF76qzmXBwDGdK6TlsJ4h3ZY8GI6UWmv7tM798JPDwDTDajryPIdEqSEnDiHgJH8D7CxVf3bosFKdP+bS/pasKLAjR9GBysl20D1ii+LJaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713512887; c=relaxed/simple;
	bh=q2wMx3UuzEqAgyujS9qbaHg4mbtlXPnOjnrYrdFzOjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BBlVAvsTuNXvf1n2yHI5EgeEow9+z1Lt2YB4JL8bh0hJC4kIsbyqW+D7A0KmhXCoA1loWWjbrqRFHHKRa+OfEDP2OHHruWc5tGoWH0gFkxehSKo/VyGR0cNU+uVpcjVFVwCy9FnCcCzuKDDv2rcdBzbVVQ4k/O38SxXucarPfkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=SsyqqH+N; arc=fail smtp.client-ip=40.107.13.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="SsyqqH+N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9JaN7DeI5Tq4aljQmqxMKKMy6RZPwCHOhbRKDWxhfkSCHjupE0a9DbDmPJhu/b349o29lAt56jO+0HwKIAGtw1DAQhSZBr2yp668BQ42fNeSTUZ42ivyOji4DIA8Qyu/wxgcWCO8Ao6s6LEwQPTeSEylQLFxCqxlBaODsJ4ZXoCGU4urTv38/t0N4H/YJhPKkA2usugMMmmS3zgParw4owvWEqWrELptG46rMn66KntXty8PA0opjuyRH5Fpd4eoGMao6eqig+Pe7D+aUIL9VH0Ff0+6hlt2+Q3/8gnUsm2kpj1n0tMGjgjtolnhm24RPDCulaT3JNFf9vCjVc8oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ha8YbydGYIQ85U+sUBiP3ia3kf+iu5IDAbJkXUFUjdI=;
 b=EQjcs6RAdtCWAanIc2oTQbAkEULhLwj4IwqzRfwcO9GONUiVQdWMSBkOrFYkU7czA1OEQ8jj+muNETdLs/iLyD0yM3tC0F0gd9VhnUP+f+cGiZ49lhttDQ8ColGMhyWl5l8wMQqiFYvsJESggDvy7vFMhbsotgrtkcxNd1vTk+8/cEAZk9H3iCp/49+PMk013y91CVS5YHFFM4SUi386o0Y9enwOp7zoJ1KGKnakcr1O5nt0toZQ6Vi08vnKmZKV3f+u0r3lrz0AwQuIf4B6FP+uooZ7nV8xAT2P+0oRmQxZyNsuTtGQ1kFFBLrccH5V5ic/YrMS0wJj+LI3ovTkFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ha8YbydGYIQ85U+sUBiP3ia3kf+iu5IDAbJkXUFUjdI=;
 b=SsyqqH+NBaT0+0NTOGq6dQtBup8VveQ+iz7P+cTAY5K9MGVgRLiVQcGpNjvhZozaXUWix+7Dolqjzd5KIGD+KF/ShwRWUMf0m3auXuVgQMKnpCfP2ytrFHjv4FPLv9nHzBUBY6jFGp9WdbNkVwRC1zPkoesHflHjH+4Ci3/rJ+0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com (2603:10a6:10:538::14)
 by AS2PR05MB10731.eurprd05.prod.outlook.com (2603:10a6:20b:647::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Fri, 19 Apr
 2024 07:48:00 +0000
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086]) by DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086%6]) with mapi id 15.20.7472.037; Fri, 19 Apr 2024
 07:48:00 +0000
Date: Fri, 19 Apr 2024 09:47:56 +0200
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, 
	cratiu@nvidia.com, ozsh@nvidia.com, vladbu@nvidia.com, gal@nvidia.com
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <yjjoc762gpm3gsdwyqpsbgw6wsybl7lhk3pqeygmv3acy76u3w@znzu42tkxosa>
References: <o7kxkadlzt2ux5bbdcsgxlfxnfedzxv4jlfd3xnhri6qpr5w3n@2vmkj5o3yrek>
 <ZfrYpvJFrrajPbHM@calendula>
 <x3qvcfxgdmurfnydhrs7ao6fmxxubmhxs2mjk24yn5zjfbo3h5@esbr3eff7bir>
 <ZhUibxdb005sYZNq@calendula>
 <uhn7bt3jdrvmczhlw3dsrinb2opr2qksnbip7asekilgczm35v@hyvzkxrgdhgn>
 <ZhetEIvz_vCB-A5D@calendula>
 <20240411110504.GE18399@breakpoint.cc>
 <ZhfMQM3KXi9dCBUd@calendula>
 <20240411121320.GF18399@breakpoint.cc>
 <ZhgGxoJyo_1vhPN_@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhgGxoJyo_1vhPN_@calendula>
X-ClientProxiedBy: FR0P281CA0248.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::7) To DBBPR05MB11225.eurprd05.prod.outlook.com
 (2603:10a6:10:538::14)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR05MB11225:EE_|AS2PR05MB10731:EE_
X-MS-Office365-Filtering-Correlation-Id: 1be35cc0-fa72-42ff-6b62-08dc604508e5
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RZP5tOEwNlI5bFFo+z84zXeUiw7aUpBtuNxCDy1BXPQGRfiG4JmNPSRLcMnK?=
 =?us-ascii?Q?O+hwg37PPVQhae9FGBMC7Xt/g2THhS8z+uc5HMhy/KRQ8AUhTkNGS+QD5iAY?=
 =?us-ascii?Q?SJzRfpMfMYJbSxBTEvBzsy002z0SRHe2X4zK4gVvX44HvyDCEUXSGr3NnsPU?=
 =?us-ascii?Q?Csq9kXfaAvkrVnG0ho5jynDrMqV6TZJh9wltdExtjhsM97dRevd6OWNPt7R7?=
 =?us-ascii?Q?5wy+zISTCqGwPpSMzKpeCBzn025QoGFQxlbGmNC6zABuO4JlICKYqBsf8Aql?=
 =?us-ascii?Q?KhGKSv7H5e20vs5n8ydJHI2WmyJHsO6P4na4h1mXwjNJRzuC7I6K6PS4lthi?=
 =?us-ascii?Q?3APffloM1ocDbySKnGp/Kc66PpU/Akhkn4zSSqvTWn4lmLNdhUN2mQo9+v10?=
 =?us-ascii?Q?5SfOia4Hv2+MlLW4J0OOlaQOKjm+FxT0Q6mxgZmV9HfF27fDR/5dNcZcOyVu?=
 =?us-ascii?Q?cbDou45mWGjh7z5zuBA5gF4N3+uoSaFU/G5IXfbDYCMd30vLnsDadfD9u42S?=
 =?us-ascii?Q?yK05HjGuIA9Ilw1NEVgSE3OJiTmt/xgTv1/aHG1vbp3D5gtFvevmp9VoVxhO?=
 =?us-ascii?Q?CSLsXxi4DE6USCUuBrveQINDDkZLW/KAXwWXTSnH5faxGdenSxD+O0W3q6MP?=
 =?us-ascii?Q?qr4UikOwGuRb+09PCNe2SKxGDzQq61AC/+ga2nQM374rxklNWieirADhIsAA?=
 =?us-ascii?Q?1zMjvfQZ5ApWue/iehAuWstciRWyAFrApFfYGobZ41gRV7vPF98i0UJUf6LR?=
 =?us-ascii?Q?CPpnps5lzC1mQlcYsLgHtJG9op56vMdBZMg+q+x4QklJ+08KxuxEgMsZil9X?=
 =?us-ascii?Q?dUz8cfA38G4e1xC6p1fEeTZUIQ/YP6jXeFOwRR+WB1U3NcwgMne5hqWIjxZn?=
 =?us-ascii?Q?UYSrLTnWdis0sjVxy68DNwz64zOYLMEbtOiqP9oFCXBEX6bUhi3JZzMvBMrx?=
 =?us-ascii?Q?ALGGhj/li62rngbFYE2OkDLkZ8I/LyIqLmjY/ST9q2Jhqpa2p2P7MqKiN3dO?=
 =?us-ascii?Q?3tZcauLbzNYVEghWvIPsVb7WLh0HKLN2pYAus5cDd8NRkjOxsHHmSw3rQ4qC?=
 =?us-ascii?Q?2fwdqVIwtsD0DLl5YjMsc1kNaCVpCYCYq4VQFbNb4PwKjjakjs5on1vGsOt6?=
 =?us-ascii?Q?4sqvBm0qh+eZiHZpM7F97Gg04Mh99SOqVez2LXh5EjpzMb0xtLJ1IlN46hjC?=
 =?us-ascii?Q?L7st9LiP7d+qLoFRGGlZJNyK/sS5KtjirVG76xvBQ2Zpyg62oaOVhqqLTPlM?=
 =?us-ascii?Q?87znXAcPNHpXonP5V4pwdX+Innde3YUKC3Ya3n6XNQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB11225.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8w9SFXF5rnqDtKj4mTboUDZt8iwBBwYdlcqqPw9cS5cqFrdpHwYV30Ga4Qe4?=
 =?us-ascii?Q?v7MloJOETSHNGnxoJlW/uDbC4nniqYp3XAZjqY0PHIrBHfR8nzRf9P6knZ7c?=
 =?us-ascii?Q?M17IuXTNAiQPeG3XIzPRVnH3yyL6wkUuX1fjkcY9JVHlOOoFyBN3mM4fEAX/?=
 =?us-ascii?Q?qjTWaj+E5ObMk5BA+1GSrj0HzwKV3dsdILS+xvdDm2t4P5nCOXIXUjYgDGHb?=
 =?us-ascii?Q?ua+R3ll+Rk/rFCXqWFxOfKHC40dwRKaWXqGIbIuEi+yJgCIyquxFv3oDpxwK?=
 =?us-ascii?Q?hNQZDsZ4DVFK/TiKuEcaD4fH8SbLS51Cv9aychQNAldRPAsNrtpaBzM+xo9c?=
 =?us-ascii?Q?jn+Hkc3IRm8GPc2tnKVJQSzEA9PBkFiGf16wTxBr4VQz1vVV1IvtYMvRKAd6?=
 =?us-ascii?Q?M0bmEJGRn6nynjoYd2nJ0A5tiAfgQPypSiCJiNB23yzezr7QvSoGcoShpFwl?=
 =?us-ascii?Q?WP7eRDjrV3uEk21RjDQ5ppubdnx1OUjyIwQZQYHSdkYTdNktv1yehpNMHL1o?=
 =?us-ascii?Q?Bz+bmvBgwUs8y3MEDdTxHQWUFQvgb1E9VOh99+rsMuW0lmT7EydF4SBksJcy?=
 =?us-ascii?Q?ub7gCokT6xBIe4dUNl35uDit6qh5CVkMbiKRBkF1koMJGbuAjg46l/9EPNlN?=
 =?us-ascii?Q?ms6p0Qb5+/7O38/1PRMJcvM03BVmSjqdtuqOfisjv5gmp/Gum4IBGdceMtGF?=
 =?us-ascii?Q?AkVfsdsRXUFaO2aAf3I5v+0skZ5ZD4ROmHnreFLOuHHJGFEWX+I+csV8Kw1z?=
 =?us-ascii?Q?0KQZnM+AVsg3yiGxCi/FCkGVwYZC+A38tFOvRH41khtQuZ+H9f4imRhfrDSN?=
 =?us-ascii?Q?B6QG5Vda/ympbMEYrqghJSQ1ahBZpBW4qJOswRAj2i9YfgfTwOtOHyANIgW8?=
 =?us-ascii?Q?TeFljjEWoJLJ6rhu50KhP8htGcnuMlrtnRjh8g+uxd64h75dQ5LmCeH2t9jZ?=
 =?us-ascii?Q?niEqYFafH1dlI+zthgJTbZWDpHKYZAcB4m0dY5docpK+15fq8Gy+4XT8Ew6r?=
 =?us-ascii?Q?jAI8mCJegiNFvLjYOw3RsInzjiAk68GaTarA2jSFHgbape/DelN5ccFcVniP?=
 =?us-ascii?Q?rylSQ524ZoZn/ubIA0i0gDL9rGeWGN/PmJe+GL4HDbvGUyYsSirmEO2kHp/2?=
 =?us-ascii?Q?TAlJUy/ojTNR9bK+Y3e8EGJxd/SiINCrzrnH0jft1xpba2kmB8m+opITgYgT?=
 =?us-ascii?Q?nF2TTITPc1SSxA9es16O2GxB9KT1xyYhQbLRtn6xIeGihSsX7DmXIUCI/WFt?=
 =?us-ascii?Q?bSI+BopW/K3Mx2xlWvX3M0xSakNs8BIBe3Qu5tVam/87O/yuJUBjP7QA8t/8?=
 =?us-ascii?Q?ewnv3wJ9RsrzGlXmhF2GwZ3IwTnZWYBNCnzbLzLW2Mvdfm7nyQqqLyjBWPRV?=
 =?us-ascii?Q?9JtFlwEty36xXqztdX32A8P8GE8C1wQCkdTGvYJFBD6XS7l047M0Z0kuOiP0?=
 =?us-ascii?Q?gjkef6TaXHKuaDOENILQhUMk4JmtPhRsulsL/KcXojKTA19DvVNaRvMUyV03?=
 =?us-ascii?Q?Iv0dMtyvKeW7rBrN8EkhN5tpgz9CjxANJFVjgJdhNV8BYN8SPjQtchrsITo6?=
 =?us-ascii?Q?tmO0Q6s1xR7g2WgECcxV9iCVSHI+EzY6zUUq9cAa0W62Qr79GErmruhV69wP?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be35cc0-fa72-42ff-6b62-08dc604508e5
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB11225.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 07:48:00.0234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vn9cYy2GAaG9Da6AJS6KXbH8fhUbhdgGqrCrrqODsndpOEp6rfYZp39mMOQdEtRwRkpRNMel7HM1BP5eW7rBK8YS5airxkNnKU3ibC05fdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR05MB10731

On Thu, Apr 11, 2024 at 05:50:30PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 11, 2024 at 02:13:20PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > I see no reason whatsoever why we need to do this, fin can be passed up
> > > > to conntrack and conntrack can and should handle this without any extra
> > > > mucking with the nf_conn state fields from flowtable infra.
> > > 
> > > You mean, just let the fin packet go without tearing down the flow
> > > entry?
> > 
> > Yes, thats what I meant.  RST would still remove the flow entry.
> 
> So flow entry would remain in place if fin packet is seen. Then, an
> ack packet will follow fastpath while another fin packet in the other
> direction will follow classic.
> 
> > > > The only cases where I see why we need to take action from
> > > > flowtable layer are:
> > > > 
> > > > 1. timeout extensions of nf_conn from gc worker to prevent eviction
> > > > 2. removal of the flowtable entry on RST reception. Don't see why that
> > > >    needs state fixup of nf_conn.
> > > 
> > > Remove it right away then is what you propose?
> > 
> > Isn't that what is happeing right now?  We set TEARDOWN bit and
> > remove OFFLOAD bit from nf_conn.
> > 
> > I think we should NOT do it for FIN and let conntrack handle this,
> > but we should still do it for RST.
> 
> Conntrack will have to deal then with an entry that is completely
> out-of-sync, will that work? At least a fixup to disable sequence
> tracking will be required?
> 
> > Technically I think we could also skip it for RST but I don't see
> > a big advantage.  For FIN it will keep offloading in place which is
> > a win for connetions where one end still sends more data.
> 
> I see.
> 
> > > > 3. removal of the flowtable entry on hard failure of
> > > >    output routines, e.g. because route is stale.
> > > >    Don't see why that needs any nf_conn changes either.
> > > 
> > > if dst is stale, packet needs to go back to classic path to get a
> > > fresh route.
> > 
> > Yes, sure.  But I would keep the teardown in place that we have now,
> > I meant to say that the current code makes sense to me, i.e.:
> > 
> > if (!nf_flow_dst_check(&tuplehash->tuple)) {
> > 	flow_offload_teardown(flow);
> > 	return 0;
> > }
> 
> I see, I misunderstood.
> 
> > > > My impression is that all these conditionals paper over some other
> > > > bugs, for example gc_worker extending timeout is racing with the
> > > > datapath, this needs to be fixed first.
> > > 
> > > That sounds good. But I am afraid some folks will not be happy if TCP
> > > flow becomes stateless again.
> > 
> > I do not know what that means.  There can never be a flowtable entry
> > without a backing nf_conn, so I don't know what stateless means in this
> > context.
> 
> If fin does not tear down the flow entry, then the flow entry remains
> in place and it holds a reference to the conntrack object, which will
> not be release until 30 seconds of no traffic activity, right?
> 
> Maybe I am just missing part of what you have in mind, I still don't
> see the big picture.
> 
> Would you make a quick summary of the proposed new logic?
> 
> Thanks!

Hi Pablo,

I tested your last patch but it makes no difference:

    [NEW] tcp      6 120 SYN_SENT src=192.168.7.126 dst=157.240.223.63 sport=63461 dport=443 [UNREPLIED] src=157.240.223.63 dst=87.138.198.79 sport=443 dport=13354 mark=25165825
 [UPDATE] tcp      6 60 SYN_RECV src=192.168.7.126 dst=157.240.223.63 sport=63461 dport=443 src=157.240.223.63 dst=87.138.198.79 sport=443 dport=13354 mark=25165825
 [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.7.126 dst=157.240.223.63 sport=63461 dport=443 src=157.240.223.63 dst=87.138.198.79 sport=443 dport=13354 [OFFLOAD] mark=25165825
 [UPDATE] tcp      6 120 FIN_WAIT src=192.168.7.126 dst=157.240.223.63 sport=63461 dport=443 src=157.240.223.63 dst=87.138.198.79 sport=443 dport=13354 [OFFLOAD] mark=25165825
 [UPDATE] tcp      6 30 LAST_ACK src=192.168.7.126 dst=157.240.223.63 sport=63461 dport=443 src=157.240.223.63 dst=87.138.198.79 sport=443 dport=13354 [OFFLOAD] mark=25165825
[DESTROY] tcp      6 LAST_ACK src=192.168.7.126 dst=157.240.223.63 sport=63461 dport=443 packets=10 bytes=790 src=157.240.223.63 dst=87.138.198.79 sport=443 dport=13354 packets=19 bytes=5061 [ASSURED] mark=25165825 delta-time=138

Best
Sven

