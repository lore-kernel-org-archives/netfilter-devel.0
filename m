From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Tue, 24 Nov 2015 11:36:38 +0100
Message-ID: <20151124103638.GA3014@salvia>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151124102245.GD2683@salvia>
 <20151124102841.GD1740@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45490 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbbKXKgo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:36:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2BFEDB6BB3
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:36:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 15D9FDA3FA
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:36:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A0E1CDA3F4
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:36:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151124102841.GD1740@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 11:28:41AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > BTW, do we really want to use the default NFNLGRP_NFTABLES group?
> > 
> > multicast group provide a simple way for filtering out what you don't
> > need from kernelspace. And you can still subscribe both groups
> > NFNLGRP_NFTABLES and NFNLGRP_NFTABLES_TRACE.
> > 
> > I'm telling this when thinking of nft-sync. Why should it be receiving
> > this spamming tracing events when it only cares about ruleset updates?
> 
> I can add a new group but nftables will need to subscribe to both
> in trace mode since we need to see new rules...

I'm talking about applications that may not need to subscribe both,
eg. nft-sync will only need to subscribe to rule updates, he doesn't
care about traces.

I think nft should have the ability to subscribe only rule updates
only as well.

You can subscribe as many groups at the same time in netlink as you want.
