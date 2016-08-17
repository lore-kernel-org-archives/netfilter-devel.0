From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V3 nf-next] netfilter: conntrack: simplify the code by
 using nf_conntrack_get_ht
Date: Wed, 17 Aug 2016 17:43:53 +0200
Message-ID: <20160817154353.GB15926@salvia>
References: <1471098936-2970-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42584 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbcHQPoD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 11:44:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 819F6D164E
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:44:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 755AEFB469
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:44:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B0152A827A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:43:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471098936-2970-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 13, 2016 at 10:35:36PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Since Commit 64b87639c9cb ("netfilter: conntrack: fix race between
> nf_conntrack proc read and hash resize") introdue the
> nf_conntrack_get_ht, so there's no need to check nf_conntrack_generation
> again and again to get the hash table and hash size. And convert
> nf_conntrack_get_ht to inline function here.

Applied, thanks.
