From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2] datatype: Display pre-defined inet_service values
 in host byte order
Date: Wed, 7 Dec 2016 20:25:10 +0100
Message-ID: <20161207192510.GA3314@salvia>
References: <20161207190331.GA7206@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57656 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752795AbcLGTZP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2016 14:25:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E304F10CF4
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 20:25:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D339DDA729
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 20:25:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9AAAA7CCB
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 20:25:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161207190331.GA7206@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Elise,

On Wed, Dec 07, 2016 at 05:03:31PM -0200, Elise Lennion wrote:
> nft describe displays, to the user, which values are available for a selector,
> then the values should be in host byte order.
> 
> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Fixes: ccc5da470e76 ("datatype: Replace getnameinfo() by internal lookup table")
> Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
> ---
> 
>  v2: Created a function to convert different types and number of bytes
> 
>  include/datatype.h |  3 ++-
>  src/datatype.c     | 27 ++++++++++++++++++++++++---
>  src/expression.c   |  3 ++-
>  3 files changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/include/datatype.h b/include/datatype.h
> index d4fe817..a7db1df 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -191,7 +191,8 @@ extern struct error_record *symbolic_constant_parse(const struct expr *sym,
>  extern void symbolic_constant_print(const struct symbol_table *tbl,
>  				    const struct expr *expr, bool quotes);
>  extern void symbol_table_print(const struct symbol_table *tbl,
> -			       const struct datatype *dtype);
> +			       const struct datatype *dtype,
> +			       enum byteorder byteorder);
>  
>  extern struct symbol_table *rt_symbol_table_init(const char *filename);
>  extern void rt_symbol_table_free(struct symbol_table *tbl);
> diff --git a/src/datatype.c b/src/datatype.c
> index b5d73bc..c884171 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -180,15 +180,36 @@ void symbolic_constant_print(const struct symbol_table *tbl,
>  		printf("%s", s->identifier);
>  }
>  
> +static void big_to_host_byteorder(void *value, const unsigned int nbytes)
> +{
> +	unsigned char *p = value;
> +	unsigned int i;
> +
> +	for (i = 0; i < nbytes / 2; i++) {
> +		p[i] ^= p[nbytes - 1 - i];
> +		p[nbytes - 1 - i] ^= p[i];
> +		p[i] ^= p[nbytes - 1 - i];
> +	}

Sorry, probably I should have specified a bit more.

I suggest you use libgmp for this, that allows any arbitrary word
size. See mpz_init() to initialize the variable, then
mpz_switch_byteorder() to change byteorder. Then, export it via
mpz_export_data() back to fixed standard datatypes.

libgmp is well documented, please have a look at it.

Thanks.
