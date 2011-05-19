From: David Miller <davem@davemloft.net>
Subject: ipset return value in type_pf_tdel()
Date: Thu, 19 May 2011 19:09:37 -0400 (EDT)
Message-ID: <20110519.190937.1873377377043137868.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:35788 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933439Ab1ESXMq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 May 2011 19:12:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Variable 'ret' in this function is set but not used.

I'm thinking that the "return 0" should perhaps be "return ret"
but it maybe should not be and 'ret' should simply be deleted
entirely.

Please take a look at this.
