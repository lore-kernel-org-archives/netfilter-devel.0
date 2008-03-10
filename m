From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/09]: Netfilter fixes
Date: Mon, 10 Mar 2008 16:45:30 -0700 (PDT)
Message-ID: <20080310.164530.193712196.davem@davemloft.net>
References: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33736
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbYCJXp0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:45:26 -0400
In-Reply-To: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 10 Mar 2008 19:26:13 +0100 (MET)

> these patches contain some netfilter fixes for 2.6.25, fixing undersized
> skb allocation and incorrect EPERM errors in nfnetlink_queue and
> nfnetlink_log, an xt_time bug that causes mismatches on Sundays, a
> missing newline in a conntrack message and the "horrible hack" in
> ct_extend.

All applied and pushed out to net-2.6, thanks Patrick!
