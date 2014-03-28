From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/7] netfilter: nf_tables: move table handling to the
 transaction infrastructure
Date: Fri, 28 Mar 2014 13:12:18 +0000
Message-ID: <20140328131217.GG7895@macbook.localnet>
References: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
 <1395957197-4899-8-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55536 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaC1NMV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:12:21 -0400
Content-Disposition: inline
In-Reply-To: <1395957197-4899-8-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 27, 2014 at 10:53:17PM +0100, Pablo Neira Ayuso wrote:
> This patch speeds up rule-set updates and it helps to leave the
> table configuration in consistent state when processing a batch.

Same things as for chain updates apply to this patch. I think we should
limit this to sets until the conceptual shortcomings have been resolved.
