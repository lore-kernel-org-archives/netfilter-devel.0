Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA38C25B6C
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 13:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbjJXNT2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 09:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbjJXNT0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 09:19:26 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EA510E
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 06:19:21 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id E082C587850F1; Tue, 24 Oct 2023 15:19:19 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 5D20558740D54
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 15:19:19 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 1/6] man: encode minushyphen the way groff/man requires it
Date:   Tue, 24 Oct 2023 15:19:14 +0200
Message-ID: <20231024131919.28665-1-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sparked by a recent LWN article[1], I made a sweep over the iptables
manpages for incorrectly encoded dashes.

If the output is supposed to be a U+002D character (which is the case
for options and everything that is going to be copy-and-pasted), \-
must be used.

[1] https://lwn.net/Articles/947941/ (paywalled until about 2023-11-06)
---
 extensions/libip6t_DNPT.man     |  2 +-
 extensions/libip6t_REJECT.man   |  7 ++++---
 extensions/libip6t_SNPT.man     |  2 +-
 extensions/libipt_REJECT.man    |  7 ++++---
 extensions/libxt_CT.man         |  4 ++--
 extensions/libxt_HMARK.man      |  2 +-
 extensions/libxt_LED.man        |  4 ++--
 extensions/libxt_MASQUERADE.man |  4 ++--
 extensions/libxt_NFLOG.man      |  2 +-
 extensions/libxt_NFQUEUE.man    |  9 +++++----
 extensions/libxt_SET.man        |  2 +-
 extensions/libxt_SNAT.man       |  2 +-
 extensions/libxt_SYNPROXY.man   |  2 +-
 extensions/libxt_TRACE.man      |  4 ++--
 extensions/libxt_bpf.man        |  8 ++++----
 extensions/libxt_cgroup.man     |  2 +-
 extensions/libxt_cluster.man    |  8 ++++----
 extensions/libxt_connlabel.man  | 10 +++++-----
 extensions/libxt_connlimit.man  |  2 +-
 extensions/libxt_hashlimit.man  |  4 ++--
 extensions/libxt_nfacct.man     |  2 +-
 extensions/libxt_osf.man        |  4 ++--
 extensions/libxt_owner.man      |  2 +-
 extensions/libxt_socket.man     |  2 +-
 24 files changed, 50 insertions(+), 47 deletions(-)

diff --git a/extensions/libip6t_DNPT.man b/extensions/libip6t_DNPT.man
index 9b060f5b..a9c06700 100644
--- a/extensions/libip6t_DNPT.man
+++ b/extensions/libip6t_DNPT.man
@@ -19,7 +19,7 @@ ip6tables \-t mangle \-I POSTROUTING \-s fd00::/64 \! \-o vboxnet0
 \-j SNPT \-\-src-pfx fd00::/64 \-\-dst-pfx 2001:e20:2000:40f::/64
 .IP
 ip6tables \-t mangle \-I PREROUTING \-i wlan0 \-d 2001:e20:2000:40f::/64
-\-j DNPT \-\-src-pfx 2001:e20:2000:40f::/64 \-\-dst-pfx fd00::/64
+\-j DNPT \-\-src-pfx 2001:e20:2000:40f::/64 \-\-dst\-pfx fd00::/64
 .PP
 You may need to enable IPv6 neighbor proxy:
 .IP
diff --git a/extensions/libip6t_REJECT.man b/extensions/libip6t_REJECT.man
index 3c42768e..e68d6f03 100644
--- a/extensions/libip6t_REJECT.man
+++ b/extensions/libip6t_REJECT.man
@@ -44,9 +44,10 @@ response for a packet so classed would then terminate the healthy connection.
 .PP
 So, instead of:
 .PP
--A INPUT ... -j REJECT
+\-A INPUT ... \-j REJECT
 .PP
 do consider using:
 .PP
