From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables] tests: add regression tests for xtables-translate
Date: Fri, 31 Mar 2017 14:34:38 +0200
Message-ID: <20170331123438.29573-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34604 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933209AbdCaMf6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2017 08:35:58 -0400
Received: by mail-wr0-f193.google.com with SMTP id w43so20292601wrb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2017 05:35:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This test suite is intended to detect regressions in the translation
infrastructure. The script checks if ip[6]tables-translate produces the
expected output, otherwise it prints the wrong translation and the
expected one.

** Arguments

  --all     # Show also passed tests
  [test]    # Run only the specified test file

** Test files structure

Test files are located under extensions directory. Every file contains
tests about specific extension translations. A test file name must end
with ".txlate".

Inside the files, every single test is defined by two consecutive lines:
ip[6]tables-translate command and expected result. One blank line is left
between tests by convention.

e.g.

  $ cat extensions/libxt_cpu.txlate
  iptables-translate -A INPUT -p tcp --dport 80 -m cpu --cpu 0 -j ACCEPT
  nft add rule ip filter INPUT tcp dport 80 cpu 0 counter accept

  iptables-translate -A INPUT -p tcp --dport 80 -m cpu ! --cpu 1 -j ACCEPT
  nft add rule ip filter INPUT tcp dport 80 cpu != 1 counter accept

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 extensions/generic.txlate            |  5 +++
 extensions/libip6t_DNAT.txlate       | 11 +++++
 extensions/libip6t_LOG.txlate        |  8 ++++
 extensions/libip6t_MASQUERADE.txlate |  8 ++++
 extensions/libip6t_REDIRECT.txlate   |  5 +++
 extensions/libip6t_REJECT.txlate     |  8 ++++
 extensions/libip6t_SNAT.txlate       | 11 +++++
 extensions/libip6t_ah.txlate         | 17 ++++++++
 extensions/libip6t_frag.txlate       | 17 ++++++++
 extensions/libip6t_hbh.txlate        |  5 +++
 extensions/libip6t_hl.txlate         |  5 +++
 extensions/libip6t_icmp6.txlate      |  8 ++++
 extensions/libip6t_mh.txlate         |  5 +++
 extensions/libip6t_rt.txlate         | 14 ++++++
 extensions/libipt_DNAT.txlate        | 14 ++++++
 extensions/libipt_LOG.txlate         |  5 +++
 extensions/libipt_MASQUERADE.txlate  |  8 ++++
 extensions/libipt_REDIRECT.txlate    |  5 +++
 extensions/libipt_REJECT.txlate      |  8 ++++
 extensions/libipt_SNAT.txlate        | 14 ++++++
 extensions/libipt_ah.txlate          |  8 ++++
 extensions/libipt_icmp.txlate        |  8 ++++
 extensions/libipt_realm.txlate       | 11 +++++
 extensions/libipt_ttl.txlate         |  5 +++
 extensions/libxt_CLASSIFY.txlate     |  8 ++++
 extensions/libxt_CONNMARK.txlate     | 23 ++++++++++
 extensions/libxt_DSCP.txlate         |  5 +++
 extensions/libxt_MARK.txlate         | 23 ++++++++++
 extensions/libxt_NFLOG.txlate        | 14 ++++++
 extensions/libxt_NFQUEUE.txlate      |  8 ++++
 extensions/libxt_TEE.txlate          | 11 +++++
 extensions/libxt_TRACE.txlate        |  2 +
 extensions/libxt_addrtype.txlate     | 11 +++++
 extensions/libxt_cgroup.txlate       |  5 +++
 extensions/libxt_comment.txlate      |  8 ++++
 extensions/libxt_connbytes.txlate    | 14 ++++++
 extensions/libxt_connlabel.txlate    |  5 +++
 extensions/libxt_connmark.txlate     | 14 ++++++
 extensions/libxt_conntrack.txlate    | 41 +++++++++++++++++
 extensions/libxt_cpu.txlate          |  5 +++
 extensions/libxt_dccp.txlate         | 14 ++++++
 extensions/libxt_devgroup.txlate     | 17 ++++++++
 extensions/libxt_dscp.txlate         |  5 +++
 extensions/libxt_ecn.txlate          | 23 ++++++++++
 extensions/libxt_esp.txlate          | 11 +++++
 extensions/libxt_hashlimit.txlate    |  5 +++
 extensions/libxt_helper.txlate       |  5 +++
 extensions/libxt_ipcomp.txlate       |  5 +++
 extensions/libxt_iprange.txlate      | 14 ++++++
 extensions/libxt_length.txlate       | 11 +++++
 extensions/libxt_limit.txlate        |  8 ++++
 extensions/libxt_mac.txlate          |  5 +++
 extensions/libxt_mark.txlate         |  5 +++
 extensions/libxt_multiport.txlate    | 11 +++++
 extensions/libxt_owner.txlate        |  8 ++++
 extensions/libxt_pkttype.txlate      |  8 ++++
 extensions/libxt_quota.txlate        |  5 +++
 extensions/libxt_rpfilter.txlate     |  8 ++++
 extensions/libxt_sctp.txlate         | 38 ++++++++++++++++
 extensions/libxt_statistic.txlate    |  8 ++++
 extensions/libxt_tcp.txlate          | 20 +++++++++
 extensions/libxt_udp.txlate          | 11 +++++
 xlate-test.py                        | 85 ++++++++++++++++++++++++++++++++++++
 63 files changed, 740 insertions(+)
 create mode 100644 extensions/generic.txlate
 create mode 100644 extensions/libip6t_DNAT.txlate
 create mode 100644 extensions/libip6t_LOG.txlate
 create mode 100644 extensions/libip6t_MASQUERADE.txlate
 create mode 100644 extensions/libip6t_REDIRECT.txlate
 create mode 100644 extensions/libip6t_REJECT.txlate
 create mode 100644 extensions/libip6t_SNAT.txlate
 create mode 100644 extensions/libip6t_ah.txlate
 create mode 100644 extensions/libip6t_frag.txlate
 create mode 100644 extensions/libip6t_hbh.txlate
 create mode 100644 extensions/libip6t_hl.txlate
 create mode 100644 extensions/libip6t_icmp6.txlate
 create mode 100644 extensions/libip6t_mh.txlate
 create mode 100644 extensions/libip6t_rt.txlate
 create mode 100644 extensions/libipt_DNAT.txlate
 create mode 100644 extensions/libipt_LOG.txlate
 create mode 100644 extensions/libipt_MASQUERADE.txlate
 create mode 100644 extensions/libipt_REDIRECT.txlate
 create mode 100644 extensions/libipt_REJECT.txlate
 create mode 100644 extensions/libipt_SNAT.txlate
 create mode 100644 extensions/libipt_ah.txlate
 create mode 100644 extensions/libipt_icmp.txlate
 create mode 100644 extensions/libipt_realm.txlate
 create mode 100644 extensions/libipt_ttl.txlate
 create mode 100644 extensions/libxt_CLASSIFY.txlate
 create mode 100644 extensions/libxt_CONNMARK.txlate
 create mode 100644 extensions/libxt_DSCP.txlate
 create mode 100644 extensions/libxt_MARK.txlate
 create mode 100644 extensions/libxt_NFLOG.txlate
 create mode 100644 extensions/libxt_NFQUEUE.txlate
 create mode 100644 extensions/libxt_TEE.txlate
 create mode 100644 extensions/libxt_TRACE.txlate
 create mode 100644 extensions/libxt_addrtype.txlate
 create mode 100644 extensions/libxt_cgroup.txlate
 create mode 100644 extensions/libxt_comment.txlate
 create mode 100644 extensions/libxt_connbytes.txlate
 create mode 100644 extensions/libxt_connlabel.txlate
 create mode 100644 extensions/libxt_connmark.txlate
 create mode 100644 extensions/libxt_conntrack.txlate
 create mode 100644 extensions/libxt_cpu.txlate
 create mode 100644 extensions/libxt_dccp.txlate
 create mode 100644 extensions/libxt_devgroup.txlate
 create mode 100644 extensions/libxt_dscp.txlate
 create mode 100644 extensions/libxt_ecn.txlate
 create mode 100644 extensions/libxt_esp.txlate
 create mode 100644 extensions/libxt_hashlimit.txlate
 create mode 100644 extensions/libxt_helper.txlate
 create mode 100644 extensions/libxt_ipcomp.txlate
 create mode 100644 extensions/libxt_iprange.txlate
 create mode 100644 extensions/libxt_length.txlate
 create mode 100644 extensions/libxt_limit.txlate
 create mode 100644 extensions/libxt_mac.txlate
 create mode 100644 extensions/libxt_mark.txlate
 create mode 100644 extensions/libxt_multiport.txlate
 create mode 100644 extensions/libxt_owner.txlate
 create mode 100644 extensions/libxt_pkttype.txlate
 create mode 100644 extensions/libxt_quota.txlate
 create mode 100644 extensions/libxt_rpfilter.txlate
 create mode 100644 extensions/libxt_sctp.txlate
 create mode 100644 extensions/libxt_statistic.txlate
 create mode 100644 extensions/libxt_tcp.txlate
 create mode 100644 extensions/libxt_udp.txlate
 create mode 100755 xlate-test.py

