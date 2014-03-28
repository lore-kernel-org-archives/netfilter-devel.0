From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/7] netfilter: nf_tables: move chain handling to the
 transaction infrastructure
Date: Fri, 28 Mar 2014 13:10:00 +0000
Message-ID: <20140328131000.GF7895@macbook.localnet>
References: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
 <1395957197-4899-7-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55521 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaC1NKE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:10:04 -0400
Content-Disposition: inline
In-Reply-To: <1395957197-4899-7-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 27, 2014 at 10:53:16PM +0100, Pablo Neira Ayuso wrote:
> This patch speeds up rule-set updates and it helps to leave chains
> in consistent state when processing a batch. Note this patch does
> not introduce a way to revert chain updates, eg. counter or default
> policy changes.

Also it doesn't seem to handle chain renames. I think this is a conceptual
shortcoming, there's no way to implement updates properly by just storing
the chain in the transaction, we need to store the actual actions to be
performed.
