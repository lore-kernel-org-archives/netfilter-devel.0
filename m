From: =?iso-8859-1?q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.net>
Subject: nft: segfault after adding to { type ipv4_addr; flags interval; }
 set
Date: Wed, 13 Jan 2016 19:35:09 +0000
Message-ID: <1452713709.8513.0@x201s.roaming.asbjorn.biz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-qlHxMrXFiTq+PhUydrzn"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:40475 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933245AbcAMT5G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 14:57:06 -0500
Received: from x201s.roaming.asbjorn.biz (mon1.fiberby.net [193.104.135.42])
	by mail.asbjorn.biz (Postfix) with ESMTPSA id 836461C001AD
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 19:47:43 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--=-qlHxMrXFiTq+PhUydrzn
Content-Type: text/plain; charset=UTF-8

Hi,

I have been trying to migrate an ipset net:hash set to a nftables set.
I don't need the nomatch feature of ipset net:hash, a set with network
prefixes should do just fine. I do need it as a named set through.

A plain type ipv4_addr set can only hold individual addresses, so
that doesn't work with network prefixes.

I found the flags interval in the bison code, and so I tried
to test if that would work.

# nft add table testtbl
# nft add set testtbl testset { type ipv4_addr\; flags interval\; }
# nft add element testtbl testset { 192.168.3.0/24 }
> BUG: invalid data expression type prefix
> nft: netlink.c:323: netlink_gen_data: Assertion `0' failed.
> Aborted
# nft add element testtbl testset { 192.168.3.0-192.168.3.255 }
> BUG: invalid data expression type range
> nft: netlink.c:323: netlink_gen_data: Assertion `0' failed.
> Aborted
# nft add element testtbl testset { 192.168.3.0, 192.168.3.255 }
# nft list tables
> Segmentation fault
# nft flush ruleset
> Segmentation fault

How was the interval flag intended to work?

It would be great if the ipset article on the wiki, could have some info
on how to migrate separate ipset types to nftables set types.
The "Supported features compared to xtables" passes ipset having
been superseeded by the nftables native sets.


Versions:

nftables: c2494dd + debian version 0.5+snapshot20151106-1
libnftnl: 18bd297 + debian version 1.0.5+snapshot20151106-1
kernel: 4.4.0 + 4.3.3


Backtrace:

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff7509e34 in __gmpz_sub () from /usr/lib/x86_64-linux-gnu/libgmp.so.10
(gdb) bt
#0  0x00007ffff7509e34 in __gmpz_sub () from /usr/lib/x86_64-linux-gnu/libgmp.so.10
#1  0x000000000041a47e in interval_map_decompose (set=0x652b60) at segtree.c:549
#2  0x0000000000414a8c in netlink_get_setelems (ctx=ctx@entry=0x7fffffff8b80, 
    h=h@entry=0x6528b0, loc=0x438b20 <internal_location>, set=set@entry=0x6528a0)
    at netlink.c:1531
#3  0x000000000040750e in cache_init_objects (cmd=CMD_FLUSH, ctx=0x7fffffff8b80)
    at rule.c:84
#4  cache_init (msgs=0x7fffffffdcd0, cmd=CMD_FLUSH) at rule.c:130
#5  cache_update (cmd=CMD_FLUSH, msgs=0x7fffffffdcd0) at rule.c:147
#6  0x000000000040f70a in cmd_evaluate (ctx=0x7fffffffe2c8, cmd=0x652640)
    at evaluate.c:2369
#7  0x000000000042887d in nft_parse (scanner=scanner@entry=0x652590, 
    state=state@entry=0x7fffffffdce0) at parser_bison.y:652
#8  0x00000000004063cd in nft_run (scanner=scanner@entry=0x652590, 
    state=state@entry=0x7fffffffdce0, msgs=msgs@entry=0x7fffffffdcd0) at main.c:231
#9  0x0000000000406022 in main (argc=<optimized out>, argv=<optimized out>)
    at main.c:357

-- 
Best regards
Asbjørn Sloth Tønnesen
Network Engineer
Fiberby ApS - AS42541

--=-qlHxMrXFiTq+PhUydrzn--
