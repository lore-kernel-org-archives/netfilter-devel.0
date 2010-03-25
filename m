From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_hashlimit: dl_seq_stop() fix
Date: Thu, 25 Mar 2010 11:01:56 +0100
Message-ID: <4BAB3494.4030402@trash.net>
References: <1269463664.2849.9.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
	netdev <netdev@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48047 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab0CYKB5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:01:57 -0400
In-Reply-To: <1269463664.2849.9.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> If dl_seq_start() memory allocation fails, we crash later in
> dl_seq_stop(), trying to kfree(ERR_PTR(-ENOMEM))

Seems pretty counter intuitive to me that ->stop is invoked after
->start returned an error.

Applied, thanks.
