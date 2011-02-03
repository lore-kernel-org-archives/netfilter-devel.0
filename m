From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd2: build fixes
Date: Thu, 03 Feb 2011 18:17:47 +0100
Message-ID: <4D4AE33B.4060504@netfilter.org>
References: <1296683468-30413-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57027 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170Ab1BCRRu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:17:50 -0500
In-Reply-To: <1296683468-30413-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/02/11 22:51, Jan Engelhardt wrote:
> The following changes since commit 4f652cc32aebeac20f46009f146ad973a1ed0e99:
> 
>   NFCT: fix bug in polling mode (2010-12-09 12:02:15 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/ulogd2 master
> 
> Jan Engelhardt (3):
>       build: avoid use of LIBS variable
>       build: use appropriate location for program modules
>       build: use compile/link information from pkgconfig

Pulled and pushed out, thanks!

> Pablo Neira Ayuso (1):
>       ulogd: fix double call of stop for reused input plugins

Hm, this seems to have slipped through :-)

