From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH libnetfilter_queue] src: check result of malloc when
 creating queue
Date: Sun, 3 Jul 2016 09:55:47 +0200
Message-ID: <20160703075547.GA1916@breakpoint.cc>
References: <1467531482-28941-1-git-send-email-lists@inliniac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Victor Julien <victor@inliniac.net>
To: lists@inliniac.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53423 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbcGCHzx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jul 2016 03:55:53 -0400
Content-Disposition: inline
In-Reply-To: <1467531482-28941-1-git-send-email-lists@inliniac.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

lists@inliniac.net <lists@inliniac.net> wrote:
>  	qh = malloc(sizeof(*qh));
> +	if (!qh)
> +		return NULL;

Applied, thanks for spotting this.

