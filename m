From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 3/3] Add helper script pcap2ulog
Date: Sun, 23 Aug 2009 21:36:08 +0200
Message-ID: <1251056168-7073-4-git-send-email-chifflier@inl.fr>
References: <1251056168-7073-1-git-send-email-chifflier@inl.fr>
Cc: eleblond@inl.fr, Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45423 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933901AbZHWTgh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Aug 2009 15:36:37 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 3272A940167
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2009 21:36:33 +0200 (CEST)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 14094940158
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2009 21:36:31 +0200 (CEST)
In-Reply-To: <1251056168-7073-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This script uses the Net::Pcap Perl library to parse an pcap file and
send packets to ulogd2 throught the UNIXSOCK input module.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 contrib/pcap2ulog |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 96 insertions(+), 0 deletions(-)
 create mode 100755 contrib/pcap2ulog

diff --git a/contrib/pcap2ulog b/contrib/pcap2ulog
new file mode 100755
index 0000000..0a42b89
--- /dev/null
+++ b/contrib/pcap2ulog
@@ -0,0 +1,96 @@
+#!/usr/bin/perl -w
+
+# Copyright (C) 2009 Pierre Chifflier <chifflier@inl.fr>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the same terms as Perl itself, either Perl version 5.8.4 or,
+# at your option, any later version of Perl 5 you may have available.
+
+use strict;
+
+use IO::Socket;
+use Net::Pcap;
+
+
+my $dumpfile = shift or die "Unable to open pcap file";
+my($pcap_t, $err);
+my($ulogd_client);
+my $socketfile = "/var/run/ulogd2.sock";
+
+sub connect_ulogd2 {
+    (-S $socketfile) or die "ulogd2 socket $socketfile does not exist - is ulogd running ?";
+
+    $ulogd_client = IO::Socket::UNIX->new(Peer  => $socketfile,
+                                          Type      => SOCK_STREAM ) or die $!;
+}
+
+sub process_pkt {
+    my($user, $hdr, $pkt) = @_;
+
+    if (($user ne "xyz") or !defined($hdr) or !defined($pkt)) {
+        print("Bad args passed to callback\n");
+        print("Bad user data\n"), if ($user ne "xyz");
+        print("Bad pkthdr\n"), if (!defined($hdr));
+        print("Bad pkt data\n"), if (!defined($pkt));
+        print("not ok\n");
+        exit;
+    }
+
+    #print "Header: len $hdr->{len}\n";
+    #my $len = length $pkt;
+    #print "Packet length: $len\n";
+
+    # decode packet
+    # packet type (sent by us: 4)
+    # link layer address type: 1
+    # link layer address length: 6
+    # src dst
+    # protocol (IP, ARP, PPP, SNMP ...)
+    # data
+    my $ignored = substr ($pkt, 0, 6);
+    my $srcmac = substr ($pkt, 6, 6);
+    my $protocol = unpack ("n", substr ($pkt, 12, 2));
+    my $size = length($pkt) - 16;
+
+    (my $hex_src = unpack("H*", $srcmac)) =~ s/(..)/$1:/g;
+    chop $hex_src;
+    #printf "source mac: $hex_src\n";
+
+    my $hex_dst = "\0";
+
+    # format data
+    my $data;
+
+    my $options_num=2;
+    my $options_len=length($hex_src) + length($hex_dst);
+    # total length
+    $data = pack ('n', $size + 4 + (4*$options_num) + ($options_len));
+    print $ulogd_client $data;
+    # payload length + payload
+    $data = pack ('na*', $size, substr($pkt,16,$size));
+    print $ulogd_client $data;
+    # options
+    my $OOB_IN = 2;
+    $data = pack ('nna*', $OOB_IN, length($hex_src), $hex_src);
+    print $ulogd_client $data;
+    my $OOB_OUT = 3;
+    $data = pack ('nna*', $OOB_OUT, length($hex_dst), $hex_dst);
+    print $ulogd_client $data;
+
+    #exit;
+}
+
+
+connect_ulogd2 or die $!;
+
+$pcap_t = Net::Pcap::open_offline($dumpfile, \$err);
+if (!defined($pcap_t)) {
+    print("Net::Pcap::dump_open failed: ", Net::Pcap::geterr($pcap_t), "\n");
+    exit;
+}
+
+Net::Pcap::loop($pcap_t, 10, \&process_pkt, "xyz");
+Net::Pcap::close($pcap_t);
+
+
+
-- 
1.6.3.3

