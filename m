From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] xtables: use guarded types
Date: Wed, 15 Dec 2010 23:20:31 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012152319550.2669@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1012032012320.26825@obet.zrqbmnf.qr> <4D00B2D7.4010401@netfilter.org> <alpine.LNX.2.01.1012092024000.30670@obet.zrqbmnf.qr> <4D01FFC5.90808@netfilter.org> <4D093A49.2060500@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45282 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab0LOWUc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:20:32 -0500
In-Reply-To: <4D093A49.2060500@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-12-15 22:59, Patrick McHardy wrote:
>
>Well, we can resync userspace, but the __ types specifically exist
>to avoid namespace polution.
>
>Applied, thanks.
>
>I'll also gladly apply a patch to get rid of the u_int_XX crap.

To be found where? (Choose: kernel/userspace/both)
