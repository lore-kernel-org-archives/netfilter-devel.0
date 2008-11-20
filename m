From: Jan Engelhardt <jengelh@medozas.de>
Subject: doc: fix a typo in libip6t_REJECT.man
Date: Thu, 20 Nov 2008 17:40:50 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811201740400.7635@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49634 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbYKTQkw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:40:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 0b474f182c0735e3920a4ae8ade73e8a6aaedecf
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Nov 20 17:21:04 2008 +0100

doc: fix a typo in libip6t_REJECT.man

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_REJECT.man |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/extensions/libip6t_REJECT.man b/extensions/libip6t_REJECT.man
index 909d826..877a769 100644
--- a/extensions/libip6t_REJECT.man
+++ b/extensions/libip6t_REJECT.man
@@ -32,5 +32,4 @@ TCP RST packet to be sent back.  This is mainly useful for blocking
 (113/tcp) probes which frequently occur when sending mail to broken mail
 hosts (which won't accept your mail otherwise).
 .B tcp-reset
-can only be used with kernel versions 2.6.14 or latter.
-
+can only be used with kernel versions 2.6.14 or later.

