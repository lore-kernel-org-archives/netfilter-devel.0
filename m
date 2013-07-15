From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 libnetfilter_acct 11/29] add variable width and
 on-the-fly formatting
Date: Tue, 16 Jul 2013 00:51:28 +0200
Message-ID: <20130715225128.GE5405@localhost>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
 <1373480727-11254-12-git-send-email-michael.zintakis@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48081 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758304Ab3GOWvd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:51:33 -0400
Content-Disposition: inline
In-Reply-To: <1373480727-11254-12-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 10, 2013 at 07:25:09PM +0100, Michael Zintakis wrote:
> * add a separate nfacct_options struct with its get/set functions, allowing
> userspace programs, like nfacct, to specify the width of the columns which
> are to be printed, so that they are no longer hard-coded into the printing
> template itself. This allows column width to be "adjusted", depending on the
> value of each property;
> 
> * add a separate NFACCT_SNPRINTF_F_NUMONLY template, which prints the
> numbers-only properties of the accounting objects (formatted - see below) -
> useful to the nfnetlink callback function in order to determine the maximum
> column width, which needs to be used to print each column.
> 
> * add a new nfacct_snprintf_with_options function enhancing the existing API
> to enable "options" to be specified during printing properties of nfacct
> objects.
> 
> * allow on-the-fly formatting, using over 14 different formats when printing
> accounting objects. This formatting, if specified, applies to *all*
> accounting objects.

This patch adds many things in one single patch that need to be split
in many of them.

> Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
> ---
>  configure.ac                                  |   2 +-
>  include/libnetfilter_acct/libnetfilter_acct.h |  75 ++++
>  src/libnetfilter_acct.c                       | 512 ++++++++++++++++++++++++--
>  src/libnetfilter_acct.map                     |  10 +
>  4 files changed, 569 insertions(+), 30 deletions(-)
>
[...]
> +void nfacct_option_set(struct nfacct_options *options,
> +			enum nfacct_option_type type, const void *data);
> +void nfacct_option_set_u16(struct nfacct_options *options,
> +			enum nfacct_option_type type, uint16_t value);
> +void nfacct_option_set_tsize(struct nfacct_options *options,
> +			enum nfacct_option_type type, size_t value);
> +void nfacct_option_unset(struct nfacct_options *options,
> +			enum nfacct_option_type type);
> +const void *nfacct_option_get(struct nfacct_options *options,
> +			enum nfacct_option_type type);
> +uint16_t nfacct_option_get_u16(struct nfacct_options *options,
> +			enum nfacct_option_type type);
> +size_t nfacct_option_get_tsize(struct nfacct_options *options,
> +			enum nfacct_option_type type);

You can get rid of all these if you use flags.
