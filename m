From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] ip{,6}tables_security: fix future section mismatch
Date: Mon, 21 Jul 2008 20:25:46 +0400
Message-ID: <20080721162546.GC13264@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, sds@tycho.nsa.gov,
	jmorris@namei.org, eparis@parisplace.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:5632 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYGUQ1f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:27:35 -0400
Received: by ug-out-1314.google.com with SMTP id h2so273040ugf.16
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jul 2008 09:27:33 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently not visible, because NET_NS is mutually exclusive with SYSFS
which is required by SECURITY.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv4/netfilter/iptable_security.c  |    2 +-
 net/ipv6/netfilter/ip6table_security.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
-- 
1.5.4.5


