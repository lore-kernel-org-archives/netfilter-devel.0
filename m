From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: conntrack: simplify early_drop
Date: Mon, 11 Jul 2016 12:11:18 +0200
Message-ID: <20160711101118.GB18393@salvia>
References: <1467571441-26797-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44406 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757697AbcGKKLW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2016 06:11:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 63FDD17AB6B
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:11:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3AF8FFF12D
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:11:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4687FFAB44
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:11:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1467571441-26797-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 03, 2016 at 08:44:01PM +0200, Florian Westphal wrote:
> We don't need to acquire the bucket lock during early drop, we can
> use lockless traveral just like ____nf_conntrack_find.
> 
> The timer deletion serves as synchronization point, if another cpu
> attempts to evict same entry, only one will succeed with timer deletion.

Applied, thanks Florian.
