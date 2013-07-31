From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6/7] netfilter: conntrack: don't send destroy events from
 iterator
Date: Wed, 31 Jul 2013 19:04:36 +0200
Message-ID: <20130731170436.GF25900@localhost>
References: <1375105316-13216-1-git-send-email-fw@strlen.de>
 <1375105316-13216-7-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52427 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002Ab3GaREp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:04:45 -0400
Content-Disposition: inline
In-Reply-To: <1375105316-13216-7-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 29, 2013 at 03:41:55PM +0200, Florian Westphal wrote:
> Let nf_ct_delete handle delivery of the DESTROY event.
> 
> This means we now also no longer send such events for conntracks that
> are still unconfirmed.

Not sure why this happens by looking at the patch. Are you refering to
conntrack with IPS_CONFIRMED unset?
