Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CD4C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D65D62067D
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfHMTgb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 15:36:31 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57466 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726137AbfHMTgb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 15:36:31 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hxcar-0003xg-O7; Tue, 13 Aug 2019 21:36:29 +0200
Date:   Tue, 13 Aug 2019 21:36:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 4/4] src: mnl: retry when we hit -ENOBUFS
Message-ID: <20190813193629.sypzwky5m6fhgy7d@breakpoint.cc>
References: <20190813184409.10757-1-fw@strlen.de>
 <20190813184409.10757-5-fw@strlen.de>
 <20190813193442.4egmzohinumixuth@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813193442.4egmzohinumixuth@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > diff --git a/src/mnl.c b/src/mnl.c
> > index 97a2e0765189..0c7a4c1fa63f 100644
> > --- a/src/mnl.c
> > +++ b/src/mnl.c
> > @@ -311,6 +311,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
> >  	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
> >  	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
> >  	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
> > +	unsigned int enobuf_restarts = 0;
> >  	size_t avg_msg_size, batch_size;
> >  	const struct sockaddr_nl snl = {
> >  		.nl_family = AF_NETLINK
> > @@ -320,6 +321,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
> >  		.tv_usec	= 0
> >  	};
> >  	struct iovec iov[iov_len];
> > +	unsigned int scale = 4;
> >  	struct msghdr msg = {};
> >  	fd_set readfds;
> >  
> > @@ -327,9 +329,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
> >  
> >  	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
> >  	avg_msg_size = div_round_up(batch_size, num_cmds);
> > -
> > -	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * 4);
> 
> Leaving this in place does not harm, right? This would speed up things
> for x86_64.

ok, I can keep it.

> It looks like s390 allocates larger page there to accomodate each
> netlink event.
> 
> All this probing and guess games could be fixed if there is a
> getsockopt() to fetch sk->sk_rmem_alloc, this is already exposed in
> netlink via /proc. Later :-)

How? The error occurs because sk_rmem_alloc is not large enough to
store all the netlink acks in the socket backlog.
