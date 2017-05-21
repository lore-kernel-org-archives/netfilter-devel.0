From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 0/3] netfilter: handle hash resize situation in
 nf_ct_iterate_cleanup
Date: Sun, 21 May 2017 10:07:55 +0200
Message-ID: <20170521080755.GB1004@breakpoint.cc>
References: <1495345149-57674-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36798 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750786AbdEUIIp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 04:08:45 -0400
Content-Disposition: inline
In-Reply-To: <1495345149-57674-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> First, when we do nf ct cleanup, we should also handle the hash resize
> situation, so we will not miss the related conntracks, this is important
> for module removal.
> 
> After we accomplish this, we can use nf_ct_iterate_cleanup to remove these
> copy & paste codes, which are used to unlink cthelper objects and
> cttimeout objects.

Agreed.
I have similar patches as part of a larger batch, see

https://git.breakpoint.cc/cgit/fw/nf-next.git/log/?h=nfct_iterate_cleanup_15

More comments as replies to the patches.
