From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_ct: do cleanup work when
 NFTA_CT_DIRECTION is invalid
Date: Wed, 15 Mar 2017 17:15:23 +0100
Message-ID: <20170315161523.GC28159@salvia>
References: <1489587728-28318-1-git-send-email-zlpnobody@163.com>
 <20170315145231.GF24366@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44022 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751100AbdCOQP2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 12:15:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12291FB44F
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 17:15:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03F1ADA870
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 17:15:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BD141DA870
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 17:15:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170315145231.GF24366@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 15, 2017 at 03:52:31PM +0100, Florian Westphal wrote:
> Liping Zhang <zlpnobody@163.com> wrote:
> > From: Liping Zhang <zlpnobody@gmail.com>
> > 
> > We should jump to invoke __nft_ct_set_destroy() instead of just
> > return error.
> > 
> > Fixes: edee4f1e9245 ("netfilter: nft_ct: add zone id set support")
> > Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
> 
> Indeed, good catch, thanks!
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Applied, thanks.
