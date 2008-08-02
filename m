From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: src: remove dependency on libiptc headers
Date: Sat, 02 Aug 2008 13:28:33 +0200
Message-ID: <489444E1.8060303@netfilter.org>
References: <alpine.LNX.1.10.0808010903020.31124@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37419 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752527AbYHBL2q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Aug 2008 07:28:46 -0400
In-Reply-To: <alpine.LNX.1.10.0808010903020.31124@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> --- a/include/libiptc/libxtc.h
> +++ b/include/libiptc/libxtc.h
> @@ -20,8 +20,6 @@ extern "C" {
>  #define XT_ALIGN(s) (((s) + ((XT_MIN_ALIGN)-1)) & ~((XT_MIN_ALIGN)-1))
>  #endif
>  
> -typedef char xt_chainlabel[32];
> -
>  #define XTC_LABEL_ACCEPT  "ACCEPT"
>  #define XTC_LABEL_DROP    "DROP"
>  #define XTC_LABEL_QUEUE   "QUEUE"
> diff --git a/include/xtables.h.in b/include/xtables.h.in
> index 4ce73e9..51cb67d 100644
> --- a/include/xtables.h.in
> +++ b/include/xtables.h.in
> @@ -1,11 +1,12 @@
>  #ifndef _XTABLES_H
>  #define _XTABLES_H
>  
> +#include <sys/socket.h> /* PF_* */
>  #include <sys/types.h>
> +#include <stdbool.h>
> +#include <net/if.h>
>  #include <linux/types.h>
>  #include <linux/netfilter/x_tables.h>
> -#include <libiptc/libxtc.h>
> -#include <stdbool.h>
>  
>  #ifndef IPPROTO_SCTP
>  #define IPPROTO_SCTP 132
> @@ -22,12 +23,14 @@
>  
>  #define XTABLES_API_VERSION(x,y,z)    (0x10000*(x) + 0x100*(y) + z)
>  
> +struct in_addr;
> +
>  /* Include file for additions: new matches and targets. */
>  struct xtables_match
>  {
>  	struct xtables_match *next;
>  
> -	xt_chainlabel name;
> +	const char *name;
>  
>  	/* Revision of match (0 by default). */
>  	u_int8_t revision;
> @@ -83,7 +86,7 @@ struct xtables_target
>  {
>  	struct xtables_target *next;
>  
> -	xt_chainlabel name;
> +	const char *name;

This is breaking the ABI. You're replacing at field of 32 bytes by one
of 4 bytes.

As we discussed in your previous patch, if your intention is to export
the xtables.h file and make it a public API for other external clients,
you must understand that you should not change a single line of headers
otherwise you may end up breaking backward compatibility (compilation
and binary) for others.

BTW, about the C++ support for xtables. Would we provide support to such
external plugin here? I think that we'll end up telling that we don't
recommend C++ plugins for iptables. I think that we should remove that
support now.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
