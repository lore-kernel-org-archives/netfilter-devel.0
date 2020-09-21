Return-Path: <SRS0=tgdo=C6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C67C4727C
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Sep 2020 23:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B131D23A6B
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Sep 2020 23:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgIUXtR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Sep 2020 19:49:17 -0400
Received: from correo.us.es ([193.147.175.20]:58034 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbgIUXtR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Sep 2020 19:49:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1BEFB117739
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2020 01:49:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C6FADA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2020 01:49:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 02002DA722; Tue, 22 Sep 2020 01:49:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A76AEDA704;
        Tue, 22 Sep 2020 01:49:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 22 Sep 2020 01:49:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8A68D42EF4E0;
        Tue, 22 Sep 2020 01:49:12 +0200 (CEST)
Date:   Tue, 22 Sep 2020 01:49:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_tables: add userdata
 attributes to nft_chain
Message-ID: <20200921234912.GA6657@salvia>
References: <20200921132822.55231-1-guigom@riseup.net>
 <20200921132822.55231-2-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200921132822.55231-2-guigom@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 21, 2020 at 03:28:21PM +0200, Jose M. Guisado Gomez wrote:
> Enables storing userdata for nft_chain. Field udata points to user data
> and udlen stores its length.
> 
> Adds new attribute flag NFTA_CHAIN_USERDATA.
> 
> Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
> ---
>  include/net/netfilter/nf_tables.h        |  2 ++
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nf_tables_api.c            | 19 +++++++++++++++++++
>  3 files changed, 23 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 8ceca0e419b3..4686fafbfd8a 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -952,6 +952,8 @@ struct nft_chain {
>  					bound:1,
>  					genmask:2;
>  	char				*name;
> +	u16				udlen;
> +	u8				*udata;
>  
>  	/* Only used during control plane commit phase: */
>  	struct nft_rule			**rules_next;
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 3c2469b43742..352ee51707a1 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -208,6 +208,7 @@ enum nft_chain_flags {
>   * @NFTA_CHAIN_COUNTERS: counter specification of the chain (NLA_NESTED: nft_counter_attributes)
>   * @NFTA_CHAIN_FLAGS: chain flags
>   * @NFTA_CHAIN_ID: uniquely identifies a chain in a transaction (NLA_U32)
> + * @NFTA_CHAIN_USERDATA: user data (NLA_BINARY)
>   */
>  enum nft_chain_attributes {
>  	NFTA_CHAIN_UNSPEC,
> @@ -222,6 +223,7 @@ enum nft_chain_attributes {
>  	NFTA_CHAIN_PAD,
>  	NFTA_CHAIN_FLAGS,
>  	NFTA_CHAIN_ID,
> +	NFTA_CHAIN_USERDATA,
>  	__NFTA_CHAIN_MAX
>  };
>  #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 84c0c1aaae99..c8065c6eae86 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
[...]
> @@ -2052,6 +2059,18 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
>  		goto err1;
>  	}
>  
> +	if (nla[NFTA_CHAIN_USERDATA]) {
> +		udlen = nla_len(nla[NFTA_CHAIN_USERDATA]);
> +		chain->udata = kzalloc(udlen, GFP_KERNEL);
> +		if (chain->udata == NULL) {
> +			err = -ENOMEM;
> +			goto err1;
> +		}
> +
> +		nla_memcpy(chain->udata, nla[NFTA_CHAIN_USERDATA], udlen);
> +		chain->udlen = udlen;
> +	}
> +
>  	rules = nf_tables_chain_alloc_rules(chain, 0);
>  	if (!rules) {
>  		err = -ENOMEM;

Hm, kfree(chain->udata) from the error path is missing?

While working at this, probably you can rename all those ugly err1;
basic-like goto style in the same patch.

Thanks.
