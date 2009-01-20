From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] fix physdev manpage
Date: Tue, 20 Jan 2009 17:19:17 +0100
Message-ID: <4975F985.8090205@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yergi.telenet-ops.be ([195.130.132.36]:42766 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbZATQTu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2009 11:19:50 -0500
Received: from edna.telenet-ops.be (unknown [195.130.132.58])
	by yergi.telenet-ops.be (Postfix) with ESMTP id 8CA8B5C97DB
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2009 17:19:46 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by edna.telenet-ops.be (Postfix) with SMTP id 2EB92E40B3
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2009 17:19:18 +0100 (CET)
Received: from [127.0.0.1] (d54C6FD43.access.telenet.be [84.198.253.67])
	by edna.telenet-ops.be (Postfix) with ESMTP id F363CE4057
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2009 17:19:17 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


A sentence of the physdev module's help entry was truncated by the man
program because the line starts with a single quote.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>


--- iptables-1.4.2/extensions/libxt_physdev.man.old	2009-01-17 13:12:39.000000000 +0100
+++ iptables-1.4.2/extensions/libxt_physdev.man	2009-01-17 13:16:37.000000000 +0100
@@ -27,9 +27,9 @@ interface which begins with this name wi
 .B OUTPUT
 chains one cannot match on the bridge output port, however one can in the
 .B "filter OUTPUT"
-chain. If the packet won't leave by a bridge device or it is yet unknown what
-the output device will be, then the packet won't match this option, unless
-'!' is used.
+chain. If the packet won't leave by a bridge device or if it is yet unknown what
+the output device will be, then the packet won't match this option,
+unless '!' is used.
 .TP
 [\fB!\fP] \fB--physdev-is-in\fP
 Matches if the packet has entered through a bridge interface.
