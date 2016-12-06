From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] datatype: Display pre-defined inet_service values in
 host byte order
Date: Tue, 6 Dec 2016 11:00:50 +0100
Message-ID: <20161206100050.GA1489@salvia>
References: <20161206003037.GA7097@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59174 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751455AbcLFKBo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 05:01:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B29B58CD92
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:01:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9CE715387D
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:01:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C80D87E081
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:00:59 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161206003037.GA7097@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 05, 2016 at 10:30:38PM -0200, Elise Lennion wrote:
> nft describe displays, to the user, which values are available for a selector,
> then the values should be in host byte order.
> 
> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Fixes: ccc5da470e76 ("datatype: Replace getnameinfo() by internal lookup table")
> Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
> ---
>  include/datatype.h |  3 ++-
>  src/datatype.c     | 14 +++++++++++---
>  src/expression.c   |  3 ++-
>  3 files changed, 15 insertions(+), 5 deletions(-)
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
> index b5d73bc..4f98a83 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -181,14 +181,22 @@ void symbolic_constant_print(const struct symbol_table *tbl,
>  }
>  
>  void symbol_table_print(const struct symbol_table *tbl,
> -			const struct datatype *dtype)
> +			const struct datatype *dtype,
> +			enum byteorder byteorder)
>  {
>  	const struct symbolic_constant *s;
>  	unsigned int size = 2 * dtype->size / BITS_PER_BYTE;
> +	long unsigned int value;
> +
> +	for (s = tbl->symbols; s->identifier != NULL; s++) {
> +		if (byteorder == BYTEORDER_BIG_ENDIAN)
> +			value = __constant_ntohs(s->value);

Is this going to work for other cases other than 16-bit?

You can probably add a function that, based on the datatype, performs
the byteswapping based on the integer length.

Thanks.
