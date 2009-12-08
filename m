From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: xtables: document minimal required version
Date: Tue, 8 Dec 2009 10:52:15 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912081051350.15041@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60077 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbZLHJwK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:52:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For both .33 and .32-stable.

---
parent 22763c5cf3690a681551162c15d34d935308c8d7 (v2.6.32)
commit 49313cdac7b34c9f7ecbb1780cfc648b1c082cd7
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Dec 8 10:51:25 2009 +0100

netfilter: xtables: document minimal required version

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Documentation/Changes |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/Changes b/Documentation/Changes
index 6d0f1ef..f08b313 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -49,6 +49,8 @@ o  oprofile               0.9                     # oprofiled --version
 o  udev                   081                     # udevinfo -V
 o  grub                   0.93                    # grub --version
 o  mcelog		  0.6
+o  iptables               1.4.1                   # iptables -V
+
 
 Kernel compilation
 ==================
-- 
# Created with git-export-patch

