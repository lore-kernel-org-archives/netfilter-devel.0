Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8929C78F4F
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Aug 2025 13:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755004682; cv=none; b=CNxTo4exFMuOmGpv5vVFSKvLexRG5DJiZsno7VNS6xrp+VWO56SSAKQLG5Vvm8mgSNW+Cl5dwW2vLGGKcly62etmPTlUw4V9DLZ2lkCwwmu83UYvvV7YQfqwkdWTAScKcV2OYIY4asXBc9dsG2ALc+MZEaeZzp1P/kHRh6ZJ1rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755004682; c=relaxed/simple;
	bh=TdBgd3e19NFLamJ8o4KVpXNnXFGo/oPQFQ3YiqqpVTI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDE0jFJh0xZMIVDgyp746Ozfp16f43/hTKIsRsbcuuqf1F4wYoGXu+g5dO+5C1ADXtfGPf9I5cSXb9ydxwitfW1tk1lasICQaU72a8K3NuPDgw5e/Zqu6wJL6D2eEvcJhxq0jrkCXpZ3qxgjqCqSExRfx8kzwT4lkHUwDp27YYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XliVY4xY; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bZXjYCUJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XliVY4xY";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bZXjYCUJ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B95F7606DF; Tue, 12 Aug 2025 15:17:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755004677;
	bh=MUmIFZ1sv6SUC29ISuQ3eDVuSLJkJSNzdeSJyudFBbg=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=XliVY4xYfVHhZEFevlFQiGjHhsH59siFRkML6b+/LWNwyXxlt6T+DyVeRcq3T/slx
	 ESkIn6V/mqDIzQT5MRsgcQ0SwhOGYrZIgfckHsDqSc9ysTl1sdVLveiMcc+9t0I90M
	 TQU3YGuuDRqq14As2wHrc6rNiRzzRiEbpspGQpoB/eDaLQlb030bQ9Mtf2EBQOjZpy
	 YLh1wEf/O1P9jtvqmAws97mJY2iWSDPEY+qbAopxJS9pzaYDY1esT0RNYzQZUEn36w
	 vNZU7bncyYbTUavahiyoFC3vixN+B18Szyv4ZXuZGy7PE8EErRvCtEReeiJfIlfXK6
	 HcY0GcFeXsivQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 580FA606D8;
	Tue, 12 Aug 2025 15:17:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755004675;
	bh=MUmIFZ1sv6SUC29ISuQ3eDVuSLJkJSNzdeSJyudFBbg=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=bZXjYCUJrkKdzIdjYFWhzpkIfu2bKS31cKwg4etuLQwytnov2IaV3U2sfcC5neXGf
	 iezdYoTZyu0IpoMBdFIufmEGX9HLKCEbgd3u6iTDNlN5kcGL/lbMRQ/E6Exnn+rCQQ
	 DUomq8BfmdgmN0/uTa5iovrO/43ngyEC7sO/ZNOYUhUDercgIFXILftmkXCvchKX+N
	 NSdb9C7jiRuT46aWjyw9VZQIZCH9g+OQpPhPMlTnJR75tB3q+5pyUVsBuMb1KHiPIw
	 J9WtE7YGSxRDAZXCqjwjRIOX/bIOafnGhzNa2Z+2ozYod3U8q4x0qA4H9RNH9+oS9X
	 FJJerkOp31dJQ==
Date: Tue, 12 Aug 2025 15:17:52 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: Re: [nft PATCH] table: Embed creating nft version into userdata
Message-ID: <aJs_ACvoIndH-vdP@calendula>
References: <20250808124624.30768-1-phil@nwl.cc>
 <aJo9aH0KUxB67dRU@calendula>
 <aJs8VtYSwB0V9hRz@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aJs8VtYSwB0V9hRz@orbyte.nwl.cc>

