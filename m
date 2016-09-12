From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] tests: py: replace "eth0" with "lo" in dup expr tests
Date: Mon, 12 Sep 2016 02:43:17 +0200
Message-ID: <20160912004317.GA27566@breakpoint.cc>
References: <1473495243-39716-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53924 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932252AbcILAna (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Sep 2016 20:43:30 -0400
Content-Disposition: inline
In-Reply-To: <1473495243-39716-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> This patch follow up on Manuel's commit a8871ba6daa0 ("tests: py: any:
> Make tests more generic by using other interfaces"). The ifindex of
> "eth0" is not always 1, furthermore, "eth0" maybe not exist on some
> systems. So replace it with "lo" will make tests more rubost.
> 
> In other test cases, "eth0" is used by iifname or oifname, so there's no
> need to convert it to "lo". Even if "eth0" is not exist, test will never
> fail.

Applied, thanks.
