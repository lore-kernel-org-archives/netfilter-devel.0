From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: xtables: fix reentrancy
Date: Sun, 20 Mar 2011 15:40:43 +0100
Message-ID: <4D8611EB.1080404@trash.net>
References: <1300467921.2888.157.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44651 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1CTOkp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Mar 2011 10:40:45 -0400
In-Reply-To: <1300467921.2888.157.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 18.03.2011 18:05, schrieb Eric Dumazet:
> commit f3c5c1bfd4308 (make ip_tables reentrant) introduced a race in
> handling the stackptr restore, at the end of ipt_do_table()
> 
> We should do it before the call to xt_info_rdunlock_bh(), or we allow
> cpu preemption and another cpu overwrites stackptr of original one.
> 
> A second fix is to change the underflow test to check the origptr value
> instead of 0 to detect underflow, or else we allow a jump from different
> hooks.

Applied, thanks Eric.