diff --git a/extensions/generic.txlate b/extensions/generic.txlate
new file mode 100644
index 00000000..1140bb89
--- /dev/null
+++ b/extensions/generic.txlate
@@ -0,0 +1,5 @@
+iptables-translate -I OUTPUT -p udp -d 8.8.8.8 -j ACCEPT
+nft insert rule ip filter OUTPUT ip protocol udp ip daddr 8.8.8.8 counter accept
+
+iptables-translate -F -t nat
+nft flush table ip nat
diff --git a/extensions/libip6t_DNAT.txlate b/extensions/libip6t_DNAT.txlate
new file mode 100644
index 00000000..fe26075d
--- /dev/null
+++ b/extensions/libip6t_DNAT.txlate
@@ -0,0 +1,11 @@
+ip6tables-translate -t nat -A prerouting -i eth1 -p tcp --dport 8080 -j DNAT --to-destination [fec0::1234]:80
+nft add rule ip6 nat prerouting iifname eth1 tcp dport 8080 counter dnat to [fec0::1234]:80
+
+ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:1-20
+nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:1-20
+
+ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:80 --persistent
+nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:80 persistent
+
+ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:80 --random --persistent
+nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:80 random,persistent
diff --git a/extensions/libip6t_LOG.txlate b/extensions/libip6t_LOG.txlate
new file mode 100644
index 00000000..2820a82c
--- /dev/null
+++ b/extensions/libip6t_LOG.txlate
@@ -0,0 +1,8 @@
+iptables-translate -I INPUT -j LOG
+nft insert rule ip filter INPUT counter log
+
+ip6tables-translate -A FORWARD -p tcp -j LOG --log-level debug
+nft add rule ip6 filter FORWARD meta l4proto tcp counter log level debug
+
+ip6tables-translate -A FORWARD -p tcp -j LOG --log-prefix "Checking log"
+nft add rule ip6 filter FORWARD meta l4proto tcp counter log prefix \"Checking log\"
diff --git a/extensions/libip6t_MASQUERADE.txlate b/extensions/libip6t_MASQUERADE.txlate
new file mode 100644
index 00000000..6c289c2b
--- /dev/null
+++ b/extensions/libip6t_MASQUERADE.txlate
@@ -0,0 +1,8 @@
+ip6tables-translate -t nat -A POSTROUTING -j MASQUERADE
+nft add rule ip6 nat POSTROUTING counter masquerade
+
+ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10
+nft add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade to :10
+
+ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10-20 --random
+nft add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade to :10-20 random
diff --git a/extensions/libip6t_REDIRECT.txlate b/extensions/libip6t_REDIRECT.txlate
new file mode 100644
index 00000000..209f67a4
--- /dev/null
+++ b/extensions/libip6t_REDIRECT.txlate
@@ -0,0 +1,5 @@
+ip6tables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080
+nft add rule ip6 nat prerouting tcp dport 80 counter redirect to :8080
+
+ip6tables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080 --random
+nft add rule ip6 nat prerouting tcp dport 80 counter redirect to :8080 random
diff --git a/extensions/libip6t_REJECT.txlate b/extensions/libip6t_REJECT.txlate
new file mode 100644
index 00000000..cfa35ebf
--- /dev/null
+++ b/extensions/libip6t_REJECT.txlate
@@ -0,0 +1,8 @@
+ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT
+nft add rule ip6 filter FORWARD tcp dport 22 counter reject
+
+ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with icmp6-reject-route
+nft add rule ip6 filter FORWARD tcp dport 22 counter reject with icmpv6 type reject-route
+
+ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with tcp-reset
+nft add rule ip6 filter FORWARD tcp dport 22 counter reject with tcp reset
diff --git a/extensions/libip6t_SNAT.txlate b/extensions/libip6t_SNAT.txlate
new file mode 100644
index 00000000..9793f8d5
--- /dev/null
+++ b/extensions/libip6t_SNAT.txlate
@@ -0,0 +1,11 @@
+ip6tables-translate -t nat -A postrouting -o eth0 -p tcp -j SNAT --to [fec0::1234]:80
+nft add rule ip6 nat postrouting oifname eth0 meta l4proto tcp counter snat to [fec0::1234]:80
+
+ip6tables-translate -t nat -A postrouting -o eth0 -p tcp -j SNAT --to [fec0::1234]:1-20
+nft add rule ip6 nat postrouting oifname eth0 meta l4proto tcp counter snat to [fec0::1234]:1-20
+
+ip6tables-translate -t nat -A postrouting -o eth0 -p tcp -j SNAT --to [fec0::1234]:123 --random
+nft add rule ip6 nat postrouting oifname eth0 meta l4proto tcp counter snat to [fec0::1234]:123 random
+
+ip6tables-translate -t nat -A postrouting -o eth0 -p tcp -j SNAT --to [fec0::1234]:123 --random-fully --persistent
+nft add rule ip6 nat postrouting oifname eth0 meta l4proto tcp counter snat to [fec0::1234]:123 fully-random,persistent
diff --git a/extensions/libip6t_ah.txlate b/extensions/libip6t_ah.txlate
new file mode 100644
index 00000000..c6b09a2e
--- /dev/null
+++ b/extensions/libip6t_ah.txlate
@@ -0,0 +1,17 @@
+ip6tables-translate -A INPUT -m ah --ahspi 500 -j DROP
+nft add rule ip6 filter INPUT ah spi 500 counter drop
+
+ip6tables-translate -A INPUT -m ah --ahspi 500:550 -j DROP
+nft add rule ip6 filter INPUT ah spi 500-550 counter drop
+
+ip6tables-translate -A INPUT -m ah ! --ahlen 120
+nft add rule ip6 filter INPUT ah hdrlength != 120 counter
+
+ip6tables-translate -A INPUT -m ah --ahres
+nft add rule ip6 filter INPUT ah reserved 1 counter
+
+ip6tables-translate -A INPUT -m ah --ahspi 500 ! --ahlen 120 -j DROP
+nft add rule ip6 filter INPUT ah spi 500 ah hdrlength != 120 counter drop
+
+ip6tables-translate -A INPUT -m ah --ahspi 500 --ahlen 120 --ahres -j ACCEPT
+nft add rule ip6 filter INPUT ah spi 500 ah hdrlength 120 ah reserved 1 counter accept
diff --git a/extensions/libip6t_frag.txlate b/extensions/libip6t_frag.txlate
new file mode 100644
index 00000000..e8bd9d4b
--- /dev/null
+++ b/extensions/libip6t_frag.txlate
@@ -0,0 +1,17 @@
+ip6tables-translate -t filter -A INPUT -m frag --fragid 100:200 -j ACCEPT
+nft add rule ip6 filter INPUT frag id 100-200 counter accept
+
+ip6tables-translate -t filter -A INPUT -m frag --fragid 100 --fragres --fragmore -j ACCEPT
+nft add rule ip6 filter INPUT frag id 100 frag reserved 1 frag more-fragments 1 counter accept
+
+ip6tables-translate -t filter -A INPUT -m frag ! --fragid 100:200 -j ACCEPT
+nft add rule ip6 filter INPUT frag id != 100-200 counter accept
+
+ip6tables-translate -t filter -A INPUT -m frag --fragid 100:200 --fraglast -j ACCEPT
+nft add rule ip6 filter INPUT frag id 100-200 frag more-fragments 0 counter accept
+
+ip6tables-translate -t filter -A INPUT -m frag --fragid 100:200 --fragfirst -j ACCEPT
+nft add rule ip6 filter INPUT frag id 100-200 frag frag-off 0 counter accept
+
+ip6tables-translate -t filter -A INPUT -m frag --fraglast -j ACCEPT
+nft add rule ip6 filter INPUT frag more-fragments 0 counter accept
diff --git a/extensions/libip6t_hbh.txlate b/extensions/libip6t_hbh.txlate
new file mode 100644
index 00000000..28101fd7
--- /dev/null
+++ b/extensions/libip6t_hbh.txlate
@@ -0,0 +1,5 @@
+ip6tables-translate -t filter -A INPUT -m hbh --hbh-len 22
+nft add rule ip6 filter INPUT hbh hdrlength 22 counter
+
+ip6tables-translate -t filter -A INPUT -m hbh ! --hbh-len 22
+nft add rule ip6 filter INPUT hbh hdrlength != 22 counter
diff --git a/extensions/libip6t_hl.txlate b/extensions/libip6t_hl.txlate
new file mode 100644
index 00000000..17563938
--- /dev/null
+++ b/extensions/libip6t_hl.txlate
@@ -0,0 +1,5 @@
+ip6tables-translate -t nat -A postrouting -m hl --hl-gt 3
+nft add rule ip6 nat postrouting ip6 hoplimit gt 3 counter
+
+ip6tables-translate -t nat -A postrouting -m hl ! --hl-eq 3
+nft add rule ip6 nat postrouting ip6 hoplimit != 3 counter
diff --git a/extensions/libip6t_icmp6.txlate b/extensions/libip6t_icmp6.txlate
new file mode 100644
index 00000000..15481ad6
--- /dev/null
+++ b/extensions/libip6t_icmp6.txlate
@@ -0,0 +1,8 @@
+ip6tables-translate -t filter -A INPUT -m icmp6 --icmpv6-type 1 -j LOG
+nft add rule ip6 filter INPUT icmpv6 type destination-unreachable counter log
+
+ip6tables-translate -t filter -A INPUT -m icmp6 --icmpv6-type neighbour-advertisement -j LOG
+nft add rule ip6 filter INPUT icmpv6 type nd-neighbor-advert counter log
+
+ip6tables-translate -t filter -A INPUT -m icmp6 ! --icmpv6-type packet-too-big -j LOG
+nft add rule ip6 filter INPUT icmpv6 type != packet-too-big counter log
diff --git a/extensions/libip6t_mh.txlate b/extensions/libip6t_mh.txlate
new file mode 100644
index 00000000..f5d638c0
--- /dev/null
+++ b/extensions/libip6t_mh.txlate
@@ -0,0 +1,5 @@
+ip6tables-translate -A INPUT -p mh --mh-type 1 -j ACCEPT
+nft add rule ip6 filter INPUT meta l4proto mobility-header mh type 1 counter accept
+
+ip6tables-translate -A INPUT -p mh --mh-type 1:3 -j ACCEPT
+nft add rule ip6 filter INPUT meta l4proto mobility-header mh type 1-3 counter accept
diff --git a/extensions/libip6t_rt.txlate b/extensions/libip6t_rt.txlate
new file mode 100644
index 00000000..6464cf9e
--- /dev/null
+++ b/extensions/libip6t_rt.txlate
@@ -0,0 +1,14 @@
+ip6tables-translate -A INPUT -m rt --rt-type 0 -j DROP
+nft add rule ip6 filter INPUT rt type 0 counter drop
+
+ip6tables-translate -A INPUT -m rt ! --rt-len 22 -j DROP
+nft add rule ip6 filter INPUT rt hdrlength != 22 counter drop
+
+ip6tables-translate -A INPUT -m rt --rt-segsleft 26 -j ACCEPT
+nft add rule ip6 filter INPUT rt seg-left 26 counter accept
+
+ip6tables-translate -A INPUT -m rt --rt-type 0 --rt-len 22 -j DROP
+nft add rule ip6 filter INPUT rt type 0 rt hdrlength 22 counter drop
+
+ip6tables-translate -A INPUT -m rt --rt-type 0 --rt-len 22 ! --rt-segsleft 26 -j ACCEPT
+nft add rule ip6 filter INPUT rt type 0 rt seg-left != 26 rt hdrlength 22 counter accept
diff --git a/extensions/libipt_DNAT.txlate b/extensions/libipt_DNAT.txlate
new file mode 100644
index 00000000..692358e2
--- /dev/null
+++ b/extensions/libipt_DNAT.txlate
@@ -0,0 +1,14 @@
+iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4
+nft add rule ip nat prerouting oifname eth0 ip protocol tcp counter dnat to 1.2.3.4
+
+iptables-translate -t nat -A prerouting -p tcp -d 15.45.23.67 --dport 80 -j DNAT --to-destination 192.168.1.1-192.168.1.10
+nft add rule ip nat prerouting ip daddr 15.45.23.67 tcp dport 80 counter dnat to 192.168.1.1-192.168.1.10
+
+iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4:1-1023
+nft add rule ip nat prerouting oifname eth0 ip protocol tcp counter dnat to 1.2.3.4:1-1023
+
+iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4 --random
+nft add rule ip nat prerouting oifname eth0 ip protocol tcp counter dnat to 1.2.3.4 random
+
+iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4 --random --persistent
+nft add rule ip nat prerouting oifname eth0 ip protocol tcp counter dnat to 1.2.3.4 random,persistent
diff --git a/extensions/libipt_LOG.txlate b/extensions/libipt_LOG.txlate
new file mode 100644
index 00000000..81f64fb2
--- /dev/null
+++ b/extensions/libipt_LOG.txlate
@@ -0,0 +1,5 @@
+iptables-translate -A FORWARD -p tcp -j LOG --log-level error
+nft add rule ip filter FORWARD ip protocol tcp counter log level err
+
+iptables-translate -A FORWARD -p tcp -j LOG --log-prefix "Random prefix"
+nft add rule ip filter FORWARD ip protocol tcp counter log prefix \"Random prefix\"
diff --git a/extensions/libipt_MASQUERADE.txlate b/extensions/libipt_MASQUERADE.txlate
new file mode 100644
index 00000000..40b6958a
--- /dev/null
+++ b/extensions/libipt_MASQUERADE.txlate
@@ -0,0 +1,8 @@
+iptables-translate -t nat -A POSTROUTING -j MASQUERADE
+nft add rule ip nat POSTROUTING counter masquerade
+
+iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10
+nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade to :10
+
+iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10-20 --random
+nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade to :10-20 random
diff --git a/extensions/libipt_REDIRECT.txlate b/extensions/libipt_REDIRECT.txlate
new file mode 100644
index 00000000..815bb771
--- /dev/null
+++ b/extensions/libipt_REDIRECT.txlate
@@ -0,0 +1,5 @@
+iptables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080
+nft add rule ip nat prerouting tcp dport 80 counter redirect to :8080
+
+iptables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080 --random
+nft add rule ip nat prerouting tcp dport 80 counter redirect to :8080 random
diff --git a/extensions/libipt_REJECT.txlate b/extensions/libipt_REJECT.txlate
new file mode 100644
index 00000000..a1bfb5f4
--- /dev/null
+++ b/extensions/libipt_REJECT.txlate
@@ -0,0 +1,8 @@
+iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT
+nft add rule ip filter FORWARD tcp dport 22 counter reject
+
+iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with icmp-net-unreachable
+nft add rule ip filter FORWARD tcp dport 22 counter reject with icmp type net-unreachable
+
+iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with tcp-reset
+nft add rule ip filter FORWARD tcp dport 22 counter reject with tcp reset
diff --git a/extensions/libipt_SNAT.txlate b/extensions/libipt_SNAT.txlate
new file mode 100644
index 00000000..4efd3ad0
--- /dev/null
+++ b/extensions/libipt_SNAT.txlate
@@ -0,0 +1,14 @@
+iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4
+nft add rule ip nat postrouting oifname eth0 counter snat to 1.2.3.4
+
+iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4-1.2.3.6
+nft add rule ip nat postrouting oifname eth0 counter snat to 1.2.3.4-1.2.3.6
+
+iptables-translate -t nat -A postrouting -p tcp -o eth0 -j SNAT --to 1.2.3.4:1-1023
+nft add rule ip nat postrouting oifname eth0 ip protocol tcp counter snat to 1.2.3.4:1-1023
+
+iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4 --random
+nft add rule ip nat postrouting oifname eth0 counter snat to 1.2.3.4 random
+
+iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4 --random --persistent
+nft add rule ip nat postrouting oifname eth0 counter snat to 1.2.3.4 random,persistent
diff --git a/extensions/libipt_ah.txlate b/extensions/libipt_ah.txlate
new file mode 100644
index 00000000..ea3ef3e9
--- /dev/null
+++ b/extensions/libipt_ah.txlate
@@ -0,0 +1,8 @@
+iptables-translate -A INPUT -p 51 -m ah --ahspi 500 -j DROP
+nft add rule ip filter INPUT ah spi 500 counter drop
+
+iptables-translate -A INPUT -p 51 -m ah --ahspi 500:600 -j DROP
+nft add rule ip filter INPUT ah spi 500-600 counter drop
+
+iptables-translate -A INPUT -p 51 -m ah ! --ahspi 50 -j DROP
+nft add rule ip filter INPUT ah spi != 50 counter drop
diff --git a/extensions/libipt_icmp.txlate b/extensions/libipt_icmp.txlate
new file mode 100644
index 00000000..434f8cc4
--- /dev/null
+++ b/extensions/libipt_icmp.txlate
@@ -0,0 +1,8 @@
+iptables-translate -t filter -A INPUT -m icmp --icmp-type echo-reply -j ACCEPT
+nft add rule ip filter INPUT icmp type echo-reply counter accept
+
+iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j ACCEPT
+nft add rule ip filter INPUT icmp type destination-unreachable counter accept
+
+iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j ACCEPT
+nft add rule ip filter INPUT icmp type != destination-unreachable counter accept
diff --git a/extensions/libipt_realm.txlate b/extensions/libipt_realm.txlate
new file mode 100644
index 00000000..7d710294
--- /dev/null
+++ b/extensions/libipt_realm.txlate
@@ -0,0 +1,11 @@
+iptables-translate -A PREROUTING -m realm --realm 4
+nft add rule ip filter PREROUTING rtclassid 0x4 counter
+
+iptables-translate -A PREROUTING -m realm --realm 5/5
+nft add rule ip filter PREROUTING rtclassid and 0x5 == 0x5 counter
+
+iptables-translate -A PREROUTING -m realm ! --realm 50
+nft add rule ip filter PREROUTING rtclassid != 0x32 counter
+
+iptables-translate -A INPUT -m realm --realm 1/0xf
+nft add rule ip filter INPUT rtclassid and 0xf == 0x1 counter
diff --git a/extensions/libipt_ttl.txlate b/extensions/libipt_ttl.txlate
new file mode 100644
index 00000000..3d5d6a70
--- /dev/null
+++ b/extensions/libipt_ttl.txlate
@@ -0,0 +1,5 @@
+iptables-translate -A INPUT -m ttl --ttl-eq 3 -j ACCEPT
+nft add rule ip filter INPUT ip ttl 3 counter accept
+
+iptables-translate -A INPUT -m ttl --ttl-gt 5 -j ACCEPT
+nft add rule ip filter INPUT ip ttl gt 5 counter accept
diff --git a/extensions/libxt_CLASSIFY.txlate b/extensions/libxt_CLASSIFY.txlate
new file mode 100644
index 00000000..3b349237
--- /dev/null
+++ b/extensions/libxt_CLASSIFY.txlate
@@ -0,0 +1,8 @@
+iptables-translate -A OUTPUT -j CLASSIFY --set-class 0:0
+nft add rule ip filter OUTPUT counter meta priority set none
+
+iptables-translate -A OUTPUT -j CLASSIFY --set-class ffff:ffff
+nft add rule ip filter OUTPUT counter meta priority set root
+
+iptables-translate -A OUTPUT -j CLASSIFY --set-class 1:234
+nft add rule ip filter OUTPUT counter meta priority set 1:234
diff --git a/extensions/libxt_CONNMARK.txlate b/extensions/libxt_CONNMARK.txlate
new file mode 100644
index 00000000..62321be1
--- /dev/null
+++ b/extensions/libxt_CONNMARK.txlate
@@ -0,0 +1,23 @@
+iptables-translate -t mangle -A PREROUTING -j CONNMARK --set-mark 0x16
+nft add rule ip mangle PREROUTING counter ct mark set 0x16
+
+iptables-translate -t mangle -A PREROUTING -j CONNMARK --set-xmark 0x16/0x12
+nft add rule ip mangle PREROUTING counter ct mark set ct mark xor 0x16 and 0xffffffed
+
+iptables-translate -t mangle -A PREROUTING -j CONNMARK --and-mark 0x16
+nft add rule ip mangle PREROUTING counter ct mark set ct mark and 0x16
+
+iptables-translate -t mangle -A PREROUTING -j CONNMARK --or-mark 0x16
+nft add rule ip mangle PREROUTING counter ct mark set ct mark or 0x16
+
+iptables-translate -t mangle -A PREROUTING -j CONNMARK --save-mark
+nft add rule ip mangle PREROUTING counter ct mark set mark
+
+iptables-translate -t mangle -A PREROUTING -j CONNMARK --save-mark --mask 0x12
+nft add rule ip mangle PREROUTING counter ct mark set mark and 0x12
+
+iptables-translate -t mangle -A PREROUTING -j CONNMARK --restore-mark
+nft add rule ip mangle PREROUTING counter meta mark set ct mark
+
+iptables-translate -t mangle -A PREROUTING -j CONNMARK --restore-mark --mask 0x12
+nft add rule ip mangle PREROUTING counter meta mark set ct mark and 0x12
diff --git a/extensions/libxt_DSCP.txlate b/extensions/libxt_DSCP.txlate
new file mode 100644
index 00000000..442742ef
--- /dev/null
+++ b/extensions/libxt_DSCP.txlate
@@ -0,0 +1,5 @@
+iptables-translate -A OUTPUT -j DSCP --set-dscp 1
+nft add rule ip filter OUTPUT counter ip dscp set 0x01
+
+ip6tables-translate -A OUTPUT -j DSCP --set-dscp 6
+nft add rule ip6 filter OUTPUT counter ip6 dscp set 0x06
diff --git a/extensions/libxt_MARK.txlate b/extensions/libxt_MARK.txlate
new file mode 100644
index 00000000..ab5977e9
--- /dev/null
+++ b/extensions/libxt_MARK.txlate
@@ -0,0 +1,23 @@
+iptables-translate -t mangle -A OUTPUT -j MARK --set-mark 64
+nft add rule ip mangle OUTPUT counter meta mark set 0x40
+
+iptables-translate -t mangle -A OUTPUT -j MARK --set-xmark 0x40/0x32
+nft add rule ip mangle OUTPUT counter meta mark set mark and 0xffffffcd xor 0x40
+
+iptables-translate -t mangle -A OUTPUT -j MARK --or-mark 64
+nft add rule ip mangle OUTPUT counter meta mark set mark or 0x40
+
+iptables-translate -t mangle -A OUTPUT -j MARK --and-mark 64
+nft add rule ip mangle OUTPUT counter meta mark set mark and 0x40
+
+iptables-translate -t mangle -A OUTPUT -j MARK --xor-mark 64
+nft add rule ip mangle OUTPUT counter meta mark set mark xor 0x40
+
+iptables-translate -t mangle -A PREROUTING -j MARK --set-mark 0x64
+nft add rule ip mangle PREROUTING counter meta mark set 0x64
+
+iptables-translate -t mangle -A PREROUTING -j MARK --and-mark 0x64
+nft add rule ip mangle PREROUTING counter meta mark set mark and 0x64
+
+iptables-translate -t mangle -A PREROUTING -j MARK --or-mark 0x64
+nft add rule ip mangle PREROUTING counter meta mark set mark or 0x64
diff --git a/extensions/libxt_NFLOG.txlate b/extensions/libxt_NFLOG.txlate
new file mode 100644
index 00000000..a0872c9e
--- /dev/null
+++ b/extensions/libxt_NFLOG.txlate
@@ -0,0 +1,14 @@
+iptables-translate -A FORWARD -j NFLOG --nflog-group 32 --nflog-prefix "Prefix 1.0"
+nft add rule ip filter FORWARD counter log prefix \"Prefix 1.0\" group 32
+
+iptables-translate -A OUTPUT -j NFLOG --nflog-group 30
+nft add rule ip filter OUTPUT counter log group 30
+
+iptables-translate -I INPUT -j NFLOG --nflog-threshold 2
+nft insert rule ip filter INPUT counter log queue-threshold 2 group 0
+
+iptables-translate -I INPUT -j NFLOG --nflog-size 256
+nft insert rule ip filter INPUT counter log snaplen 256 group 0
+
+iptables-translate -I INPUT -j NFLOG --nflog-threshold 25
+nft insert rule ip filter INPUT counter log queue-threshold 25 group 0
diff --git a/extensions/libxt_NFQUEUE.txlate b/extensions/libxt_NFQUEUE.txlate
new file mode 100644
index 00000000..3d188a7a
--- /dev/null
+++ b/extensions/libxt_NFQUEUE.txlate
@@ -0,0 +1,8 @@
+iptables-translate -t nat -A PREROUTING -p tcp --dport 80 -j NFQUEUE --queue-num 30
+nft add rule ip nat PREROUTING tcp dport 80 counter queue num 30
+
+iptables-translate -A FORWARD -j NFQUEUE --queue-num 0 --queue-bypass -p TCP --sport 80
+nft add rule ip filter FORWARD tcp sport 80 counter queue num 0 bypass
+
+iptables-translate -A FORWARD -j NFQUEUE --queue-bypass -p TCP --sport 80 --queue-balance 0:3 --queue-cpu-fanout
+nft add rule ip filter FORWARD tcp sport 80 counter queue num 0-3 bypass,fanout
diff --git a/extensions/libxt_TEE.txlate b/extensions/libxt_TEE.txlate
new file mode 100644
index 00000000..9fcee254
--- /dev/null
+++ b/extensions/libxt_TEE.txlate
@@ -0,0 +1,11 @@
+# iptables-translate -t mangle -A PREROUTING -j TEE --gateway 192.168.0.2 --oif eth0
+# nft add rule ip mangle PREROUTING counter dup to 192.168.0.2 device eth0
+#
+# iptables-translate -t mangle -A PREROUTING -j TEE --gateway 192.168.0.2
+# nft add rule ip mangle PREROUTING counter dup to 192.168.0.2
+
+ip6tables-translate -t mangle -A PREROUTING -j TEE --gateway ab12:00a1:1112:acba::
+nft add rule ip6 mangle PREROUTING counter dup to ab12:a1:1112:acba::
+
+ip6tables-translate -t mangle -A PREROUTING -j TEE --gateway ab12:00a1:1112:acba:: --oif eth0
+nft add rule ip6 mangle PREROUTING counter dup to ab12:a1:1112:acba:: device eth0
diff --git a/extensions/libxt_TRACE.txlate b/extensions/libxt_TRACE.txlate
new file mode 100644
index 00000000..8e3d2a7a
--- /dev/null
+++ b/extensions/libxt_TRACE.txlate
@@ -0,0 +1,2 @@
+iptables-translate -t raw -A PREROUTING -j TRACE
+nft add rule ip raw PREROUTING counter nftrace set 1
diff --git a/extensions/libxt_addrtype.txlate b/extensions/libxt_addrtype.txlate
new file mode 100644
index 00000000..a719b2c9
--- /dev/null
+++ b/extensions/libxt_addrtype.txlate
@@ -0,0 +1,11 @@
+iptables-translate -A INPUT -m addrtype --src-type LOCAL
+nft add rule ip filter INPUT fib saddr type local counter
+
+iptables-translate -A INPUT -m addrtype --dst-type LOCAL
+nft add rule ip filter INPUT fib daddr type local counter
+
+iptables-translate -A INPUT -m addrtype ! --dst-type ANYCAST,LOCAL
+nft add rule ip filter INPUT fib daddr type != { local, anycast } counter
+
+iptables-translate -A INPUT -m addrtype --limit-iface-in --dst-type ANYCAST,LOCAL
+nft add rule ip filter INPUT fib daddr . iif type { local, anycast } counter
diff --git a/extensions/libxt_cgroup.txlate b/extensions/libxt_cgroup.txlate
new file mode 100644
index 00000000..75f2e6ae
--- /dev/null
+++ b/extensions/libxt_cgroup.txlate
@@ -0,0 +1,5 @@
+iptables-translate -t filter -A INPUT -m cgroup --cgroup 0 -j ACCEPT
+nft add rule ip filter INPUT meta cgroup 0 counter accept
+
+iptables-translate -t filter -A INPUT -m cgroup ! --cgroup 0 -j ACCEPT
+nft add rule ip filter INPUT meta cgroup != 0 counter accept
diff --git a/extensions/libxt_comment.txlate b/extensions/libxt_comment.txlate
new file mode 100644
index 00000000..c610b0e5
--- /dev/null
+++ b/extensions/libxt_comment.txlate
@@ -0,0 +1,8 @@
+iptables-translate -A INPUT -s 192.168.0.0 -m comment --comment "A privatized IP block"
+nft add rule ip filter INPUT ip saddr 192.168.0.0 counter comment \"A privatized IP block\"
+
+iptables-translate -A INPUT -p tcp -m tcp --sport http -s  192.168.0.0/16 -d 192.168.0.0/16 -j LONGNACCEPT -m comment --comment "foobar"
+nft add rule ip filter INPUT ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter jump LONGNACCEPT comment \"foobar\"
+
+iptables-translate -A FORWARD -p tcp -m tcp --sport http -s 192.168.0.0/16 -d 192.168.0.0/16 -j DROP -m comment --comment singlecomment
+nft add rule ip filter FORWARD ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter drop comment \"singlecomment\"
diff --git a/extensions/libxt_connbytes.txlate b/extensions/libxt_connbytes.txlate
new file mode 100644
index 00000000..f78958d2
--- /dev/null
+++ b/extensions/libxt_connbytes.txlate
@@ -0,0 +1,14 @@
+iptables-translate -A OUTPUT -m connbytes --connbytes 200 --connbytes-dir original --connbytes-mode packets
+nft add rule ip filter OUTPUT ct original packets ge 200 counter
+
+iptables-translate -A OUTPUT -m connbytes ! --connbytes 200 --connbytes-dir reply --connbytes-mode packets
+nft add rule ip filter OUTPUT ct reply packets lt 200 counter
+
+iptables-translate -A OUTPUT -m connbytes --connbytes 200:600 --connbytes-dir both --connbytes-mode bytes
+nft add rule ip filter OUTPUT ct bytes 200-600 counter
+
+iptables-translate -A OUTPUT -m connbytes ! --connbytes 200:600 --connbytes-dir both --connbytes-mode bytes
+nft add rule ip filter OUTPUT ct bytes != 200-600 counter
+
+iptables-translate -A OUTPUT -m connbytes --connbytes 200:200 --connbytes-dir both --connbytes-mode avgpkt
+nft add rule ip filter OUTPUT ct avgpkt 200 counter
diff --git a/extensions/libxt_connlabel.txlate b/extensions/libxt_connlabel.txlate
new file mode 100644
index 00000000..5be42204
--- /dev/null
+++ b/extensions/libxt_connlabel.txlate
@@ -0,0 +1,5 @@
+iptables-translate -A INPUT -m connlabel --label bit40
+nft add rule ip filter INPUT ct label bit40 counter
+
+iptables-translate -A INPUT -m connlabel ! --label bit40 --set
+nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter
diff --git a/extensions/libxt_connmark.txlate b/extensions/libxt_connmark.txlate
new file mode 100644
index 00000000..89423259
--- /dev/null
+++ b/extensions/libxt_connmark.txlate
@@ -0,0 +1,14 @@
+iptables-translate -A INPUT -m connmark --mark 2 -j ACCEPT
+nft add rule ip filter INPUT ct mark 0x2 counter accept
+
+iptables-translate -A INPUT -m connmark ! --mark 2 -j ACCEPT
+nft add rule ip filter INPUT ct mark != 0x2 counter accept
+
+iptables-translate -A INPUT -m connmark --mark 10/10 -j ACCEPT
+nft add rule ip filter INPUT ct mark and 0xa == 0xa counter accept
+
+iptables-translate -A INPUT -m connmark ! --mark 10/10 -j ACCEPT
+nft add rule ip filter INPUT ct mark and 0xa != 0xa counter accept
+
+iptables-translate -t mangle -A PREROUTING -p tcp --dport 40 -m connmark --mark 0x40
+nft add rule ip mangle PREROUTING tcp dport 40 ct mark 0x40 counter
diff --git a/extensions/libxt_conntrack.txlate b/extensions/libxt_conntrack.txlate
new file mode 100644
index 00000000..e35d5ce8
--- /dev/null
+++ b/extensions/libxt_conntrack.txlate
@@ -0,0 +1,41 @@
+iptables-translate -t filter -A INPUT -m conntrack --ctstate NEW,RELATED -j ACCEPT
+nft add rule ip filter INPUT ct state new,related counter accept
+
+ip6tables-translate -t filter -A INPUT -m conntrack ! --ctstate NEW,RELATED -j ACCEPT
+nft add rule ip6 filter INPUT ct state != new,related counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack --ctproto UDP -j ACCEPT
+nft add rule ip filter INPUT ct original protocol 17 counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack ! --ctproto UDP -j ACCEPT
+nft add rule ip filter INPUT ct original protocol != 17 counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack --ctorigsrc 10.100.2.131 -j ACCEPT
+nft add rule ip filter INPUT ct original saddr 10.100.2.131 counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack --ctorigsrc 10.100.0.0/255.255.0.0 -j ACCEPT
+nft add rule ip filter INPUT ct original saddr 10.100.0.0/16 counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack --ctorigdst 10.100.2.131 -j ACCEPT
+nft add rule ip filter INPUT ct original daddr 10.100.2.131 counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack --ctreplsrc 10.100.2.131 -j ACCEPT
+nft add rule ip filter INPUT ct reply saddr 10.100.2.131 counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack --ctrepldst 10.100.2.131 -j ACCEPT
+nft add rule ip filter INPUT ct reply daddr 10.100.2.131 counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack --ctproto tcp --ctorigsrcport 443:444 -j ACCEPT
+nft add rule ip filter INPUT ct original protocol 6 ct original proto-src 443-444 counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack ! --ctstatus CONFIRMED -j ACCEPT
+nft add rule ip filter INPUT ct status != confirmed counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack --ctexpire 3 -j ACCEPT
+nft add rule ip filter INPUT ct expiration 3 counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack --ctdir ORIGINAL -j ACCEPT
+nft add rule ip filter INPUT ct direction original counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack --ctstate NEW --ctproto tcp --ctorigsrc 192.168.0.1 --ctorigdst 192.168.0.1 --ctreplsrc 192.168.0.1 --ctrepldst 192.168.0.1 --ctorigsrcport 12 --ctorigdstport 14 --ctreplsrcport 16 --ctrepldstport 18 --ctexpire 10 --ctstatus SEEN_REPLY --ctdir ORIGINAL -j ACCEPT
+nft add rule ip filter INPUT ct direction original ct original protocol 6 ct state new ct status seen-reply ct expiration 10 ct original saddr 192.168.0.1 ct original daddr 192.168.0.1 ct reply saddr 192.168.0.1 ct reply daddr 192.168.0.1 ct original proto-src 12 ct original proto-dst 14 ct reply proto-src 16 ct reply proto-dst 18 counter accept
diff --git a/extensions/libxt_cpu.txlate b/extensions/libxt_cpu.txlate
new file mode 100644
index 00000000..c59b0e02
--- /dev/null
+++ b/extensions/libxt_cpu.txlate
@@ -0,0 +1,5 @@
+iptables-translate -A INPUT -p tcp --dport 80 -m cpu --cpu 0 -j ACCEPT
+nft add rule ip filter INPUT tcp dport 80 cpu 0 counter accept
+
+iptables-translate -A INPUT -p tcp --dport 80 -m cpu ! --cpu 1 -j ACCEPT
+nft add rule ip filter INPUT tcp dport 80 cpu != 1 counter accept
diff --git a/extensions/libxt_dccp.txlate b/extensions/libxt_dccp.txlate
new file mode 100644
index 00000000..b47dc65f
--- /dev/null
+++ b/extensions/libxt_dccp.txlate
@@ -0,0 +1,14 @@
+iptables-translate -A INPUT -p dccp -m dccp --sport 100
+nft add rule ip filter INPUT dccp sport 100 counter
+
+iptables-translate -A INPUT -p dccp -m dccp --dport 100:200
+nft add rule ip filter INPUT dccp dport 100-200 counter
+
+iptables-translate -A INPUT -p dccp -m dccp ! --dport 100
+nft add rule ip filter INPUT dccp dport != 100 counter
+
+iptables-translate -A INPUT -p dccp -m dccp --dport 100 --dccp-types REQUEST,RESPONSE,DATA,ACK,DATAACK,CLOSEREQ,CLOSE,SYNC,SYNCACK
+nft add rule ip filter INPUT dccp dport 100 dccp type {request, response, data, ack, dataack, closereq, close, sync, syncack} counter
+
+iptables-translate -A INPUT -p dccp -m dccp --sport 200 --dport 100
+nft add rule ip filter INPUT dccp sport 200 dport 100 counter
diff --git a/extensions/libxt_devgroup.txlate b/extensions/libxt_devgroup.txlate
new file mode 100644
index 00000000..aeb597bd
--- /dev/null
+++ b/extensions/libxt_devgroup.txlate
@@ -0,0 +1,17 @@
+iptables-translate -A FORWARD -m devgroup --src-group 0x2 -j ACCEPT
+nft add rule ip filter FORWARD iifgroup 0x2 counter accept
+
+iptables-translate -A FORWARD -m devgroup --dst-group 0xc/0xc -j ACCEPT
+nft add rule ip filter FORWARD oifgroup and 0xc == 0xc counter accept
+
+iptables-translate -t mangle -A PREROUTING -p tcp --dport 46000 -m devgroup --src-group 23 -j ACCEPT
+nft add rule ip mangle PREROUTING tcp dport 46000 iifgroup 0x17 counter accept
+
+iptables-translate -A FORWARD -m devgroup ! --dst-group 0xc/0xc -j ACCEPT
+nft add rule ip filter FORWARD oifgroup and 0xc != 0xc counter accept
+
+iptables-translate -A FORWARD -m devgroup ! --src-group 0x2 -j ACCEPT
+nft add rule ip filter FORWARD iifgroup != 0x2 counter accept
+
+iptables-translate -A FORWARD -m devgroup ! --src-group 0x2 --dst-group 0xc/0xc -j ACCEPT
+nft add rule ip filter FORWARD iifgroup != 0x2 oifgroup and 0xc != 0xc counter accept
diff --git a/extensions/libxt_dscp.txlate b/extensions/libxt_dscp.txlate
new file mode 100644
index 00000000..2cccc3b4
--- /dev/null
+++ b/extensions/libxt_dscp.txlate
@@ -0,0 +1,5 @@
+iptables-translate -t filter -A INPUT -m dscp --dscp 0x32 -j ACCEPT
+nft add rule ip filter INPUT ip dscp 0x32 counter accept
+
+ip6tables-translate -t filter -A INPUT -m dscp ! --dscp 0x32 -j ACCEPT
+nft add rule ip6 filter INPUT ip6 dscp != 0x32 counter accept
diff --git a/extensions/libxt_ecn.txlate b/extensions/libxt_ecn.txlate
new file mode 100644
index 00000000..9e3bd310
--- /dev/null
+++ b/extensions/libxt_ecn.txlate
@@ -0,0 +1,23 @@
+iptables-translate -A INPUT -m ecn --ecn-ip-ect 0
+nft add rule ip filter INPUT ip ecn not-ect counter
+
+iptables-translate -A INPUT -m ecn --ecn-ip-ect 1
+nft add rule ip filter INPUT ip ecn ect1 counter
+
+iptables-translate -A INPUT -m ecn --ecn-ip-ect 2
+nft add rule ip filter INPUT ip ecn ect0 counter
+
+iptables-translate -A INPUT -m ecn --ecn-ip-ect 3
+nft add rule ip filter INPUT ip ecn ce counter
+
+iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 0
+nft add rule ip filter INPUT ip ecn != not-ect counter
+
+iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 1
+nft add rule ip filter INPUT ip ecn != ect1 counter
+
+iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 2
+nft add rule ip filter INPUT ip ecn != ect0 counter
+
+iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 3
+nft add rule ip filter INPUT ip ecn != ce counter
diff --git a/extensions/libxt_esp.txlate b/extensions/libxt_esp.txlate
new file mode 100644
index 00000000..a67c6f0e
--- /dev/null
+++ b/extensions/libxt_esp.txlate
@@ -0,0 +1,11 @@
+iptables-translate -A FORWARD -p esp -j ACCEPT
+nft add rule ip filter FORWARD ip protocol esp counter accept
+
+iptables-translate -A INPUT  --in-interface  wan --protocol esp -j ACCEPT
+nft add rule ip filter INPUT iifname wan ip protocol esp counter accept
+
+iptables-translate -A INPUT -p 50 -m esp --espspi 500 -j DROP
+nft add rule ip filter INPUT esp spi 500 counter drop
+
+iptables-translate -A INPUT -p 50 -m esp --espspi 500:600 -j DROP
+nft add rule ip filter INPUT esp spi 500-600 counter drop
diff --git a/extensions/libxt_hashlimit.txlate b/extensions/libxt_hashlimit.txlate
new file mode 100644
index 00000000..d8fa8d23
--- /dev/null
+++ b/extensions/libxt_hashlimit.txlate
@@ -0,0 +1,5 @@
+iptables-translate -A OUTPUT -m tcp -p tcp --dport 443 -m hashlimit --hashlimit-above 20kb/s --hashlimit-burst 1mb --hashlimit-mode dstip --hashlimit-name https --hashlimit-dstmask 24 -m state --state NEW -j DROP
+nft add rule ip filter OUTPUT tcp dport 443 flow table https { ip daddr and 255.255.255.0 timeout 60s limit rate over 20 kbytes/second burst 1 mbytes} ct state new  counter drop
+
+iptables-translate -A OUTPUT -m tcp -p tcp --dport 443 -m hashlimit --hashlimit-upto 300 --hashlimit-burst 15 --hashlimit-mode srcip,dstip --hashlimit-name https --hashlimit-htable-expire 300000 -m state --state NEW -j DROP
+nft add rule ip filter OUTPUT tcp dport 443 flow table https { ip daddr . ip saddr timeout 300s limit rate 300/second burst 15 packets} ct state new  counter drop
diff --git a/extensions/libxt_helper.txlate b/extensions/libxt_helper.txlate
new file mode 100644
index 00000000..8259aba3
--- /dev/null
+++ b/extensions/libxt_helper.txlate
@@ -0,0 +1,5 @@
+iptables-translate -A FORWARD -m helper --helper sip
+nft add rule ip filter FORWARD ct helper \"sip\" counter
+
+iptables-translate -A FORWARD -m helper ! --helper ftp
+nft add rule ip filter FORWARD ct helper != \"ftp\" counter
diff --git a/extensions/libxt_ipcomp.txlate b/extensions/libxt_ipcomp.txlate
new file mode 100644
index 00000000..f9efe53c
--- /dev/null
+++ b/extensions/libxt_ipcomp.txlate
@@ -0,0 +1,5 @@
+iptables-translate -t filter -A INPUT -m ipcomp --ipcompspi 0x12 -j ACCEPT
+nft add rule ip filter INPUT comp cpi 18 counter accept
+
+iptables-translate -t filter -A INPUT -m ipcomp ! --ipcompspi 0x12 -j ACCEPT
+nft add rule ip filter INPUT comp cpi != 18 counter accept
diff --git a/extensions/libxt_iprange.txlate b/extensions/libxt_iprange.txlate
new file mode 100644
index 00000000..999f4b72
--- /dev/null
+++ b/extensions/libxt_iprange.txlate
@@ -0,0 +1,14 @@
+iptables-translate -A INPUT -m iprange --src-range 192.168.25.149-192.168.25.151 -j ACCEPT
+nft add rule ip filter INPUT ip saddr 192.168.25.149-192.168.25.151 counter accept
+
+iptables-translate -A INPUT -m iprange --dst-range 192.168.25.149-192.168.25.151 -j ACCEPT
+nft add rule ip filter INPUT ip daddr 192.168.25.149-192.168.25.151 counter accept
+
+iptables-translate -A INPUT -m iprange --dst-range 3.3.3.3-6.6.6.6 --src-range 4.4.4.4-7.7.7.7 -j ACCEPT
+nft add rule ip filter INPUT ip saddr 4.4.4.4-7.7.7.7 ip daddr 3.3.3.3-6.6.6.6 counter accept
+
+ip6tables-translate -A INPUT -m iprange ! --dst-range ::2d01-::2d03 -j ACCEPT
+nft add rule ip6 filter INPUT ip6 daddr != ::2d01-::2d03 counter accept
+
+ip6tables-translate -A INPUT -m iprange ! --dst-range ::2d01-::2d03 --src-range ::2d01-::2d03 -j ACCEPT
+nft add rule ip6 filter INPUT ip6 saddr ::2d01-::2d03 ip6 daddr != ::2d01-::2d03 counter accept
diff --git a/extensions/libxt_length.txlate b/extensions/libxt_length.txlate
new file mode 100644
index 00000000..e777c265
--- /dev/null
+++ b/extensions/libxt_length.txlate
@@ -0,0 +1,11 @@
+iptables-translate -A INPUT -p icmp -m length --length 86:0xffff -j DROP
+nft add rule ip filter INPUT ip protocol icmp meta length 86-65535 counter drop
+
+iptables-translate -A INPUT -p udp -m length --length :400
+nft add rule ip filter INPUT ip protocol udp meta length 0-400 counter
+
+iptables-translate -A INPUT -p udp -m length --length 40
+nft add rule ip filter INPUT ip protocol udp meta length 40 counter
+
+iptables-translate -A INPUT -p udp -m length ! --length 40
+nft add rule ip filter INPUT ip protocol udp meta length != 40 counter
diff --git a/extensions/libxt_limit.txlate b/extensions/libxt_limit.txlate
new file mode 100644
index 00000000..df9ed2d5
--- /dev/null
+++ b/extensions/libxt_limit.txlate
@@ -0,0 +1,8 @@
+iptables-translate -A INPUT -m limit --limit 3/m --limit-burst 3
+nft add rule ip filter INPUT limit rate 3/minute burst 3 packets counter
+
+iptables-translate -A INPUT -m limit --limit 10/s --limit-burst 5
+nft add rule ip filter INPUT limit rate 10/second burst 5 packets counter
+
+iptables-translate -A INPUT -m limit --limit 10/s --limit-burst 0
+nft add rule ip filter INPUT limit rate 10/second counter
diff --git a/extensions/libxt_mac.txlate b/extensions/libxt_mac.txlate
new file mode 100644
index 00000000..08696f3d
--- /dev/null
+++ b/extensions/libxt_mac.txlate
@@ -0,0 +1,5 @@
+iptables-translate -A INPUT -m mac --mac-source 0a:12:3e:4f:b2:c6 -j DROP
+nft add rule ip filter INPUT ether saddr 0a:12:3e:4f:b2:c6 counter drop
+
+iptables-translate -A INPUT -p tcp --dport 80 -m mac --mac-source 0a:12:3e:4f:b2:c6 -j ACCEPT
+nft add rule ip filter INPUT tcp dport 80 ether saddr 0a:12:3e:4f:b2:c6 counter accept
diff --git a/extensions/libxt_mark.txlate b/extensions/libxt_mark.txlate
new file mode 100644
index 00000000..6bfb5243
--- /dev/null
+++ b/extensions/libxt_mark.txlate
@@ -0,0 +1,5 @@
+iptables-translate -I INPUT -p tcp -m mark ! --mark 0xa/0xa
+nft insert rule ip filter INPUT ip protocol tcp mark and 0xa != 0xa counter
+
+iptables-translate -I INPUT -p tcp -m mark ! --mark 0x1
+nft insert rule ip filter INPUT ip protocol tcp mark != 0x1 counter
diff --git a/extensions/libxt_multiport.txlate b/extensions/libxt_multiport.txlate
new file mode 100644
index 00000000..752e7148
--- /dev/null
+++ b/extensions/libxt_multiport.txlate
@@ -0,0 +1,11 @@
+iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80,81 -j ACCEPT
+nft add rule ip filter INPUT ip protocol tcp tcp dport { 80,81} counter accept
+
+iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80:88 -j ACCEPT
+nft add rule ip filter INPUT ip protocol tcp tcp dport 80-88 counter accept
+
+iptables-translate -t filter -A INPUT -p tcp -m multiport ! --dports 80:88 -j ACCEPT
+nft add rule ip filter INPUT ip protocol tcp tcp dport != 80-88 counter accept
+
+iptables-translate -t filter -A INPUT -p tcp -m multiport --sports 50 -j ACCEPT
+nft add rule ip filter INPUT ip protocol tcp tcp sport 50 counter accept
diff --git a/extensions/libxt_owner.txlate b/extensions/libxt_owner.txlate
new file mode 100644
index 00000000..eeca168b
--- /dev/null
+++ b/extensions/libxt_owner.txlate
@@ -0,0 +1,8 @@
+iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --uid-owner root -j ACCEPT
+nft add rule ip nat OUTPUT tcp dport 80 skuid 0 counter accept
+
+iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --gid-owner 0-10 -j ACCEPT
+nft add rule ip nat OUTPUT tcp dport 80 skgid 0-10 counter accept
+
+iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner ! --uid-owner pablo -j ACCEPT
+nft add rule ip nat OUTPUT tcp dport 80 skuid != 1000 counter accept
diff --git a/extensions/libxt_pkttype.txlate b/extensions/libxt_pkttype.txlate
new file mode 100644
index 00000000..6506a380
--- /dev/null
+++ b/extensions/libxt_pkttype.txlate
@@ -0,0 +1,8 @@
+iptables-translate -A INPUT -m pkttype --pkt-type broadcast -j DROP
+nft add rule ip filter INPUT pkttype broadcast counter drop
+
+iptables-translate -A INPUT -m pkttype ! --pkt-type unicast -j DROP
+nft add rule ip filter INPUT pkttype != unicast counter drop
+
+iptables-translate -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
+nft add rule ip filter INPUT pkttype multicast counter accept
diff --git a/extensions/libxt_quota.txlate b/extensions/libxt_quota.txlate
new file mode 100644
index 00000000..91142141
--- /dev/null
+++ b/extensions/libxt_quota.txlate
@@ -0,0 +1,5 @@
+iptables-translate -A OUTPUT -m quota --quota 111
+nft add rule ip filter OUTPUT quota 111 bytes counter
+
+iptables-translate -A OUTPUT -m quota ! --quota 111
+nft add rule ip filter OUTPUT quota over 111 bytes counter
diff --git a/extensions/libxt_rpfilter.txlate b/extensions/libxt_rpfilter.txlate
new file mode 100644
index 00000000..8d7733ba
--- /dev/null
+++ b/extensions/libxt_rpfilter.txlate
@@ -0,0 +1,8 @@
+iptables-translate -t mangle -A PREROUTING -m rpfilter
+nft add rule ip mangle PREROUTING fib saddr . iif oif != 0 counter
+
+iptables-translate -t mangle -A PREROUTING -m rpfilter --validmark --loose
+nft add rule ip mangle PREROUTING fib saddr . mark oif != 0 counter
+
+ip6tables-translate -t mangle -A PREROUTING -m rpfilter --validmark --invert
+nft add rule ip6 mangle PREROUTING fib saddr . mark . iif oif 0 counter
diff --git a/extensions/libxt_sctp.txlate b/extensions/libxt_sctp.txlate
new file mode 100644
index 00000000..72f4641a
--- /dev/null
+++ b/extensions/libxt_sctp.txlate
@@ -0,0 +1,38 @@
+iptables-translate -A INPUT -p sctp --dport 80 -j DROP
+nft add rule ip filter INPUT sctp dport 80 counter drop
+
+iptables-translate -A INPUT -p sctp --sport 50 -j DROP
+nft add rule ip filter INPUT sctp sport 50 counter drop
+
+iptables-translate -A INPUT -p sctp ! --dport 80 -j DROP
+nft add rule ip filter INPUT sctp dport != 80 counter drop
+
+iptables-translate -A INPUT -p sctp ! --sport 50 -j DROP
+nft add rule ip filter INPUT sctp sport != 50 counter drop
+
+iptables-translate -A INPUT -p sctp --sport 80:100 -j ACCEPT
+nft add rule ip filter INPUT sctp sport 80-100 counter accept
+
+iptables-translate -A INPUT -p sctp --dport 50:56 -j ACCEPT
+nft add rule ip filter INPUT sctp dport 50-56 counter accept
+
+iptables-translate -A INPUT -p sctp ! --sport 80:100 -j ACCEPT
+nft add rule ip filter INPUT sctp sport != 80-100 counter accept
+
+iptables-translate -A INPUT -p sctp ! --dport 50:56 -j ACCEPT
+nft add rule ip filter INPUT sctp dport != 50-56 counter accept
+
+iptables-translate -A INPUT -p sctp --dport 80 --sport 50 -j ACCEPT
+nft add rule ip filter INPUT sctp sport 50 dport 80 counter accept
+
+iptables-translate -A INPUT -p sctp --dport 80:100 --sport 50 -j ACCEPT
+nft add rule ip filter INPUT sctp sport 50 dport 80-100 counter accept
+
+iptables-translate -A INPUT -p sctp --dport 80 --sport 50:55 -j ACCEPT
+nft add rule ip filter INPUT sctp sport 50-55 dport 80 counter accept
+
+iptables-translate -A INPUT -p sctp ! --dport 80:100 --sport 50 -j ACCEPT
+nft add rule ip filter INPUT sctp sport 50 dport != 80-100 counter accept
+
+iptables-translate -A INPUT -p sctp --dport 80 ! --sport 50:55 -j ACCEPT
+nft add rule ip filter INPUT sctp sport != 50-55 dport 80 counter accept
diff --git a/extensions/libxt_statistic.txlate b/extensions/libxt_statistic.txlate
new file mode 100644
index 00000000..4c3dea43
--- /dev/null
+++ b/extensions/libxt_statistic.txlate
@@ -0,0 +1,8 @@
+iptables-translate -A OUTPUT -m statistic --mode nth --every 10 --packet 1
+nft add rule ip filter OUTPUT numgen inc mod 10 1 counter
+
+iptables-translate -A OUTPUT -m statistic --mode nth ! --every 10 --packet 5
+nft add rule ip filter OUTPUT numgen inc mod 10 != 5 counter
+
+iptables-translate -A OUTPUT -m statistic --mode random --probability 0.1
+nft # -A OUTPUT -m statistic --mode random --probability 0.1
diff --git a/extensions/libxt_tcp.txlate b/extensions/libxt_tcp.txlate
new file mode 100644
index 00000000..db099037
--- /dev/null
+++ b/extensions/libxt_tcp.txlate
@@ -0,0 +1,20 @@
+iptables-translate -A INPUT -p tcp -i eth0 --sport 53 -j ACCEPT
+nft add rule ip filter INPUT iifname eth0 tcp sport 53 counter accept
+
+iptables-translate -A OUTPUT -p tcp -o eth0 --dport 53:66 -j DROP
+nft add rule ip filter OUTPUT oifname eth0 tcp dport 53-66 counter drop
+
+iptables-translate -I OUTPUT -p tcp -d 8.8.8.8 -j ACCEPT
+nft insert rule ip filter OUTPUT ip protocol tcp ip daddr 8.8.8.8 counter accept
+
+iptables-translate -I OUTPUT -p tcp --dport 1020:1023 --sport 53 -j ACCEPT
+nft insert rule ip filter OUTPUT tcp sport 53 tcp dport 1020-1023 counter accept
+
+iptables -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
+nft add rule ip filter INPUT tcp flags & fin|ack == fin counter drop
+
+iptables-translate -A INPUT -p tcp --syn -j ACCEPT
+nft add rule ip filter INPUT tcp flags & (fin|syn|rst|ack) == syn counter accept
+
+iptables-translate -A INPUT -p tcp --syn --dport 80 -j ACCEPT
+nft add rule ip filter INPUT tcp dport 80 tcp flags & (fin|syn|rst|ack) == syn counter accept
diff --git a/extensions/libxt_udp.txlate b/extensions/libxt_udp.txlate
new file mode 100644
index 00000000..a9adfcda
--- /dev/null
+++ b/extensions/libxt_udp.txlate
@@ -0,0 +1,11 @@
+iptables-translate -A INPUT -p udp -i eth0 --sport 53 -j ACCEPT
+nft add rule ip filter INPUT iifname eth0 udp sport 53 counter accept
+
+iptables-translate -A OUTPUT -p udp -o eth0 --dport 53:66 -j DROP
+nft add rule ip filter OUTPUT oifname eth0 udp dport 53-66 counter drop
+
+iptables-translate -I OUTPUT -p udp -d 8.8.8.8 -j ACCEPT
+nft insert rule ip filter OUTPUT ip protocol udp ip daddr 8.8.8.8 counter accept
+
+iptables-translate -I OUTPUT -p udp --dport 1020:1023 --sport 53 -j ACCEPT
+nft insert rule ip filter OUTPUT udp sport 53 udp dport 1020-1023 counter accept
diff --git a/xlate-test.py b/xlate-test.py
new file mode 100755
index 00000000..006289f3
--- /dev/null
+++ b/xlate-test.py
@@ -0,0 +1,85 @@
+#!/usr/bin/env python3
+# encoding: utf-8
+
+import os
+import sys
+import shlex
+import subprocess
+import argparse
+
+keywords = ("iptables-translate", "ip6tables-translate")
+
+
+if sys.stdout.isatty():
+    colors = {"magenta": "\033[95m", "green": "\033[92m", "yellow": "\033[93m",
+              "red": "\033[91m", "end": "\033[0m"}
+else:
+    colors = {"magenta": "", "green": "", "yellow": "", "red": "", "end": ""}
+
+
+def magenta(string):
+    return colors["magenta"] + string + colors["end"]
+
+
+def red(string):
+    return colors["red"] + string + colors["end"]
+
+
+def yellow(string):
+    return colors["yellow"] + string + colors["end"]
+
+
+def green(string):
+    return colors["green"] + string + colors["end"]
+
+
+def run_test(name, payload):
+    test_passed = True
+    result = []
+    result.append(yellow("## " + name.replace(".txlate", "")))
+
+    for line in payload:
+        if line.startswith(keywords):
+            output = subprocess.run(shlex.split(line), stdout=subprocess.PIPE)
+            translation = output.stdout.decode("utf-8").rstrip(" \n")
+            expected = next(payload).rstrip(" \n")
+            if translation != expected:
+                result.append(red("Fail"))
+                result.append(magenta("src: ") + line.rstrip(" \n"))
+                result.append(magenta("exp: ") + expected)
+                result.append(magenta("res: ") + translation + "\n")
+                test_passed = False
+            elif args.all:
+                result.append(green("Ok"))
+                result.append(magenta("src: ") + line.rstrip(" \n"))
+                result.append(magenta("res: ") + translation + "\n")
+
+    if not test_passed or args.all:
+        print("\n".join(result))
+
+
+def load_test_files():
+    for test in sorted(os.listdir("extensions")):
+        if test.endswith(".txlate"):
+            with open("extensions/" + test, "r") as payload:
+                run_test(test, payload)
+
+
+def main():
+    if args.test:
+        if not args.test.endswith(".txlate"):
+            args.test += ".txlate"
+        try:
+            with open("extensions/" + args.test, "r") as payload:
+                run_test(args.test, payload)
+        except IOError:
+            print(red("Error: ") + "test file does not exist")
+    else:
+        load_test_files()
+
+
+parser = argparse.ArgumentParser()
+parser.add_argument("--all", action="store_true", help="show also passed tests")
+parser.add_argument("test", nargs="?", help="run only the specified test file")
+args = parser.parse_args()
+main()
-- 
2.12.1

