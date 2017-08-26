From: Florian Westphal <fw@strlen.de>
Subject: Re: NFQUEUE --queue-balance
Date: Sat, 26 Aug 2017 21:24:21 +0200
Message-ID: <20170826192421.GC29355@breakpoint.cc>
References: <20170826154013.GA19754@legohost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oleg <lego12239@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44378 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751062AbdHZT07 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Aug 2017 15:26:59 -0400
Content-Disposition: inline
In-Reply-To: <20170826154013.GA19754@legohost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oleg <lego12239@yandex.ru> wrote:
>   Hi, all.
> 
> --queue-balance balance packets according to connection tracking,
> iiuc. Consequently queue utilization is not equal. E.g.:

It hashes based on ip addresses.

> Is there queue balancer without this feature(simple round-robin)?

Use nftables or use multiple NFQUEUE rules with -m statistic.

