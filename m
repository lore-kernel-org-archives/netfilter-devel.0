From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter: xt_comment: drop unneeded unsigned qualifier
Date: Wed, 12 Jan 2011 21:31:00 +0100
Message-ID: <4D2E0F84.1070509@netfilter.org>
References: <alpine.LNX.2.01.1012261022030.5017@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47204 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab1ALUbH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:31:07 -0500
In-Reply-To: <alpine.LNX.2.01.1012261022030.5017@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26/12/10 10:22, Jan Engelhardt wrote:
> parent 0167acf6cbdf1d70d1540e61680d8301c0c388fb (v2.6.37-rc1-237-g0167acf)
> commit c21eb58de7b4d9c6bb406fd0b08388e6eb76a106
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Sun Dec 26 10:21:19 2010 +0100
> 
> netfilter: xt_comment: drop unneeded unsigned qualifier
> 
> Since a string is stored, and not something like a MAC address that
> would rely on (un)signedness, drop the qualifier.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Applied for nf-next, thanks.
