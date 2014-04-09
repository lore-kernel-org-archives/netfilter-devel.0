From: Nazim Wahid Djafar <nwd.dev@gmail.com>
Subject: nftables-20140407 compilation error
Date: Wed, 9 Apr 2014 10:17:22 +0100
Message-ID: <CABtPJSsULt0MKYHacfGtLbJFLrepcGGB5uUZ5CSaQkNdTb2kSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:41831 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaDIJRX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:17:23 -0400
Received: by mail-vc0-f172.google.com with SMTP id la4so1864227vcb.31
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 02:17:22 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is an error of compilation of nftables-20140407 on Debian 7.0
Wheezy (eglibc 2.13 )


nwd@mozart:~/lab/nftables/nftables-20140407$ LANG=us_EN make
-e   SUBDIR	src/
-e   LEX		src/scanner.l
-e   YACC		src/parser.y
-e   DEP		src/scanner.c
-e   DEP		src/parser.c
-e   DEP		src/mnl.c
-e   DEP		src/erec.c
-e   DEP		src/utils.c
-e   DEP		src/gmputil.c
-e   DEP		src/rbtree.c
-e   DEP		src/segtree.c
-e   DEP		src/netlink_delinearize.c
-e   DEP		src/netlink_linearize.c
-e   DEP		src/netlink.c
-e   DEP		src/ct.c
-e   DEP		src/meta.c
-e   DEP		src/exthdr.c
-e   DEP		src/payload.c
-e   DEP		src/proto.c
-e   DEP		src/evaluate.c
-e   DEP		src/expression.c
-e   DEP		src/datatype.c
-e   DEP		src/statement.c
-e   DEP		src/rule.c
-e   DEP		src/cli.c
-e   DEP		src/main.c
-e   YACC		src/parser.y
-e   DEP		src/parser.c
-e   DEP		src/scanner.c
-e   CC		src/main.c
-e   CC		src/cli.c
-e   CC		src/rule.c
-e   CC		src/statement.c
-e   CC		src/datatype.c
-e   CC		src/expression.c
-e   CC		src/evaluate.c
-e   CC		src/proto.c
-e   CC		src/payload.c
-e   CC		src/exthdr.c
-e   CC		src/meta.c
-e   CC		src/ct.c
-e   CC		src/netlink.c
-e   CC		src/netlink_linearize.c
-e   CC		src/netlink_delinearize.c
-e   CC		src/segtree.c
-e   CC		src/rbtree.c
-e   CC		src/gmputil.c
-e   CC		src/utils.c
-e   CC		src/erec.c
-e   CC		src/mnl.c
-e   CC		src/parser.c
-e   CC		src/scanner.c
-e   LD		src/nft
src/scanner.o: In function `nft_realloc':
/home/nwd/lab/nftables/nftables-20140407/<stdout>:4260: undefined
reference to `rpl_realloc'
src/scanner.o: In function `nft_alloc':
/home/nwd/lab/nftables/nftables-20140407/<stdout>:4248: undefined
reference to `rpl_malloc'
/home/nwd/lab/nftables/nftables-20140407/<stdout>:4248: undefined
reference to `rpl_malloc'
/home/nwd/lab/nftables/nftables-20140407/<stdout>:4248: undefined
reference to `rpl_malloc'
src/scanner.o: In function `nft_realloc':
/home/nwd/lab/nftables/nftables-20140407/<stdout>:4260: undefined
reference to `rpl_realloc'
/home/nwd/lab/nftables/nftables-20140407/<stdout>:4260: undefined
reference to `rpl_realloc'
src/scanner.o: In function `nft_alloc':
/home/nwd/lab/nftables/nftables-20140407/<stdout>:4248: undefined
reference to `rpl_malloc'
/home/nwd/lab/nftables/nftables-20140407/<stdout>:4248: undefined
reference to `rpl_malloc'
/home/nwd/lab/nftables/nftables-20140407/<stdout>:4248: undefined
reference to `rpl_malloc'
/home/nwd/lab/nftables/nftables-20140407/<stdout>:4248: undefined
reference to `rpl_malloc'
/home/nwd/lab/nftables/nftables-20140407/<stdout>:4248: undefined
reference to `rpl_malloc'
src/scanner.o: In function `nft_realloc':
/home/nwd/lab/nftables/nftables-20140407/<stdout>:4260: undefined
reference to `rpl_realloc'
src/utils.o: In function `xmalloc':
/home/nwd/lab/nftables/nftables-20140407/src/utils.c:36: undefined
reference to `rpl_malloc'
src/utils.o: In function `xrealloc':
/home/nwd/lab/nftables/nftables-20140407/src/utils.c:44: undefined
reference to `rpl_realloc'
src/parser.o: In function `nft_parse':
/home/nwd/lab/nftables/nftables-20140407/src/parser.c:3419: undefined
reference to `rpl_malloc'
/home/nwd/lab/nftables/nftables-20140407/src/parser.c:6698: undefined
reference to `rpl_malloc'
collect2: error: ld returned 1 exit status
make[1]: *** [src/nft] Error 1
make: *** [src] Error 2
