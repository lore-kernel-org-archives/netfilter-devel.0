From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] socket: Added 'transparent' option
Date: Fri, 24 Apr 2009 16:54:53 +0200
Message-ID: <49F1D2BD.60709@trash.net>
References: <1240579820-18637-1-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46814 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbZDXOy7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:54:59 -0400
In-Reply-To: <1240579820-18637-1-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laszlo Attila Toth wrote:
> The socket match has an own matchinfo structure, with one boolean field,
> transparent, which is true when only transparent sockets can be matched.
> 
> @@ -161,6 +168,7 @@ static struct xt_match socket_mt_reg __read_mostly = {
>  	.name		= "socket",
>  	.family		= AF_INET,
>  	.match		= socket_mt,
> +	.matchsize	= sizeof(struct xt_socket_match_info),

This will break compatibility with old iptables binaries. You need
to add a new revision for this.
