Return-Path: <SRS0=1PIt=XE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97937C4740C
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Sep 2019 21:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 702FA218AF
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Sep 2019 21:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388129AbfIIVLO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Sep 2019 17:11:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727483AbfIIVLO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Sep 2019 17:11:14 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 421063091D69;
        Mon,  9 Sep 2019 21:11:13 +0000 (UTC)
Received: from egarver.localdomain (ovpn-123-28.rdu2.redhat.com [10.10.123.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2CA45C21E;
        Mon,  9 Sep 2019 21:11:11 +0000 (UTC)
Date:   Mon, 9 Sep 2019 17:11:10 -0400
From:   Eric Garver <eric@garver.life>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables 3/3] src: mnl: retry when we hit -ENOBUFS
Message-ID: <20190909211110.2dzcta4dgengb4wy@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20190813201246.5543-1-fw@strlen.de>
 <20190813201246.5543-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813201246.5543-4-fw@strlen.de>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 09 Sep 2019 21:11:13 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Tue, Aug 13, 2019 at 10:12:46PM +0200, Florian Westphal wrote:
> tests/shell/testcases/transactions/0049huge_0
> 
> still fails with ENOBUFS error after endian fix done in
> previous patch.  Its enough to increase the scale factor (4)
> on s390x, but rather than continue with these "guess the proper
> size" game, just increase the buffer size and retry up to 3 times.
> 
> This makes above test work on s390x.
> 
> So, implement what Pablo suggested in the earlier commit:
>     We could also explore increasing the buffer and retry if
>     mnl_nft_socket_sendmsg() hits ENOBUFS if we ever hit this problem again.
> 
> v2: call setsockopt unconditionally, then increase on error.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/mnl.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/src/mnl.c b/src/mnl.c
> index 97a2e0765189..9c1f5356c9b9 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -311,6 +311,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
>  	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
>  	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
>  	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
> +	unsigned int enobuf_restarts = 0;
>  	size_t avg_msg_size, batch_size;
>  	const struct sockaddr_nl snl = {
>  		.nl_family = AF_NETLINK
> @@ -320,6 +321,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
>  		.tv_usec	= 0
>  	};
>  	struct iovec iov[iov_len];
> +	unsigned int scale = 4;
>  	struct msghdr msg = {};
>  	fd_set readfds;
>  
> @@ -328,7 +330,8 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
>  	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
>  	avg_msg_size = div_round_up(batch_size, num_cmds);
>  
> -	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * 4);
> +restart:
> +	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * scale);
>  
>  	ret = mnl_nft_socket_sendmsg(ctx, &msg);
>  	if (ret == -1)
> @@ -347,8 +350,13 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
>  			break;
>  
>  		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
> -		if (ret == -1)
> +		if (ret == -1) {
> +			if (errno == ENOBUFS && enobuf_restarts++ < 3) {
> +				scale *= 2;
> +				goto restart;
> +			}

If this restart is triggered it causes rules to be duplicated. We send
the same batch again.

I'm hitting this on x86_64. Maybe we need find a better way to estimate
the rcvbuffer in the case of --echo. By the time we see ENOBUFS we're
already in a bad way - events have already be lost.

>  			return -1;
> +		}
>  
>  		ret = mnl_cb_run(rcv_buf, ret, 0, portid, &netlink_echo_callback, ctx);
>  		/* Continue on error, make sure we get all acknowledgments */
> -- 
> 2.21.0
> 
