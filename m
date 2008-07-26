From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 03/06: ip{,6}tables_security: fix future section mismatch
Date: Sun, 27 Jul 2008 01:37:10 +0200 (MEST)
Message-ID: <20080726233709.15283.65484.sendpatchset@localhost.localdomain>
References: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43534 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbYGZXhM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 19:37:12 -0400
In-Reply-To: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ip{,6}tables_security: fix future section mismatch

Currently not visible, because NET_NS is mutually exclusive with SYSFS
which is required by SECURITY.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3e7770f4574672e7e6122b0dee21faf325d7b6a3
tree 7f564b32d493aa1e24040ae76a6510576a908818
parent 0b2ece9450ccf5ab814cc8d3520f6977db184e28
author Alexey Dobriyan <adobriyan@gmail.com> Sun, 27 Jul 2008 00:40:13 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 27 Jul 2008 00:40:13 +0200

 net/ipv4/netfilter/iptable_security.c  |    2 +-
 net/ipv6/netfilter/ip6table_security.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 2b472ac..db6d312 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -32,7 +32,7 @@ static struct
 	struct ipt_replace repl;
 	struct ipt_standard entries[3];
 	struct ipt_error term;
-} initial_table __initdata = {
+} initial_table __net_initdata = {
 	.repl = {
 		.name = "security",
 		.valid_hooks = SECURITY_VALID_HOOKS,
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index a07abee..6e71310 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -31,7 +31,7 @@ static struct
 	struct ip6t_replace repl;
 	struct ip6t_standard entries[3];
 	struct ip6t_error term;
-} initial_table __initdata = {
+} initial_table __net_initdata = {
 	.repl = {
 		.name = "security",
 		.valid_hooks = SECURITY_VALID_HOOKS,
