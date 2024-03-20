Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2132.outbound.protection.outlook.com [40.107.241.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B6711181
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 09:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710926441; cv=fail; b=CM5KGP/0AsqWltZBN8By7Mxa3NL7xaXplBOSflY+iTFlSJ9kWwX77jAQGX0lTHuY5GO5kxy2LJ1q1CtQ703kx/zU8NUhlJF9Cz1PqGvC0x3GYgU4ZshEf9Or1lQg8q2oDvt0svgvhR3A2nKZr3srQ2tzgTX1YwhOwhBHog5r3Aw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710926441; c=relaxed/simple;
	bh=Wzb3p5HMcdDoir4UWWZBQ5+GflTH+JRaf0axH+BK8Mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UXbjkPDpKXMU0Nhfcv98QFxKvDkAxXOAnCgY20j+NmzSM6pXISd7QQJIJQKFSG2wxQERmqczEJ5bQ5M4a8TGtp6ZSHeQppc9XpISOQsQPa0kU9zd8rMVF1TCp7AbBV/rlRjz20xBZSHmgtVTYxG0ALRaPUbThxP/uokHnFFi8Uk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=CiyKKeIM; arc=fail smtp.client-ip=40.107.241.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="CiyKKeIM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3+EwFgSC9xw1ABvqbYIcTojt+jNWYVeAhwXsbjzdS+eDpeO4HqJalNilj1iSU3BpjD15rQQoGHaB/THGcFKpO2TgGBAS16Ra/fR4uCDhv1MlCgUAYzA2NBMPsqsbUTLO1NpcGy/xt0Sx+9t2wsuWiQPbH/Ek0WtV2Qxcn20LpxYXSnCMVpZ66dujACBXsydDjoqgD/hgO8aGCKEqraGKro9jFtvnsJ4zzusOMT9ChBHZH2J6aEj29/5AARzOkHB550FQpl8CEgsgPMlDqYpwUIPUyV/9Wih/3PaFFzACMLo7WgAI+KPNiuG3gp9okWTWOnJFeFt7I7hIi2hUMm94A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8MPnko+LPvw9PA9xJE68QIw9Bf7Ky9HC0De6cAXeN4=;
 b=U+fdTu4kxqBucR89QKpm43yIEhbLDcjcMFnF9uHHURpmchbm1+IWpzcmyLxdVAaf0tAsgiwAi/iq1Y2il8EqlOg6YsUV2T81Amy9jiDN57elIMMzBp70YAXbkAA7mCgvIYcclOcz/CGH9yxRQyQp5lufmUfhyWL2KXwfoM3v4Lx7a19XahhRBRiPuvr0+EC9WpeGsE8bHgZsVc5usnTvFSfpBZ3x5h9siwOxzUpIwVojL/eByqzsvN9iyUvIJCt0WqR5vlvZPO6kgcIabtWN3YySYoHxFAymge1gO+Xl/O/qT2rX03qZlmkbqz5W6uyqNkbck/YNx0A+5M9KyRunIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8MPnko+LPvw9PA9xJE68QIw9Bf7Ky9HC0De6cAXeN4=;
 b=CiyKKeIMjekSKluBuQWnALarF+FccRZU294Qo5Qe51pzvxzpNVxezgqkAIPVtECGQU4Y6/NkNHWivfo4i+FDUA4mGIQd5h9lRARozLii4TrkW+a4QcggebgjCmrCjk2lZx5TeV3Ma2RzETdPpQWtNq5HknppPY8s+OtsMGyz0vI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by PAXPR05MB8955.eurprd05.prod.outlook.com
 (2603:10a6:102:2b7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 09:20:35 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Wed, 20 Mar 2024
 09:20:35 +0000
Date: Wed, 20 Mar 2024 10:20:29 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com, 
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>
References: <20240318093915.10358-1-pablo@netfilter.org>
 <zxdruu67c2xs6zrhagjilitxu5ysik5x7zvk3kthzcclype22c@nevv7c7adz7z>
 <ZfqiHPpUfFwHI5-h@calendula>
 <lajzqkqbqptfa6m6ntyseutpmbnrrc4yb26x6lwjaxm3aldzvc@u33db2j37rtb>
 <ZfqnTJKyW1VSIOgY@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfqnTJKyW1VSIOgY@calendula>
X-ClientProxiedBy: FR0P281CA0149.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::16) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|PAXPR05MB8955:EE_
X-MS-Office365-Filtering-Correlation-Id: 883bdabc-c20d-4d1c-33ed-08dc48beff9c
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TigllKDTFVdexaea7qhKMMwvmorZXP5bEwdPyQLtA83BUZUeXliCl8UjzMgsvwnScwXFNogxEdHpzL+phQxCq8bJ6ieMQHMgp5iL8ikXUxF9NWdXc7FJJc/Fzxcidhap7Wmc/ySp8jJsC5lIH+ybghrQyCOtoTNJ8jh1aDOaKqU+5dCBOTJoIVlrO9rezMgjDnfb12J+Z8/iRFdAzAVlfziSD28vvG+1C5413vaWWOQOOKK93hAqvEXrNUPR6HnG2BzLT+gfk/5OKexwaJKFWn9E6aqf/bnzB6VGEpurp0aDsNScFHPhQ8pjRT3Ki/0u1Re+lb+qOKNqYQcWxP+vQ4CmIJDtIpp4kWwYmOn7XwEKNFTmxODohTYw6ZIVm9cYZ2x5XldpA1rkIHcFt44zcG4u8gePDagmRdqpP38drYx0vLh04JmJMDwb7MGjyafMWGescsYhF8jPmKFyHmEMMM+tpb0KSBDjvJVYeW6J6m2XG3ThMv34mNDxLFE03xcjpx01SPSDf0GnSm2O2eQBv55dFJ8LKQ5z2e6lan1xiXenBx+F1ll5Z9DwpowtiMSsYty78BwwFWIovK+qvcR9WyKN6s+LLmpP9afVUNMkH1/XtydprGOlH/w+VchY8hqwmGsXREmT0IJsXtJIIRLmTfKbLlkgFzzWE8iPeNTcEw8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iVwEXf5r6pJjmIdQlYwOqTkl7kjodl0/3Gf/pxWS2QP8SaUIVm59DOIaxduY?=
 =?us-ascii?Q?U6tI528qjh4hKuR0JZJrVHUvL9ZT7EyLkHCH1eeVgU+l6/URT7baWFgaAbIl?=
 =?us-ascii?Q?SqmihTS9jrDWTzS9D7R4HeqZZhNRwdUFm+2pp2NjyextWHCkdB3AgUov4OvC?=
 =?us-ascii?Q?Z8EjOErQV5un/1nuZXONNrlWtRXWvX3MDRna9cqHX8cSuSbqH/EXqeXPDAV3?=
 =?us-ascii?Q?b+4rnWc/tyWlPykL1/gWp5FUDTLxvMa20Fwz606YuABONIGRccZNUNthNCy8?=
 =?us-ascii?Q?HV5N/iubwlruLf2xVaWF6zqVpfRJo5LUOscJrCaOvM7e6nORzZ4LaLKkMTEt?=
 =?us-ascii?Q?Dw8lyAMaYK3y+8gYCToKiRijOMKswFaYSmIpq0lBhhQ65NVE1qqVfbTObdkf?=
 =?us-ascii?Q?Lid6KaX5XoOMVxYt8dtuP/Hy0AlRjBTgV0tp9LLmPwv1UPVg/0b56oNze8X3?=
 =?us-ascii?Q?ect8lEYcoVW8S+/2YBbV6GWEgkVJA9FG98f6vHnwNmKc5OBih1JAM5HSd0xm?=
 =?us-ascii?Q?HkWCqgrG6T2Rj40vd62+9NrJ1XmndhmCWaE0GAdXPb6QyHUZPUm1YsP4gn3V?=
 =?us-ascii?Q?iDai2uqpeR19UZbTTOYuveVYJkxamyJBoMnp9HLQJLfW11Gub1aL3eRypI1g?=
 =?us-ascii?Q?3JHxaJhmxA8MJa0JP3pkGQxL7f0XdByPfVd0GfHhnTxsdnmRz8M2tIge2hMK?=
 =?us-ascii?Q?4gHevcY8jStTiauuzQlIZFyC2Aekz4BqULFOEz4XWLg6ZB8Qw1OimLeh7Obb?=
 =?us-ascii?Q?uJuV3uI0CeFuFnPWVLtBxn+s6ULQzd/NHGjjQhXEpfWt7b44kHu2CRXb0Gju?=
 =?us-ascii?Q?RIQLpsz84wLDxCot4ZzkMHCB6F+CsnGu7o4HlaN0BQh1EWBEr1r2yeSiy47H?=
 =?us-ascii?Q?PF6fm7mvnpwQcgpW5fnHrISbk/G+v5+ltKGgFbi5JBLFWFfhLwqLJDVrHovV?=
 =?us-ascii?Q?PLZP+NAOrUHcECgMlzYomijXuubyHG1+L6cnjFjc3NwPxZYC6dpFgyQ+Q96b?=
 =?us-ascii?Q?uCxmnYizHtDKeq8sml4hiQm44sri3GSWfql7et5I/7aHJqCivO8QlqB1GkZo?=
 =?us-ascii?Q?b87xp/OimszZ4eR78bQ7yQfsPSkmvJ/eiJ0ipLdrzzXndOw8VPDzOeW7Calt?=
 =?us-ascii?Q?TuGyDG0Wx644SLh2+OuHPPy692KiVlrjrTgfXF0bxuSlQqjhAp+JWmWwsl6G?=
 =?us-ascii?Q?2ESf7/oTQofRUTwMK5pqZ7reUgUXsza+zKZGQFBRykRCRjxVooT4SWG3yh8I?=
 =?us-ascii?Q?oPU5l8BryfD5mMYW5ymhxP6BqiOozWVSkO+/88VRQQ8vNfNReEd9r+73Gn4a?=
 =?us-ascii?Q?Unq/fmELSsCmnB36TEQxWCtyPdrRTLuCOS/qqtYSnykquxAuXT4xFal/e/eg?=
 =?us-ascii?Q?vJvdFYYs1Efg0BwFiMWweeeJTAAczhYuJynRc1ZNgYAoPJkcebUR3jRwizhL?=
 =?us-ascii?Q?7XQVeoWAIhQ/V++XTQ+DTP1fbFGdicFCoyj3dW199yHC2ARj0M5dVvlMpRyN?=
 =?us-ascii?Q?uVvoY1Z/OiWZ3CLEIO7OCn9AJ2wn5IG9ytI4CxzSEovq0gmsihWa44tbAp0P?=
 =?us-ascii?Q?9OlQYfJWkrTToZJw70vj5jrEWAXEvS5hNFu1vURs6AQ+k7Oe4TIqo9Kfdbf3?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 883bdabc-c20d-4d1c-33ed-08dc48beff9c
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 09:20:35.0482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LcqF2Cl9KNKd8LZGbW6PbXbxqnxTEXar6d2bvZOZWT2WTCDdl1iP//O0PuXlj6l+evQ4jEdKTZ1xjUvk0WdDADaOS4MfZfpLnmxxWXMGAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB8955

On Wed, Mar 20, 2024 at 10:07:24AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 20, 2024 at 09:49:49AM +0100, Sven Auhagen wrote:
> > On Wed, Mar 20, 2024 at 09:45:16AM +0100, Pablo Neira Ayuso wrote:
> > > Hi Sven,
> > > 
> > > On Wed, Mar 20, 2024 at 09:39:16AM +0100, Sven Auhagen wrote:
> > > > On Mon, Mar 18, 2024 at 10:39:15AM +0100, Pablo Neira Ayuso wrote:
> > > [...]
> > > > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > > > index a0571339239c..481fe3d96bbc 100644
> > > > > --- a/net/netfilter/nf_flow_table_core.c
> > > > > +++ b/net/netfilter/nf_flow_table_core.c
> > > > > @@ -165,10 +165,22 @@ void flow_offload_route_init(struct flow_offload *flow,
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(flow_offload_route_init);
> > > > >  
> > > > > -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> > > > > +static s32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
> > > > > +				  enum tcp_conntrack tcp_state)
> > > > >  {
> > > > > -	tcp->seen[0].td_maxwin = 0;
> > > > > -	tcp->seen[1].td_maxwin = 0;
> > > > > +	struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > > > > +
> > > > > +	ct->proto.tcp.state = tcp_state;
> > > > > +	ct->proto.tcp.seen[0].td_maxwin = 0;
> > > > > +	ct->proto.tcp.seen[1].td_maxwin = 0;
> > > > > +
> > > > > +	/* Similar to mid-connection pickup with loose=1.
> > > > > +	 * Avoid large ESTABLISHED timeout.
> > > > > +	 */
> > > > > +	if (tcp_state == TCP_CONNTRACK_ESTABLISHED)
> > > > > +		return tn->timeouts[TCP_CONNTRACK_UNACK];
> > > > 
> > > > Hi Pablo,
> > > > 
> > > > I tested the patch but the part that sets the timout to UNACK is not
> > > > very practical.
> > > > For example my long running SSH connections get killed off by the firewall
> > > > regularly now while beeing ESTABLISHED:
> > > > 
> > > > [NEW] tcp      6 120 SYN_SENT src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 [UNREPLIED] src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > [UPDATE] tcp      6 60 SYN_RECV src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 [OFFLOAD] mark=16777216
> > > > 
> > > > [DESTROY] tcp      6 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=54941 dport=22 packets=133 bytes=13033 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=54941 packets=95 bytes=15004 [ASSURED] mark=16777216 delta-time=1036
> > > > 
> > > > I would remove the if case here.
> > > 
> > > OK, I remove it and post a v2. Thanks!
> > 
> > Thanks and also the hardcoded TCP_CONNTRACK_ESTABLISHED in flow_offload_fixup_ct
> > should be reverted to the real tcp state ct->proto.tcp.state.
> 
> ct->proto.tcp.state contains the state that was observed before
> handling over this flow to the flowtable, in most cases, this should
> be TCP_CONNTRACK_ESTABLISHED.
> 
> > This way we always set the current TCP timeout.
> 
> I can keep it to ct->proto.tcp.state but I wonder if it is better to
> use a well known state such as TCP_CONNTRACK_ESTABLISHED to pick up from.

In case of a race condition or if something is off like my TCP_FIN
that is beeing offloaded again setting to to ESTABLISHED hard coded
will make the e.g. FIN or CLOSE a very long state.
It is not guaranteed that we are still in ESTABLISHED when this code
runs. Also for example we could have seen both FIN already before the
flowtable gc runs.
> 
> > I am doing more tests with that now.
> 
> Thanks!
