From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: unregister nf hooks, matches and targets in
 the reverse order
Date: Wed, 15 Sep 2010 19:32:43 +0200
Message-ID: <4C91033B.6070902@trash.net>
References: <1283436908-10744-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54943 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab0IORco (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:32:44 -0400
In-Reply-To: <1283436908-10744-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 02.09.2010 16:15, schrieb Changli Gao:
> Since we register nf hooks, matches and targets in order, we'd better
> unregister them in the reverse order.

Why? Is there a specific bug you've noticed?
