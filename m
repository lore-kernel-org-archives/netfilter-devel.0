From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 5/7] autotool conversion: Converted the support for the
 'doc/' subdir.
Date: Mon, 7 Jul 2014 15:12:29 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1407071510390.20461@nerf08.vanv.qr>
References: <1404728169-7899-1-git-send-email-giorgio.nicole@arcor.de> <1404728169-7899-6-git-send-email-giorgio.nicole@arcor.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:58087 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbaGGNMc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:12:32 -0400
In-Reply-To: <1404728169-7899-6-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2014-07-07 12:16, Giorgio Dal Molin wrote:
>+		[AC_MSG_WARN([docbookx2-man/db2x_docbook2man not found, no manpages will be built])]
>+	)]
>+)
>+
>+AC_ARG_ENABLE([man], AS_HELP_STRING([--enable-man], [Enable generating the man page nft.8. Requires docbook2x-man or db2x_docbook2man.]))
>+
>+AC_MSG_CHECKING([whether to generate the man page])
>+AS_CASE([${enable_man}],
>+	[yes],[
>+		AS_IF([test -z "$DB2MAN"],AC_MSG_ERROR([No tool found to generate the man page. Please install either docbook2x-man or db2x_docbook2man.]))
>+		AC_MSG_RESULT(yes)
>+	], [
>+	NFT_8=""
>+	AC_MSG_RESULT(no)
>+	]
>+)
> 
>+AC_SUBST(DB2MAN)
>+AC_SUBST(NFT_8)
>+
>+AC_CHECK_PROG(DBLATEX, [dblatex], [found], [no])
>+AS_CASE([$DBLATEX],
>+	[found],[NFT_PDF=nft.pdf],
>+	[AC_MSG_WARN([dblatex not found, no PDF manpages will be built])]
>+)
>+
>+AC_MSG_CHECKING([whether to generate the pdf doc])
>+AC_ARG_ENABLE([pdf], AS_HELP_STRING([--enable-pdf], [Enable generating the pdf doc file nft.pdf. Requires dblatex.]))
>+AS_CASE([${enable_pdf}],
>+	[yes],[
>+		AS_IF([test -z "$DBLATEX"], AC_MSG_ERROR([No tool found to generate the pdf doc. Please install dblatex.]))
>+		AC_MSG_RESULT(yes)
>+	],[
>+	NFT_PDF=""
>+	AC_MSG_RESULT(no)
>+	]
>+)
>+
>+AC_SUBST(NFT_PDF)
> 
> # Checks for libraries.
> 
>diff --git a/doc/Makefile.am b/doc/Makefile.am
>new file mode 100644
>index 0000000..6ea973a
>--- /dev/null
>+++ b/doc/Makefile.am
>@@ -0,0 +1,12 @@
>+man_MANS = @NFT_8@
>+pdf_DATA = @NFT_PDF@
>+
>+pdfdir=${docdir}/pdf
>+
>+nft.pdf: nft.xml
>+	@echo -e "  PDF\t\t$@"
>+	@dblatex -q -t pdf -o $@ $<

automake already provided silencers that should be used in this case.

.xml.pdf:
	${AM_V_GEN}dblatex -q -t pdf -o $@ $<

.xml.8:
	${AM_V_GEN}${DB2MAN} --xinclude $<
