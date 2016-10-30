From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft v2] ct: fix "ct l3proto/protocol" syntax broken
Date: Sun, 30 Oct 2016 19:08:37 +0100
Message-ID: <20161030180837.GE30951@breakpoint.cc>
References: <1477830974-13197-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41562 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752236AbcJ3SKS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Oct 2016 14:10:18 -0400
Content-Disposition: inline
In-Reply-To: <1477830974-13197-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> "l3proto" and "protocol" are still keywords in our grammer, they are not
> STRING, so if the user input the following rule, nft will complain that
> the syntax is error:
>   # nft add t c ct l3proto ipv4
>   <cmdline>:1:12-18: Error: syntax error, unexpected l3proto, expecting
>   string or mark or packets or bytes
>   add t c ct l3proto ipv4
              ^^^^^^^
Applied, thanks for fixing this up.
