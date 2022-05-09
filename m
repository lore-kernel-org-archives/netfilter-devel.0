Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D323C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 May 2022 13:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbiEINUf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 May 2022 09:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbiEINUc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 May 2022 09:20:32 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2110.outbound.protection.outlook.com [40.107.22.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFB81A15EA
        for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2022 06:16:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kb/PPXek1JK/7s5fKGR9xgsPwr+Vogg9cS3ZQ0p83a5iaYi1W1+MV/4oElyk9PmnIVynDPYVKMvxi3EIfSZVgJdvIIqM0gzJenH9i/aeQ3CsYQLzYqMQLv+8oUD1VSWHKd4zdhQQailARZiNmsIbEBqDUL2uKa3sjTwzX56p+OLC5Hg1Fzc+SwkuYY901G83J9TvHSZnjXddpetsF3KWdRaNQVWmGgtHsEPO27ii3mXMvQ6cVidOzT9ymbULIzA/1g/kMPtjCYuGfvPNzhxwlxqszyN9dsZaCn7ZquSt/wTiA26zitz65HrHj4u2O8HR8pz5XOIug63PTE39NHxHBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WEO7HAUaP+E3ygAvcmw3sQJZ6xqcutCYefswFHIKlkg=;
 b=JV1zbX+WpvIFHIZNiI9qqiydO9xgPoojrj/TBAx6PXMECZrEdErW15EJKVxkzlAmweL4WRrBq6VfbbNpy8bfBwjc6FjLAlG73ElWc9a4m7pBZf1Uh4dd09deSPZHcOuzMasZGwtwAUw3OOJJTbhMHT+TR9sNNaYYWVLJhXzc51Z98Synk6PCoS7MW8i2u7DSZ8mNatqsQj+eDrlQYpnm7iznM9G0nUmgCas2MeME9PS6TxrDlOSCOvU+Rjerd2IJXOhx/1gDAWlUAiNtG2KuVsCVtYD9OL748B580vEwjXir59XuxVcSayY3MqSRNDJ3hV5avG+qcoaZf1R80+DFZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEO7HAUaP+E3ygAvcmw3sQJZ6xqcutCYefswFHIKlkg=;
 b=ecS6VvDVztETAfBJmog519uEsykLkgK6oUBB5DrmVzu3lg7VUM120MMJcNvrIY/K9k3779ozPL243fhAfRnEmrMzx+9IeLC03atnMB47ryJSIrnYrF9eG2JnleHf7YiQ8VsoTYzYZmOc3Cd3AiSr5sCGCVq5/GGIhRLm0gi+fuo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by PR3PR05MB7513.eurprd05.prod.outlook.com (2603:10a6:102:8c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 13:16:36 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::c4b9:8da4:3f97:a2c6]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::c4b9:8da4:3f97:a2c6%5]) with mapi id 15.20.5186.021; Mon, 9 May 2022
 13:16:36 +0000
Date:   Mon, 9 May 2022 15:16:31 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, nbd@nbd.name,
        fw@strlen.de, paulb@nvidia.com
Subject: Re: [PATCH] nf_flowtable: teardown fix race condition
Message-ID: <20220509131631.asgitsqwt5s57a6c@SvensMacbookPro.hq.voleatech.com>
References: <20220509093132.fmxxhhogq7jhhpks@SvensMacbookPro.hq.voleatech.com>
 <c4622e4f-d22d-b716-6909-400eae9b3abf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4622e4f-d22d-b716-6909-400eae9b3abf@nvidia.com>
