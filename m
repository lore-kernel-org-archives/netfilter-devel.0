From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1 V2] netfilter: Add nf_conntrack_helpers_register to
 fix one panic
Date: Sun, 8 Nov 2015 23:19:01 +0100
Message-ID: <20151108221901.GA21268@salvia>
References: <BAY403-EAS27321B698171BF5F88C2EB0952E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Feng Gao <gfree.wind@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35036 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbbKHWTI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Nov 2015 17:19:08 -0500
Content-Disposition: inline
In-Reply-To: <BAY403-EAS27321B698171BF5F88C2EB0952E0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 31, 2015 at 11:40:53PM +0800, Feng Gao wrote:
> When execute "insmod nf_conntrack_ftp.ko ports=76,76", the kernel crashes
> immediately.Because the old codes try to unregister the helper which is
> not registered successfully.
> Now add new function nf_conntrack_helpers_register to fix this bug.
> It would unregister the right helpers automatically if someone fails.
> And add another function nf_ct_helper_init to init the helper.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  include/net/netfilter/nf_conntrack_helper.h | 38 +++++++++++++++
>  net/netfilter/nf_conntrack_ftp.c            | 58 +++++++----------------
>  net/netfilter/nf_conntrack_helper.c         | 29 ++++++++++++
>  net/netfilter/nf_conntrack_irc.c            | 37 +++++----------
>  net/netfilter/nf_conntrack_sane.c           | 55 +++++++---------------
>  net/netfilter/nf_conntrack_sip.c            | 73
> +++++++++++------------------
>  net/netfilter/nf_conntrack_tftp.c           | 46 +++++++-----------
>  7 files changed, 158 insertions(+), 180 deletions(-)
> diff --git a/include/net/netfilter/nf_conntrack_helper.h
> b/include/net/netfilter/nf_conntrack_helper.h
> index 6cf614bc..49841bb
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -59,9 +59,47 @@ struct nf_conntrack_helper
> *nf_conntrack_helper_try_module_get(const char *name,
>  							       u16 l3num,
>  							       u8 protonum);
>  
> +static inline void nf_ct_helper_init(struct nf_conntrack_helper *helper,

No need for inline. This runs from the configuration path, which is
considered slow path. Better place this in the nf_conntrack_helper.c
file and export this symbol.

Another change, please split this patch in two patches:

1) One that adds nc_ct_helper_init() in first place.

2) Another patch that adds your nf_conntrack_helpers_register() and
   nf_conntrack_helpers_unregister()

In general, it is a good practise to split patches into logical
changes, it makes it easier for reviewing them and we reduce their
size.

We're almost there. Please follow up on this. Thanks.
