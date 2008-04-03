From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/24] [NETFILTER]: remove ARPT_{CONTINUE,RETURN} indirection
 macros
Date: Thu, 03 Apr 2008 13:52:21 +0200
Message-ID: <47F4C4F5.10105@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <c3311a6c3c9a63f913b4c634eaa0e57a3a5bf6ef.1207134547.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64626 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbYDCLwZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 07:52:25 -0400
In-Reply-To: <c3311a6c3c9a63f913b4c634eaa0e57a3a5bf6ef.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/linux/netfilter_arp/arp_tables.h |    6 ------
>  net/ipv4/netfilter/arp_tables.c          |    6 +++---
>  net/ipv4/netfilter/arpt_mangle.c         |    2 +-
>  3 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
> index 493dcd2..2cdcc0c 100644
> --- a/include/linux/netfilter_arp/arp_tables.h
> +++ b/include/linux/netfilter_arp/arp_tables.h
> @@ -125,12 +125,6 @@ struct arpt_entry
>  #define ARPT_SO_GET_REVISION_TARGET	(ARPT_BASE_CTL + 3)
>  #define ARPT_SO_GET_MAX			(ARPT_SO_GET_REVISION_TARGET)
>  
> -/* CONTINUE verdict for targets */
> -#define ARPT_CONTINUE XT_CONTINUE
> -
> -/* For standard target */
> -#define ARPT_RETURN XT_RETURN

These are also used by userspace.
