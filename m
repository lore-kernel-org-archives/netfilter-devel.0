Return-Path: <SRS0=LXG+=DT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582BEC433E7
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 12:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24F2D20735
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 12:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388432AbgJLMI7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 08:08:59 -0400
Received: from correo.us.es ([193.147.175.20]:40216 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388364AbgJLMI6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 08:08:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A11E9DA3CC
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 14:08:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90F88DA78C
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 14:08:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 86606DA78B; Mon, 12 Oct 2020 14:08:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 941D3DA72F;
        Mon, 12 Oct 2020 14:08:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Oct 2020 14:08:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 77F2742EE38F;
        Mon, 12 Oct 2020 14:08:55 +0200 (CEST)
Date:   Mon, 12 Oct 2020 14:08:55 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 06/10] nft: Introduce struct nft_chain
Message-ID: <20201012120855.GE26845@salvia>
References: <20200923174849.5773-1-phil@nwl.cc>
 <20200923174849.5773-7-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200923174849.5773-7-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 23, 2020 at 07:48:45PM +0200, Phil Sutter wrote:
> Preparing for ordered output of user-defined chains, introduce a local
> datatype wrapping nftnl_chain. In order to maintain the chain name hash
> table, introduce nft_chain_list as well and use it instead of
> nftnl_chain_list.
> 
> Put everything into a dedicated source file and provide a bunch of
> getters for attributes of the embedded libnftnl_chain object.
[...]
> diff --git a/iptables/nft-chain.h b/iptables/nft-chain.h
> new file mode 100644
> index 0000000000000..818bbf1f4b525
> --- /dev/null
> +++ b/iptables/nft-chain.h
> @@ -0,0 +1,87 @@
> +#ifndef _NFT_CHAIN_H_
> +#define _NFT_CHAIN_H_
> +
> +#include <libnftnl/chain.h>
> +#include <libiptc/linux_list.h>
> +
> +struct nft_handle;
> +
> +struct nft_chain {
> +	struct list_head	head;
> +	struct hlist_node	hnode;
> +	struct nftnl_chain	*nftnl;
> +};
> +
> +#define CHAIN_NAME_HSIZE	512
> +
> +struct nft_chain_list {
> +	struct list_head	list;
> +	struct hlist_head	names[CHAIN_NAME_HSIZE];
> +};
> +
> +struct nft_chain *nft_chain_alloc(struct nftnl_chain *nftnl);
> +void nft_chain_free(struct nft_chain *c);
> +
> +struct nft_chain_list *nft_chain_list_alloc(void);
> +void nft_chain_list_free(struct nft_chain_list *list);
> +void nft_chain_list_del(struct nft_chain *c);
> +
> +static inline const char *nft_chain_name(struct nft_chain *c)
> +{
> +	return nftnl_chain_get_str(c->nftnl, NFTNL_CHAIN_NAME);
> +}
> +
> +static inline const char *nft_chain_table(struct nft_chain *c)
> +{
> +	return nftnl_chain_get_str(c->nftnl, NFTNL_CHAIN_TABLE);
> +}
> +
> +static inline const char *nft_chain_type(struct nft_chain *c)
> +{
> +	return nftnl_chain_get_str(c->nftnl, NFTNL_CHAIN_TYPE);
> +}
> +
> +static inline uint32_t nft_chain_prio(struct nft_chain *c)
> +{
> +	return nftnl_chain_get_u32(c->nftnl, NFTNL_CHAIN_PRIO);
> +}
> +
> +static inline uint32_t nft_chain_hooknum(struct nft_chain *c)
> +{
> +	return nftnl_chain_get_u32(c->nftnl, NFTNL_CHAIN_HOOKNUM);
> +}
> +
> +static inline uint64_t nft_chain_packets(struct nft_chain *c)
> +{
> +	return nftnl_chain_get_u64(c->nftnl, NFTNL_CHAIN_PACKETS);
> +}
> +
> +static inline uint64_t nft_chain_bytes(struct nft_chain *c)
> +{
> +	return nftnl_chain_get_u64(c->nftnl, NFTNL_CHAIN_BYTES);
> +}
> +
> +static inline bool nft_chain_has_policy(struct nft_chain *c)
> +{
> +	return nftnl_chain_is_set(c->nftnl, NFTNL_CHAIN_POLICY);
> +}
> +
> +static inline uint32_t nft_chain_policy(struct nft_chain *c)
> +{
> +	return nftnl_chain_get_u32(c->nftnl, NFTNL_CHAIN_POLICY);
> +}
> +
> +static inline uint32_t nft_chain_use(struct nft_chain *c)
> +{
> +	return nftnl_chain_get_u32(c->nftnl, NFTNL_CHAIN_USE);
> +}

Do you need this wrapper functions now? I mean, the intention is to
have a native nft_chain structure so nft_chain_use() become:

static inline uint32_t nft_chain_use(struct nft_chain *c)
{
	return c->use;
}

at some point?

Sorry but I don't see this is happening in this batch?

I remember the original intention was to support for sorting chains,
so the listing is predictable. But this batch is updating more things
than that and I don't see a clear connection with the goal.

Thanks Phil.

