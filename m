From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 7/7] tests: add tcp option set support / tcp mss
 mangling test cases
Date: Mon, 21 Aug 2017 16:14:17 +0200
Message-ID: <20170821141417.GF6076@salvia>
References: <20170819231413.15164-1-fw@strlen.de>
 <20170819231413.15164-8-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:55855 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753916AbdHUOOu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 10:14:50 -0400
Content-Disposition: inline
In-Reply-To: <20170819231413.15164-8-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for adding tests.

On Sun, Aug 20, 2017 at 01:14:13AM +0200, Florian Westphal wrote:
> diff --git a/tests/py/inet/tcpopt.t b/tests/py/inet/tcpopt.t
> index a42ecd250a9c..94ad3fc4c645 100644
> --- a/tests/py/inet/tcpopt.t
> +++ b/tests/py/inet/tcpopt.t
> @@ -38,3 +38,6 @@ tcp option sack window 1;fail
>  
>  tcp option window exists;ok
>  tcp option window missing;ok
> +
> +tcp option maxseg size set 1360;ok;tcp option mss set 1360

This is a follow up, related to 5/7.

Why do we need this assymetry at all?
