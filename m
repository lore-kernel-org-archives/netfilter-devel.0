From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_conntrack PATCH 2/3] src: add support for IPv6 NAT
Date: Tue, 17 May 2016 17:38:06 +0200
Message-ID: <20160517153806.GA1397@salvia>
References: <146348935823.4910.10745657047372991575.stgit@nfdev2.cica.es>
 <146348943723.4910.7071079736393329605.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33705 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbcEQPiN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 11:38:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 98ACD4B0EE
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 17:38:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 873C3A865
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 17:38:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7930C13473F
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 17:38:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146348943723.4910.7071079736393329605.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 17, 2016 at 02:50:37PM +0200, Arturo Borrero Gonzalez wrote:
> The conntrackd daemon lacks support for syncing IPv6 NATed connections.
> 
> This patch adds support for managing the IPv6 part of struct __nfct_nat,
> also updating the corresponsing symbols.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  .../libnetfilter_conntrack.h                       |    2 +
>  src/conntrack/build.c                              |   34 ++++++++++++++++++++
>  src/conntrack/build_mnl.c                          |   34 ++++++++++++++++++++
>  src/conntrack/copy.c                               |   16 +++++++++
>  src/conntrack/getter.c                             |   12 +++++++
>  src/conntrack/objopt.c                             |   26 ++++++++++++++-
>  src/conntrack/setter.c                             |   16 +++++++++
>  7 files changed, 138 insertions(+), 2 deletions(-)
> 
> diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> index 22af622..6cba578 100644
> --- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> +++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> @@ -138,6 +138,8 @@ enum nf_conntrack_attr {
>  	ATTR_CONNLABELS_MASK,			/* variable length */
>  	ATTR_ORIG_ZONE,				/* u16 bits */
>  	ATTR_REPL_ZONE,				/* u16 bits */
> +	ATTR_SNAT_IPV6,				/* u128 bits */
> +	ATTR_DNAT_IPV6,				/* u128 bits */
>  	ATTR_MAX
>  };
>  
> diff --git a/src/conntrack/build.c b/src/conntrack/build.c
> index 10d51fe..0b15230 100644
> --- a/src/conntrack/build.c
> +++ b/src/conntrack/build.c
> @@ -284,6 +284,8 @@ static void __build_nat(struct nfnlhdr *req,
>  			       &nat->min_ip.v4, sizeof(uint32_t));
>  		break;
>  	case AF_INET6:
> +		nfnl_addattr_l(&req->nlh, size, CTA_NAT_MINIP,
> +			       &nat->min_ip.v6, sizeof(struct in6_addr));

This should be CTA_NAT_V6_MINIP instead of CTA_NAT_MINIP.

enum ctattr_nat {
        CTA_NAT_UNSPEC,
        CTA_NAT_V4_MINIP,
#define CTA_NAT_MINIP CTA_NAT_V4_MINIP
        CTA_NAT_V4_MAXIP,
#define CTA_NAT_MAXIP CTA_NAT_V4_MAXIP
        CTA_NAT_PROTO,
        CTA_NAT_V6_MINIP,
        CTA_NAT_V6_MAXIP,
        __CTA_NAT_MAX
};
#define CTA_NAT_MAX (__CTA_NAT_MAX - 1)
