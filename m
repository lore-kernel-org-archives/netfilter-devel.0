From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix oops when deleting a chain
 with references
Date: Wed, 29 Jan 2014 20:22:54 +0100
Message-ID: <20140129192254.GB11531@localhost>
References: <20140125080407.GA15949@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44621 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbaA2TXA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:23:00 -0500
Content-Disposition: inline
In-Reply-To: <20140125080407.GA15949@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 25, 2014 at 08:04:07AM +0000, Patrick McHardy wrote:
> commit 780f57420cdac84eabec388868678ede19f7d682
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Fri Jan 24 13:23:52 2014 +0000
> 
>     netfilter: nf_tables: fix oops when deleting a chain with references
> 
>     THe following commands trigger an oops:
> 
>     # nft -i
>     nft> add table filter
>     nft> add chain filter input { type filter hook input priority 0; }
>     nft> add chain filter test 
>     nft> add rule filter input jump test
>     nft> delete chain filter test
>     
>     We need to check the chain use counter before allowing destruction since
>     we might have references from sets or jump rules.

Applied, thanks Patrick.
