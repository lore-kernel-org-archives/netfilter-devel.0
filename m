From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RESEND PATCH -stable,4.1.y] netfilter: nf_nat_redirect: add missing NULL pointer check
Date: Thu,  7 Apr 2016 18:28:29 +0200
Message-ID: <1460046509-2184-1-git-send-email-pablo@netfilter.org>
Cc: stable@vger.kernel.org, machida.yuki@jp.fujitsu.com,
	kamatam@amazon.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49564 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbcDGQ2h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 12:28:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C152B1F190D
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 18:28:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A214FDA398
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 18:28:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DB343DA791
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 18:28:32 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Munehisa Kamata <kamatam@amazon.com>

[ upstream commit 94f9cd81436c85d8c3a318ba92e236ede73752fc ]

Commit 8b13eddfdf04cbfa561725cfc42d6868fe896f56 ("netfilter: refactor NAT
redirect IPv4 to use it from nf_tables") has introduced a trivial logic
change which can result in the following crash.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
IP: [<ffffffffa033002d>] nf_nat_redirect_ipv4+0x2d/0xa0 [nf_nat_redirect]
PGD 3ba662067 PUD 3ba661067 PMD 0
Oops: 0000 [#1] SMP
Modules linked in: ipv6(E) xt_REDIRECT(E) nf_nat_redirect(E) xt_tcpudp(E) iptable_nat(E) nf_conntrack_ipv4(E) nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) ip_tables(E) x_tables(E) binfmt_misc(E) xfs(E) libcrc32c(E) evbug(E) evdev(E) psmouse(E) i2c_piix4(E) i2c_core(E) acpi_cpufreq(E) button(E) ext4(E) crc16(E) jbd2(E) mbcache(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E)
CPU: 0 PID: 2536 Comm: ip Tainted: G            E   4.1.7-15.23.amzn1.x86_64 #1
Hardware name: Xen HVM domU, BIOS 4.2.amazon 05/06/2015
task: ffff8800eb438000 ti: ffff8803ba664000 task.ti: ffff8803ba664000
[...]
Call Trace:
 <IRQ>
 [<ffffffffa0334065>] redirect_tg4+0x15/0x20 [xt_REDIRECT]
 [<ffffffffa02e2e99>] ipt_do_table+0x2b9/0x5e1 [ip_tables]
 [<ffffffffa0328045>] iptable_nat_do_chain+0x25/0x30 [iptable_nat]
 [<ffffffffa031777d>] nf_nat_ipv4_fn+0x13d/0x1f0 [nf_nat_ipv4]
 [<ffffffffa0328020>] ? iptable_nat_ipv4_fn+0x20/0x20 [iptable_nat]
 [<ffffffffa031785e>] nf_nat_ipv4_in+0x2e/0x90 [nf_nat_ipv4]
 [<ffffffffa03280a5>] iptable_nat_ipv4_in+0x15/0x20 [iptable_nat]
 [<ffffffff81449137>] nf_iterate+0x57/0x80
 [<ffffffff814491f7>] nf_hook_slow+0x97/0x100
 [<ffffffff814504d4>] ip_rcv+0x314/0x400

unsigned int
nf_nat_redirect_ipv4(struct sk_buff *skb,
...
{
...
		rcu_read_lock();
		indev = __in_dev_get_rcu(skb->dev);
		if (indev != NULL) {
			ifa = indev->ifa_list;
			newdst = ifa->ifa_local; <---
		}
		rcu_read_unlock();
...
}

Before the commit, 'ifa' had been always checked before access. After the
commit, however, it could be accessed even if it's NULL. Interestingly,
this was once fixed in 2003.

http://marc.info/?l=netfilter-devel&m=106668497403047&w=2

In addition to the original one, we have seen the crash when packets that
need to be redirected somehow arrive on an interface which hasn't been
yet fully configured.

This change just reverts the logic to the old behavior to avoid the crash.

Fixes: 8b13eddfdf04 ("netfilter: refactor NAT redirect IPv4 to use it from nf_tables")
Cc: <stable@vger.kernel.org> # 4.1.x
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This is the third resent: I already tried this, but in Greg said (in Jan 18):

"Relax, I am _way_ behind on stable patch work at the moment,
hould hopefully dig out from the mess over the next week..."

https://patchwork.ozlabs.org/patch/540946/

Please, apply this. Thanks!

 net/netfilter/nf_nat_redirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index 97b75f9..d438698 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -55,7 +55,7 @@ nf_nat_redirect_ipv4(struct sk_buff *skb,
 
 		rcu_read_lock();
 		indev = __in_dev_get_rcu(skb->dev);
-		if (indev != NULL) {
+		if (indev && indev->ifa_list) {
 			ifa = indev->ifa_list;
 			newdst = ifa->ifa_local;
 		}
-- 
2.1.4

