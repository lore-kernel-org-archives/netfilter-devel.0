From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: install nf_conntrack_tuple.h header
Date: Sat, 21 Feb 2009 04:10:00 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902210409170.28533@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38012 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZBUDKB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:10:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


While trying to resynchronize headers from the kernel->iptables,
I stumbled upon a missing file...

---8<---
parent 5eebd6df9f3304f74b611fe47bab50fd3a1c668b (v2.6.29-rc4-30-g5eebd6d)
commit 20ad97e0f3dab834a31b3c26b2144e819162b750
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Feb 21 04:08:46 2009 +0100

netfilter: install nf_conntrack_tuple.h header

linux/netfilter/nf_nat.h references nf_conntrack_tuple.h,
but the latter is not installed. Correct this.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 5a8af87..42fa489 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -1,4 +1,5 @@
 header-y += nf_conntrack_sctp.h
+header-y += nf_conntrack_tuple.h
 header-y += nf_conntrack_tuple_common.h
 header-y += nfnetlink_conntrack.h
 header-y += nfnetlink_log.h
-- 
# Created with git-export-patch

