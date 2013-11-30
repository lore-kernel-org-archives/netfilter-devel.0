From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nftables: segfault in top scope define
Date: Sat, 30 Nov 2013 21:53:17 +0100
Message-ID: <20131130205317.GA8306@localhost>
References: <20131129203003.GA22533@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51246 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab3K3UxX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 15:53:23 -0500
Content-Disposition: inline
In-Reply-To: <20131129203003.GA22533@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 29, 2013 at 12:30:04PM -0800, Phil Oester wrote:
> Nftables segfaults if a symbol is added in top_scope, because of a missing
> init_list_head.  Trivial example:
> 
>     define ip_set = {192.168.1.2, 192.168.2.3}
>     add rule filter output ip daddr $ip_set counter
> 
> This closes netfilter bugzilla #877.

Applied, thanks Phil!
