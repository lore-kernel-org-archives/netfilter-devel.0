From: K-Gen <alphakgen@gmail.com>
Subject: Re: Prerouting hook doesn't "see" all packets
Date: Wed, 7 Apr 2010 22:02:12 +0200
Message-ID: <y2pefcd93941004071302mc5ca51a8s4aa401c5c5fe64df@mail.gmail.com>
References: <y2yefcd93941004061610n9f6b0a90lec0209b794d5bc14@mail.gmail.com>
	 <alpine.LSU.2.01.1004070122000.31132@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40614 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab0DGUJl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 16:09:41 -0400
Received: by gyg13 with SMTP id 13so721562gyg.19
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Apr 2010 13:09:40 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1004070122000.31132@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for the response.

Was nfcache "long gone" even in 2.6.8.1? If so, what took it's place?

As for the code, there you go :

This is the hook registration (pardon the Object-Oriented C):

RC_t PREROUTING_HOOK_init(PREROUTING_HOOK_t * self)
{
  ...
  ...
  self->netfilter_ops_prerouting.hook = PREROUTING_HOOK_hook;
  self->netfilter_ops_prerouting.pf = PF_INET;
  self->netfilter_ops_prerouting.hooknum = NF_IP_PRE_ROUTING;
  self->netfilter_ops_prerouting.priority = NF_IP_PRI_LAST;
  ...
  ...
  nf_retval = nf_register_hook(&(self->netfilter_ops_prerouting));
  ...
  ...
}

This is the hook function:

unsigned int PREROUTING_HOOK_hook(unsigned int hooknum,
				  struct sk_buff ** skb,
				  const struct net_device * in,
				  const struct net_device * out,
				  int (* okfn)(struct sk_buff *))
{
  unsigned int verdict = NF_ACCEPT;
  unsigned char * tcp_start = NULL;

  if (NULL == (*skb)) {
    goto done;
  }

  /* No IP header? */
  if (NULL == (*skb)->nh.iph) {
    goto done;
  }

  if (0x06 != (*skb)->nh.iph->protocol) {
    goto done;
  }

  tcp_start = ((unsigned char *)((*skb)->nh.iph)) + ((*skb)->nh.iph->ihl * 4);

  (*skb)->nfcache |= NFC_UNKNOWN;

  printk(KERN_INFO "Pkt: %08X -> %08X proto: %d len: %d\n",
	 (*skb)->nh.iph->saddr,
	 (*skb)->nh.iph->daddr,
	 (*skb)->nh.iph->protocol,
	 (*skb)->nh.iph->tot_len);

  printk(KERN_INFO "   Tcp: %d -> %d. Traffic: %ld\n",
	 *((unsigned short *)tcp_start),
	 *((unsigned short *)tcp_start+1),
	 traffic);

 done:
  return verdict;
}

I cut out some irrelevant code, as you can see. Most of the hook
function is intact.

What I'm trying to do here, is to print some data about the TCP
packets that pass through the hook.
As I've said, I don't see all the packets. The only ones printed out
are stuff like TCP handshake packets, and maybe some others (but very
far from all of them).

The code is pretty straight forward. The line "  (*skb)->nfcache |=
NFC_UNKNOWN;" doesn't really do anything for me. I've tried this with
or without it.

Can you see what the problem may be? Should I try this under a newer
kernel version, in a VM, perhaps?

On Wed, Apr 7, 2010 at 1:28 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Wednesday 2010-04-07 01:10, K-Gen wrote:
>
>>Hi there.
>>I'm trying to see TCP packets passing through a router using a
>>netfilter module (in order to eventually alter them).
>>
>>I have a hook on PREROUTING, and it doesn't quite work as expected.
>>The only packets I see, are the TCP handshake (3 packets). Any packets
>>in an established connection do not get to my hook.
>>The TCP connections in question all pass via NAT before reaching my
>>hook. I've thus given my hook the priority NF_IP_PRI_LAST.
>>I've tried setting nfcache to NFC_UNKNOWN for every TCP packet, and
>>this didn't help.
>>
>>The kernel version on the router is 2.6.8.1, the router itself is
>>based on a BCM board. I did not try to the same on another machine.
>
> The stable series did not exist before 2.6.11, so 2.6.8.1 did not
> exist. Assuming you meant 2.6.8, I'd say it's time to update.
>
> nfcache is long gone.
>
>>I'm obviously doing something wrong, so please tell my why is this happening.
>
> You need to post your code, because we don't have magic orbs (let alone
> that, if such existed, the law would probably prohibit their use for
> obvious reasons of unwanted privacy invasion).
>
