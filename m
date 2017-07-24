From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] monitor: Print NEWGEN events
Date: Mon, 24 Jul 2017 13:17:30 +0200
Message-ID: <20170724111730.GA6691@salvia>
References: <20170719143257.3772-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45306 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751649AbdGXLRk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 07:17:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 33EBDCA4A1
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 13:17:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22C9ADA80E
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 13:17:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33279A0AD8
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 13:17:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170719143257.3772-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 19, 2017 at 04:32:57PM +0200, Phil Sutter wrote:
> Now that they contain process information, they're actually interesting.
> For backwards compatibility, print process information only if it was
> present in the message.

Wait, a couple of comments.

[...]
> diff --git a/src/netlink.c b/src/netlink.c
> index e3c90dac8c7a6..44a9806097d00 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -2915,6 +2915,43 @@ static void netlink_events_debug(uint16_t type)
>  #endif /* DEBUG */
>  }
>  
> +static int netlink_events_newgen_cb(const struct nlmsghdr *nlh, int type,
> +				    struct netlink_mon_handler *monh)
> +{
> +	const struct nlattr *attr;
> +	char name[256] = "";
> +	int genid, pid = -1;
> +
> +	mnl_attr_for_each(attr, nlh, sizeof(struct nfgenmsg)) {
> +		switch (mnl_attr_get_type(attr)) {
> +		case NFTA_GEN_ID:
> +			if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
> +				break;

I think it's better to hit netlink_abi_error() error. If validation
fails, it means someone in the kernel has accidentally changed the
size/type of this attribute. This it's basically breaking the ABI.
Better bail out here so people come to us so we quickly fix this.

> +			genid = ntohl(mnl_attr_get_u32(attr));
> +			break;
> +		case NFTA_GEN_PROC_NAME:
> +			if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
> +				break;
> +			strncpy(name, mnl_attr_get_str(attr), sizeof(name));

What is maximum process name length? If we hit this bound, we have to
make sure this does:

                        name[X - 1] = '\0';

Where X is the name buffer size.

> +			break;
> +		case NFTA_GEN_PROC_ID:
> +			if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
> +				break;
> +			pid = ntohl(mnl_attr_get_u32(attr));
> +			break;
> +		}
> +	}
> +	printf("new generation %d", genid);

Please, prepend '#' to this message.

> +	if (pid >= 0) {
> +		printf(" by process %d", pid);
> +		if (!monh->ctx->octx->numeric)
> +			printf(" (%s)", name);
> +	}
> +	printf("\n");
> +
> +	return MNL_CB_OK;
> +}

Thanks!
