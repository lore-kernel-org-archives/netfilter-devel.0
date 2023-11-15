Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E0CC07548
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 11:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbjKOLlN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 06:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbjKOLlM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 06:41:12 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D23CE9
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 03:41:09 -0800 (PST)
Received: from [78.30.43.141] (port=50698 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r3EGW-00BeTv-5g; Wed, 15 Nov 2023 12:41:06 +0100
Date:   Wed, 15 Nov 2023 12:41:03 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v3 1/1] src: Add nfq_nlmsg_put2() -
 user specifies header flags
Message-ID: <ZVSuTwfVBEsCcthA@calendula>
References: <ZVSkE1fzi68CN+uo@calendula>
 <20231115113011.6620-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115113011.6620-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 15, 2023 at 10:30:11PM +1100, Duncan Roe wrote:
> Enable mnl programs to check whether a config request was accepted.
> (nfnl programs do this already).
> 
> v3: force on NLM_F_REQUEST
> 
> v2: take flags as an arg (Pablo request)
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
>  src/nlmsg.c                                   | 55 ++++++++++++++++++-
>  2 files changed, 55 insertions(+), 1 deletion(-)
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
> index 5400dd7..999ccfe 100644
> --- a/src/nlmsg.c
> +++ b/src/nlmsg.c
> @@ -309,10 +309,63 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
>   */
>  EXPORT_SYMBOL
>  struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num)
> +{
> +	return nfq_nlmsg_put2(buf, type, queue_num, 0);
> +}
> +
> +/**
> + * nfq_nlmsg_put2 - Convert memory buffer into a Netlink buffer with
> + * user-specified flags

This is setting up a netlink header in the memory buffer.

> + * \param *buf Pointer to memory buffer
> + * \param type Either NFQNL_MSG_CONFIG or NFQNL_MSG_VERDICT
> + * \param queue_num Queue number
> + * \param flags additional (to NLM_F_REQUEST) flags to put in message header,
> + *              commonly NLM_F_ACK

remove NLM_F_REQUEST here.

> + * \returns Pointer to netlink message

               Pointer to netlink header

> + *
> + * Use NLM_F_ACK before performing an action that might fail, e.g.

Failures are always reported.

if you set NLM_F_ACK, then you always get an acknowledgment from the
kernel, either 0 to report success or negative to report failure.

if you do not set NLM_F_ACK, then only failures are reported by the
kernel.

> + * attempt to configure NFQA_CFG_F_SECCTX on a system not runnine SELinux.
> + * \n
> + * NLM_F_ACK instructs the kernel to send a message in response
> + * to a successful command.

As I said above, this is not accurate.

> + * The kernel always sends a message in response to a failed command.
> + * \n
> + * This code snippet demonstrates reading these responses:
> + * \verbatim
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
> + * If there had been other items, they would not have been actioned and it would
> + * not now be safe to proceed.
> + */
> +
> +EXPORT_SYMBOL
> +struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num,
> +				uint16_t flags)
>  {
>  	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
>  	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | type;
> -	nlh->nlmsg_flags = NLM_F_REQUEST;
> +	nlh->nlmsg_flags = NLM_F_REQUEST | flags;
>  
>  	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
>  	nfg->nfgen_family = AF_UNSPEC;
> -- 
> 2.35.8
> 
