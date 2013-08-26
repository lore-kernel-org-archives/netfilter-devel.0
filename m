From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnf-queue] api: add nfq_nlmsg_get_timestamp helper
Date: Tue, 27 Aug 2013 00:53:25 +0200
Message-ID: <20130826225325.GA4695@localhost>
References: <1377184037-19790-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52452 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab3HZWxg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:53:36 -0400
Content-Disposition: inline
In-Reply-To: <1377184037-19790-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, Aug 22, 2013 at 05:07:17PM +0200, Florian Westphal wrote:
> The NFQA_TIMESTAMP structure is in network byte order, so it seems
> appropriate to add a helper to convert it to a timeval struct.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  examples/nf-queue.c                             |    9 ++++++++-
>  include/libnetfilter_queue/libnetfilter_queue.h |    2 ++
>  src/nlmsg.c                                     |   15 +++++++++++++++
>  3 files changed, 25 insertions(+), 1 deletions(-)
> 
> diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> index 1f465ad..2722426 100644
> --- a/examples/nf-queue.c
> +++ b/examples/nf-queue.c
> @@ -5,6 +5,7 @@
>  #include <string.h>
>  #include <time.h>
>  #include <arpa/inet.h>
> +#include <sys/time.h>
>  
>  #include <libmnl/libmnl.h>
>  #include <linux/netfilter.h>
> @@ -54,6 +55,7 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
>  	uint32_t id = 0, skbinfo;
>  	struct nfgenmsg *nfg;
>  	uint16_t plen;
> +	struct timeval tv;
>  
>  	if (nfq_nlmsg_parse(nlh, attr) < 0) {
>  		perror("problems parsing");
> @@ -72,7 +74,11 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
>  	plen = mnl_attr_get_payload_len(attr[NFQA_PAYLOAD]);
>  	/* void *payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]); */
>  
> -	skbinfo = attr[NFQA_SKB_INFO] ? ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO])) : 0;
> +	if (attr[NFQA_TIMESTAMP])
> +		nfq_nlmsg_get_timestamp(attr[NFQA_TIMESTAMP], &tv);

I think we can update nfq_get_timestamp to use libmnl without breaking
backward compatibility. Same thing with all other getter functions
that we have.

Regards.
