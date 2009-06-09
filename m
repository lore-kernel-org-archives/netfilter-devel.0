From: Patrick McHardy <kaber@trash.net>
Subject: Re: [resend2 net-next] socket: added mtinfo with 'transparent' flag
Date: Tue, 09 Jun 2009 14:50:42 +0200
Message-ID: <4A2E5AA2.8020206@trash.net>
References: <4A27CD5A.6040303@trash.net> <1244464224-30692-1-git-send-email-panther@balabit.hu> <1244464224-30692-2-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62322 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbZFIMun (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:50:43 -0400
In-Reply-To: <1244464224-30692-2-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laszlo Attila Toth wrote:
>  net/netfilter/xt_socket.c |   63 +++++++++++++++++++++++++++++++++++++--------

> +#include <linux/netfilter/xt_socket.h>

-ENOCOMPILE

> +	{
> +		.name		= "socket",
> +		.revision	= 1,
> +		.family		= AF_INET,

NFPROTO_IPV4 please.

> +		.match		= socket_mt_v1,
> +		.matchsize	= sizeof(struct xt_socket_mtinfo1),
> +		.hooks		= 1 << NF_INET_PRE_ROUTING,
> +		.me		= THIS_MODULE,
> +	},