--A INPUT ... -m conntrack --ctstate INVALID -j DROP
--A INPUT ... -j REJECT
+\-A INPUT ... \-m conntrack \-\-ctstate INVALID \-j DROP
+.br
+\-A INPUT ... \-j REJECT
diff --git a/extensions/libip6t_SNPT.man b/extensions/libip6t_SNPT.man
index 97e0071b..1185d9c0 100644
--- a/extensions/libip6t_SNPT.man
+++ b/extensions/libip6t_SNPT.man
@@ -19,7 +19,7 @@ ip6tables \-t mangle \-I POSTROUTING \-s fd00::/64 \! \-o vboxnet0
 \-j SNPT \-\-src-pfx fd00::/64 \-\-dst-pfx 2001:e20:2000:40f::/64
 .IP
 ip6tables \-t mangle \-I PREROUTING \-i wlan0 \-d 2001:e20:2000:40f::/64
-\-j DNPT \-\-src-pfx 2001:e20:2000:40f::/64 \-\-dst-pfx fd00::/64
+\-j DNPT \-\-src-pfx 2001:e20:2000:40f::/64 \-\-dst\-pfx fd00::/64
 .PP
 You may need to enable IPv6 neighbor proxy:
 .IP
diff --git a/extensions/libipt_REJECT.man b/extensions/libipt_REJECT.man
index cc47aead..a7196cdc 100644
--- a/extensions/libipt_REJECT.man
+++ b/extensions/libipt_REJECT.man
@@ -44,9 +44,10 @@ response for a packet so classed would then terminate the healthy connection.
 .PP
 So, instead of:
 .PP
--A INPUT ... -j REJECT
+\-A INPUT ... \-j REJECT
 .PP
 do consider using:
 .PP
--A INPUT ... -m conntrack --ctstate INVALID -j DROP
--A INPUT ... -j REJECT
+\-A INPUT ... \-m conntrack \-\-ctstate INVALID \-j DROP
+.br
+\-A INPUT ... \-j REJECT
diff --git a/extensions/libxt_CT.man b/extensions/libxt_CT.man
index fc692f9a..7523ead4 100644
--- a/extensions/libxt_CT.man
+++ b/extensions/libxt_CT.man
@@ -20,12 +20,12 @@ the ctmark, not nfmark), \fBnatseqinfo\fP, \fBsecmark\fP (ctsecmark).
 Only generate the specified expectation events for this connection.
 Possible event types are: \fBnew\fP.
 .TP
-\fB\-\-zone-orig\fP {\fIid\fP|\fBmark\fP}
+\fB\-\-zone\-orig\fP {\fIid\fP|\fBmark\fP}
 For traffic coming from ORIGINAL direction, assign this packet to zone
 \fIid\fP and only have lookups done in that zone. If \fBmark\fP is used
 instead of \fIid\fP, the zone is derived from the packet nfmark.
 .TP
-\fB\-\-zone-reply\fP {\fIid\fP|\fBmark\fP}
+\fB\-\-zone\-reply\fP {\fIid\fP|\fBmark\fP}
 For traffic coming from REPLY direction, assign this packet to zone
 \fIid\fP and only have lookups done in that zone. If \fBmark\fP is used
 instead of \fIid\fP, the zone is derived from the packet nfmark.
diff --git a/extensions/libxt_HMARK.man b/extensions/libxt_HMARK.man
index cd7ffd54..63d18cb5 100644
--- a/extensions/libxt_HMARK.man
+++ b/extensions/libxt_HMARK.man
@@ -53,7 +53,7 @@ A 32 bit random custom value to feed hash calculation.
 \fIExamples:\fP
 .PP
 iptables \-t mangle \-A PREROUTING \-m conntrack \-\-ctstate NEW
- \-j HMARK \-\-hmark-tuple ct,src,dst,proto \-\-hmark-offset 10000
+ \-j HMARK \-\-hmark-tuple ct,src,dst,proto \-\-hmark\-offset 10000
 \-\-hmark\-mod 10 \-\-hmark\-rnd 0xfeedcafe
 .PP
 iptables \-t mangle \-A PREROUTING \-j HMARK \-\-hmark\-offset 10000
