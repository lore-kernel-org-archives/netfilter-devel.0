From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/2] common: add wrapper to represent events
Date: Tue, 15 Apr 2014 11:51:53 +0200
Message-ID: <20140415095153.GB5223@localhost>
References: <20140415094030.23739.71580.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58006 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaDOJv7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:51:59 -0400
Content-Disposition: inline
In-Reply-To: <20140415094030.23739.71580.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 15, 2014 at 11:40:30AM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds a simple string wrapper to represent nf_tables events.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/libnftnl/common.h |    6 +++++
>  src/common.c              |   59 +++++++++++++++++++++++++++++++++++++++++++++
>  src/libnftnl.map          |    3 ++
>  3 files changed, 68 insertions(+)
> 
> diff --git a/include/libnftnl/common.h b/include/libnftnl/common.h
> index f0c20f0..96f8155 100644
> --- a/include/libnftnl/common.h
> +++ b/include/libnftnl/common.h
> @@ -2,6 +2,7 @@
>  #define _LIBNFTNL_COMMON_H_
>  
>  #include <stdint.h>
> +#include <stdio.h>
>  
>  enum {
>  	NFT_PARSE_EBADINPUT	= 0,
> @@ -30,4 +31,9 @@ struct nlmsghdr *nft_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
>  struct nft_parse_err *nft_parse_err_alloc(void);
>  void nft_parse_err_free(struct nft_parse_err *);
>  int nft_parse_perror(const char *str, struct nft_parse_err *err);
> +int nft_event_snprintf(char *buf, size_t bufsiz, const char *content,
> +		       uint32_t format, uint32_t type);
> +int nft_event_fprintf(FILE *fp, const char *content,
> +		      uint32_t format, uint32_t type);

We have flags in the existing output functions:

int nft_table_snprintf(char *buf, size_t size, struct nft_table *t,
                       uint32_t type, uint32_t flags);
int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type,
                      uint32_t flags);

I think you can add a new flag that tells that you have to add the
extra event handling that you need, thus, we don't need a new
interface.

You can most likely reuse most of the code in this patch.
