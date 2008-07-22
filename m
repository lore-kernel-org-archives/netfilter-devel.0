From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/7] netfilter: Export ip6t_mh.h and xt_quota.h for iptables
 build
Date: Tue, 22 Jul 2008 12:45:16 +0200
Message-ID: <4885BA3C.8080205@trash.net>
References: <E1KKl4I-00068B-LW@swissweb.swissdisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58262 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbYGVKpW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:45:22 -0400
In-Reply-To: <E1KKl4I-00068B-LW@swissweb.swissdisk.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tim Gardner wrote:
> CC: netfilter-devel@vger.kernel.org
> Signed-off-by: Soren Hansen <soren@ubuntu.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Ben Collins <ben.lcollins@canonical.com>
> ---
>  include/linux/netfilter/Kbuild      |    2 ++
>  include/linux/netfilter_ipv6/Kbuild |    1 +
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
> index 3aff513..3a04da3 100644
> --- a/include/linux/netfilter/Kbuild
> +++ b/include/linux/netfilter/Kbuild
> @@ -31,6 +31,8 @@ header-y += xt_multiport.h
>  header-y += xt_owner.h
>  header-y += xt_pkttype.h
>  header-y += xt_rateest.h
> +header-y += xt_policy.h
> +header-y += xt_quota.h

xt_policy.h is already included in unidef-y. The others look fine.


