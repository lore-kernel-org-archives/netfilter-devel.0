From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] netfilter: nf_nat: better error handling of	nf_ct_expect_related()
 in helpers
Date: Tue, 21 Sep 2010 17:07:07 +0200
Message-ID: <4C98CA1B.3080200@trash.net>
References: <20100921092843.3279.6914.stgit@decadence> <20100921093425.3279.85095.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38888 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab0IUPHX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:07:23 -0400
In-Reply-To: <20100921093425.3279.85095.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 21.09.2010 11:34, schrieb Pablo Neira Ayuso:
> This patch improves the situation in which the expectation table is
> full for conntrack NAT helpers. Basically, we give up if we don't
> find a place in the table instead of looping over nf_ct_expect_related()
> with a different port (we should only do this if it returns -EBUSY, for
> -EMFILE or -ESHUTDOWN I think that it's better to skip this).

Indeed, this makes a lot more sense than our current behaviour.
