From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [lnf-log PATCH] build: fix typo
Date: Mon, 10 Aug 2015 17:11:17 +0900
Message-ID: <20150810081116.GA25169@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34881 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbbHJILW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 04:11:22 -0400
Received: by pacgr6 with SMTP id gr6so21798154pac.2
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2015 01:11:21 -0700 (PDT)
Received: from gmail.com (softbank220009032004.bbtec.net. [220.9.32.4])
        by smtp.gmail.com with ESMTPSA id vg4sm18831973pbc.90.2015.08.10.01.11.20
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Aug 2015 01:11:21 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 autogen.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/autogen.sh b/autogen.sh
index ce22b64..2b29953 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -34,6 +34,6 @@ include ()
     fi
 }
 
-[ "x$1" == "xdistrib" ] && include
+[ "x$1" = "xdistrib" ] && include
 autoreconf -fi
 rm -Rf autom4te.cache
-- 
2.1.4

