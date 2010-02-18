From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH] libip4tc: Add static qualifier to dump_entry()
Date: Thu, 18 Feb 2010 19:40:20 +0300
Message-ID: <20100218164017.GA19949@wo.int.altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vint.altlinux.org ([194.107.17.35]:59249 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab0BRQuh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:50:37 -0500
Received: from wo.int.altlinux.org (wo.int.altlinux.org [192.168.1.4])
	by vint.altlinux.org (Postfix) with ESMTP id 044BF3F80EDE
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2010 16:40:21 +0000 (UTC)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Change dump_entry() signature defined in libip4tc.c to match prototype
declared in libiptc.c and another static dump_entry() function defined
in libip6tc.c.  This function is not a part of the public libiptc API.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 libiptc/libip4tc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index 3c7b073..0c64ac8 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -124,8 +124,8 @@ typedef unsigned int socklen_t;
 
 #define IP_PARTS(n) IP_PARTS_NATIVE(ntohl(n))
 
-int
-dump_entry(STRUCT_ENTRY *e, struct iptc_handle *const handle)
+static int
+dump_entry(struct ipt_entry *e, struct iptc_handle *const handle)
 {
 	size_t i;
 	STRUCT_ENTRY_TARGET *t;
-- 
ldv
