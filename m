From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/5] Add support for SCTP
Date: Sun, 09 Dec 2007 20:13:55 +0100
Message-ID: <475C3E73.8080806@trash.net>
References: <475C3032.5040706@netfilter.org> <475C31EF.6040007@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60107 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXLITOM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 14:14:12 -0500
In-Reply-To: <475C31EF.6040007@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Strange, this patch has been mangled by quilt or something (duplicated
> #ifdef). Surprisingly, the compiler doesn't warn about it. New patch
> attached. Sorry.
>   

> --- net-2.6.git.orig/net/netfilter/nf_conntrack_proto_sctp.c	2007-12-08 21:42:27.000000000 +0100
> +++ net-2.6.git/net/netfilter/nf_conntrack_proto_sctp.c	2007-12-09 19:18:11.000000000 +0100
> @@ -619,6 +619,11 @@ static struct nf_conntrack_l4proto nf_co
> 	.packet 		= sctp_packet,
> 	.new 			= sctp_new,
> 	.me 			= THIS_MODULE,
> +#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
> +	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
> +	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
> +	.nla_policy		= nf_ct_port_nla_policy,
> +#endif
>  #ifdef CONFIG_SYSCTL
> 	.ctl_table_users	= &sctp_sysctl_table_users,
> 	.ctl_table_header	= &sctp_sysctl_header,



This patch is missing IPv6 support. I've applied it and copied this
chunk to the IPv6 struct since I assume that is what you wanted.

