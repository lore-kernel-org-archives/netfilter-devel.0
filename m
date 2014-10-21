From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 4/4 v3] evaluate: fix a crash if we check the
 transport protocol is tcp
Date: Tue, 21 Oct 2014 10:15:22 +0200
Message-ID: <20141021081522.GB3628@salvia>
References: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com>
 <1413847780-10149-4-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54955 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbaJUINv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:13:51 -0400
Content-Disposition: inline
In-Reply-To: <1413847780-10149-4-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 21, 2014 at 01:29:40AM +0200, Alvaro Neira Ayuso wrote:
> Example:
> 
> nft add rule inet filter input meta l4proto udp reject with tcp reset
> 
> If we try to check if the transport protocol is tcp, we use the network context.
> If we don't have this network context, we have a crash.

I have applied this with minor changes.

Please, select the patch ordering carefully. This is a v3 coming as
the 4th patch in a batch.

Remember: Fixes always come in first place. Thanks.
