From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] xt_rateest: Better struct xt_rateest layout
Date: Tue, 08 Jun 2010 14:12:36 +0200
Message-ID: <4C0E33B4.1030501@trash.net>
References: <1275941837.2775.7.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netdev <netdev@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41763 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab0FHMMn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:12:43 -0400
In-Reply-To: <1275941837.2775.7.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.06.2010 22:17, Eric Dumazet wrote:
> We currently dirty two cache lines in struct xt_rateest, this hurts SMP
> performance.
> 
> This patch moves lock/bstats/rstats at beginning of structure so that
> they share a single cache line.

Applied, thanks Eric.
