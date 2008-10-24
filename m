From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: pass netns to ->match or to not pass
Date: Fri, 24 Oct 2008 18:10:07 +0400
Message-ID: <20081024140523.GA24706@x200.localdomain>
References: <20081023231611.GA19245@x200.localdomain> <alpine.LNX.1.10.0810231915500.15705@fbirervta.pbzchgretzou.qr> <20081023233620.GA19634@x200.localdomain> <alpine.LNX.1.10.0810232021220.15705@fbirervta.pbzchgretzou.qr> <20081024094506.GC19634@x200.localdomain> <alpine.LNX.1.10.0810240930500.15705@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:59477 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYJXOGw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:06:52 -0400
Received: by ug-out-1314.google.com with SMTP id k3so183290ugf.37
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2008 07:06:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0810240930500.15705@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 24, 2008 at 09:31:28AM -0400, Jan Engelhardt wrote:
> 
> On Friday 2008-10-24 05:45, Alexey Dobriyan wrote:
> >
> >Well, if it would have a pointer like xt_connlimit has, I could take
> >netns from ->matchinfo. Here is xt_connlimit patch, btw.
> >
> >diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
> >index 7f404cc..ef01431 100644
> >--- a/net/netfilter/xt_connlimit.c
> >+++ b/net/netfilter/xt_connlimit.c
> >@@ -38,6 +38,7 @@ struct xt_connlimit_conn {
> > struct xt_connlimit_data {
> > 	struct list_head iphash[256];
> > 	spinlock_t lock;
> >+	struct net *net;
> > };
> 
> And why should this be better than dev_net(par->in)/dev_net(par_out)?

par->in doesn't exist, not sure what do you mean.
