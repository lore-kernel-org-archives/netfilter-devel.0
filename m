From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH nf-next] netfilter: ipvs: don't check for presence of nat
 extension
Date: Thu, 30 Mar 2017 14:42:32 +0200
Message-ID: <20170330124232.GA2980@verge.net.au>
References: <20170328083120.2291-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:36671 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933173AbdC3Mmi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2017 08:42:38 -0400
Content-Disposition: inline
In-Reply-To: <20170328083120.2291-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 28, 2017 at 10:31:20AM +0200, Florian Westphal wrote:
> Check for the NAT status bits, they are set once conntrack needs NAT in source or
> reply direction, this is slightly faster than nfct_nat() as that has to check the
> extension area.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Thanks, applied.
