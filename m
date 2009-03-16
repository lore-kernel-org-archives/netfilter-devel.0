From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: (pull) pending patches
Date: Mon, 16 Mar 2009 09:38:11 +0100
Message-ID: <49BE0FF3.5090906@netfilter.org>
References: <alpine.LSU.2.00.0903152142090.17985@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35146 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752272AbZCPIiZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:38:25 -0400
In-Reply-To: <alpine.LSU.2.00.0903152142090.17985@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
> index f0a2369..b5f8028 100644
> --- a/extensions/libipt_DNAT.c
> +++ b/extensions/libipt_DNAT.c
> @@ -6,8 +6,9 @@
>  #include <getopt.h>
>  #include <xtables.h>
>  #include <iptables.h> /* get_kernel_version */
> +#include <limits.h> /* INT_MAX in ip_tables.h */
>  #include <linux/netfilter_ipv4/ip_tables.h>
> -#include <linux/netfilter/nf_nat.h>
> +#include <net/netfilter/nf_nat.h>

I thought that kernel headers under net/ are not ever exported to
userspace ?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
