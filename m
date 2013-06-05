From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/3] examples: delete payload code in
 nft-chain-add
Date: Wed, 5 Jun 2013 05:52:29 +0200
Message-ID: <20130605035229.GA1504@localhost>
References: <1370333124-11674-1-git-send-email-eric@regit.org>
 <1370333124-11674-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33289 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab3FEDwe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 23:52:34 -0400
Content-Disposition: inline
In-Reply-To: <1370333124-11674-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 04, 2013 at 10:05:21AM +0200, Eric Leblond wrote:
> 'make check' was not working due to the fact that
> 'libnftables/payload.h' was not present.

Oops, that file was dead lying on my filesystem, applied a fix for
this.

> As the payload related code was commented, the "I've got an axe"
> solution was to remove all payload related code. This is done in
> this patch.

I prefered to keep the payload example, so apply a different fix.
Thanks for the spots anyway.
