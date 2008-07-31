From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 01/03: nf_conntrack_tcp: decrease timeouts while
 data in unacknowledged
Date: Thu, 31 Jul 2008 00:38:07 -0700 (PDT)
Message-ID: <20080731.003807.193694867.davem@davemloft.net>
References: <20080731063312.18150.49494.sendpatchset@localhost.localdomain>
	<20080731063313.18150.27237.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54648
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753442AbYGaHiI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:38:08 -0400
In-Reply-To: <20080731063313.18150.27237.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 31 Jul 2008 08:33:14 +0200 (MEST)

> netfilter: nf_conntrack_tcp: decrease timeouts while data in unacknowledged
> 
> In order to time out dead connections quicker, keep track of outstanding data
> and cap the timeout.
> 
> Suggested by Herbert Xu.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
