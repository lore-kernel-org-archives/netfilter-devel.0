From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 4/7] src: add tcp options set support
Date: Mon, 21 Aug 2017 16:09:39 +0200
Message-ID: <20170821140939.GC6076@salvia>
References: <20170819231413.15164-1-fw@strlen.de>
 <20170819231413.15164-5-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:55780 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753636AbdHUOKH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 10:10:07 -0400
Content-Disposition: inline
In-Reply-To: <20170819231413.15164-5-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 20, 2017 at 01:14:10AM +0200, Florian Westphal wrote:
> This adds support for tcp mss mangling:
> 
> nft add rule filter input tcp option maxseg size 1200
> 
> Its also possible to change other tcp option fields, but
> maxseg is one of the more useful ones to change.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
