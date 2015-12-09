From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: Link libext_arpt to static build
Date: Wed, 9 Dec 2015 13:53:32 +0100
Message-ID: <20151209125332.GA17240@salvia>
References: <1448273927-24853-1-git-send-email-daniel.wagner@bmw-carit.de>
 <20151125194541.GA12517@salvia>
 <5656A9D2.3080502@bmw-carit.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Daniel Wagner <daniel.wagner@bmw-carit.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50158 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbbLIMxl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 07:53:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9DD021324CC
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 13:53:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8AC05DA808
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 13:53:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A73C9DA85F
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 13:53:37 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <5656A9D2.3080502@bmw-carit.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 26, 2015 at 07:42:26AM +0100, Daniel Wagner wrote:
> On 11/25/2015 08:45 PM, Pablo Neira Ayuso wrote:
> > On Mon, Nov 23, 2015 at 11:18:47AM +0100, Daniel Wagner wrote:
> >> The libext_arpt is not included when linking the static version of
> >> iptables.
> >>
> >> Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
> >> ---
> >> Hi,
> >>
> >> I had some troubles getting a static version of iptables. Not sure
> >> if I fixed it correctly. Anyway I am able to proceed with testing.
> > 
> > Could you tell me what options you're using to compile iptables so I
> > can try to reproduce it?
> 
> Yes, sure. I am using this simple toy script to build:
> 
> declare -a arr=("libmnl" "libnl" "libnftnl" "libnfnetlink"
> "libnetfilter" "libnetfilter_acct" "libnetfilter_conntrack"
> "libnetfilter_cthelper" "libnetfilter_cttimeout" "libnetfilter_queue"
> "iptables")
> 
> NFPATH=/home/wagi/connman/netfilter
> export PKG_CONFIG_PATH=$NFPATH/lib/pkgconfig
> export LD_LIBRARY_PATH=$NFPATH/lib
> 
> ## now loop through the above array
> for i in "${arr[@]}"
> do
>     echo "$i"
>     (
> 	cd $i
> 	./configure --prefix=$NFPATH --enable-static

I can reproduce this, thanks.

We also need to include libnetfilter_conntrack otherwise static builds
also break when connlabel support is on.

--bg08WKrSYDhXBjb5
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 132fe5f..3c0faa5 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -1,7 +1,7 @@
 # -*- Makefile -*-
 
 AM_CFLAGS        = ${regular_CFLAGS}
-AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${libmnl_CFLAGS} ${libnftnl_CFLAGS}
+AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${libmnl_CFLAGS} ${libnftnl_CFLAGS} ${libnetfilter_conntrack_CFLAGS}
 AM_YFLAGS = -d
 
 xtables_multi_SOURCES  = xtables-multi.c iptables-xml.c
@@ -41,7 +41,7 @@ xtables_compat_multi_SOURCES += xtables-save.c xtables-restore.c \
 				xtables-arp-standalone.c xtables-arp.c \
 				getethertype.c nft-bridge.c \
 				xtables-eb-standalone.c xtables-eb.c
-xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS} ../extensions/libext4.a ../extensions/libext6.a ../extensions/libext_ebt.a
+xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS} ${libnetfilter_conntrack_LIBS} ../extensions/libext4.a ../extensions/libext6.a ../extensions/libext_ebt.a ../extensions/libext_arpt.a
 # yacc and lex generate dirty code
 xtables_compat_multi-xtables-config-parser.o xtables_compat_multi-xtables-config-syntax.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
 xtables_compat_multi_SOURCES += xshared.c

--bg08WKrSYDhXBjb5--
