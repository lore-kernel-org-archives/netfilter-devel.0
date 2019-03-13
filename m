Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDADC43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AB15213A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfCMTqj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 15:46:39 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48588 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbfCMTqj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 15:46:39 -0400
Received: from localhost ([::1]:33446 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h49pl-0001Ao-Fe; Wed, 13 Mar 2019 20:46:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/6] doc: Adjust arptables man pages
Date:   Wed, 13 Mar 2019 20:46:13 +0100
Message-Id: <20190313194617.31071-3-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190313194617.31071-1-phil@nwl.cc>
References: <20190313194617.31071-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Change content to suit the shipped nft-based variant. Most relevant
changes:

* FORWARD chain is not supported
* arptables-nft-save supports a few parameters

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/arptables-nft-restore.8 |  6 ++--
 iptables/arptables-nft-save.8    | 20 +++++++++----
 iptables/arptables-nft.8         | 48 +++++++++++++++-----------------
 3 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/iptables/arptables-nft-restore.8 b/iptables/arptables-nft-restore.8
index 4f2f623673415..09d9082cf9fd3 100644
--- a/iptables/arptables-nft-restore.8
+++ b/iptables/arptables-nft-restore.8
@@ -1,4 +1,4 @@
-.TH ARPTABLES-RESTORE 8 "Nov 07, 2013" "" ""
+.TH ARPTABLES-RESTORE 8 "March 2019" "" ""
 .\"
 .\" Man page written by Jesper Dangaard Brouer <brouer@redhat.com> based on a
 .\" Man page written by Harald Welte <laforge@gnumonks.org>
@@ -20,7 +20,7 @@
 .\"
 .\"
 .SH NAME
