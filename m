From: Patrick McHardy <kaber@trash.net>
Subject: Re: [13/19] rename overlapping function names
Date: Sun, 20 Jan 2008 14:37:43 +0100
Message-ID: <47934EA7.9090906@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161451470.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58096 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbYATNin (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:38:43 -0500
In-Reply-To: <Pine.LNX.4.64.0801161451470.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Rename overlapping function names.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> ---
>  extensions/libip6t_policy.c  |    6 
>  extensions/libipt_DNAT.c     |    6 
>  extensions/libipt_NETMAP.c   |    6 
>  extensions/libipt_SAME.c     |    6 
>  extensions/libipt_SNAT.c     |    6 
>  extensions/libipt_iprange.c  |    6 
>  extensions/libipt_policy.c   |    4 
>  extensions/libxt_conntrack.c |    8 -
>  include/iptables.h           |    5 
>  include/xtables.h            |    7 
>  ip6tables.c                  |  159 ---------------------
>  iptables.c                   |  198 --------------------------
>  xtables.c                    |  318 +++++++++++++++++++++++++++++++++++++++++++
>  13 files changed, 356 insertions(+), 379 deletions(-)


This patch could have used a better description, it also
moves some functions to xtables.c. Anyways, applied.
