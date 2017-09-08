From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 0/2] netfilter: nat: do not use rhltable
Date: Fri, 8 Sep 2017 13:55:36 +0200
Message-ID: <20170908115536.GC13597@salvia>
References: <20170906123952.12555-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:34527 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752858AbdIHL4B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2017 07:56:01 -0400
Content-Disposition: inline
In-Reply-To: <20170906123952.12555-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 06, 2017 at 02:39:50PM +0200, Florian Westphal wrote:
> This reverts the conversion of the nat bysource table to rhlist that
> I did last year.
> 
> It was a bad idea to begin with.
> 
> Fast lookup is not essential; in most cases there is no lookup
> at all because original tuple is not taken and can be used as-is.
> What needs to be fast is insertion and deletion.
> 
> With rhlist, deletion is slow as it requires a list traversal.
> So, switch back to a statically-sized table for bysource hash.

Series applied.
