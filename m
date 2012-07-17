From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] libxt_HMARK: remove -set fix spi syntax and add
 hton{s,l}
Date: Tue, 17 Jul 2012 18:30:12 +0200
Message-ID: <20120717163012.GA28247@1984>
References: <1342527949-17589-1-git-send-email-hans@schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45751 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab2GQQaQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:30:16 -0400
Content-Disposition: inline
In-Reply-To: <1342527949-17589-1-git-send-email-hans@schillstrom.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 17, 2012 at 02:25:49PM +0200, Hans Schillstrom wrote:
> Correct a number of errors introduced by Pablos rework
> 
> -set removed in all commands, iptables-save syntax must be valid.
> xxx-set also removed in print commands.
> Mix of spi and spi-mask fixed.
> Added ntohX again for all ports and spi values.
> Restore of spi / port  validation.
> 
> Remove --hmark-offset as mandatory.

Applied, thanks Hans.
