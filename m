From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nf-next: x_tables: Replace kmalloc(s*n) with
 kmalloc_array(n,s)
Date: Fri, 12 Aug 2016 01:13:52 +0200
Message-ID: <20160811231352.GA4972@salvia>
References: <20160810141146.GA22890@void>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Loganaden Velvindron <logan@hackers.mu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49340 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbcHKXN5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:13:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 677F31878BB
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:13:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 59CC09663E
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:13:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5CE4CFF154
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:13:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160810141146.GA22890@void>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 06:11:51PM +0400, Loganaden Velvindron wrote:
> It is easier to check that the calculation doesn't wrap or return a smaller
> allocation.

Could you review the netfilter tree in search for similar kmalloc()
invocation that can be replaced? I could at least find one more at
quick glace.

Thanks.
