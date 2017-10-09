From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] src: Merge assignment with return
Date: Mon, 9 Oct 2017 15:21:54 +0200
Message-ID: <20171009132154.GA8460@salvia>
References: <20171006223033.664-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:40910 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755365AbdJINV7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2017 09:21:59 -0400
Content-Disposition: inline
In-Reply-To: <20171006223033.664-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Harsha,

On Sat, Oct 07, 2017 at 04:00:33AM +0530, Harsha Sharma wrote:
> Merge assignment with return statement to directly return the value.
> Done using following coccinelle semantic patch
> 
> @@
> local idexpression ret;
> expression e;
> @@
> 
> -ret =
> +return
>      e;
> -return ret;
> 
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
>  src/mini-gmp.c  | 3 +--
>  src/statement.c | 5 +----
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/src/mini-gmp.c b/src/mini-gmp.c
> index acbe1be..0579c46 100644
> --- a/src/mini-gmp.c
> +++ b/src/mini-gmp.c
> @@ -1297,8 +1297,7 @@ mpn_set_str_bits (mp_ptr rp, const unsigned char *sp, size_t sn,
>  	    }
>  	}
>      }
> -  rn = mpn_normalized_size (rp, rn);
> -  return rn;
> +  return mpn_normalized_size(rp, rn);

mini-gmp.c has been extracted from libgmp sources [1], so either you
submit this chunk to them, or you leave this part as is. I would like
we just cache a copy of the mini-gmp.c original file.

Probably you can just check if latest stable release of libgmp
contains updates for mini-gmp.{c,h} and send us a patch to get in sync
with them.

Thanks.

[1] https://gmplib.org/repo/gmp/file/tip/mini-gmp
