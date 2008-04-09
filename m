From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 1/2]: xt_hashlimit: fix mask calculation
Date: Wed, 09 Apr 2008 15:15:19 -0700 (PDT)
Message-ID: <20080409.151519.263185427.davem@davemloft.net>
References: <47FA0C1C.70301@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47291
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbYDIWPS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:15:18 -0400
In-Reply-To: <47FA0C1C.70301@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 07 Apr 2008 13:57:16 +0200

> The following two patches fix an invalid mask calculation
> in xt_hashlimit for prefix-lengths of 32 and add a missing
> module dependency from nf_nat to nf_conntrack_ipv4.
> 
> Please apply, thanks.

Both applied to net-2.6, thanks Patrick!
