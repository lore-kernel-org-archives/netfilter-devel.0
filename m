From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/13] include: consistent usage of "extern"
Date: Sat, 23 Oct 2010 07:44:44 +0200
Message-ID: <1287812691-14470-8-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55120 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab0JWFpH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:45:07 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libmnl/libmnl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index f658428..0442d05 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -49,7 +49,7 @@ extern struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len);
 extern int mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq);
 
 /* Netlink portID checking */
-int mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid);
+extern int mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid);
 
 /* Netlink message getters */
 extern void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh);
-- 
1.7.1

