From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/4] netlink: Fix segfault when using --echo flag
Date: Tue, 15 Aug 2017 12:25:14 +0200
Message-ID: <20170815102514.GB3928@salvia>
References: <20170814234305.2829-1-phil@nwl.cc>
 <20170814234305.2829-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:55615 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752058AbdHOKZd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2017 06:25:33 -0400
Content-Disposition: inline
In-Reply-To: <20170814234305.2829-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 15, 2017 at 01:43:03AM +0200, Phil Sutter wrote:
> Commit 07b45939972eb ("src: introduce struct nft_cache") added cache
> pointer to struct netlink_mon_handler and the code assumes it is never
> NULL. Therefore initialize it in the dummy version of
> netlink_mon_handler in netlink_echo_callback().

Also applied, thanks.
