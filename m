From: giorgio.nicole@arcor.de
Subject: Aw: Re: [libnftnl PATCH 1/1] Correctly define the header
 'Requires:' in the file 'libnftnl.pc'.
Date: Thu, 13 Nov 2014 15:36:10 +0100 (CET)
Message-ID: <786059936.614033.1415889370881.JavaMail.ngmail@webmail11.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: jengelh@inai.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:53473 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932596AbaKMOgN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:36:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, 


----- Original Nachricht ----
Von:     Jan Engelhardt <jengelh@inai.de>
An:      Giorgio Dal Molin <giorgio.nicole@arcor.de>
Datum:   13.11.2014 13:34
Betreff: Re: [libnftnl PATCH 1/1] Correctly define the header 'Requires:' in
 the file 'libnftnl.pc'.

> 
> On Thursday 2014-11-13 13:09, Giorgio Dal Molin wrote:
> >
> >Without a correctly defined 'Requires:' header failures can happen
> >while linking a program against 'libnftnl', expecially while cross
> compiling.
> >
> ># make V=1 all
> >...
> >arm-926ejs-linux-gnueabi-gcc -Wall -Wstrict-prototypes -Wmissing-prototypes
> -Wmissing-declarations -Wdeclaration-after-statement -Wsign-compare
> -Winit-self -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute
> -Wcast-align -Wundef -Wbad-function-cast -O2 -msoft-float -mabi=aapcs-linux
> -march=armv5te -mtune=arm926ej-s -mcpu=arm926ej-s -w  -L/tmp/pkg_root/lib -o
> nft main.o rule.o statement.o datatype.o expression.o evaluate.o proto.o
> payload.o exthdr.o meta.o ct.o netlink.o netlink_linearize.o
> netlink_delinearize.o segtree.o rbtree.o gmputil.o utils.o erec.o mnl.o
> scanner.o parser_bison.o  -L/tmp/pkg_root/lib -lmnl  -L/tmp/pkg_root/lib
> -lnftnl  -lgmp
> >arm-926ejs-linux-gnueabi/bin/ld: warning: libjansson.so.4, needed by
> /tmp/pkg_root/lib/libnftnl.so, not found (try using -rpath or -rpath-link)
> >/tmp/pkg_root/lib/libnftnl.so: undefined reference to `json_integer_value'
> 
> Can you actually check whether `LD_LIBRARY_PATH=/tmp/pkg_root/lib
> ldd -r /tmp/pkg_root/lib/libnftnl.so` succeeds?
> 
> Programs should generally need not be concerned with 3rd-level
> symbols. Adding json to the command line for linking the nft
> program seems wrong (when you have a build with shared libraries),
> because nft does not appear to be using any of the json_* symbols.
> 
I'm not really a 'guru' about building sw packages but
as I understand the pkg-config system there is no *direct* 3rd-level
dependencies, every package must declare just its own direct deps, pkg-config
then does the recursion when needed, pulling in the whole tree.
In this case, the 'nftable' package just needs 'libnftnl', it should not know
what 'libnftnl' in turn needs.

Here is how I (cross) build 'nftable' in my own Makefile:
...
configure:
	( cd $(BUILD_DIR) &&									\
	$(SRC_DIR)/configure									\
		PKG_CONFIG_LIBDIR="$(PKG_ROOT)/lib/pkgconfig" 		\
		CFLAGS="$(CROSS_CFLAGS)"						\
		--prefix= --host="$(CONFIGURE_HOST)"				\
		--libexecdir=/lib				 					\
		--enable-assert									\
		--without-cli									\
	)

build: configure
	$(MAKE) -C $(BUILD_DIR) DESTDIR=$(PKG_ROOT) V=1 all
	$(MAKE) -C $(BUILD_DIR) DESTDIR=$(PKG_ROOT) install-strip

I think this should just work, without requiring additional/redundant infos.

I've tested your 'ldd' with the LD_LIBRARY_PATH explicitly set and it
actually works but I don't want to fiddle with such env. variables directly
when I already have a build configuration system.

giorgio

> >index 55b28ab..ff29200 100644
> >--- a/configure.ac
> >+++ b/configure.ac
> >@@ -39,19 +39,24 @@ case "$host" in
> > *) AC_MSG_ERROR([Linux only, dude!]);;
> > esac
> > 
> >+NFTNL_PC_DEPS=libmnl
> > regular_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_REENTRANT"
> > AS_IF([test "x$with_xml_parsing" = "xyes"], [
> > 	regular_CPPFLAGS="$regular_CPPFLAGS -DXML_PARSING"
> >+	NFTNL_PC_DEPS+=" mxml"
> > ])
> 
> += is not portable to sh; such should be of the form a="$a b".
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
