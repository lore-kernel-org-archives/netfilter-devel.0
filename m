Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D92A212D7C
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Aug 2025 18:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754938739; cv=none; b=F3fR4EjBvIKi61P/DnUYZROAQPndDKgszXJmFVMZiBbERloZC1frmFhQVRtPKiCIH8YI1DGy72BuoR0CaWOki+SIU7gLqe/4bzwH/GyQaMzN7ZBkciyJyEqGbdVrMAUIKeDRhEcUj824CCfYyfSFbNFEQtn478NoP5dN8bt6NtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754938739; c=relaxed/simple;
	bh=JwGhSUrIq84I6MRdoGyBtASrY2kr1cuIUItWwnNAaQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BL5kJSNkCw7kmi2tjSG7MYuXiETL+th7pwYeiNlWqxSH/RU0jwbY8ZISKZamiQDYO6P9hKCZ7GozYezx0HaSB2ok2s4Mk+DQR17QFDrFvsgPTJ1jAldjV3QqFcL8p/Y3US51dLu+kqdAWzTM0CaDFiALIpX3hY1vdY0rt/qTGvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Xd5iCj+R; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vaptwmfR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Xd5iCj+R";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vaptwmfR"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 916F660708; Mon, 11 Aug 2025 20:58:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754938733;
	bh=bF2AQorscEbaQ9OmmKTwBiczWJxQ5ThQSLF4rwuNpWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xd5iCj+RNFWqyqjpQoXlY25w367mc49+yr4U5VOYQN+xJ3QYcnO8UHP9Miw1dhuFQ
	 /yQgk0X5XB5ek/8AGOnpI3ZRL92V/FP4iavrQQohZEDzRZiDSSiTq4PAZuwIh6hHQp
	 UVCmF6V54FZdA5b2PnyeRLAzVFp+sWk4bdcqVETJl+wOM9R5UkaL0BwucYJSPietHm
	 HY2zm2Nwm30eJCRmXCRLCSdFPsPm+0vi4uDUoXk8d2LdG1n+FLoNVx1wIDZecDgA7P
	 7tNV4fGRLVVwQkQksRrLwfNmqhAv+6vHb/H8xHawGD/1gTVAQhS3ovF+VowO2Uxi0H
	 j20isdDGR3YOA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3EB1F60705;
	Mon, 11 Aug 2025 20:58:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754938731;
	bh=bF2AQorscEbaQ9OmmKTwBiczWJxQ5ThQSLF4rwuNpWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vaptwmfR4mvsAIIHzdE3xGkvRQGdcRB8qTKNlLOnAaPlbSa9gCUP1s/7AlVPl4i8U
	 PKL8AK9DvCpPdIf+F3Jhw108GKV92WFn6YLoO+b69I6yDKt6lyZ4OeKmBIyRD9Pjcm
	 6jmDee0udZJV771I+z9ki6scHeorG3Ihl6oom8oEiSEjzMQw+bi8DuEi+rWsRkKEYD
	 0yXt6Ha0+/piedPfzj/mGIG2PK0woN3w+ZTOpQEUgPx7Z4MXun/BNmdgNnZkw819nW
	 GMq10nL37bXhzuuds4wvPvV9IIc1dscA7FXBkhJXPxL1mdXXtpk7Z4A/OOK/JNB+Wr
	 26V1lAs5K40JA==
Date: Mon, 11 Aug 2025 20:58:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: Re: [nft PATCH] table: Embed creating nft version into userdata
Message-ID: <aJo9aH0KUxB67dRU@calendula>
References: <20250808124624.30768-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250808124624.30768-1-phil@nwl.cc>

Hi Phil,

Thanks for your patch, comments below.

