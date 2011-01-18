From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_conntrack snmp helper
Date: Tue, 18 Jan 2011 14:45:34 +0100
Message-ID: <4D35997E.6060502@trash.net>
References: <20110114201805.GC4546@jolsa.brq.redhat.com> <4D31C804.5090304@trash.net> <20110117094547.GA1918@jolsa.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, Tim Waugh <twaugh@redhat.com>,
	netfilter-devel@vger.kernel.org
To: Jiri Olsa <jolsa@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55865 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1ARNpg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 08:45:36 -0500
In-Reply-To: <20110117094547.GA1918@jolsa.brq.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17.01.2011 10:45, Jiri Olsa wrote:
> hi,
> thanks for comments, attaching new patch

> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -28,7 +28,8 @@ obj-$(CONFIG_NF_CONNTRACK_AMANDA) += nf_conntrack_amanda.o
>  obj-$(CONFIG_NF_CONNTRACK_FTP) += nf_conntrack_ftp.o
>  obj-$(CONFIG_NF_CONNTRACK_H323) += nf_conntrack_h323.o
>  obj-$(CONFIG_NF_CONNTRACK_IRC) += nf_conntrack_irc.o
> -obj-$(CONFIG_NF_CONNTRACK_NETBIOS_NS) += nf_conntrack_netbios_ns.o
> +obj-$(CONFIG_NF_CONNTRACK_NETBIOS_NS) += nf_conntrack_netbios_ns.o nf_conntrack_broadcast.o
> +obj-$(CONFIG_NF_CONNTRACK_SNMP) += nf_conntrack_snmp.o nf_conntrack_broadcast.o

Just add an EXPORT_SYMBOL_GPL'ed function and a new Kconfig
symbol for the nf_conntrack_broadcast.o file that is selected
by NETBIOS_NS and SNMP.

>  obj-$(CONFIG_NF_CONNTRACK_PPTP) += nf_conntrack_pptp.o
>  obj-$(CONFIG_NF_CONNTRACK_SANE) += nf_conntrack_sane.o
>  obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
> diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
> new file mode 100644
> index 0000000..fb48be1
> --- /dev/null
> +++ b/net/netfilter/nf_conntrack_broadcast.c
> @@ -0,0 +1,79 @@
> +/*
> + *      broadcast connection tracking helper
> + *
> + *      (c) 2011 Jiri Olsa <jolsa@redhat.com>

I'd also prefer if you keep my copyright statement from
the netbios ns file.

> + *
> + *      This program is free software; you can redistribute it and/or
> + *      modify it under the terms of the GNU General Public License
> + *      as published by the Free Software Foundation; either version
> + *      2 of the License, or (at your option) any later version.
> + */
