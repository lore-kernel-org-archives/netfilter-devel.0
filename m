From: Sam Liddicott <sam@liddicott.com>
Subject: Re: [nft PATCH] files: replace interpreter during installation
Date: Tue, 14 Jan 2014 15:00:14 +0000
Message-ID: <CAOj-5WAXqwd3eHD0bFNxa031pLcLWwXtHsOxeYbnJxFeUVMYUA@mail.gmail.com>
References: <20140113091623.10582.14579.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:59785 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaANPAP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:00:15 -0500
Received: by mail-qe0-f48.google.com with SMTP id k5so7230416qej.21
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2014 07:00:15 -0800 (PST)
In-Reply-To: <20140113091623.10582.14579.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I realise a solution is reached, but an alternative in common use is
mentioned here for completeness;

#! /usr/bin/env nft -f

it is commonly used to invoke interpreters whose path is unknown but
which can be expected to be on the PATH

Sam

On Mon, Jan 13, 2014 at 9:16 AM, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
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
> @@ -5,6 +5,7 @@ LEX             = @LEX@
>  YACC           = @YACC@
>  MKDIR_P                = @MKDIR_P@
>  INSTALL                = @INSTALL@
> +SED            = @SED@
>
>  PACKAGE_TARNAME        = @PACKAGE_TARNAME@
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
>         @echo -e "  INSTALL\tfiles"
>         $(MKDIR_P) $(DESTDIR)/$(confdir)
>         $(INSTALL) -m 755 -p $(SUBDIR)nftables/* $(DESTDIR)/$(confdir)/
> +       $(SED) -i "s~#\! nft~#\!@sbindir@/nft~" $(DESTDIR)/$(confdir)/*
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
