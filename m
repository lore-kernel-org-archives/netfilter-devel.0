From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] netfilter: nfnetlink_queue: some optimizations
Date: Wed, 09 Jun 2010 18:08:14 +0200
Message-ID: <4C0FBC6E.3080607@trash.net>
References: <1276097354.2442.189.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37151 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab0FIQIM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:08:12 -0400
In-Reply-To: <1276097354.2442.189.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> - Use an atomic_t for id_sequence to avoid a spin_lock/spin_unlock pair
>
> - Group highly modified struct nfqnl_instance fields together
Applied, thanks Eric.

