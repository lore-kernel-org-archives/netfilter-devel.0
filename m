From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2 v2] New netfilter target to trigger LED devices
Date: Thu, 13 Nov 2008 16:56:47 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811131653030.13330@fbirervta.pbzchgretzou.qr>
References: <49196D3E.5080305@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44436 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYKMP4u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Nov 2008 10:56:50 -0500
In-Reply-To: <49196D3E.5080305@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-11-11 12:32, Adam Nielsen wrote:
> +/*
> + * Known issues:
> + *
> + *  - It's possible to add multiple led triggers with the same name (as
> + *    set with --led-trigger-id)
> + *
> + */

So fix this?

> +	/* If the timer has expired while we're changing the state, then don't
> +	   interfere.  We also don't want to twiddle with anything after the
> +	   mutex is unlocked, because by then a new timeout will have been
> +	   set. */

Not that it is overly important, but the comment style generally
seems to be (for multilines)
m{^(\s+)/\*\n(\1 \* \w+\n)+\1 \*/\n}
