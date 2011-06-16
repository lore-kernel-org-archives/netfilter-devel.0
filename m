From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/15] netfilter: ipset: Options and flags support added
 to the kernel API
Date: Thu, 16 Jun 2011 18:46:54 +0200
Message-ID: <4DFA337E.8030407@trash.net>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-3-git-send-email-kadlec@blackhole.kfki.hu> <1307465780-28980-4-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61478 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab1FPQqz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:46:55 -0400
In-Reply-To: <1307465780-28980-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.06.2011 18:56, Jozsef Kadlecsik wrote:
> The support makes possible to specify the timeout value for
> the SET target and a flag to reset the timeout for already existing
> entries.

Applied.

> --- a/include/linux/netfilter/xt_set.h
> +++ b/include/linux/netfilter/xt_set.h
> @@ -44,13 +44,22 @@ struct xt_set_info {
>  };
>  
>  /* match and target infos */
> -struct xt_set_info_match {
> +struct xt_set_info_match_v1 {
>  	struct xt_set_info match_set;
>  };
>  
> -struct xt_set_info_target {
> +struct xt_set_info_target_v1 {
>  	struct xt_set_info add_set;
>  	struct xt_set_info del_set;
>  };
>  

But we shouldn't rename existing structures that are already
exposed to userspace.
