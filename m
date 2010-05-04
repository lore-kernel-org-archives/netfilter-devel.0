From: Simon Lodal <simonl@parknet.dk>
Subject: Re: [PATCH] Document --state UNTRACKED
Date: Tue, 4 May 2010 10:04:08 +0200
Message-ID: <201005041004.08349.simonl@parknet.dk>
References: <201005040832.00376.simonl@parknet.dk> <alpine.LSU.2.01.1005040913330.9626@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cuda.parknet.dk ([84.238.112.40]:55787 "EHLO cuda.parknet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab0EDIEL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 May 2010 04:04:11 -0400
In-Reply-To: <alpine.LSU.2.01.1005040913330.9626@obet.zrqbmnf.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tirsdag 04 maj 2010 09:13:43 skrev Jan Engelhardt:
> On Tuesday 2010-05-04 08:32, Simon Lodal wrote:
> >--state UNTRACKED was missing in man page.
>
> As is --ctstate UNTRACKED

Were you aiming for this, or just making a remark?

Signed-off-by: Simon Lodal <simonl@parknet.dk>

diff -ruNp a/extensions/libxt_conntrack.man b/extensions/libxt_conntrack.man
--- a/extensions/libxt_conntrack.man	2010-03-01 15:11:28.000000000 +0100
+++ b/extensions/libxt_conntrack.man	2010-05-04 09:57:47.000000000 +0200
@@ -55,6 +55,10 @@ in both directions,
 meaning that the packet is starting a new connection, but is associated with an
 existing connection, such as an FTP data transfer, or an ICMP error.
 .TP
+\fBUNTRACKED\fR
+meaning that the packet is not tracked at all, which happens if you use
+the NOTRACK target in mangle table.
+.TP
 \fBSNAT\fR
 A virtual state, matching if the original source address differs from the reply
 destination.
diff -ruNp a/extensions/libxt_state.man b/extensions/libxt_state.man
--- a/extensions/libxt_state.man	2010-03-01 15:11:28.000000000 +0100
+++ b/extensions/libxt_state.man	2010-05-04 09:57:47.000000000 +0200
@@ -19,3 +19,6 @@ directions, and
 meaning that the packet is starting a new connection, but is
 associated with an existing connection, such as an FTP data transfer,
 or an ICMP error.
+.B UNTRACKED
+meaning that the packet is not tracked at all, which happens if you use
+the NOTRACK target in mangle table.

