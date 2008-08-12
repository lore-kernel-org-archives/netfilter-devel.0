From: Jan Engelhardt <jengelh@medozas.de>
Subject: manpages: add missing --rsource,--rdest options to
 libxt_recent.man
Date: Tue, 12 Aug 2008 19:36:53 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808121935410.22804@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40294 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYHLXgy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:36:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit ffffffffffffffffffffffffffffffffffffffff
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Mar 10 17:37:34 2008 +0100

manpages: add missing --rsource,--rdest options to libxt_recent.man
    
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_recent.man |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/extensions/libipt_recent.man b/extensions/libipt_recent.man
index bf5d710..02432ba 100644
--- a/extensions/libipt_recent.man
+++ b/extensions/libipt_recent.man
@@ -15,6 +15,13 @@ source address is already in the list, this will update the existing
 entry. This will always return success (or failure if `!' is passed
 in).
 .TP
+\fB--rsource\fP
+Match/save the source address of each packet in the recent list table. This
+is the default.
+.TP
+\fB--rdest\fP
+Match/save the destination address of each packet in the recent list table.
+.TP
 [\fB!\fR] \fB--rcheck\fR
 Check if the source address of the packet is currently in
 the list.

