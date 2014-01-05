From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: nf_tables: limit maximum number of
 elements
Date: Sun, 5 Jan 2014 21:51:02 +0000
Message-ID: <20140105215102.GA18661@macbook.localnet>
References: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
 <1388956728-6754-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47643 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaAEVvJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:51:09 -0500
Content-Disposition: inline
In-Reply-To: <1388956728-6754-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 05, 2014 at 10:18:47PM +0100, Pablo Neira Ayuso wrote:
> This patch adds a limit to the maximum number of elements that
> belong to a set. It also adds a new field to count the current
> number of elements, so in case that limit is reached, we hit
> -ENOSPC.
> 
> This patch also adds two new attributes: NFTA_SET_MAXELEMS to
> set and to indicate the current limit and NFTA_SET_NUMELEMS
> to export the current number of set elements.

This affects the API, I'm really opposed to make any temporary
fixes, but any temporary fix affecting the API is a complete
no go IMO.
