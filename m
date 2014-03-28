From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/7] netfilter: nf_tables: generalise transaction
 infrastructure
Date: Fri, 28 Mar 2014 12:42:58 +0000
Message-ID: <20140328124257.GC7895@macbook.localnet>
References: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
 <1395957197-4899-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55332 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaC1MnD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:43:03 -0400
Content-Disposition: inline
In-Reply-To: <1395957197-4899-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 27, 2014 at 10:53:12PM +0100, Pablo Neira Ayuso wrote:
> This patch generalises the existing rule transaction infrastructure
> so it can be used to handle set, table and chain object transactions
> as well.

This looks very good to me.
