From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter: nf_tables: check if payload length is a
 power of 2
Date: Mon, 17 Feb 2014 11:39:24 +0100
Message-ID: <20140217103924.GA8090@localhost>
References: <1392555718-3607-1-git-send-email-nikolay@redhat.com>
 <20140216160954.GA12656@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikolay Aleksandrov <nikolay@redhat.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59848 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbaBQKje (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:39:34 -0500
Content-Disposition: inline
In-Reply-To: <20140216160954.GA12656@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 16, 2014 at 04:09:55PM +0000, Patrick McHardy wrote:
> On Sun, Feb 16, 2014 at 02:01:58PM +0100, Nikolay Aleksandrov wrote:
> > Add a check if payload's length is a power of 2 when selecting ops.
> > The fast ops were meant for well aligned loads, also this fixes a
> > small bug when using a length of 3 with some offsets which causes
> > only 1 byte to be loaded because the fast ops are chosen.
> > 
> > Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
> > ---
> > v3: Check the length,  not the offset.
> > v2: use is_power_of_2, and adjust order of checks as per Patrick's comment
> > 
> > Sorry for the noise, I shouldn't hurry so much. This patch applies to
> > Dave's -net tree.
> 
> Thanks!
> 
> Acked-by: Patrick McHardy <kaber@trash.net>

Applied, thanks.
