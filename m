From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: build: do not install ip{,6}tables.h
Date: Tue, 29 Jul 2008 13:57:12 +0200
Message-ID: <488F0598.40202@netfilter.org>
References: <alpine.LNX.1.10.0807281851030.15902@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41488 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753350AbYG2L5U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:57:20 -0400
In-Reply-To: <alpine.LNX.1.10.0807281851030.15902@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 9fbe00d1a9c1977233011690e00bab26c9cd4798
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Mon Jul 28 18:50:28 2008 -0400
> 
>     build: do not install ip{,6}tables.h
>     
>     These files do not contain anything that 3rd party modules could
>     reasonably use.
>     
>     Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  Makefile.am |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 49edbf8..48561b7 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -72,7 +72,7 @@ man_MANS         := iptables.8 iptables-restore.8 iptables-save.8 \
>                      ip6tables-save.8
>  CLEANFILES       := iptables.8 ip6tables.8
>  if ENABLE_DEVEL
> -include_HEADERS  := include/xtables.h include/iptables.h include/ip6tables.h
> +include_HEADERS  := include/xtables.h

Well, the same thing should apply for xtables.h. The iptables plugin API
has not been stable over the time. If we export that header file, we'll
have to get stuck to that API.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
