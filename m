From: <abirvalg@lavabit.com>
Subject: nfqueue library setup requires root
Date: Thu, 29 Dec 2011 14:00:19 +0000
Message-ID: <20111229140019.23841ead@wwwwww-701SD>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:41566 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab1L2KAq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 05:00:46 -0500
Received: from b.earth.lavabit.com (b.earth.lavabit.com [192.168.111.11])
	by karen.lavabit.com (Postfix) with ESMTP id 8555211BBD3
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Dec 2011 04:00:45 -0600 (CST)
Received: from wwwwww-701sd (user-26.81.118.217.in-addr.arpa [217.118.81.26])
	by lavabit.com with ESMTP id 20QQ3WQL18WM
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Dec 2011 04:00:45 -0600
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I launched my application with CAP_NET_ADMIN capability, yet both nfq_unbind_pf and nfq_bind_pf produce an error.
When I setuid(0) no error is produced and everything works as expected.
Could you please confirm that Library setup operations require root.
Isn't it a bit misleading that libnetfilter_queue docu states that CAP_NET_ADMIN is required without mentioning root permissions.
Would it be possible to do Library Setup with only CAP_NET_ADMIN and without root priviliges in future versions?

