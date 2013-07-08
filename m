From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: allow service names in [DS]NAT targets
Date: Mon, 8 Jul 2013 05:16:45 +0200
Message-ID: <20130708031645.GA17472@localhost>
References: <20130627155409.GA8638@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53682 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3GHDRl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Jul 2013 23:17:41 -0400
Content-Disposition: inline
In-Reply-To: <20130627155409.GA8638@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 27, 2013 at 11:54:09AM -0400, Phil Oester wrote:
> As reported by Alexander Hoogerhuis, the [DS]NAT targets do not allow use of
> service names in the --to argument.  The same problem was fixed in the REDIRECT
> target in commit 84d758b3 ("extensions: REDIRECT: fix --to-ports parser").
> Use a similar fix here.

We also have libip6t_SNAT and libip6t_DNAT these days. Can you rework
the patch to support that there as well? Thanks.
