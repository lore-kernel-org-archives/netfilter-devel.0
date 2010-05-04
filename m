From: Simon Lodal <simonl@parknet.dk>
Subject: Re: [PATCH] Document --state UNTRACKED
Date: Tue, 4 May 2010 12:05:47 +0200
Message-ID: <201005041205.47747.simonl@parknet.dk>
References: <201005040832.00376.simonl@parknet.dk> <4BDFED86.5000408@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cuda.parknet.dk ([84.238.112.40]:43398 "EHLO cuda.parknet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab0EDKFv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 May 2010 06:05:51 -0400
In-Reply-To: <4BDFED86.5000408@plouf.fr.eu.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tirsdag 04 maj 2010 11:48:54 skrev Pascal Hambourg:
> Hello,
>
> Simon Lodal a =E9crit :
> > +.B UNTRACKED
> > +meaning that the packet is not tracked at all, which happens if yo=
u use
> > +the NOTRACK target in mangle table.
>
> s/mangle/raw/

Can't believe i wrote that, thanks.

Signed-off-by: Simon Lodal <simonl@parknet.dk>

diff -ruNp a/extensions/libxt_conntrack.man b/extensions/libxt_conntrac=
k.man
--- a/extensions/libxt_conntrack.man	2010-03-01 15:11:28.000000000 +010=
0
+++ b/extensions/libxt_conntrack.man	2010-05-04 12:01:22.000000000 +020=
0
@@ -55,6 +55,10 @@ in both directions,
 meaning that the packet is starting a new connection, but is associate=
d with an
 existing connection, such as an FTP data transfer, or an ICMP error.
 .TP
+\fBUNTRACKED\fR
+meaning that the packet is not tracked at all, which happens if you us=
e
+the NOTRACK target in raw table.
+.TP
 \fBSNAT\fR
 A virtual state, matching if the original source address differs from =
the reply
 destination.
diff -ruNp a/extensions/libxt_state.man b/extensions/libxt_state.man
--- a/extensions/libxt_state.man	2010-03-01 15:11:28.000000000 +0100
+++ b/extensions/libxt_state.man	2010-05-04 12:01:34.000000000 +0200
@@ -19,3 +19,6 @@ directions, and
 meaning that the packet is starting a new connection, but is
 associated with an existing connection, such as an FTP data transfer,
 or an ICMP error.
+.B UNTRACKED
+meaning that the packet is not tracked at all, which happens if you us=
e
+the NOTRACK target in raw table.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
