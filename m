From: David Miller <davem@davemloft.net>
Subject: [PATCH 0/4] Prevent UDP tunnels from operating on garbage socket
Date: Sun, 05 Apr 2015 22:18:47 -0400 (EDT)
Message-ID: <20150405.221847.2119086885797169021.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	hannes@stressinduktion.org, jiri@resnulli.us
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:41593 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbDFCSv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2015 22:18:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


So this should do the rest of the work such that when we encapsulate
into a UDP tunnel, the output path works on the UDP tunnel's socket
rather than skb->sk.

Part of this work is based upon changes done by Jiri Pirko some time
ago.

Basically the first step is to pass the socket through the nf_hook
okfn(), and then next we do the same for the UDP tunnel xmit routines.

Signed-off-by: David S. Miller <davem@davemloft.net>
