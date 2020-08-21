Return-Path: <SRS0=c8az=B7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD01C433E3
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Aug 2020 17:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B0562086A
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Aug 2020 17:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgHURVf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Aug 2020 13:21:35 -0400
Received: from correo.us.es ([193.147.175.20]:52518 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbgHURVR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Aug 2020 13:21:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0A8D79D320
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 19:21:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF80CDA789
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 19:21:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E4F85DA722; Fri, 21 Aug 2020 19:21:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71EC1DA722;
        Fri, 21 Aug 2020 19:21:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 21 Aug 2020 19:21:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 55C7442EE38F;
        Fri, 21 Aug 2020 19:21:12 +0200 (CEST)
Date:   Fri, 21 Aug 2020 19:21:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_tables: add userdata
 attributes to nft_table
Message-ID: <20200821172112.GA15625@salvia>
References: <20200820081903.36781-1-guigom@riseup.net>
 <20200820081903.36781-2-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820081903.36781-2-guigom@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 20, 2020 at 10:19:01AM +0200, Jose M. Guisado Gomez wrote:
> Enables storing userdata for nft_table. Field udata points to user data
> and udlen store its length.
> 
> Adds new attribute flag NFTA_TABLE_USERDATA
> 
> Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
> ---
>  include/net/netfilter/nf_tables.h        |  2 ++
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nf_tables_api.c            | 25 ++++++++++++++++++++++++
>  3 files changed, 29 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index bf9491b77d16..97a7e147a59a 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1080,6 +1080,8 @@ struct nft_table {
>  					flags:8,
>  					genmask:2;
>  	char				*name;
> +	u16				udlen;
> +	u8				*udata;
>  };
>  
>  void nft_register_chain_type(const struct nft_chain_type *);
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 42f351c1f5c5..aeb88cbd303e 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -172,6 +172,7 @@ enum nft_table_flags {
>   * @NFTA_TABLE_NAME: name of the table (NLA_STRING)
>   * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
>   * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
> + * @NFTA_TABLE_USERDATA: user data (NLA_BINARY)
>   */
>  enum nft_table_attributes {
>  	NFTA_TABLE_UNSPEC,
> @@ -180,6 +181,7 @@ enum nft_table_attributes {
>  	NFTA_TABLE_USE,
>  	NFTA_TABLE_HANDLE,
>  	NFTA_TABLE_PAD,
> +	NFTA_TABLE_USERDATA,
>  	__NFTA_TABLE_MAX
>  };
>  #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index d878e34e3354..ca240a990eea 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -650,6 +650,8 @@ static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
>  				    .len = NFT_TABLE_MAXNAMELEN - 1 },
>  	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
>  	[NFTA_TABLE_HANDLE]	= { .type = NLA_U64 },
> +	[NFTA_TABLE_USERDATA]	= { .type = NLA_BINARY,
> +				    .len = NFT_USERDATA_MAXLEN }
>  };
>  
>  static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
> @@ -676,6 +678,11 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
>  			 NFTA_TABLE_PAD))
>  		goto nla_put_failure;
>  
> +	if (table->udata) {
> +		if (nla_put(skb, NFTA_TABLE_USERDATA, table->udlen, table->udata))
> +			goto nla_put_failure;
> +	}
> +
>  	nlmsg_end(skb, nlh);
>  	return 0;
>  
> @@ -980,6 +987,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
>  	u32 flags = 0;
>  	struct nft_ctx ctx;
>  	int err;
> +	u16 udlen = 0;
>  
>  	lockdep_assert_held(&net->nft.commit_mutex);
>  	attr = nla[NFTA_TABLE_NAME];
> @@ -1005,6 +1013,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
>  			return -EINVAL;
>  	}
>  
> +
>  	err = -ENOMEM;
>  	table = kzalloc(sizeof(*table), GFP_KERNEL);
>  	if (table == NULL)
> @@ -1014,6 +1023,20 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
>  	if (table->name == NULL)
>  		goto err_strdup;
>  
> +	if (nla[NFTA_TABLE_USERDATA]) {
> +		udlen = nla_len(nla[NFTA_TABLE_USERDATA]);
> +		table->udata = kzalloc(udlen, GFP_KERNEL);
> +		if (table->udata == NULL)
> +			goto err_table_udata;
> +	} else {
> +		table->udata = NULL;
> +	}
> +
> +	if (udlen) {
> +		nla_memcpy(table->udata, nla[NFTA_TABLE_USERDATA], udlen);
> +		table->udlen = udlen;
> +	}

       if (nla[NFTA_TABLE_USERDATA]) {
               udlen = nla_len(nla[NFTA_TABLE_USERDATA]);
               table->udata = kzalloc(udlen, GFP_KERNEL);
               if (table->udata == NULL)
                       goto err_table_udata;

               nla_memcpy(table->udata, nla[NFTA_TABLE_USERDATA], udlen);
               table->udlen = udlen;
       }

Probably this simplification instead? kzalloc() zeroes the table
object, so table->udata is NULL and ->udlen is zero.
