From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] netfilter: xtables: fix conntrack match v1 ipt-save
 output
Date: Mon, 23 Nov 2009 10:45:44 +0100
Message-ID: <4B0A59C8.6030104@trash.net>
References: <1258529958.2810.36.camel@localhost> <1258851366-1512-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, ben@decadent.org.uk,
	lists@michel-messerschmidt.de
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35877 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbZKWJpk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:45:40 -0500
In-Reply-To: <1258851366-1512-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> commit d6d3f08b0fd998b647a05540cedd11a067b72867
> (netfilter: xtables: conntrack match revision 2) does break the
> v1 conntrack match iptables-save output in a subtle way.
> 
> Problem is as follows:
> 
>     up = kmalloc(sizeof(*up), GFP_KERNEL);
> [..]
>    /*
>     * The strategy here is to minimize the overhead of v1 matching,
>     * by prebuilding a v2 struct and putting the pointer into the
>     * v1 dataspace.
>     */
>     memcpy(up, info, offsetof(typeof(*info), state_mask));
> [..]
>     *(void **)info  = up;
> 
> As the v2 struct pointer is saved in the match data space,
> it clobbers the first structure member (->origsrc_addr).
> 
> Because the _v1 match function grabs this pointer and does not actually
> look at the v1 origsrc, run time functionality does not break.
> But iptables -nvL (or iptables-save) cannot know that v1 origsrc_addr
> has been overloaded in this way:
> 
> $ iptables -p tcp -A OUTPUT -m conntrack --ctorigsrc 10.0.0.1 -j ACCEPT
> $ iptables-save
> -A OUTPUT -p tcp -m conntrack --ctorigsrc 128.173.134.206 -j ACCEPT
> 
> (128.173... is the address to the v2 match structure).
> 
> To fix this, we take advantage of the fact that the v1 and v2 structures
> are identical with exception of the last two structure members (u8 in v1,
> u16 in v2).
> 
> We extract them as early as possible and prevent the v2 matching function
> from looking at those two members directly.
> 
> Previously reported by Michel Messerschmidt via Ben Hutchings, also
> see Debian Bug tracker #556587.

Applied, thanks Florian.
