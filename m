From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnf-log 3/3] utils: nf-log: attaching a conntrack
 information
Date: Mon, 12 Oct 2015 17:26:30 +0200
Message-ID: <20151012152630.GC21781@salvia>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
 <20150911031535.GG7380@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52870 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbbJLPT1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Oct 2015 11:19:27 -0400
Content-Disposition: inline
In-Reply-To: <20150911031535.GG7380@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 11, 2015 at 12:15:35PM +0900, Ken-ichirou MATSUZAWA wrote:
> diff --git a/utils/nf-log.c b/utils/nf-log.c
> index 5f2a192..1418af4 100644
> --- a/utils/nf-log.c
> +++ b/utils/nf-log.c
> @@ -3,15 +3,108 @@
>  #include <stdlib.h>
>  #include <arpa/inet.h>
>  
> -#include <linux/netfilter/nfnetlink_log.h>
> +/* #include <linux/netfilter/nfnetlink_log.h> */

Do you remember why you had to comment out this line?

> +#include <libnetfilter_log/linux_nfnetlink_log.h>
>  
>  #include <libmnl/libmnl.h>
>  #include <libnetfilter_log/libnetfilter_log.h>
>  
> +#include "../config.h"
> +#ifdef BUILD_NFCT
> +#include <linux/netfilter/nf_conntrack_common.h>
> +#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
> +#endif
> +
> +#ifdef BUILD_NFCT
> +static int print_ctinfo(const struct nlattr *const attr)
> +{
> +	char *s = NULL;
> +
> +	if (attr == NULL)
> +		return MNL_CB_OK;
> +
> +	switch (ntohl(mnl_attr_get_u32(attr))) {
> +	case IP_CT_ESTABLISHED:
> +		s = "IP_CT_ESTABLISHED";

For this example, you can probably simplify this with.

        case IP_CT_ESTABLISHED:
        case IP_CT_ESTABLISHED_REPLY:
                s = "ESTABLISHED";

> +		break;
> +	case IP_CT_RELATED:
> +		s = "IP_CT_RELATED";
> +		break;
> +	case IP_CT_NEW:
> +		s = "IP_CT_NEW";
> +		break;
> +	case IP_CT_IS_REPLY:
> +		s = "IP_CT_IS_REPLY";
> +		break;

IP_CT_IS_REPLY is never used alone, it's is always combined with NEW,
ESTABLISHED, RELATED states.

> +	/* case IP_CT_ESTABLISHED_REPLY: == IP_CT_IS_REPLY
> +	 *	s = "IP_CT_ESTABLISHED_REPLY";
> +	 *	break;
> +	 */
> +	case IP_CT_RELATED_REPLY:
> +		s = "IP_CT_RELATED_REPLY";
> +		break;
> +	case IP_CT_NEW_REPLY:
> +		s = "IP_CT_NEW_REPLY";
> +		break;
> +	/* case IP_CT_NUMBER: == IP_CT_NEW_REPLY
> +	 *	s ="IP_CT_NUMBER";
> +	 *	break;
> +	 */

IP_CT_NUMBER should never happen. Please remove this code.

Same applied to the libnetfilter_queue example that you posted.

Thanks.
