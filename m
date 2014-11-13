From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [libnftnl PATCH 1/1] Correctly define the header 'Requires:' in
 the file 'libnftnl.pc'.
Date: Thu, 13 Nov 2014 13:34:52 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1411131328530.22813@nerf08.vanv.qr>
References: <1415880545-19831-1-git-send-email-giorgio.nicole@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:53106 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419AbaKMMex (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:34:53 -0500
In-Reply-To: <1415880545-19831-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2014-11-13 13:09, Giorgio Dal Molin wrote:
>
>Without a correctly defined 'Requires:' header failures can happen
>while linking a program against 'libnftnl', expecially while cross compiling.
>
># make V=1 all
>...
>arm-926ejs-linux-gnueabi-gcc -Wall -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wdeclaration-after-statement -Wsign-compare -Winit-self -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute -Wcast-align -Wundef -Wbad-function-cast -O2 -msoft-float -mabi=aapcs-linux -march=armv5te -mtune=arm926ej-s -mcpu=arm926ej-s -w  -L/tmp/pkg_root/lib -o nft main.o rule.o statement.o datatype.o expression.o evaluate.o proto.o payload.o exthdr.o meta.o ct.o netlink.o netlink_linearize.o netlink_delinearize.o segtree.o rbtree.o gmputil.o utils.o erec.o mnl.o scanner.o parser_bison.o  -L/tmp/pkg_root/lib -lmnl  -L/tmp/pkg_root/lib -lnftnl  -lgmp
>arm-926ejs-linux-gnueabi/bin/ld: warning: libjansson.so.4, needed by /tmp/pkg_root/lib/libnftnl.so, not found (try using -rpath or -rpath-link)
>/tmp/pkg_root/lib/libnftnl.so: undefined reference to `json_integer_value'

Can you actually check whether `LD_LIBRARY_PATH=/tmp/pkg_root/lib
ldd -r /tmp/pkg_root/lib/libnftnl.so` succeeds?

Programs should generally need not be concerned with 3rd-level
symbols. Adding json to the command line for linking the nft
program seems wrong (when you have a build with shared libraries),
because nft does not appear to be using any of the json_* symbols.

>index 55b28ab..ff29200 100644
>--- a/configure.ac
>+++ b/configure.ac
>@@ -39,19 +39,24 @@ case "$host" in
> *) AC_MSG_ERROR([Linux only, dude!]);;
> esac
> 
>+NFTNL_PC_DEPS=libmnl
> regular_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_REENTRANT"
> AS_IF([test "x$with_xml_parsing" = "xyes"], [
> 	regular_CPPFLAGS="$regular_CPPFLAGS -DXML_PARSING"
>+	NFTNL_PC_DEPS+=" mxml"
> ])

+= is not portable to sh; such should be of the form a="$a b".
