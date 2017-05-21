From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/3] netfilter: restart nf ct cleanup if hash
 resize happen
Date: Sun, 21 May 2017 10:09:24 +0200
Message-ID: <20170521080924.GC1004@breakpoint.cc>
References: <1495345149-57674-1-git-send-email-zlpnobody@163.com>
 <1495345149-57674-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36822 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751545AbdEUIKL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 04:10:11 -0400
Content-Disposition: inline
In-Reply-To: <1495345149-57674-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Similar to commit 474803d37e7f ("netfilter: cttimeout: unlink timeout
> obj again when hash resize happen"), when hash resize happen, we should
> try to do cleanup work from the 0#bucket again, so we will never miss
> the conntrack entries which we are intrested in. This is important for
> the module removal.

Right.  However, I suggest to use the seqcount for this, as done here:

https://git.breakpoint.cc/cgit/fw/nf-next.git/commit/?h=nfct_iterate_cleanup_15&id=b4f7c51617df8c79e0f28d03c6ebc2c157b1fecd

