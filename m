From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] payload: don't update protocol context if we can't
 find a description
Date: Tue, 7 Jun 2016 00:16:24 +0200
Message-ID: <20160606221624.GA1413@salvia>
References: <1465243278-22625-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49113 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbcFFWQ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 18:16:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BCE40CD6F09
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:16:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B03F39EBA4
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:16:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 63FB89EBA8
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:16:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465243278-22625-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 06, 2016 at 10:01:18PM +0200, Florian Westphal wrote:
> Since commit
> 20b1131c07acd2fc ("payload: fix stacked headers protocol context tracking")
> we deref null pointer if we can't find a description for the desired
> protocol, so "ip protocol 254" crashes while testing protocols 6 or 17
> (tcp, udp) works.
> 
> Also add a test case for this.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1072
> Signed-off-by: Florian Westphal <fw@strlen.de>

Thanks for fixing this!

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
