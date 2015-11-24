From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Tue, 24 Nov 2015 11:44:04 +0100
Message-ID: <20151124104404.GA3149@salvia>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151124102245.GD2683@salvia>
 <20151124102841.GD1740@breakpoint.cc>
 <20151124103348.GG2310@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48047 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbbKXKoI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:44:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9A2E1DA862
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:44:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8B3DBDA7FF
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:44:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A2FEDDA7FF
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:44:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151124103348.GG2310@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 10:33:49AM +0000, Patrick McHardy wrote:
> BTW and completely unrelated to the netlink group: I think it would be
> nicer to have a "trace" keyword instead of "nftrace set 1" in the nft
> frontend.

I like the idea of having this "trace" statement.
