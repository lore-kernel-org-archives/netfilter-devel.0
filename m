From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/3] netfilter: nf_tables: add generation mask to
 set objects
Date: Tue, 4 Aug 2015 12:38:13 +0200
Message-ID: <20150804103813.GA12016@acer.localdomain>
References: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
 <1438679128-4146-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43255 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbbHDKiR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 06:38:17 -0400
Content-Disposition: inline
In-Reply-To: <1438679128-4146-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.08, Pablo Neira Ayuso wrote:
> Use the generation mask approach to obtain a consistent list of set objects
> from netlink dump commands.
> 
> Get rid of the internal NFT_SET_INACTIVE flag.

In this case I don't see how deletion and creation in the same
batch will work at all since we don't check any active bits in
nf_tables_newset().

We also have the problem that f.i. delset checks for activeness
in the current instead of the next generation.
