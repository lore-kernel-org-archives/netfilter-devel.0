From: Kevin Cernekee <cernekee@chromium.org>
Subject: [PATCH 1/3] conntrackd: cthelper: ftp: Set match offset/len for PORT mangling
Date: Wed, 31 Aug 2016 21:27:53 -0700
Message-ID: <1472704075-38007-1-git-send-email-cernekee@chromium.org>
Cc: ashley.hughes@blueyonder.co.uk, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34548 "EHLO
        mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750701AbcIAE3W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2016 00:29:22 -0400
Received: by mail-pa0-f48.google.com with SMTP id fi15so25431454pac.1
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2016 21:29:22 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently matchoff and matchlen are 0, so IP mangling is performed in
the wrong place if NAT is used:

    FTP_NAT: type 0, off 0 len 0

The resultant packet is clearly incorrect:

    0x0000:  9410 3eb8 00ab 00e0 4c68 0012 0800 4510  ..>.....Lh....E.
    0x0010:  0081 9ed9 4000 4006 cd35 646b 0370 646b  ....@.@..5dk.pdk
    0x0020:  0212 0015 87c5 8cc2 de50 aa28 4842 8018  .........P.(HB..
    0x0030:  00e3 459d 0000 0101 080a e916 985e 2a3b  ..E..........^*;
    0x0040:  b82d 3530 3020 2731 3030 2c31 3037 2c32  .-500.'100,107,2
    0x0050:  2c31 382c 3134 392c 3739 504f 5254 2031  ,18,149,79PORT.1
    0x0060:  3932 2c31 3638 2c32 3534 2c32 2c31 3439  92,168,254,2,149
    0x0070:  2c37 3927 3a20 636f 6d6d 616e 6420 6e6f  ,79':.command.no
    0x0080:  7420 756e 6465 7273 746f 6f64 2e0d 0a    t.understood...

Add the missing assignments.

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 src/helpers/ftp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/helpers/ftp.c b/src/helpers/ftp.c
index 24ee877..3da6e56 100644
--- a/src/helpers/ftp.c
+++ b/src/helpers/ftp.c
@@ -293,6 +293,9 @@ static int ftp_find_pattern(struct pkt_buff *pkt,
 	if (!numlen)
 		return 0;
 
+	*matchoff = i;
+	*matchlen = numlen;
+
 	pr_debug("Match succeded!\n");
 	return 1;
 }
-- 
1.9.1

