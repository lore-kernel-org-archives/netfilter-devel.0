From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] libnetfitler_queue: receive security context info
Date: Tue, 26 May 2015 15:11:05 +0200
Message-ID: <20150526131105.GE7817@breakpoint.cc>
References: <5562F8D9.50608@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Roman Kubiak <r.kubiak@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42930 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753646AbbEZNLG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2015 09:11:06 -0400
Content-Disposition: inline
In-Reply-To: <5562F8D9.50608@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Roman Kubiak <r.kubiak@samsung.com> wrote:
> From: RomanKubiak <r.kubiak@samsung.com>
> Date: Mon, 25 May 2015 12:24:34 +0200
> Subject: [PATCH] libnetfitler_queue: receive security context info
> 
> This will allow userspace to find the security context of each
> packet (if it exists) and make decisions based on that.
> It should work for SELinux and SMACK.
> 
> ---
>  include/libnetfilter_queue/libnetfilter_queue.h    |  2 ++
>  include/libnetfilter_queue/linux_nfnetlink_queue.h |  4 +++-
>  include/linux/netfilter/nfnetlink_queue.h          |  4 +++-
>  src/libnetfilter_queue.c                           | 18 ++++++++++++++++++
>  utils/nfqnl_test.c                                 | 11 ++++++++++-
>  5 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
> index 122cd10..489e76d 100644
> --- a/include/libnetfilter_queue/libnetfilter_queue.h
> +++ b/include/libnetfilter_queue/libnetfilter_queue.h
> @@ -105,6 +105,7 @@ extern u_int32_t nfq_get_outdev(struct nfq_data *nfad);
>  extern u_int32_t nfq_get_physoutdev(struct nfq_data *nfad);
>  extern int nfq_get_uid(struct nfq_data *nfad, u_int32_t *uid);
>  extern int nfq_get_gid(struct nfq_data *nfad, u_int32_t *gid);
> +extern int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata);
>  
>  extern int nfq_get_indev_name(struct nlif_handle *nlif_handle,
>  			      struct nfq_data *nfad, char *name);
> @@ -129,6 +130,7 @@ enum {
>  	NFQ_XML_TIME	= (1 << 5),
>  	NFQ_XML_UID	= (1 << 6),
>  	NFQ_XML_GID	= (1 << 7),
> +	NFQ_XML_SECCTX  = (1 << 8),
>  	NFQ_XML_ALL	= ~0U,
>  };
>  
> diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
> index f732201..479faa3 100644
> --- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
> +++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
> @@ -52,6 +52,7 @@ enum nfqnl_attr_type {
>  	NFQA_EXP,			/* nf_conntrack_netlink.h */
>  	NFQA_UID,			/* __u32 sk uid */
>  	NFQA_GID,			/* __u32 sk gid */
> +	NFQA_SECCTX,
>  
>  	__NFQA_MAX
>  };
> @@ -105,7 +106,8 @@ enum nfqnl_attr_config {
>  #define NFQA_CFG_F_CONNTRACK		(1 << 1)
>  #define NFQA_CFG_F_GSO			(1 << 2)
>  #define NFQA_CFG_F_UID_GID		(1 << 3)
> -#define NFQA_CFG_F_MAX			(1 << 4)
> +#define NFQA_CFG_F_SECCTX		(1 << 4)
> +#define NFQA_CFG_F_MAX			(1 << 5)
>  
>  /* flags for NFQA_SKB_INFO */
>  /* packet appears to have wrong checksums, but they are ok */
> diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
> index 22f5d45..030672d 100644
> --- a/include/linux/netfilter/nfnetlink_queue.h
> +++ b/include/linux/netfilter/nfnetlink_queue.h
> @@ -49,6 +49,7 @@ enum nfqnl_attr_type {
>  	NFQA_EXP,			/* nf_conntrack_netlink.h */
>  	NFQA_UID,			/* __u32 sk uid */
>  	NFQA_GID,			/* __u32 sk gid */
> +	NFQA_SECCTX,
>  
>  	__NFQA_MAX
>  };
> @@ -102,7 +103,8 @@ enum nfqnl_attr_config {
>  #define NFQA_CFG_F_CONNTRACK			(1 << 1)
>  #define NFQA_CFG_F_GSO				(1 << 2)
>  #define NFQA_CFG_F_UID_GID			(1 << 3)
> -#define NFQA_CFG_F_MAX				(1 << 4)
> +#define NFQA_CFG_F_SECCTX			(1 << 4)
> +#define NFQA_CFG_F_MAX				(1 << 5)
>  
>  /* flags for NFQA_SKB_INFO */
>  /* packet appears to have wrong checksums, but they are ok */
> diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
> index 740b340..9356e3d 100644
> --- a/src/libnetfilter_queue.c
> +++ b/src/libnetfilter_queue.c
> @@ -1219,6 +1219,24 @@ int nfq_get_gid(struct nfq_data *nfad, u_int32_t *gid)
>  EXPORT_SYMBOL(nfq_get_gid);
>  
>  /**
> + * nfq_get_secctx - get the security context for this packet
> + * \param nfad Netlink packet data handle passed to callback function
> + * \param secdata data to write the security context to
> + *
> + * \return 1 if there is a security context available, 0 otherwise
> + */
> +int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
> +{
> +	if (!nfnl_attr_present(nfad->data, NFQA_SECCTX))
> +		return 0;
> +
> +	*secdata = (unsigned char *)nfnl_get_pointer_to_data(nfad->data, NFQA_SECCTX, char);
> +
> +	return 1;

This should return the attr size, see nfq_get_payload() below on how to
do this.

It would be nice if you could add libmnl based version too
(src/nlmsg.c contains libmnl api of libnetfilter_queue).

The short version is that libnfnetlink has problems wrt.
extensibility/flexibility since it hides netlink details.

libmnl exposes all of the netlink data so its more flexible to add
functionality on top of libmnl than on top of libnfnetlink.

And on top of that, libnetfilter_queue libnfnetlink api exposes/leaks
implementation details of libnfnetlink so we can't replace libnfnetlink
with libmnl in the higer level libraries :-(