On Tue, Aug 12, 2025 at 03:06:30PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Mon, Aug 11, 2025 at 08:58:48PM +0200, Pablo Neira Ayuso wrote:
> > Thanks for your patch, comments below.
> 
> Thanks for your review! (Replies below.)
> 
> > On Fri, Aug 08, 2025 at 02:46:18PM +0200, Phil Sutter wrote:
> > > Upon listing a table which was created by a newer version of nftables,
> > > warn about the potentially incomplete content.
> > > 
> > > Suggested-by: Florian Westphal <fw@strlen.de>
> > > Cc: Dan Winship <danwinship@redhat.com>
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > > Changes since RFC:
> > > - Change NFTNL_UDATA_TABLE_NFTVER content from string (PACKAGE_VERSION)
> > >   to 12Byte binary data consisting of:
> > >   - the version 3-tuple
> > >   - a stable release number specified at configure-time
> > >   - the build time in seconds since epoch (a 64bit value - could scrap
> > >     some bytes, but maybe worth leaving some space)
> > > ---
> > >  .gitignore     |  1 +
> > >  Makefile.am    |  3 +++
> > >  configure.ac   | 22 ++++++++++++++++++++++
> > >  include/nft.h  |  2 ++
> > >  include/rule.h |  1 +
> > >  src/mnl.c      | 19 +++++++++++++------
> > >  src/netlink.c  | 23 ++++++++++++++++++++++-
> > >  src/rule.c     |  4 ++++
> > >  8 files changed, 68 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/.gitignore b/.gitignore
> > > index a62e31f31c6b5..1e3bc5146b2f1 100644
> > > --- a/.gitignore
> > > +++ b/.gitignore
> > > @@ -14,6 +14,7 @@ autom4te.cache
> > >  build-aux/
> > >  libnftables.pc
> > >  libtool
> > > +nftversion.h
> > >  
> > >  # cscope files
> > >  /cscope.*
> > > diff --git a/Makefile.am b/Makefile.am
> > > index b5580b5451fca..ca6af2e393bed 100644
> > > --- a/Makefile.am
> > > +++ b/Makefile.am
> > > @@ -33,6 +33,7 @@ sbin_PROGRAMS =
> > >  check_PROGRAMS =
> > >  dist_man_MANS =
> > >  CLEANFILES =
> > > +DISTCLEANFILES =
> > >  
> > >  ###############################################################################
> > >  
> > > @@ -106,6 +107,8 @@ noinst_HEADERS = \
> > >  	\
> > >  	$(NULL)
> > >  
> > > +DISTCLEANFILES += nftversion.h
> > > +
> > >  ###############################################################################
> > >  
> > >  AM_CPPFLAGS = \
> > > diff --git a/configure.ac b/configure.ac
> > > index 550913ef04964..2c68c2b8e0560 100644
> > > --- a/configure.ac
> > > +++ b/configure.ac
> > > @@ -114,6 +114,28 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
> > >  #include <netdb.h>
> > >  ]])
> > >  
> > > +AC_ARG_WITH([stable-release], [AS_HELP_STRING([--with-stable-release],
> > > +            [Stable release number])],
> > > +            [], [with_stable_release=0])
> > > +AC_CONFIG_COMMANDS([stable_release],
> > > +                   [STABLE_RELEASE=$stable_release],
> > > +                   [stable_release=$with_stable_release])
> > > +AC_CONFIG_COMMANDS([nftversion.h], [
> > > +(
> > > +	echo "static char nftversion[[]] = {"
> > > +	echo "	${VERSION}," | tr '.' ','
> > > +	echo "	${STABLE_RELEASE},"
> > > +	for ((i = 56; i >= 0; i-= 8)); do
> > > +		echo "	((uint64_t)MAKE_STAMP >> $i) & 0xff,"
> > > +	done
> > > +	echo "};"
> > > +) >nftversion.h
> > > +])
> > > +# Current date should be fetched exactly once per build,
> > > +# so have 'make' call date and pass the value to every 'gcc' call
> > > +AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
> > > +CFLAGS="${CFLAGS} -DMAKE_STAMP=\${MAKE_STAMP}"
> > > +
> > >  AC_CONFIG_FILES([					\
> > >  		Makefile				\
> > >  		libnftables.pc				\
> > > diff --git a/include/nft.h b/include/nft.h
> > > index a2d62dbf4808a..b406a68ffeb18 100644
> > > --- a/include/nft.h
> > > +++ b/include/nft.h
> > > @@ -15,4 +15,6 @@
> > >   * something we frequently need to do and it's intentional. */
> > >  #define free_const(ptr) free((void *)(ptr))
> > >  
> > > +#define NFTNL_UDATA_TABLE_NFTVER 1
> > 
> > Better define this in libnftnl?
> 
> ACK, you found my "quick hack", sorry for that.

If you prefer easier backporting, then add an #ifdef here to skip the
libnftnl dependency.

> > libnftnl$ git grep NFTNL_UDATA_TABLE_COMMENT
> > include/libnftnl/udata.h:       NFTNL_UDATA_TABLE_COMMENT,
> > 
> > >  #endif /* NFTABLES_NFT_H */
> > > diff --git a/include/rule.h b/include/rule.h
> > > index 470ae10754ba5..319f9c39f1107 100644
> > > --- a/include/rule.h
> > > +++ b/include/rule.h
> > > @@ -170,6 +170,7 @@ struct table {
> > >  	uint32_t		owner;
> > >  	const char		*comment;
> > >  	bool			has_xt_stmts;
> > > +	bool			is_from_future;
> > >  };
> > >  
> > >  extern struct table *table_alloc(void);
> > > diff --git a/src/mnl.c b/src/mnl.c
> > > index 43229f2498e55..67ec60a6fee00 100644
> > > --- a/src/mnl.c
> > > +++ b/src/mnl.c
> > > @@ -10,6 +10,7 @@
> > >  
> > >  #include <nft.h>
> > >  #include <iface.h>
> > > +#include <nftversion.h>
> > >  
> > >  #include <libmnl/libmnl.h>
> > >  #include <libnftnl/common.h>
> > > @@ -1074,24 +1075,30 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
> > >  	if (nlt == NULL)
> > >  		memory_allocation_error();
> > >  
> > > +	udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
> > > +	if (!udbuf)
> > > +		memory_allocation_error();
> > > +
> > >  	nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, cmd->handle.family);
> > >  	if (cmd->table) {
> > >  		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, cmd->table->flags);
> > >  
> > >  		if (cmd->table->comment) {
> > > -			udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
> > > -			if (!udbuf)
> > > -				memory_allocation_error();
> > >  			if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_TABLE_COMMENT, cmd->table->comment))
> > >  				memory_allocation_error();
> > > -			nftnl_table_set_data(nlt, NFTNL_TABLE_USERDATA, nftnl_udata_buf_data(udbuf),
> > > -					     nftnl_udata_buf_len(udbuf));
> > 
> > I suggest two separated TLVs, one for version and another for build time.
> 
> This seems wrong to me. Build time is just an extra to the version info.
> What benefit do you see with splitting them up?

