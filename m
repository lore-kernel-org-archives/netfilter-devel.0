From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: use NFPROTO_IPV4 instead of AF_INET
Date: Thu, 16 Sep 2010 19:38:22 +0200
Message-ID: <4C92560E.1040902@trash.net>
References: <1282027632-13707-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49130 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab0IPRiY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:38:24 -0400
In-Reply-To: <1282027632-13707-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17.08.2010 08:47, Changli Gao wrote:
> The field family of xt_target should be NFPROTO_IPV4, though NFPROTO_IPV4
> and AF_INET are the same.

Applied, thanks.
