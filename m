From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH 0/2 nf_tables] 32/64/128-bits word addressing in
 nf_tables
Date: Mon, 28 Oct 2013 13:09:15 +0000
Message-ID: <20131028130915.GB3780@macbook.localnet>
References: <1382965180-9400-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38780 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab3J1NJT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:09:19 -0400
Content-Disposition: inline
In-Reply-To: <1382965180-9400-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 28, 2013 at 01:59:37PM +0100, Pablo Neira Ayuso wrote:
> This is a preliminary patchset to allow nf_tables to address registers
> at 32/64/128 bits word size. This is something that Patrick and I have
> been discussing for a while.
> 
> The proposed approach in this patchset adds the new register addressing
> to the nf_tables core, the overlapping register approach describe in
> patch 1/2 is backward compatible.
> 
> Still missing a kernel patch to allow set elements higher than 128 bits,
> so we can have concatenations including IPv6 addresses, but that limitation
> should be easy to remove. Explicit set type selection is also required,
> currently, it is selecting the rb-tree set type here, which is suboptimal.
> 
> Comments welcome.

Thanks for looking into this. I'll review them tonight.
