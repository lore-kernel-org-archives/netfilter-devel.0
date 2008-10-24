From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: pass netns to ->match or to not pass
Date: Fri, 24 Oct 2008 09:31:28 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810240930500.15705@fbirervta.pbzchgretzou.qr>
References: <20081023231611.GA19245@x200.localdomain> <alpine.LNX.1.10.0810231915500.15705@fbirervta.pbzchgretzou.qr> <20081023233620.GA19634@x200.localdomain> <alpine.LNX.1.10.0810232021220.15705@fbirervta.pbzchgretzou.qr>
 <20081024094506.GC19634@x200.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36531 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYJXNba (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:31:30 -0400
In-Reply-To: <20081024094506.GC19634@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-10-24 05:45, Alexey Dobriyan wrote:
>
>Well, if it would have a pointer like xt_connlimit has, I could take
>netns from ->matchinfo. Here is xt_connlimit patch, btw.
>
>diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
>index 7f404cc..ef01431 100644
>--- a/net/netfilter/xt_connlimit.c
>+++ b/net/netfilter/xt_connlimit.c
>@@ -38,6 +38,7 @@ struct xt_connlimit_conn {
> struct xt_connlimit_data {
> 	struct list_head iphash[256];
> 	spinlock_t lock;
>+	struct net *net;
> };

And why should this be better than dev_net(par->in)/dev_net(par_out)?

