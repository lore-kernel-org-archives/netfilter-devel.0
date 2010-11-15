From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: add __rcu annotations
Date: Mon, 15 Nov 2010 18:26:16 +0100
Message-ID: <4CE16D38.5030506@trash.net>
References: <1289841688.2607.102.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36231 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab0KOR0S (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:26:18 -0500
In-Reply-To: <1289841688.2607.102.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15.11.2010 18:21, Eric Dumazet wrote:
> Use helpers to reduce number of sparse warnings
> (CONFIG_SPARSE_RCU_POINTER=y)
> 
> remove one variable in amanda, hiding a previous one.

nf_ct_expect_related() returns negative errno codes. It still
works, but I prefer the clarity of actually using a signed
variable for this. Unless you have strong feelings about this,
I'll remove that part from the patch.