-arptables-restore \(em Restore ARP Tables
+arptables-restore \- Restore ARP Tables (nft-based)
 .SH SYNOPSIS
 \fBarptables\-restore
 .SH DESCRIPTION
@@ -32,8 +32,6 @@ Use I/O redirection provided by your shell to read from a file
 .TP
 .B arptables-restore
 flushes (deletes) all previous contents of the respective ARP Table.
-.SH BUGS
-None known as of arptables-0.0.4 release
 .SH AUTHOR
 Jesper Dangaard Brouer <brouer@redhat.com>
 .SH SEE ALSO
diff --git a/iptables/arptables-nft-save.8 b/iptables/arptables-nft-save.8
index 34791a9c087f0..905e59854cc28 100644
--- a/iptables/arptables-nft-save.8
+++ b/iptables/arptables-nft-save.8
@@ -1,4 +1,4 @@
-.TH ARPTABLES-SAVE 8 "Nov 07, 2013" "" ""
+.TH ARPTABLES-SAVE 8 "March 2019" "" ""
 .\"
 .\" Man page written by Jesper Dangaard Brouer <brouer@redhat.com> based on a
 .\" Man page written by Harald Welte <laforge@gnumonks.org>
@@ -20,16 +20,26 @@
 .\"
 .\"
 .SH NAME
-arptables-save \(em dump arptables rules to stdout
+arptables-save \- dump arptables rules to stdout (nft-based)
 .SH SYNOPSIS
-\fBarptables\-save
+\fBarptables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
+.P
+\fBarptables\-save\fP [\fB\-V\fP]
 .SH DESCRIPTION
 .PP
 .B arptables-save
 is used to dump the contents of an ARP Table in easily parseable format
 to STDOUT. Use I/O-redirection provided by your shell to write to a file.
-.SH BUGS
-None known as of arptables-0.0.4 release
+.TP
+\fB\-M\fR, \fB\-\-modprobe\fR \fImodprobe_program\fP
+Specify the path to the modprobe program. By default, arptables-save will
+inspect /proc/sys/kernel/modprobe to determine the executable's path.
+.TP
+\fB\-c\fR, \fB\-\-counters\fR
+Include the current values of all packet and byte counters in the output.
+.TP
+\fB\-V\fR, \fB\-\-version\fR
+Print version information and exit.
 .SH AUTHOR
 Jesper Dangaard Brouer <brouer@redhat.com>
 .SH SEE ALSO
diff --git a/iptables/arptables-nft.8 b/iptables/arptables-nft.8
index 3ce99e3757004..ea31e0842acd4 100644
--- a/iptables/arptables-nft.8
+++ b/iptables/arptables-nft.8
@@ -1,4 +1,4 @@
-.TH ARPTABLES 8  "June 2018"
+.TH ARPTABLES 8  "March 2019"
 .\"
 .\" Man page originally written by Jochen Friedrich <jochen@scram.de>,
 .\" maintained by Bart De Schuymer.
@@ -22,7 +22,7 @@
 .\"
 .\"
 .SH NAME
-arptables \- ARP table administration (legacy)
+arptables \- ARP table administration (nft-based)
 .SH SYNOPSIS
 .BR "arptables " [ "-t table" ] " -" [ AD ] " chain rule-specification " [ options ]
 .br
@@ -38,17 +38,6 @@ arptables \- ARP table administration (legacy)
 .br
 .BR "arptables " [ "-t table" ] " -P chain target " [ options ]
 
-.SH LEGACY
-This tool uses the old xtables/setsockopt framework, and is a legacy version
-of arptables. That means that a new, more modern tool exists with the same
-functionality using the nf_tables framework and you are encouraged to migrate now.
-The new binaries (formerly known as -compat) uses the same syntax and
-semantics than this legacy one.
-
-You can still use this legacy tool. You should probably get some specific
-information from your Linux distribution or vendor.
-More docs are available at https://wiki.nftables.org
-
 .SH DESCRIPTION
 .B arptables
 is a user space tool, it is used to set up and maintain the
@@ -106,15 +95,11 @@ first argument on the arptables command line, if used.
 .B "-t, --table"
 .br
 .BR filter ,
-is the only table and contains two (Linux kernels 2.4.X) or three (Linux kernels 2.6.0 and later) built-in chains:
+is the only table and contains two built-in chains:
 .B INPUT 
-(for frames destined for the host), 
+(for frames destined for the host) and
 .B OUTPUT 
-(for locally-generated frames) and
-.B FORWARD
-(for frames being forwarded by the bridge code). The
-.B FORWARD
-chain doesn't exist in Linux 2.4.X kernels.
+(for locally-generated frames).
 .br
 .br
 .SH ARPTABLES COMMAND LINE ARGUMENTS
@@ -258,15 +243,15 @@ numbers separated by colons.
 .TP 
 .BR "-i, --in-interface " "[!] \fIname\fP"
 The interface via which a frame is received (for the
-.BR INPUT " and " FORWARD
-chains). The flag
+.B INPUT
+chain). The flag
 .B --in-if
 is an alias for this option.
 .TP
 .BR "-o, --out-interface " "[!] \fIname\fP"
 The interface via which a frame is going to be sent (for the
-.BR OUTPUT " and " FORWARD
-chains). The flag
+.B OUTPUT
+chain). The flag
 .B --out-if
 is an alias for this option.
 .TP
@@ -344,9 +329,20 @@ Binary AND the mark with bits.
 .BR "--or-mark mark"
 Binary OR the mark with bits.
 
+.SH NOTES
+In this nft-based version of
+.BR arptables ,
+support for
+.B FORWARD
+chain has not been implemented. Since ARP packets are "forwarded" only by Linux
+bridges, the same may be achieved using
+.B FORWARD
+chain in
+.BR ebtables .
+
 .SH MAILINGLISTS
 .BR "" "See " http://netfilter.org/mailinglists.html
 .SH SEE ALSO
-.BR iptables "(8), " ebtables "(8), " arp "(8), " rarp "(8), " ifconfig "(8), " route (8)
+.BR xtables-nft "(8), " iptables "(8), " ebtables "(8), " ip (8)
 .PP
-.BR "" "See " http://ebtables.sf.net
+.BR "" "See " https://wiki.nftables.org
-- 
2.21.0

