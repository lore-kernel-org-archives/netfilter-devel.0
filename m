Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC669C28CC0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 18:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CECC4240AD
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 18:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfE2Ssq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 14:48:46 -0400
Received: from mail.us.es ([193.147.175.20]:51722 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfE2Ssq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 14:48:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4D6B9BAEE8
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 20:48:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D8FEDA70B
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 20:48:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 33575DA704; Wed, 29 May 2019 20:48:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2EB8CDA707;
        Wed, 29 May 2019 20:48:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 May 2019 20:48:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0BDD14265A32;
        Wed, 29 May 2019 20:48:42 +0200 (CEST)
Date:   Wed, 29 May 2019 20:48:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nft PATCH 3/4] mnl: Fix and simplify mnl_batch_talk()
Message-ID: <20190529184841.e6jyuxflo7vhjulw@salvia>
References: <20190529131346.23659-1-phil@nwl.cc>
 <20190529131346.23659-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529131346.23659-4-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 29, 2019 at 03:13:45PM +0200, Phil Sutter wrote:
> Use of select() after the first call to mnl_socket_recvfrom() was
> incorrect, FD_SET() was called after the call to select() returned. This
> effectively turned the FD_ISSET() check into a noop (always true
> condition).

Good catch.

> Rewrite the receive loop using mnl_nft_event_listener() as an example:
> 
> * Combine the two calls to FD_ZERO(), FD_SET() and select() into one at
>   loop start.
> * Check ENOBUFS condition and warn the user, also upon other errors.
> * Continue on ENOBUFS, it is not a permanent error.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/mnl.c | 39 ++++++++++++++++++++++-----------------
>  1 file changed, 22 insertions(+), 17 deletions(-)
> 
> diff --git a/src/mnl.c b/src/mnl.c
> index 06280aa2cb50a..4fbfd059c0228 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -299,34 +299,39 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
>  	if (ret == -1)
>  		return -1;
>  
> -	FD_ZERO(&readfds);
> -	FD_SET(fd, &readfds);
> +	while (true) {
> +		FD_ZERO(&readfds);
> +		FD_SET(fd, &readfds);
>  
> -	/* receive and digest all the acknowledgments from the kernel. */
> -	ret = select(fd+1, &readfds, NULL, NULL, &tv);
> -	if (ret == -1)
> -		return -1;
> +		/* receive and digest all the acknowledgments from the kernel. */
> +		ret = select(fd + 1, &readfds, NULL, NULL, &tv);
> +		if (ret < 0)
> +			return -1;
>  
> -	while (ret > 0 && FD_ISSET(fd, &readfds)) {
> -		struct nlmsghdr *nlh = (struct nlmsghdr *)rcv_buf;
> +		if (!FD_ISSET(fd, &readfds))
> +			break;
>  
>  		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
> -		if (ret == -1)
> -			return -1;
> +		if (ret < 0) {
> +			if (errno == ENOBUFS) {
> +				nft_print(&ctx->nft->output,
> +					  "# ERROR: We lost some netlink events!\n");

Probably better handling this from nft_netlink().

Could you just fix the problem you report above? Then, we make another
pass on this ENOBUFS error.

> +				continue;
> +			}
> +			nft_print(&ctx->nft->output, "# ERROR: %s\n",
> +				  strerror(errno));
> +			err = ret;
> +			break;
> +		}
>  
>  		ret = mnl_cb_run(rcv_buf, ret, 0, portid, &netlink_echo_callback, ctx);
>  		/* Continue on error, make sure we get all acknowledgments */
>  		if (ret == -1) {
> +			struct nlmsghdr *nlh = (struct nlmsghdr *)rcv_buf;
> +
>  			mnl_err_list_node_add(err_list, errno, nlh->nlmsg_seq);
>  			err = -1;
>  		}
> -
> -		ret = select(fd+1, &readfds, NULL, NULL, &tv);
> -		if (ret == -1)
> -			return -1;
> -
> -		FD_ZERO(&readfds);
> -		FD_SET(fd, &readfds);
>  	}
>  	return err;
>  }
> -- 
> 2.21.0
> 
