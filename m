From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: arp_tables: fix invoking 32bit "iptable -P
 INPUT ACCEPT" failed in 64bit kernel
Date: Wed, 30 Nov 2016 12:53:07 +0100
Message-ID: <20161130115307.GD6454@breakpoint.cc>
References: <1480474586-205429-1-git-send-email-hongxu.jia@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Hongxu Jia <hongxu.jia@windriver.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46816 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753679AbcK3L4M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2016 06:56:12 -0500
Content-Disposition: inline
In-Reply-To: <1480474586-205429-1-git-send-email-hongxu.jia@windriver.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hongxu Jia <hongxu.jia@windriver.com> wrote:
> Since the following commit applied in kernel (https://git.kernel.org/cgit/
> linux/kernel/git/torvalds/linux.git/commit/?id=09d9686047dbbe1cf4faa558d3ecc4aae2046054)
> --------------------------------------
> commit 09d9686047dbbe1cf4faa558d3ecc4aae2046054
> Author: Florian Westphal <fw@strlen.de>
> Date:   Fri Apr 1 14:17:34 2016 +0200
> 
>     netfilter: x_tables: do compat validation via translate_table
> --------------------------------------
> It used compatr structure to assign newinfo structure.
> In translate_compat_table of ip_tables.c and ip6_tables.c, it used
> compatr->hook_entry to replace info->hook_entry and
> compatr->underflow to replace info->underflow, but not do the same
> replacement in arp_tables.c.

Right, thanks for fixing this:

Acked-by: Florian Westphal <fw@strlen.de>
