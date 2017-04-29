From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nf_ct_ext: invoke destroy even when
 ext is not attached
Date: Sat, 29 Apr 2017 22:03:10 +0200
Message-ID: <20170429200310.GC26935@breakpoint.cc>
References: <1493474389-9217-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39246 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1036093AbdD2UDZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Apr 2017 16:03:25 -0400
Content-Disposition: inline
In-Reply-To: <1493474389-9217-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> For NF_NAT_MANIP_SRC, we will insert the ct to the nat_bysource_table,
> then remove it from the nat_bysource_table via nat_extend->destroy.

Right, I forgot about that.

> But now, the nat extension is attached on demand, so if the nat extension
> is not attached, we will not be notified when the ct is destroyed, i.e.
> we may fail to remove ct from the nat_bysource_table.
>
> So just keep it simple, even if the extension is not attached, we will
> still invoke the related ext->destroy. And this will also preserve the
> flexibility for the future extension.

So afaics only helper and nat have destructors and both are safe to be
called if the extension isn't present.

IOW, this looks correct to me, thanks for finding and fixing this.
