From: Sven-Haegar Koch <haegar@sdinet.de>
Subject: iptables/ipset "-m set" alignment problem 64bit kernel 32bit
 userspace
Date: Fri, 31 Oct 2014 23:30:53 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1410312256090.1586@aurora.sdinet.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blackhole.sdinet.de ([176.9.52.58]:55261 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbaJaWkd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:40:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hallo,

Problem with 32bit userspace iptables, 64bit kernel and the "-m set" 
ipset match.

iptables:
32bit, debian 1.4.21-2 plus the ipset patch from the git branch

kernel:
64bit, debian 3.2.63-2+deb7u1 plus ipset 6.23

When trying to add an iptables set match it fails with the following 
error when using 64bit kernel and 32bit userspace:

sims:~# iptables -A OUTPUT -m set --match-set testset src -j ACCEPT
iptables: Invalid argument. Run `dmesg' for more information.

In syslog:
x_tables: ip_tables: set.3 match: invalid size 48 (kernel) != (user) 32


Adding some hacky paddings to the userspace iptables makes it work with 
my 64bit kernel, but this way is naturally no real solution:

(whitespace damaged, cut&paste)

--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -238,6 +238,7 @@ enum {
 
 struct ip_set_counter_match {
        __u8 op;
+       __u8 padding[7];
        __u64 value;
 };
 
--- a/include/linux/netfilter/xt_set.h
+++ b/include/linux/netfilter/xt_set.h
@@ -66,9 +66,11 @@ struct xt_set_info_target_v2 {
 
 struct xt_set_info_match_v3 {
        struct xt_set_info match_set;
+       __u32 padding1;
        struct ip_set_counter_match packets;
        struct ip_set_counter_match bytes;
        __u32 flags;
+       __u32 padding2;
 };
 
 /* Revision 3 target */


I do not see a way to cleanly fix the revision 3 set match, as any 
change would break it for either existing 32+32 or 64+64 environments - 
the only clean way I see would be a revision 4 that works correctly and 
accept that rev 3 does not work in the mixed environment.

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
