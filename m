From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 07/41: arp_tables: unfold two critical loops in
 arp_packet_match()
Date: Tue, 24 Mar 2009 14:16:07 -0700 (PDT)
Message-ID: <20090324.141607.97470957.davem@davemloft.net>
References: <20090324140312.31401.89168.sendpatchset@x2.localnet>
	<20090324.132954.148903398.davem@davemloft.net>
	<49C94B6A.5020304@cosmosbay.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: dada1@cosmosbay.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47158
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754383AbZCXVQU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:16:20 -0400
In-Reply-To: <49C94B6A.5020304@cosmosbay.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Tue, 24 Mar 2009 22:06:50 +0100

> [PATCH] arp_tables: ifname_compare() can assume 16bit alignment
> 
> Arches without efficient unaligned access can still perform a loop
> assuming 16bit alignment in ifname_compare()
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Looks great, applied, thanks Eric!
