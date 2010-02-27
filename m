From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 40/66] include/linux/netfilter/nf_conntrack_tuple_common.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:21 +0100
Message-ID: <1267289508-31031-41-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

include/linux/netfilter/nf_conntrack_tuple_common.h:5: ERROR: open brace '{' following enum go on the same line

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 .../linux/netfilter/nf_conntrack_tuple_common.h    |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tuple_common.h b/include/linux/netfilter/nf_conntrack_tuple_common.h
index 8e145f0..2ea22b0 100644
--- a/include/linux/netfilter/nf_conntrack_tuple_common.h
+++ b/include/linux/netfilter/nf_conntrack_tuple_common.h
@@ -1,8 +1,7 @@
 #ifndef _NF_CONNTRACK_TUPLE_COMMON_H
 #define _NF_CONNTRACK_TUPLE_COMMON_H
 
-enum ip_conntrack_dir
-{
+enum ip_conntrack_dir {
 	IP_CT_DIR_ORIGINAL,
 	IP_CT_DIR_REPLY,
 	IP_CT_DIR_MAX
-- 
1.7.0.90.g251a4
