From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] netns netfilter: create per-netns /proc/net/*_tables_*
Date: Wed, 30 Jan 2008 16:17:55 +0100
Message-ID: <47A09523.1030307@trash.net>
References: <20080125164529.GG6028@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	devel@openvz.org
To: Alexey Dobriyan <adobriyan@sw.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53668 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYA3PSL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:18:11 -0500
In-Reply-To: <20080125164529.GG6028@localhost.sw.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
> 
>  include/linux/netfilter/x_tables.h |    4 ++--
>  net/ipv4/netfilter/arp_tables.c    |   21 ++++++++++++++++++---
>  net/ipv4/netfilter/ip_tables.c     |   21 ++++++++++++++++++---
>  net/ipv6/netfilter/ip6_tables.c    |   22 +++++++++++++++++++---
>  net/netfilter/x_tables.c           |   20 ++++++++++----------
>  5 files changed, 67 insertions(+), 21 deletions(-)

Also applied, thanks.
