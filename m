Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91A3C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 May 2022 20:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344622AbiEYUJX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 May 2022 16:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344619AbiEYUJW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 May 2022 16:09:22 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2136.outbound.protection.outlook.com [40.107.22.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE2F5590
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 13:09:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2nlI9paGmsFtPVWFz4jIDtghBWUAhL1o+3UsXU4Gl5cLBH+iZbz1WjASyT17EsHIsnKEk4CtCBTtnF1po0AwihHAnMzvWzU31uObYSNt7YWdGTYTpyLTTkldi2MSgXWQbnvLCwLMgniTK7SKB8HvjXeZcWroqbSYBRyboMilHkAzwohFxdBvcB3X5AOMT2Ikofkr2vLD6zXmyCbqN5VZ8vJizbyBr+oc54I0Wx8ueaz8eO7FuKsCblZVXKhR2xvoemS3GgcS+xXzSrPCoobvmPO5d3IawIWD06OHhhB0ybGnypa30d+aIc1zGswUtyFMlBOoJpPn22e1jVzzk6ABQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOyQ+O8GEOkpvVDkoYeKSpjBibuYf63f73UYC7SHLYQ=;
 b=eiuD0Db+Q7kkI3vo8ZRQuRzA/R85NxjadJPpIdUV7uSTM37FuXmEiml7ZoGMZ3scPajRG08OkG/J3O4MjFP03t+h48LGnfd9NLueBZS+dTHyOM44R57cYgoxxKa7yznerxJ80rQpFGXTNOxmUFn1JzYYqAKb5Djmjj7o+JDFRHP145UjDYai/JCNC47WHZ8ouVdERyRr52Oa8OacIRI2YQr+g2a1s4Hld5Q5ogWiMOihftbEhTGx0H/hdHvpVPYp+0ceXNYMtXnAH0gzWMOvHrzK0nzh9zxUmUbIIu/z0nJSPdmZ/KTiSfdUencpygYHrbp4/9729toEjbd4JMA8qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOyQ+O8GEOkpvVDkoYeKSpjBibuYf63f73UYC7SHLYQ=;
 b=kA4fP/+1UFrddHDGFtPB4fO5PyPGq8h2Vo2i8m1KvnkNfDWdQ2pM1asIb8FaAEuJl4gQok/B6hrYVHm/P3xnMJbnrMnjQyM320QYEPAOuF3FFiOojYUvbgp62+S1PF5fPaPZF7OyHiihlRnCUPRMGxz9ucffS4yVIe4L4XWyeA8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by AM6PR05MB4807.eurprd05.prod.outlook.com (2603:10a6:20b:2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 20:09:16 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594%9]) with mapi id 15.20.5273.022; Wed, 25 May 2022
 20:09:16 +0000
Date:   Wed, 25 May 2022 22:09:12 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     wenxu@chinatelecom.cn, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: flowtable: fix nft_flow_route use
 saddr for reverse route
Message-ID: <20220525200912.gcjucakyfibn3soy@svensmacbookpro.sven.lan>
References: <1653495837-75877-1-git-send-email-wenxu@chinatelecom.cn>
 <Yo55KCPBfIk46hxv@salvia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo55KCPBfIk46hxv@salvia>
