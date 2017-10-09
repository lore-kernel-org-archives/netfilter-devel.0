From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH] extensions: libxt_tcpmss: Detect invalid ranges
Date: Mon,  9 Oct 2017 15:47:39 +0200
Message-ID: <20171009134739.19046-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:37748 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754850AbdJINrv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2017 09:47:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Previously, an MSS range of e.g. 65535:1000 was silently accepted but
would then never match a packet since the kernel checks whether the MSS
value is greater than or equal to the first *and* less than or equal to
the second value.

Detect this as a parameter problem and update the man page accordingly.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_tcpmss.c   | 6 +++++-
 extensions/libxt_tcpmss.man | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index c7c5971716294..bcd357aa3d8e2 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -27,8 +27,12 @@ static void tcpmss_parse(struct xt_option_call *cb)
 	xtables_option_parse(cb);
 	mssinfo->mss_min = cb->val.u16_range[0];
 	mssinfo->mss_max = mssinfo->mss_min;
-	if (cb->nvals == 2)
+	if (cb->nvals == 2) {
 		mssinfo->mss_max = cb->val.u16_range[1];
+		if (mssinfo->mss_max < mssinfo->mss_min)
+			xtables_error(PARAMETER_PROBLEM,
+				      "tcpmss: invalid range given");
+	}
 	if (cb->invert)
 		mssinfo->invert = 1;
 }
diff --git a/extensions/libxt_tcpmss.man b/extensions/libxt_tcpmss.man
index 8ee715cdbfb07..8253c363418f8 100644
--- a/extensions/libxt_tcpmss.man
+++ b/extensions/libxt_tcpmss.man
@@ -1,4 +1,4 @@
 This matches the TCP MSS (maximum segment size) field of the TCP header.  You can only use this on TCP SYN or SYN/ACK packets, since the MSS is only negotiated during the TCP handshake at connection startup time.
 .TP
 [\fB!\fP] \fB\-\-mss\fP \fIvalue\fP[\fB:\fP\fIvalue\fP]
-Match a given TCP MSS value or range.
+Match a given TCP MSS value or range. If a range is given, the second \fIvalue\fP must be greater than or equal to the first \fIvalue\fP.
-- 
2.13.1

