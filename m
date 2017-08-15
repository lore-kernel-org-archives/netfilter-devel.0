From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] echo: Fix for added delays in rule updates
Date: Tue, 15 Aug 2017 14:03:10 +0200
Message-ID: <20170815120310.GA24822@salvia>
References: <20170815115912.4254-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:56446 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbdHOMDe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2017 08:03:34 -0400
Content-Disposition: inline
In-Reply-To: <20170815115912.4254-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 15, 2017 at 01:59:12PM +0200, Phil Sutter wrote:
> The added cache update upon every command dealing with rules was a
> bummer. Instead, perform the needed cache update only if echo option was
> set.
> 
> Initially, I tried to perform the cache update from within
> netlink_echo_callback(), but that turned into a mess since the shared
> socket between cache_init() and mnl_batch_talk() would receive
> unexpected new input. So instead update the cache from do_command_add(),
> netlink_replace_rule_batch() and do_comand_insert() so it completes
> before mnl_batch_talk() starts listening.

Applied, thanks Phil!
