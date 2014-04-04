From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables 5/5] meta: Add support for input and output
 bridge interface name
Date: Fri, 4 Apr 2014 13:11:34 +0200
Message-ID: <20140404111134.GA8247@localhost>
References: <1396604851-15348-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1396604851-15348-6-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38645 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbaDDLLp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:11:45 -0400
Content-Disposition: inline
In-Reply-To: <1396604851-15348-6-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 04, 2014 at 12:47:31PM +0300, Tomasz Bursztyka wrote:
> diff --git a/src/meta.c b/src/meta.c
> index ebc0c54..d95c124 100644
> --- a/src/meta.c
> +++ b/src/meta.c
> @@ -298,40 +298,46 @@ static const struct datatype gid_type = {
>  };
>  
>  static const struct meta_template meta_templates[] = {
> -	[NFT_META_LEN]		= META_TEMPLATE("length",    &integer_type,
> +	[NFT_META_LEN]		= META_TEMPLATE("length",      &integer_type,
>  						4 * 8, BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_PROTOCOL]	= META_TEMPLATE("protocol",  &ethertype_type,
> +	[NFT_META_PROTOCOL]	= META_TEMPLATE("protocol",    &ethertype_type,
>  						2 * 8, BYTEORDER_BIG_ENDIAN),
> -	[NFT_META_NFPROTO]	= META_TEMPLATE("nfproto",   &nfproto_type,
> +	[NFT_META_NFPROTO]	= META_TEMPLATE("nfproto",     &nfproto_type,
>  						1 * 8, BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_L4PROTO]	= META_TEMPLATE("l4proto",   &inet_protocol_type,
> +	[NFT_META_L4PROTO]	= META_TEMPLATE("l4proto",     &inet_protocol_type,
>  						1 * 8, BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_PRIORITY]	= META_TEMPLATE("priority",  &tchandle_type,
> +	[NFT_META_PRIORITY]	= META_TEMPLATE("priority",    &tchandle_type,
>  						4 * 8, BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_MARK]		= META_TEMPLATE("mark",      &mark_type,
> +	[NFT_META_MARK]		= META_TEMPLATE("mark",        &mark_type,
>  						4 * 8, BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_IIF]		= META_TEMPLATE("iif",       &ifindex_type,
> +	[NFT_META_IIF]		= META_TEMPLATE("iif",         &ifindex_type,
>  						4 * 8, BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_IIFNAME]	= META_TEMPLATE("iifname",   &string_type,
> +	[NFT_META_IIFNAME]	= META_TEMPLATE("iifname",     &string_type,
>  						IFNAMSIZ * BITS_PER_BYTE,
>  						BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_IIFTYPE]	= META_TEMPLATE("iiftype",   &arphrd_type,
> +	[NFT_META_IIFTYPE]	= META_TEMPLATE("iiftype",     &arphrd_type,
>  						2 * 8, BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_OIF]		= META_TEMPLATE("oif",	     &ifindex_type,
> +	[NFT_META_OIF]		= META_TEMPLATE("oif",	       &ifindex_type,
>  						4 * 8, BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_OIFNAME]	= META_TEMPLATE("oifname",   &string_type,
> +	[NFT_META_OIFNAME]	= META_TEMPLATE("oifname",     &string_type,
>  						IFNAMSIZ * BITS_PER_BYTE,
>  						BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_OIFTYPE]	= META_TEMPLATE("oiftype",   &arphrd_type,
> +	[NFT_META_OIFTYPE]	= META_TEMPLATE("oiftype",     &arphrd_type,
>  						2 * 8, BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_SKUID]	= META_TEMPLATE("skuid",     &uid_type,
> +	[NFT_META_SKUID]	= META_TEMPLATE("skuid",       &uid_type,
>  						4 * 8, BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_SKGID]	= META_TEMPLATE("skgid",     &gid_type,
> +	[NFT_META_SKGID]	= META_TEMPLATE("skgid",       &gid_type,
>  						4 * 8, BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_NFTRACE]	= META_TEMPLATE("nftrace",   &integer_type,
> +	[NFT_META_NFTRACE]	= META_TEMPLATE("nftrace",     &integer_type,
>  						1    , BYTEORDER_HOST_ENDIAN),
> -	[NFT_META_RTCLASSID]	= META_TEMPLATE("rtclassid", &realm_type,
> +	[NFT_META_RTCLASSID]	= META_TEMPLATE("rtclassid",   &realm_type,
>  						4 * 8, BYTEORDER_HOST_ENDIAN),
> +	[NFT_META_BRI_IIFNAME]	= META_TEMPLATE("bri_iifname", &string_type,
> +						IFNAMSIZ * BITS_PER_BYTE,
> +						BYTEORDER_HOST_ENDIAN),
> +	[NFT_META_BRI_OIFNAME]	= META_TEMPLATE("bri_oifname", &string_type,
> +						IFNAMSIZ * BITS_PER_BYTE,
> +						BYTEORDER_HOST_ENDIAN),
>  };
>  
>  static void meta_expr_print(const struct expr *expr)
> diff --git a/src/parser.y b/src/parser.y
> index db6f493..e8aef1d 100644
> --- a/src/parser.y
> +++ b/src/parser.y
> @@ -304,6 +304,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  %token SKGID			"skgid"
>  %token NFTRACE			"nftrace"
>  %token RTCLASSID		"rtclassid"
> +%token BRI_IIFNAME		"bri_iifname"
> +%token BRI_OIFNAME		"bri_oifname"
>  
>  %token CT			"ct"
>  %token DIRECTION		"direction"
> @@ -1563,6 +1565,8 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
>  			|	SKGID		{ $$ = NFT_META_SKGID; }
>  			|	NFTRACE		{ $$ = NFT_META_NFTRACE; }
>  			|	RTCLASSID	{ $$ = NFT_META_RTCLASSID; }
> +			|	BRI_IIFNAME	{ $$ = NFT_META_BRI_IIFNAME; }
> +			|       BRI_OIFNAME	{ $$ = NFT_META_BRI_OIFNAME; }
>  			;
>  
>  meta_stmt		:	META	meta_key	SET	expr
> diff --git a/src/scanner.l b/src/scanner.l
> index 47c5933..61c98b5 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -402,6 +402,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  "skgid"			{ return SKGID; }
>  "nftrace"		{ return NFTRACE; }
>  "rtclassid"		{ return RTCLASSID; }
> +"bri_iifname"		{ return BRI_IIFNAME; }
> +"bri_oifname"		{ return BRI_OIFNAME; }

I prefer if we skip the underscore there, I remember that Patrick
mentioned that he would also like to get rid of it in other cases like
the ipv4_address type.

Perhaps iifnamebr
        oifnamebr?

briifname and broifname could be an alternative, but I had problems to
type that myself several times while writing this email. So I prefer
the iffnamebr / oifnamebr alternative.

We can also save the reformatting of meta_templates with a shorter
name, so this patch will be smaller.

>  "ct"			{ return CT; }
>  "direction"		{ return DIRECTION; }
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
