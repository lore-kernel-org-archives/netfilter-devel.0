From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: xtables make functions local
Date: Mon, 30 Dec 2013 18:19:42 +0100
Message-ID: <20131230171942.GA21263@localhost>
References: <20131227120937.702bc383@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36912 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341Ab3L3RTr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:19:47 -0500
Content-Disposition: inline
In-Reply-To: <20131227120937.702bc383@nehalam.linuxnetplumber.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 27, 2013 at 12:09:37PM -0800, Stephen Hemminger wrote:
> A couple of functions only used in x_tables, don't need to be global

Applied, thanks stephen.
