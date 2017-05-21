From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nat: use atomic bit op to clear the
 _SRC_NAT_DONE_BIT
Date: Sun, 21 May 2017 17:45:05 +0200
Message-ID: <20170521154505.GG1004@breakpoint.cc>
References: <1495377491-46768-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37550 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751315AbdEUPpz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 11:45:55 -0400
Content-Disposition: inline
In-Reply-To: <1495377491-46768-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> We need to clear the IPS_SRC_NAT_DONE_BIT to indicate that the ct has
> been removed from nat_bysource table. But unfortunately, we use the
> non-atomic bit operation: "ct->status &= ~IPS_NAT_DONE_MASK". So
> there's a race condition that we may clear the _DYING_BIT set by
> another CPU unexpectedly.
> 
> Since we don't care about the IPS_DST_NAT_DONE_BIT, so just using
> clear_bit to clear the IPS_SRC_NAT_DONE_BIT is enough.
> 
> Also note, this is the last user which use the non-atomic bit operation
> to update the confirmed ct->status.

Looks good, thanks Liping.
