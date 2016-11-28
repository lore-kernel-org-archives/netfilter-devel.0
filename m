From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2 2/2] datatype: Implement binary search in
 symbolic_constant_print()
Date: Mon, 28 Nov 2016 09:50:49 +0100
Message-ID: <20161128085049.GB949@salvia>
References: <20161128012814.GA22480@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46508 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752805AbcK1Iu7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 03:50:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C554EA4168
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 09:50:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2DCDEBAF8
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 09:50:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91884EBACD
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 09:50:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161128012814.GA22480@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 27, 2016 at 11:28:14PM -0200, Elise Lennion wrote:
> Because a linear search is used, which is slower.
> 
> This approach demands that the symbol_table have a variable with its
> size, also, it must be sorted by value.
> 
> Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
> ---
> 
>  v2: This patch has no v1.
> 
>  include/datatype.h |  2 ++
>  src/datatype.c     | 37 +++++++++++++++++++++++++++++--------
>  src/proto.c        |  3 ++-
>  src/services.c     |  3 ++-
>  4 files changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/include/datatype.h b/include/datatype.h
> index e53797d..0e7db40 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -178,10 +178,12 @@ struct symbolic_constant {
>  /**
>   * struct symbol_table - type construction from symbolic values
>   *
> + * @size: 	number of symbols, without SYMBOL_LIST_END
>   * @symbols:	the symbols
>   */
>  struct symbol_table {
>  	int				gcc_workaround;

You can know remove this gcc_workaround field.

> +	unsigned int 			size;
>  	struct symbolic_constant	symbols[];
>  };
>  
> diff --git a/src/datatype.c b/src/datatype.c
> index 1ae7db4..25d9000 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -116,6 +116,18 @@ struct error_record *symbol_parse(const struct expr *sym,
>  		     sym->dtype->desc);
>  }
>  
> +static int symbolic_constant_cmp(const void *p1, const void *p2)
> +{
> +        const struct symbolic_constant f = *(struct symbolic_constant *)p1;
   ^^^^^^^^
I see spaces instead of tabs here. Same thing everywhere in this
patch.
