From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 10/34] netfilter: ipset: Missing rcu protection in
 mtype_list() fixed
Date: Fri, 8 May 2015 02:03:43 +0200
Message-ID: <20150508000343.GA18705@salvia>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1430587703-3387-11-git-send-email-kadlec@blackhole.kfki.hu>
 <20150507181918.GA3654@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46705 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbbEGX7W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 May 2015 19:59:22 -0400
Content-Disposition: inline
In-Reply-To: <20150507181918.GA3654@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 07, 2015 at 08:19:18PM +0200, Pablo Neira Ayuso wrote:
[...]
> I will come back to review the rcu patches, I still have concerns
> there.
> 
> If you're OK, I'll take as much as I can that is independent your RCU
> changes, so you don't need to resend this large patchset, but you will
> need to rebase though.

Unless you have any concern, I'm going to start by applying this batch
of 15 patches:

netfilter: ipset: Use better include files in xt_set.c
netfilter: ipset: Improve preprocessor macros checks
netfilter: ipset: Fix hashing for ipv6 sets
netfilter: ipset: Fix ext_*() macros
netfilter: ipset: Check for comment netlink attribute length
netfilter: ipset: Return bool values instead of int
netfilter: ipset: Use HOST_MASK literal to represent host address CIDR len
netfilter: ipset: Check IPSET_ATTR_PORT only once
netfilter: ipset: Return ipset error instead of bool
netfilter: ipset: Preprocessor directices cleanup
netfilter: ipset: No need to make nomatch bitfield
netfilter: ipset: Properly calculate extensions offsets and total length
netfilter: ipset: make ip_set_get_ip*_port to use skb_network_offset
netfilter: ipset: Give a better name to a macro in ip_set_core.c
netfilter: ipset: Fix sparse warning

It would be good if other small patches come in first place if
possible. Otherwise, I'd suggest you focus on a next batch with the
rcu conversion, that will be already quite large.

Thanks Jozsef.
