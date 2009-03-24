From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 07/41: arp_tables: unfold two critical loops in
 arp_packet_match()
Date: Tue, 24 Mar 2009 14:25:57 -0700 (PDT)
Message-ID: <20090324.142557.198996961.davem@davemloft.net>
References: <alpine.LSU.2.00.0903242215590.26397@fbirervta.pbzchgretzou.qr>
	<20090324.141848.119353425.davem@davemloft.net>
	<alpine.LSU.2.00.0903242220280.26397@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: dada1@cosmosbay.com, kaber@trash.net, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53465
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbZCXV0J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:26:09 -0400
In-Reply-To: <alpine.LSU.2.00.0903242220280.26397@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>
Date: Tue, 24 Mar 2009 22:23:23 +0100 (CET)

> Is the cost of testing for non-4-divisibility expensive enough
> to warrant not usnig memcmp?

I think so.  This is the fast path of these things.

> Irrespective of all that, I think putting the interface comparison
> code should be agglomerated in a function/header so that it is
> replicated across iptables, ip6tables, ebtables, arptables, etc.

Agreed.
