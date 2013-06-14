From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_TCPMSS: Add safe fragmentation handling
Date: Fri, 14 Jun 2013 18:03:56 +0200
Message-ID: <20130614160356.GB3592@localhost>
References: <20130610040634.GB2742@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46693 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab3FNQEA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:04:00 -0400
Content-Disposition: inline
In-Reply-To: <20130610040634.GB2742@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 10, 2013 at 12:06:34AM -0400, Phil Oester wrote:
> Similar to commit bc6bcb59 ("netfilter: xt_TCPOPTSTRIP: fix possible mangling
> beyond packet boundary"), add safe fragment handling to xt_TCPMSS.

Applied, thanks.

I have used the previous changes to make it smaller.
