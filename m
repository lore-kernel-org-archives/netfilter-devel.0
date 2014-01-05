From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: nft_hash: use set->maxelems to calculate
 number of buckets
Date: Sun, 5 Jan 2014 23:12:11 +0100
Message-ID: <20140105221211.GB4387@localhost>
References: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
 <1388956728-6754-4-git-send-email-pablo@netfilter.org>
 <20140105214744.GA18655@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53770 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaAEWMP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 17:12:15 -0500
Content-Disposition: inline
In-Reply-To: <20140105214744.GA18655@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 05, 2014 at 09:47:44PM +0000, Patrick McHardy wrote:
> On Sun, Jan 05, 2014 at 10:18:48PM +0100, Pablo Neira Ayuso wrote:
> > Use set->maxelems to calculate the number of buckets that holds a
> > load factor of 0.75.
> 
> This patch is perfectly fine of course.

Thanks. So I guess you're fine with 2/3 as well which is needed by
this patch.
