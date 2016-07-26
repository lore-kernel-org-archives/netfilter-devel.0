From: Sami Kerola <kerolasa@iki.fi>
Subject: [PATCH] manpages: do not adjust reject-with type footnote indentation
Date: Tue, 26 Jul 2016 14:59:06 +0100
Message-ID: <20160726135906.6808-1-kerolasa@iki.fi>
Cc: Sami Kerola <kerolasa@iki.fi>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35626 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbcGZN7L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 09:59:11 -0400
Received: by mail-wm0-f68.google.com with SMTP id i5so1821606wmg.2
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 06:59:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The footnote clarification to option argument documentation, so keep the
indentation level same as for the arguments.

Signed-off-by: Sami Kerola <kerolasa@iki.fi>
---
 extensions/libipt_REJECT.man | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libipt_REJECT.man b/extensions/libipt_REJECT.man
index 926da03..48ad565 100644
--- a/extensions/libipt_REJECT.man
+++ b/extensions/libipt_REJECT.man
@@ -27,6 +27,6 @@ can be used on rules which only match the TCP protocol: this causes a
 TCP RST packet to be sent back.  This is mainly useful for blocking 
 .I ident
 (113/tcp) probes which frequently occur when sending mail to broken mail
-hosts (which won't accept your mail otherwise).
-.PP
+htosts (which won't accept your mail otherwise).
+.IP
 (*) Using icmp\-admin\-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
-- 
2.9.0

