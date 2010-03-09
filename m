From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: [PATCH 1/1] netfilter: nf_ct_tcp: pack nf_ct_tcp_flags to match user space
Date: Tue,  9 Mar 2010 17:48:17 +0100
Message-ID: <1268153297-4226-2-git-send-email-ljaenicke@innominate.com>
References: <1268153297-4226-1-git-send-email-ljaenicke@innominate.com>
Cc: Lutz Jaenicke <ljaenicke@innominate.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:43049 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab0CIQsS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:48:18 -0500
In-Reply-To: <1268153297-4226-1-git-send-email-ljaenicke@innominate.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On some platforms (here: Intel IXP4xx ARM big endian)
sizeof(struct nf_ct_tcp_flags) evaluates to 4 bytes while in the user
space code 2 bytes is hard coded.
Add "__attribute__ ((__packed__))" to enforce matching structure
sizes.

Signed-off-by: Lutz Jaenicke <ljaenicke@innominate.com>
---
 include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index 6e135f9..c7ee4ec 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -39,7 +39,7 @@ enum tcp_conntrack {
 /* The field td_maxack has been set */
 #define IP_CT_TCP_FLAG_MAXACK_SET		0x20
 
-struct nf_ct_tcp_flags {
+struct __attribute__ ((packed)) nf_ct_tcp_flags {
 	__u8 flags;
 	__u8 mask;
 };
-- 
1.6.0.3

