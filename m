From: James Morris <jmorris@redhat.com>
Subject: Patch for perlipq (fwd)
Date: Wed, 16 Nov 2005 23:44:47 -0500 (EST)
Message-ID: <Lynx.SEL.4.62.0511162343370.20029@thoron.boston.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Here's a patch for perlipq and FC4 if anyone needs it.


---------- Forwarded message ----------
Date: Wed, 16 Nov 2005 20:55:14 -0500
From: David Steele
To: jmorris@redhat.com
Subject: Patch for perlipq

Patch to make perlipq build cleanly for Fedora Core 4.

----
Thanks for making your software available.

Dave Steele
---
diff -Naur perlipq-1.25/Makefile.PL devel/Makefile.PL
--- perlipq-1.25/Makefile.PL    2000-12-01 10:02:15.000000000 -0500
+++ devel/Makefile.PL   2005-11-16 20:28:44.000000000 -0500
@@ -7,7 +7,7 @@
 #
 # Defaults
 #
-my $IPTABLES_DIR = '/usr/local';
+my $IPTABLES_DIR = '/usr';

 #
 # Query user to override defaults.
diff -Naur perlipq-1.25/t/simple.t devel/t/simple.t
--- perlipq-1.25/t/simple.t     2001-10-22 09:47:16.000000000 -0400
+++ devel/t/simple.t    2005-11-16 20:30:06.000000000 -0500
@@ -46,7 +46,7 @@
        }

        while (<PROC>) {
-               if (/^Peer pid\s+:\s+(\d+)/) {
+               if (/^Peer PID\s+:\s+(\d+)/) {
                        $procpid = $1;
                        last;
                }
@@ -72,7 +72,7 @@
        if (defined $packet) {
                print "not ok 4\n";
        } else {
-               if (IPTables::IPv4::IPQueue->errstr eq 'Timeout') {
+               if (substr( IPTables::IPv4::IPQueue->errstr,0,7) eq 'Timeout') {
                        print "ok 4\n";
                } else {
                        print "not ok 4\n";
