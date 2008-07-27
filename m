From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 06/06: nf_conntrack_extend: avoid unnecessary
 "ct->ext" dereferences
Date: Sat, 26 Jul 2008 17:50:14 -0700 (PDT)
Message-ID: <20080726.175014.07248856.davem@davemloft.net>
References: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
	<20080726233714.15283.89711.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48130
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756518AbYG0AuO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 20:50:14 -0400
In-Reply-To: <20080726233714.15283.89711.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 27 Jul 2008 01:37:15 +0200 (MEST)

> netfilter: nf_conntrack_extend: avoid unnecessary "ct->ext" dereferences
> 
> As Linus points out, "ct->ext" and "new" are always equal, avoid unnecessary
> dereferences and use "new" directly.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks Patrick!
