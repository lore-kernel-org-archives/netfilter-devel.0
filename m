From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH 2/3] ipset: change 'iface' part in hash:net,iface set
Date: Thu,  5 Jul 2012 23:34:31 +0100
Message-ID: <1341527720-10125-1-git-send-email-mr.dash.four@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com>
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Netfilter Core Team <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56156 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480Ab2GEWfV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:35:21 -0400
Received: by mail-wi0-f172.google.com with SMTP id hm11so160062wib.1
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Jul 2012 15:35:21 -0700 (PDT)
In-Reply-To: <cover.1341525006.git.mr.dash.four@googlemail.com>
In-Reply-To: <cover.1341525006.git.mr.dash.four@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Userspace changes to ipset, allowing 'in' and 'out' values to be
specified for the 'iface' part of hash:net,iface type sets.

Man page updated accordingly.

Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
 include/libipset/linux_ip_set.h |    5 +++++
 src/ipset.8                     |    8 ++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/libipset/linux_ip_set.h b/include/libipset/linux_ip_set.h
index 008da06..8f2bd95 100644
--- a/include/libipset/linux_ip_set.h
+++ b/include/libipset/linux_ip_set.h
@@ -190,6 +190,10 @@ enum ip_set_dim {
 	 * If changed, new revision of iptables match/target is required.
 	 */
 	IPSET_DIM_MAX = 6,
+	/* 
+	 * Indicates whether the new 'iface' format (in/out) has been used.
+	 */
+	IPSET_DIM_IFACE = 7, 
 };
 
 /* Option flags for kernel operations */
@@ -198,6 +202,7 @@ enum ip_set_kopt {
 	IPSET_DIM_ONE_SRC = (1 << IPSET_DIM_ONE),
 	IPSET_DIM_TWO_SRC = (1 << IPSET_DIM_TWO),
 	IPSET_DIM_THREE_SRC = (1 << IPSET_DIM_THREE),
+	IPSET_DIM_IFACE_INOUT = (1 << IPSET_DIM_IFACE),
 };
 
 #endif /* __IP_SET_H */
diff --git a/src/ipset.8 b/src/ipset.8
index bbad680..522107f 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -800,10 +800,10 @@ set, or by the host prefix value if the set is empty.
 .PP 
 The second direction parameter of the \fBset\fR match and
 \fBSET\fR target modules corresponds to the incoming/outgoing interface:
-\fBsrc\fR to the incoming one (similar to the \fB\-i\fR flag of iptables), while
-\fBdst\fR to the outgoing one (similar to the \fB\-o\fR flag of iptables). When
-the interface is flagged with \fBphysdev:\fR, the interface is interpreted
-as the incoming/outgoing bridge port.
+\fBin\fR for the incoming, 
+\fBout\fR for the outgoing interface, thus, consistent with their appropriate flags in netfilter/iptables), while the format used in prior versions of ipset is also supported:
+\fBsrc\fR indicating the incoming and 
+\fBdst\fR the outgoing interface respectively. If the interface value is preceded with \fBphysdev:\fR, the interface is then interpreted as bridge port.
 .PP 
 The lookup time grows linearly with the number of the different prefix
 values added to the set.
-- 
1.7.10.4

