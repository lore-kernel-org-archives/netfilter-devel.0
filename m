From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: core: remove erroneous warn_on
Date: Fri, 8 Sep 2017 14:04:32 +0200
Message-ID: <20170908120432.GA14839@salvia>
References: <20170906124757.13934-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:34623 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753407AbdIHME5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2017 08:04:57 -0400
Content-Disposition: inline
In-Reply-To: <20170906124757.13934-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 06, 2017 at 02:47:57PM +0200, Florian Westphal wrote:
> kernel test robot reported:
> 
> WARNING: CPU: 0 PID: 1244 at net/netfilter/core.c:218 __nf_hook_entries_try_shrink+0x49/0xcd
> [..]
> 
> After allowing batching in nf_unregister_net_hooks its possible that an earlier
> call to __nf_hook_entries_try_shrink already compacted the list.
> If this happens we don't need to do anything.

Applied, thanks.
