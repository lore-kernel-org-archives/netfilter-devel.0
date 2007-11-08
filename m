From: Philip Craig <philipc@snapgear.com>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in  
   2.6.22.6
Date: Thu, 08 Nov 2007 12:16:42 +1000
Message-ID: <4732718A.8040001@snapgear.com>
References: <W352381485970601194435879@nocme1bl6.telenet-ops.be> <4731A7A9.1050606@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "bdschuym@pandora.be" <bdschuym@telenet.be>,
	ron lai <ronlai@cs.stanford.edu>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:59649 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754441AbXKHCQk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:16:40 -0500
In-Reply-To: <4731A7A9.1050606@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
>  > Another solution I think is this:
>> in br_nf_post_routing():
>> change
>> if (!nf_bridge)
>> to
>> if (!nf_bridge || !(nf_bridge->mask & BRNF_BRIDGED_DNAT))
> 
> Wouldn't that break the regular case of packets forwarded
> through a single bridge?

How about:

if (!nf_bridge || !(nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT))

(I didn't follow the code enough to see if BRNF_BRIDGED_DNAT
implies BRNF_BRIDGED.)

> Yes, though the underlying problem seems to be that skb->nf_bridge
> has no clearly defined lifetime. We want to pass the bridge port
> information up exactly one layer, and then it should disappear.
> But that seems to require sprinkling nf_bridge_put in lots of places.

An alternative to clearing nf_bridge is settings flags in the mask,
whether that is existing flags or a new one.

