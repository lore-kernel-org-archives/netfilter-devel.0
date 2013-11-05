From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/4] build: resolve build errors in dependent programs
Date: Tue, 5 Nov 2013 13:56:28 +0100
Message-ID: <20131105125628.GB29010@localhost>
References: <1382963240-18760-1-git-send-email-jengelh@inai.de>
 <1382963240-18760-3-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52563 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab3KEM4g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:56:36 -0500
Content-Disposition: inline
In-Reply-To: <1382963240-18760-3-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 28, 2013 at 01:27:18PM +0100, Jan Engelhardt wrote:
> The headers do not compile standalone, which also causes nftables to
> fail to build for the same reason.

I fail to reproduce this compilation nftables breakage. It's clear
that third party application will do, so I have mangled the changelog.

> 	$ gcc -x c -Wall -c *.h
> 	chain.h:62:35: error: unknown type name =E2=80=98size_t=E2=80=99
> 	expr.h:40:39: error: unknown type name =E2=80=98size_t=E2=80=99
> 	rule.h:60:34: error: unknown type name =E2=80=98size_t=E2=80=99
> 	ruleset.h:20:1: error: unknown type name =E2=80=98bool=E2=80=99
> 	ruleset.h:20:59: error: unknown type name =E2=80=98uint16_t=E2=80=99
> 	ruleset.h:21:52: error: unknown type name =E2=80=98uint16_t=E2=80=99
> 	ruleset.h:22:50: error: unknown type name =E2=80=98uint16_t=E2=80=99
> 	ruleset.h:23:63: error: unknown type name =E2=80=98uint16_t=E2=80=99
> 	ruleset.h:39:37: error: unknown type name =E2=80=98size_t=E2=80=99
> 	ruleset.h:39:80: error: unknown type name =E2=80=98uint32_t=E2=80=99
> 	ruleset.h:39:95: error: unknown type name =E2=80=98uint32_t=E2=80=99
> 	set.h:40:33: error: unknown type name =E2=80=98size_t=E2=80=99
> 	set.h:110:38: error: unknown type name =E2=80=98size_t=E2=80=99
> 	table.h:50:35: error: unknown type name =E2=80=98size_t=E2=80=99

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
