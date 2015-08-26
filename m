From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [lnf-log PATCHv2 1/3] introduce new functions independent from
 libnfnetlink
Date: Wed, 26 Aug 2015 21:01:21 +0200
Message-ID: <20150826190121.GA18364@salvia>
References: <20150810081342.GB25169@gmail.com>
 <20150810081752.GD25169@gmail.com>
 <20150818060409.GA3062@salvia>
 <20150819071103.GA15064@gmail.com>
 <20150819220403.GA5220@salvia>
 <20150820072645.GA3916@gmail.com>
 <20150820181613.GA4227@salvia>
 <20150821002306.GA11754@gmail.com>
 <20150821002608.GB11754@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50633 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbbHZSzA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2015 14:55:00 -0400
Content-Disposition: inline
In-Reply-To: <20150821002608.GB11754@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 21, 2015 at 09:26:08AM +0900, Ken-ichirou MATSUZAWA wrote:
> The libnetfilter_log.c file contains the old API, its use is
> discouraged since it depends on libnfnetlink.
> 
> The idea is to provide a set of helper functions that we can use in
> conjunction with libmnl, similar to what we have in
> libnetfilter_queue/nlmsg.c

Applied with minor change, thanks!

> +int nflog_attr_put_cfg_mode(struct nlmsghdr *nlh, uint8_t mode, uint32_t range)
> +{
> +	struct nfulnl_msg_config_mode nfmode = {
> +		.copy_mode = mode,
> +		.copy_range = htonl(range)
> +	};
> +
> +	mnl_attr_put(nlh, NFULA_CFG_MODE, sizeof(nfmode), &nfmode);
> +
> +	/* it may returns -1 in future */
> +	return 1;

This is now returning 0 instead.

So we reserve negative values for errors, 0 means success and >= 0 are
left unused for future use.
