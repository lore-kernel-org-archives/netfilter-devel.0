From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5 nf-next 0/4] netfilter: nftables: add connlabel set
 support
Date: Mon, 18 Apr 2016 20:39:16 +0200
Message-ID: <20160418183916.GA16253@salvia>
References: <1460477666-17823-1-git-send-email-fw@strlen.de>
 <20160415110020.GA12188@salvia>
 <20160415131414.GM3192@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38883 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbcDRSjU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2016 14:39:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4A258C9ECB
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:39:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 386B19D0E3
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:39:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2AAEFC21AF
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:39:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160415131414.GM3192@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 15, 2016 at 03:14:14PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > First 4 patches are preparation changes, patch #4 adds set support.
> > 
> > Florian, I can push into the tree the 3 preparation patches, I don't
> > see many changes on them. You can follow up with the nft_ct changes
> > later on.
> 
> That would be great, thanks!

Done, thanks!
