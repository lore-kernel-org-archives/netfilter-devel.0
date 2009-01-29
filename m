From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 0/6] iptables: read/write lock elimination (v0.4)
Date: Thu, 29 Jan 2009 11:12:39 -0800
Message-ID: <20090129191239.483204605@vyatta.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from suva.vyatta.com ([76.74.103.44]:51503 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150AbZA2Ugd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:36:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an update to last round of patches, using Eric's suggestion
to move the sequence count to top level per cpu variable. Also encapsulated
the counter manipulation.
-- 

