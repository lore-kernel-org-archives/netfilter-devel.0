From: Florian Westphal <fw@strlen.de>
Subject: Need net-next in nf-next for netfilter ipv6 frag patchset
Date: Sat, 17 Oct 2015 11:00:47 +0200
Message-ID: <20151017090047.GB30789@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58875 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbbJQJAt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Oct 2015 05:00:49 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.80)
	(envelope-from <fw@strlen.de>)
	id 1ZnNM7-0003k4-8O
	for netfilter-devel@vger.kernel.org; Sat, 17 Oct 2015 11:00:47 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo

Please consider pulling net-next into nf-next tree to obtain
commit

ipv6: Pass struct net into nf_ct_frag6_gather

There are bugs in openvswitch ipv6 defragmentation that are better
resolved on netfilter side (also simplifies nf side).

Problem is that these patches don't apply cleanly to net-next.
So I can either send what I have and Dave will need to resolve
the (easy) conflicts, or I can rebase it on nf-next once you
pulled in the net change.

Let me know.

Patch preview for the curious is at
https://git.breakpoint.cc/cgit/fw/nf-next.git/log/?h=ipv6_frag_06
