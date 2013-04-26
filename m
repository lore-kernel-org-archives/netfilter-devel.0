From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/4] examples/nf-queue: handle recv error, use larger
 buffer
Date: Fri, 26 Apr 2013 03:42:44 +0200
Message-ID: <20130426014244.GB4510@localhost>
References: <1366886611-21666-1-git-send-email-fw@strlen.de>
 <1366886611-21666-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34870 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759410Ab3DZBmv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:42:51 -0400
Content-Disposition: inline
In-Reply-To: <1366886611-21666-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 25, 2013 at 12:43:29PM +0200, Florian Westphal wrote:
> We ask for 0xffff copy size, so we need a buffer that can
> hold 0xffff, plus a few more bytes to allow for netlink attributes.
> 
> Also, turn off/handle ENOBUFS.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  examples/nf-queue.c |   38 +++++++++++++++++++++++++-------------
>  1 files changed, 25 insertions(+), 13 deletions(-)
> 
> diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> index 7adac21..57ba483 100644
> --- a/examples/nf-queue.c
> +++ b/examples/nf-queue.c
> @@ -1,3 +1,4 @@
> +#include <errno.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <unistd.h>
> @@ -82,7 +83,8 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
>  
>  int main(int argc, char *argv[])
>  {
> -	char buf[MNL_SOCKET_BUFFER_SIZE];
> +	char *buf;
> +	size_t sizeof_buf = 0xffff + 2084;

I think users will appreciate a comment to explain why those black
magic numbers are there ;-). Probably using MNL_SOCKET_BUFFER_SIZE/2
instead of 2084.

>  	struct nlmsghdr *nlh;
>  	int ret;
>  	unsigned int portid, queue_num;
> @@ -105,6 +107,12 @@ int main(int argc, char *argv[])
>  	}
>  	portid = mnl_socket_get_portid(nl);
>  
> +	buf = malloc(sizeof_buf);
> +	if (!buf) {
> +		perror("allocate receive buffer");
> +		exit(EXIT_FAILURE);
> +	}
> +
>  	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, 0);
>  	nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_PF_UNBIND);
>  
> @@ -137,23 +145,27 @@ int main(int argc, char *argv[])
>  		exit(EXIT_FAILURE);
>  	}
>  
> -	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> -	if (ret == -1) {
> -		perror("mnl_socket_recvfrom");
> -		exit(EXIT_FAILURE);
> -	}
> -	while (ret > 0) {
> -		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, NULL);
> -		if (ret < 0){
> -			perror("mnl_cb_run");
> -			exit(EXIT_FAILURE);
> -		}
> +	/* ENOBUFS is signalled to userspace when packets were lost
> +	 * on kernel side.  In most cases, userspace isn't interested
> +	 * in this information, so turn it off.
> +	 */
> +	ret = 1;
> +	mnl_socket_setsockopt(nl, NETLINK_NO_ENOBUFS, &ret, sizeof(int));
>  
> -		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> +	for (;;) {
> +		ret = mnl_socket_recvfrom(nl, buf, sizeof_buf);
>  		if (ret == -1) {
> +			if (errno == ENOBUFS) /* messages were lost */

Hm, you disabled ENOBUFS errors, right?

> +				continue;
>  			perror("mnl_socket_recvfrom");
>  			exit(EXIT_FAILURE);
>  		}
> +
> +		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, NULL);
> +		if (ret < 0){
> +			perror("mnl_cb_run");
> +			exit(EXIT_FAILURE);
> +		}
>  	}
>  
>  	mnl_socket_close(nl);
> -- 
> 1.7.8.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