X-ClientProxiedBy: AM6PR01CA0042.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::19) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac9c4395-7eb9-4cb7-08e2-08da31be24f2
X-MS-TrafficTypeDiagnostic: PR3PR05MB7513:EE_
X-Microsoft-Antispam-PRVS: <PR3PR05MB7513DE98F579DFCC075CBCDDEFC69@PR3PR05MB7513.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K1w3D6mUxvkBjZ+Y5Qoka5QVgCDC72N2HWdC3iM8fD6l+Z7fRDtlMDfTX560YO/ZEb4ubyJ7wM3USE9o+b26MxEK7Al4F3tSRm0wEjy8EV1hvpI55aLO1sKYInIlzw60GcK3KpR16B79yaXO3CroosaRFjK1IL1so/xbObv112kL8m3uoOQUZ+nZLn2lsWq2ylXy7FZ83yjuNzcDW5N9hgMVsaHjMFUlo08ALOZAR8u9CoNR86e9bpXNDmyMxQLXbhjNixZDD22ueBtWmqhNbrzwRsRLfJODtcypqHEbC+Oyqep4DynuZ3HakKGGaktBfNeQY80AAvypK5bxjCnTLQk/fqVqvEUTtial+fshhGH8V0FYgr9WxOX3q9jmHHZiIRnYk1Xf+5yWrZ7DzX1ctmGqCouRLgxXByUCZKzyFw/BtNloVcv9Sw6IZg6tSd4/OVTNwyI/JnJ5jLPbMVkcAbFkIVs5SbAk7r2gjfTl2z9F89k4k6Zo8XMg6ZWOmItcH2WCbfaYxS+I/XpC8O3IY2UKOue9A/sGBMWu/0hv2Pr+U68nsirIKoFPutFbX+4fKLo0ZhsYQQZsWRyfKIdb8x4Qm7VnSSiF9eEEN/f3qtLNaV50VfLUFQ8UMBLvIac0IvbFblBLgj2VfrUUxK1vpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(346002)(396003)(39830400003)(366004)(376002)(9686003)(4326008)(8676002)(44832011)(6512007)(26005)(2906002)(53546011)(6506007)(6666004)(8936002)(508600001)(6486002)(86362001)(5660300002)(66476007)(83380400001)(1076003)(186003)(316002)(66556008)(6916009)(66946007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5bdD7cgbYs+5H/xRGA4YsI5L0s+mwGuwdjbrXukIE4thbq3/vR1Z3mPX0AVg?=
 =?us-ascii?Q?7MnMRGDnBiapg6C90/2LOEc44wRw77AR9YvG2SeW3zmron5r69teaKQNxaPz?=
 =?us-ascii?Q?WBfspWYniW8+xSnG0T5xsbHFH4NbPIDxsUAohAJigqbn9fLf5L/H7lOidfOW?=
 =?us-ascii?Q?iahqg2CTCBSf2MrE7mnTeObt2yuJcxEmluVHFpBoRsnnNhUzv2KHfDuaM6cK?=
 =?us-ascii?Q?aHQS84i7fEwwjeW/vM0mu8J+JFoCn70Hgxg5q/R3rGJx9J9Xwwh8NZxnxFyr?=
 =?us-ascii?Q?JfGiU39US5KZw0Muz4+TYZ+o9FaHcWU4ycs5UMie2Ok9r9mHt29wXBDfiFSW?=
 =?us-ascii?Q?T7NGgYUXdWIf/JeUT92zlplqpS5T3yA0bM0eMOfNI6eWNmTQVuQ5lizI4q79?=
 =?us-ascii?Q?QwVP3Js8FcmQE/qhqRTNy5pdeybOcel6ShuOPlXE77qcfIErAk4c1pTRM2IP?=
 =?us-ascii?Q?F6vuY0onvfUuxc7bcRAAh3Fq7fLVlSJF5LUIk37De1a9TtX8kLHDFQctSuwb?=
 =?us-ascii?Q?1H0+/6qpMWouy8zvUrTDW8oss+FhVdK+q5bcmxsmFwM3j+x/7ba5POI/Lh/j?=
 =?us-ascii?Q?/C4F+5bncnclkugA0G0NOqnSFA3vSgvTPbi2rxrZ1VA+ycazazeCE089MaU+?=
 =?us-ascii?Q?5ikD12UlbmQ5bpcNxUfIw5KNE5uGGMpRentQfxWvWqAOdNZuwCI3OpYU+HPv?=
 =?us-ascii?Q?uiGkaK1DCXwiqYQPrQp2WE477ctZYRcuKaIH5LBvdZ7u7xTaYagQxYQA/hjK?=
 =?us-ascii?Q?PUG3gZ4bzDk/ayrV7OMIav5jdNVCK1Xk6x4F2aNmsGBJzp8bPGtXBSRYQaZD?=
 =?us-ascii?Q?RAupCX/Cpvleu9CMFa31EFet39nq1sZIlNqpbwdQEQ5w8C/wcPFIKiq6X84o?=
 =?us-ascii?Q?kxBBBRT9Jq4WnJYaVw9I4SEmh4hJdzaMQiFQBNPL0prqozZ3cHPx6VPoRAjj?=
 =?us-ascii?Q?oho7ebQgWedeJqwBwVOw4BFnJKratjPpFjgSK3TwGIJ7vgw8cr2igH8l3C0O?=
 =?us-ascii?Q?k093EZP2L/ocgb0S9nl2EDBy3F6OZVo3QjafcNYbwBRFQgPTlASGZdruP81X?=
 =?us-ascii?Q?8ZxAFmJM0zdxxQfbcnNWc4s+QYJpXg+kwmuKSjvb3rSe6hvr/VW+cZ8sEu6U?=
 =?us-ascii?Q?iI6QMhqlqoUba2AlL3osB/HOiLOcHKw4wqictNraryXb666OQgTOwXOX7NLO?=
 =?us-ascii?Q?QuXgy4sYXztznciX/CeIxhHVtzA4SnLwPEelqAP2zbuL1g+PQi1TZK0odMPC?=
 =?us-ascii?Q?NqT4+j7DraMtT+U7zyugxSQi1tDz7HTgN3/RpXhYkW1Y71zLQ0lJxYmNnsjz?=
 =?us-ascii?Q?H0Z+TR1rNZCvDSdIv1flGB/P3UHHMt224XXZUYVu3wW7cyEN3MhAMG5o5K0C?=
 =?us-ascii?Q?6ukltpd8Fw6/M7gHuxwJXcJxBamD/4VV9ZAZNR53qqAFGjspe+fwkj6VzxN0?=
 =?us-ascii?Q?2WoSwj1NoUtohs9LBjR3ZWG5ecudvIp5zxDqpAN9Jhb10iSBz7IvS64Nj6Je?=
 =?us-ascii?Q?MpQpYhd/vmOZ2p9W1WMoWc+ZaG7oTuM8kMO+2PQ8VT0n9at53cDUQIalpScm?=
 =?us-ascii?Q?5VnZawdU06d7sL9H89GPfmK21MqCkY4HgzNdGcuQFHQRrsnnUy4DEOrndhn+?=
 =?us-ascii?Q?v0v6y4OxfpYokfv/U2GV/7iTDhl/NFQOin9uxq7iqMMJUuWUlEy8HVxggwGF?=
 =?us-ascii?Q?ftX0WbvRwh5AQDQukb+kcalK4UGrRuqHlRKgbG657SCzmOOID0NvnUuFqnlr?=
 =?us-ascii?Q?+nVM5Bmx0Es/EhlJXpP1sQVGyvhQMI0=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9c4395-7eb9-4cb7-08e2-08da31be24f2
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 13:16:36.1467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o2HJMoMnRYG8D7AYKB85qRWOvapHgGHi3TRTMrP0QUGcdhcO/PnzQ42Wuh11WzMw71HbZIX+cPA9fNzqxjmpxh6d8fF1BQ7DqAxjdfn++0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR05MB7513
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Oz,

On Mon, May 09, 2022 at 04:13:19PM +0300, Oz Shlomo wrote:
> Hi Sven,
> 
> It seems to me like the issue should be resolved from nft side rather than
> the flowtable side.

this is not possible to be resolved on the nftables side only.

> 
> On 5/9/2022 12:31 PM, Sven Auhagen wrote:
> > The nf flowtable teardown forces a tcp state into established state
> > with the corresponding timeout and is in a race condition with
> > the conntrack code.
> > This might happen even though the state is already in a CLOSE or
> > FIN WAIT state and about to be closed.
> > In order to process the correct state, a TCP connection needs to be
> > set to established in the flowtable software and hardware case.
> > Also this is a bit optimistic as we actually do not check for the
> > 3 way handshake ACK at this point, we do not really have a choice.
> > 
> > This is also fixing a race condition between the ct gc code
> > and the flowtable teardown where the ct might already be removed
> > when the flowtable teardown code runs >
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > 
> > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > index 87a7388b6c89..898ea2fc833e 100644
> > --- a/net/netfilter/nf_flow_table_core.c
> > +++ b/net/netfilter/nf_flow_table_core.c
> > @@ -5,6 +5,7 @@
> >   #include <linux/netfilter.h>
> >   #include <linux/rhashtable.h>
> >   #include <linux/netdevice.h>
> > +#include <linux/spinlock.h>
> >   #include <net/ip.h>
> >   #include <net/ip6_route.h>
> >   #include <net/netfilter/nf_tables.h>
> > @@ -171,30 +172,32 @@ int flow_offload_route_init(struct flow_offload *flow,
> >   }
> >   EXPORT_SYMBOL_GPL(flow_offload_route_init);
> > -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> > -{
> > -	tcp->state = TCP_CONNTRACK_ESTABLISHED;
> > -	tcp->seen[0].td_maxwin = 0;
> > -	tcp->seen[1].td_maxwin = 0;
> > -}
> > -static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> > +static void flow_offload_fixup_ct(struct nf_conn *ct)
> >   {
> >   	struct net *net = nf_ct_net(ct);
> >   	int l4num = nf_ct_protonum(ct);
> >   	s32 timeout;
> > +	spin_lock_bh(&ct->lock);
> > +
> >   	if (l4num == IPPROTO_TCP) {
> > -		struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > +		ct->proto.tcp.seen[0].td_maxwin = 0;
> > +		ct->proto.tcp.seen[1].td_maxwin = 0;
> > -		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
> > -		timeout -= tn->offload_timeout;
> > +		if (nf_conntrack_tcp_established(ct)) {
> > +			struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > +
> > +			timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
> > +			timeout -= tn->offload_timeout;
> > +		}
> >   	} else if (l4num == IPPROTO_UDP) {
> >   		struct nf_udp_net *tn = nf_udp_pernet(net);
> >   		timeout = tn->timeouts[UDP_CT_REPLIED];
> >   		timeout -= tn->offload_timeout;
> >   	} else {
> > +		spin_unlock_bh(&ct->lock);
> >   		return;
> >   	}
> > @@ -203,18 +206,8 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> >   	if (nf_flow_timeout_delta(ct->timeout) > (__s32)timeout)
> >   		ct->timeout = nfct_time_stamp + timeout;
> > -}
> > -static void flow_offload_fixup_ct_state(struct nf_conn *ct)
> > -{
> > -	if (nf_ct_protonum(ct) == IPPROTO_TCP)
> > -		flow_offload_fixup_tcp(&ct->proto.tcp);
> > -}
> > -
> > -static void flow_offload_fixup_ct(struct nf_conn *ct)
> > -{
> > -	flow_offload_fixup_ct_state(ct);
> > -	flow_offload_fixup_ct_timeout(ct);
> > +	spin_unlock_bh(&ct->lock);
> >   }
> >   static void flow_offload_route_release(struct flow_offload *flow)
> > @@ -354,12 +347,9 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
> >   			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
> >   			       nf_flow_offload_rhash_params);
> > -	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> > +	flow_offload_fixup_ct(flow->ct);
> > -	if (nf_flow_has_expired(flow))
> > -		flow_offload_fixup_ct(flow->ct);
> > -	else
> > -		flow_offload_fixup_ct_timeout(flow->ct);
> > +	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> >   	flow_offload_free(flow);
> >   }
> > @@ -367,8 +357,6 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
> >   void flow_offload_teardown(struct flow_offload *flow)
> >   {
> >   	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> > -
> > -	flow_offload_fixup_ct_state(flow->ct);
> >   }
> >   EXPORT_SYMBOL_GPL(flow_offload_teardown);
> > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > index 889cf88d3dba..990128cb7a61 100644
> > --- a/net/netfilter/nf_flow_table_ip.c
> > +++ b/net/netfilter/nf_flow_table_ip.c
> > @@ -10,6 +10,7 @@
> >   #include <linux/if_ether.h>
> >   #include <linux/if_pppox.h>
> >   #include <linux/ppp_defs.h>
> > +#include <linux/spinlock.h>
> >   #include <net/ip.h>
> >   #include <net/ipv6.h>
> >   #include <net/ip6_route.h>
> > @@ -34,6 +35,13 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
> >   		return -1;
> >   	}
> > +	if (unlikely(!test_bit(IPS_ASSURED_BIT, &flow->ct->status))) {
> > +		spin_lock_bh(&flow->ct->lock);
> > +		flow->ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
> > +		spin_unlock_bh(&flow->ct->lock);
> > +		set_bit(IPS_ASSURED_BIT, &flow->ct->status);
> > +	}
> > +
> >   	return 0;
> >   }
> > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > index b561e0a44a45..63bf1579e75f 100644
> > --- a/net/netfilter/nf_flow_table_offload.c
> > +++ b/net/netfilter/nf_flow_table_offload.c
> > @@ -5,6 +5,7 @@
> >   #include <linux/rhashtable.h>
> >   #include <linux/netdevice.h>
> >   #include <linux/tc_act/tc_csum.h>
> > +#include <linux/spinlock.h>
> >   #include <net/flow_offload.h>
> >   #include <net/netfilter/nf_flow_table.h>
> >   #include <net/netfilter/nf_tables.h>
> > @@ -953,11 +954,22 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
> >   static void flow_offload_work_handler(struct work_struct *work)
> >   {
> >   	struct flow_offload_work *offload;
> > +	struct flow_offload_tuple *tuple;
> > +	struct flow_offload *flow;
> >   	offload = container_of(work, struct flow_offload_work, work);
> >   	switch (offload->cmd) {
> >   		case FLOW_CLS_REPLACE:
> >   			flow_offload_work_add(offload);
> > +			/* Set the TCP connection to established or teardown does not work */
> > +			flow = offload->flow;
> > +			tuple = &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple;
> > +			if (tuple->l4proto == IPPROTO_TCP && !test_bit(IPS_ASSURED_BIT, &flow->ct->status)) {
> > +				spin_lock_bh(&flow->ct->lock);
> > +				flow->ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
> > +				spin_unlock_bh(&flow->ct->lock);
> > +				set_bit(IPS_ASSURED_BIT, &flow->ct->status);
> > +			}
> 
> Hmm, this looks like a workaround.
> Also note that this code is called only when the flowtable
> NF_FLOWTABLE_HW_OFFLOAD bit is set.
> 

Yes, but as explained in my previous email, we need to set the TCP state to
established otherwise we have no chance of fixing up the TCP state in
flow_offload_del or we just do not know what has happened to the TCP state
between the time it was offloaded and it is know beeing processed by nftables
before the flowtable gc runs.



> >   			break;
> >   		case FLOW_CLS_DESTROY:
> >   			flow_offload_work_del(offload);
