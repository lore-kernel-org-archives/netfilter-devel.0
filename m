From: Diadon <diadon@isfera.ru>
Subject: Re: [PATCH 2.4] fix ipt_REJECT when used in OUTPUT
Date: Mon, 22 Sep 2003 12:16:50 +0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F6EAFF2.9080303@isfera.ru>
References: <20030921144013.GA22223@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@redhat.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030921144013.GA22223@sunbeam.de.gnumonks.org>
List-Id: netfilter-devel.vger.kernel.org

That patch is not work, after patching the kernel problem is not 
disappeared!

Patch by Patrick is working fine and fix this problem


Harald Welte wrote:

>Hi Dave!
>
>Some people use REJECT in the OUTPUT chain (rejecting locally generated
>packets).  This didn't work anymore starting with some fixes we did in 2.4.22. 
>A dst_entry for a local source doesn't contain pmtu information - and
>thus the newly-created packet would instantly be dropped again.
>
>I'll send you a 2.6.x merge for this later.
>
>Please apply the following fix, thanks
>
>  
>
>------------------------------------------------------------------------
>
>diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.4.22/net/ipv4/netfilter/ipt_REJECT.c linux-2.4.22-rejectfix/net/ipv4/netfilter/ipt_REJECT.c
>--- linux-2.4.22/net/ipv4/netfilter/ipt_REJECT.c	2003-08-25 13:44:44.000000000 +0200
>+++ linux-2.4.22-rejectfix/net/ipv4/netfilter/ipt_REJECT.c	2003-09-21 16:39:25.000000000 +0200
>@@ -186,8 +186,8 @@
> 	nskb->nh.iph->check = ip_fast_csum((unsigned char *)nskb->nh.iph, 
> 					   nskb->nh.iph->ihl);
> 
>-	/* "Never happens" */
>-	if (nskb->len > nskb->dst->pmtu)
>+	/* dst->pmtu can be zero because it is not set for local dst's */
>+	if (nskb->dst->pmtu && nskb->len > nskb->dst->pmtu)
> 		goto free_nskb;
> 
> 	connection_attach(nskb, oldskb->nfct);
>  
>
>------------------------------------------------------------------------
>
>Scanned by evaliation version of Dr.Web antivirus Daemon 
>http://drweb.ru/unix/
>
>  
>
