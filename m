From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: mark set datatype check too strict?
Date: Fri, 22 Jan 2016 14:15:08 +0100
Message-ID: <20160122131508.GA3018@salvia>
References: <20160120163124.GB10903@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37495 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbcAVNPS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jan 2016 08:15:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 001CA2EFEA5
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 14:15:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EA1FFDA86F
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 14:15:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 58EE7DA807
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 14:15:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160120163124.GB10903@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Wed, Jan 20, 2016 at 05:31:24PM +0100, Florian Westphal wrote:
> Hello Patrick
> 
> last your you added check to make this illegal:
> 
> nft add rule ip filter input ip daddr 192.168.7.1 meta mark set '(ip saddr & 0xff)'
> datatype mismatch: expected packet mark, expression has type IPv4 address
> 
> My question is -- why?
> The changelog for 068e138a8d9eb doesn't say :)
> Doesn't that take away a lot of flexibility?
> 
> For instance one could e.g. set conntrack zones based on the VLAN id:
> 
> bridge ... prerouting ct zone set vlan id
> (yes, I know that zone cannot be set at the moment).
> 
> 'nft add rule bridge filter prerouting meta mark set vlan id'
> should work, in my opinion.  Any ideas/comments?

Last time we talked about this, Patrick mentioned about adding
explicit casting. We definitely want this flexibility.
