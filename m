From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 7/9] files: provide 'raw' table equivalent
Date: Tue, 14 Mar 2017 20:58:14 +0100
Message-ID: <20170314195816.1721-8-fw@strlen.de>
References: <20170314195816.1721-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42154 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751229AbdCNT63 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 15:58:29 -0400
In-Reply-To: <20170314195816.1721-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

useful for the 'ct zone set' statement, it has to be done before
the conntrack lookup but preferrably after the defragmention hook.

In iptables, the functionality resides in the CT target which is
restricted to the raw table.  This provides the skeleton for nft.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 files/nftables/Makefile.am | 4 +++-
 files/nftables/ipv4-raw    | 6 ++++++
 files/nftables/ipv6-raw    | 6 ++++++
 3 files changed, 15 insertions(+), 1 deletion(-)
 create mode 100644 files/nftables/ipv4-raw
 create mode 100644 files/nftables/ipv6-raw

diff --git a/files/nftables/Makefile.am b/files/nftables/Makefile.am
index 1378e2b684f1..a4c7ac7c980b 100644
--- a/files/nftables/Makefile.am
+++ b/files/nftables/Makefile.am
@@ -5,9 +5,11 @@ dist_pkgsysconf_DATA =	bridge-filter	\
 			ipv4-filter	\
 			ipv4-mangle	\
 			ipv4-nat	\
+			ipv4-raw	\
 			ipv6-filter	\
 			ipv6-mangle	\
-			ipv6-nat
+			ipv6-nat	\
+			ipv6-raw
 
 install-data-hook:
 	${SED} -i 's|@sbindir[@]|${sbindir}/|g' ${DESTDIR}${pkgsysconfdir}/*
diff --git a/files/nftables/ipv4-raw b/files/nftables/ipv4-raw
new file mode 100644
index 000000000000..19773ee8bc3b
--- /dev/null
+++ b/files/nftables/ipv4-raw
@@ -0,0 +1,6 @@
+#! @sbindir@nft -f
+
+table raw {
+	chain prerouting	{ type filter hook prerouting priority -300; }
+	chain output		{ type filter hook output priority -300; }
+}
diff --git a/files/nftables/ipv6-raw b/files/nftables/ipv6-raw
new file mode 100644
index 000000000000..5ee56a83987e
--- /dev/null
+++ b/files/nftables/ipv6-raw
@@ -0,0 +1,6 @@
+#! @sbindir@nft -f
+
+table ip6 raw {
+	chain prerouting	{ type filter hook prerouting priority -300; }
+	chain output		{ type filter hook output priority -300; }
+}
-- 
2.10.2

