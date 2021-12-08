Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAC4C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 18:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238642AbhLHSOq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 13:14:46 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41174 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238613AbhLHSOq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 13:14:46 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id F07F9605C4;
        Wed,  8 Dec 2021 19:08:49 +0100 (CET)
Date:   Wed, 8 Dec 2021 19:11:08 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eugene Crosser <crosser@average.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] Handle retriable errors from mnl functions
Message-ID: <YbD1PNLwpV/uGjn4@salvia>
References: <20211208134914.16365-1-crosser@average.org>
 <20211208134914.16365-3-crosser@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211208134914.16365-3-crosser@average.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 08, 2021 at 02:49:14PM +0100, Eugene Crosser wrote:
> diff --git a/src/iface.c b/src/iface.c
> index d0e1834c..029f6476 100644
> --- a/src/iface.c
> +++ b/src/iface.c
> @@ -66,39 +66,54 @@ void iface_cache_update(void)
>  	struct nlmsghdr *nlh;
>  	struct rtgenmsg *rt;
>  	uint32_t seq, portid;
> +	bool need_restart;
> +	int retry_count = 5;
>  	int ret;
>  
> -	nlh = mnl_nlmsg_put_header(buf);
> -	nlh->nlmsg_type	= RTM_GETLINK;
> -	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
> -	nlh->nlmsg_seq = seq = time(NULL);
> -	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
> -	rt->rtgen_family = AF_PACKET;
> -
> -	nl = mnl_socket_open(NETLINK_ROUTE);
> -	if (nl == NULL)
> -		netlink_init_error();
> -
> -	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
> -		netlink_init_error();
> -
> -	portid = mnl_socket_get_portid(nl);
> -
> -	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
> -		netlink_init_error();
> -
> -	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> -	while (ret > 0) {
> -		ret = mnl_cb_run(buf, ret, seq, portid, data_cb, NULL);
> -		if (ret <= MNL_CB_STOP)
> -			break;
> -		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> -	}
> -	if (ret == -1)
> +	do {
> +		nlh = mnl_nlmsg_put_header(buf);
> +		nlh->nlmsg_type	= RTM_GETLINK;
> +		nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
> +		nlh->nlmsg_seq = seq = time(NULL);
> +		rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
> +		rt->rtgen_family = AF_PACKET;
> +
> +		nl = mnl_socket_open(NETLINK_ROUTE);
> +		if (nl == NULL)
> +			netlink_init_error();
> +
> +		if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
> +			netlink_init_error();
> +
> +		portid = mnl_socket_get_portid(nl);
> +
> +		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
> +			netlink_init_error();
> +
> +		need_restart = false;
> +		while (true) {
> +			ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> +			if (ret == -1) {
> +				if (errno == EINTR)
> +					continue;
> +				else
> +					netlink_init_error();
> +			}
> +			ret = mnl_cb_run(buf, ret, seq, portid, data_cb, NULL);
> +			if (ret == MNL_CB_STOP)
> +				break;
> +			if (ret == -1) {
> +				if (errno == EINTR)
> +					need_restart = true;
> +				else
> +					netlink_init_error();
> +			}
> +		}
> +		mnl_socket_close(nl);

BTW, could you just rename iface_cache_update() to
__iface_cache_update() then add the loop to retry on EINTR? That would
skip this extra large indent in this patch.

Thanks.

> +	} while (need_restart && retry_count--);
> +	if (need_restart)
>  		netlink_init_error();
>  
> -	mnl_socket_close(nl);
> -
>  	iface_cache_init = true;
>  }
>  
> -- 
> 2.32.0
> 
