From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: destroy kmemcache on module
 removal
Date: Wed, 15 Jun 2016 11:36:03 +0200
Message-ID: <20160615093602.GA2516@salvia>
References: <1465572319-880-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52700 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbcFOJgK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 05:36:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DC0D2100786
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:36:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CB4439EBAD
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:36:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E8F5A9EBAD
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:36:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465572319-880-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 10, 2016 at 05:25:19PM +0200, Florian Westphal wrote:
> I forgot to move the kmem_cache_destroy into the exit path.

Applied to nf, thanks Florian.

