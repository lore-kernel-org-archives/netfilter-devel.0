From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] netfilter: queue: rwlock to spinlock conversion
Date: Wed, 09 Jun 2010 15:49:01 +0200
Message-ID: <4C0F9BCD.2040605@trash.net>
References: <1276002860.2486.22.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34687 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab0FINs7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jun 2010 09:48:59 -0400
In-Reply-To: <1276002860.2486.22.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> Converts queue_lock rwlock to a spinlock.
>
> (readlocked part can be changed by reads of integer values)
>
> One atomic operation instead of four per ipq_enqueue_packet() call.

Looks fine to me, applied, thanks Eric.

Just wondering since ip_queue is actually obsoleted, do you intend to
change ip6_queue and nfnetlink_queue in a similar fashion?

