From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_quota: use per-rule spin lock
Date: Fri, 23 Jul 2010 14:04:24 +0200
Message-ID: <4C498548.1030307@trash.net>
References: <1279858053-14732-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36546 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab0GWMES (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:04:18 -0400
In-Reply-To: <1279858053-14732-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23.07.2010 06:07, Changli Gao wrote:
> xt_quota: use per-rule spin lock
> 
> use per-rule spin lock to improve the scalability.

Applied, thanks.
