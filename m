From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3] netfilter: nf_tables: fix wrong destroy
 anonymous sets if binding fails
Date: Wed, 15 Jun 2016 11:39:26 +0200
Message-ID: <20160615093926.GB2533@salvia>
References: <1465618828-22162-1-git-send-email-zlpnobody@163.com>
 <1465618828-22162-4-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54022 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbcFOJjc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 05:39:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0EC9B100797
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:39:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F2DF49EBB8
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:39:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DE6609EBD5
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:39:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465618828-22162-4-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 11, 2016 at 12:20:28PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> When we add a nft rule like follows:
>   # nft add rule filter test tcp dport vmap {1: jump test}
> -ELOOP error will be returned, and the anonymous set will be
> destroyed.
> 
> But after that, nf_tables_abort will also try to remove the
> element and destroy the set, which was already destroyed and
> freed.
> 
> If we add a nft wrong rule, nft_tables_abort will do the cleanup
> work rightly, so nf_tables_set_destroy call here is redundant and
> wrong, remove it.

Also applied, thanks.
