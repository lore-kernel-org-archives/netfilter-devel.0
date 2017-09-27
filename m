From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] monitor: Fix for incorrect debug_mask
Date: Wed, 27 Sep 2017 14:11:21 +0200
Message-ID: <20170927121121.GA21470@salvia>
References: <20170921183802.27797-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:35555 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdI0MLZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 08:11:25 -0400
Content-Disposition: inline
In-Reply-To: <20170921183802.27797-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 21, 2017 at 08:38:02PM +0200, Phil Sutter wrote:
> The field 'debug_mask' of struct netlink_mon_handler was left
> uninitialized in do_command_monitor() so it contained garbage from the
> stack. Fix this by initializing it with the debug_mask value from struct
> netlink_ctx.
> 
> While being at it, change the code to make use of C99-style initializer,
> which will also avoid things like this in future.

Applied, thanks Phil.
