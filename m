Return-Path: <SRS0=BTt+=XF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E479C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 10:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E6AA20692
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 10:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbfIJKwo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 06:52:44 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42774 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729511AbfIJKwo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 06:52:44 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i7dlK-0005if-F4; Tue, 10 Sep 2019 12:52:42 +0200
Date:   Tue, 10 Sep 2019 12:52:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft] src: mnl: fix --echo buffer size -- again
Message-ID: <20190910105242.GC2066@breakpoint.cc>
References: <20190909221918.28473-1-fw@strlen.de>
 <20190910085056.bfbgsgvhraatmsuc@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910085056.bfbgsgvhraatmsuc@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Sep 10, 2019 at 12:19:18AM +0200, Florian Westphal wrote:
> [...]
> > diff --git a/src/mnl.c b/src/mnl.c
> > index 9c1f5356c9b9..d664564e16af 100644
> > --- a/src/mnl.c
> > +++ b/src/mnl.c
> > @@ -311,8 +311,6 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
> >  	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
> >  	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
> >  	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
> > -	unsigned int enobuf_restarts = 0;
> > -	size_t avg_msg_size, batch_size;
> >  	const struct sockaddr_nl snl = {
> >  		.nl_family = AF_NETLINK
> >  	};
> > @@ -321,17 +319,22 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
> >  		.tv_usec	= 0
> >  	};
> >  	struct iovec iov[iov_len];
> > -	unsigned int scale = 4;
> >  	struct msghdr msg = {};
> >  	fd_set readfds;
> >  
> >  	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
> >  
> > -	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
> > -	avg_msg_size = div_round_up(batch_size, num_cmds);
> > +	mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
> >  
> > -restart:
> > -	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * scale);
> > +	if (nft_output_echo(&ctx->nft->output)) {
> > +		size_t buffer_size = MNL_SOCKET_BUFFER_SIZE * 1024;
> > +		size_t new_buffer_size = num_cmds * 1024;
> 
> Probably all simplify this to?
> 
> 		mnl_set_rcvbuffer(ctx->nft->nf_sock, (1 << 10) * num_cmds);

Reason for above patch was to avoid any risk for normal operations by
restricting the recvbuffer tuning to echo-mode and also adding a
lower thresh.

For some reason I don't like the idea of setting only 1k recvbuf by
default in the extreme case.

That said, it does seem to work.
