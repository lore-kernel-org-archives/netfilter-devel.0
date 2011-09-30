From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [libnl-nft PATCH] Fix the route object comparison using the wrong pointer
Date: Fri, 30 Sep 2011 13:26:28 +0200
Message-ID: <201109301326.28941.thomas.jarosch@intra2net.com>
References: <4E55255F.1050901@intra2net.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs04.intra2net.com ([85.214.66.2]:45489 "EHLO
	rs04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab1I3L0c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Sep 2011 07:26:32 -0400
In-Reply-To: <4E55255F.1050901@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday, 24. August 2011 18:22:55 you wrote:
> Typo detected by cppcheck
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> ---
>  lib/route/route_obj.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/route/route_obj.c b/lib/route/route_obj.c
> index 4e14d6d..8f1d4d5 100644
> --- a/lib/route/route_obj.c
> +++ b/lib/route/route_obj.c
> @@ -403,7 +403,7 @@ static int route_compare(struct nl_object *_a, struct
> nl_object *_b, diff |= ROUTE_DIFF(FLAGS,
>  			  (a->rt_flags ^ b->rt_flags) & b->rt_flag_mask);
>  	} else {
> -		if (a->rt_nr_nh != a->rt_nr_nh)
> +		if (a->rt_nr_nh != b->rt_nr_nh)
>  			goto nh_mismatch;
> 
>  		/* search for a dup in each nh of a */

Just a short reminder: This patch is still pending.

Cheers,
Thomas