diff --git a/extensions/libxt_LED.man b/extensions/libxt_LED.man
index 81c2f296..d92fd940 100644
--- a/extensions/libxt_LED.man
+++ b/extensions/libxt_LED.man
@@ -6,9 +6,9 @@ the trigger behavior:
 .TP
 \fB\-\-led\-trigger\-id\fP \fIname\fP
 This is the name given to the LED trigger. The actual name of the trigger
-will be prefixed with "netfilter-".
+will be prefixed with "netfilter\-".
 .TP
-\fB\-\-led-delay\fP \fIms\fP
+\fB\-\-led\-delay\fP \fIms\fP
 This indicates how long (in milliseconds) the LED should be left illuminated
 when a packet arrives before being switched off again. The default is 0
 (blink as fast as possible.) The special value \fIinf\fP can be given to
diff --git a/extensions/libxt_MASQUERADE.man b/extensions/libxt_MASQUERADE.man
index 26d91ddb..e2009086 100644
--- a/extensions/libxt_MASQUERADE.man
+++ b/extensions/libxt_MASQUERADE.man
@@ -21,9 +21,9 @@ if the rule also specifies one of the following protocols:
 .TP
 \fB\-\-random\fP
 Randomize source port mapping (kernel >= 2.6.21).
-Since kernel 5.0, \fB\-\-random\fP is identical to \fB\-\-random-fully\fP.
+Since kernel 5.0, \fB\-\-random\fP is identical to \fB\-\-random\-fully\fP.
 .TP
-\fB\-\-random-fully\fP
+\fB\-\-random\-fully\fP
 Fully randomize source port mapping (kernel >= 3.13).
 .TP
 IPv6 support available since Linux kernels >= 3.7.
diff --git a/extensions/libxt_NFLOG.man b/extensions/libxt_NFLOG.man
index 318e6305..99f1b66d 100644
--- a/extensions/libxt_NFLOG.man
+++ b/extensions/libxt_NFLOG.man
@@ -17,7 +17,7 @@ A prefix string to include in the log message, up to 64 characters
 long, useful for distinguishing messages in the logs.
 .TP
 \fB\-\-nflog\-range\fP \fIsize\fP
