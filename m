From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6/13] [NETFILTER]: arp_tables: make return of 0 explicit
Date: Thu, 29 May 2014 14:24:00 +0200
Message-ID: <20140529122400.GA5371@localhost>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
 <1400473875-22228-7-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-janitors@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400473875-22228-7-git-send-email-Julia.Lawall@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Julia,

On Mon, May 19, 2014 at 06:31:08AM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Delete unnecessary local variable whose value is always 0 and that hides
> the fact that the result is always 0.
>
> A simplified version of the semantic patch that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r exists@
> local idexpression ret;
> expression e;
> position p;
> @@
>
> -ret = 0;
> ... when != ret = e
> return
> - ret
> + 0
>   ;
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>  net/ipv4/netfilter/arp_tables.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index f95b6f9..89f6737 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -1289,9 +1289,8 @@ compat_copy_entry_from_user(struct compat_arpt_entry *e, void **dstptr,
>  	struct xt_target *target;
>  	struct arpt_entry *de;
>  	unsigned int origsize;
> -	int ret, h;
> +	int h;
>
> -	ret = 0;
>  	origsize = *size;
>  	de = (struct arpt_entry *)*dstptr;
>  	memcpy(de, e, sizeof(struct arpt_entry));
> @@ -1312,7 +1311,7 @@ compat_copy_entry_from_user(struct compat_arpt_entry *e, void **dstptr,
>  		if ((unsigned char *)de - base < newinfo->underflow[h])
>  			newinfo->underflow[h] -= origsize - *size;
>  	}
> -	return ret;
> +	return 0;
>  }

This looks good, but we can simplify this a bit further, given that
compat_copy_entry_from_user could be made void.

This branch below never happens.

        xt_entry_foreach(iter0, entry0, total_size) {
                ret = compat_copy_entry_from_user(iter0, &pos, &size,
                                                  name, newinfo, entry1);
                if (ret != 0)
                        break;
        }

Thanks for your patch anyway!