It is the same as in Netlink. If someone shows up saying built time
and version is not enough, a new attribute should be sufficient.

I cannot see how that can happen, but I have regretted everytime I
added TLVs that embed multiple fields to save a header.

> > > -			nftnl_udata_buf_free(udbuf);
> > >  		}
> > >  	} else {
> > >  		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, 0);
> > >  	}
> > >  
> > > +	if (!nftnl_udata_put(udbuf, NFTNL_UDATA_TABLE_NFTVER,
> > > +			     sizeof(nftversion), nftversion))
> > > +		memory_allocation_error();
> > > +	nftnl_table_set_data(nlt, NFTNL_TABLE_USERDATA,
> > > +			     nftnl_udata_buf_data(udbuf),
> > > +			     nftnl_udata_buf_len(udbuf));
> > > +	nftnl_udata_buf_free(udbuf);
> > > +
> > >  	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
> > >  				    NFT_MSG_NEWTABLE,
> > >  				    cmd->handle.family,
> > > diff --git a/src/netlink.c b/src/netlink.c
> > > index 94cbcbfc6c094..97a49c08b1e82 100644
> > > --- a/src/netlink.c
> > > +++ b/src/netlink.c
> > > @@ -10,6 +10,7 @@
> > >   */
> > >  
> > >  #include <nft.h>
> > > +#include <nftversion.h>
> > >  
> > >  #include <errno.h>
> > >  #include <libmnl/libmnl.h>
> > > @@ -799,6 +800,10 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
> > >  			if (value[len - 1] != '\0')
> > >  				return -1;
> > >  			break;
> > > +		case NFTNL_UDATA_TABLE_NFTVER:
> > > +			if (len != sizeof(nftversion))
> > > +				return -1;
> > > +			break;
> > >  		default:
> > >  			return 0;
> > >  	}
> > > @@ -806,10 +811,23 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
> > >  	return 0;
> > >  }
> > >  
> > > +static int version_cmp(const struct nftnl_udata *ud)
> > > +{
> > > +	const char *udbuf = nftnl_udata_get(ud);
> > > +	size_t i;
> > > +
> > > +	/* udbuf length checked by table_parse_udata_cb() */
> > > +	for (i = 0; i < sizeof(nftversion); i++) {
> > > +		if (nftversion[i] != udbuf[i])
> > > +			return nftversion[i] - udbuf[i];
> > > +	}
> > 
> > Interesting trick.
> 
> There's a German proverb about a blind hen and grains. But I like that
> function, too! :)

