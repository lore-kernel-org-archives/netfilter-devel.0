From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: xtables: add scheduling opportunity in
 get_counters
Date: Fri, 8 Sep 2017 13:47:54 +0200
Message-ID: <20170908114754.GB13597@salvia>
References: <20170901204103.16129-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, edumazet@google.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:34460 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754358AbdIHLsS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2017 07:48:18 -0400
Content-Disposition: inline
In-Reply-To: <20170901204103.16129-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 01, 2017 at 10:41:03PM +0200, Florian Westphal wrote:
> There are reports about spurious softlockups during iptables-restore, a
> backtrace i saw points at get_counters -- it uses a sequence lock and also
> has unbounded restart loop.

Applied, thanks.
