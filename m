From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] expression: fix output of verdict maps
Date: Mon, 13 Jan 2014 12:42:03 +0000
Message-ID: <20140113124202.GA17951@macbook.localnet>
References: <1389616756-8326-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56875 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaAMMmH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:42:07 -0500
Content-Disposition: inline
In-Reply-To: <1389616756-8326-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 13, 2014 at 01:39:16PM +0100, Pablo Neira Ayuso wrote:
> % nft list table filter
> table ip filter {
> 	...
> 	chain output {
> 		...
> 		ip saddr map { 1.1.1.1 => accept}
> 	}
> }
> 
> It displays 'map' instead of 'vmap'. Fix it by checking the mapping
> type in map_expr_print().

The fix is fine of course, but even better would be to get rid of the
vmap keyword IMO. IIRC it only exists because I couldn't manage to get
a conflict free grammar together, but it would be worth another try.
