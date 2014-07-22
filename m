From: Yanchuan Nian <ycnian@gmail.com>
Subject: Re: [PATCH nft 3/3] src: rework batching logic to fix possible use
 of uninitialized pages
Date: Tue, 22 Jul 2014 20:18:45 +0800
Message-ID: <20140722121845.GA21492@localhost.localdomain>
References: <1405439238-10186-1-git-send-email-pablo@netfilter.org>
 <1405439238-10186-3-git-send-email-pablo@netfilter.org>
 <20140722110203.GA4348@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34651 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbaGVMP2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:15:28 -0400
Received: by mail-pd0-f173.google.com with SMTP id w10so11115784pde.18
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2014 05:15:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140722110203.GA4348@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 22, 2014 at 07:02:03PM +0800, Yanchuan Nian wrote:
> On Tue, Jul 15, 2014 at 05:47:18PM +0200, Pablo Neira Ayuso wrote:
> > This patch reworks the batching logic in several aspects:
> > 
> > 1) New batch pages are now always added into the batch page list in
> >    first place. Then, in the send path, if the last batch page is
> >    empty, it is removed from the batch list.
> > 
> > 2) nft_batch_page_add() is only called if the current batch page is
> >    full. Therefore, it is guaranteed to find a valid netlink message
> >    in the batch page when moving the tail that didn't fit into a new
> >    batch page.
> > 
> > 3) The batch paging is initialized and released from the nft_netlink()
> >    path.
> > 
> > 4) No more global struct mnl_nlmsg_batch *batch that points to the
> >    current batch page. Instead, it is retrieved from the tail of the
> >    batch list, which indicates the current batch page.
> > 
> > This patch fixes a crash due to access of uninitialized memory area in
> > due to calling batch_page_add() with an empty batch in the send path,
> > and the memleak of the batch page contents. Reported in:
> > 
> > http://patchwork.ozlabs.org/patch/367085/
> > http://patchwork.ozlabs.org/patch/367774/
> > 
> > The patch is larger, but this save the zeroing of the batch page area.
> 
> Tested, it works find. Just a little question: is it better to release
> all batches but the current after each message sending?
> 
My misunderstanding. No questions now.

