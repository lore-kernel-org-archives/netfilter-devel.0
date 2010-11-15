From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: add __rcu annotations
Date: Mon, 15 Nov 2010 18:44:42 +0100
Message-ID: <4CE1718A.4060209@trash.net>
References: <1289841688.2607.102.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36541 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279Ab0KORoo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:44:44 -0500
In-Reply-To: <1289841688.2607.102.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 15.11.2010 18:21, schrieb Eric Dumazet:
> Use helpers to reduce number of sparse warnings
> (CONFIG_SPARSE_RCU_POINTER=y)

Applied, thanks Eric.
