From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: remove per-netns conntrack
 tables, part 3
Date: Mon, 9 May 2016 16:45:00 +0200
Message-ID: <20160509144500.GA3059@salvia>
References: <1462803872-13497-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48621 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbcEIOpN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2016 10:45:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E9DD44BCC4
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 16:45:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DAB3313470F
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 16:45:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7ED8C134711
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 16:45:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1462803872-13497-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 09, 2016 at 04:24:29PM +0200, Florian Westphal wrote:
> This series removes the per-namespace duplication of the NAT bysource table.
[...]
> I have another patch queued to convert nat bysource table to an rhashtable.
> However; it seems better to wait until the next merge window so that bug
> reports can be more easily pointed to the de-duplication work or a rhashtable
> conversion, I will therefore hold this back for now.

Agreed, thanks Florian.

Series applied.

Will be sending a batch with pending nf-next updates today, including
these three patches.