We don't have such proverb in Spanish :)

> > > +	return 0;
> > > +}
> > > +
> > >  struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
> > >  					const struct nftnl_table *nlt)
> > >  {
> > > -	const struct nftnl_udata *ud[NFTNL_UDATA_TABLE_MAX + 1] = {};
> > > +	const struct nftnl_udata *ud[NFTNL_UDATA_TABLE_MAX + 2] = {};
> > >  	struct table *table;
> > >  	const char *udata;
> > >  	uint32_t ulen;
> > > @@ -830,6 +848,9 @@ struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
> > >  		}
> > >  		if (ud[NFTNL_UDATA_TABLE_COMMENT])
> > >  			table->comment = xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_TABLE_COMMENT]));
> > > +		if (ud[NFTNL_UDATA_TABLE_NFTVER] &&
> > > +		    version_cmp(ud[NFTNL_UDATA_TABLE_NFTVER]) < 0)
> > > +			table->is_from_future = true;
> > >  	}
> > >  
> > >  	return table;
> > > diff --git a/src/rule.c b/src/rule.c
> > > index 0ad948ea87f2f..fd69c622cfe75 100644
> > > --- a/src/rule.c
> > > +++ b/src/rule.c
> > > @@ -1298,6 +1298,10 @@ static void table_print(const struct table *table, struct output_ctx *octx)
> > >  		fprintf(octx->error_fp,
> > >  			"# Warning: table %s %s is managed by iptables-nft, do not touch!\n",
> > >  			family, table->handle.table.name);
> > > +	if (table->is_from_future)
> > > +		fprintf(octx->error_fp,
> > > +			"# Warning: table %s %s was created by a newer version of nftables, content may be incomplete!\n",
> > 
> > +			"# Warning: this table %s %s was created by a newer version of nftables? Content may be incomplete!\n",
> > 
> > Maybe rise it as a question? This is just an indication, I was
> > considering you could write a program to push anything in the userdata
> > area. But not a deal breaker if you prefer this sentence.
> 
> Fine with me!

Thanks.
