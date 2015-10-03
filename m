From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH -next 2/8] netfilter: add and use nf_ct_netns_get/put
Date: Sat, 3 Oct 2015 12:46:26 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1510031244440.16988@nerf40.vanv.qr>
References: <1443786557-21315-1-git-send-email-fw@strlen.de> <1443786557-21315-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, ebiederm@xmission.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:44479 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbbJCKq1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Oct 2015 06:46:27 -0400
In-Reply-To: <1443786557-21315-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2015-10-02 13:49, Florian Westphal wrote:
>diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
>index 6a6e762..01a2322 100644
>--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
>+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
>@@ -415,12 +415,12 @@ static int synproxy_tg4_check(const struct xt_tgchk_param *par)
> 	    e->ip.invflags & XT_INV_PROTO)
> 		return -EINVAL;
> 
>-	return nf_ct_l3proto_try_module_get(par->family);
>+	return nf_ct_netns_get(par->net, NFPROTO_IPV4);
> }
> 
> static void synproxy_tg4_destroy(const struct xt_tgdtor_param *par)
> {
>-	nf_ct_l3proto_module_put(par->family);
>+	nf_ct_netns_put(par->net, NFPROTO_IPV4);
> }
> 
> static struct xt_target synproxy_tg4_reg __read_mostly = {

In the other places (like ip6t_SYNPROXY, xt_CONNSECMARK, ..), you chose
par->family, why hardcode NFPROTO_IPV4 in just this place?
