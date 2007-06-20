From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: xt_connlimit kernel 20070620
Date: Wed, 20 Jun 2007 11:47:14 +0200
Message-ID: <4678F7A2.6090203@netfilter.org>
References: <Pine.LNX.4.64.0706200039290.5731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706200039290.5731@fbirervta.pbzchgretzou.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Adds the xt_connlimit match to the kernel.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> ---
>  include/linux/netfilter/xt_connlimit.h |   14 +
>  net/netfilter/Kconfig                  |    7 
>  net/netfilter/Makefile                 |    1 
>  net/netfilter/xt_connlimit.c           |  259 +++++++++++++++++++++++++++++++++
>  4 files changed, 281 insertions(+)
> 
> Index: linux-2.6.22/include/linux/netfilter/xt_connlimit.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.22/include/linux/netfilter/xt_connlimit.h
> @@ -0,0 +1,14 @@
> +#ifndef _XT_CONNLIMIT_H
> +#define _XT_CONNLIMIT_H
> +
> +struct xt_connlimit_data;
> +
> +struct xt_connlimit_info {
> +	u_int32_t mask;
> +	unsigned int limit, inverse;
> +
> +	/* this needs to be at the end */
> +	struct xt_connlimit_data *data;
                         ^^^
IIRC, this should be:

struct xt_connlimit_data __attribute__((aligned(8))) *data;

to avoid problems with 32/64 bits architectures.

> +};
> +
> +#endif /* _XT_CONNLIMIT_H */
> Index: linux-2.6.22/net/netfilter/xt_connlimit.c
> ===================================================================
[...]
> +
> +		if (found_ct->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT) {
> +			/*
> +			 * we do not care about connections which are
> +			 * closed already -> ditch it
> +			 */
> +			lh = lh->prev;
> +			list_del(lh->next);
> +			kfree(conn);
> +			nf_conntrack_put(&found_ct->ct_general);
> +			continue;
> +		}

This match seems completely dependent of TCP. I think that it would be 
worth a rework. Luke, use the connection tracking event API :)

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
