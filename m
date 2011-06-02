From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_conntrack: remove one synchronize_net()
Date: Thu, 02 Jun 2011 15:00:32 +0200
Message-ID: <4DE78970.2020705@netfilter.org>
References: <1306509313.3445.5.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55856 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab1FBNAh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:00:37 -0400
In-Reply-To: <1306509313.3445.5.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27/05/11 17:15, Eric Dumazet wrote:
> No point to wait a rcu grace period before the unregisters.

applied, thanks
