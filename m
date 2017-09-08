From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_nat: don't bug when mapping already
 exists
Date: Fri, 8 Sep 2017 13:47:31 +0200
Message-ID: <20170908114731.GA13597@salvia>
References: <20170831114524.7511-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:34451 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754914AbdIHLry (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2017 07:47:54 -0400
Content-Disposition: inline
In-Reply-To: <20170831114524.7511-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 31, 2017 at 01:45:24PM +0200, Florian Westphal wrote:
> It seems preferrable to limp along if we have a conflicting mapping,
> its certainly better than a BUG().

Applied, thanks.
