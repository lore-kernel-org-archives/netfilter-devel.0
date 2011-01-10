From: Romain Francoise <romain@orebokech.com>
Subject: Re: collecting netfilter bugfixes for 2.6.37
Date: Mon, 10 Jan 2011 10:24:05 +0100
Message-ID: <87ei8l9kne.fsf@elegiac.orebokech.com>
References: <4D2A2ACC.6010906@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:40075 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab1AJJYQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jan 2011 04:24:16 -0500
In-Reply-To: <4D2A2ACC.6010906@netfilter.org> (Pablo Neira Ayuso's message of
	"Sun, 09 Jan 2011 22:38:20 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> While Patrick is not available, I have set up a tree to collect
> netfilter bugfixes that need to get into 2.6.37 asap. You can find
> them at:

> http://1984.lsi.us.es/git/?p=net-2.6/.git;a=summary

Not sure if this one is already going to -stable via davem, but I
don't see your own "netfilter: fix export secctx error handling" in
there (cba85b532e upstream).

Thanks.
