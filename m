From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables 6/6] src: add trace support to nft monitor mode
Date: Tue, 24 Nov 2015 11:53:33 +0100
Message-ID: <20151124105333.GA3212@salvia>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-7-git-send-email-fw@strlen.de>
 <20151124102553.GE2310@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51060 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbbKXKxl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:53:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 36BBFDA86C
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:53:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 18F6ADA804
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:53:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 24DA3DA85F
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:53:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151124102553.GE2310@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 10:25:54AM +0000, Patrick McHardy wrote:
> Tracing might be a long running operation. The cache can go out of sync, might
> be better to do a lookup on demand.

We'll need to handle generations in that approach. The kernel lookup
per trace will be expensive.

Why not just keep the cache in userspace and update it only when
needed? We can easily detect when we get out of sync via ENOBUFS.

> Right now the caching infrastrucure has quite a lot of problems and I'd prefer
> to get them fixed before we base new things on it.

The caching infrastructure only needs to have a mode to be populated
via set information, then infer existing tables from handles as you
indicated.

What other problems you see with it?
