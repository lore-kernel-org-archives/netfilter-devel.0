From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nf_nat: dont check for port change on ICMP tuples
Date: Sun, 28 Oct 2012 23:49:56 +0100
Message-ID: <20121028224956.GA828@1984>
References: <20121025153445.GA22403@uweber-WS>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ulrich Weber <ulrich.weber@sophos.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33460 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab2J1WuC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Oct 2012 18:50:02 -0400
Content-Disposition: inline
In-Reply-To: <20121025153445.GA22403@uweber-WS>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 25, 2012 at 05:34:45PM +0200, Ulrich Weber wrote:
> ICMP tuples have id in src and type/code in dst.
> So comparing src.u.all with dst.u.all will always fail here
> and ip_xfrm_me_harder() is called for every ICMP packet,
> even if there was no NAT...

Tracking the history, this seems to be there since really long time
ago. I'll pass a backport of this to -stable.

Applied, thanks Ulrich.
