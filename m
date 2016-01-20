From: Florian Westphal <fw@strlen.de>
Subject: mark set datatype check too strict?
Date: Wed, 20 Jan 2016 17:31:24 +0100
Message-ID: <20160120163124.GB10903@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50426 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934015AbcATQbZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 11:31:25 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.80)
	(envelope-from <fw@strlen.de>)
	id 1aLvfI-0003Vc-48
	for netfilter-devel@vger.kernel.org; Wed, 20 Jan 2016 17:31:24 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Patrick

last your you added check to make this illegal:

nft add rule ip filter input ip daddr 192.168.7.1 meta mark set '(ip saddr & 0xff)'
datatype mismatch: expected packet mark, expression has type IPv4 address

My question is -- why?
The changelog for 068e138a8d9eb doesn't say :)
Doesn't that take away a lot of flexibility?

For instance one could e.g. set conntrack zones based on the VLAN id:

bridge ... prerouting ct zone set vlan id
(yes, I know that zone cannot be set at the moment).

'nft add rule bridge filter prerouting meta mark set vlan id'
should work, in my opinion.  Any ideas/comments?

In case its relevant: I'm working on bridge defrag+conntrack, and one
of the open questions is handling of vlan identifiers
so that we can deal with overlapping addresses in different VLANs.

Since it might be feasible to allow tracking inside other encap
protocols (e.g. pppoe) at one point I would prefer to handle isolation
via conntrack zones since thats already available and not have
to deal with vlan identifiers directly in the kernel.

But if doing operations like 'set zone based on vlan id' is illegal/
considered bad I will have to reconsider...

Thanks!
