From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Prerouting hook doesn't "see" all packets
Date: Wed, 7 Apr 2010 22:16:39 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004072213170.30103@obet.zrqbmnf.qr>
References: <y2yefcd93941004061610n9f6b0a90lec0209b794d5bc14@mail.gmail.com>  <alpine.LSU.2.01.1004070122000.31132@obet.zrqbmnf.qr> <y2pefcd93941004071302mc5ca51a8s4aa401c5c5fe64df@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: K-Gen <alphakgen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37116 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab0DGUQl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 16:16:41 -0400
In-Reply-To: <y2pefcd93941004071302mc5ca51a8s4aa401c5c5fe64df@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-04-07 22:02, K-Gen wrote:

>Thanks for the response.
>
>Was nfcache "long gone" even in 2.6.8.1? If so, what took it's place?

Dunno about 2.6.8. You're really better off using something that's
maintained.
Nothing took its place AFAICS.

>As for the code, there you go :
>
>This is the hook registration (pardon the Object-Oriented C):

Well the kernel is in C, so using another language is next to gambling.

>RC_t PREROUTING_HOOK_init(PREROUTING_HOOK_t * self)
>{
>  ...
>  ...
>  self->netfilter_ops_prerouting.hook = PREROUTING_HOOK_hook;
>  self->netfilter_ops_prerouting.pf = PF_INET;
>  self->netfilter_ops_prerouting.hooknum = NF_IP_PRE_ROUTING;
>  self->netfilter_ops_prerouting.priority = NF_IP_PRI_LAST;
>  ...
>  ...

It's simpler to just use a
static struct nf_hook_ops myops = {
	.hook = NF_INET_PRE_ROUTING
	.pf = NFPROTO_IPV4, /* not PF_INET */
	.hooknum = ...
	etc.
};

>  nf_retval = nf_register_hook(&(self->netfilter_ops_prerouting));
>  ...
>  ...
>}
>
>This is the hook function:
>
>unsigned int PREROUTING_HOOK_hook(unsigned int hooknum,
>				  struct sk_buff ** skb,
>				  const struct net_device * in,
>				  const struct net_device * out,
>				  int (* okfn)(struct sk_buff *))
>{
>  unsigned int verdict = NF_ACCEPT;
>  unsigned char * tcp_start = NULL;
>
>  if (NULL == (*skb)) {
>    goto done;
>  }
>
>  /* No IP header? */
>  if (NULL == (*skb)->nh.iph) {
>    goto done;
>  }
>
>  if (0x06 != (*skb)->nh.iph->protocol) {
>    goto done;
>  }
>
>  tcp_start = ((unsigned char *)((*skb)->nh.iph)) + ((*skb)->nh.iph->ihl * 4);

The TCP header may be fragmented; you need to use skb_header_pointer.
