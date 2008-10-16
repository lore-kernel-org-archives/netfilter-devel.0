From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: fix arptable_filter wrong hook registering
Date: Wed, 15 Oct 2008 22:03:40 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810152201290.28060@fbirervta.pbzchgretzou.qr>
References: <20081016012451.6126.34071.stgit@Decadence> <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr> <48F69EF2.5000104@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33733 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYJPCDm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 22:03:42 -0400
In-Reply-To: <48F69EF2.5000104@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-10-15 21:54, Pablo Neira Ayuso wrote:

>Jan Engelhardt wrote:
>> On Wednesday 2008-10-15 21:24, Pablo Neira Ayuso wrote:
>> 
>>> This patch replaces NFPROTO_ARP by NF_ARP in the hooks registered
>>> by arptable_filter, otherwise the arptables tool does not work.
>>> Thus, we use NF_ARP to register ARP hooks to match the NF_HOOK
>>> invocation in net/ipv4/arp.c and NFPROTO_ARP for internal xtables
>>> handling, ie. matches, targets and tables.
>> 
>> This does not fly. You are essentially trying to register
>> arpt_in_hook for NFPROTO_UNSPEC, since NF_ARP == 0, and
>> 0 == NFPROTO_UNSPEC.
>
>This flies like a Boeing(R) 777 buddy ;). As the NFPROTO_* thing is only
>internal used by xtables, not by the hooks. The hooks use the protocol
>family, and we've been using NF_ARP to 0 by now.
>
>> Define "does not work". Do you mean arptables sees no packets?
>
>arptables sees *no packet at all*.
>
>The ARP mangling does not work. Try:
>
>arptables -o eth0 -l 6 -I OUTPUT -j mangle --mangle-mac-s 00:15:58:28:5a:30
>
>and tcpdump the arp request.
>
>> Perhaps the following helps?
>
>Yes, your patch will also work, but it introduces an inconsistency in
>the naming used to register hooks in the family field.

No, not really. Netfilter Hooks are supposed to register with
	.pf = NFPROTO_FOO
instead of
	.pf = PF_FOO
because the nf_hooks list itself is indexed by nfproto numbers,
not PF numbers:

struct list_head nf_hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS] __read_mostly; 

(The fact that there's still PF_ in the source is merely historical,
and as you see, PF_foo == NFPROTO_foo for that exact reason.)
