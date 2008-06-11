From: Patrick McHardy <kaber@trash.net>
Subject: Re: [SPAM?] Re: conntrackd causes kernel panic
Date: Wed, 11 Jun 2008 08:17:35 +0200
Message-ID: <484F6DFF.8030700@trash.net>
References: <200806101343.12607.sabelka@iue.tuwien.ac.at> <484E8FC8.4000402@trash.net> <200806101706.52341.sabelka@iue.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Rainer Sabelka <sabelka@iue.tuwien.ac.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62143 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYFKGRh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:17:37 -0400
In-Reply-To: <200806101706.52341.sabelka@iue.tuwien.ac.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rainer Sabelka wrote:
> On Tuesday 10 June 2008 16:29, Patrick McHardy wrote:
>> Do these two patches help?
> 
> Patrick, I tried to apply those patches to the Ubuntu kernel sources 
> (2.6.24-18) but they failed, so I guess I should try to use a vanilla kernel 
> instead.
> Which version should I try?

They apply cleanly to the current 2.6.26-rc and probably
also to 2.6.25.

It should also be simple to fix up manually, with 2.6.24
you only need the first patch, but it doesn't apply because
that kernel is missing the rcu conversion. You can fix
it up manually by moving the nf_ct_ext_destroy() call from
destroy_conntrack() to nf_conntrack_free() in
net/netfilter/nf_conntrack_core.c.
