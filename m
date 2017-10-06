From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables] netlink_linearize: skip set element expression
 in set statement key
Date: Fri, 6 Oct 2017 14:58:11 +0200
Message-ID: <20171006125811.GA8450@salvia>
References: <1507127265.20182.2.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:41834 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751869AbdJFM6Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2017 08:58:16 -0400
Content-Disposition: inline
In-Reply-To: <1507127265.20182.2.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 04, 2017 at 02:27:45PM +0000, Anders K. Pedersen | Cohaesio wrote:
> From: Anders K. Pedersen <akp@cohaesio.com>
> 
> Before this patch the following fails:
> 
> # nft add rule ip6 filter x \
> 	set add ip6 saddr . ip6 daddr @test
> nft: netlink_linearize.c:648: netlink_gen_expr: Assertion `dreg < ctx->reg_low' failed.
> Aborted
> 
> This is was previously fixed for flow statements in fbea4a6f4449
> ("netlink_linearize: skip set element expression in flow table key"), and
> this patch implements the same change for set statements by using the set
> element key in netlink_gen_set_stmt().
> 
> nft-test.py is updated to support set types with concatenated data types
> in order to support testing of this.

Applied, thanks Anders.
