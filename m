From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Ulogd - mysql addresses are in network-byte order
Date: Mon, 2 Jan 2012 19:08:11 +0100
Message-ID: <20120102180811.GA26533@1984>
References: <4F013AB2.8030004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: marty <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42672 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab2ABSIO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jan 2012 13:08:14 -0500
Content-Disposition: inline
In-Reply-To: <4F013AB2.8030004@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 02, 2012 at 12:03:46AM -0500, marty wrote:
> 
> Here, for your review is a patch to
> address the issue that I reported.
> 
> --- orig.ulogd_raw2packet_BASE.c	2011-12-08 11:55:09.000000000 -0500
> +++ ulogd_raw2packet_BASE.c	2012-01-01 23:40:14.000000000 -0500
> @@ -717,8 +717,8 @@
>  		return ULOGD_IRET_OK;
>  	len -= iph->ihl * 4;
> 
> -	okey_set_u32(&ret[KEY_IP_SADDR], iph->saddr);
> -	okey_set_u32(&ret[KEY_IP_DADDR], iph->daddr);
> +	okey_set_u32(&ret[KEY_IP_SADDR], ntohl(iph->saddr));
> +	okey_set_u32(&ret[KEY_IP_DADDR], ntohl(iph->daddr));
>  	okey_set_u8(&ret[KEY_IP_PROTOCOL], iph->protocol);
>  	okey_set_u8(&ret[KEY_IP_TOS], iph->tos);
>  	okey_set_u8(&ret[KEY_IP_TTL], iph->ttl);

Many other plugins rely on the address in network byte order.

Can you fix this in the mysql plugin by adding some configurable
option?

more suggestions for your next patches, please:

* include short description before the patch.
* they have to apply with patch -p1 < file.patch

you can generate this with git diff HEAD (there are more advanced ways
to do this in git though).

thanks.
