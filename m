From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] meta: permit meta nfproto ip in ip family
Date: Mon, 12 Jun 2017 12:46:31 +0200
Message-ID: <20170612104631.GA7920@salvia>
References: <20170529172538.27878-1-fw@strlen.de>
 <20170606185739.GC13566@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:57593 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751746AbdFLKqk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2017 06:46:40 -0400
Content-Disposition: inline
In-Reply-To: <20170606185739.GC13566@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 06, 2017 at 08:57:39PM +0200, Florian Westphal wrote:
[...]
> One thing to keep in mind for future:
> 
> NFT_META_NFPROTO is basically useless except for inet pseudo-family.

IIRC, the only reason I can find we need this is because skb->pkttype
is set after the output hook.
