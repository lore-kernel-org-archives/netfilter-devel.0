From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: xt_connlimit: honor conntrack zone if
 available
Date: Mon, 17 Nov 2014 12:45:48 +0100
Message-ID: <20141117114548.GA9067@salvia>
References: <1415967708-15492-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42879 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbaKQLnq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:43:46 -0500
Content-Disposition: inline
In-Reply-To: <1415967708-15492-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 14, 2014 at 01:21:48PM +0100, Florian Westphal wrote:
> Currently all the conntrack lookups are done using default zone.
> In case the skb has a ct attached (e.g. template) we should use this zone
> for lookups instead.  This makes connlimit work with connections assigned
> to other zones.

Applied to nf-next, thanks Florian!
