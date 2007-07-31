From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 07/**] Move connlimit to xt
Date: Tue, 31 Jul 2007 09:44:57 +0900 (JST)
Message-ID: <200707310044.l6V0iwNk027807@toshiba.co.jp>
References: <Pine.LNX.4.64.0707241246160.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707241246160.18990@fbirervta.pbzchgretzou.qr>
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

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Tue, 24 Jul 2007 12:46:45 +0200 (CEST)

> Moves libip{,6}t_connlimit to libxt.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> ---
>  extensions/Makefile              |    6 -
>  extensions/libip6t_connlimit.c   |  151 ---------------------------
>  extensions/libip6t_connlimit.man |   27 ----
>  extensions/libipt_connlimit.c    |  128 -----------------------
>  extensions/libipt_connlimit.man  |   27 ----
>  extensions/libxt_connlimit.c     |  217 +++++++++++++++++++++++++++++++++++++++
>  extensions/libxt_connlimit.man   |   27 ++++
>  7 files changed, 247 insertions(+), 336 deletions(-)

The manuals cannot be unified in the current.

> +static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
> +                           struct xt_connlimit_info *info, unsigned int family)
> +{
> +	char *err;
> +	int i;
> +
> +	switch (c) {
> +	case 'A':
> +		if (*flags & 0x1)
> +			exit_error(PARAMETER_PROBLEM,
> +				"--connlimit-above may be given only once");
> +		*flags |= 0x1;
> +		check_inverse(optarg, &invert, &optind, 0);
> +		info->limit   = strtoul(argv[optind-1], NULL, 0);
> +		info->inverse = invert;
> +		break;
> +	case 'M':
> +		if (*flags & 0x2)
> +			exit_error(PARAMETER_PROBLEM,
> +				"--connlimit-mask may be given only once");
> +
> +		*flags |= 0x2;
> +		i = strtoul(argv[optind-1], &err, 0);
> +		if (family == AF_INET6) {
> +			if (i > 128 || *err != '\0')
> +				exit_error(PARAMETER_PROBLEM,
> +					"--connlimit-mask must be between "
> +					"0 and 128");
> +			prefix_to_netmask(info->v6_mask, i);
> +		} else {
> +			if (i > 32 || *err != '\0')
> +				exit_error(PARAMETER_PROBLEM,
> +					"--connlimit-mask must be between "
> +					"0 and 32");
> +			if (i == 0)
> +				info->v4_mask = 0;
> +			else
> +				info->v4_mask = htonl(0xFFFFFFFF << (32 - i));
> +		}
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return 1;
> +}

Looks fine, But this patch also includes a change to allow to use
--connlimit-mask and --connlimit-above. Why previous connlimit prohibited
that ?

-- Yasuyuki Kozakai
