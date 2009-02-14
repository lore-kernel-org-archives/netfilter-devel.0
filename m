From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netlink callback and socket buffer.
Date: Sat, 14 Feb 2009 18:16:29 +0100
Message-ID: <4996FC6D.6020705@netfilter.org>
References: <885896af0902131235q68b79efbu5c25d29fd9bd1661@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giacomo <delleceste@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40815 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751507AbZBNRQg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Feb 2009 12:16:36 -0500
In-Reply-To: <885896af0902131235q68b79efbu5c25d29fd9bd1661@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Giacomo wrote:
> Good evening to everybody.
> 
> In recent kernels (>=2.6.24) netlink_kernel_create() callback function
> has the following signature:
> 
> 
> (void *) function(struct sk_buff* skb);
> 
> while before it was
> 
> (void  *) function(struct sock *skctrl, int len)
> 
> In the latter, i used to call skb_dequeue, obtain the skb and then,
> once data was extracted, I used
> to kfree_skb(skb); where skb is a sk_buff* obtained by skb_dequeue();
> 
> Now (with the (void *) function(struct sk_buff* skb)  callback) I get
> data from skb but DO NOT HAVE
> TO kfree_skb() it...
> 
> Is it true?  Is it automatically freed by the kernel once the callback returns?

Right, look at netlink_unicast_kernel() in af_netlink.c

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
