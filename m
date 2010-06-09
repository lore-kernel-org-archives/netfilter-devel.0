From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] netfilter: ip6queue: rwlock to spinlock conversion
Date: Wed, 09 Jun 2010 16:25:56 +0200
Message-ID: <4C0FA474.4030003@trash.net>
References: <1276002860.2486.22.camel@edumazet-laptop>	 <4C0F9BCD.2040605@trash.net> <1276092053.2442.142.camel@edumazet-laptop>	 <4C0F9EED.2020007@trash.net> <1276093202.2442.145.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35501 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab0FIOZw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jun 2010 10:25:52 -0400
In-Reply-To: <1276093202.2442.145.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> Converts queue_lock rwlock to a spinlock.
>
> (readlocked part can be changed by reads of integer values)
>
> One atomic operation instead of four per ipq_enqueue_packet() call.
>   

Applied, thanks Eric.
