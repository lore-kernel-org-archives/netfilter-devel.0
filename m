From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft patch]add default branch for code integrality
Date: Thu, 26 Nov 2015 10:49:17 +0100
Message-ID: <20151126094917.GA1578@salvia>
References: <0A900C78B9F2324AB7F4F7A51D1A2F85779782D0@szxema505-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Linmujia <linmujia@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34725 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbbKZJtZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 04:49:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id ED95A1324E5
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 10:49:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D4E98DA860
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 10:49:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E6F6DDA85E
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 10:49:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <0A900C78B9F2324AB7F4F7A51D1A2F85779782D0@szxema505-mbs.china.huawei.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 26, 2015 at 09:32:02AM +0000, Linmujia wrote:
> Hi,I reviewed nftables code and add some default branch for code itegrality.
> 
> Thanks!
> 
> Signed-off-by: linmujia <linmujia@huawei.com>
> ---
> src/netlink.c | 25 +++++++++++++++++++++++++
> 1 file changed, 25 insertions(+)
> 
> diff --git a/src/netlink.c b/src/netlink.c
> index 974afb1..7821169 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -307,6 +307,8 @@ static void netlink_gen_verdict(const struct expr *expr,
>                 strncpy(data->chain, expr->chain, NFT_CHAIN_MAXNAMELEN);
>                 data->chain[NFT_CHAIN_MAXNAMELEN-1] = '\0';
>                 break;
> +       default:
> +                BUG("invalid verdict value %u\n", expr->verdict);
>        }
> }
> @@ -1670,6 +1672,8 @@ static uint32_t netlink_msg2nftnl_of(uint32_t msg)
>        case NFT_MSG_DELSETELEM:
>        case NFT_MSG_DELRULE:
>                 return NFTNL_OF_EVENT_DEL;
> +       default:
> +                BUG("invalid nft msg type %u\n", msg);
>        }
>         return 0;
> @@ -1741,6 +1745,8 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
>                                      netlink_msg2nftnl_of(type));
>                 fprintf(stdout, "\n");
>                 break;
> +       default:
> +                BUG("invalid output format %u\n", monh->format);

This will break old nft versions with new kernels, in case we add new
netlink messages.

And that is very likely to happen.
