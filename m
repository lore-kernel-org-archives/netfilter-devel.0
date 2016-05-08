From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: remove per-netns conntrack
 tables, part 2
Date: Mon, 9 May 2016 00:19:12 +0200
Message-ID: <20160508221912.GA10278@salvia>
References: <1462488709-13031-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58695 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbcEHWTS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 May 2016 18:19:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2C7AB1B1CFF
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 00:19:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1C87EB5045
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 00:19:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 27EC1A90C
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 00:19:13 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1462488709-13031-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 06, 2016 at 12:51:46AM +0200, Florian Westphal wrote:
> This series removes the per-namespace duplication of the expectation table.
> We use one table for all namespaces, using net_hash_mix(net) as additional
> hash seed so entries are spread evenly even if addresses overlap.
> 
> The max limit was already global, even before this patch.
> couting is still done per namespace.

Series applied, thanks Florian.
