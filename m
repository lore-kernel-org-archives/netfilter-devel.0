From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: cttimeout: fix deadlock due to erroneous
 unlock/lock conversion
Date: Mon, 1 Feb 2016 18:39:15 +0100
Message-ID: <20160201173915.GA1299@salvia>
References: <1453983419-28688-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, sasha.levin@oracle.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45214 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbcBARjT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 12:39:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6D4CAE6664
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 18:39:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5D555DA804
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 18:39:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7EE12DA801
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 18:39:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453983419-28688-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 28, 2016 at 01:16:59PM +0100, Florian Westphal wrote:
> The spin_unlock call should have been left as-is, revert.
> 
> Fixes: b16c29191dc89bd ("netfilter: nf_conntrack: use safer way to lock all buckets")
> Reported-by: kernel test robot <fengguang.wu@intel.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Florian, thanks for resolving this problems. Applied, thanks.
