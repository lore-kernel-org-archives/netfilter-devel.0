From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: rpfilter: bypass ipv4 lbcast packets
 with zeronet source
Date: Sun, 4 Dec 2016 12:20:41 +0100
Message-ID: <20161204112041.GC26974@breakpoint.cc>
References: <1480771508-4429-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34046 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750995AbcLDLYA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 06:24:00 -0500
Content-Disposition: inline
In-Reply-To: <1480771508-4429-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Otherwise, DHCP Discover packets(0.0.0.0->255.255.255.255) may be
> dropped incorrectly.

LGTM.
Acked-by: Florian Westphal <fw@strlen.de>
