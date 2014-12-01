From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] scanner: fix reading of really long line
Date: Mon, 1 Dec 2014 12:55:34 +0100
Message-ID: <20141201115534.GA6170@salvia>
References: <1417278278-30206-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45227 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbaLALxe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:53:34 -0500
Content-Disposition: inline
In-Reply-To: <1417278278-30206-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 29, 2014 at 05:24:38PM +0100, Eric Leblond wrote:
> Current code is causing a failure in adding a set containing
> a really long list of elements. The failure occurs as soon as
> the line is longer than flex read buffer.
> 
> When a line is longer than scanner buffer size, the code in YY_INPUT
> forces a rewind to the beginning of the string because it does not
> find a end of line. The result is that the string is never parsed.
> 
> This patch updates the code by rewinding till we found a space.

But the part that didn't fit in will be ignore, right? So the user
will lose some elements in the set?

If so, I think it's better to spot an error via YY_FATAL_ERROR to
indicate that the line is too long to the user.
