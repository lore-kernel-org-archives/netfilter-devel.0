From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] datatype: Replace getnameinfo() by internal lookup
 table
Date: Thu, 24 Nov 2016 10:31:15 +0100
Message-ID: <20161124093115.GA1461@salvia>
References: <20161123225317.GA20966@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936584AbcKXJb3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 04:31:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B03BA7D52
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 10:31:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59AB3A7E1B
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 10:31:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 490ECA7E27
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 10:31:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161123225317.GA20966@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Elise,

On Wed, Nov 23, 2016 at 08:53:17PM -0200, Elise Lennion wrote:
> To avoid exceeding the inputs number limit of the flex scanner used.
> 
> Using port number as index, to map service names in the table, results
> in a very sparse table, so a new struct is needed to associate ports
> with names.

Please, indicate what /etc/services you have used, ie. your linux
distro version, so that info remains here for the record.

More comments below.

> Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
> ---
> 
>  The services list are all well-known and registered ports of my local
>  /etc/services file.
> 
>  include/datatype.h |  11 ++++
>  src/datatype.c     | 159 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 162 insertions(+), 8 deletions(-)
> 
> diff --git a/include/datatype.h b/include/datatype.h
> index 9f3f711..9c34c50 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -172,6 +172,17 @@ struct symbolic_constant {
>  	uint64_t			value;
>  };
>  
> +/**
> + * struct port_servname - port <-> service name mapping
> + *
> + * @port: port number
> + * @name: service name
> + */
> +struct port_servname {
> +	uint16_t			port;
> +	char				*name;
> +};
> +
>  #define SYMBOL(id, v)	{ .identifier = (id), .value = (v) }
>  #define SYMBOL_LIST_END	(struct symbolic_constant) { }
>  
> diff --git a/src/datatype.c b/src/datatype.c
> index 1e40287..85b261d 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -28,6 +28,156 @@
>  
>  #include <netinet/ip_icmp.h>
>  
> +static const struct port_servname services[] = {

Given that this is long, please, place this and nft_service_lookup()
under a new file, src/services.c.

> +	{1, "tcpmux"}, {7, "echo"}, {9, "discard"},

We use symbol_table for these definitions instead, eg.

        static const struct symbol_table icmp_code_tbl = {
                ...
                .sym_tbl        = &icmp_code_tbl,

If you attach the symbol table that defines the services to the
inet_service_type definition, then "nft describe tcp dport" will also
display the available service names.

BTW, on a different front, the binary search in this patch is useful,
you can probably integrate this into the core, I mean
symbolic_constant_print(). Only problem is that we would need an
explicit size in struct symbol_table, but that shouldn't be a problem.
And update many spots in the code, but that should be fine. You can
follow up with a patch that applies on top of this to add this binary
search approach.

Thanks.
