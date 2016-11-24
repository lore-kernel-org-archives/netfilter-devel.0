From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nft_fib_ipv4: initialize *dest to zero
Date: Thu, 24 Nov 2016 13:54:43 +0100
Message-ID: <20161124125443.GC24598@breakpoint.cc>
References: <1479910341-40744-1-git-send-email-zlpnobody@163.com>
 <1479910341-40744-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51872 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938556AbcKXM6T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 07:58:19 -0500
Content-Disposition: inline
In-Reply-To: <1479910341-40744-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Otherwise, if fib lookup fail, *dest will be filled with garbage value,
> so reverse path filtering will not work properly:
>  # nft add rule x prerouting fib saddr oif eq 0 drop
> 
> Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>

Acked-by: Florian Westphal <fw@strlen.de>
