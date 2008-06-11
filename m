From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: netnsize ip6table_security
Date: Wed, 11 Jun 2008 08:20:34 +0200
Message-ID: <484F6EB2.6020508@trash.net>
References: <200806102048.34447.adobriyan@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, James Morris <jmorris@namei.org>
To: Alexey Dobriyan <adobriyan@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62197 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbYFKGUg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:20:36 -0400
In-Reply-To: <200806102048.34447.adobriyan@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
> ---
> 
>  not sure why this code in IPv4 version but not in IPv6
> 
>  net/ipv6/netfilter/ip6table_security.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied, but I couldn't figure out what "netnsize ip6table_security"
is supposed to mean, so I changed it to

"netfilter: use correct namespace in ip6table_security".

