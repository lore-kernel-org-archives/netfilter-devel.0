From: David Miller <davem@davemloft.net>
Subject: Re: NAT66 : A first implementation
Date: Thu, 14 Jul 2011 16:17:17 -0700 (PDT)
Message-ID: <20110714.161717.1387261665409519132.davem@davemloft.net>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr>
	<4E1F1902.9020605@student.ulg.ac.be>
	<alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: T.Moes@student.ulg.ac.be, netfilter-devel@vger.kernel.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:49082 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab1GNXTb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:19:31 -0400
In-Reply-To: <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>
Date: Fri, 15 Jul 2011 01:15:47 +0200 (CEST)

> Of course yours is feature-richer. But the topic of IPv6 NAT has had 
> come up a number of unrecollectable times, and the response has been the 
> same everytime - NAT is still an ugly undesired hack whose recurrence 
> wants to be avoided.

You can't avoid it.

People want to hide the details of the topology of their
internal networks, therefore we will have NAT with ipv6
no matter what we think or feel.

Everyone needs to stop being in denial, now.
