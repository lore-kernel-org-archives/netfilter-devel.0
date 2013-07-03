From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnf-ct] src: callback: fix memory leak when ct has
 dynamically allocated attr
Date: Wed, 3 Jul 2013 12:55:54 +0200
Message-ID: <20130703105554.GA4437@localhost>
References: <1372848761-14444-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52237 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab3GCK4M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jul 2013 06:56:12 -0400
Content-Disposition: inline
In-Reply-To: <1372848761-14444-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 03, 2013 at 12:52:41PM +0200, Florian Westphal wrote:
> Must free ct and exp using the _destroy functions, else we leak attributes with malloc'd data.

Looks good, push it please.
