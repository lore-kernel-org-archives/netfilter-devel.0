From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH] files: replace interpreter during installation
Date: Mon, 13 Jan 2014 09:39:13 +0000
Message-ID: <20140113093912.GA14898@macbook.localnet>
References: <20140113091623.10582.14579.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55470 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaAMJjR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:39:17 -0500
Content-Disposition: inline
In-Reply-To: <20140113091623.10582.14579.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 13, 2014 at 10:16:23AM +0100, Arturo Borrero Gonzalez wrote:
> Many systems (for example Debian) don't recognice `#!nft -f' as a
> valid interpreter.
> 
> A short way to handle this is to provide the full path to the interpreter
> in the shebang.
> That is what this patch does: update the shebang's path during installation.
> 
> For example, if you are installing under /usr/local, the shebang becomes:
>  #!/usr/local/sbin/nft -f
> 
> If using --prefix=/, then:
>  #!/sbin/nft -f
> 
> NOTE: If the shebang in source files are changed in a future, this sed script
> should be updated as well.

I think we should use .in files instead and perform variable substition.

> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  Makefile.defs.in  |    1 +
>  configure.ac      |    1 +
>  files/Makefile.in |    1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/Makefile.defs.in b/Makefile.defs.in
> index 502f374..3fee9c2 100644
> --- a/Makefile.defs.in
> +++ b/Makefile.defs.in
> @@ -5,6 +5,7 @@ LEX		= @LEX@
>  YACC		= @YACC@
>  MKDIR_P		= @MKDIR_P@
>  INSTALL		= @INSTALL@
> +SED		= @SED@
>  
>  PACKAGE_TARNAME	= @PACKAGE_TARNAME@
>  
> diff --git a/configure.ac b/configure.ac
> index 811d7e2..ca14d83 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -23,6 +23,7 @@ AC_SUBST([CONFIG_DEBUG])
>  AC_PROG_CC
>  AC_PROG_MKDIR_P
>  AC_PROG_INSTALL
> +AC_PROG_SED
>  
>  AC_CHECK_PROG(CONFIG_MAN, docbook2x-man, y, n)
>  if test "$CONFIG_MAN" != "y"
> diff --git a/files/Makefile.in b/files/Makefile.in
> index c3643df..dc237e2 100644
> --- a/files/Makefile.in
> +++ b/files/Makefile.in
> @@ -2,3 +2,4 @@ install:
>  	@echo -e "  INSTALL\tfiles"
>  	$(MKDIR_P) $(DESTDIR)/$(confdir)
>  	$(INSTALL) -m 755 -p $(SUBDIR)nftables/* $(DESTDIR)/$(confdir)/
> +	$(SED) -i "s~#\! nft~#\!@sbindir@/nft~" $(DESTDIR)/$(confdir)/*
