From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 085/103] netfilter: ip6tables: remove xt1 SET_REPLACE code
Date: Tue,  4 Aug 2009 09:26:09 +0200
Message-ID: <1249370787-17583-86-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56959 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593AbZHDH2F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:05 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv6/netfilter/ip6_tables.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index deb63f9..846d15c 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1557,8 +1557,7 @@ compat_do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user,
 
 	switch (cmd) {
 	case IP6T_SO_SET_REPLACE:
-		ret = compat_do_replace(sock_net(sk), user, len);
-		break;
+		return ip6t2_compat_do_replace(sock_net(sk), user, len);
 
 	case IP6T_SO_SET_ADD_COUNTERS:
 		ret = do_add_counters(sock_net(sk), user, len, 1);
@@ -1644,8 +1643,7 @@ do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 
 	switch (cmd) {
 	case IP6T_SO_SET_REPLACE:
-		ret = do_replace(sock_net(sk), user, len);
-		break;
+		return ip6t2_do_replace(sock_net(sk), user, len);
 
 	case IP6T_SO_SET_ADD_COUNTERS:
 		ret = do_add_counters(sock_net(sk), user, len, 0);
-- 
1.6.3.3

