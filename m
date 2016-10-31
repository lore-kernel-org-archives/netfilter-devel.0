From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests/py: add missing payload test for numgen offset
Date: Mon, 31 Oct 2016 13:37:14 +0100
Message-ID: <1477917434-14333-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37426 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941655AbcJaMhZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2016 08:37:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 03B878D0500
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 13:37:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8C0DDA851
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 13:37:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF78CDA7E9
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 13:37:21 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new cover test for:

	ct mark set numgen inc mod 2 offset 100

is lacking the payload file chunk.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/numgen.t.payload | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tests/py/ip/numgen.t.payload b/tests/py/ip/numgen.t.payload
index a548b5c8621e..a8ba21498795 100644
--- a/tests/py/ip/numgen.t.payload
+++ b/tests/py/ip/numgen.t.payload
@@ -22,3 +22,8 @@ ip test-ip4 pre
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
+# ct mark set numgen inc mod 2 offset 100
+ip test-ip4 pre
+  [ numgen reg 1 = inc mod 2 offset 100 ]
+  [ ct set mark with reg 1 ]
+
-- 
2.1.4

