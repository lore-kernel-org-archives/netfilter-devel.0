From: Jan Engelhardt <jengelh@medozas.de>
Subject: CONNMARK 0xffffffff patch
Date: Wed, 4 Nov 2009 13:13:20 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911041311300.10500@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36705 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbZKDMNP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:13:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,


I just saw your patch to libxt_MARK.c and remembered that CONNMARK needs 
the same.



The following changes since commit 3d915e1ac610bce44250b4aea556f4726387388d:
  Patrick McHardy (1):
        MARK: print mark rules with mask 0xffffffff as --set-mark instead of --set-xmark

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (1):
      CONNMARK: print mark rules with mask 0xffffffff as set instead of xset

 extensions/libxt_CONNMARK.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

-----

parent 3d915e1ac610bce44250b4aea556f4726387388d (v1.4.5-22-g3d915e1)
commit 5fdf032a02b671bc1a18cec0e803c17c64175ab1
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Nov 4 13:10:50 2009 +0100

CONNMARK: print mark rules with mask 0xffffffff as set instead of xset

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_CONNMARK.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 3cf62f0..1951e67 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -312,6 +312,8 @@ connmark_tg_print(const void *ip, const struct xt_entry_target *target,
 			printf("CONNMARK or 0x%x ", info->ctmark);
 		else if (info->ctmask == 0)
 			printf("CONNMARK xor 0x%x ", info->ctmark);
+		else if (info->ctmask == 0xFFFFFFFFU)
+			printf("CONNMARK set 0x%x ", info->ctmark);
 		else
 			printf("CONNMARK xset 0x%x/0x%x ",
 			       info->ctmark, info->ctmask);
-- 
# Created with git-export-patch
