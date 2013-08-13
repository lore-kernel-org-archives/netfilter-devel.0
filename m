From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnf-queue] build: avoid sym namespace pollution
Date: Tue, 13 Aug 2013 18:15:51 +0200
Message-ID: <20130813161551.GA3901@localhost>
References: <1376383730-11731-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55516 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248Ab3HMQP4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:15:56 -0400
Content-Disposition: inline
In-Reply-To: <1376383730-11731-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 13, 2013 at 10:48:50AM +0200, Florian Westphal wrote:
> as of f40eabb01 (add pkt_buff and protocol helper functions)
> lnetfilter_queue exports a function named 'checksum'.  This is a bit
> too generic and causes crash with applications that worked fine before.

I see, that was not the intention as they are supposed to be internal
(as you can see in src/internal.h), however, it seems that the
visibility changes were incomplete, sorry.

> This patch makes the functions checksum, checksum_tcpudp_ipv4 and
> checksum_tcpudp_ipv6 local by building with fvis-hidden and adding
> EXPORTs for the legacy api calls and the ones that seem to have missing
> EXPORT tags (mainly pktbuf api).

I have applied this, thanks Florian.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Alternative would be to rename "checksum" to something

I have just renamed those, even if they are internal I think it's a
good cleanup.
