From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next V2] netfilter: conntrack: simplify the code by
 using nf_conntrack_get_ht
Date: Fri, 12 Aug 2016 12:34:42 +0200
Message-ID: <20160812103442.GA3484@salvia>
References: <1469878973-15201-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32864 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbcHLKex (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 06:34:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 961EED162B
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:34:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 868006DB36
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:34:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CA8146DB3B
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:34:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469878973-15201-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 30, 2016 at 07:42:53PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Since Commit 64b87639c9cb ("netfilter: conntrack: fix race between
> nf_conntrack proc read and hash resize") introdue the
> nf_conntrack_get_ht, so there's no need to check nf_conntrack_generation
> again and again to get the hash table and hash size.
> 
> But keep ____nf_conntrack_find unchanged, because it is performance
> critical path, increase the overhead of the function call is not so
> good.

I'm not very happy with this solution.

I think it is a good time to kill compat /proc/net/ip_conntrack*. That
has been there for so long already. So we can inline this function,
this is the only one that needs it to export it, right?
