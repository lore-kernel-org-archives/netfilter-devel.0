From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xt_statistic: remove nth_lock spinlock
Date: Tue, 01 Jun 2010 12:01:22 +0200
Message-ID: <4C04DA72.5090501@trash.net>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>	 <1274861468.2672.9.camel@edumazet-laptop>	 <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>	 <1274874846.2672.192.camel@edumazet-laptop>	 <AANLkTilaed7xvxsrxYzub6-NogFHXKOlPtdnaXEgiYz5@mail.gmail.com> <1274876994.2672.215.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Changli Gao <xiaosuo@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44886 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0FAKB0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:01:26 -0400
In-Reply-To: <1274876994.2672.215.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> [PATCH v2] netfilter: xt_statistic: remove nth_lock spinlock
> 
> Use atomic_cmpxchg() to avoid dirtying a shared location.
> 
> xt_statistic_priv smp aligned to avoid sharing same cache line with
> other stuff.
> 

Applied, thanks Eric.
