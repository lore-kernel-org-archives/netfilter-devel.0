From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2] net: Allow xt_owner in any user namespace
Date: Tue, 14 Jun 2016 02:02:23 +0200
Message-ID: <20160614000223.GC16798@breakpoint.cc>
References: <1465850579-23431-1-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org, ebiederm@xmission.com
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41964 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030193AbcFNACd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jun 2016 20:02:33 -0400
Content-Disposition: inline
In-Reply-To: <1465850579-23431-1-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kevin Cernekee <cernekee@chromium.org> wrote:
> @@ -35,6 +63,7 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	const struct xt_owner_match_info *info = par->matchinfo;
>  	const struct file *filp;
>  	struct sock *sk = skb_to_full_sk(skb);
> +	const struct net *net;
>  
>  	if (sk == NULL || sk->sk_socket == NULL)
>  		return (info->match ^ info->invert) == 0;
> @@ -50,9 +79,10 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  		return ((info->match ^ info->invert) &
>  		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
>  
> +	net = sock_net(skb->sk);

I think you need to use sock_net(sk) as skb_to_full_sk(skb) can return something
other than skb->sk.

