From: Vasily Averin <vvs@parallels.com>
Subject: Re: [PATCH] bridge: Superfluous skb->nfct check in br_nf_dev_queue_xmit
Date: Sun, 04 May 2014 23:04:29 +0400
Message-ID: <53668F3D.7080202@parallels.com>
References: <20140428131646.GP31953@breakpoint.cc> <5360BA5A.7020200@parallels.com> <20140504125427.GA4344@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Saikiran Madugula <hummerbliss@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:24694 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbaEDTGP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 May 2014 15:06:15 -0400
In-Reply-To: <20140504125427.GA4344@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/04/2014 04:54 PM, Pablo Neira Ayuso wrote:
> On Wed, Apr 30, 2014 at 12:54:50PM +0400, Vasily Averin wrote:
>> Currently bridge can silently drop ipv4 fragments.
>> If node have loaded nf_defrag_ipv4 module but have no nf_conntrack_ipv4,
>> br_nf_pre_routing defragments incoming ipv4 fragments
>> but nfct check in br_nf_dev_queue_xmit does not allow re-fragment combined packet back,
>> and therefore it is dropped in br_dev_queue_push_xmit without incrementing of any failcounters
> 
> If no further objections, I'll push this original patch appending this comment
> to the description:
> 
> [ It seems the only way to hit the ip_fragment code in the bridge xmit
>   path is to have a fragment list whose reassembled fragments go over
>   the mtu. This only happens if nf_defrag is enabled. Thanks to
>   Florian Westphal for providing feedback to clarify this. ]

I have not objections, however I still do not understand why #if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV4) 
is required in br_dev_queue_push_xmit()?

If ipv4 defragmentation is required not only for conntracks but for TPROXY target and xt_socket match
I think we need to use NF_DEFRAG_IPV4 instead.
