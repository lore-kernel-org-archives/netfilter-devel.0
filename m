Return-Path: <SRS0=BTt+=XF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4F8C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 11:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC50120872
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 11:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfIJLXA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 07:23:00 -0400
Received: from correo.us.es ([193.147.175.20]:33278 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbfIJLXA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 07:23:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7A5D31C4388
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2019 13:22:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C0C5B8001
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2019 13:22:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 609A0B7FFB; Tue, 10 Sep 2019 13:22:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2120ECF823;
        Tue, 10 Sep 2019 13:22:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 10 Sep 2019 13:22:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.177.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BACC14265A5A;
        Tue, 10 Sep 2019 13:22:53 +0200 (CEST)
Date:   Tue, 10 Sep 2019 13:22:54 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft] src: mnl: fix --echo buffer size -- again
Message-ID: <20190910112254.isfbdqjfg6aokcm7@salvia>
References: <20190909221918.28473-1-fw@strlen.de>
 <20190910085056.bfbgsgvhraatmsuc@salvia>
 <20190910105242.GC2066@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xhngxoa5eci5k4lc"
Content-Disposition: inline
In-Reply-To: <20190910105242.GC2066@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--xhngxoa5eci5k4lc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2019 at 12:52:42PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Sep 10, 2019 at 12:19:18AM +0200, Florian Westphal wrote:
> > [...]
> > > diff --git a/src/mnl.c b/src/mnl.c
> > > index 9c1f5356c9b9..d664564e16af 100644
> > > --- a/src/mnl.c
> > > +++ b/src/mnl.c
> > > @@ -311,8 +311,6 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
> > >  	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
> > >  	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
> > >  	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
> > > -	unsigned int enobuf_restarts = 0;
> > > -	size_t avg_msg_size, batch_size;
> > >  	const struct sockaddr_nl snl = {
> > >  		.nl_family = AF_NETLINK
> > >  	};
> > > @@ -321,17 +319,22 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
> > >  		.tv_usec	= 0
> > >  	};
> > >  	struct iovec iov[iov_len];
> > > -	unsigned int scale = 4;
> > >  	struct msghdr msg = {};
> > >  	fd_set readfds;
> > >  
> > >  	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
> > >  
> > > -	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
> > > -	avg_msg_size = div_round_up(batch_size, num_cmds);
> > > +	mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
> > >  
> > > -restart:
> > > -	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * scale);
> > > +	if (nft_output_echo(&ctx->nft->output)) {
> > > +		size_t buffer_size = MNL_SOCKET_BUFFER_SIZE * 1024;
> > > +		size_t new_buffer_size = num_cmds * 1024;
> > 
> > Probably all simplify this to?
> > 
> > 		mnl_set_rcvbuffer(ctx->nft->nf_sock, (1 << 10) * num_cmds);
> 
> Reason for above patch was to avoid any risk for normal operations by
> restricting the recvbuffer tuning to echo-mode and also adding a
> lower thresh.
> 
> For some reason I don't like the idea of setting only 1k recvbuf by
> default in the extreme case.

I'd still like to keep setting the receive buffer for the non-echo
case, a ruleset with lots of acknowledments (lots of errors) might hit
ENOBUFS, I remember that was reproducible.

Probably this? it's based on your patch.

--xhngxoa5eci5k4lc
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/mnl.c b/src/mnl.c
index 9c1f5356c9b9..8031bd6add80 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -304,6 +304,8 @@ static ssize_t mnl_nft_socket_sendmsg(struct netlink_ctx *ctx,
 	return sendmsg(mnl_socket_get_fd(ctx->nft->nf_sock), msg, 0);
 }
 
+#define NFT_MNL_ECHO_RCVBUFF_DEFAULT	(MNL_SOCKET_BUFFER_SIZE * 1024)
+
 int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 		   uint32_t num_cmds)
 {
@@ -311,8 +313,6 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
 	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
 	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
-	unsigned int enobuf_restarts = 0;
-	size_t avg_msg_size, batch_size;
 	const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
 	};
@@ -321,17 +321,24 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 		.tv_usec	= 0
 	};
 	struct iovec iov[iov_len];
-	unsigned int scale = 4;
 	struct msghdr msg = {};
+	unsigned int rcvbufsiz;
+	size_t batch_size;
 	fd_set readfds;
 
 	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
 
 	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
-	avg_msg_size = div_round_up(batch_size, num_cmds);
 
-restart:
-	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * scale);
+	if (nft_output_echo(&ctx->nft->output)) {
+		rcvbufsiz = num_cmds * 1024;
+		if (rcvbufsiz < NFT_MNL_ECHO_RCVBUFF_DEFAULT)
+			rcvbufsiz = NFT_MNL_ECHO_RCVBUFF_DEFAULT;
+	} else {
+		rcvbufsiz = num_cmds * div_round_up(batch_size, num_cmds) * 4;
+	}
+
+	mnl_set_rcvbuffer(ctx->nft->nf_sock, rcvbufsiz);
 
 	ret = mnl_nft_socket_sendmsg(ctx, &msg);
 	if (ret == -1)
@@ -350,13 +357,8 @@ restart:
 			break;
 
 		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
-		if (ret == -1) {
-			if (errno == ENOBUFS && enobuf_restarts++ < 3) {
-				scale *= 2;
-				goto restart;
-			}
+		if (ret == -1)
 			return -1;
-		}
 
 		ret = mnl_cb_run(rcv_buf, ret, 0, portid, &netlink_echo_callback, ctx);
 		/* Continue on error, make sure we get all acknowledgments */

--xhngxoa5eci5k4lc--
