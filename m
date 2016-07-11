From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2,nf 0/3] netfilter: conntrack: fix race condition
 associated with hash resize
Date: Mon, 11 Jul 2016 12:09:33 +0200
Message-ID: <20160711100933.GA18350@salvia>
References: <1467523125-61877-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43854 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbcGKKJo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2016 06:09:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2DE8F17AB63
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:09:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 152B19EBB8
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:09:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D44BA9EBB8
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:09:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1467523125-61877-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 03, 2016 at 01:18:42PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> When user adjust the hash size via /sys/module/nf_conntrack/parameters/hashsize,
> something will break because race condition happened.
> 
> This patch set aim to fix these bugs.
> 
> When we do "cat /proc/net/nf_conntrack", and at the same time do hash resize,
> nf_conntrack_htable_size and nf_conntrack_hash may become unrelated if we
> read them separately, so oops will happen. Fix this in patch #1.
> 
> When we do unlink help or timeout objects, and at the same time do hash resize,
> we may miss unlinking some objects, later we will end up with invalid references.
> Fix this in patch #2 and #3.

Series applied to nf-next. We're already a bit late in the rc cycle
and this has been broken since the beginning, so I'm inclined to
follow the nf-next path.
