From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] redir: fix snprintf to return the number of bytes printed
Date: Tue, 30 Jun 2015 02:04:48 +0200
Message-ID: <20150630000448.GA6641@salvia>
References: <1435312673-32048-1-git-send-email-balazs.scheidler@balabit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: balazs.scheidler@balabit.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38266 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbbF2X7Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 19:59:24 -0400
Content-Disposition: inline
In-Reply-To: <1435312673-32048-1-git-send-email-balazs.scheidler@balabit.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 26, 2015 at 11:57:53AM +0200, balazs.scheidler@balabit.com wrote:
> From: Balazs Scheidler <balazs.scheidler@balabit.com>
> 
> This fixes --debug netlink output when a redir target is included.

Applied to libnftnl, thanks Balazs.
