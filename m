From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] rt: add path mtu support
Date: Tue, 22 Aug 2017 18:16:36 +0200
Message-ID: <20170822161636.GB11814@salvia>
References: <20170822135141.10785-1-fw@strlen.de>
 <20170822135141.10785-3-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38189 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751043AbdHVQRD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 12:17:03 -0400
Content-Disposition: inline
In-Reply-To: <20170822135141.10785-3-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 22, 2017 at 03:51:40PM +0200, Florian Westphal wrote:
> Only use case is to allow similar behaviour to iptables
> TCPMSS --clamp-mss-to-pmtu, by combining this with exthdr statement:
> 
> tcp option maxseg size set rt mtu
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
