From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] evaluate: reject: fix a crash to use tcp reset with
 network context in bridge
Date: Tue, 25 Nov 2014 18:13:28 +0100
Message-ID: <20141125171328.GA6324@salvia>
References: <1416856857-15768-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37297 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaKYRLf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:11:35 -0500
Content-Disposition: inline
In-Reply-To: <1416856857-15768-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 24, 2014 at 08:20:57PM +0100, Alvaro Neira Ayuso wrote:
> If we use tcp reset with a network protocol that it's not supported, we send an
> error message. In that case reject.expr is NULL and we have a crash. Therefore
> we have to use the stmt to indicate that the error comes from the reject.

Please, reword this title and description. I can see you're fixing
this by passing the stmt->location instead of the reject expression,
which is NULL in this case.

Thanks.