On Fri, Aug 08, 2025 at 02:46:18PM +0200, Phil Sutter wrote:
> Upon listing a table which was created by a newer version of nftables,
> warn about the potentially incomplete content.
> 
> Suggested-by: Florian Westphal <fw@strlen.de>
> Cc: Dan Winship <danwinship@redhat.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since RFC:
> - Change NFTNL_UDATA_TABLE_NFTVER content from string (PACKAGE_VERSION)
>   to 12Byte binary data consisting of:
>   - the version 3-tuple
>   - a stable release number specified at configure-time
>   - the build time in seconds since epoch (a 64bit value - could scrap
>     some bytes, but maybe worth leaving some space)
> ---
>  .gitignore     |  1 +
>  Makefile.am    |  3 +++
>  configure.ac   | 22 ++++++++++++++++++++++
>  include/nft.h  |  2 ++
>  include/rule.h |  1 +
>  src/mnl.c      | 19 +++++++++++++------
>  src/netlink.c  | 23 ++++++++++++++++++++++-
>  src/rule.c     |  4 ++++
>  8 files changed, 68 insertions(+), 7 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index a62e31f31c6b5..1e3bc5146b2f1 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -14,6 +14,7 @@ autom4te.cache
>  build-aux/
>  libnftables.pc
>  libtool
> +nftversion.h
>  
>  # cscope files
>  /cscope.*
> diff --git a/Makefile.am b/Makefile.am
> index b5580b5451fca..ca6af2e393bed 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -33,6 +33,7 @@ sbin_PROGRAMS =
>  check_PROGRAMS =
>  dist_man_MANS =
>  CLEANFILES =
> +DISTCLEANFILES =
>  
>  ###############################################################################
>  
> @@ -106,6 +107,8 @@ noinst_HEADERS = \
>  	\
>  	$(NULL)
>  
> +DISTCLEANFILES += nftversion.h
> +
>  ###############################################################################
>  
>  AM_CPPFLAGS = \
> diff --git a/configure.ac b/configure.ac
> index 550913ef04964..2c68c2b8e0560 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -114,6 +114,28 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
>  #include <netdb.h>
>  ]])
>  
> +AC_ARG_WITH([stable-release], [AS_HELP_STRING([--with-stable-release],
> +            [Stable release number])],
> +            [], [with_stable_release=0])
> +AC_CONFIG_COMMANDS([stable_release],
> +                   [STABLE_RELEASE=$stable_release],
> +                   [stable_release=$with_stable_release])
> +AC_CONFIG_COMMANDS([nftversion.h], [
> +(
> +	echo "static char nftversion[[]] = {"
> +	echo "	${VERSION}," | tr '.' ','
> +	echo "	${STABLE_RELEASE},"
> +	for ((i = 56; i >= 0; i-= 8)); do
> +		echo "	((uint64_t)MAKE_STAMP >> $i) & 0xff,"
> +	done
> +	echo "};"
> +) >nftversion.h
> +])
> +# Current date should be fetched exactly once per build,
> +# so have 'make' call date and pass the value to every 'gcc' call
> +AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
> +CFLAGS="${CFLAGS} -DMAKE_STAMP=\${MAKE_STAMP}"
> +
>  AC_CONFIG_FILES([					\
>  		Makefile				\
>  		libnftables.pc				\
> diff --git a/include/nft.h b/include/nft.h
> index a2d62dbf4808a..b406a68ffeb18 100644
> --- a/include/nft.h
> +++ b/include/nft.h
> @@ -15,4 +15,6 @@
>   * something we frequently need to do and it's intentional. */
>  #define free_const(ptr) free((void *)(ptr))
>  
> +#define NFTNL_UDATA_TABLE_NFTVER 1

Better define this in libnftnl?

libnftnl$ git grep NFTNL_UDATA_TABLE_COMMENT
include/libnftnl/udata.h:       NFTNL_UDATA_TABLE_COMMENT,

>  #endif /* NFTABLES_NFT_H */
> diff --git a/include/rule.h b/include/rule.h
> index 470ae10754ba5..319f9c39f1107 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -170,6 +170,7 @@ struct table {
>  	uint32_t		owner;
>  	const char		*comment;
>  	bool			has_xt_stmts;
> +	bool			is_from_future;
>  };
>  
>  extern struct table *table_alloc(void);
> diff --git a/src/mnl.c b/src/mnl.c
> index 43229f2498e55..67ec60a6fee00 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -10,6 +10,7 @@
>  
>  #include <nft.h>
>  #include <iface.h>
> +#include <nftversion.h>
>  
>  #include <libmnl/libmnl.h>
>  #include <libnftnl/common.h>
> @@ -1074,24 +1075,30 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
>  	if (nlt == NULL)
>  		memory_allocation_error();
>  
> +	udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
> +	if (!udbuf)
> +		memory_allocation_error();
> +
>  	nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, cmd->handle.family);
>  	if (cmd->table) {
>  		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, cmd->table->flags);
>  
>  		if (cmd->table->comment) {
> -			udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
> -			if (!udbuf)
> -				memory_allocation_error();
>  			if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_TABLE_COMMENT, cmd->table->comment))
>  				memory_allocation_error();
> -			nftnl_table_set_data(nlt, NFTNL_TABLE_USERDATA, nftnl_udata_buf_data(udbuf),
> -					     nftnl_udata_buf_len(udbuf));

