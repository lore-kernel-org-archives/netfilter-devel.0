From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next 0/9] netfilter: don't copy initns hooks to new
 namespaces
Date: Tue, 24 Nov 2015 11:27:46 +0100
Message-ID: <20151124102746.GA2917@salvia>
References: <1445597006-11264-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40335 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbbKXK1u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:27:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2768BB6B97
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:27:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 192D6DA81D
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:27:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3E77CDA861
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:27:47 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1445597006-11264-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 23, 2015 at 12:43:17PM +0200, Florian Westphal wrote:
> Ads section:
> conntrack+filter + nat table used in init namespace, single TCP_STREAM lo netperf:
> 87380  16384  16384    30.00    14348.66
> with patch set, netperf running in net namespace without rules:
> 87380  16384  16384    30.00    15683.97
> 
> routing from ns3 -> ns2, filter + nat table & conntrack in all namespaces:
> 87380  16384  16384    30.00    5664.46
> without conntrack+any tables in those namespaces:
> 87380  16384  16384    30.00    7336.54

Florian, I didn't have time so far on this but I really expect that
you follow up on this with a new version adressing or summarizing
possible solutions for the corner cases that we have discussed
previously.

We definitely need this for better netns support in iptables.

Thanks.
