From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/7] netfilter: conntrack: constify protocol
 trackers, part 1
Date: Thu, 24 Aug 2017 18:52:58 +0200
Message-ID: <20170824165258.GA16380@salvia>
References: <20170811225708.22181-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:59081 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753734AbdHXQxW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 12:53:22 -0400
Content-Disposition: inline
In-Reply-To: <20170811225708.22181-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 12, 2017 at 12:57:01AM +0200, Florian Westphal wrote:
> This is an initial series of patches to mark the l3 and l4 protocol handler
> structs as const.
> 
> Only reason why we can't constify them now is that l3 and l4 trackers
> compute netlink attribute size needed at init time and store result in
> the proto struct.
> 
> First patch switches the l3 trackers to compile-time computation.
> 
> Next patches reduce size by (re)moving various pointers.
> 
> Last patch adds const qualifiers in a lot of places.  This patch
> has no effect on its own but its needed to avoid compiler warnings
> when part 2 of the series will constify the trackers.

Applied, thanks.