I suggest two separated TLVs, one for version and another for build time.

> -			nftnl_udata_buf_free(udbuf);
>  		}
>  	} else {
>  		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, 0);
>  	}
>  
> +	if (!nftnl_udata_put(udbuf, NFTNL_UDATA_TABLE_NFTVER,
> +			     sizeof(nftversion), nftversion))
> +		memory_allocation_error();
> +	nftnl_table_set_data(nlt, NFTNL_TABLE_USERDATA,
> +			     nftnl_udata_buf_data(udbuf),
> +			     nftnl_udata_buf_len(udbuf));
> +	nftnl_udata_buf_free(udbuf);
> +
>  	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
>  				    NFT_MSG_NEWTABLE,
>  				    cmd->handle.family,
> diff --git a/src/netlink.c b/src/netlink.c
> index 94cbcbfc6c094..97a49c08b1e82 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include <nft.h>
> +#include <nftversion.h>
>  
>  #include <errno.h>
>  #include <libmnl/libmnl.h>
> @@ -799,6 +800,10 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
>  			if (value[len - 1] != '\0')
>  				return -1;
>  			break;
> +		case NFTNL_UDATA_TABLE_NFTVER:
> +			if (len != sizeof(nftversion))
> +				return -1;
> +			break;
>  		default:
>  			return 0;
>  	}
> @@ -806,10 +811,23 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
>  	return 0;
>  }
>  
> +static int version_cmp(const struct nftnl_udata *ud)
> +{
> +	const char *udbuf = nftnl_udata_get(ud);
> +	size_t i;
> +
> +	/* udbuf length checked by table_parse_udata_cb() */
> +	for (i = 0; i < sizeof(nftversion); i++) {
> +		if (nftversion[i] != udbuf[i])
> +			return nftversion[i] - udbuf[i];
> +	}

Interesting trick.

> +	return 0;
> +}
> +
>  struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
>  					const struct nftnl_table *nlt)
>  {
> -	const struct nftnl_udata *ud[NFTNL_UDATA_TABLE_MAX + 1] = {};
> +	const struct nftnl_udata *ud[NFTNL_UDATA_TABLE_MAX + 2] = {};
>  	struct table *table;
>  	const char *udata;
>  	uint32_t ulen;
> @@ -830,6 +848,9 @@ struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
>  		}
>  		if (ud[NFTNL_UDATA_TABLE_COMMENT])
>  			table->comment = xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_TABLE_COMMENT]));
> +		if (ud[NFTNL_UDATA_TABLE_NFTVER] &&
> +		    version_cmp(ud[NFTNL_UDATA_TABLE_NFTVER]) < 0)
> +			table->is_from_future = true;
>  	}
>  
>  	return table;
> diff --git a/src/rule.c b/src/rule.c
> index 0ad948ea87f2f..fd69c622cfe75 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -1298,6 +1298,10 @@ static void table_print(const struct table *table, struct output_ctx *octx)
>  		fprintf(octx->error_fp,
>  			"# Warning: table %s %s is managed by iptables-nft, do not touch!\n",
>  			family, table->handle.table.name);
> +	if (table->is_from_future)
> +		fprintf(octx->error_fp,
> +			"# Warning: table %s %s was created by a newer version of nftables, content may be incomplete!\n",

+			"# Warning: this table %s %s was created by a newer version of nftables? Content may be incomplete!\n",

Maybe rise it as a question? This is just an indication, I was
considering you could write a program to push anything in the userdata
area. But not a deal breaker if you prefer this sentence.

> +			family, table->handle.table.name);
>  
>  	nft_print(octx, "table %s %s {", family, table->handle.table.name);
>  	if (nft_output_handle(octx) || table->flags & TABLE_F_OWNER)
> -- 
> 2.49.0
> 
