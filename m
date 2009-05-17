From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: user-space xtables ABI [was Re: [Fwd: Re: iptables pull
 request]]
Date: Sun, 17 May 2009 19:06:20 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905171853560.12523@fbirervta.pbzchgretzou.qr>
References: <4A0E9786.8060407@netfilter.org>  <1242566196.3996.23.camel@dogo.mojatatu.com>  <4A10235B.3070607@netfilter.org>  <1242573261.3996.36.camel@dogo.mojatatu.com>  <4A102FD0.2050007@netfilter.org> <1242578893.3996.70.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50703 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbZEQRGU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 13:06:20 -0400
In-Reply-To: <1242578893.3996.70.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-05-17 18:48, jamal wrote:
>
>If it is not public, then dont put it in libxtables otherwise I will
>use it (and you should not complain;->)

Then let me submit this one...

parent e55cc4aaa6e35448c14370e5261c3387d26b257d (v1.4.3.2-3-ge55cc4a)
commit ec1794f80034c4cc0c99937d6208dcdaa3d87267
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun May 17 19:01:10 2009 +0200

Move functions out of xtables.c which would contain the public API
---
 Makefile.am                     |   14 +++++++-------
 xtables.c => xtables_internal.c |    0
 2 files changed, 7 insertions(+), 7 deletions(-)
 rename xtables.c => xtables_internal.c (100%)

diff --git a/Makefile.am b/Makefile.am
index fd99098..5c883ba 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -18,17 +18,17 @@ lib_LTLIBRARIES           += libiptc/libiptc.la
 libiptc_libiptc_la_SOURCES = libiptc/libip4tc.c libiptc/libip6tc.c
 libiptc_libiptc_la_LDFLAGS = -version-info 0:0:0
 
-lib_LTLIBRARIES      += libxtables.la
-libxtables_la_SOURCES = xtables.c
-libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
-libxtables_la_LIBADD  = -ldl
+lib_LTLIBRARIES      += libxtables_internal.la
+libxtables_internal_la_SOURCES = xtables_internal.c
+libxtables_internal_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
+libxtables_internal_la_LIBADD  = -ldl
 
 # iptables, dynamic
 iptables_SOURCES          = iptables-standalone.c iptables.c
 iptables_LDFLAGS          = -rdynamic
-iptables_LDADD            = libiptc/libiptc.la extensions/libext4.a libxtables.la -lm
+iptables_LDADD            = libiptc/libiptc.la extensions/libext4.a libxtables_internal.la -lm
 
-iptables_xml_LDADD        = libxtables.la
+iptables_xml_LDADD        = libxtables_internal.la
 iptables_multi_SOURCES    = iptables-multi.c iptables-save.c \
                             iptables-restore.c iptables-xml.c \
                             iptables-standalone.c iptables.c
@@ -54,7 +54,7 @@ iptables_xml_SOURCES      = iptables-xml.c
 # ip6tables, dynamic
 ip6tables_SOURCES         = ip6tables-standalone.c ip6tables.c
 ip6tables_LDFLAGS         = -rdynamic
-ip6tables_LDADD           = libiptc/libiptc.la extensions/libext6.a libxtables.la -lm
+ip6tables_LDADD           = libiptc/libiptc.la extensions/libext6.a libxtables_internal.la -lm
 
 ip6tables_multi_SOURCES   = ip6tables-multi.c ip6tables-save.c \
                             ip6tables-restore.c ip6tables-standalone.c \
diff --git a/xtables.c b/xtables_internal.c
similarity index 100%
rename from xtables.c
rename to xtables_internal.c
--==== 

>The other side of the coin (point i am trying to make to Pablo above) is
>once i get to be backward compat, I have zero reason to upgrade.

If you have no reason to upgrade, you could use the exact iptables version
m_ipt was written for.
