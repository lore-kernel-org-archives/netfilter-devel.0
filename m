From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/5] trace: implement commands action
Date: Thu, 25 Jun 2015 16:11:54 +0200
Message-ID: <20150625141154.GB6579@salvia>
References: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
 <1434571657-20047-5-git-send-email-koetter@rrzn.uni-hannover.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Markus Koetter <koetter@rrzn.uni-hannover.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39171 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbbFYOGe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jun 2015 10:06:34 -0400
Content-Disposition: inline
In-Reply-To: <1434571657-20047-5-git-send-email-koetter@rrzn.uni-hannover.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 17, 2015 at 10:07:36PM +0200, Markus Koetter wrote:
> 
> trace.c is based upon https://git.netfilter.org/libmnl/tree/examples/netfilter/nf-log.c
> 
> ---
>  include/Makefile.am |   1 +
>  include/trace.h     |   2 +
>  src/Makefile.am     |   1 +
>  src/rule.c          |   1 +
>  src/trace.c         | 361 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 366 insertions(+)
>  create mode 100644 include/trace.h
>  create mode 100644 src/trace.c
> 
> diff --git a/include/Makefile.am b/include/Makefile.am
> index f22561b..c351b55 100644
> --- a/include/Makefile.am
> +++ b/include/Makefile.am
> @@ -19,4 +19,5 @@ noinst_HEADERS = 	cli.h		\
>  			parser.h	\
>  			proto.h		\
>  			rule.h		\
> +			trace.h		\
>  			utils.h
> diff --git a/include/trace.h b/include/trace.h
> new file mode 100644
> index 0000000..8c43c86
> --- /dev/null
> +++ b/include/trace.h
> @@ -0,0 +1,2 @@
> +int nft_trace(int qnum, int family);
> +
> diff --git a/src/Makefile.am b/src/Makefile.am
> index 2410fd3..db77e8e 100644
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -45,6 +45,7 @@ nft_SOURCES =	main.c				\
>  		erec.c				\
>  		mnl.c				\
>  		scanner.l			\
> +		trace.c				\
>  		parser_bison.y
>  
>  if BUILD_CLI
> diff --git a/src/rule.c b/src/rule.c
> index dc65452..cd21de0 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -18,6 +18,7 @@
>  
>  #include <statement.h>
>  #include <rule.h>
> +#include <trace.h>
>  #include <utils.h>
>  #include <netlink.h>
>  
> diff --git a/src/trace.c b/src/trace.c
> new file mode 100644
> index 0000000..a9c9b5f
> --- /dev/null
> +++ b/src/trace.c
> @@ -0,0 +1,361 @@
> +#include <stddef.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <time.h>
> +#include <arpa/inet.h>
> +
> +#include <net/ethernet.h>
> +
> +#include <libmnl/libmnl.h>
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/nfnetlink.h>
> +
> +#ifndef aligned_be64
> +#define aligned_be64 u_int64_t __attribute__((aligned(8)))
> +#endif
> +
> +#include <linux/netfilter/nfnetlink_log.h>
> +#include <libmnl/libmnl.h>
> +
> +#include "trace.h"
> +#include "rule.h"
> +#include "statement.h"
> +#include "log.h"
> +
> +struct prefix
> +{
> +	char *table;
> +	char *chain;
> +	char *action;
> +	char *num;
> +};
> +
> +static int parse_prefix(char *prefix, struct prefix *td)
> +{
> +	static const char *TRACE = "TRACE: ";
> +	char *pos;
> +	char *cur = NULL;
> +	char *end = prefix + strlen(prefix);
> +	pos = prefix;
> +
> +	/* "TRACE: filter:input:rule:2 " */
> +	if (strncmp(prefix, TRACE, strlen(TRACE)) != 0)
> +		return -1;
> +
> +	pos += strlen(TRACE);
> +
> +	if (pos >= end)
> +		goto invalid_format_error;
> +
> +	/* "filter:input:rule:2 " */
> +	/* TABLE:CHAIN:ACTION:NUM */
> +	if ( (cur=strchr(pos, ':')) == NULL || cur+1 >= end)
> +		goto invalid_format_error;
> +	*cur = '\0';
> +	td->table = pos;
> +	pos = cur+1;
> +
> +	if ( (cur=strchr(pos, ':')) == NULL || cur+1 >= end)
> +		goto invalid_format_error;
> +	*cur = '\0';
> +	td->chain = pos;
> +	pos = cur+1;
> +
> +	if ( (cur=strchr(pos, ':')) == NULL || cur+1 >= end)
> +		goto invalid_format_error;
> +	*cur = '\0';
> +	td->action = pos;
> +
> +	td->num = cur+1;

We have to pass this information to nfnetlink_log to express it as
netlink attributes. This requires some changes in the kernel side.
This string parsing is not a good idea.
