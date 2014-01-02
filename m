From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] parsing: add interface to parse from file
Date: Thu, 2 Jan 2014 14:52:42 +0100
Message-ID: <20140102135242.GA5101@localhost>
References: <20140102132103.23299.58753.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58055 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaABNwu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 08:52:50 -0500
Content-Disposition: inline
In-Reply-To: <20140102132103.23299.58753.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 02, 2014 at 02:21:03PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds API interfaces to parse nft objects from a given filename.
> 
> I found this useful in `nft', where I'm trying to parse XML/JSON from a file.
> 
> Examples will be updated in a separated patch.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/libnftables/chain.h   |    1 +
>  include/libnftables/rule.h    |    1 +
>  include/libnftables/ruleset.h |    1 +
>  include/libnftables/set.h     |    2 ++
>  include/libnftables/table.h   |    1 +
>  src/chain.c                   |   15 +++++++++++++++
>  src/internal.h                |    8 +++++++-
>  src/libnftables.map           |    6 ++++++
>  src/rule.c                    |   14 ++++++++++++++
>  src/ruleset.c                 |   14 ++++++++++++++
>  src/set.c                     |   14 ++++++++++++++
>  src/set_elem.c                |   14 ++++++++++++++
>  src/table.c                   |   14 ++++++++++++++
>  src/utils.c                   |   34 ++++++++++++++++++++++++++++++++++
>  14 files changed, 138 insertions(+), 1 deletion(-)
> 
> diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
> index 8b4eab9..619088f 100644
> --- a/include/libnftables/chain.h
> +++ b/include/libnftables/chain.h
> @@ -52,6 +52,7 @@ struct nlmsghdr;
>  void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain *t);
>  
>  int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type, const char *data);
> +int nft_chain_fparse(struct nft_chain *c, enum nft_parse_type type, const char *filename);

Please, rework this to pass a file descriptor instead so it's
consistent with _fprintf API and we can use it with pipes as well.
Thanks.
