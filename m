From: David Miller <davem@davemloft.net>
Subject: Re: netlink 02/08: add NLA_PUT_BE64 macro
Date: Mon, 21 Jul 2008 10:05:04 -0700 (PDT)
Message-ID: <20080721.100504.20503802.davem@davemloft.net>
References: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
	<20080721161725.28572.50686.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58542
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbYGURFE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:05:04 -0400
In-Reply-To: <20080721161725.28572.50686.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 21 Jul 2008 18:17:25 +0200 (MEST)

> netlink: add NLA_PUT_BE64 macro
> 
> Add NLA_PUT_BE64 macro required for 64bit counters in netfilter
> 
> Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
