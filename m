From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 3/5] erec_print: Pass output FILE pointer to
 netlink_dump_expr()
Date: Fri, 29 Sep 2017 12:26:44 +0200
Message-ID: <20170929102644.GC2720@salvia>
References: <20170928151745.28426-1-phil@nwl.cc>
 <20170928151745.28426-4-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [213.95.27.120] ([213.95.27.120]:59020 "EHLO
        ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbdI2K1z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2017 06:27:55 -0400
Content-Disposition: inline
In-Reply-To: <20170928151745.28426-4-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 28, 2017 at 05:17:43PM +0200, Phil Sutter wrote:
> It was a bit odd that erec_print() outputs to a given FILE pointer but
> then calls netlink_dump_expr() which just prints to stdout. Fix this by
> passing the given FILE pointer along so output is guaranteed to go to
> the same destination.

Applied, thanks Phil.
