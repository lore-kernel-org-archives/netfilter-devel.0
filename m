From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ebtables: remove unneeded initializations
Date: Mon, 09 Feb 2009 17:30:26 +0100
Message-ID: <49905A22.5040803@trash.net>
References: <20090204001202.724266235@vyatta.com>	<20090204001755.685385465@vyatta.com>	<49904DB3.60004@trash.net> <20090209082419.064bb842@extreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
	Rick Jones <rick.jones2@hp.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Eric Dumazet <dada1@cosmosbay.com>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58831 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbZBIQa3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:30:29 -0500
In-Reply-To: <20090209082419.064bb842@extreme>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Hemminger wrote:
> The initialization of the lock element is not needed
> since the lock is always initialized in ebt_register_table.

Also applied, thanks. I'll push out my current tree now, should be
on kernel.org in a few minutes.



