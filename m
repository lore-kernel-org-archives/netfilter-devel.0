From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Aw: Re: libnftnl.pc lacks dependency from libmnl
Date: Mon, 30 Jun 2014 13:27:14 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1406301323020.9261@nerf08.vanv.qr>
References: <2044885271.472926.1404124882557.JavaMail.ngmail@webmail13.arcor-online.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: giorgio.nicole@arcor.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:57097 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaF3L1P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:27:15 -0400
In-Reply-To: <2044885271.472926.1404124882557.JavaMail.ngmail@webmail13.arcor-online.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2014-06-30 12:41, giorgio.nicole@arcor.de wrote:
>
>(cross) compiling an autotooled version of the 'nftables' package that finds the 'libnftnl'
>library using the pkg-config macro 'PKG_CHECK_MODULES()' I get the following
>errors:
>
>arm-imx6-linux-gnueabihf-gcc -fno-strict-aliasing -Wall -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wdeclaration-after-statement -Wsign-compare -Winit-self -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute -Wcast-align -Wundef -Wbad-function-cast -Waggregate-return -Wunused -Wwrite-strings -I/opt/projects/pkg_root/include  -I/opt/projects/pkg_root/include  -I/opt/projects/pkg_root/include/ncurses  -O2 -march=armv7-a -mtune=cortex-a9 -mcpu=cortex-a9 -mfpu=neon -mvectorize-with-neon-quad -mfloat-abi=hard  -L/opt/projects/pkg_root/lib -o nft nft-main.o nft-cli.o nft-rule.o nft-statement.o nft-datatype.o nft-expression.o nft-evaluate.o nft-proto.o nft-payload.o nft-exthdr.o nft-meta.o nft-ct.o nft-netlink.o nft-netlink_linearize.o nft-netlink_delinearize.o 
 nft-segtree.o nft-rbtree.o nft-gmputil.o nft-utils.o nft-erec.o nft-mnl.o nft-scanner.o nft-yacc_parser.o -L/opt/projects/pkg_root/lib -lmnl -lnftnl -lreadline -lncurses -lgmp 
>/opt/projects/pkg_root/lib/libnftnl.a(table.o): In function `nft_table_parse_attr_cb':
>(.text+0xc): undefined reference to `mnl_attr_get_type'
>/opt/projects/pkg_root/lib/libnftnl.a(table.o): In function `nft_table_parse_attr_cb':
>(.text+0x1c): undefined reference to `mnl_attr_type_valid'
>...
>
>Maybe it is a problem only when doing a static link (I do a static link here).

Static linking should be possible, by way of libnftnl.la, which contains:

# Libraries that this one depends upon.
dependency_libs=' -lmnl'

However, nftables is not using automake+libtool, so it gets ignored.
