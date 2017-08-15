From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/4] mnl: Drop --echo support for non-batch calls
Date: Tue, 15 Aug 2017 12:25:00 +0200
Message-ID: <20170815102500.GA3928@salvia>
References: <20170814234305.2829-1-phil@nwl.cc>
 <20170814234305.2829-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:55606 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753490AbdHOKZY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2017 06:25:24 -0400
Content-Disposition: inline
In-Reply-To: <20170814234305.2829-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 15, 2017 at 01:43:02AM +0200, Phil Sutter wrote:
> Echo support in nft_mnl_talk() was broken: nft_mnl_talk_cb() passed
> cbdata->data as second parameter to netlink_echo_callback() which
> expected it to be of type struct netlink_ctx while in fact it was
> whatever callers of nft_mnl_talk() passed as callback data (in most
> cases a NULL pointer).

Applied, thanks.

> I didn't notice this because I didn't test for kernels without support
> for transactions. This has been added to nftables in kernel version 3.16
> back in 2014. Since then, user space which doesn't support it can't even
> add a table anymore. So adding this new feature to the old code path is
> really not feasible, therefore drop this broken attempt at supporting
> it.

We fixed this problem with nft and 3.16 IIRC. So at least the very
basic featureset still available there works fine.
