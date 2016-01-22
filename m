From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Add support for masq port selection
Date: Fri, 22 Jan 2016 14:05:05 +0100
Message-ID: <20160122130505.GA2810@salvia>
References: <20160122061517.GA5964@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34579 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbcAVNFM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jan 2016 08:05:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6BA842EFEA1
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 14:05:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5EF4CDA80B
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 14:05:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CCD2BDA865
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 14:05:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160122061517.GA5964@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 22, 2016 at 11:45:17AM +0530, Shivani Bhardwaj wrote:
> Complete masquerading support by allowing port range selection.

Thanks.

Please, include the right subject so we know what tree you're
targeting to, this one would be [PATCH libnftnl]

Comments below:

> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  include/libnftnl/expr.h             |  4 ++-
>  include/linux/netfilter/nf_tables.h |  2 ++
>  src/expr/masq.c                     | 64 ++++++++++++++++++++++++++++++++++---
>  3 files changed, 65 insertions(+), 5 deletions(-)
> 
> diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
> index 4a37581..ba5c605 100644
> --- a/include/libnftnl/expr.h
> +++ b/include/libnftnl/expr.h
> @@ -166,7 +166,9 @@ enum {
>  };
>  
>  enum {
> -	NFTNL_EXPR_MASQ_FLAGS	= NFTNL_EXPR_BASE,
> +	NFTNL_EXPR_MASQ_REG_PROTO_MIN	= NFTNL_EXPR_BASE,
> +	NFTNL_EXPR_MASQ_REG_PROTO_MAX,
> +	NFTNL_EXPR_MASQ_FLAGS,
>  };
>  
>  enum {
> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index 9796d82..c17615a 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -924,6 +924,8 @@ enum nft_nat_attributes {
>  enum nft_masq_attributes {
>  	NFTA_MASQ_UNSPEC,
>  	NFTA_MASQ_FLAGS,
> +	NFTA_MASQ_REG_PROTO_MIN,
> +	NFTA_MASQ_REG_PROTO_MAX,
>  	__NFTA_MASQ_MAX
>  };
>  #define NFTA_MASQ_MAX		(__NFTA_MASQ_MAX - 1)
> diff --git a/src/expr/masq.c b/src/expr/masq.c
> index 01512b4..e7c9ec7 100644
> --- a/src/expr/masq.c
> +++ b/src/expr/masq.c
> @@ -21,7 +21,9 @@
>  #include <libnftnl/rule.h>
>  
>  struct nftnl_expr_masq {
> -	uint32_t	flags;
> +	uint32_t		flags;
> +	enum nft_registers	sreg_proto_min;
> +	enum nft_registers	sreg_proto_max;
>  };
>  
>  static int
> @@ -31,6 +33,12 @@ nftnl_expr_masq_set(struct nftnl_expr *e, uint16_t type,
>  	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
>  
>  	switch (type) {
> +	case NFTNL_EXPR_MASQ_REG_PROTO_MIN:
> +		masq->sreg_proto_min = *((uint32_t *)data);
> +		break;
> +	case NFTNL_EXPR_MASQ_REG_PROTO_MAX:
> +		masq->sreg_proto_max = *((uint32_t *)data);
> +		break;

Minor: Please, place these after _FLAGS, so we keep the switch cases
in incremental order. Same in other spots.

BTW, don't forget to extend the tests under
libnftnl/tests/nft-expr_masq-test.c

Thanks.
