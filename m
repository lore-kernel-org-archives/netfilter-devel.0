From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/5] netfilter: nf_nat: change sequence number
 adjustments to 32 bits
Date: Wed, 31 Jul 2013 19:58:50 +0200
Message-ID: <20130731175850.GA9609@localhost>
References: <1375044851-12471-1-git-send-email-kaber@trash.net>
 <1375044851-12471-5-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57066 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab3GaR6z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:58:55 -0400
Content-Disposition: inline
In-Reply-To: <1375044851-12471-5-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 28, 2013 at 10:54:10PM +0200, Patrick McHardy wrote:
> Using 16 bits is too small, when many adjustments happen the offsets might
> overflow and break the connection.

Applied, thanks.
