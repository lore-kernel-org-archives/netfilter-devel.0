From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/5] netfilter: xtables: consolidate code into xt_request_find_match
Date: Thu, 25 Mar 2010 14:09:22 +0100
Message-ID: <4BAB6082.9010509@trash.net>
References: <1269521809-29393-1-git-send-email-jengelh@medozas.de> <1269521809-29393-5-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51503 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab0CYNJW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:09:22 -0400
In-Reply-To: <1269521809-29393-5-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  include/linux/netfilter/x_tables.h |    1 +
>  net/bridge/netfilter/ebtables.c    |    5 +----
>  net/ipv4/netfilter/ip_tables.c     |   18 ++++++++----------
>  net/ipv6/netfilter/ip6_tables.c    |   18 ++++++++----------
>  net/netfilter/x_tables.c           |   11 +++++++++++
>  5 files changed, 29 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
> index f8f5551..3c13d24 100644
> --- a/include/linux/netfilter/x_tables.h
> +++ b/include/linux/netfilter/x_tables.h
> @@ -436,6 +436,7 @@ extern struct xt_table_info *xt_replace_table(struct xt_table *table,
>  
>  extern struct xt_match *xt_find_match(u8 af, const char *name, u8 revision);
>  extern struct xt_target *xt_find_target(u8 af, const char *name, u8 revision);
> +extern struct xt_match *xt_request_find_match(uint8_t, const char *, uint8_t);
>  extern struct xt_target *xt_request_find_target(u8 af, const char *name,
>  						u8 revision);

Just for the sake of consistency, please use "u8" and specify the
parameter names.
