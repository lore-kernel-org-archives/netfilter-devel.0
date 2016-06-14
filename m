From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH V2] net: Allow xt_owner in any user namespace
Date: Mon, 13 Jun 2016 17:20:16 -0700
Message-ID: <1465863616.7945.178.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1465850579-23431-1-git-send-email-cernekee@chromium.org>
	 <20160614000223.GC16798@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Kevin Cernekee <cernekee@chromium.org>, pablo@netfilter.org,
	kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org, ebiederm@xmission.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35960 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161263AbcFNAUS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jun 2016 20:20:18 -0400
Received: by mail-pf0-f195.google.com with SMTP id 62so11551927pfd.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jun 2016 17:20:18 -0700 (PDT)
In-Reply-To: <20160614000223.GC16798@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2016-06-14 at 02:02 +0200, Florian Westphal wrote:
> Kevin Cernekee <cernekee@chromium.org> wrote:
> > @@ -35,6 +63,7 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >  	const struct xt_owner_match_info *info = par->matchinfo;
> >  	const struct file *filp;
> >  	struct sock *sk = skb_to_full_sk(skb);
> > +	const struct net *net;
> >  
> >  	if (sk == NULL || sk->sk_socket == NULL)
> >  		return (info->match ^ info->invert) == 0;
> > @@ -50,9 +79,10 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >  		return ((info->match ^ info->invert) &
> >  		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
> >  
> > +	net = sock_net(skb->sk);
> 
> I think you need to use sock_net(sk) as skb_to_full_sk(skb) can return something
> other than skb->sk.

They should share same network namespace ?


