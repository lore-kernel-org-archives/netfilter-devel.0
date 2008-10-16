From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix arptable_filter wrong hook registering
Date: Thu, 16 Oct 2008 03:54:58 +0200
Message-ID: <48F69EF2.5000104@netfilter.org>
References: <20081016012451.6126.34071.stgit@Decadence> <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50633 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753500AbYJPBzG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 21:55:06 -0400
In-Reply-To: <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-10-15 21:24, Pablo Neira Ayuso wrote:
> 
>> This patch replaces NFPROTO_ARP by NF_ARP in the hooks registered
>> by arptable_filter, otherwise the arptables tool does not work.
>> Thus, we use NF_ARP to register ARP hooks to match the NF_HOOK
>> invocation in net/ipv4/arp.c and NFPROTO_ARP for internal xtables
>> handling, ie. matches, targets and tables.
> 
> This does not fly. You are essentially trying to register
> arpt_in_hook for NFPROTO_UNSPEC, since NF_ARP == 0, and
> 0 == NFPROTO_UNSPEC.

This flies like a Boeing(R) 777 buddy ;). As the NFPROTO_* thing is only
internal used by xtables, not by the hooks. The hooks use the protocol
family, and we've been using NF_ARP to 0 by now.

> Define "does not work". Do you mean arptables sees no packets?

arptables sees *no packet at all*.

The ARP mangling does not work. Try:

arptables -o eth0 -l 6 -I OUTPUT -j mangle --mangle-mac-s 00:15:58:28:5a:30

and tcpdump the arp request.

> Perhaps the following helps?

Yes, your patch will also work, but it introduces an inconsistency in
the naming used to register hooks in the family field.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
