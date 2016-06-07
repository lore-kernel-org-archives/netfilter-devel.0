From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: helper: avoid extra expectation
 iterations on unregister
Date: Tue, 7 Jun 2016 17:28:49 +0200
Message-ID: <20160607152849.GA23880@salvia>
References: <1463334614-10189-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59741 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbcFGP2y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2016 11:28:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 33E48921777
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:28:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 24F8A9EBA1
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:28:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 21D189EBA1
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:28:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1463334614-10189-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 15, 2016 at 07:50:14PM +0200, Florian Westphal wrote:
> The expectation table is not duplicated per net namespace anymore, so we can move
> the expectation table and conntrack table iteration out of the per-net loop.

Florian, I can place this in the nf-next tree. This hit the queue in a
very late stage of the previous merge window so basically it was hard
to pass it on to David without pushing a bit.

Or let me know if you prefer to resubmit, thanks.
