From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink_delinearize: only remove protocol if equal
 cmp is used
Date: Wed, 27 Jan 2016 16:45:49 +0100
Message-ID: <20160127154549.GA1330@salvia>
References: <1453902155-3077-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41907 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbcA0PqG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Jan 2016 10:46:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4BCED6C1D
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2016 16:46:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3D35DDA809
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2016 16:46:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4DF19DA808
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2016 16:45:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453902155-3077-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 27, 2016 at 02:42:35PM +0100, Florian Westphal wrote:
> Check for OP_EQ before removing a dependency, else we may zap wrong one,
> changing the meaning of the rule.
> 
> Listing without patch:
> ip protocol udp udp dport ssh
> ip protocol udp udp dport ssh
> counter packets 1 bytes 308 ip protocol udp udp dport ssh
> 
> With patch:
> ip protocol != tcp udp dport ssh
> ip protocol != udp udp dport ssh
> ip protocol != tcp counter packets 1 bytes 308 udp dport ssh

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  NB: ip protocol != udp udp dport ... is nonsensical, not sure
>  if its worth the hassle to try to reject stuff like this.

I agree this is not worth. We'll have more advanced tools to perform
transformations and more in-depth semantic evaluation of the ruleset
at some point, but not now ;-)
