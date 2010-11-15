From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: add __rcu annotations
Date: Mon, 15 Nov 2010 18:45:45 +0100
Message-ID: <4CE171C9.9080106@trash.net>
References: <1289841688.2607.102.camel@edumazet-laptop>	 <4CE16D38.5030506@trash.net> <1289842364.2607.107.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36568 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227Ab0KORpr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:45:47 -0500
In-Reply-To: <1289842364.2607.107.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 15.11.2010 18:32, schrieb Eric Dumazet:
> [PATCH] netfilter/amanda: rename a variable
> 
> Avoid a sparse warning about 'ret' variable shadowing

Applied, thanks Eric.

