From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] common: events: be more strict when placing the
 \0 character
Date: Tue, 15 Jul 2014 18:42:42 +0200
Message-ID: <20140715164242.GA11248@salvia>
References: <20140714124335.13205.77982.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52967 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbaGOQmr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:42:47 -0400
Content-Disposition: inline
In-Reply-To: <20140714124335.13205.77982.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 14, 2014 at 02:43:35PM +0200, Arturo Borrero Gonzalez wrote:
> Previous to this patch, the code path can potentially print an empty
> buffer with the \0 at the end of the buffer.
> 
> Be more strict and place the \0 character in the first position if the
> buffer is empty.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/common.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/src/common.c b/src/common.c
> index 1b600f1..c81a1d8 100644
> --- a/src/common.c
> +++ b/src/common.c
> @@ -114,9 +114,10 @@ int nft_event_header_snprintf(char *buf, size_t size, uint32_t type,
>  int nft_event_header_fprintf(FILE *fp, uint32_t type, uint32_t flags)
>  {
>  	char buf[64]; /* enough for the maximum string length above */
> +	int ret;
>  
> -	nft_event_header_snprintf(buf, sizeof(buf), type, flags);
> -	buf[sizeof(buf) - 1] = '\0';
> +	ret = nft_event_header_snprintf(buf, sizeof(buf), type, flags);
> +	buf[ret] = '\0';

ret can be 64 at worst case, then you have ret[64] would be an
off-by-one memory access (out of bound).

BTW, could you review all_snprintf functions? We should retain the
snprintf semantics, ie. always nul-terminate strings if

        offset < buffer_size

Otherwise, return the string without the nul-termination.
