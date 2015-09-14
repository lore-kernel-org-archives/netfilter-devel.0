From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_log: don't zap all loggers on unregister
Date: Mon, 14 Sep 2015 14:50:50 +0200
Message-ID: <20150914125050.GA6864@salvia>
References: <1441760241-3220-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47679 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbbINMoO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Sep 2015 08:44:14 -0400
Content-Disposition: inline
In-Reply-To: <1441760241-3220-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 09, 2015 at 02:57:21AM +0200, Florian Westphal wrote:
> like nf_log_unset, nf_log_unregister must not reset the list of loggers.
> Otherwise, a call to nf_log_unregister() will render loggers of other nf
> protocols unusable:
> 
> iptables -A INPUT -j LOG
> modprobe nf_log_arp ; rmmod nf_log_arp
> iptables -A INPUT -j LOG
> iptables: No chain/target/match by that name

Applied, thanks Florian.

My scripts applies this cleanly to -stable:

3.18.x
4.1.x
4.2.x
