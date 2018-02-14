From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf RFC] netfilter: x_tables: only allow jumps to
 user-defined chains
Date: Wed, 14 Feb 2018 21:04:06 +0100
Message-ID: <20180214200406.222zibea6c5qr6vn@salvia>
References: <20180207132041.444-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37262 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967798AbeBNUEL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 15:04:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B705DFFB69
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 21:04:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6516DA808
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 21:04:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180207132041.444-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 07, 2018 at 02:20:41PM +0100, Florian Westphal wrote:
> This rejects rulesets where a jump occurs to a non-user defined chain.
> This isn't limited in any way in the binary format (you can jump to
> any rule you want within the blob structure), but iptables tools
> do not offset such a feature.
> 
> Sending as RFC as this limits features that might be used by programs
> that don't call xtables(-restore) tools.
> 
> This change also prevents the syzkaller reported crash as
> ruleset gets rejected.

My original intention was to go for this, given our official interface
since the beginning has been iptables-restore. But given this
description makes it clear that we have chance to break third
applications relying on this binary layout, better go conservative and
keep allowing this.

My only concern so far is if this sort of flexibility, allowing us
arbitrary jumps, can cause us more problems later on.

Let me know,
Thanks!
