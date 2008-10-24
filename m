From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: pass netns to ->match or to not pass
Date: Fri, 24 Oct 2008 20:25:17 +0400
Message-ID: <20081024162517.GA10505@x200.localdomain>
References: <20081023231611.GA19245@x200.localdomain> <alpine.LNX.1.10.0810231915500.15705@fbirervta.pbzchgretzou.qr> <20081023233620.GA19634@x200.localdomain> <alpine.LNX.1.10.0810232021220.15705@fbirervta.pbzchgretzou.qr> <20081024094506.GC19634@x200.localdomain> <alpine.LNX.1.10.0810240930500.15705@fbirervta.pbzchgretzou.qr> <20081024140523.GA24706@x200.localdomain> <alpine.LNX.1.10.0810241105040.15468@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:59815 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbYJXQWG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2008 12:22:06 -0400
Received: by ey-out-2122.google.com with SMTP id 6so328395eyi.37
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2008 09:21:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0810241105040.15468@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 24, 2008 at 11:06:25AM -0400, Jan Engelhardt wrote:
> 
> On Friday 2008-10-24 10:10, Alexey Dobriyan wrote:
> >On Fri, Oct 24, 2008 at 09:31:28AM -0400, Jan Engelhardt wrote:
> >> 
> >> >Well, if it would have a pointer like xt_connlimit has, I could take
> >> >netns from ->matchinfo. Here is xt_connlimit patch, btw.
> >> >
> >> >diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
> >> >index 7f404cc..ef01431 100644
> >> >--- a/net/netfilter/xt_connlimit.c
> >> >+++ b/net/netfilter/xt_connlimit.c
> >> >@@ -38,6 +38,7 @@ struct xt_connlimit_conn {
> >> > struct xt_connlimit_data {
> >> > 	struct list_head iphash[256];
> >> > 	spinlock_t lock;
> >> >+	struct net *net;
> >> > };
> >> 
> >> And why should this be better than dev_net(par->in)/dev_net(par_out)?
> >
> >par->in doesn't exist, not sure what do you mean.
> >
> Of course that exists when you get a packet. (If not, then it's par->out
> in case of forwarded/output traffic.)
> 
> static bool
> connlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
> {
> 	...
> }
> 
> struct xt_match_param {
> 	const struct net_device *in, *out;   <- THAT ONE

Ah, these ones!
