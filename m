From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 05/07]: remove unneeded rcu_dereference() calls
Date: Mon, 05 Nov 2007 20:43:38 -0800 (PST)
Message-ID: <20071105.204338.52804249.davem@davemloft.net>
References: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
	<20071102112007.22803.32649.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49071
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756107AbXKFEnj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2007 23:43:39 -0500
In-Reply-To: <20071102112007.22803.32649.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Fri,  2 Nov 2007 12:23:17 +0100 (MET)

> [NETFILTER]: remove unneeded rcu_dereference() calls
> 
> As noticed by Paul McKenney, the rcu_dereference calls in the init path
> of NAT modules are unneeded, remove them.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
