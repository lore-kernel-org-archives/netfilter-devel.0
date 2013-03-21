From: pablo@netfilter.org
Subject: [PATCH 1/2] libip6t_SNPT: add manpage
Date: Thu, 21 Mar 2013 13:40:47 +0100
Message-ID: <1363869648-13529-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48528 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758060Ab3CUMk5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:40:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libip6t_SNPT.man |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 extensions/libip6t_SNPT.man

diff --git a/extensions/libip6t_SNPT.man b/extensions/libip6t_SNPT.man
new file mode 100644
index 0000000..78d644a
--- /dev/null
+++ b/extensions/libip6t_SNPT.man
@@ -0,0 +1,30 @@
+Provides stateless source IPv6-to-IPv6 Network Prefix Translation (as described
+by RFC 6296).
+.PP
+You have to use this target in the
+.B mangle
+table, not in the
+.B nat
+table. It takes the following options:
+.TP
+\fB\-\-src\-pfx\fP [\fIprefix/\fP\fIlength]
+Set source prefix that you want to translate and length
+.TP
+\fB\-\-dst\-pfx\fP [\fIprefix/\fP\fIlength]
+Set destination prefix that you want to use in the translation and length
+.PP
+You have to use the DNPT target to undo the translation. Example:
+.IP
+ip6tables \-t mangle \-I POSTROUTING \-s fd00::/64 \! \-o vboxnet0
+\-j SNPT \-\-src-pfx fd00::/64 \-\-dst-pfx 2001:e20:2000:40f::/64
+.IP
+ip6tables \-t mangle \-I PREROUTING \-i wlan0 \-d 2001:e20:2000:40f::/64
+\-j DNPT \-\-src-pfx 2001:e20:2000:40f::/64 \-\-dst-pfx fd00::/64
+.PP
+You may need to enable IPv6 neighbor proxy:
+.IP
+sysctl -w net.ipv6.conf.all.proxy_ndp=1
+.PP
+You also have to use the
+.B NOTRACK
+target to disable connection tracking for translated flows.
-- 
1.7.10.4

