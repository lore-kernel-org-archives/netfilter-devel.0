From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: add support for inverted
 login in nft_lookup
Date: Tue, 31 May 2016 13:39:21 +0200
Message-ID: <20160531113921.GA5870@salvia>
References: <146469443294.16092.10350972377628813816.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58732 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbcEaLj1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 07:39:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EC6E7EAA65
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 13:39:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D656315D63A
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 13:39:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C564F15D63A
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 13:39:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146469443294.16092.10350972377628813816.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 31, 2016 at 01:33:53PM +0200, Arturo Borrero Gonzalez wrote:
> Introduce a new configuration option for this expression, which allows users
> to invert the logic of set lookups.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |    6 ++++++
>  net/netfilter/nft_lookup.c               |   15 ++++++++++++++-
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 6a4dbe0..01751fa 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -546,6 +546,10 @@ enum nft_cmp_attributes {
>  };
>  #define NFTA_CMP_MAX		(__NFTA_CMP_MAX - 1)
>  
> +enum nft_lookup_flags {
> +	NFT_LOOKUP_F_INV = (1 << 0),
> +};
> +
>  /**
>   * enum nft_lookup_attributes - nf_tables set lookup expression netlink attributes
>   *
> @@ -553,6 +557,7 @@ enum nft_cmp_attributes {
>   * @NFTA_LOOKUP_SREG: source register of the data to look for (NLA_U32: nft_registers)
>   * @NFTA_LOOKUP_DREG: destination register (NLA_U32: nft_registers)
>   * @NFTA_LOOKUP_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
> + * @NFTA_LOOKUP_FLAGS: flags (NLA_U32: enum nft_lookup_flags)
>   */
>  enum nft_lookup_attributes {
>  	NFTA_LOOKUP_UNSPEC,
> @@ -560,6 +565,7 @@ enum nft_lookup_attributes {
>  	NFTA_LOOKUP_SREG,
>  	NFTA_LOOKUP_DREG,
>  	NFTA_LOOKUP_SET_ID,
> +	NFTA_LOOKUP_FLAGS,
>  	__NFTA_LOOKUP_MAX
>  };
>  #define NFTA_LOOKUP_MAX		(__NFTA_LOOKUP_MAX - 1)
> diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
> index b3c31ef..4a9ee78 100644
> --- a/net/netfilter/nft_lookup.c
> +++ b/net/netfilter/nft_lookup.c
> @@ -23,6 +23,7 @@ struct nft_lookup {
>  	enum nft_registers		sreg:8;
>  	enum nft_registers		dreg:8;
>  	struct nft_set_binding		binding;
> +	bool				invert;
>  };

pahole reports that there is a hole between dreg and binding where you
can scratch those 8 bytes for this new boolean:

struct nft_lookup {
        struct nft_set *           set;                  /*     0 8 */
        enum nft_registers         sreg:8;               /*     8:24 4 */
        enum nft_registers         dreg:8;               /*     8:16 4 */

        /* XXX 16 bits hole, try to pack */
        /* XXX 4 bytes hole, try to pack */

        struct nft_set_binding     binding;              /*    16 32 */

        /* XXX last struct has 4 bytes of padding */

        /* size: 48, cachelines: 1, members: 4 */
        /* sum members: 44, holes: 1, sum holes: 4 */
        /* bit holes: 1, sum bit holes: 16 bits */
        /* paddings: 1, sum paddings: 4 */
        /* last cacheline: 48 bytes */
}

So this should look like instead:

  	enum nft_registers		sreg:8;
  	enum nft_registers		dreg:8;
 +	bool				invert;
  	struct nft_set_binding		binding;
  };
