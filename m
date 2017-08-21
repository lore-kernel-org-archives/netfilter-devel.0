From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 17/18] libnftables: suppress unused global variables
Date: Mon, 21 Aug 2017 10:40:08 +0200
Message-ID: <20170821084008.GJ2982@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-18-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53319 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753001AbdHUIkg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 04:40:36 -0400
Content-Disposition: inline
In-Reply-To: <20170819152420.22563-18-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 19, 2017 at 05:24:19PM +0200, Eric Leblond wrote:
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  src/libnftables.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/src/libnftables.c b/src/libnftables.c
> index b1df916..1abe077 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -26,9 +26,6 @@
>  
>  
>  unsigned int max_errors = 1;
> -unsigned int numeric_output;
> -unsigned int ip2name_output;
> -unsigned int handle_output;

I guess these slipped through in the constant rebases I'm triggering
with my preparation patches, sorry about that.

I guess it should be possible to get rid of this in the next
submission by amending the patch that adds the library.
