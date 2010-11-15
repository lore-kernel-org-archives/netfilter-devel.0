From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: rcu sparse cleanups
Date: Mon, 15 Nov 2010 19:46:10 +0100
Message-ID: <4CE17FF2.4020000@trash.net>
References: <1289846348.2607.115.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37659 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab0KOSqN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:46:13 -0500
In-Reply-To: <1289846348.2607.115.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 15.11.2010 19:39, schrieb Eric Dumazet:
> Use RCU helpers to reduce number of sparse warnings
> (CONFIG_SPARSE_RCU_POINTER=y), and adds lockdep checks.

Applied, thanks Eric.
