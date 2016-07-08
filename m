From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_ct: fix expiration getter
Date: Fri, 8 Jul 2016 14:56:46 +0200
Message-ID: <20160708125646.GA23652@salvia>
References: <1467809586-15950-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42445 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbcGHM4v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jul 2016 08:56:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0739A1B694A
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2016 14:56:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EEB7BA5A9
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2016 14:56:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 03CD126674C
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2016 14:56:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1467809586-15950-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 06, 2016 at 02:53:06PM +0200, Florian Westphal wrote:
> We need to compute timeout.expires - jiffies, not the other way around.
> Add a helper, another patch can then later change more places in
> conntrack code where we currently open-code this.
>
> Will allow us to only change one place later when we remove per-ct timer.

Applied, thanks.
