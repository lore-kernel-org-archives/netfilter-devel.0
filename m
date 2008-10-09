From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/8] [PATCH] get rid of module refcounting in ctnetlink
Date: Thu, 09 Oct 2008 15:26:29 +0200
Message-ID: <48EE0685.30308@trash.net>
References: <20081009083339.9824.24056.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51161 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988AbYJIN0c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:26:32 -0400
In-Reply-To: <20081009083339.9824.24056.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch replaces the unnecessary module refcounting with
> the read-side locks. With this patch, all the dump and fill_info
> function are called under the RCU read lock.
> 
> Based on a patch from Fabian Hugelshofer.

Applied, thanks.

Some of the new rcu_read_locks wouldn't have been necessary though
since some of the paths can only be reached through nf_hook_slow,
which already does rcu_read_lock() (and we're relying on that in
many spots).

