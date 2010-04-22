From: David Miller <davem@davemloft.net>
Subject: Re: DDoS attack causing bad effect on conntrack searches
Date: Thu, 22 Apr 2010 16:44:25 -0700 (PDT)
Message-ID: <20100422.164425.171794554.davem@davemloft.net>
References: <Pine.LNX.4.64.1004222213290.10919@ask.diku.dk>
	<1271970199.7895.6482.camel@edumazet-laptop>
	<1271970893.7895.6507.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: hawk@diku.dk, paulmck@linux.vnet.ibm.com, kaber@trash.net,
	xiaosuo@gmail.com, hawk@comx.dk, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: eric.dumazet@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47134
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697Ab0DVXoV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 19:44:21 -0400
In-Reply-To: <1271970893.7895.6507.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Eric, I wonder if we run into some kind of issue on 32-bit systems
because we always lose a bit of the conntrack hash value when we store
it into the 'nulls' area?

Wouldn't that make the "get_nulls_value(n) != hash" fail?
