From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 6/7] rt: add path mss support
Date: Mon, 21 Aug 2017 16:12:27 +0200
Message-ID: <20170821141227.GE6076@salvia>
References: <20170819231413.15164-1-fw@strlen.de>
 <20170819231413.15164-7-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:55822 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753939AbdHUONE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 10:13:04 -0400
Content-Disposition: inline
In-Reply-To: <20170819231413.15164-7-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 20, 2017 at 01:14:12AM +0200, Florian Westphal wrote:
> Only use case is to allow similar behaviour to iptables
> TCPMSS --clamp-mss-to-pmtu, by combining this via tcp exthdr:
> 
> tcp option mss set rt mss
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
