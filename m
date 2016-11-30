From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: arp_tables: fix invoking 32bit "iptable -P
 INPUT ACCEPT" failed in 64bit kernel
Date: Wed, 30 Nov 2016 19:32:39 +0100
Message-ID: <20161130183239.GA9099@salvia>
References: <1480474586-205429-1-git-send-email-hongxu.jia@windriver.com>
 <20161130115307.GD6454@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hongxu Jia <hongxu.jia@windriver.com>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48658 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757704AbcK3SlJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2016 13:41:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 78E5311E588
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 19:32:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69CD4DA7E0
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 19:32:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDBE2DA807
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 19:32:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161130115307.GD6454@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 30, 2016 at 12:53:07PM +0100, Florian Westphal wrote:
> Hongxu Jia <hongxu.jia@windriver.com> wrote:
> > Since the following commit applied in kernel (https://git.kernel.org/cgit/
> > linux/kernel/git/torvalds/linux.git/commit/?id=09d9686047dbbe1cf4faa558d3ecc4aae2046054)
> > --------------------------------------
> > commit 09d9686047dbbe1cf4faa558d3ecc4aae2046054
> > Author: Florian Westphal <fw@strlen.de>
> > Date:   Fri Apr 1 14:17:34 2016 +0200
> > 
> >     netfilter: x_tables: do compat validation via translate_table
> > --------------------------------------
> > It used compatr structure to assign newinfo structure.
> > In translate_compat_table of ip_tables.c and ip6_tables.c, it used
> > compatr->hook_entry to replace info->hook_entry and
> > compatr->underflow to replace info->underflow, but not do the same
> > replacement in arp_tables.c.
> 
> Right, thanks for fixing this:
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Applied, thanks everyone.
