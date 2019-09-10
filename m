Return-Path: <SRS0=BTt+=XF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FBBC3A5A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 08:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E66A20863
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 08:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfIJIvD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 04:51:03 -0400
Received: from correo.us.es ([193.147.175.20]:38170 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbfIJIvD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 04:51:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 71B972A2BBA
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2019 10:50:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61CCFD2B1F
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2019 10:50:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 575DC2DC8C; Tue, 10 Sep 2019 10:50:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36830DA801;
        Tue, 10 Sep 2019 10:50:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 10 Sep 2019 10:50:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.45.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 042CD42EE38E;
        Tue, 10 Sep 2019 10:50:55 +0200 (CEST)
Date:   Tue, 10 Sep 2019 10:50:56 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft] src: mnl: fix --echo buffer size -- again
Message-ID: <20190910085056.bfbgsgvhraatmsuc@salvia>
References: <20190909221918.28473-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909221918.28473-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 10, 2019 at 12:19:18AM +0200, Florian Westphal wrote:
[...]
> diff --git a/src/mnl.c b/src/mnl.c
> index 9c1f5356c9b9..d664564e16af 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -311,8 +311,6 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
>  	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
>  	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
>  	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
> -	unsigned int enobuf_restarts = 0;
> -	size_t avg_msg_size, batch_size;
>  	const struct sockaddr_nl snl = {
>  		.nl_family = AF_NETLINK
>  	};
> @@ -321,17 +319,22 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
>  		.tv_usec	= 0
>  	};
>  	struct iovec iov[iov_len];
> -	unsigned int scale = 4;
>  	struct msghdr msg = {};
>  	fd_set readfds;
>  
>  	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
>  
> -	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
> -	avg_msg_size = div_round_up(batch_size, num_cmds);
> +	mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
>  
> -restart:
> -	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * scale);
> +	if (nft_output_echo(&ctx->nft->output)) {
> +		size_t buffer_size = MNL_SOCKET_BUFFER_SIZE * 1024;
> +		size_t new_buffer_size = num_cmds * 1024;

Probably all simplify this to?

		mnl_set_rcvbuffer(ctx->nft->nf_sock, (1 << 10) * num_cmds);

Upper limit for us is NLMSG_GOODSIZE, which is not exposed to
userspace, although we have control over that upper limit from
nf_tables. In practise, I think we go over the 1 Kbytes per message
boundary.

> +
> +		if (new_buffer_size > buffer_size)
> +			buffer_size = new_buffer_size;
> +
> +		mnl_set_rcvbuffer(ctx->nft->nf_sock, buffer_size);
> +	}
>  
>  	ret = mnl_nft_socket_sendmsg(ctx, &msg);
>  	if (ret == -1)
