From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH] iptables: add noreturn attribute to exit_tryhelp()
Date: Fri, 19 Feb 2010 05:26:38 +0300
Message-ID: <20100219022638.GB32672@wo.int.altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vint.altlinux.org ([194.107.17.35]:52737 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0BSC0j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 21:26:39 -0500
Received: from wo.int.altlinux.org (wo.int.altlinux.org [192.168.1.4])
	by vint.altlinux.org (Postfix) with ESMTP id D0A773F80EDF
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Feb 2010 02:26:38 +0000 (UTC)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Found by gcc -Wmissing-noreturn.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 ip6tables.c |    2 +-
 iptables.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index e2359df..d98a66f 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -224,7 +224,7 @@ proto_to_name(u_int8_t proto, int nolookup)
 	return NULL;
 }
 
-static void
+static void __attribute__((noreturn))
 exit_tryhelp(int status)
 {
 	if (line != -1)
diff --git a/iptables.c b/iptables.c
index 08eb134..b4b8982 100644
--- a/iptables.c
+++ b/iptables.c
@@ -237,7 +237,7 @@ enum {
 	IPT_DOTTED_MASK
 };
 
-static void
+static void __attribute__((noreturn))
 exit_tryhelp(int status)
 {
 	if (line != -1)
-- 
ldv
