From: Harald Welte <laforge@gnumonks.org>
Subject: [wojtektm@poczta.onet.pl: Odp: problem with iplimit]
Date: Sat, 19 Oct 2002 22:37:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021019203740.GI3039@naboo.club.berlin.ccc.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="lEGEL1/lMxI0MVQ2"
Cc: wojtektm@poczta.onet.pl
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm forwarding this to here, since it belongs to this list and not in my
private mail.

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--lEGEL1/lMxI0MVQ2
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: X-Sieve: cmu-sieve 2.0
Received: from mail by coruscant.gnumonks.org with spam-scanned (Exim 3.34 #1)
	id 182wGN-0006E2-00
	for laforge@gnumonks.org; Sat, 19 Oct 2002 18:15:43 +0200
Received: from smtp4.poczta.onet.pl ([213.180.130.28])
	by coruscant.gnumonks.org with esmtp (Exim 3.34 #1)
	id 182wGM-0006Dz-00
	for laforge@gnumonks.org; Sat, 19 Oct 2002 18:15:42 +0200
Received: from pa84.krzeszowice.sdi.tpnet.pl ([217.99.138.84]:25351 "HELO
	user1") by ps4.test.onet.pl with SMTP id <S840122AbSJSQOk>;
	Sat, 19 Oct 2002 18:14:40 +0200
Message-ID: <006f01c2778a$8f8a6880$060110ac@localdomain>
From: "Wojciech Maj" <wojtektm@poczta.onet.pl>
To: "Harald Welte" <laforge@gnumonks.org>
References: <003c01c25b36$a86d6b60$060110ac@localdomain> <20020915102430.C3810@sunbeam.de.gnumonks.org> <004601c25c98$58481aa0$060110ac@localdomain> <20020915135531.S3810@sunbeam.de.gnumonks.org>
Subject: Odp: problem with iplimit
Date: Sat, 19 Oct 2002 18:14:11 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 5.00.2615.200
X-MimeOLE: Produced By Microsoft MimeOLE V5.00.2615.200

Dear Sir

As You know, Gerd Knorr (the author of iplimit ) doesn't want to maintain
it any more.
Could You please have a look at iplimit code? It contain a nasty bug, which
shows up
 if I try to limit the number of  parallel connections. Simply, sometimes
the next incoming
connection - which should be denied - is accepted. Because of this iplimit
is useless.
I need it to avoid some abuses in our local network.
Would You help me?

thanks in advance

            Wojtek

P.S.
Forgive me my english please.I hope You know what I mean







--lEGEL1/lMxI0MVQ2--
