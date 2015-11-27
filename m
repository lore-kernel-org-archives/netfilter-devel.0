From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 0/3] src: trace infrastructure support
Date: Fri, 27 Nov 2015 01:33:54 +0000
Message-ID: <20151127013353.GB4263@macbook.localdomain>
References: <1448560779-28989-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41255 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbbK0BeB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 20:34:01 -0500
Content-Disposition: inline
In-Reply-To: <1448560779-28989-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Florian Westphal wrote:
> This is V2 of the nft trace patch set.
> 
> See the individual patches for a change vs. v1 description.
> 
> Patrick: I did a quick test w. your last public patches
> (plus a few minor changes to make it build again) and things
> seem to work fine.
> 
> What does not work correctly is decoding of vlan header.
> I think whats happening is that we cannot splice sub-byte
> sized quantities from a larger chunk.

I've managed to decode it properly, so the kernel part is fine:

ether saddr 63:f6:4b:00:54:52 ether daddr c9:4b:a9:00:54:52 vlan pcp 0 vlan cfi 0 vlan id 1000 vlan type ip ip saddr 10.0.0.1 ip daddr 10.0.0.2 ip tos 0 ip ttl 64 ip id 61847 ip length 84 icmp type echo-request icmp code 0 icmp id 29049 icmp sequence 4267 icmp type 61 icmp code 177 icmp id 0 icmp sequence 0 icmp type 116 icmp code 211

There are a number of problems however. The easy one is wrong header
definitions in nft, also my decoding is a bit hackish so far and occasionally
causes endless loops, I'll fix that.

The somewhat bigger problem are some inconsistencies. Usually we can see
the original lower layer header on the receive path in the higher layers,
f.i. the ethernet header. With VLAN offloading this doesn't work since we
loose the meta data once the packet has been received through the VLAN code.
This means we'll just see a regular ethernet header.

This does not only affect tracing, but anything that wants to access that
header. Its not a *huge* problem, but it is unexpected for the user,
especially since he is able to treat the offloaded header like a regular
VLAN header before "decapsulation".

I have no good suggestion what to do about that. The information in the skb
is gone. The only possibility I can think of is to reconstruct (most of) it
based on the incoming device, the known upper protocol and skb->priority,
but that's quite ugly.