> > 
> > Reported-by: Yanchuan Nian <ycnian@gmail.com>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  src/main.c    |   14 +++++-----
> >  src/mnl.c     |   82 ++++++++++++++++++++++++++++++++-------------------------
> >  src/netlink.c |    1 -
> >  3 files changed, 54 insertions(+), 43 deletions(-)
> > 
> > diff --git a/src/main.c b/src/main.c
> > index 30ea2c6..552a35d 100644
> > --- a/src/main.c
> > +++ b/src/main.c
> > @@ -173,6 +173,8 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
> >  	bool batch_supported = netlink_batch_supported();
> >  	int ret = 0;
> >  
> > +	mnl_batch_init();
> > +
> >  	batch_seqnum = mnl_batch_begin();
> >  	list_for_each_entry(cmd, &state->cmds, list) {
> >  		memset(&ctx, 0, sizeof(ctx));
> > @@ -182,16 +184,14 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
> >  		init_list_head(&ctx.list);
> >  		ret = do_command(&ctx, cmd);
> >  		if (ret < 0)
> > -			return ret;
> > +			goto out;
> >  	}
> >  	mnl_batch_end();
> >  
> > -	if (mnl_batch_ready())
> > -		ret = netlink_batch_send(&err_list);
> > -	else {
> > -		mnl_batch_reset();
> > +	if (!mnl_batch_ready())
> >  		goto out;
> > -	}
> > +
> > +	ret = netlink_batch_send(&err_list);
> >  
> >  	list_for_each_entry_safe(err, tmp, &err_list, head) {
> >  		list_for_each_entry(cmd, &state->cmds, list) {
> > @@ -208,6 +208,8 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
> >  		}
> >  	}
> >  out:
> > +	mnl_batch_reset();
> > +
> >  	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
> >  		list_del(&cmd->list);
> >  		cmd_free(cmd);
> > diff --git a/src/mnl.c b/src/mnl.c
> > index e4f0339..42b11f5 100644
> > --- a/src/mnl.c
> > +++ b/src/mnl.c
> > @@ -82,8 +82,6 @@ nft_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
> >   */
> >  #define BATCH_PAGE_SIZE getpagesize() * 32
> >  
> > -static struct mnl_nlmsg_batch *batch;
> > -
> >  static struct mnl_nlmsg_batch *mnl_batch_alloc(void)
> >  {
> >  	static char *buf;
> > @@ -93,11 +91,6 @@ static struct mnl_nlmsg_batch *mnl_batch_alloc(void)
> >  	return mnl_nlmsg_batch_start(buf, BATCH_PAGE_SIZE);
> >  }
> >  
> > -void mnl_batch_init(void)
> > -{
> > -	batch = mnl_batch_alloc();
> > -}
> > -
> >  static LIST_HEAD(batch_page_list);
> >  static int batch_num_pages;
> >  
> > @@ -106,35 +99,53 @@ struct batch_page {
> >  	struct mnl_nlmsg_batch *batch;
> >  };
> >  
> > +void mnl_batch_init(void)
> > +{
> > +	struct batch_page *batch_page;
> > +
> > +	batch_page = xmalloc(sizeof(struct batch_page));
> > +	batch_page->batch = mnl_batch_alloc();
> > +	batch_num_pages++;
> > +	list_add_tail(&batch_page->head, &batch_page_list);
> > +}
> > +
> > +static struct batch_page *nft_batch_page_current(void)
> > +{
> > +	return list_entry(batch_page_list.prev, struct batch_page, head);
> > +}
> > +
> >  static void *nft_nlmsg_batch_current(void)
> >  {
> > -	return mnl_nlmsg_batch_current(batch);
> > +	return mnl_nlmsg_batch_current(nft_batch_page_current()->batch);
> >  }
> >  
> > -static void mnl_batch_page_add(void)
> > +static void nft_batch_page_add(void)
> >  {
> > -	struct batch_page *batch_page;
> >  	struct nlmsghdr *last_nlh;
> >  
> >  	/* Get the last message not fitting in the batch */
> >  	last_nlh = nft_nlmsg_batch_current();
> > -
> > -	batch_page = xmalloc(sizeof(struct batch_page));
> > -	batch_page->batch = batch;
> > -	list_add_tail(&batch_page->head, &batch_page_list);
> > -	batch_num_pages++;
> > -	batch = mnl_batch_alloc();
> > -
> > +	/* Add new batch page */
> > +	mnl_batch_init();
> >  	/* Copy the last message not fitting to the new batch page */
> >  	memcpy(nft_nlmsg_batch_current(), last_nlh, last_nlh->nlmsg_len);
> >  	/* No overflow may happen as this is a new empty batch page */
> > -	mnl_nlmsg_batch_next(batch);
> > +	mnl_nlmsg_batch_next(nft_batch_page_current()->batch);
> > +}
> > +
> > +static void nft_batch_page_release(struct batch_page *batch_page)
> > +{
> > +	list_del(&batch_page->head);
> > +	xfree(mnl_nlmsg_batch_head(batch_page->batch));
> > +	mnl_nlmsg_batch_stop(batch_page->batch);
> > +	xfree(batch_page);
> > +	batch_num_pages--;
> >  }
> >  
> >  static void nft_batch_continue(void)
> >  {
> > -	if (!mnl_nlmsg_batch_next(batch))
> > -		mnl_batch_page_add();
> > +	if (!mnl_nlmsg_batch_next(nft_batch_page_current()->batch))
> > +		nft_batch_page_add();
> >  }
> >  
> >  static uint32_t mnl_batch_put(int type)
> > @@ -171,12 +182,16 @@ bool mnl_batch_ready(void)
> >  	/* Check if the batch only contains the initial and trailing batch
> >  	 * messages. In that case, the batch is empty.
> >  	 */
> > -	return mnl_nlmsg_batch_size(batch) != (NLMSG_HDRLEN+sizeof(struct nfgenmsg)) * 2;
> > +	return mnl_nlmsg_batch_size(nft_batch_page_current()->batch) !=
> > +	       (NLMSG_HDRLEN+sizeof(struct nfgenmsg)) * 2;
> >  }
> >  
> >  void mnl_batch_reset(void)
> >  {
> > -	mnl_nlmsg_batch_reset(batch);
> > +	struct batch_page *batch_page, *next;
> > +
> > +	list_for_each_entry_safe(batch_page, next, &batch_page_list, head)
> > +		nft_batch_page_release(batch_page);
> >  }
> >  
> >  static void mnl_err_list_node_add(struct list_head *err_list, int error,
> > @@ -226,12 +241,12 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
> >  		.msg_iov	= iov,
> >  		.msg_iovlen	= batch_num_pages,
> >  	};
> > -	struct batch_page *batch_page, *next;
> > +	struct batch_page *batch_page;
> >  	int i = 0;
> >  
> >  	mnl_set_sndbuffer(nl);
> >  
> > -	list_for_each_entry_safe(batch_page, next, &batch_page_list, head) {
> > +	list_for_each_entry(batch_page, &batch_page_list, head) {
> >  		iov[i].iov_base = mnl_nlmsg_batch_head(batch_page->batch);
> >  		iov[i].iov_len = mnl_nlmsg_batch_size(batch_page->batch);
> >  		i++;
> > @@ -243,10 +258,6 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
> >  					  sizeof(struct nfgenmsg));
> >  		}
> >  #endif
> > -		list_del(&batch_page->head);
> > -		xfree(batch_page->batch);
> > -		xfree(batch_page);
> > -		batch_num_pages--;
> >  	}
> >  
> >  	return sendmsg(mnl_socket_get_fd(nl), &msg, 0);
> > @@ -262,12 +273,13 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
> >  		.tv_usec	= 0
> >  	};
> >  
> > -	if (!mnl_nlmsg_batch_is_empty(batch))
> > -		mnl_batch_page_add();
> > +	/* Remove last page from the batch if it's empty */
> > +	if (mnl_nlmsg_batch_is_empty(nft_batch_page_current()->batch))
> > +		nft_batch_page_release(nft_batch_page_current());
> >  
> >  	ret = mnl_nft_socket_sendmsg(nl);
> >  	if (ret == -1)
> > -		goto err;
> > +		return -1;
> >  
> >  	FD_ZERO(&readfds);
> >  	FD_SET(fd, &readfds);
> > @@ -275,14 +287,14 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
> >  	/* receive and digest all the acknowledgments from the kernel. */
> >  	ret = select(fd+1, &readfds, NULL, NULL, &tv);
> >  	if (ret == -1)
> > -		goto err;
> > +		return -1;
> >  
> >  	while (ret > 0 && FD_ISSET(fd, &readfds)) {
> >  		struct nlmsghdr *nlh = (struct nlmsghdr *)rcv_buf;
> >  
> >  		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
> >  		if (ret == -1)
> > -			goto err;
> > +			return -1;
> >  
> >  		ret = mnl_cb_run(rcv_buf, ret, 0, portid, NULL, NULL);
> >  		/* Continue on error, make sure we get all acknowledgments */
> > @@ -291,13 +303,11 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
> >  
> >  		ret = select(fd+1, &readfds, NULL, NULL, &tv);
> >  		if (ret == -1)
> > -			goto err;
> > +			return -1;
> >  
> >  		FD_ZERO(&readfds);
> >  		FD_SET(fd, &readfds);
> >  	}
> > -err:
> > -	mnl_nlmsg_batch_reset(batch);
> >  	return ret;
> >  }
> >  
> > diff --git a/src/netlink.c b/src/netlink.c
> > index afad5a4..0176cb4 100644
> > --- a/src/netlink.c
> > +++ b/src/netlink.c
> > @@ -59,7 +59,6 @@ static void __init netlink_open_sock(void)
> >  {
> >  	nf_sock = nfsock_open();
> >  	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
> > -	mnl_batch_init();
> >  }
> >  
> >  static void __exit netlink_close_sock(void)
> > -- 
> > 1.7.10.4
