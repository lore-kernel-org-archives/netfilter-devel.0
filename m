From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/7] netfilter: nf_tables: deconstify table and chain in
 context structure
Date: Fri, 28 Mar 2014 12:42:29 +0000
Message-ID: <20140328124229.GB7895@macbook.localnet>
References: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
 <1395957197-4899-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55327 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaC1Mmd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:42:33 -0400
Content-Disposition: inline
In-Reply-To: <1395957197-4899-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 27, 2014 at 10:53:11PM +0100, Pablo Neira Ayuso wrote:
> The new transaction infrastructure updates the family, table and chain
> objects in the context structure, so let's deconstify them. While at it,
> move the context structure initialization routine to the top of the
> source file as it will be also used from the table and chain routines.

I would prefer to keep the consts for the context, but I'm fine with it
if we don't find a clean other way. Basically I'd suggest to use your
patch if we have functions that are called from both the transaction
code and non-transaction code, IOW need the nft_ctx structure.
Otherwise, if this stuff is only used by the transaction code, we could
add the individual members to the transaction as non-consts.
