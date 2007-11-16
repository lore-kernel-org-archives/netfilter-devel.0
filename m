From: David Miller <davem@davemloft.net>
Subject: CONFIG_NETFILTER_ADVANCED
Date: Thu, 15 Nov 2007 16:01:10 -0800 (PST)
Message-ID: <20071115.160110.12856737.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57793
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759839AbXKPABL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:01:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Patrick I would like to propose that we do something similar to how we
handle all the non-trivial routing and TCP congestion control
settings.

And that is to have an "ADVANCED" guard that simply doesn't present
the myriad of netfilter modules and options we have.

Basically, if the user doesn't set CONFIG_NETFILTER_ADVANCED he gets
basic NAT and connection tracking support, that's it.

Or at least something along those lines.

Let me know what you think about this.  Linus has asked me for
something like this several times :)
