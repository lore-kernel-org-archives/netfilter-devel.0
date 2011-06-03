From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: option to disable /proc/net/nf_conntrack procfs [was Re: netfilter
 patches for 3.0.0-rc1]
Date: Fri, 03 Jun 2011 11:50:53 +0200
Message-ID: <4DE8AE7D.8060609@netfilter.org>
References: <4DE79466.6080400@netfilter.org> <alpine.LNX.2.01.1106031052210.32042@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56751 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1FCJvD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:51:03 -0400
In-Reply-To: <alpine.LNX.2.01.1106031052210.32042@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/06/11 10:53, Jan Engelhardt wrote:
> netfilter: provide config option to disable ancient procfs parts
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  net/netfilter/Kconfig                   |   10 ++++++++++
>  net/netfilter/nf_conntrack_expect.c     |   12 ++++++------
>  net/netfilter/nf_conntrack_standalone.c |    4 ++--
>  3 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index 32bff6d..e4b1076 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -75,6 +75,16 @@ config NF_CONNTRACK_ZONES
>  
>  	  If unsure, say `N'.
>  
> +config NF_CONNTRACK_PROCFS
> +	bool "Supply CT list in procfs (OBSOLETE)"
> +	default y
> +	depends on PROC_FS
> +	---help---
> +	This option enables for the list of known conntrack entries
> +	to be shown in procfs under net/netfilter/nf_conntrack. This
> +	is considered obsolete in favor of using the conntrack(8)
> +	tool which uses Netlink.
> +

This still misses /proc/net/ip_conntrack which would be available. See
nf_conntrack_l3proto_ipv4_compat.c
