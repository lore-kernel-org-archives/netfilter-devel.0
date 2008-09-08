From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 01/04]: netfilter: nf_conntrack_sip: de-static helper
 pointers
Date: Sun, 07 Sep 2008 18:19:34 -0700 (PDT)
Message-ID: <20080907.181934.262412289.davem@davemloft.net>
References: <20080904141553.6414.87829.sendpatchset@x2.localnet>
	<20080904141554.6414.14525.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53246
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbYIHBTl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Sep 2008 21:19:41 -0400
In-Reply-To: <20080904141554.6414.14525.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu,  4 Sep 2008 16:15:54 +0200 (MEST)

>     netfilter: nf_conntrack_sip: de-static helper pointers
>     
>     Helper's ->help hook can run concurrently with itself, so iterating over
>     SIP helpers with static pointer won't work reliably.
>     
>     Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
