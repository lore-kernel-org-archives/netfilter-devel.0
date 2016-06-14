From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2] net: Allow xt_owner in any user namespace
Date: Tue, 14 Jun 2016 15:23:18 +0200
Message-ID: <20160614132318.GA13565@salvia>
References: <1465850579-23431-1-git-send-email-cernekee@chromium.org>
 <20160614000223.GC16798@breakpoint.cc>
 <87wplszfpc.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Kevin Cernekee <cernekee@chromium.org>, kaber@trash.net,
	kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57149 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbcFNNX1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 09:23:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 82CDDE8E92
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:23:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 730A39EBB7
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:23:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4A8C09EBBD
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:23:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <87wplszfpc.fsf@x220.int.ebiederm.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 13, 2016 at 09:06:55PM -0500, Eric W. Biederman wrote:
> Florian Westphal <fw@strlen.de> writes:
> 
> > Kevin Cernekee <cernekee@chromium.org> wrote:
> >> @@ -35,6 +63,7 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >>  	const struct xt_owner_match_info *info = par->matchinfo;
> >>  	const struct file *filp;
> >>  	struct sock *sk = skb_to_full_sk(skb);
> >> +	const struct net *net;
> >>  
> >>  	if (sk == NULL || sk->sk_socket == NULL)
> >>  		return (info->match ^ info->invert) == 0;
> >> @@ -50,9 +79,10 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >>  		return ((info->match ^ info->invert) &
> >>  		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
> >>  
> >> +	net = sock_net(skb->sk);
> >
> > I think you need to use sock_net(sk) as skb_to_full_sk(skb) can return something
> > other than skb->sk.
> 
> Actually this should be "par->net".  That did not exist a few years ago
> when the patch was written but it does now, and that should simplify
> things a little bit, and remove any guess work or uncertainty.

Right.

BTW, could you also send a follow up patch to update
net/netfilter/nft_meta.c? We have similar support for socket owner in
nf_tables as well (actually it will be a more simple patch that this,
I would expect).

Thanks.
