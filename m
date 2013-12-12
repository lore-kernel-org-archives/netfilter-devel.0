From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nftables kernel PATCH v2] netfilter: nf_tables: fix nft_meta_target
 module
Date: Thu, 12 Dec 2013 14:27:17 +0200
Message-ID: <52A9ABA5.4020200@linux.intel.com>
References: <20131212111201.4462.9945.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33850 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab3LLM1T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:27:19 -0500
In-Reply-To: <20131212111201.4462.9945.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

>    * @NFTA_META_DREG: destination register (NLA_U32)
> + * @NFTA_META_VALUE: source data to load (NLA_U32)
>    * @NFTA_META_KEY: meta data item to load (NLA_U32: nft_meta_keys)
>    */
>   enum nft_meta_attributes {
>   	NFTA_META_UNSPEC,
>   	NFTA_META_DREG,
> +	NFTA_META_VALUE,
>   	NFTA_META_KEY,

You have to move NFTA_META_VALUE after NFTA_META_KEY, or then it will 
break with 3.13 kernel API version.
(your patch is going to be part of 3.14 I guess)

>   	__NFTA_META_MAX
>   };
> (...)
> +
>   static const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
>   	[NFTA_META_DREG]	= { .type = NLA_U32 },
> +	[NFTA_META_VALUE]	= { .type = NLA_U32 },
>   	[NFTA_META_KEY]		= { .type = NLA_U32 },

So switch these 2 last lines accordingly.


Besides that the _match/_target naming looks still awkward to me.
But _get/_set would be more "semantically relevant" imho.

Of course it's purely subjective, as usual with naming ;)


Tomasz
