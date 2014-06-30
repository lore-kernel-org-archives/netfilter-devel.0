From: giorgio.nicole@arcor.de
Subject: Aw: Re: libnftnl.pc lacks dependency from libmnl
Date: Mon, 30 Jun 2014 12:41:22 +0200 (CEST)
Message-ID: <2044885271.472926.1404124882557.JavaMail.ngmail@webmail13.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: jengelh@inai.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:58562 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711AbaF3KlY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:41:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

----- Original Nachricht ----
Von:     Jan Engelhardt <jengelh@inai.de>
An:      giorgio.nicole@arcor.de
Datum:   27.06.2014 17:36
Betreff: Re: libnftnl.pc lacks dependency from libmnl

> On Friday 2014-06-27 11:16, giorgio.nicole@arcor.de wrote:
> 
> >Hi,
> >
> >I've noticed that the pkg-config file libnftnl.pc installed by the
> >library package misses the dependency from libmnl in
> >the 'Required:' line.
> >
> ># cat libnftnl.pc.in
> ># libnftnl pkg-config file
> >[...]
> >Name: libnftnl
> >Description: Netfilter nf_tables infrastructure library
> >URL: http://netfilter.org/projects/libnftnl/
> >Version: @VERSION@
> >Requires:                                                             <===
> this line
> 
> This seems correct, as the libmnl development files do not appear to be 
> needed to write a libnftnl program.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Hi,

(cross) compiling an autotooled version of the 'nftables' package that finds the 'libnftnl'
library using the pkg-config macro 'PKG_CHECK_MODULES()' I get the following
errors:

arm-imx6-linux-gnueabihf-gcc -fno-strict-aliasing -Wall -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wdeclaration-after-statement -Wsign-compare -Winit-self -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute -Wcast-align -Wundef -Wbad-function-cast -Waggregate-return -Wunused -Wwrite-strings -I/opt/projects/pkg_root/include  -I/opt/projects/pkg_root/include  -I/opt/projects/pkg_root/include/ncurses  -O2 -march=armv7-a -mtune=cortex-a9 -mcpu=cortex-a9 -mfpu=neon -mvectorize-with-neon-quad -mfloat-abi=hard  -L/opt/projects/pkg_root/lib -o nft nft-main.o nft-cli.o nft-rule.o nft-statement.o nft-datatype.o nft-expression.o nft-evaluate.o nft-proto.o nft-payload.o nft-exthdr.o nft-meta.o nft-ct.o nft-netlink.o nft-netlink_linearize.o nft-netlink_delinearize.o n
 ft-segtree.o nft-rbtree.o nft-gmputil.o nft-utils.o nft-erec.o nft-mnl.o nft-scanner.o nft-yacc_parser.o -L/opt/projects/pkg_root/lib -lmnl -lnftnl -lreadline -lncurses -lgmp 
/opt/projects/pkg_root/lib/libnftnl.a(table.o): In function `nft_table_parse_attr_cb':
(.text+0xc): undefined reference to `mnl_attr_get_type'
/opt/projects/pkg_root/lib/libnftnl.a(table.o): In function `nft_table_parse_attr_cb':
(.text+0x1c): undefined reference to `mnl_attr_type_valid'
...

Maybe it is a problem only when doing a static link (I do a static link here).

Note that I also have a '-lmnl' linker option in my gcc cmdline, but it is *before* the '-lnftnl'.

giorgio
