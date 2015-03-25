From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 2/4] Add MARK target for arptables
Date: Wed, 25 Mar 2015 17:16:08 +0100
Message-ID: <20150325161608.GA4787@salvia>
References: <1427248656-8851-1-git-send-email-zhangcy@cn.fujitsu.com>
 <1427248656-8851-3-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>
To: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43838 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbbCYQMS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 12:12:18 -0400
Content-Disposition: inline
In-Reply-To: <1427248656-8851-3-git-send-email-zhangcy@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 24, 2015 at 09:57:34PM -0400, Zhang Chunyu wrote:
> We can use MARK target to set make value for arp packet.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> Signed-off-by: Zhang Chunyu <zhangcy@cn.fujitsu.com>
> ---
>  extensions/Makefile    |   2 +-
>  extensions/arpt_MARK.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 120 insertions(+), 1 deletion(-)
>  create mode 100644 extensions/arpt_MARK.c
> 
> diff --git a/extensions/Makefile b/extensions/Makefile
> index 09b244e..0189cc9 100644
> --- a/extensions/Makefile
> +++ b/extensions/Makefile
> @@ -1,6 +1,6 @@
>  #! /usr/bin/make
>  
> -EXT_FUNC+=standard mangle CLASSIFY
> +EXT_FUNC+=standard mangle CLASSIFY MARK
>  EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/arpt_$(T).o)
>  
>  extensions/ebt_%.o: extensions/arpt_%.c include/arptables.h include/arptables_common.h
> diff --git a/extensions/arpt_MARK.c b/extensions/arpt_MARK.c
> new file mode 100644
> index 0000000..d9aec8b
> --- /dev/null
> +++ b/extensions/arpt_MARK.c
> @@ -0,0 +1,119 @@
> +/*
> + * (C) 2014 by Gao Feng <gaofeng@cn.fujitsu.com>
> + *
> + * arpt_MARK.c -- arptables extension to set mark for arp packet
> + *
> + *	This program is free software; you can redistribute it and/or modify
> + *	it under the terms of the GNU General Public License as published by
> + *	the Free Software Foundation; either version 2 of the License, or
> + *	(at your option) any later version.
> + *
> + *	This program is distributed in the hope that it will be useful,
> + *	but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *	GNU General Public License for more details.
> + *
> + *	You should have received a copy of the GNU General Public License
> + *	along with this program; if not, write to the Free Software
> + *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <stdio.h>
> +#include <getopt.h>
> +#include <arptables.h>
> +#include <linux/netfilter/xt_mark.h>
> +#include <linux/netfilter/xt_MARK.h>
> +#include <linux/netfilter/x_tables.h>
> +
> +static void
> +help(void)

Place this in the same line, ie.

static void help(void)

> +{
> +	printf(
> +"MARK target v%s options:\n"
> +"--set-mark mark : set the mark value\n",
> +	ARPTABLES_VERSION);
> +}
> +
> +#define MARK_OPT 1
> +
> +static struct option opts[] = {
> +	{ "set-mark"   , required_argument, 0, MARK_OPT },

Could you use C99 initialization for this?

I know other extensions don't because this code is rather old, but it
would be good to good at least new code in better shape.

> +	{0}
> +};
> +
> +static void
> +init(struct arpt_entry_target *t)
> +{
> +	struct xt_mark_tginfo2 *info = (struct xt_mark_tginfo2 *) t->data;
> +
> +	info->mark = 0;
> +}
> +
> +static int
> +parse(int c, char **argv, int invert, unsigned int *flags,
> +	const struct arpt_entry *e,
> +	struct arpt_entry_target **t)
> +{
> +	struct xt_mark_tginfo2 *info = (struct xt_mark_tginfo2 *)(*t)->data;
> +	int i;
> +
> +	switch (c) {
> +		case MARK_OPT:

We prefer:

        switch (c) {
        case MARK_OPT:
                ...

> +			if (sscanf(argv[optind-1], "%x", &i) != 1) {
> +				exit_error(PARAMETER_PROBLEM,
> +						"Bad mark value `%s'", optarg);

                                exit_error(...
                                           "Bad mark..."

> +				return 0;
> +			}
> +			info->mark = i;
> +			if (*flags)
> +				exit_error(PARAMETER_PROBLEM,
> +						"CLASSIFY: Can't specify --set-mark twice");
> +			*flags = 1;
> +			break;
> +		default:
> +			return 0;
> +	}
> +	return 1;
> +}
> +
> +static void final_check(unsigned int flags)
> +{
> +	if (!flags)
> +		exit_error(PARAMETER_PROBLEM, "MARK: Parameter --set-mark is required");
> +}
> +
> +static void print(const struct arpt_arp *ip,
> +	const struct arpt_entry_target *target, int numeric)
> +{
> +	struct xt_mark_tginfo2 *info = (struct xt_mark_tginfo2 *)(target->data);
> +
> +	printf("--set-mark %x ", info->mark);
> +}
> +
> +static void
> +save(const struct arpt_arp *ip, const struct arpt_entry_target *target)
> +{
> +}
> +
> +static
> +struct arptables_target mark
> += { NULL,
> +	"MARK",
> +	ARPTABLES_VERSION,
> +	ARPT_ALIGN(sizeof(struct xt_mark_tginfo2)),
> +	ARPT_ALIGN(sizeof(struct xt_mark_tginfo2)),
> +	2,
> +	&help,
> +	&init,
> +	&parse,
> +	&final_check,
> +	&print,
> +	&save,
> +	opts

Please, use C99 structure initialization here too.

> +};
> +
> +static void _init(void) __attribute__ ((constructor));
> +static void _init(void)
> +{
> +	register_target(&mark);
> +}
> -- 
> 1.7.12.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
