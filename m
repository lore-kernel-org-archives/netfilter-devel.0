From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4] netfilter: xt_recent: remove ip_list_hash_size
 parameter
Date: Thu, 12 Jul 2012 17:42:10 +0200
Message-ID: <20120712154210.GC18793@1984>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de>
 <1341964350-13809-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42592 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030635Ab2GLPmQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:42:16 -0400
Content-Disposition: inline
In-Reply-To: <1341964350-13809-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 11, 2012 at 01:52:27AM +0200, Jan Engelhardt wrote:
> This module parameter has no effect, since the user-specified value is
> overriden by the init function anyway.

My only concern with this is to break existing configuration that sets
that module parameter.

I wonder if it's useful to fix this module parameter to make it work
instead.

> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  net/netfilter/xt_recent.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
> index c426497..b980b3f 100644
> --- a/net/netfilter/xt_recent.c
> +++ b/net/netfilter/xt_recent.c
> @@ -50,7 +50,6 @@ static unsigned int ip_list_uid = 0;
>  static unsigned int ip_list_gid = 0;
>  module_param(ip_list_tot, uint, 0400);
>  module_param(ip_pkt_list_tot, uint, 0400);
> -module_param(ip_list_hash_size, uint, 0400);
>  module_param(ip_list_perms, uint, 0400);
>  module_param(ip_list_uid, uint, S_IRUGO | S_IWUSR);
>  module_param(ip_list_gid, uint, S_IRUGO | S_IWUSR);
> -- 
> 1.7.7
> 
