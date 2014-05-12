From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/2] src: add nft_*_build_msg functions
Date: Mon, 12 May 2014 18:13:36 +0200
Message-ID: <20140512161336.GA13099@localhost>
References: <20140506201936.18158.83354.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44363 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbaELQNq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 12:13:46 -0400
Content-Disposition: inline
In-Reply-To: <20140506201936.18158.83354.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 06, 2014 at 10:19:36PM +0200, Arturo Borrero Gonzalez wrote:
> These functions are likely to be used by all userspace programs to interact
> with the nftables kernel subsystem.
> 
> Lets put in the library.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/libnftnl/chain.h |    2 ++
>  include/libnftnl/rule.h  |    2 ++
>  include/libnftnl/set.h   |    4 ++++
>  include/libnftnl/table.h |    2 ++
>  src/chain.c              |   11 +++++++++++
>  src/libnftnl.map         |    8 ++++++++
>  src/rule.c               |   11 +++++++++++
>  src/set.c                |   11 +++++++++++
>  src/set_elem.c           |   11 +++++++++++
>  src/table.c              |   11 +++++++++++
>  10 files changed, 73 insertions(+)
> 
> diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
> index c11cb5e..eecc7e9 100644
> --- a/include/libnftnl/chain.h
> +++ b/include/libnftnl/chain.h
> @@ -56,6 +56,8 @@ uint64_t nft_chain_attr_get_u64(struct nft_chain *c, uint16_t attr);
>  struct nlmsghdr;
>  
>  void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain *t);
> +void nft_chain_build_msg(struct nft_chain *c, void *buf, uint16_t msg,
> +			 unsigned int flags, uint32_t seq);

We should return the struct nlmsghdr * there, so we can still use the
_fprintf function from libmnl in case we need to debug the message
that has been made.
