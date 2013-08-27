From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ip[6]t_REJECT: tcp-reset using wrong MAC
 source if bridged
Date: Wed, 28 Aug 2013 00:49:08 +0200
Message-ID: <20130827224908.GA15535@localhost>
References: <20130626211627.GA22947@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43798 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab3H0WtT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Aug 2013 18:49:19 -0400
Content-Disposition: inline
In-Reply-To: <20130626211627.GA22947@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 26, 2013 at 05:16:28PM -0400, Phil Oester wrote:
> As reported by Casper Gripenberg, in a bridged setup, using ip[6]t_REJECT
> with the tcp-reset option sends out reset packets with the src MAC address
> of the local bridge interface, instead of the MAC address of the intended
> destination.  This causes some routers/firewalls to drop the reset packet
> as it appears to be spoofed.  Fix this by bypassing ip[6]_local_out and
> setting the MAC of the sender in the tcp reset packet. 
> 
> This closes netfilter bugzilla #531.

Applied, thanks Phil.
