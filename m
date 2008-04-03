From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 07/24] [NETFILTER]: remove ARPT_{CONTINUE,RETURN} indirection
 macros
Date: Thu, 03 Apr 2008 13:52:45 +0200
Message-ID: <47F4C50D.9060902@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <5bfc07f75334b4c529d6777b80b1ff8dda6eefa8.1207134547.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64638 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbYDCLwt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 07:52:49 -0400
In-Reply-To: <5bfc07f75334b4c529d6777b80b1ff8dda6eefa8.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/linux/netfilter_arp/arp_tables.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
> index 2cdcc0c..f701e36 100644
> --- a/include/linux/netfilter_arp/arp_tables.h
> +++ b/include/linux/netfilter_arp/arp_tables.h
> @@ -180,10 +180,6 @@ struct arpt_replace
>  	struct arpt_entry entries[0];
>  };
>  
> -/* The argument to ARPT_SO_ADD_COUNTERS. */
> -#define arpt_counters_info xt_counters_info
> -#define arpt_counters xt_counters
> -

Used by userspace.
