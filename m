From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next RFC 1/5] netfilter: use
 nf_conntrack_helpers_register when possible
Date: Mon, 5 Jun 2017 11:26:06 +0200
Message-ID: <20170605092606.GB843@breakpoint.cc>
References: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
 <1496589909-56730-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:32930 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751290AbdFEJ0g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2017 05:26:36 -0400
Content-Disposition: inline
In-Reply-To: <1496589909-56730-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> amanda_helper, nf_conntrack_helper_ras and nf_conntrack_helper_q931 are
> all arrays, so we can use nf_conntrack_helpers_register to register
> the ct helper, this will help us to eliminate some "goto errX"
> statements.
> 
> Also introduce h323_helper_init/exit helper function to register the ct
> helpers, this is prepared for the followup patch, which will add net
> namespace support for ct helper.

Looks good,

Acked-by: Florian Westphal <fw@strlen.de>
