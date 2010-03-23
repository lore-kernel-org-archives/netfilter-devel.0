From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/9] netfilter: xtables: consolidate code into xt_request_find_match
Date: Tue, 23 Mar 2010 15:27:08 +0100
Message-ID: <4BA8CFBC.6020305@trash.net>
References: <1269285486-22653-1-git-send-email-jengelh@medozas.de> <1269285486-22653-5-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58953 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab0CWO1L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:27:11 -0400
In-Reply-To: <1269285486-22653-5-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -629,12 +629,11 @@ find_check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par)
>  	struct xt_match *match;
>  	int ret;
>  
> -	match = try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
> -						      m->u.user.revision),
> -					"ipt_%s", m->u.user.name);
> -	if (IS_ERR(match) || !match) {
> +	match = xt_request_find_match(NFPROTO_IPV4, m->u.user.name,
> +	        m->u.user.revision);
>   
Please fix indentation in this patch as well.

