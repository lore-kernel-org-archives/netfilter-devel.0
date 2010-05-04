From: Simon Lodal <simonl@parknet.dk>
Subject: [PATCH] Document --state UNTRACKED
Date: Tue, 4 May 2010 08:32:00 +0200
Message-ID: <201005040832.00376.simonl@parknet.dk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cuda.parknet.dk ([84.238.112.40]:46870 "EHLO cuda.parknet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab0EDGvw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 May 2010 02:51:52 -0400
Received: from duen.parknet.dk (localhost [127.0.0.1])
	by cuda.parknet.dk (Spam & Virus Firewall) with ESMTP id 3D5413F33702
	for <netfilter-devel@vger.kernel.org>; Tue,  4 May 2010 08:32:01 +0200 (CEST)
Received: from duen.parknet.dk (duen.parknet.dk [84.238.112.14]) by cuda.parknet.dk with ESMTP id f5d7TfYUQaRantj0 for <netfilter-devel@vger.kernel.org>; Tue, 04 May 2010 08:32:01 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--state UNTRACKED was missing in man page.

Signed-off-by: Simon Lodal <simonl@parknet.dk>

diff -ruNp a/extensions/libxt_state.man b/extensions/libxt_state.man
--- a/extensions/libxt_state.man        2010-03-01 15:11:28.000000000 +0100
+++ b/extensions/libxt_state.man        2010-05-04 08:20:27.000000000 +0200
@@ -19,3 +19,6 @@ directions, and
 meaning that the packet is starting a new connection, but is
 associated with an existing connection, such as an FTP data transfer,
 or an ICMP error.
+.B UNTRACKED
+meaning that the packet is not tracked at all, which happens if you use
+the NOTRACK target in mangle table.

