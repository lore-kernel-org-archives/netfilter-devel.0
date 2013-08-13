From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCHv2] iptables: link against libnetfilter_conntrack
Date: Tue, 13 Aug 2013 21:02:06 +0200 (CEST)
Message-ID: <alpine.LSU.2.10.9.1308132051420.22862@nerf07.vanv.qr>
References: <1376411824-22311-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:60309 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039Ab3HMTMN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:12:13 -0400
In-Reply-To: <1376411824-22311-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2013-08-13 18:37, Gustavo Zacarias wrote:
>diff --git a/iptables/Makefile.am b/iptables/Makefile.am
>index a4246eb..6390b7c 100644
>--- a/iptables/Makefile.am
>+++ b/iptables/Makefile.am
>@@ -21,6 +21,9 @@ xtables_multi_SOURCES += ip6tables-save.c ip6tables-restore.c \
> xtables_multi_CFLAGS  += -DENABLE_IPV6
> xtables_multi_LDADD   += ../libiptc/libip6tc.la ../extensions/libext6.a
> endif
>+if HAVE_LIBNETFILTER_CONNTRACK
>+xtables_multi_LDADD += @libnetfilter_conntrack_LIBS@
>+endif
> xtables_multi_SOURCES += xshared.c
> xtables_multi_LDADD   += ../libxtables/libxtables.la -lm

The righteous patch would be something like the following.
It's libxtables.la(libxt_connlabel.o) uses the lib, not the
main program. As for -lm, *both* the main program and
libxtables.la(static-plugins) use math funcs.

If libnetfilter_conntrack is not found, @libnetfilter_conntrack_CFLAGS@
and @libnetfilter_conntrack_LIBS@ (and their ${} ones) should be empty,
therefore producing no harm to include unconditionally.


diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 14e7c57..780e715 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -21,7 +21,7 @@ regular_CPPFLAGS   = @regular_CPPFLAGS@
 kinclude_CPPFLAGS  = @kinclude_CPPFLAGS@
 
 AM_CFLAGS       = ${regular_CFLAGS}
-AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS}
+AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS} @libnetfilter_conntrack_CFLAGS@
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 AM_LDFLAGS      = @noundef_LDFLAGS@
 
@@ -93,7 +93,7 @@ lib%.so: lib%.oo
 	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< -L../libxtables/.libs -lxtables ${$*_LIBADD};
 
 lib%.oo: ${srcdir}/lib%.c
-	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} ${$*_CFLAGADD} -o $@ -c $<;
+	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
 
 libxt_NOTRACK.so: libxt_CT.so
 	ln -fs $< $@
@@ -103,9 +103,7 @@ libxt_state.so: libxt_conntrack.so
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
 xt_RATEEST_LIBADD   = -lm
 xt_statistic_LIBADD = -lm
-@HAVE_LIBNETFILTER_CONNTRACK_TRUE@xt_connlabel_LIBADD = @libnetfilter_conntrack_LIBS@
-
-@HAVE_LIBNETFILTER_CONNTRACK_TRUE@xt_connlabel_CFLAGADD = @libnetfilter_conntrack_CFLAGS@
+xt_connlabel_LIBADD = @libnetfilter_conntrack_LIBS@
 
 #
 #	Static bits
diff --git a/libxtables/Makefile.am b/libxtables/Makefile.am
index c5795fe..4267cb5 100644
--- a/libxtables/Makefile.am
+++ b/libxtables/Makefile.am
@@ -10,7 +10,7 @@ libxtables_la_LIBADD  =
 if ENABLE_STATIC
 # With --enable-static, shipped extensions are linked into the main executable,
 # so we need all the LIBADDs here too
-libxtables_la_LIBADD += -lm
+libxtables_la_LIBADD += -lm ${libnetfilter_conntrack_LIBS}
 endif
 if ENABLE_SHARED
 libxtables_la_CFLAGS  = ${AM_CFLAGS}
