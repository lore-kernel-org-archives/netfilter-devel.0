From: David Miller <davem@davemloft.net>
Subject: Re: [RFC] SLOB breaks netfilter
Date: Tue, 07 Jun 2011 14:35:44 -0700 (PDT)
Message-ID: <20110607.143544.969037282692013955.davem@davemloft.net>
References: <20110607210651.GA11159@Chamillionaire.breakpoint.cc>
	<alpine.LNX.2.01.1106072316370.3052@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sebastian@breakpoint.cc, kaber@trash.net,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, tglx@linutronix.de
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:47879 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1FGVlA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:41:00 -0400
In-Reply-To: <alpine.LNX.2.01.1106072316370.3052@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>
Date: Tue, 7 Jun 2011 23:27:25 +0200 (CEST)

> THOUGH: I notice that alignof(uint64_t) yields 8 even for i586-linux-gnu
> mode, but for 32-bit mode, e % 4 is enough.
> To be investigated more tomorrow :)

You can thank the GCC developers for that.

