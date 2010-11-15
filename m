From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] netfilter: add __rcu annotations
Date: Mon, 15 Nov 2010 18:17:51 +0100
Message-ID: <4CE16B3F.7060800@trash.net>
References: <1289839592.2607.91.camel@edumazet-laptop>	 <4CE16591.9030504@trash.net> <1289840615.2607.96.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36061 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab0KORR4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:17:56 -0500
In-Reply-To: <1289840615.2607.96.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15.11.2010 18:03, Eric Dumazet wrote:
> netfilter: add __rcu annotations
> 
> Add some __rcu annotations and use helpers to reduce number of sparse
> warnings (CONFIG_SPARSE_RCU_POINTER=y)

Applied, thanks Eric.
