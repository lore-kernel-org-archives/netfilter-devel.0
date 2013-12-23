From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] build: properly handle
 --without-{xml,json}-parsing
Date: Mon, 23 Dec 2013 13:51:41 +0100
Message-ID: <20131223125141.GA28923@localhost>
References: <1387790097-9314-1-git-send-email-dwfreed@mtu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Douglas Freed <dwfreed@mtu.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35900 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990Ab3LWMvu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Dec 2013 07:51:50 -0500
Content-Disposition: inline
In-Reply-To: <1387790097-9314-1-git-send-email-dwfreed@mtu.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 23, 2013 at 09:14:57AM +0000, Douglas Freed wrote:
> This patch fixes how --without-{xml,json}-parsing (and subsequently
> --with-{xml,json}-parsing=no) is handled.  Prior to this,
> --without-{xml,json}-parsing actually resulted in libnftables being
> built with that parsing enabled.

Applied, thanks.
