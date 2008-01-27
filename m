From: Max Kellermann <max@duempel.org>
Subject: [iptables PATCH trunk7285 1/7] manpage fixes
Date: Sun, 27 Jan 2008 19:25:03 +0100
Message-ID: <20080127182503.15959.60931.stgit@woodpecker.roonstrasse.net>
References: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:56456 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752092AbYA0SfO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:35:14 -0500
In-Reply-To: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 extensions/libipt_REDIRECT.man |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


diff --git a/extensions/libipt_REDIRECT.man b/extensions/libipt_REDIRECT.man
index 93e2982..72f1d4d 100644
--- a/extensions/libipt_REDIRECT.man
+++ b/extensions/libipt_REDIRECT.man
@@ -7,8 +7,7 @@ and
 chains, and user-defined chains which are only called from those
 chains.  It redirects the packet to the machine itself by changing the
 destination IP to the primary address of the incoming interface
-(locally-generated packets are mapped to the 127.0.0.1 address).  It
-takes one option:
+(locally-generated packets are mapped to the 127.0.0.1 address).
 .TP
 .BR "--to-ports " "\fIport\fP[-\fIport\fP]"
 This specifies a destination port or range of ports to use: without


