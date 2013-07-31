From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/7] netfilter: tproxy: remove nf_tproxy_core.h
Date: Wed, 31 Jul 2013 18:58:23 +0200
Message-ID: <20130731165823.GD25900@localhost>
References: <1375105316-13216-1-git-send-email-fw@strlen.de>
 <1375105316-13216-5-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51596 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760518Ab3GaQ61 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:58:27 -0400
Content-Disposition: inline
In-Reply-To: <1375105316-13216-5-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 29, 2013 at 03:41:53PM +0200, Florian Westphal wrote:
> We've removed nf_tproxy_core.ko, so also remove its header.
> The lookup helpers are split and then moved to tproxy target/socket match.

Applied, thanks. Minor comestic change: I have fixed some comments
from:

/*
 * ... */

to:

/*
 * ...
 */
