From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/6] netfilter: xtables: add const qualifiers
Date: Thu, 11 Feb 2010 10:00:48 +0100
Message-ID: <4B73C740.5020003@trash.net>
References: <1265823547-10358-1-git-send-email-jengelh@medozas.de> <1265823547-10358-7-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37093 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab0BKJAy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:00:54 -0500
In-Reply-To: <1265823547-10358-7-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> +static inline const struct ip6t_entry_target *
> +ip6t_get_target_c(const struct ip6t_entry *e)
> +{
> +	return ip6t_get_target((struct ip6t_entry *)e);
> +}
> +

I would prefer a macro over these get_target_c functions.
