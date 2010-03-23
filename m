From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/9] netfilter: xt_recent: allow changing ip_list_[ug]id
 at runtime
Date: Tue, 23 Mar 2010 15:18:33 +0100
Message-ID: <4BA8CDB9.1010304@trash.net>
References: <1269285486-22653-1-git-send-email-jengelh@medozas.de> <1269285486-22653-6-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58786 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0CWOSd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:18:33 -0400
In-Reply-To: <1269285486-22653-6-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  net/netfilter/xt_recent.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
> index 72cbced..8530944 100644
> --- a/net/netfilter/xt_recent.c
> +++ b/net/netfilter/xt_recent.c
> @@ -51,14 +51,14 @@ module_param(ip_list_tot, uint, 0400);
>  module_param(ip_pkt_list_tot, uint, 0400);
>  module_param(ip_list_hash_size, uint, 0400);
>  module_param(ip_list_perms, uint, 0400);
> -module_param(ip_list_uid, uint, 0400);
> -module_param(ip_list_gid, uint, 0400);
> +module_param(ip_list_uid, uint, S_IRUGO | S_IWUSR);
> +module_param(ip_list_gid, uint, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(ip_list_tot, "number of IPs to remember per list");
>  MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 255)");
>  MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look up IPs");
>  MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/xt_recent/* files");
> -MODULE_PARM_DESC(ip_list_uid,"owner of /proc/net/xt_recent/* files");
> -MODULE_PARM_DESC(ip_list_gid,"owning group of /proc/net/xt_recent/* files");
> +MODULE_PARM_DESC(ip_list_uid, "default owner of /proc/net/xt_recent/* files");
> +MODULE_PARM_DESC(ip_list_gid, "default owning group of /proc/net/xt_recent/* files");
>

So what will be updating the permissions of the existing proc files?
