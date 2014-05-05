From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ipv4: "conntrack zones" support for defrag user check in
 ip_expire
Date: Mon, 5 May 2014 16:07:38 +0200
Message-ID: <20140505140738.GA12005@localhost>
References: <536426BC.7020509@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53413 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438AbaEEOHr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 10:07:47 -0400
Content-Disposition: inline
In-Reply-To: <536426BC.7020509@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 03, 2014 at 03:14:04AM +0400, Vasily Averin wrote:
> Defrag user check in ip_expire was not updated after adding support for
> "conntrack zones"

Applied, thanks.
