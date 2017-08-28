From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: convert hook list to an array
Date: Mon, 28 Aug 2017 17:47:42 +0200
Message-ID: <20170828154742.GA11932@salvia>
References: <20170823152627.19865-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, aconole@bytheb.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37760 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751270AbdH1PsG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 11:48:06 -0400
Content-Disposition: inline
In-Reply-To: <20170823152627.19865-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 23, 2017 at 05:26:24PM +0200, Florian Westphal wrote:
> This series converts netfilters linked-list to an array.
> This improves cache utilization as the next hook will be either
> in same or next cacheline.
> 
> Tested:
> - nfqueue test program still works
> - ip and ebtables rule counters increment
> - nftables can register base chains
> 
> Joint work with Aaron Conole.

Series applied, thanks.

I have taken 1/3 version 2.
