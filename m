Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6ACD68
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 00:39:00 -0800 (PST)
Received: from [78.30.43.141] (port=54680 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1r6RiC-0043Bq-4V; Fri, 24 Nov 2023 09:38:58 +0100
Date: Fri, 24 Nov 2023 09:38:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v4] src: Add nfq_nlmsg_put2() - user
 specifies header flags
Message-ID: <ZWBhH235ou6RhYFn@calendula>
References: <20231120010849.11276-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231120010849.11276-1-duncan_roe@optusnet.com.au>
X-Spam-Score: -1.8 (-)

On Mon, Nov 20, 2023 at 12:08:49PM +1100, Duncan Roe wrote:
> Enable mnl programs to check whether a config request was accepted.
> (nfnl programs do this already).
> 
> v4: other requested changes
> 
> v3: force on NLM_F_REQUEST
> 
> v2: take flags as an arg (Pablo request)
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
>  src/nlmsg.c                                   | 54 ++++++++++++++++++-
>  2 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
> index 3d8e444..f254984 100644
> --- a/include/libnetfilter_queue/libnetfilter_queue.h
> +++ b/include/libnetfilter_queue/libnetfilter_queue.h
> @@ -151,6 +151,7 @@ void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t p
>  
>  int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
>  struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num);
> +struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num, uint16_t flags);
>  
>  #ifdef __cplusplus
>  } /* extern "C" */
> diff --git a/src/nlmsg.c b/src/nlmsg.c
> index 5400dd7..0c6229e 100644
> --- a/src/nlmsg.c
> +++ b/src/nlmsg.c
> @@ -309,10 +309,62 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
>   */
>  EXPORT_SYMBOL
>  struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num)
> +{
> +	return nfq_nlmsg_put2(buf, type, queue_num, 0);
> +}
> +
> +/**
> + * nfq_nlmsg_put2 - Set up a netlink header with user-specified flags
> + *                  in a memory buffer
> + * \param *buf Pointer to memory buffer
> + * \param type Either NFQNL_MSG_CONFIG or NFQNL_MSG_VERDICT


This can be any value in enum nfqnl_msg_types.

> + * \param queue_num Queue number
> + * \param flags additional flags to put in message header, commonly NLM_F_ACK

This can be any NLM_F_* flag, as define in include/linux/netlink.h

> + * \returns Pointer to netlink header
> + *
> + * Use NLM_F_ACK before performing an action that might fail, e.g.
> + * attempt to configure NFQA_CFG_F_SECCTX on a system not runnine SELinux.

typo: 'runnine'

> + * \n
> + * The kernel always sends a message in response to a failed command.
> + * NLM_F_ACK instructs the kernel to also send a message in response
> + * to a successful command.
> + * \n

Please, also specify that recommended buffer size in this case is
MNL_SOCKET_BUFFER_SIZE.

> + * This code snippet demonstrates reading these responses:
> + * \verbatim

I'd suggest to add:

        char nltxbuf[MNL_SOCKET_BUFFER_SIZE];

> +	nlh = nfq_nlmsg_put2(nltxbuf, NFQNL_MSG_CONFIG, queue_num, NLM_F_ACK);
> +	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, NFQA_CFG_F_SECCTX);
> +	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, NFQA_CFG_F_SECCTX);
> +
> +	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> +		perror("mnl_socket_send");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	ret = mnl_socket_recvfrom(nl, nlrxbuf, sizeof nlrxbuf);
> +	if (ret == -1) {
> +		perror("mnl_socket_recvfrom");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	ret = mnl_cb_run(nlrxbuf, ret, 0, portid, NULL, NULL);
> +	if (ret == -1)
> +		perror("configure NFQA_CFG_F_SECCTX");
> +\endverbatim
> + *
> + * \note
> + * The program above can continue after the error because NFQA_CFG_F_SECCTX
> + * was the only item in the preceding **mnl_socket_sendto**.

Not sure what you mean in this sentence. The program above can
continue because you do not bail out mnl_cb_run().

Suggestion: To keep it simpler, I would simply do exit(EXIT_FAILURE)
in the example above and remove these two sentences.

Here above you are requesting to toggle this flag, if kernel reports
an error (which one? EOPNOTSUPP?) then this means such
NFAQ_CFG_F_SECCTX feature is not available.

Please, send v5, this is looking better and better, thanks!