-This option has never worked, use --nflog-size instead
+This option has never worked, use \-\-nflog\-size instead
 .TP
 \fB\-\-nflog\-size\fP \fIsize\fP
 The number of bytes to be copied to userspace (only applicable for
diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index 950b0d24..5126609d 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -6,7 +6,8 @@ reinject the packet into the kernel.  Please see libnetfilter_queue
 for details.
 .B
 nfnetlink_queue
-was added in Linux 2.6.14. The \fBqueue-balance\fP option was added in Linux 2.6.31,
+was added in Linux 2.6.14. The \fBqueue\-balance\fP option was added in Linux
+2.6.31,
 \fBqueue-bypass\fP in 2.6.39.
 .TP
 \fB\-\-queue\-num\fP \fIvalue\fP
@@ -28,8 +29,8 @@ are dropped.  When this option is used, the NFQUEUE rule behaves like ACCEPT ins
 will move on to the next table.
 .PP
 .TP
-\fB\-\-queue\-cpu-fanout\fP
+\fB\-\-queue\-cpu\-fanout\fP
 Available starting Linux kernel 3.10. When used together with
-\fB--queue-balance\fP this will use the CPU ID as an index to map packets to
+\fB\-\-queue\-balance\fP this will use the CPU ID as an index to map packets to
 the queues. The idea is that you can improve performance if there's a queue
-per CPU. This requires \fB--queue-balance\fP to be specified.
+per CPU. This requires \fB\-\-queue\-balance\fP to be specified.
diff --git a/extensions/libxt_SET.man b/extensions/libxt_SET.man
index c4713378..037969ea 100644
--- a/extensions/libxt_SET.man
+++ b/extensions/libxt_SET.man
@@ -26,7 +26,7 @@ when adding an entry if it already exists, reset the timeout value
 to the specified one or to the default from the set definition
 .TP
 \fB\-\-map\-set\fP \fIset\-name\fP
-the set-name should be created with --skbinfo option
+the set-name should be created with \-\-skbinfo option
 \fB\-\-map\-mark\fP
 map firewall mark to packet by lookup of value in the set
 \fB\-\-map\-prio\fP
diff --git a/extensions/libxt_SNAT.man b/extensions/libxt_SNAT.man
index 80a698a6..d879c871 100644
--- a/extensions/libxt_SNAT.man
+++ b/extensions/libxt_SNAT.man
@@ -23,7 +23,7 @@ will be mapped to ports below 1024, and other ports will be mapped to
 \fB\-\-random\fP
 Randomize source port mapping through a hash-based algorithm (kernel >= 2.6.21).
 .TP
-\fB\-\-random-fully\fP
+\fB\-\-random\-fully\fP
 Fully randomize source port mapping through a PRNG (kernel >= 3.14).
 .TP
 \fB\-\-persistent\fP
diff --git a/extensions/libxt_SYNPROXY.man b/extensions/libxt_SYNPROXY.man
index 30a71ed2..521a1d28 100644
--- a/extensions/libxt_SYNPROXY.man
+++ b/extensions/libxt_SYNPROXY.man
@@ -22,7 +22,7 @@ Example:
 .PP
 Determine tcp options used by backend, from an external system
 .IP
-tcpdump -pni eth0 -c 1 'tcp[tcpflags] == (tcp-syn|tcp-ack)'
+tcpdump \-pni eth0 -c 1 'tcp[tcpflags] == (tcp\-syn|tcp\-ack)'
 .br
     port 80 &
 .br
diff --git a/extensions/libxt_TRACE.man b/extensions/libxt_TRACE.man
index 5187a8d2..9cfa2711 100644
--- a/extensions/libxt_TRACE.man
+++ b/extensions/libxt_TRACE.man
@@ -15,6 +15,6 @@ With iptables-nft, the target is translated into nftables'
 .B "meta nftrace"
 expression. Hence the kernel sends trace events via netlink to userspace where
 they may be displayed using
-.B "xtables-monitor --trace"
+.B "xtables\-monitor \-\-trace"
 command. For details, refer to
-.BR xtables-monitor (8).
+.BR xtables\-monitor (8).
diff --git a/extensions/libxt_bpf.man b/extensions/libxt_bpf.man
index d6da2043..b79c21db 100644
--- a/extensions/libxt_bpf.man
+++ b/extensions/libxt_bpf.man
@@ -28,7 +28,7 @@ without the comments or trailing whitespace:
 .IP
 4               # number of instructions
 .br
-48 0 0 9        # load byte  ip->proto
+48 0 0 9        # load byte  ip\->proto
 .br
 21 0 1 6        # jump equal IPPROTO_TCP
 .br
@@ -44,7 +44,7 @@ Or instead, you can invoke the nfbpf_compile utility.
 .IP
 iptables \-A OUTPUT \-m bpf \-\-bytecode "`nfbpf_compile RAW 'ip proto 6'`" \-j ACCEPT
 .PP
-Or use tcpdump -ddd. In that case, generate BPF targeting a device with the
+Or use tcpdump \-ddd. In that case, generate BPF targeting a device with the
 same data link type as the xtables match. Iptables passes packets from the
 network layer up, without mac layer. Select a device with data link type RAW,
 such as a tun device:
@@ -53,8 +53,8 @@ ip tuntap add tun0 mode tun
 .br
 ip link set tun0 up
 .br
-tcpdump -ddd -i tun0 ip proto 6
+tcpdump \-ddd \-i tun0 ip proto 6
 .PP
-See tcpdump -L -i $dev for a list of known data link types for a given device.
+See tcpdump \-L \-i $dev for a list of known data link types for a given device.
 .PP
 You may want to learn more about BPF from FreeBSD's bpf(4) manpage.
diff --git a/extensions/libxt_cgroup.man b/extensions/libxt_cgroup.man
index 4d5d1d86..140afb48 100644
--- a/extensions/libxt_cgroup.man
+++ b/extensions/libxt_cgroup.man
@@ -15,7 +15,7 @@ option and \-\-path can't be used together.
 .PP
 Example:
 .IP
-iptables \-A OUTPUT \-p tcp \-\-sport 80 \-m cgroup ! \-\-path service/http-server \-j DROP
+iptables \-A OUTPUT \-p tcp \-\-sport 80 \-m cgroup ! \-\-path service/http\-server \-j DROP
 .IP
 iptables \-A OUTPUT \-p tcp \-\-sport 80 \-m cgroup ! \-\-cgroup 1
 \-j DROP
diff --git a/extensions/libxt_cluster.man b/extensions/libxt_cluster.man
index 23448e26..63054471 100644
--- a/extensions/libxt_cluster.man
+++ b/extensions/libxt_cluster.man
@@ -22,7 +22,7 @@ Example:
 iptables \-A PREROUTING \-t mangle \-i eth1 \-m cluster
 \-\-cluster\-total\-nodes 2 \-\-cluster\-local\-node 1
 \-\-cluster\-hash\-seed 0xdeadbeef
-\-j MARK \-\-set-mark 0xffff
+\-j MARK \-\-set\-mark 0xffff
 .IP
 iptables \-A PREROUTING \-t mangle \-i eth2 \-m cluster
 \-\-cluster\-total\-nodes 2 \-\-cluster\-local\-node 1
@@ -42,10 +42,10 @@ ip maddr add 01:00:5e:00:01:01 dev eth1
 ip maddr add 01:00:5e:00:01:02 dev eth2
 .IP
 arptables \-A OUTPUT \-o eth1 \-\-h\-length 6
-\-j mangle \-\-mangle-mac-s 01:00:5e:00:01:01
+\-j mangle \-\-mangle\-mac\-s 01:00:5e:00:01:01
 .IP
-arptables \-A INPUT \-i eth1 \-\-h-length 6
-\-\-destination-mac 01:00:5e:00:01:01
+arptables \-A INPUT \-i eth1 \-\-h\-length 6
+\-\-destination\-mac 01:00:5e:00:01:01
 \-j mangle \-\-mangle\-mac\-d 00:zz:yy:xx:5a:27
 .IP
 arptables \-A OUTPUT \-o eth2 \-\-h\-length 6
diff --git a/extensions/libxt_connlabel.man b/extensions/libxt_connlabel.man
index bdaa51e8..7ce18cf5 100644
--- a/extensions/libxt_connlabel.man
+++ b/extensions/libxt_connlabel.man
@@ -23,11 +23,11 @@ Label translation is done via the \fB/etc/xtables/connlabel.conf\fP configuratio
 Example:
 .IP
 .nf
-0	eth0-in
-1	eth0-out
-2	ppp-in
-3	ppp-out
-4	bulk-traffic
+0	eth0\-in
+1	eth0\-out
+2	ppp\-in
+3	ppp\-out
+4	bulk\-traffic
 5	interactive
 .fi
 .PP
diff --git a/extensions/libxt_connlimit.man b/extensions/libxt_connlimit.man
index ad9f40fa..2292e9cc 100644
--- a/extensions/libxt_connlimit.man
+++ b/extensions/libxt_connlimit.man
@@ -39,4 +39,4 @@ ip6tables \-p tcp \-\-syn \-\-dport 80 \-s fe80::/64 \-m connlimit \-\-connlimit
 .TP
 # Limit the number of connections to a particular host:
 ip6tables \-p tcp \-\-syn \-\-dport 49152:65535 \-d 2001:db8::1 \-m connlimit
-\-\-connlimit-above 100 \-j REJECT
+\-\-connlimit\-above 100 \-j REJECT
diff --git a/extensions/libxt_hashlimit.man b/extensions/libxt_hashlimit.man
index 8a35d564..627fcd0a 100644
--- a/extensions/libxt_hashlimit.man
+++ b/extensions/libxt_hashlimit.man
@@ -77,8 +77,8 @@ in 10.0.0.0/8" =>
 .TP
 matching bytes per second
 "flows exceeding 512kbyte/s" =>
-\-\-hashlimit-mode srcip,dstip,srcport,dstport \-\-hashlimit\-above 512kb/s
+\-\-hashlimit\-mode srcip,dstip,srcport,dstport \-\-hashlimit\-above 512kb/s
 .TP
 matching bytes per second
 "hosts that exceed 512kbyte/s, but permit up to 1Megabytes without matching"
-\-\-hashlimit-mode dstip \-\-hashlimit\-above 512kb/s \-\-hashlimit-burst 1mb
+\-\-hashlimit\-mode dstip \-\-hashlimit\-above 512kb/s \-\-hashlimit\-burst 1mb
diff --git a/extensions/libxt_nfacct.man b/extensions/libxt_nfacct.man
index a818fedd..4e05891e 100644
--- a/extensions/libxt_nfacct.man
+++ b/extensions/libxt_nfacct.man
@@ -22,7 +22,7 @@ Then, you can check for the amount of traffic that the rules match:
 .IP
 nfacct get http\-traffic
 .IP
-{ pkts = 00000000000000000156, bytes = 00000000000000151786 } = http-traffic;
+{ pkts = 00000000000000000156, bytes = 00000000000000151786 } = http\-traffic;
 .PP
 You can obtain
 .B nfacct(8)
diff --git a/extensions/libxt_osf.man b/extensions/libxt_osf.man
index 41103f29..e68440f5 100644
--- a/extensions/libxt_osf.man
+++ b/extensions/libxt_osf.man
@@ -29,7 +29,7 @@ Log determined genres into dmesg even if they do not match the desired one.
 .PP
 You may find something like this in syslog:
 .PP
-Windows [2000:SP3:Windows XP Pro SP1, 2000 SP3]: 11.22.33.55:4024 ->
+Windows [2000:SP3:Windows XP Pro SP1, 2000 SP3]: 11.22.33.55:4024 \->
 11.22.33.44:139 hops=3 Linux [2.5-2.6:] : 1.2.3.4:42624 -> 1.2.3.5:22 hops=4
 .PP
 OS fingerprints are loadable using the \fBnfnl_osf\fP program. To load
@@ -42,4 +42,4 @@ To remove them again,
 \fBnfnl_osf \-f /usr/share/xtables/pf.os \-d\fP
 .PP
 The fingerprint database can be downloaded from
-http://www.openbsd.org/cgi-bin/cvsweb/src/etc/pf.os .
+http://www.openbsd.org/cgi\-bin/cvsweb/src/etc/pf.os .
diff --git a/extensions/libxt_owner.man b/extensions/libxt_owner.man
index e2479865..fd6fe190 100644
--- a/extensions/libxt_owner.man
+++ b/extensions/libxt_owner.man
@@ -16,7 +16,7 @@ Matches if the packet socket's file structure is owned by the given group.
 You may also specify a numerical GID, or a GID range.
 .TP
 \fB\-\-suppl\-groups\fP
-Causes group(s) specified with \fB\-\-gid-owner\fP to be also checked in the
+Causes group(s) specified with \fB\-\-gid\-owner\fP to be also checked in the
 supplementary groups of a process.
 .TP
 [\fB!\fP] \fB\-\-socket\-exists\fP
diff --git a/extensions/libxt_socket.man b/extensions/libxt_socket.man
index f809df69..a268b443 100644
--- a/extensions/libxt_socket.man
+++ b/extensions/libxt_socket.man
@@ -29,7 +29,7 @@ to be matched when restoring the packet mark.
 Example: An application opens 2 transparent (\fBIP_TRANSPARENT\fP) sockets and
 sets a mark on them with \fBSO_MARK\fP socket option. We can filter matching packets:
 .IP
-\-t mangle \-I PREROUTING \-m socket \-\-transparent \-\-restore-skmark \-j action
+\-t mangle \-I PREROUTING \-m socket \-\-transparent \-\-restore\-skmark \-j action
 .IP
 \-t mangle \-A action \-m mark \-\-mark 10 \-j action2
 .IP
-- 
2.42.0

