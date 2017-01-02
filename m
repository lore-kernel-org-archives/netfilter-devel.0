From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: nft segfaults listing huge sets
Date: Mon, 02 Jan 2017 11:12:05 +0100
Message-ID: <9051843e593289b7aa4d670dd304bbe5@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vulcan.natalenko.name ([104.207.131.136]:32392 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdABKU1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2017 05:20:27 -0500
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 78C7816A993
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2017 11:12:05 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

/* Please CC me, I'm not subscribed to ML */

Hello.

I'm trying to replace ipset+iptables setup with pure nft for 200+ 
thousand of subnets.

For the list of subnets I create a set in a file:

===
add table inet filter
add set inet filter p2p-paranoid { type ipv4_addr; flags interval; }
add element inet filter p2p-paranoid {
1.0.4.0/22,
1.0.64.0/18,
...
here goes 200+ thousand of lines
...
223.255.128.0/18,
223.255.241.132,
}
===

Then I apply this file by "nft -f file". This works fine.

Then I try to list ruleset with "nfs list ruleset", but get segfault:

===
Starting program: /usr/bin/nft list ruleset

Program received signal SIGSEGV, Segmentation fault.
0x000000000041ef06 in interval_map_decompose (set=0x6f26080) at 
segtree.c:617
617     segtree.c: No such file or directory.
#0  0x000000000041ef06 in interval_map_decompose (set=0x6f26080) at 
segtree.c:617
#1  0x0000000000418449 in netlink_get_setelems 
(ctx=ctx@entry=0x7fffffff5260, h=h@entry=0x65caa0,
     loc=0x43cf00 <internal_location>, set=set@entry=0x65ca90) at 
netlink.c:1603
#2  0x0000000000408119 in cache_init_objects (cmd=CMD_LIST, 
ctx=0x7fffffff5260) at rule.c:84
#3  cache_init (msgs=0x7fffffffe400, cmd=CMD_LIST) at rule.c:130
#4  cache_update (cmd=cmd@entry=CMD_LIST, msgs=0x7fffffffe400) at 
rule.c:147
#5  0x0000000000411717 in cmd_evaluate_list (cmd=0x65c730, 
ctx=0x7fffffffe9f8) at evaluate.c:2793
#6  cmd_evaluate (ctx=ctx@entry=0x7fffffffe9f8, cmd=0x65c730) at 
evaluate.c:3048
#7  0x000000000042849d in nft_parse (scanner=scanner@entry=0x65c4b0, 
state=state@entry=0x7fffffffe410) at parser_bison.y:626
#8  0x00000000004064c6 in nft_run (scanner=scanner@entry=0x65c4b0, 
state=state@entry=0x7fffffffe410,
     msgs=msgs@entry=0x7fffffffe400) at main.c:230
#9  0x00000000004069c2 in main (argc=<optimized out>, 
argv=0x7fffffffec48) at main.c:361
===

The same applies to "nft flush ruleset".

According to strace, it seems, nft runs out of stack. Here is the tail 
of strace output:

===
brk(0x10b7c000)                         = 0x10b7c000
brk(0x10b9d000)                         = 0x10b9d000
brk(0x10bbe000)                         = 0x10bbe000
brk(0x10bdf000)                         = 0x10bdf000
brk(0x10c00000)                         = 0x10c00000
brk(0x10c21000)                         = 0x10c21000
brk(0x10c42000)                         = 0x10c42000
brk(0x10c63000)                         = 0x10c63000
--- SIGSEGV {si_signo=SIGSEGV, si_code=SEGV_MAPERR, 
si_addr=0x7fffb6554b18} ---
+++ killed by SIGSEGV (core dumped) +++
===

The amount of brk() calls is ~1900.

Could that be addressed, and should I provide more info?

Thanks.

Regards,
   Oleksandr
