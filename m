From: Dan Williams <dcbw@redhat.com>
Subject: [PATCH 2/2 v2] iptables-restore.8: document -w/-W options
Date: Mon, 10 Apr 2017 12:35:18 -0500
Message-ID: <1491845718.28450.4.camel@redhat.com>
References: <1491255160.5423.16.camel@redhat.com>
         <20170408220418.GA8524@salvia> <1491707416.27302.1.camel@redhat.com>
         <20170410115356.GC2155@salvia> <1491845516.28450.3.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50900 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753963AbdDJRfU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 13:35:20 -0400
In-Reply-To: <1491845516.28450.3.camel@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes: 999eaa241212d3952ddff39a99d0d55a74e3639e

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 iptables/iptables-restore.8.in | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index bba505d..f751492 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -23,11 +23,13 @@ iptables-restore \(em Restore IP Tables
 .P
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
-\fBiptables\-restore\fP [\fB\-chntvV\fP] [\fB\-M\fP \fImodprobe\fP]
-[\fB\-T\fP \fIname\fP] [\fBfile\fP]
+\fBiptables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIsecs\fP]
+[\fB\-W\fP \fIusecs\fP] [\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
+[\fBfile\fP]
 .P
-\fBip6tables\-restore\fP [\fB\-chntvV\fP] [\fB\-M\fP \fImodprobe\fP]
-[\fB\-T\fP \fIname\fP] [\fBfile\fP]
+\fBip6tables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIsecs\fP]
+[\fB\-W\fP \fIusecs\fP] [\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
+[\fBfile\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-restore
@@ -56,6 +58,21 @@ Print additional debug info during ruleset processing.
 \fB\-V\fP, \fB\-\-version\fP
 Print the program version number.
 .TP
+\fB\-w\fP, \fB\-\-wait\fP [\fIseconds\fP]
+Wait for the xtables lock.
+To prevent multiple instances of the program from running concurrently,
+an attempt will be made to obtain an exclusive lock at launch.  By default,
+the program will exit if the lock cannot be obtained.  This option will
+make the program wait (indefinitely or for optional \fIseconds\fP) until
+the exclusive lock can be obtained.
+.TP
+\fB\-W\fP, \fB\-\-wait-interval\fP \fImicroseconds\fP
+Interval to wait per each iteration.
+When running latency sensitive applications, waiting for the xtables lock
+for extended durations may not be acceptable. This option will make each
+iteration take the amount of time specified. The default interval is
+1 second. This option only works with \fB\-w\fP.
+.TP
 \fB\-M\fP, \fB\-\-modprobe\fP \fImodprobe_program\fP
 Specify the path to the modprobe program. By default, iptables-restore will
 inspect /proc/sys/kernel/modprobe to determine the executable's path.
-- 
2.9.3
