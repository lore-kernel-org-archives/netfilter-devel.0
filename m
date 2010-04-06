From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] doc: add manpage for libxt_osf
Date: Tue,  6 Apr 2010 12:52:42 +0200
Message-ID: <1270551164-2945-5-git-send-email-jengelh@medozas.de>
References: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36847 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab0DFKwx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:52:53 -0400
In-Reply-To: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_osf.c   |    4 ++--
 extensions/libxt_osf.man |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 2 deletions(-)
 create mode 100644 extensions/libxt_osf.man

diff --git a/extensions/libxt_osf.c b/extensions/libxt_osf.c
index 3c0ea2d..07b86e4 100644
--- a/extensions/libxt_osf.c
+++ b/extensions/libxt_osf.c
@@ -40,8 +40,8 @@
 static void osf_help(void)
 {
 	printf("OS fingerprint match options:\n"
-		"--genre [!] string         Match a OS genre by passive fingerprinting.\n"
-		"--ttl                  Use some TTL check extensions to determine OS:\n"
+		"[!] --genre string     Match a OS genre by passive fingerprinting.\n"
+		"--ttl level            Use some TTL check extensions to determine OS:\n"
 		"       0                       true ip and fingerprint TTL comparison. Works for LAN.\n"
 		"       1                       check if ip TTL is less than fingerprint one. Works for global addresses.\n"
 		"       2                       do not compare TTL at all. Allows to detect NMAP, but can produce false results.\n"
diff --git a/extensions/libxt_osf.man b/extensions/libxt_osf.man
new file mode 100644
index 0000000..ea616a9
--- /dev/null
+++ b/extensions/libxt_osf.man
@@ -0,0 +1,45 @@
+The osf module does passive operating system fingerprinting. This modules
+compares some data (Window Size, MSS, options and their order, TTL, DF,
+and others) from packets with the SYN bit set. 
+.TP
+[\fB!\fP] \fB\-\-genre\fP \fIstring\fP
+Match an operating system genre by using a passive fingerprinting.
+.TP
+\fB\-\-ttl\fP \fIlevel\fP
+Do additional TTL checks on the packet to determine the operating system.
+\fIlevel\fP can be one of the following values:
+.IP \(bu 4
+0 - True IP address and fingerprint TTL comparison. This generally works for
+LANs.
+.IP \(bu 4
+1 - Check if the IP header's TTL is less than the fingerprint one. Works for
+globally-routable addresses.
+.IP \(bu 4
+2 - Do not compare the TTL at all.
+.TP
+\fB\-\-log\fP \fIlevel\fP
+Log determined genres into dmesg even if they do not match the desired one.
+\fIlevel\fP can be one of the following values:
+.IP \(bu 4
+0 - Log all matched or unknown signatures
+.IP \(bu 4
+1 - Log only the first one
+.IP \(bu 4
+2 - Log all known matched signatures
+.PP
+You may find something like this in syslog:
+.PP
+Windows [2000:SP3:Windows XP Pro SP1, 2000 SP3]: 11.22.33.55:4024 ->
+11.22.33.44:139 hops=3 Linux [2.5-2.6:] : 1.2.3.4:42624 -> 1.2.3.5:22 hops=4
+.PP
+OS fingerprints are loadable using the \fBnfnl_osf\fP program. To load
+fingerprints from a file, use:
+.PP
+\fBnfnl_osf -f ./pf.os\fP
+.PP
+To remove them again,
+.PP
+\fBnfnl_osf -f ./pf.os -d\fP
+.PP
+The fingerprint database can be downlaoded from
+http://www.openbsd.org/cgi-bin/cvsweb/src/etc/pf.os .
-- 
1.7.0.2

