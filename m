From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: don't setup nat info for confirmed ct
Date: Sat, 6 May 2017 21:09:35 +0200
Message-ID: <20170506190935.GA20672@breakpoint.cc>
References: <20170506122802.5630-1-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36284 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750836AbdEFTKC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 May 2017 15:10:02 -0400
Content-Disposition: inline
In-Reply-To: <20170506122802.5630-1-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> We cannot setup nat info if the ct has been confirmed already, else,
> different cpu may race to handle the same ct.

Yes.

> In extreme situation,
> we may hit the "BUG_ON(nf_nat_initialized(ct, maniptype))" in the
> nf_nat_setup_info.

Right, before my change we did call
nf_ct_nat_ext_add() unconditionally and that made us return NF_ACCEPT
for confirmed conntracks without nat extension.

So this fix looks correct to me, thanks Liping!

Acked-by: Florian Westphal <fw@strlen.de>
