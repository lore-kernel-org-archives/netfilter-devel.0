From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 2/2] Add helper script pcap2ulog
Date: Thu, 14 Jan 2010 20:41:28 +0100
Message-ID: <1263498088-32555-3-git-send-email-chifflier@inl.fr>
References: <1263498088-32555-1-git-send-email-chifflier@inl.fr>
Cc: eleblond@inl.fr, Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:53288 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757546Ab0ANTlx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:41:53 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 3C692940146
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2010 20:41:48 +0100 (CET)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 19340940045
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2010 20:41:46 +0100 (CET)
In-Reply-To: <1263498088-32555-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This script uses the Net::Pcap Perl library to parse an pcap file and
send packets to ulogd2 throught the UNIXSOCK input module.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 contrib/pcap2ulog |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 149 insertions(+), 0 deletions(-)
 create mode 100755 contrib/pcap2ulog

diff --git a/contrib/pcap2ulog b/contrib/pcap2ulog
new file mode 100755
index 0000000..6f0d571
--- /dev/null
+++ b/contrib/pcap2ulog
@@ -0,0 +1,149 @@
+#!/usr/bin/perl -w
+
+# Copyright (C) 2009-2010 Pierre Chifflier <chifflier@inl.fr>
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
+my $ULOGD_SOCKET_MARK = 0x41c90fd4;
+
+my $dumpfile = shift or die "Unable to open pcap file";
+my($pcap_t, $err);
+my($ulogd_client);
+my $socketfile = "/var/run/ulogd2.sock";
+my $data_buffer;
+
+sub connect_ulogd2 {
+    (-S $socketfile) or die "ulogd2 socket $socketfile does not exist - is ulogd running ?";
+
+    $ulogd_client = IO::Socket::UNIX->new(Peer  => $socketfile,
+                                          Type      => SOCK_STREAM ) or die $!;
+    $ulogd_client->autoflush(0);
+}
+
+sub print_padding
+{
+    my ($offset) = @_;
+    my $padding;
+    my $align = 4;
+    my $data;
+
+    $padding = ($align - ($offset % $align)) % $align;
+    #print "offset: $offset padding $padding\n";
+
+    $data = "\0" x $padding;
+    $data_buffer .= $data;
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
+    #my $pcaphdr = unpack ("H*", substr ($pkt, 0, 16));
+    #printf("pcap hdr: $pcaphdr\n");
+    my $proto = unpack ("H*", substr ($pkt, 14, 2));
+    #printf("proto: $proto\n");
+
+    if ($proto ne "0800") {
+      print "ignoring packet with proto $proto\n";
+      return;
+    }
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
+    $data_buffer = undef;
+
+    # ulogd packet signature
+    $data = pack ('N', $ULOGD_SOCKET_MARK);
+
+    $data_buffer .= $data;
+
+    my $options_num=2;
+    my $options_len=length($hex_src) + length($hex_dst);
+    # total length (will be filled later)
+    my $total_size = 0;
+    $data = pack ('n', $total_size);
+    $data_buffer .= $data;
+
+    # payload length + payload
+    $data = pack ('na*', $size, substr($pkt,16,$size));
+    $data_buffer .= $data;
+    print_padding($size);
+
+    # options
+    my $OOB_IN = 2;
+    $data = pack ('nna*', $OOB_IN, length($hex_src), $hex_src);
+    $data_buffer .= $data;
+    print_padding(length($hex_src));
+    my $OOB_OUT = 3;
+    $data = pack ('nna*', $OOB_OUT, length($hex_dst), $hex_dst);
+    $data_buffer .= $data;
+    print_padding(length($hex_dst));
+
+    # replace total size in buffer
+    my $l = length($data_buffer) - 4;
+    substr($data_buffer, 4, 2) = pack('n', $l);
+
+    #(my $hex = unpack("H*", $data_buffer)) =~ s/(..)/$1 /g;
+    #print "total size $total_size, length is $l\n";
+    #print "$l will be encoded as " . unpack("H*", pack('n', $l)) . "\n";
+    #print $hex, "\n";
+
+    print $ulogd_client $data_buffer;
+
+    $ulogd_client->flush;
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
1.6.6

