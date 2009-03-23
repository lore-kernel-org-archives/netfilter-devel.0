From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: drop packet without verdict from nfqueue after timeout
Date: Mon, 23 Mar 2009 20:18:45 +0100
Message-ID: <49C7E095.9020002@trash.net>
References: <1691181420.20090323214823@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Kuzin Andrey <kuzinandrey@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46688 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZCWTSt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:18:49 -0400
In-Reply-To: <1691181420.20090323214823@yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kuzin Andrey wrote:
> This is patch for problem with stucked packets in nf_queue if
> something going wrong in userspace program. Automatically drop packets
> without any verdict after timeout defined by NFQNL_TIMEOUT_ENTRY_DROP.

I don't want to add per-packet timeouts. The number one problem cause
I've seen in userspace programs so far has been "missed" packets by
incorrect application logic/error handling. These applications usually
continue to send verdicts, they just miss some packets, which accumulate
in the queue until it is full.

There's a very easy and cheap way to handle this. The packets have
sequence numbers and userspace should issues verdicts in ascending
order anyways to avoid reordering. Just add something that will drop
everything in the queue up to the sequence number contained in the
netlink message. And if you want to make it seem like something that
isn't just meant to work around buggy application behaviour, you can
use the same mechanism to add verdict batching :)

