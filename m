From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,RFC 1/3] netfilter: nf_conntrack: add 64-bit
 conntrack ID extension
Date: Tue, 28 Nov 2017 13:16:52 +0100
Message-ID: <20171128121652.GH23412@breakpoint.cc>
References: <20171128021309.11277-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, richard@nod.at, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48856 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753788AbdK1MSC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Nov 2017 07:18:02 -0500
Content-Disposition: inline
In-Reply-To: <20171128021309.11277-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This patch adds a 64-bit conntrack ID extension that allows userspace to
> uniquely identify a conntrack object.
> 
> The existing 32-bit ID is not good to uniquely identify a conntrack
> object. Long time ago, this used to be an incremental number that could
> quickly wrap around. Someone suggested to use 64-bits, back then this
> was considered to be too much memory for just an ID. So we usually
> suggested to users that they should combine it with the conntrack tuple
> to achieve a way to uniquely conntrack objects. This has always
> generated a bit of controversy since userspace applications needed to
> deal with extra work.
> 
> At some point, someone remove the explicit ct->id field that we used to
> have to save memory space. This ID was modified to part of its memory
> address. Howeover, this is a problem because objects can be quickly
> recycled with the slab-by-rcu approach that we use these days. So even
> combining this 32-bit ID with the tuple doesn't ensure that this is
> unique. Moreover, this is leaking the pointer to userspace in 32-bit
> arches, which is not good.
> 
> So let's introduce a 64-bit unique ID that ensures no overlaps. This is
> only allocated once in the first packet, and never ever again from the
> hot path, so let's keep this in a separated extension not to grab more
> cachelines.
> 
> ID assignment is lockless: this patch divides the 64-bit space between
> the existing CPUs, so they can freely allocate IDs in their space.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_conntrack_extend.h |  2 ++
>  include/net/netfilter/nf_conntrack_id.h     | 51 +++++++++++++++++++++++++++++
>  include/net/netns/conntrack.h               |  1 +
>  net/netfilter/Makefile                      |  2 +-
>  net/netfilter/nf_conntrack_core.c           | 18 +++++++++-
>  net/netfilter/nf_conntrack_id.c             | 48 +++++++++++++++++++++++++++
>  net/netfilter/nf_conntrack_netlink.c        |  2 ++
>  7 files changed, 122 insertions(+), 2 deletions(-)
>  create mode 100644 include/net/netfilter/nf_conntrack_id.h
>  create mode 100644 net/netfilter/nf_conntrack_id.c
> 
> diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
> index 21f887c5058c..274f9370c56a 100644
> --- a/include/net/netfilter/nf_conntrack_extend.h
> +++ b/include/net/netfilter/nf_conntrack_extend.h
> @@ -28,6 +28,7 @@ enum nf_ct_ext_id {
>  #if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
>  	NF_CT_EXT_SYNPROXY,
>  #endif
> +	NF_CT_EXT_ID,

I think, if we decide that this new id is needed,
we might as well place this directly in the extension
struct itself rather than an id.

AFAIU this id is always active/set so we never have a
conntrack without this.

> +static inline u64 nf_ct_id(const struct nf_conn *ct)
> +{
> +	struct nf_conn_id *conn;
> +
> +	conn = nf_ct_ext_find(ct, NF_CT_EXT_ID);
> +	if (!conn)
> +		return 0;

so this could just return ct->ext->id.