X-ClientProxiedBy: AS9PR06CA0157.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::32) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a628ae57-dbca-496b-1bd7-08da3e8a71d7
X-MS-TrafficTypeDiagnostic: AM6PR05MB4807:EE_
X-Microsoft-Antispam-PRVS: <AM6PR05MB4807957C43AD34A507D58B17EFD69@AM6PR05MB4807.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 64cEaGrQgBuEuLUpgy7KFWhJN0cI5UvA3vyJ7kpsKmGw/PjUP2xsTT7oQQf3ALCluzoJ9fQZnYvK7bZ2+Y+4w04jJIfdkMCxBc7DQWH4XrWVCVsoefIAZNyYOwW+AdiQdEGdu6eXLYbYYSuFFPRi0SdJ+k9MHns8vzEgbI7f6jYfHW5RiE51hCLyagB7ouemuOsX8qg9x5aijA74hCNvaPBZL8tGUGoZiaIn1UtXUf32WXJnEAA7dm0RPwpm88Ud/Gz3tVL5tr7XVrVgYQSMy3sRWpuObwfjNsk8Q7EPVkNlBzGeKzpNohYH1Pfs8GdvW+VWxxNXHyiAlz96J2PzmHcXfAKux/YLvCqGdlNjkkaX6aLNXsKU1zh+EDqgyqZpSFVTo78lJZrkBR98Jv9UIHH04dhA+YgAMOPrJLbwgYk8FQA3RkdrlQbtywsD5//Lrzu3MYo3Y9clBSNsKO+mUY13IHZ6EmISCEmwiO9MN4APNKOiLPZKipMWT33KMBPJ+ipK5HwRExfK0SndIH9/dl+DpwGH00igMbOgmY8o9rNnsfIdFeGPgfXhHSJa0c3g2FZ1nQps9jwhm7P8CMfYYSz6jxcGM6jfxSsRSJeeXRmsAjOnP630Xw+7/BMOtcvk9U7izKNwE7YnaoGTeYJ5mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(376002)(366004)(136003)(346002)(396003)(39830400003)(9686003)(6506007)(6916009)(316002)(44832011)(86362001)(2906002)(4326008)(38100700002)(66946007)(8676002)(66476007)(66556008)(8936002)(508600001)(6666004)(5660300002)(6486002)(83380400001)(186003)(1076003)(41300700001)(26005)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BLcbtfO8bGJw03ehzWWUdA8S7fwDHJP2oklMiquo6oPPq6S2yFvhW7l4v/V9?=
 =?us-ascii?Q?TWVQH7YODwjrekcmvWq5zieFvBXI3IOwnIDydl2GYOPHddnM+rKJiaNqKspu?=
 =?us-ascii?Q?TtmvxhL6x1LjaJ1oFeTAPmENBdF2OyYKoiVjk2mmmhAnkxWNfYeSLcn6TBGJ?=
 =?us-ascii?Q?ugrehSvvYwO+HusvAzgxUSwTEaRPD1I9+sjvIXCNkN7EByQw+Ii1VjpAohq7?=
 =?us-ascii?Q?M1d6OMEke+LEt+3bpz0qOADuUJMzLsaI3GfoCAfTzMQsMdpzlSi8x/sBN3ri?=
 =?us-ascii?Q?EX0RcFKWnGFAo5RiuiEjVOS/eiW3fj+eCiCdTFLwwUx5SPg7TXw+B4Ixj/HJ?=
 =?us-ascii?Q?BvixznrQ66aMJhPU1I8TqwOzYyB5sbL2LlORAtvFdSOPmHFssNKw/7a1/J6r?=
 =?us-ascii?Q?ZylfVIeokFNMMXTQyXTlCMBdf6+pl3q8RxznJodLfI4PlMGBZB5fln0zLv9d?=
 =?us-ascii?Q?uFL+s6UzktKbugO0HFjxTPhOObzspMTeBwMLEkr7cSRCFN/qCAy8BhlP+9i8?=
 =?us-ascii?Q?b7ZkZVx0Jm3eFKTinKEtum2bUt8bHM369DhMKgV4MnWjVEE/l3DLzBF87B8O?=
 =?us-ascii?Q?rB/AUnd/5+HlRHDecNJzg74HWcXg3G2+ez1ZQlpiAnAkCO5YDdqHRJzzUFnt?=
 =?us-ascii?Q?dEvWAoxP/iL725ZHlNyOKWk0KRb+qt5g7mym/NED+vU3QRwfJ5ySELSWp7mJ?=
 =?us-ascii?Q?cL7Z5ek8lcuNcvAhxvSe20x/JjQzXQp6pfIVzvipVyPGMFbtw+GZm7Pdy8QC?=
 =?us-ascii?Q?Z63+Q1CI3GDdzumv3prl4YsKPPoII/TT7Ch7OzlBSEgdsrOOt9/wcYizL0Lc?=
 =?us-ascii?Q?aDb4DHt4HGtMnPSKTXxK3pqEwOMIG1eTlWy1OJtfh4UqL0t3WeMny5AOwVge?=
 =?us-ascii?Q?t5MziWrU7YzMLu9UX+UBcYOXSoflkmqtdEdZDZis0OK65SMEuAfcnBtCzDjx?=
 =?us-ascii?Q?Rw2EUx2PGgAr3kwZsGrlyzcC7O6/s21cqv7YDluBq85UyKaFNIOY1n4jeOem?=
 =?us-ascii?Q?sZoMS08OzTHu5uaWwydyhejROwnXUygZKKlr1b3mjWrFBqynqmT2Nf2uWGJn?=
 =?us-ascii?Q?6JR+C8Djubb23jUeVLwx0j7SGmmlAwQxv88uG6EsZSq1MWDW4fhJak6+R/0y?=
 =?us-ascii?Q?P/HjzZH+5KNEEAD1wjavt8vwy5ZrBs5sChhQLz227eXey4DPNpVK0LGXAYud?=
 =?us-ascii?Q?QiBe/Buir37iy6B1wWRyna+OpC+nXX9tkNCJmmwuZ8slgRyzIaZ7ozTfEsSe?=
 =?us-ascii?Q?znPhN1k5SGwdzYgUYVKRkfQFulqF5j9vyvN5gjE/h9xd8ZDvdH8t8/heCG0J?=
 =?us-ascii?Q?ohNqHDy1y7usq0mj2pBMou4rtQ2pQQYq5xOXs0ZBhKdbnvjhb79oTeckcLiE?=
 =?us-ascii?Q?ddA68WwRMoyJCQmPmGpSJQLQ9St2FouHF7zzwMWbNUVRbfCaX/SLdimIf+bd?=
 =?us-ascii?Q?NLcKAFWcP5p2wRta7CYjozsJ+yfvxK0tclU3xRRjUZYIqwd/Xu064SsFBYW4?=
 =?us-ascii?Q?97ynd/xYXK11rl8NxYozrIuvAvRFsvkMBBpREIsOjYhHkUOj9gPxIIrEFVCL?=
 =?us-ascii?Q?CNW3jzYDSZyci9L8/oC9F8siXiAMf/utABJAyFoBFpQMdNE76Bh9aqtK9Nsb?=
 =?us-ascii?Q?BUKHx1hRrgGZBm61AIbxb2qWYuNHi6kT9JpU1/PPaHlHer8ElXC+VRHNeMmQ?=
 =?us-ascii?Q?7KS7ZrK9nx+9tmWkrm/GDnUFKVDZoIKXG+SvfaPWVwA35EhDlAReFqKL5tim?=
 =?us-ascii?Q?qBRJjtMxMetFJPBYW2uszvTLXdvK78g=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: a628ae57-dbca-496b-1bd7-08da3e8a71d7
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 20:09:16.4084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oU+4h743xYDDRrVkgshX90jkjoHLAM3WJkUPKWKEMf6hGjKlMkUid/uWO92zsUvk9n3r56Xb18swsARsIyNHAGHMgV+rDyDc7v7yq0Qjds4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4807
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 25, 2022 at 08:44:56PM +0200, Pablo Neira Ayuso wrote:
> On Wed, May 25, 2022 at 12:23:57PM -0400, wenxu@chinatelecom.cn wrote:
> > From: wenxu <wenxu@chinatelecom.cn>
> > 
> > The nf_flow_tabel get route through ip_route_output_key which
> > the saddr should be local ones. For the forward case it always
> > can't get the other_dst and can't offload any flows
> > 
> > Fixes: 3412e1641828 (netfilter: flowtable: nft_flow_route use more data for reverse route)
> > Signed-off-by: wenxu <wenxu@chinatelecom.cn>
> > ---
> >  net/netfilter/nft_flow_offload.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> > index 40d18aa..742a494 100644
> > --- a/net/netfilter/nft_flow_offload.c
> > +++ b/net/netfilter/nft_flow_offload.c
> > @@ -230,7 +230,6 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
> >  	switch (nft_pf(pkt)) {
> >  	case NFPROTO_IPV4:
> >  		fl.u.ip4.daddr = ct->tuplehash[dir].tuple.src.u3.ip;
> > -		fl.u.ip4.saddr = ct->tuplehash[dir].tuple.dst.u3.ip;
> 
> I think this should be instead:
> 
>                 fl.u.ip4.saddr = ct->tuplehash[!dir].tuple.src.u3.ip;
> 
> to accordingly deal with snat and dnat.

Hi,

I think what is actually missing here to cover all cases is:

fl.u.ip4.flowi4_flags = FLOWI_FLAG_ANYSRC;

and

fl.u.ip6.flowi6_flags = FLOWI_FLAG_ANYSRC;

this is used in other places in the kernel to fix this problem.

Do you want me to send a fix for that?

Best
Sven

> 
> >  		fl.u.ip4.flowi4_oif = nft_in(pkt)->ifindex;
> >  		fl.u.ip4.flowi4_iif = this_dst->dev->ifindex;
> >  		fl.u.ip4.flowi4_tos = RT_TOS(ip_hdr(pkt->skb)->tos);
> > @@ -238,7 +237,6 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
> >  		break;
> >  	case NFPROTO_IPV6:
> >  		fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
> > -		fl.u.ip6.saddr = ct->tuplehash[dir].tuple.dst.u3.in6;
> 
>                 fl.u.ip6.saddr = ct->tuplehash[!dir].tuple.src.u3.in6;
> 
> >  		fl.u.ip6.flowi6_oif = nft_in(pkt)->ifindex;
> >  		fl.u.ip6.flowi6_iif = this_dst->dev->ifindex;
> >  		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
> > -- 
> > 1.8.3.1
> > 
