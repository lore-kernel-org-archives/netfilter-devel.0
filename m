From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_TCPMSS: Add IPv6 default MSS
Date: Fri, 14 Jun 2013 18:03:16 +0200
Message-ID: <20130614160316.GA3592@localhost>
References: <20130610123038.GA5089@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46571 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab3FNQDV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:03:21 -0400
Content-Disposition: inline
In-Reply-To: <20130610123038.GA5089@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 10, 2013 at 08:30:38AM -0400, Phil Oester wrote:
> As a followup to commit 409b545a ("netfilter: xt_TCPMSS: Fix violation of RFC879
> in absence of MSS option"), John Heffner points out that IPv6 has a higher MTU
> than IPv4, and thus a higher minimum MSS.  Update TCPMSS target to account
> for this, and update RFC comment.

Applied, thanks.

Made some little mangling to pass the xt param.
