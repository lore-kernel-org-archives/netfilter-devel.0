From: Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH] libxt_recent: Remove ineffective checks for
 info->name
Date: Fri, 20 Oct 2017 13:54:52 +0200
Message-ID: <20171020115452.GF16796@breakpoint.cc>
References: <20171020112436.17679-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35276 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753125AbdJTLzC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 07:55:02 -0400
Content-Disposition: inline
In-Reply-To: <20171020112436.17679-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Sutter <phil@nwl.cc> wrote:
> In struct xt_recent_mtinfo{,_v1}, field 'name' is an array, not a
> pointer. So there is no point in comparing it against NULL. Changing the
> check to make sure it's content is not an empty string is pointless
> either, since a non-empty default string is used and the argument parser
> will refuse empty strings as --name argument. So simply get rid of the
> checks altogether.

Right, applied.
