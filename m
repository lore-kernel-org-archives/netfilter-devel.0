From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH] netfilter: synproxy: fix BUG_ON triggered by corrupt
 TCP packets
Date: Mon, 30 Sep 2013 12:43:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1309301241400.8972@ask.diku.dk>
References: <1380527506-27585-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>,
	mph@one.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:35485 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab3I3LEK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:04:10 -0400
In-Reply-To: <1380527506-27585-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 30 Sep 2013, Patrick McHardy wrote:

> TCP packets hitting the SYN proxy through the SYNPROXY target are not
> validated by TCP conntrack. When th->doff is below 5, an underflow happens
> when calculating the options length, causing skb_header_pointer() to
> return NULL and triggering the BUG_ON().
>
> Handle this case gracefully by checking for NULL instead of using BUG_ON().
>
> Reported-by: Martin Topholm <mph@one.com>
> Tested-by: Martin Topholm <mph@one.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> ---

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks for fixing this!

Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
