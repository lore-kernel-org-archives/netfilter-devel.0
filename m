From: Jiri Benc <jbenc@redhat.com>
Subject: [BUG] libnftables: NULL pointer dereference in nft_expr_ops_lookup
Date: Fri, 25 Oct 2013 15:27:35 +0200
Message-ID: <20131025152735.65d354bd@griffin>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab3JYN1j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:27:39 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9PDRcJR028701
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2013 09:27:39 -0400
Received: from griffin (ovpn-113-123.phx2.redhat.com [10.3.113.123])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r9PDRahR009329
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2013 09:27:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

using both the latest (git) libnftables and nftables, I got:

[root@localhost ~]# nft add rule ip filter input tcp dport 81 reject
Segmentation fault (core dumped)

(gdb) bt
#0  0x00007fb7890c1364 in __strcmp_sse2 () from /lib64/libc.so.6
#1  0x00007fb78960bfa4 in nft_expr_ops_lookup (name=name@entry=0x0) at expr_ops.c:18
#2  0x00007fb78960bc56 in nft_rule_expr_alloc (name=name@entry=0x0) at expr.c:34
#3  0x000000000040db29 in alloc_nft_expr (name=name@entry=0x0) at src/netlink.c:118
#4  0x0000000000410117 in netlink_gen_reject_stmt (ctx=<optimized out>, stmt=<optimized out>)
    at src/netlink_linearize.c:564
#5  netlink_gen_stmt (stmt=0xb106f0, ctx=0x7fff734c4690) at src/netlink_linearize.c:651
#6  netlink_linearize_rule (ctx=ctx@entry=0x7fff734c4730, nlr=nlr@entry=0xb10520, rule=rule@entry=0xb10760)
    at src/netlink_linearize.c:670
#7  0x000000000040e25b in netlink_add_rule_batch (ctx=0x7fff734c4730, h=<optimized out>, rule=0xb10760, flags=2048)
    at src/netlink.c:320
#8  0x00000000004056ec in nft_netlink (msgs=0x7fff734c48b0, state=0x7fff734c48c0) at src/main.c:167
#9  nft_run (scanner=scanner@entry=0xb102c0, state=state@entry=0x7fff734c48c0, msgs=msgs@entry=0x7fff734c48b0)
    at src/main.c:214
#10 0x00000000004052e5 in main (argc=10, argv=<optimized out>) at src/main.c:321


Looking into the code, netlink_gen_reject_stmt calls
alloc_nft_expr(NULL), the NULL propagates to strcmp in
nft_expr_ops_lookup.

Sorry for not providing a patch, I'm only starting looking into the code
and this seems to require at least certain degree of understanding
those functions.

 Jiri

-- 
Jiri Benc
