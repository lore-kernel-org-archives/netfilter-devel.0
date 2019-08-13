Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620C2C32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 404102067D
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfHMTes (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 15:34:48 -0400
Received: from correo.us.es ([193.147.175.20]:39186 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfHMTer (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 15:34:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 64AA0B6323
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:34:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 567F11150CB
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:34:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4C5051150B9; Tue, 13 Aug 2019 21:34:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4AD96A75E;
        Tue, 13 Aug 2019 21:34:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 21:34:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 235954265A2F;
        Tue, 13 Aug 2019 21:34:43 +0200 (CEST)
Date:   Tue, 13 Aug 2019 21:34:42 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 4/4] src: mnl: retry when we hit -ENOBUFS
Message-ID: <20190813193442.4egmzohinumixuth@salvia>
References: <20190813184409.10757-1-fw@strlen.de>
 <20190813184409.10757-5-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813184409.10757-5-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 13, 2019 at 08:44:09PM +0200, Florian Westphal wrote:
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
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/mnl.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/src/mnl.c b/src/mnl.c
> index 97a2e0765189..0c7a4c1fa63f 100644
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
> @@ -327,9 +329,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
>  
>  	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
>  	avg_msg_size = div_round_up(batch_size, num_cmds);
> -
> -	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * 4);

Leaving this in place does not harm, right? This would speed up things
for x86_64.

It looks like s390 allocates larger page there to accomodate each
netlink event.

All this probing and guess games could be fixed if there is a
getsockopt() to fetch sk->sk_rmem_alloc, this is already exposed in
netlink via /proc. Later :-)
