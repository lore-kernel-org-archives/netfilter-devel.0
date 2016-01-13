From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/6] add support for conntrack counters
Date: Wed, 13 Jan 2016 13:50:28 +0100
Message-ID: <20160113125028.GA19206@salvia>
References: <1452246171-13943-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33049 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbcAMMug (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 07:50:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E836DA7E1E
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 13:50:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D3412DA811
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 13:50:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 69753DA85D
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 13:50:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1452246171-13943-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 08, 2016 at 10:42:45AM +0100, Florian Westphal wrote:
> Adds support for tests like
> 
> ct original packets > 10
> ct reply packets > 10
> ct packets > 10
> 
> The latter returns the counter for both original and reply (i.e. sum).
> 
> Needs the two kernel patches:
> nftables: ct: add byte/packet counter support
> nftables: byteorder: provide le/be 64 bit conversion helper
> 
> That were posted earlier.  Let me know if you spot issues.

I'd suggest you go push this.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks!
