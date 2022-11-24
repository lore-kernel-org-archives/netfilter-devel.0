Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB43C4708B
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 13:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiKXNuK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 08:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiKXNuE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 08:50:04 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CE811607E
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 05:49:54 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oyCbx-0000UG-3b; Thu, 24 Nov 2022 14:49:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 2/3] extensions: change expected output for new format
Date:   Thu, 24 Nov 2022 14:49:38 +0100
Message-Id: <20221124134939.8245-3-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221124134939.8245-1-fw@strlen.de>
References: <20221124134939.8245-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now that xtables-translate encloses the entire command line in ', update
the test cases accordingly.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/generic.txlate            | 56 ++++++++++++++--------------
 extensions/libebt_dnat.txlate        |  6 +--
 extensions/libebt_ip.txlate          | 18 ++++-----
 extensions/libebt_ip6.txlate         | 20 +++++-----
 extensions/libebt_limit.txlate       |  6 +--
 extensions/libebt_log.txlate         | 10 ++---
 extensions/libebt_mark.txlate        |  8 ++--
 extensions/libebt_mark_m.txlate      | 10 ++---
 extensions/libebt_nflog.txlate       |  8 ++--
 extensions/libebt_pkttype.txlate     | 14 +++----
 extensions/libebt_snat.txlate        |  4 +-
 extensions/libebt_vlan.txlate        |  8 ++--
 extensions/libip6t_LOG.txlate        |  6 +--
 extensions/libip6t_MASQUERADE.txlate | 12 +++---
 extensions/libip6t_REJECT.txlate     |  6 +--
 extensions/libip6t_SNAT.txlate       |  8 ++--
 extensions/libip6t_ah.txlate         | 12 +++---
 extensions/libip6t_frag.txlate       | 12 +++---
 extensions/libip6t_hbh.txlate        |  4 +-
 extensions/libip6t_hl.txlate         |  4 +-
 extensions/libip6t_icmp6.txlate      |  6 +--
 extensions/libip6t_mh.txlate         |  4 +-
 extensions/libip6t_rt.txlate         | 10 ++---
 extensions/libipt_LOG.txlate         |  4 +-
 extensions/libipt_MASQUERADE.txlate  | 12 +++---
 extensions/libipt_REJECT.txlate      |  6 +--
 extensions/libipt_SNAT.txlate        | 10 ++---
 extensions/libipt_ah.txlate          |  6 +--
 extensions/libipt_icmp.txlate        |  8 ++--
 extensions/libipt_realm.txlate       |  8 ++--
 extensions/libipt_ttl.txlate         |  4 +-
 extensions/libxt_AUDIT.txlate        |  6 +--
 extensions/libxt_CLASSIFY.txlate     |  6 +--
 extensions/libxt_CONNMARK.txlate     | 16 ++++----
 extensions/libxt_DNAT.txlate         | 24 ++++++------
 extensions/libxt_DSCP.txlate         |  4 +-
 extensions/libxt_MARK.txlate         | 18 ++++-----
 extensions/libxt_NFLOG.txlate        | 10 ++---
 extensions/libxt_NFQUEUE.txlate      |  6 +--
 extensions/libxt_NOTRACK.txlate      |  2 +-
 extensions/libxt_REDIRECT.txlate     | 20 +++++-----
 extensions/libxt_SYNPROXY.txlate     |  2 +-
 extensions/libxt_TCPMSS.txlate       |  4 +-
 extensions/libxt_TEE.txlate          |  8 ++--
 extensions/libxt_TOS.txlate          | 18 ++++-----
 extensions/libxt_TRACE.txlate        |  2 +-
 extensions/libxt_addrtype.txlate     |  8 ++--
 extensions/libxt_cgroup.txlate       |  4 +-
 extensions/libxt_cluster.txlate      | 18 ++++-----
 extensions/libxt_comment.txlate      |  6 +--
 extensions/libxt_connbytes.txlate    | 10 ++---
 extensions/libxt_connlabel.txlate    |  4 +-
 extensions/libxt_connlimit.txlate    | 16 ++++----
 extensions/libxt_connmark.txlate     | 10 ++---
 extensions/libxt_conntrack.txlate    | 40 ++++++++++----------
 extensions/libxt_cpu.txlate          |  4 +-
 extensions/libxt_dccp.txlate         | 14 +++----
 extensions/libxt_devgroup.txlate     | 12 +++---
 extensions/libxt_dscp.txlate         |  4 +-
 extensions/libxt_ecn.txlate          | 20 +++++-----
 extensions/libxt_esp.txlate          |  8 ++--
 extensions/libxt_hashlimit.txlate    |  4 +-
 extensions/libxt_helper.txlate       |  4 +-
 extensions/libxt_ipcomp.txlate       |  4 +-
 extensions/libxt_iprange.txlate      | 10 ++---
 extensions/libxt_length.txlate       |  8 ++--
 extensions/libxt_limit.txlate        |  6 +--
 extensions/libxt_mac.txlate          |  4 +-
 extensions/libxt_mark.txlate         |  4 +-
 extensions/libxt_multiport.txlate    | 10 ++---
 extensions/libxt_owner.txlate        |  6 +--
 extensions/libxt_pkttype.txlate      |  6 +--
 extensions/libxt_policy.txlate       |  4 +-
 extensions/libxt_quota.txlate        |  4 +-
 extensions/libxt_rpfilter.txlate     |  6 +--
 extensions/libxt_sctp.txlate         | 30 +++++++--------
 extensions/libxt_statistic.txlate    |  4 +-
 extensions/libxt_tcp.txlate          | 22 +++++------
 extensions/libxt_tcpmss.txlate       |  8 ++--
 extensions/libxt_time.txlate         | 18 ++++-----
 extensions/libxt_udp.txlate          |  8 ++--
 81 files changed, 402 insertions(+), 402 deletions(-)

diff --git a/extensions/generic.txlate b/extensions/generic.txlate
index 6779d6f86dec..7e879fd526bb 100644
--- a/extensions/generic.txlate
+++ b/extensions/generic.txlate
@@ -1,90 +1,90 @@
 iptables-translate -I OUTPUT -p udp -d 8.8.8.8 -j ACCEPT
-nft insert rule ip filter OUTPUT ip protocol udp ip daddr 8.8.8.8 counter accept
+nft 'insert rule ip filter OUTPUT ip protocol udp ip daddr 8.8.8.8 counter accept'
 
 iptables-translate -F -t nat
 nft flush table ip nat
 
 iptables-translate -I INPUT -i iifname -s 10.0.0.0/8
-nft insert rule ip filter INPUT iifname "iifname" ip saddr 10.0.0.0/8 counter
+nft 'insert rule ip filter INPUT iifname "iifname" ip saddr 10.0.0.0/8 counter'
 
 iptables-translate -A INPUT -i iif+ ! -d 10.0.0.0/8
-nft add rule ip filter INPUT iifname "iif*" ip daddr != 10.0.0.0/8 counter
+nft 'add rule ip filter INPUT iifname "iif*" ip daddr != 10.0.0.0/8 counter'
 
 iptables-translate -I INPUT -s 10.11.12.13/255.255.0.0
-nft insert rule ip filter INPUT ip saddr 10.11.0.0/16 counter
+nft 'insert rule ip filter INPUT ip saddr 10.11.0.0/16 counter'
 
 iptables-translate -I INPUT -s 10.11.12.13/255.0.255.0
-nft insert rule ip filter INPUT ip saddr & 255.0.255.0 == 10.0.12.0 counter
+nft 'insert rule ip filter INPUT ip saddr & 255.0.255.0 == 10.0.12.0 counter'
 
 iptables-translate -I INPUT -s 10.11.12.13/0.255.0.255
-nft insert rule ip filter INPUT ip saddr & 0.255.0.255 == 0.11.0.13 counter
+nft 'insert rule ip filter INPUT ip saddr & 0.255.0.255 == 0.11.0.13 counter'
 
 iptables-translate -I INPUT ! -s 10.11.12.13/0.255.0.255
-nft insert rule ip filter INPUT ip saddr & 0.255.0.255 != 0.11.0.13 counter
+nft 'insert rule ip filter INPUT ip saddr & 0.255.0.255 != 0.11.0.13 counter'
 
 iptables-translate -I INPUT -s 0.0.0.0/16
-nft insert rule ip filter INPUT ip saddr 0.0.0.0/16 counter
+nft 'insert rule ip filter INPUT ip saddr 0.0.0.0/16 counter'
 
 iptables-translate -I INPUT -s 0.0.0.0/0
-nft insert rule ip filter INPUT counter
+nft 'insert rule ip filter INPUT counter'
 
 iptables-translate -I INPUT ! -s 0.0.0.0/0
-nft insert rule ip filter INPUT ip saddr != 0.0.0.0/0 counter
+nft 'insert rule ip filter INPUT ip saddr != 0.0.0.0/0 counter'
 
 ip6tables-translate -I INPUT -i iifname -s feed::/16
-nft insert rule ip6 filter INPUT iifname "iifname" ip6 saddr feed::/16 counter
+nft 'insert rule ip6 filter INPUT iifname "iifname" ip6 saddr feed::/16 counter'
 
 ip6tables-translate -A INPUT -i iif+ ! -d feed::/16
-nft add rule ip6 filter INPUT iifname "iif*" ip6 daddr != feed::/16 counter
+nft 'add rule ip6 filter INPUT iifname "iif*" ip6 daddr != feed::/16 counter'
 
 ip6tables-translate -I INPUT -s feed:babe::1/ffff:ff00::
-nft insert rule ip6 filter INPUT ip6 saddr feed:ba00::/24 counter
+nft 'insert rule ip6 filter INPUT ip6 saddr feed:ba00::/24 counter'
 
 ip6tables-translate -I INPUT -s feed:babe:c0ff:ee00:c0be:1234:5678:90ab/ffff:0:ffff:0:ffff:0:ffff:0
-nft insert rule ip6 filter INPUT ip6 saddr & ffff:0:ffff:0:ffff:0:ffff:0 == feed:0:c0ff:0:c0be:0:5678:0 counter
+nft 'insert rule ip6 filter INPUT ip6 saddr & ffff:0:ffff:0:ffff:0:ffff:0 == feed:0:c0ff:0:c0be:0:5678:0 counter'
 
 ip6tables-translate -I INPUT -s feed:babe:c0ff:ee00:c0be:1234:5678:90ab/0:ffff:0:ffff:0:ffff:0:ffff
-nft insert rule ip6 filter INPUT ip6 saddr & 0:ffff:0:ffff:0:ffff:0:ffff == 0:babe:0:ee00:0:1234:0:90ab counter
+nft 'insert rule ip6 filter INPUT ip6 saddr & 0:ffff:0:ffff:0:ffff:0:ffff == 0:babe:0:ee00:0:1234:0:90ab counter'
 
 ip6tables-translate -I INPUT ! -s feed:babe:c0ff:ee00:c0be:1234:5678:90ab/0:ffff:0:ffff:0:ffff:0:ffff
-nft insert rule ip6 filter INPUT ip6 saddr & 0:ffff:0:ffff:0:ffff:0:ffff != 0:babe:0:ee00:0:1234:0:90ab counter
+nft 'insert rule ip6 filter INPUT ip6 saddr & 0:ffff:0:ffff:0:ffff:0:ffff != 0:babe:0:ee00:0:1234:0:90ab counter'
 
 ip6tables-translate -I INPUT -s ::/16
-nft insert rule ip6 filter INPUT ip6 saddr ::/16 counter
+nft 'insert rule ip6 filter INPUT ip6 saddr ::/16 counter'
 
 ip6tables-translate -I INPUT -s ::/0
-nft insert rule ip6 filter INPUT counter
+nft 'insert rule ip6 filter INPUT counter'
 
 ip6tables-translate -I INPUT ! -s ::/0
-nft insert rule ip6 filter INPUT ip6 saddr != ::/0 counter
+nft 'insert rule ip6 filter INPUT ip6 saddr != ::/0 counter'
 
 ebtables-translate -I INPUT -i iname --logical-in ilogname -s 0:0:0:0:0:0
-nft insert rule bridge filter INPUT iifname "iname" meta ibrname "ilogname" ether saddr 00:00:00:00:00:00 counter
+nft 'insert rule bridge filter INPUT iifname "iname" meta ibrname "ilogname" ether saddr 00:00:00:00:00:00 counter'
 
 ebtables-translate -A FORWARD ! -i iname --logical-in ilogname -o out+ --logical-out lout+ -d 1:2:3:4:de:af
-nft add rule bridge filter FORWARD iifname != "iname" meta ibrname "ilogname" oifname "out*" meta obrname "lout*" ether daddr 01:02:03:04:de:af counter
+nft 'add rule bridge filter FORWARD iifname != "iname" meta ibrname "ilogname" oifname "out*" meta obrname "lout*" ether daddr 01:02:03:04:de:af counter'
 
 ebtables-translate -I INPUT -p ip -d 1:2:3:4:5:6/ff:ff:ff:ff:00:00
-nft insert rule bridge filter INPUT ether type 0x800 ether daddr 01:02:03:04:00:00 and ff:ff:ff:ff:00:00 == 01:02:03:04:00:00 counter
+nft 'insert rule bridge filter INPUT ether type 0x800 ether daddr 01:02:03:04:00:00 and ff:ff:ff:ff:00:00 == 01:02:03:04:00:00 counter'
 
 ebtables-translate -I INPUT -p Length
-nft insert rule bridge filter INPUT ether type < 0x0600 counter
+nft 'insert rule bridge filter INPUT ether type < 0x0600 counter'
 
 ebtables-translate -I INPUT -p ! Length
-nft insert rule bridge filter INPUT ether type >= 0x0600 counter
+nft 'insert rule bridge filter INPUT ether type >= 0x0600 counter'
 
 # asterisk is not special in iptables and it is even a valid interface name
 iptables-translate -A FORWARD -i '*' -o 'eth*foo'
-nft add rule ip filter FORWARD iifname "\*" oifname "eth\*foo" counter
+nft 'add rule ip filter FORWARD iifname "\*" oifname "eth\*foo" counter'
 
 # escape all asterisks but translate only the first plus character
 iptables-translate -A FORWARD -i 'eth*foo*+' -o 'eth++'
-nft add rule ip filter FORWARD iifname "eth\*foo\**" oifname "eth+*" counter
+nft 'add rule ip filter FORWARD iifname "eth\*foo\**" oifname "eth+*" counter'
 
 # skip for always matching interface names
 iptables-translate -A FORWARD -i '+'
-nft add rule ip filter FORWARD counter
+nft 'add rule ip filter FORWARD counter'
 
 # match against invalid interface name to simulate never matching rule
 iptables-translate -A FORWARD ! -i '+'
-nft add rule ip filter FORWARD iifname "INVAL/D" counter
+nft 'add rule ip filter FORWARD iifname "INVAL/D" counter'
diff --git a/extensions/libebt_dnat.txlate b/extensions/libebt_dnat.txlate
index 2652dd55b264..9f305c76c954 100644
--- a/extensions/libebt_dnat.txlate
+++ b/extensions/libebt_dnat.txlate
@@ -1,8 +1,8 @@
 ebtables-translate -t nat -A PREROUTING -i someport --to-dst de:ad:00:be:ee:ff
-nft add rule bridge nat PREROUTING iifname "someport" ether daddr set de:ad:0:be:ee:ff accept counter
+nft 'add rule bridge nat PREROUTING iifname "someport" ether daddr set de:ad:0:be:ee:ff accept counter'
 
 ebtables-translate -t nat -A PREROUTING -i someport --to-dst de:ad:00:be:ee:ff --dnat-target ACCEPT
-nft add rule bridge nat PREROUTING iifname "someport" ether daddr set de:ad:0:be:ee:ff accept counter
+nft 'add rule bridge nat PREROUTING iifname "someport" ether daddr set de:ad:0:be:ee:ff accept counter'
 
 ebtables-translate -t nat -A PREROUTING -i someport --to-dst de:ad:00:be:ee:ff --dnat-target CONTINUE
-nft add rule bridge nat PREROUTING iifname "someport" ether daddr set de:ad:0:be:ee:ff continue counter
+nft 'add rule bridge nat PREROUTING iifname "someport" ether daddr set de:ad:0:be:ee:ff continue counter'
diff --git a/extensions/libebt_ip.txlate b/extensions/libebt_ip.txlate
index b5882c342b04..75c1db246fb8 100644
--- a/extensions/libebt_ip.txlate
+++ b/extensions/libebt_ip.txlate
@@ -1,26 +1,26 @@
 ebtables-translate -A FORWARD -p ip --ip-src ! 192.168.0.0/24 -j ACCEPT
-nft add rule bridge filter FORWARD ip saddr != 192.168.0.0/24 counter accept
+nft 'add rule bridge filter FORWARD ip saddr != 192.168.0.0/24 counter accept'
 
 ebtables-translate -I FORWARD -p ip --ip-dst 10.0.0.1
-nft insert rule bridge filter FORWARD ip daddr 10.0.0.1 counter
+nft 'insert rule bridge filter FORWARD ip daddr 10.0.0.1 counter'
 
 ebtables-translate -I OUTPUT 3 -p ip -o eth0 --ip-tos 0xff
-nft insert rule bridge filter OUTPUT oifname "eth0" ip dscp 0x3f counter
+nft 'insert rule bridge filter OUTPUT oifname "eth0" ip dscp 0x3f counter'
 
 ebtables-translate -A FORWARD -p ip --ip-proto tcp --ip-dport 22
-nft add rule bridge filter FORWARD tcp dport 22 counter
+nft 'add rule bridge filter FORWARD tcp dport 22 counter'
 
 ebtables-translate -A FORWARD -p ip --ip-proto udp --ip-sport 1024:65535
-nft add rule bridge filter FORWARD udp sport 1024-65535 counter
+nft 'add rule bridge filter FORWARD udp sport 1024-65535 counter'
 
 ebtables-translate -A FORWARD -p ip --ip-proto 253
-nft add rule bridge filter FORWARD ip protocol 253 counter
+nft 'add rule bridge filter FORWARD ip protocol 253 counter'
 
 ebtables-translate -A FORWARD -p ip --ip-protocol icmp --ip-icmp-type "echo-request"
-nft add rule bridge filter FORWARD icmp type 8 counter
+nft 'add rule bridge filter FORWARD icmp type 8 counter'
 
 ebtables-translate -A FORWARD -p ip --ip-proto icmp --ip-icmp-type 1/1
-nft add rule bridge filter FORWARD icmp type 1 icmp code 1 counter
+nft 'add rule bridge filter FORWARD icmp type 1 icmp code 1 counter'
 
 ebtables-translate -A FORWARD -p ip --ip-protocol icmp --ip-icmp-type ! 1:10
-nft add rule bridge filter FORWARD icmp type != 1-10 counter
+nft 'add rule bridge filter FORWARD icmp type != 1-10 counter'
diff --git a/extensions/libebt_ip6.txlate b/extensions/libebt_ip6.txlate
index 0271734c9b09..0debbe125509 100644
--- a/extensions/libebt_ip6.txlate
+++ b/extensions/libebt_ip6.txlate
@@ -1,29 +1,29 @@
 ebtables-translate -A FORWARD -p ip6 --ip6-src ! dead::beef/64 -j ACCEPT
-nft add rule bridge filter FORWARD ip6 saddr != dead::/64 counter accept
+nft 'add rule bridge filter FORWARD ip6 saddr != dead::/64 counter accept'
 
 ebtables-translate -A FORWARD -p ip6 ! --ip6-dst dead:beef::/64 -j ACCEPT
-nft add rule bridge filter FORWARD ip6 daddr != dead:beef::/64 counter accept
+nft 'add rule bridge filter FORWARD ip6 daddr != dead:beef::/64 counter accept'
 
 ebtables-translate -I FORWARD -p ip6 --ip6-dst f00:ba::
-nft insert rule bridge filter FORWARD ip6 daddr f00:ba:: counter
+nft 'insert rule bridge filter FORWARD ip6 daddr f00:ba:: counter'
 
 ebtables-translate -I OUTPUT -o eth0 -p ip6 --ip6-tclass 0xff
-nft insert rule bridge filter OUTPUT oifname "eth0" ip6 dscp 0x3f counter
+nft 'insert rule bridge filter OUTPUT oifname "eth0" ip6 dscp 0x3f counter'
 
 ebtables-translate -A FORWARD -p ip6 --ip6-proto tcp --ip6-dport 22
-nft add rule bridge filter FORWARD ether type ip6 tcp dport 22 counter
+nft 'add rule bridge filter FORWARD ether type ip6 tcp dport 22 counter'
 
 ebtables-translate -A FORWARD -p ip6 --ip6-proto udp --ip6-sport 1024:65535
-nft add rule bridge filter FORWARD ether type ip6 udp sport 1024-65535 counter
+nft 'add rule bridge filter FORWARD ether type ip6 udp sport 1024-65535 counter'
 
 ebtables-translate -A FORWARD -p ip6 --ip6-proto 253
-nft add rule bridge filter FORWARD ether type ip6 meta l4proto 253 counter
+nft 'add rule bridge filter FORWARD ether type ip6 meta l4proto 253 counter'
 
 ebtables-translate -A FORWARD -p ip6  --ip6-protocol icmpv6 --ip6-icmp-type "echo-request"
-nft add rule bridge filter FORWARD icmpv6 type 128 counter
+nft 'add rule bridge filter FORWARD icmpv6 type 128 counter'
 
 ebtables-translate -A FORWARD -p ip6 --ip6-protocol icmpv6  --ip6-icmp-type 1/1
-nft add rule bridge filter FORWARD icmpv6 type 1 icmpv6 code 1 counter
+nft 'add rule bridge filter FORWARD icmpv6 type 1 icmpv6 code 1 counter'
 
 ebtables-translate -A FORWARD -p ip6 --ip6-protocol icmpv6 --ip6-icmp-type ! 1:10
-nft add rule bridge filter FORWARD icmpv6 type != 1-10 counter
+nft 'add rule bridge filter FORWARD icmpv6 type != 1-10 counter'
diff --git a/extensions/libebt_limit.txlate b/extensions/libebt_limit.txlate
index b6af15d5c769..adcce3ed6d31 100644
--- a/extensions/libebt_limit.txlate
+++ b/extensions/libebt_limit.txlate
@@ -1,8 +1,8 @@
 ebtables-translate -A INPUT --limit 3/m --limit-burst 3
-nft add rule bridge filter INPUT limit rate 3/minute burst 3 packets counter
+nft 'add rule bridge filter INPUT limit rate 3/minute burst 3 packets counter'
 
 ebtables-translate -A INPUT --limit 10/s --limit-burst 5
-nft add rule bridge filter INPUT limit rate 10/second burst 5 packets counter
+nft 'add rule bridge filter INPUT limit rate 10/second burst 5 packets counter'
 
 ebtables-translate -A INPUT --limit 10/s --limit-burst 0
-nft add rule bridge filter INPUT limit rate 10/second counter
+nft 'add rule bridge filter INPUT limit rate 10/second counter'
diff --git a/extensions/libebt_log.txlate b/extensions/libebt_log.txlate
index 7ef8d5e1f954..9847e4c1c8a9 100644
--- a/extensions/libebt_log.txlate
+++ b/extensions/libebt_log.txlate
@@ -1,15 +1,15 @@
 ebtables-translate -A INPUT --log
-nft add rule bridge filter INPUT log level notice flags ether counter
+nft 'add rule bridge filter INPUT log level notice flags ether counter'
 
 ebtables-translate -A INPUT --log-level 1
-nft add rule bridge filter INPUT log level alert flags ether counter
+nft 'add rule bridge filter INPUT log level alert flags ether counter'
 
 ebtables-translate -A INPUT --log-level crit
-nft add rule bridge filter INPUT log level crit flags ether counter
+nft 'add rule bridge filter INPUT log level crit flags ether counter'
 
 ebtables-translate -A INPUT --log-level emerg --log-ip --log-arp --log-ip6
-nft add rule bridge filter INPUT log level emerg flags ether counter
+nft 'add rule bridge filter INPUT log level emerg flags ether counter'
 
 ebtables-translate -A INPUT --log-level crit --log-ip --log-arp --log-ip6 --log-prefix foo
-nft add rule bridge filter INPUT log prefix "foo" level crit flags ether counter
+nft 'add rule bridge filter INPUT log prefix "foo" level crit flags ether counter'
 
diff --git a/extensions/libebt_mark.txlate b/extensions/libebt_mark.txlate
index 7529302d9a44..d006e8ac9400 100644
--- a/extensions/libebt_mark.txlate
+++ b/extensions/libebt_mark.txlate
@@ -1,11 +1,11 @@
 ebtables-translate -A INPUT --mark-set 42
-nft add rule bridge filter INPUT meta mark set 0x2a accept counter
+nft 'add rule bridge filter INPUT meta mark set 0x2a accept counter'
 
 ebtables-translate -A INPUT --mark-or 42 --mark-target RETURN
-nft add rule bridge filter INPUT meta mark set meta mark or 0x2a return counter
+nft 'add rule bridge filter INPUT meta mark set meta mark or 0x2a return counter'
 
 ebtables-translate -A INPUT --mark-and 42 --mark-target ACCEPT
-nft add rule bridge filter INPUT meta mark set meta mark and 0x2a accept counter
+nft 'add rule bridge filter INPUT meta mark set meta mark and 0x2a accept counter'
 
 ebtables-translate -A INPUT --mark-xor 42 --mark-target DROP
-nft add rule bridge filter INPUT meta mark set meta mark xor 0x2a drop counter
+nft 'add rule bridge filter INPUT meta mark set meta mark xor 0x2a drop counter'
diff --git a/extensions/libebt_mark_m.txlate b/extensions/libebt_mark_m.txlate
index 7b44425b2716..2981a5647bd8 100644
--- a/extensions/libebt_mark_m.txlate
+++ b/extensions/libebt_mark_m.txlate
@@ -1,14 +1,14 @@
 ebtables-translate -A INPUT --mark 42
-nft add rule bridge filter INPUT meta mark 0x2a counter
+nft 'add rule bridge filter INPUT meta mark 0x2a counter'
 
 ebtables-translate -A INPUT ! --mark 42
-nft add rule bridge filter INPUT meta mark != 0x2a counter
+nft 'add rule bridge filter INPUT meta mark != 0x2a counter'
 
 ebtables-translate -A INPUT --mark ! 42
-nft add rule bridge filter INPUT meta mark != 0x2a counter
+nft 'add rule bridge filter INPUT meta mark != 0x2a counter'
 
 ebtables-translate -A INPUT --mark ! 0x1/0xff
-nft add rule bridge filter INPUT meta mark and 0xff != 0x1 counter
+nft 'add rule bridge filter INPUT meta mark and 0xff != 0x1 counter'
 
 ebtables-translate -A INPUT --mark /0x02
-nft add rule bridge filter INPUT meta mark and 0x2 != 0 counter
+nft 'add rule bridge filter INPUT meta mark and 0x2 != 0 counter'
diff --git a/extensions/libebt_nflog.txlate b/extensions/libebt_nflog.txlate
index bc3f5364e940..6f292fd2af80 100644
--- a/extensions/libebt_nflog.txlate
+++ b/extensions/libebt_nflog.txlate
@@ -1,11 +1,11 @@
 ebtables-translate -A INPUT --nflog
-nft add rule bridge filter INPUT log group 1 counter
+nft 'add rule bridge filter INPUT log group 1 counter'
 
 ebtables-translate -A INPUT --nflog-group 42
-nft add rule bridge filter INPUT log group 42 counter
+nft 'add rule bridge filter INPUT log group 42 counter'
 
 ebtables-translate -A INPUT --nflog-range 42
-nft add rule bridge filter INPUT log group 1 snaplen 42 counter
+nft 'add rule bridge filter INPUT log group 1 snaplen 42 counter'
 
 ebtables-translate -A INPUT --nflog-threshold 100 --nflog-prefix foo
-nft add rule bridge filter INPUT log prefix "foo" group 1 queue-threshold 100 counter
+nft 'add rule bridge filter INPUT log prefix "foo" group 1 queue-threshold 100 counter'
diff --git a/extensions/libebt_pkttype.txlate b/extensions/libebt_pkttype.txlate
index 94d016d9e70e..6a828a98bf31 100644
--- a/extensions/libebt_pkttype.txlate
+++ b/extensions/libebt_pkttype.txlate
@@ -1,20 +1,20 @@
 ebtables-translate -A INPUT --pkttype-type host
-nft add rule bridge filter INPUT meta pkttype host counter
+nft 'add rule bridge filter INPUT meta pkttype host counter'
 
 ebtables-translate -A INPUT ! --pkttype-type broadcast
-nft add rule bridge filter INPUT meta pkttype != broadcast counter
+nft 'add rule bridge filter INPUT meta pkttype != broadcast counter'
 
 ebtables-translate -A INPUT --pkttype-type ! multicast
-nft add rule bridge filter INPUT meta pkttype != multicast counter
+nft 'add rule bridge filter INPUT meta pkttype != multicast counter'
 
 ebtables-translate -A INPUT --pkttype-type otherhost
-nft add rule bridge filter INPUT meta pkttype other counter
+nft 'add rule bridge filter INPUT meta pkttype other counter'
 
 ebtables-translate -A INPUT --pkttype-type outgoing
-nft add rule bridge filter INPUT meta pkttype 4 counter
+nft 'add rule bridge filter INPUT meta pkttype 4 counter'
 
 ebtables-translate -A INPUT --pkttype-type loopback
-nft add rule bridge filter INPUT meta pkttype 5 counter
+nft 'add rule bridge filter INPUT meta pkttype 5 counter'
 
 ebtables-translate -A INPUT --pkttype-type fastroute
-nft add rule bridge filter INPUT meta pkttype 6 counter
+nft 'add rule bridge filter INPUT meta pkttype 6 counter'
diff --git a/extensions/libebt_snat.txlate b/extensions/libebt_snat.txlate
index 0d84602466c2..857a6052aed1 100644
--- a/extensions/libebt_snat.txlate
+++ b/extensions/libebt_snat.txlate
@@ -1,5 +1,5 @@
 ebtables-translate -t nat -A POSTROUTING -s 0:0:0:0:0:0 -o someport+ --to-source de:ad:00:be:ee:ff
-nft add rule bridge nat POSTROUTING oifname "someport*" ether saddr 00:00:00:00:00:00 ether saddr set de:ad:0:be:ee:ff accept counter
+nft 'add rule bridge nat POSTROUTING oifname "someport*" ether saddr 00:00:00:00:00:00 ether saddr set de:ad:0:be:ee:ff accept counter'
 
 ebtables-translate -t nat -A POSTROUTING -o someport --to-src de:ad:00:be:ee:ff --snat-target CONTINUE
-nft add rule bridge nat POSTROUTING oifname "someport" ether saddr set de:ad:0:be:ee:ff continue counter
+nft 'add rule bridge nat POSTROUTING oifname "someport" ether saddr set de:ad:0:be:ee:ff continue counter'
diff --git a/extensions/libebt_vlan.txlate b/extensions/libebt_vlan.txlate
index 2ab62d5335ab..5d21e3eba0dc 100644
--- a/extensions/libebt_vlan.txlate
+++ b/extensions/libebt_vlan.txlate
@@ -1,11 +1,11 @@
 ebtables-translate -A INPUT -p 802_1Q --vlan-id 42
-nft add rule bridge filter INPUT vlan id 42 counter
+nft 'add rule bridge filter INPUT vlan id 42 counter'
 
 ebtables-translate -A INPUT -p 802_1Q --vlan-prio ! 1
-nft add rule bridge filter INPUT vlan pcp != 1 counter
+nft 'add rule bridge filter INPUT vlan pcp != 1 counter'
 
 ebtables-translate -A INPUT -p 802_1Q --vlan-encap ip
-nft add rule bridge filter INPUT vlan type 0x0800 counter
+nft 'add rule bridge filter INPUT vlan type 0x0800 counter'
 
 ebtables-translate -A INPUT -p 802_1Q --vlan-encap ipv6 ! --vlan-id 1
-nft add rule bridge filter INPUT vlan id != 1 vlan type 0x86dd counter
+nft 'add rule bridge filter INPUT vlan id != 1 vlan type 0x86dd counter'
diff --git a/extensions/libip6t_LOG.txlate b/extensions/libip6t_LOG.txlate
index 2820a82c231d..29ffce72870f 100644
--- a/extensions/libip6t_LOG.txlate
+++ b/extensions/libip6t_LOG.txlate
@@ -1,8 +1,8 @@
 iptables-translate -I INPUT -j LOG
-nft insert rule ip filter INPUT counter log
+nft 'insert rule ip filter INPUT counter log'
 
 ip6tables-translate -A FORWARD -p tcp -j LOG --log-level debug
-nft add rule ip6 filter FORWARD meta l4proto tcp counter log level debug
+nft 'add rule ip6 filter FORWARD meta l4proto tcp counter log level debug'
 
 ip6tables-translate -A FORWARD -p tcp -j LOG --log-prefix "Checking log"
-nft add rule ip6 filter FORWARD meta l4proto tcp counter log prefix \"Checking log\"
+nft 'add rule ip6 filter FORWARD meta l4proto tcp counter log prefix "Checking log"'
diff --git a/extensions/libip6t_MASQUERADE.txlate b/extensions/libip6t_MASQUERADE.txlate
index a2f9808036eb..3f003477c0f5 100644
--- a/extensions/libip6t_MASQUERADE.txlate
+++ b/extensions/libip6t_MASQUERADE.txlate
@@ -1,17 +1,17 @@
 ip6tables-translate -t nat -A POSTROUTING -j MASQUERADE
-nft add rule ip6 nat POSTROUTING counter masquerade
+nft 'add rule ip6 nat POSTROUTING counter masquerade'
 
 ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10
-nft add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade to :10
+nft 'add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade to :10'
 
 ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10-20 --random
-nft add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade to :10-20 random
+nft 'add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade to :10-20 random'
 
 ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --random
-nft add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade random
+nft 'add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade random'
 
 ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --random-fully
-nft add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade fully-random
+nft 'add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade fully-random'
 
 ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --random --random-fully
-nft add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade random,fully-random
+nft 'add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade random,fully-random'
diff --git a/extensions/libip6t_REJECT.txlate b/extensions/libip6t_REJECT.txlate
index cfa35ebff693..184713d1c246 100644
--- a/extensions/libip6t_REJECT.txlate
+++ b/extensions/libip6t_REJECT.txlate
@@ -1,8 +1,8 @@
 ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT
-nft add rule ip6 filter FORWARD tcp dport 22 counter reject
+nft 'add rule ip6 filter FORWARD tcp dport 22 counter reject'
 
 ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with icmp6-reject-route
-nft add rule ip6 filter FORWARD tcp dport 22 counter reject with icmpv6 type reject-route
+nft 'add rule ip6 filter FORWARD tcp dport 22 counter reject with icmpv6 type reject-route'
 
 ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with tcp-reset
-nft add rule ip6 filter FORWARD tcp dport 22 counter reject with tcp reset
+nft 'add rule ip6 filter FORWARD tcp dport 22 counter reject with tcp reset'
diff --git a/extensions/libip6t_SNAT.txlate b/extensions/libip6t_SNAT.txlate
index 44f2fcea68f3..e5f6f7355341 100644
--- a/extensions/libip6t_SNAT.txlate
+++ b/extensions/libip6t_SNAT.txlate
@@ -1,11 +1,11 @@
 ip6tables-translate -t nat -A postrouting -o eth0 -p tcp -j SNAT --to [fec0::1234]:80
-nft add rule ip6 nat postrouting oifname "eth0" meta l4proto tcp counter snat to [fec0::1234]:80
+nft 'add rule ip6 nat postrouting oifname "eth0" meta l4proto tcp counter snat to [fec0::1234]:80'
 
 ip6tables-translate -t nat -A postrouting -o eth0 -p tcp -j SNAT --to [fec0::1234]:1-20
-nft add rule ip6 nat postrouting oifname "eth0" meta l4proto tcp counter snat to [fec0::1234]:1-20
+nft 'add rule ip6 nat postrouting oifname "eth0" meta l4proto tcp counter snat to [fec0::1234]:1-20'
 
 ip6tables-translate -t nat -A postrouting -o eth0 -p tcp -j SNAT --to [fec0::1234]:123 --random
-nft add rule ip6 nat postrouting oifname "eth0" meta l4proto tcp counter snat to [fec0::1234]:123 random
+nft 'add rule ip6 nat postrouting oifname "eth0" meta l4proto tcp counter snat to [fec0::1234]:123 random'
 
 ip6tables-translate -t nat -A postrouting -o eth0 -p tcp -j SNAT --to [fec0::1234]:123 --random-fully --persistent
-nft add rule ip6 nat postrouting oifname "eth0" meta l4proto tcp counter snat to [fec0::1234]:123 fully-random,persistent
+nft 'add rule ip6 nat postrouting oifname "eth0" meta l4proto tcp counter snat to [fec0::1234]:123 fully-random,persistent'
diff --git a/extensions/libip6t_ah.txlate b/extensions/libip6t_ah.txlate
index c6b09a2e0d26..cc33ac2718c0 100644
--- a/extensions/libip6t_ah.txlate
+++ b/extensions/libip6t_ah.txlate
@@ -1,17 +1,17 @@
 ip6tables-translate -A INPUT -m ah --ahspi 500 -j DROP
-nft add rule ip6 filter INPUT ah spi 500 counter drop
+nft 'add rule ip6 filter INPUT ah spi 500 counter drop'
 
 ip6tables-translate -A INPUT -m ah --ahspi 500:550 -j DROP
-nft add rule ip6 filter INPUT ah spi 500-550 counter drop
+nft 'add rule ip6 filter INPUT ah spi 500-550 counter drop'
 
 ip6tables-translate -A INPUT -m ah ! --ahlen 120
-nft add rule ip6 filter INPUT ah hdrlength != 120 counter
+nft 'add rule ip6 filter INPUT ah hdrlength != 120 counter'
 
 ip6tables-translate -A INPUT -m ah --ahres
-nft add rule ip6 filter INPUT ah reserved 1 counter
+nft 'add rule ip6 filter INPUT ah reserved 1 counter'
 
 ip6tables-translate -A INPUT -m ah --ahspi 500 ! --ahlen 120 -j DROP
-nft add rule ip6 filter INPUT ah spi 500 ah hdrlength != 120 counter drop
+nft 'add rule ip6 filter INPUT ah spi 500 ah hdrlength != 120 counter drop'
 
 ip6tables-translate -A INPUT -m ah --ahspi 500 --ahlen 120 --ahres -j ACCEPT
-nft add rule ip6 filter INPUT ah spi 500 ah hdrlength 120 ah reserved 1 counter accept
+nft 'add rule ip6 filter INPUT ah spi 500 ah hdrlength 120 ah reserved 1 counter accept'
diff --git a/extensions/libip6t_frag.txlate b/extensions/libip6t_frag.txlate
index e8bd9d4b2c6f..33fc0631dc79 100644
--- a/extensions/libip6t_frag.txlate
+++ b/extensions/libip6t_frag.txlate
@@ -1,17 +1,17 @@
 ip6tables-translate -t filter -A INPUT -m frag --fragid 100:200 -j ACCEPT
-nft add rule ip6 filter INPUT frag id 100-200 counter accept
+nft 'add rule ip6 filter INPUT frag id 100-200 counter accept'
 
 ip6tables-translate -t filter -A INPUT -m frag --fragid 100 --fragres --fragmore -j ACCEPT
-nft add rule ip6 filter INPUT frag id 100 frag reserved 1 frag more-fragments 1 counter accept
+nft 'add rule ip6 filter INPUT frag id 100 frag reserved 1 frag more-fragments 1 counter accept'
 
 ip6tables-translate -t filter -A INPUT -m frag ! --fragid 100:200 -j ACCEPT
-nft add rule ip6 filter INPUT frag id != 100-200 counter accept
+nft 'add rule ip6 filter INPUT frag id != 100-200 counter accept'
 
 ip6tables-translate -t filter -A INPUT -m frag --fragid 100:200 --fraglast -j ACCEPT
-nft add rule ip6 filter INPUT frag id 100-200 frag more-fragments 0 counter accept
+nft 'add rule ip6 filter INPUT frag id 100-200 frag more-fragments 0 counter accept'
 
 ip6tables-translate -t filter -A INPUT -m frag --fragid 100:200 --fragfirst -j ACCEPT
-nft add rule ip6 filter INPUT frag id 100-200 frag frag-off 0 counter accept
+nft 'add rule ip6 filter INPUT frag id 100-200 frag frag-off 0 counter accept'
 
 ip6tables-translate -t filter -A INPUT -m frag --fraglast -j ACCEPT
-nft add rule ip6 filter INPUT frag more-fragments 0 counter accept
+nft 'add rule ip6 filter INPUT frag more-fragments 0 counter accept'
diff --git a/extensions/libip6t_hbh.txlate b/extensions/libip6t_hbh.txlate
index 28101fd757eb..a753df0dfe41 100644
--- a/extensions/libip6t_hbh.txlate
+++ b/extensions/libip6t_hbh.txlate
@@ -1,5 +1,5 @@
 ip6tables-translate -t filter -A INPUT -m hbh --hbh-len 22
-nft add rule ip6 filter INPUT hbh hdrlength 22 counter
+nft 'add rule ip6 filter INPUT hbh hdrlength 22 counter'
 
 ip6tables-translate -t filter -A INPUT -m hbh ! --hbh-len 22
-nft add rule ip6 filter INPUT hbh hdrlength != 22 counter
+nft 'add rule ip6 filter INPUT hbh hdrlength != 22 counter'
diff --git a/extensions/libip6t_hl.txlate b/extensions/libip6t_hl.txlate
index 17563938fd89..9ff0df9c687a 100644
--- a/extensions/libip6t_hl.txlate
+++ b/extensions/libip6t_hl.txlate
@@ -1,5 +1,5 @@
 ip6tables-translate -t nat -A postrouting -m hl --hl-gt 3
-nft add rule ip6 nat postrouting ip6 hoplimit gt 3 counter
+nft 'add rule ip6 nat postrouting ip6 hoplimit gt 3 counter'
 
 ip6tables-translate -t nat -A postrouting -m hl ! --hl-eq 3
-nft add rule ip6 nat postrouting ip6 hoplimit != 3 counter
+nft 'add rule ip6 nat postrouting ip6 hoplimit != 3 counter'
diff --git a/extensions/libip6t_icmp6.txlate b/extensions/libip6t_icmp6.txlate
index 15481ad6fdae..324a48b9e46a 100644
--- a/extensions/libip6t_icmp6.txlate
+++ b/extensions/libip6t_icmp6.txlate
@@ -1,8 +1,8 @@
 ip6tables-translate -t filter -A INPUT -m icmp6 --icmpv6-type 1 -j LOG
-nft add rule ip6 filter INPUT icmpv6 type destination-unreachable counter log
+nft 'add rule ip6 filter INPUT icmpv6 type destination-unreachable counter log'
 
 ip6tables-translate -t filter -A INPUT -m icmp6 --icmpv6-type neighbour-advertisement -j LOG
-nft add rule ip6 filter INPUT icmpv6 type nd-neighbor-advert counter log
+nft 'add rule ip6 filter INPUT icmpv6 type nd-neighbor-advert counter log'
 
 ip6tables-translate -t filter -A INPUT -m icmp6 ! --icmpv6-type packet-too-big -j LOG
-nft add rule ip6 filter INPUT icmpv6 type != packet-too-big counter log
+nft 'add rule ip6 filter INPUT icmpv6 type != packet-too-big counter log'
diff --git a/extensions/libip6t_mh.txlate b/extensions/libip6t_mh.txlate
index f5d638c09ca8..4dfaf46a2b8d 100644
--- a/extensions/libip6t_mh.txlate
+++ b/extensions/libip6t_mh.txlate
@@ -1,5 +1,5 @@
 ip6tables-translate -A INPUT -p mh --mh-type 1 -j ACCEPT
-nft add rule ip6 filter INPUT meta l4proto mobility-header mh type 1 counter accept
+nft 'add rule ip6 filter INPUT meta l4proto mobility-header mh type 1 counter accept'
 
 ip6tables-translate -A INPUT -p mh --mh-type 1:3 -j ACCEPT
-nft add rule ip6 filter INPUT meta l4proto mobility-header mh type 1-3 counter accept
+nft 'add rule ip6 filter INPUT meta l4proto mobility-header mh type 1-3 counter accept'
diff --git a/extensions/libip6t_rt.txlate b/extensions/libip6t_rt.txlate
index 6464cf9e05a3..3578bcba0157 100644
--- a/extensions/libip6t_rt.txlate
+++ b/extensions/libip6t_rt.txlate
@@ -1,14 +1,14 @@
 ip6tables-translate -A INPUT -m rt --rt-type 0 -j DROP
-nft add rule ip6 filter INPUT rt type 0 counter drop
+nft 'add rule ip6 filter INPUT rt type 0 counter drop'
 
 ip6tables-translate -A INPUT -m rt ! --rt-len 22 -j DROP
-nft add rule ip6 filter INPUT rt hdrlength != 22 counter drop
+nft 'add rule ip6 filter INPUT rt hdrlength != 22 counter drop'
 
 ip6tables-translate -A INPUT -m rt --rt-segsleft 26 -j ACCEPT
-nft add rule ip6 filter INPUT rt seg-left 26 counter accept
+nft 'add rule ip6 filter INPUT rt seg-left 26 counter accept'
 
 ip6tables-translate -A INPUT -m rt --rt-type 0 --rt-len 22 -j DROP
-nft add rule ip6 filter INPUT rt type 0 rt hdrlength 22 counter drop
+nft 'add rule ip6 filter INPUT rt type 0 rt hdrlength 22 counter drop'
 
 ip6tables-translate -A INPUT -m rt --rt-type 0 --rt-len 22 ! --rt-segsleft 26 -j ACCEPT
-nft add rule ip6 filter INPUT rt type 0 rt seg-left != 26 rt hdrlength 22 counter accept
+nft 'add rule ip6 filter INPUT rt type 0 rt seg-left != 26 rt hdrlength 22 counter accept'
diff --git a/extensions/libipt_LOG.txlate b/extensions/libipt_LOG.txlate
index 81f64fb27094..13a2ef55a2b7 100644
--- a/extensions/libipt_LOG.txlate
+++ b/extensions/libipt_LOG.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A FORWARD -p tcp -j LOG --log-level error
-nft add rule ip filter FORWARD ip protocol tcp counter log level err
+nft 'add rule ip filter FORWARD ip protocol tcp counter log level err'
 
 iptables-translate -A FORWARD -p tcp -j LOG --log-prefix "Random prefix"
-nft add rule ip filter FORWARD ip protocol tcp counter log prefix \"Random prefix\"
+nft 'add rule ip filter FORWARD ip protocol tcp counter log prefix "Random prefix"'
diff --git a/extensions/libipt_MASQUERADE.txlate b/extensions/libipt_MASQUERADE.txlate
index 49f79d33dcfa..0293b05b9b63 100644
--- a/extensions/libipt_MASQUERADE.txlate
+++ b/extensions/libipt_MASQUERADE.txlate
@@ -1,17 +1,17 @@
 iptables-translate -t nat -A POSTROUTING -j MASQUERADE
-nft add rule ip nat POSTROUTING counter masquerade
+nft 'add rule ip nat POSTROUTING counter masquerade'
 
 iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10
-nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade to :10
+nft 'add rule ip nat POSTROUTING ip protocol tcp counter masquerade to :10'
 
 iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10-20 --random
-nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade to :10-20 random
+nft 'add rule ip nat POSTROUTING ip protocol tcp counter masquerade to :10-20 random'
 
 iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --random
-nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade random
+nft 'add rule ip nat POSTROUTING ip protocol tcp counter masquerade random'
 
 iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --random-fully
-nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade fully-random
+nft 'add rule ip nat POSTROUTING ip protocol tcp counter masquerade fully-random'
 
 iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --random --random-fully
-nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade random,fully-random
+nft 'add rule ip nat POSTROUTING ip protocol tcp counter masquerade random,fully-random'
diff --git a/extensions/libipt_REJECT.txlate b/extensions/libipt_REJECT.txlate
index a1bfb5f48dff..022166a66c08 100644
--- a/extensions/libipt_REJECT.txlate
+++ b/extensions/libipt_REJECT.txlate
@@ -1,8 +1,8 @@
 iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT
-nft add rule ip filter FORWARD tcp dport 22 counter reject
+nft 'add rule ip filter FORWARD tcp dport 22 counter reject'
 
 iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with icmp-net-unreachable
-nft add rule ip filter FORWARD tcp dport 22 counter reject with icmp type net-unreachable
+nft 'add rule ip filter FORWARD tcp dport 22 counter reject with icmp type net-unreachable'
 
 iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with tcp-reset
-nft add rule ip filter FORWARD tcp dport 22 counter reject with tcp reset
+nft 'add rule ip filter FORWARD tcp dport 22 counter reject with tcp reset'
diff --git a/extensions/libipt_SNAT.txlate b/extensions/libipt_SNAT.txlate
index 01592fad01a2..83afef9541de 100644
--- a/extensions/libipt_SNAT.txlate
+++ b/extensions/libipt_SNAT.txlate
@@ -1,14 +1,14 @@
 iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4
-nft add rule ip nat postrouting oifname "eth0" counter snat to 1.2.3.4
+nft 'add rule ip nat postrouting oifname "eth0" counter snat to 1.2.3.4'
 
 iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4-1.2.3.6
-nft add rule ip nat postrouting oifname "eth0" counter snat to 1.2.3.4-1.2.3.6
+nft 'add rule ip nat postrouting oifname "eth0" counter snat to 1.2.3.4-1.2.3.6'
 
 iptables-translate -t nat -A postrouting -p tcp -o eth0 -j SNAT --to 1.2.3.4:1-1023
-nft add rule ip nat postrouting oifname "eth0" ip protocol tcp counter snat to 1.2.3.4:1-1023
+nft 'add rule ip nat postrouting oifname "eth0" ip protocol tcp counter snat to 1.2.3.4:1-1023'
 
 iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4 --random
-nft add rule ip nat postrouting oifname "eth0" counter snat to 1.2.3.4 random
+nft 'add rule ip nat postrouting oifname "eth0" counter snat to 1.2.3.4 random'
 
 iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4 --random --persistent
-nft add rule ip nat postrouting oifname "eth0" counter snat to 1.2.3.4 random,persistent
+nft 'add rule ip nat postrouting oifname "eth0" counter snat to 1.2.3.4 random,persistent'
diff --git a/extensions/libipt_ah.txlate b/extensions/libipt_ah.txlate
index ea3ef3e9adf5..897c82b5f95c 100644
--- a/extensions/libipt_ah.txlate
+++ b/extensions/libipt_ah.txlate
@@ -1,8 +1,8 @@
 iptables-translate -A INPUT -p 51 -m ah --ahspi 500 -j DROP
-nft add rule ip filter INPUT ah spi 500 counter drop
+nft 'add rule ip filter INPUT ah spi 500 counter drop'
 
 iptables-translate -A INPUT -p 51 -m ah --ahspi 500:600 -j DROP
-nft add rule ip filter INPUT ah spi 500-600 counter drop
+nft 'add rule ip filter INPUT ah spi 500-600 counter drop'
 
 iptables-translate -A INPUT -p 51 -m ah ! --ahspi 50 -j DROP
-nft add rule ip filter INPUT ah spi != 50 counter drop
+nft 'add rule ip filter INPUT ah spi != 50 counter drop'
diff --git a/extensions/libipt_icmp.txlate b/extensions/libipt_icmp.txlate
index a2aec8e26df7..e7208d8b874c 100644
--- a/extensions/libipt_icmp.txlate
+++ b/extensions/libipt_icmp.txlate
@@ -1,11 +1,11 @@
 iptables-translate -t filter -A INPUT -m icmp --icmp-type echo-reply -j ACCEPT
-nft add rule ip filter INPUT icmp type echo-reply counter accept
+nft 'add rule ip filter INPUT icmp type echo-reply counter accept'
 
 iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j ACCEPT
-nft add rule ip filter INPUT icmp type destination-unreachable counter accept
+nft 'add rule ip filter INPUT icmp type destination-unreachable counter accept'
 
 iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j ACCEPT
-nft add rule ip filter INPUT icmp type != destination-unreachable counter accept
+nft 'add rule ip filter INPUT icmp type != destination-unreachable counter accept'
 
 iptables-translate -t filter -A INPUT -m icmp --icmp-type any -j ACCEPT
-nft add rule ip filter INPUT ip protocol icmp counter accept
+nft 'add rule ip filter INPUT ip protocol icmp counter accept'
diff --git a/extensions/libipt_realm.txlate b/extensions/libipt_realm.txlate
index 7d7102945511..6d134546cd05 100644
--- a/extensions/libipt_realm.txlate
+++ b/extensions/libipt_realm.txlate
@@ -1,11 +1,11 @@
 iptables-translate -A PREROUTING -m realm --realm 4
-nft add rule ip filter PREROUTING rtclassid 0x4 counter
+nft 'add rule ip filter PREROUTING rtclassid 0x4 counter'
 
 iptables-translate -A PREROUTING -m realm --realm 5/5
-nft add rule ip filter PREROUTING rtclassid and 0x5 == 0x5 counter
+nft 'add rule ip filter PREROUTING rtclassid and 0x5 == 0x5 counter'
 
 iptables-translate -A PREROUTING -m realm ! --realm 50
-nft add rule ip filter PREROUTING rtclassid != 0x32 counter
+nft 'add rule ip filter PREROUTING rtclassid != 0x32 counter'
 
 iptables-translate -A INPUT -m realm --realm 1/0xf
-nft add rule ip filter INPUT rtclassid and 0xf == 0x1 counter
+nft 'add rule ip filter INPUT rtclassid and 0xf == 0x1 counter'
diff --git a/extensions/libipt_ttl.txlate b/extensions/libipt_ttl.txlate
index 3d5d6a70da55..6b90ff99ce57 100644
--- a/extensions/libipt_ttl.txlate
+++ b/extensions/libipt_ttl.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A INPUT -m ttl --ttl-eq 3 -j ACCEPT
-nft add rule ip filter INPUT ip ttl 3 counter accept
+nft 'add rule ip filter INPUT ip ttl 3 counter accept'
 
 iptables-translate -A INPUT -m ttl --ttl-gt 5 -j ACCEPT
-nft add rule ip filter INPUT ip ttl gt 5 counter accept
+nft 'add rule ip filter INPUT ip ttl gt 5 counter accept'
diff --git a/extensions/libxt_AUDIT.txlate b/extensions/libxt_AUDIT.txlate
index abd11eaeb0a2..c1650b9acdef 100644
--- a/extensions/libxt_AUDIT.txlate
+++ b/extensions/libxt_AUDIT.txlate
@@ -1,8 +1,8 @@
 iptables-translate -t filter -A INPUT -j AUDIT --type accept
-nft add rule ip filter INPUT counter log level audit
+nft 'add rule ip filter INPUT counter log level audit'
 
 iptables-translate -t filter -A INPUT -j AUDIT --type drop
-nft add rule ip filter INPUT counter log level audit
+nft 'add rule ip filter INPUT counter log level audit'
 
 iptables-translate -t filter -A INPUT -j AUDIT --type reject
-nft add rule ip filter INPUT counter log level audit
+nft 'add rule ip filter INPUT counter log level audit'
diff --git a/extensions/libxt_CLASSIFY.txlate b/extensions/libxt_CLASSIFY.txlate
index 3b349237231d..3150c69ed062 100644
--- a/extensions/libxt_CLASSIFY.txlate
+++ b/extensions/libxt_CLASSIFY.txlate
@@ -1,8 +1,8 @@
 iptables-translate -A OUTPUT -j CLASSIFY --set-class 0:0
-nft add rule ip filter OUTPUT counter meta priority set none
+nft 'add rule ip filter OUTPUT counter meta priority set none'
 
 iptables-translate -A OUTPUT -j CLASSIFY --set-class ffff:ffff
-nft add rule ip filter OUTPUT counter meta priority set root
+nft 'add rule ip filter OUTPUT counter meta priority set root'
 
 iptables-translate -A OUTPUT -j CLASSIFY --set-class 1:234
-nft add rule ip filter OUTPUT counter meta priority set 1:234
+nft 'add rule ip filter OUTPUT counter meta priority set 1:234'
diff --git a/extensions/libxt_CONNMARK.txlate b/extensions/libxt_CONNMARK.txlate
index 99627c2b05d4..5da4d6c7ee08 100644
--- a/extensions/libxt_CONNMARK.txlate
+++ b/extensions/libxt_CONNMARK.txlate
@@ -1,23 +1,23 @@
 iptables-translate -t mangle -A PREROUTING -j CONNMARK --set-mark 0
-nft add rule ip mangle PREROUTING counter ct mark set 0x0
+nft 'add rule ip mangle PREROUTING counter ct mark set 0x0'
 
 iptables-translate -t mangle -A PREROUTING -j CONNMARK --set-mark 0x16
-nft add rule ip mangle PREROUTING counter ct mark set 0x16
+nft 'add rule ip mangle PREROUTING counter ct mark set 0x16'
 
 iptables-translate -t mangle -A PREROUTING -j CONNMARK --set-xmark 0x16/0x12
-nft add rule ip mangle PREROUTING counter ct mark set ct mark xor 0x16 and 0xffffffed
+nft 'add rule ip mangle PREROUTING counter ct mark set ct mark xor 0x16 and 0xffffffed'
 
 iptables-translate -t mangle -A PREROUTING -j CONNMARK --and-mark 0x16
-nft add rule ip mangle PREROUTING counter ct mark set ct mark and 0x16
+nft 'add rule ip mangle PREROUTING counter ct mark set ct mark and 0x16'
 
 iptables-translate -t mangle -A PREROUTING -j CONNMARK --or-mark 0x16
-nft add rule ip mangle PREROUTING counter ct mark set ct mark or 0x16
+nft 'add rule ip mangle PREROUTING counter ct mark set ct mark or 0x16'
 
 iptables-translate -t mangle -A PREROUTING -j CONNMARK --save-mark
-nft add rule ip mangle PREROUTING counter ct mark set mark
+nft 'add rule ip mangle PREROUTING counter ct mark set mark'
 
 iptables-translate -t mangle -A PREROUTING -j CONNMARK --restore-mark
-nft add rule ip mangle PREROUTING counter meta mark set ct mark
+nft 'add rule ip mangle PREROUTING counter meta mark set ct mark'
 
 iptables-translate -t mangle -A PREROUTING  -j CONNMARK --set-mark 0x23/0x42 --right-shift-mark 5
-nft add rule ip mangle PREROUTING counter ct mark set ( ct mark xor 0x23 and 0xffffff9c ) >> 5
+nft 'add rule ip mangle PREROUTING counter ct mark set ( ct mark xor 0x23 and 0xffffff9c ) >> 5'
diff --git a/extensions/libxt_DNAT.txlate b/extensions/libxt_DNAT.txlate
index a65976562ef5..e005245d6bb4 100644
--- a/extensions/libxt_DNAT.txlate
+++ b/extensions/libxt_DNAT.txlate
@@ -1,35 +1,35 @@
 iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4
-nft add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4
+nft 'add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4'
 
 iptables-translate -t nat -A prerouting -p tcp -d 15.45.23.67 --dport 80 -j DNAT --to-destination 192.168.1.1-192.168.1.10
-nft add rule ip nat prerouting ip daddr 15.45.23.67 tcp dport 80 counter dnat to 192.168.1.1-192.168.1.10
+nft 'add rule ip nat prerouting ip daddr 15.45.23.67 tcp dport 80 counter dnat to 192.168.1.1-192.168.1.10'
 
 iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4:1-1023
-nft add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4:1-1023
+nft 'add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4:1-1023'
 
 iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4 --random
-nft add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4 random
+nft 'add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4 random'
 
 iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4 --random --persistent
-nft add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4 random,persistent
+nft 'add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4 random,persistent'
 
 ip6tables-translate -t nat -A prerouting -p tcp --dport 8080 -j DNAT --to-destination fec0::1234
-nft add rule ip6 nat prerouting tcp dport 8080 counter dnat to fec0::1234
+nft 'add rule ip6 nat prerouting tcp dport 8080 counter dnat to fec0::1234'
 
 ip6tables-translate -t nat -A prerouting -p tcp --dport 8080 -j DNAT --to-destination fec0::1234-fec0::2000
-nft add rule ip6 nat prerouting tcp dport 8080 counter dnat to fec0::1234-fec0::2000
+nft 'add rule ip6 nat prerouting tcp dport 8080 counter dnat to fec0::1234-fec0::2000'
 
 ip6tables-translate -t nat -A prerouting -i eth1 -p tcp --dport 8080 -j DNAT --to-destination [fec0::1234]:80
-nft add rule ip6 nat prerouting iifname "eth1" tcp dport 8080 counter dnat to [fec0::1234]:80
+nft 'add rule ip6 nat prerouting iifname "eth1" tcp dport 8080 counter dnat to [fec0::1234]:80'
 
 ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:1-20
-nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:1-20
+nft 'add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:1-20'
 
 ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234-fec0::2000]:1-20
-nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234-fec0::2000]:1-20
+nft 'add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234-fec0::2000]:1-20'
 
 ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:80 --persistent
-nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:80 persistent
+nft 'add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:80 persistent'
 
 ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:80 --random --persistent
-nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:80 random,persistent
+nft 'add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:80 random,persistent'
diff --git a/extensions/libxt_DSCP.txlate b/extensions/libxt_DSCP.txlate
index 442742ef9984..f7801a836215 100644
--- a/extensions/libxt_DSCP.txlate
+++ b/extensions/libxt_DSCP.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A OUTPUT -j DSCP --set-dscp 1
-nft add rule ip filter OUTPUT counter ip dscp set 0x01
+nft 'add rule ip filter OUTPUT counter ip dscp set 0x01'
 
 ip6tables-translate -A OUTPUT -j DSCP --set-dscp 6
-nft add rule ip6 filter OUTPUT counter ip6 dscp set 0x06
+nft 'add rule ip6 filter OUTPUT counter ip6 dscp set 0x06'
diff --git a/extensions/libxt_MARK.txlate b/extensions/libxt_MARK.txlate
index d3250ab6c2e1..36ee7a3b8f18 100644
--- a/extensions/libxt_MARK.txlate
+++ b/extensions/libxt_MARK.txlate
@@ -1,26 +1,26 @@
 iptables-translate -t mangle -A OUTPUT -j MARK --set-mark 0
-nft add rule ip mangle OUTPUT counter meta mark set 0x0
+nft 'add rule ip mangle OUTPUT counter meta mark set 0x0'
 
 iptables-translate -t mangle -A OUTPUT -j MARK --set-mark 64
-nft add rule ip mangle OUTPUT counter meta mark set 0x40
+nft 'add rule ip mangle OUTPUT counter meta mark set 0x40'
 
 iptables-translate -t mangle -A OUTPUT -j MARK --set-xmark 0x40/0x32
-nft add rule ip mangle OUTPUT counter meta mark set mark and 0xffffffcd xor 0x40
+nft 'add rule ip mangle OUTPUT counter meta mark set mark and 0xffffffcd xor 0x40'
 
 iptables-translate -t mangle -A OUTPUT -j MARK --or-mark 64
-nft add rule ip mangle OUTPUT counter meta mark set mark or 0x40
+nft 'add rule ip mangle OUTPUT counter meta mark set mark or 0x40'
 
 iptables-translate -t mangle -A OUTPUT -j MARK --and-mark 64
-nft add rule ip mangle OUTPUT counter meta mark set mark and 0x40
+nft 'add rule ip mangle OUTPUT counter meta mark set mark and 0x40'
 
 iptables-translate -t mangle -A OUTPUT -j MARK --xor-mark 64
-nft add rule ip mangle OUTPUT counter meta mark set mark xor 0x40
+nft 'add rule ip mangle OUTPUT counter meta mark set mark xor 0x40'
 
 iptables-translate -t mangle -A PREROUTING -j MARK --set-mark 0x64
-nft add rule ip mangle PREROUTING counter meta mark set 0x64
+nft 'add rule ip mangle PREROUTING counter meta mark set 0x64'
 
 iptables-translate -t mangle -A PREROUTING -j MARK --and-mark 0x64
-nft add rule ip mangle PREROUTING counter meta mark set mark and 0x64
+nft 'add rule ip mangle PREROUTING counter meta mark set mark and 0x64'
 
 iptables-translate -t mangle -A PREROUTING -j MARK --or-mark 0x64
-nft add rule ip mangle PREROUTING counter meta mark set mark or 0x64
+nft 'add rule ip mangle PREROUTING counter meta mark set mark or 0x64'
diff --git a/extensions/libxt_NFLOG.txlate b/extensions/libxt_NFLOG.txlate
index a0872c9e7ce5..ebd81be39e85 100644
--- a/extensions/libxt_NFLOG.txlate
+++ b/extensions/libxt_NFLOG.txlate
@@ -1,14 +1,14 @@
 iptables-translate -A FORWARD -j NFLOG --nflog-group 32 --nflog-prefix "Prefix 1.0"
-nft add rule ip filter FORWARD counter log prefix \"Prefix 1.0\" group 32
+nft 'add rule ip filter FORWARD counter log prefix "Prefix 1.0" group 32'
 
 iptables-translate -A OUTPUT -j NFLOG --nflog-group 30
-nft add rule ip filter OUTPUT counter log group 30
+nft 'add rule ip filter OUTPUT counter log group 30'
 
 iptables-translate -I INPUT -j NFLOG --nflog-threshold 2
-nft insert rule ip filter INPUT counter log queue-threshold 2 group 0
+nft 'insert rule ip filter INPUT counter log queue-threshold 2 group 0'
 
 iptables-translate -I INPUT -j NFLOG --nflog-size 256
-nft insert rule ip filter INPUT counter log snaplen 256 group 0
+nft 'insert rule ip filter INPUT counter log snaplen 256 group 0'
 
 iptables-translate -I INPUT -j NFLOG --nflog-threshold 25
-nft insert rule ip filter INPUT counter log queue-threshold 25 group 0
+nft 'insert rule ip filter INPUT counter log queue-threshold 25 group 0'
diff --git a/extensions/libxt_NFQUEUE.txlate b/extensions/libxt_NFQUEUE.txlate
index 3d188a7a86a7..3698dcbc9e5b 100644
--- a/extensions/libxt_NFQUEUE.txlate
+++ b/extensions/libxt_NFQUEUE.txlate
@@ -1,8 +1,8 @@
 iptables-translate -t nat -A PREROUTING -p tcp --dport 80 -j NFQUEUE --queue-num 30
-nft add rule ip nat PREROUTING tcp dport 80 counter queue num 30
+nft 'add rule ip nat PREROUTING tcp dport 80 counter queue num 30'
 
 iptables-translate -A FORWARD -j NFQUEUE --queue-num 0 --queue-bypass -p TCP --sport 80
-nft add rule ip filter FORWARD tcp sport 80 counter queue num 0 bypass
+nft 'add rule ip filter FORWARD tcp sport 80 counter queue num 0 bypass'
 
 iptables-translate -A FORWARD -j NFQUEUE --queue-bypass -p TCP --sport 80 --queue-balance 0:3 --queue-cpu-fanout
-nft add rule ip filter FORWARD tcp sport 80 counter queue num 0-3 bypass,fanout
+nft 'add rule ip filter FORWARD tcp sport 80 counter queue num 0-3 bypass,fanout'
diff --git a/extensions/libxt_NOTRACK.txlate b/extensions/libxt_NOTRACK.txlate
index 9d35619d3dbd..9490ee8f54a8 100644
--- a/extensions/libxt_NOTRACK.txlate
+++ b/extensions/libxt_NOTRACK.txlate
@@ -1,2 +1,2 @@
 iptables-translate -A PREROUTING -t raw -j NOTRACK
-nft add rule ip raw PREROUTING counter notrack
+nft 'add rule ip raw PREROUTING counter notrack'
diff --git a/extensions/libxt_REDIRECT.txlate b/extensions/libxt_REDIRECT.txlate
index 36419a46bb36..dc4733403836 100644
--- a/extensions/libxt_REDIRECT.txlate
+++ b/extensions/libxt_REDIRECT.txlate
@@ -1,29 +1,29 @@
 iptables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT
-nft add rule ip nat prerouting tcp dport 80 counter redirect
+nft 'add rule ip nat prerouting tcp dport 80 counter redirect'
 
 iptables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 0
-nft add rule ip nat prerouting tcp dport 80 counter redirect to :0
+nft 'add rule ip nat prerouting tcp dport 80 counter redirect to :0'
 
 iptables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080
-nft add rule ip nat prerouting tcp dport 80 counter redirect to :8080
+nft 'add rule ip nat prerouting tcp dport 80 counter redirect to :8080'
 
 iptables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 0-65535
-nft add rule ip nat prerouting tcp dport 80 counter redirect to :0-65535
+nft 'add rule ip nat prerouting tcp dport 80 counter redirect to :0-65535'
 
 iptables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 10-22
-nft add rule ip nat prerouting tcp dport 80 counter redirect to :10-22
+nft 'add rule ip nat prerouting tcp dport 80 counter redirect to :10-22'
 
 iptables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080 --random
-nft add rule ip nat prerouting tcp dport 80 counter redirect to :8080 random
+nft 'add rule ip nat prerouting tcp dport 80 counter redirect to :8080 random'
 
 iptables-translate -t nat -A prerouting -j REDIRECT --random
-nft add rule ip nat prerouting counter redirect random
+nft 'add rule ip nat prerouting counter redirect random'
 
 ip6tables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT
-nft add rule ip6 nat prerouting tcp dport 80 counter redirect
+nft 'add rule ip6 nat prerouting tcp dport 80 counter redirect'
 
 ip6tables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080
-nft add rule ip6 nat prerouting tcp dport 80 counter redirect to :8080
+nft 'add rule ip6 nat prerouting tcp dport 80 counter redirect to :8080'
 
 ip6tables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080 --random
-nft add rule ip6 nat prerouting tcp dport 80 counter redirect to :8080 random
+nft 'add rule ip6 nat prerouting tcp dport 80 counter redirect to :8080 random'
diff --git a/extensions/libxt_SYNPROXY.txlate b/extensions/libxt_SYNPROXY.txlate
index b3de2b2a8c9d..a0954f640f2b 100644
--- a/extensions/libxt_SYNPROXY.txlate
+++ b/extensions/libxt_SYNPROXY.txlate
@@ -1,2 +1,2 @@
 iptables-translate -t mangle -A INPUT -i iifname -p tcp -m tcp --dport 80 -m state --state INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
-nft add rule ip mangle INPUT iifname "iifname" tcp dport 80 ct state invalid,untracked  counter synproxy sack-perm timestamp wscale 7 mss 1460
+nft 'add rule ip mangle INPUT iifname "iifname" tcp dport 80 ct state invalid,untracked  counter synproxy sack-perm timestamp wscale 7 mss 1460'
diff --git a/extensions/libxt_TCPMSS.txlate b/extensions/libxt_TCPMSS.txlate
index 3dbbad66c560..a059c6027280 100644
--- a/extensions/libxt_TCPMSS.txlate
+++ b/extensions/libxt_TCPMSS.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
-nft add rule ip filter FORWARD tcp flags syn / syn,rst counter tcp option maxseg size set rt mtu
+nft 'add rule ip filter FORWARD tcp flags syn / syn,rst counter tcp option maxseg size set rt mtu'
 
 iptables-translate -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 90
-nft add rule ip filter FORWARD tcp flags syn / syn,rst counter tcp option maxseg size set 90
+nft 'add rule ip filter FORWARD tcp flags syn / syn,rst counter tcp option maxseg size set 90'
diff --git a/extensions/libxt_TEE.txlate b/extensions/libxt_TEE.txlate
index 9fcee254b6b0..fa1d5fe31579 100644
--- a/extensions/libxt_TEE.txlate
+++ b/extensions/libxt_TEE.txlate
@@ -1,11 +1,11 @@
 # iptables-translate -t mangle -A PREROUTING -j TEE --gateway 192.168.0.2 --oif eth0
-# nft add rule ip mangle PREROUTING counter dup to 192.168.0.2 device eth0
+# nft 'add rule ip mangle PREROUTING counter dup to 192.168.0.2 device eth0
 #
 # iptables-translate -t mangle -A PREROUTING -j TEE --gateway 192.168.0.2
-# nft add rule ip mangle PREROUTING counter dup to 192.168.0.2
+# nft 'add rule ip mangle PREROUTING counter dup to 192.168.0.2
 
 ip6tables-translate -t mangle -A PREROUTING -j TEE --gateway ab12:00a1:1112:acba::
-nft add rule ip6 mangle PREROUTING counter dup to ab12:a1:1112:acba::
+nft 'add rule ip6 mangle PREROUTING counter dup to ab12:a1:1112:acba::'
 
 ip6tables-translate -t mangle -A PREROUTING -j TEE --gateway ab12:00a1:1112:acba:: --oif eth0
-nft add rule ip6 mangle PREROUTING counter dup to ab12:a1:1112:acba:: device eth0
+nft 'add rule ip6 mangle PREROUTING counter dup to ab12:a1:1112:acba:: device eth0'
diff --git a/extensions/libxt_TOS.txlate b/extensions/libxt_TOS.txlate
index 9c1267429935..37ef1d86afac 100644
--- a/extensions/libxt_TOS.txlate
+++ b/extensions/libxt_TOS.txlate
@@ -1,26 +1,26 @@
 ip6tables-translate -A INPUT -j TOS --set-tos 0x1f
-nft add rule ip6 filter INPUT counter ip6 dscp set 0x07
+nft 'add rule ip6 filter INPUT counter ip6 dscp set 0x07'
 
 ip6tables-translate -A INPUT -j TOS --set-tos 0xff
-nft add rule ip6 filter INPUT counter ip6 dscp set 0x3f
+nft 'add rule ip6 filter INPUT counter ip6 dscp set 0x3f'
 
 ip6tables-translate -A INPUT -j TOS --set-tos Minimize-Delay
-nft add rule ip6 filter INPUT counter ip6 dscp set 0x04
+nft 'add rule ip6 filter INPUT counter ip6 dscp set 0x04'
 
 ip6tables-translate -A INPUT -j TOS --set-tos Minimize-Cost
-nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
+nft 'add rule ip6 filter INPUT counter ip6 dscp set 0x00'
 
 ip6tables-translate -A INPUT -j TOS --set-tos Normal-Service
-nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
+nft 'add rule ip6 filter INPUT counter ip6 dscp set 0x00'
 
 ip6tables-translate -A INPUT -j TOS --and-tos 0x12
-nft add rule ip6 filter INPUT counter ip6 dscp set ip6 dscp and 0x04
+nft 'add rule ip6 filter INPUT counter ip6 dscp set ip6 dscp and 0x04'
 
 ip6tables-translate -A INPUT -j TOS --or-tos 0x12
-nft add rule ip6 filter INPUT counter ip6 dscp set ip6 dscp or 0x04
+nft 'add rule ip6 filter INPUT counter ip6 dscp set ip6 dscp or 0x04'
 
 ip6tables-translate -A INPUT -j TOS --xor-tos 0x12
-nft add rule ip6 filter INPUT counter ip6 dscp set ip6 dscp xor 0x04
+nft 'add rule ip6 filter INPUT counter ip6 dscp set ip6 dscp xor 0x04'
 
 ip6tables-translate -A INPUT -j TOS --set-tos 0x12/0x34
-nft add rule ip6 filter INPUT counter ip6 dscp set ip6 dscp and 0x32 xor 0x04
+nft 'add rule ip6 filter INPUT counter ip6 dscp set ip6 dscp and 0x32 xor 0x04'
diff --git a/extensions/libxt_TRACE.txlate b/extensions/libxt_TRACE.txlate
index 8e3d2a7a2986..a9d28fe0e623 100644
--- a/extensions/libxt_TRACE.txlate
+++ b/extensions/libxt_TRACE.txlate
@@ -1,2 +1,2 @@
 iptables-translate -t raw -A PREROUTING -j TRACE
-nft add rule ip raw PREROUTING counter nftrace set 1
+nft 'add rule ip raw PREROUTING counter nftrace set 1'
diff --git a/extensions/libxt_addrtype.txlate b/extensions/libxt_addrtype.txlate
index a719b2c92a66..70c0a345e668 100644
--- a/extensions/libxt_addrtype.txlate
+++ b/extensions/libxt_addrtype.txlate
@@ -1,11 +1,11 @@
 iptables-translate -A INPUT -m addrtype --src-type LOCAL
-nft add rule ip filter INPUT fib saddr type local counter
+nft 'add rule ip filter INPUT fib saddr type local counter'
 
 iptables-translate -A INPUT -m addrtype --dst-type LOCAL
-nft add rule ip filter INPUT fib daddr type local counter
+nft 'add rule ip filter INPUT fib daddr type local counter'
 
 iptables-translate -A INPUT -m addrtype ! --dst-type ANYCAST,LOCAL
-nft add rule ip filter INPUT fib daddr type != { local, anycast } counter
+nft 'add rule ip filter INPUT fib daddr type != { local, anycast } counter'
 
 iptables-translate -A INPUT -m addrtype --limit-iface-in --dst-type ANYCAST,LOCAL
-nft add rule ip filter INPUT fib daddr . iif type { local, anycast } counter
+nft 'add rule ip filter INPUT fib daddr . iif type { local, anycast } counter'
diff --git a/extensions/libxt_cgroup.txlate b/extensions/libxt_cgroup.txlate
index 75f2e6ae16fe..6e3aab7647aa 100644
--- a/extensions/libxt_cgroup.txlate
+++ b/extensions/libxt_cgroup.txlate
@@ -1,5 +1,5 @@
 iptables-translate -t filter -A INPUT -m cgroup --cgroup 0 -j ACCEPT
-nft add rule ip filter INPUT meta cgroup 0 counter accept
+nft 'add rule ip filter INPUT meta cgroup 0 counter accept'
 
 iptables-translate -t filter -A INPUT -m cgroup ! --cgroup 0 -j ACCEPT
-nft add rule ip filter INPUT meta cgroup != 0 counter accept
+nft 'add rule ip filter INPUT meta cgroup != 0 counter accept'
diff --git a/extensions/libxt_cluster.txlate b/extensions/libxt_cluster.txlate
index 9dcf57079eee..4dc1c691cf86 100644
--- a/extensions/libxt_cluster.txlate
+++ b/extensions/libxt_cluster.txlate
@@ -1,26 +1,26 @@
 iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-node 1 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
-nft add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 2 seed 0xdeadbeef eq 1 meta pkttype set host counter meta mark set 0xffff
+nft 'add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 2 seed 0xdeadbeef eq 1 meta pkttype set host counter meta mark set 0xffff'
 
 iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 1 --cluster-local-node 1 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
-nft add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 1 seed 0xdeadbeef eq 1 meta pkttype set host counter meta mark set 0xffff
+nft 'add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 1 seed 0xdeadbeef eq 1 meta pkttype set host counter meta mark set 0xffff'
 
 iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-nodemask 1 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
-nft add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 2 seed 0xdeadbeef eq 1 meta pkttype set host counter meta mark set 0xffff
+nft 'add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 2 seed 0xdeadbeef eq 1 meta pkttype set host counter meta mark set 0xffff'
 
 iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 1 --cluster-local-nodemask 1 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
-nft add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 1 seed 0xdeadbeef eq 1 meta pkttype set host counter meta mark set 0xffff
+nft 'add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 1 seed 0xdeadbeef eq 1 meta pkttype set host counter meta mark set 0xffff'
 
 iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 32 --cluster-local-node 32 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
-nft add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 32 seed 0xdeadbeef eq 32 meta pkttype set host counter meta mark set 0xffff
+nft 'add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 32 seed 0xdeadbeef eq 32 meta pkttype set host counter meta mark set 0xffff'
 
 iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 32 --cluster-local-nodemask 32 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
-nft add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 32 seed 0xdeadbeef eq 6 meta pkttype set host counter meta mark set 0xffff
+nft 'add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 32 seed 0xdeadbeef eq 6 meta pkttype set host counter meta mark set 0xffff'
 
 iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 32 --cluster-local-nodemask 5 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
-nft add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 32 seed 0xdeadbeef { 0, 2 } meta pkttype set host counter meta mark set 0xffff
+nft 'add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 32 seed 0xdeadbeef { 0, 2 } meta pkttype set host counter meta mark set 0xffff'
 
 iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 7 --cluster-local-nodemask 9 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
-nft add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 7 seed 0xdeadbeef { 0, 3 } meta pkttype set host counter meta mark set 0xffff
+nft 'add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 7 seed 0xdeadbeef { 0, 3 } meta pkttype set host counter meta mark set 0xffff'
 
 iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 7 --cluster-local-node 5 --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
-nft add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 7 seed 0xdeadbeef eq 5 meta pkttype set host counter meta mark set 0xffff
+nft 'add rule ip mangle PREROUTING iifname "eth1" jhash ct original saddr mod 7 seed 0xdeadbeef eq 5 meta pkttype set host counter meta mark set 0xffff'
diff --git a/extensions/libxt_comment.txlate b/extensions/libxt_comment.txlate
index c610b0e57a9d..5d4ce59dda5a 100644
--- a/extensions/libxt_comment.txlate
+++ b/extensions/libxt_comment.txlate
@@ -1,8 +1,8 @@
 iptables-translate -A INPUT -s 192.168.0.0 -m comment --comment "A privatized IP block"
-nft add rule ip filter INPUT ip saddr 192.168.0.0 counter comment \"A privatized IP block\"
+nft 'add rule ip filter INPUT ip saddr 192.168.0.0 counter comment "A privatized IP block"'
 
 iptables-translate -A INPUT -p tcp -m tcp --sport http -s  192.168.0.0/16 -d 192.168.0.0/16 -j LONGNACCEPT -m comment --comment "foobar"
-nft add rule ip filter INPUT ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter jump LONGNACCEPT comment \"foobar\"
+nft 'add rule ip filter INPUT ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter jump LONGNACCEPT comment "foobar"'
 
 iptables-translate -A FORWARD -p tcp -m tcp --sport http -s 192.168.0.0/16 -d 192.168.0.0/16 -j DROP -m comment --comment singlecomment
-nft add rule ip filter FORWARD ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter drop comment \"singlecomment\"
+nft 'add rule ip filter FORWARD ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter drop comment "singlecomment"'
diff --git a/extensions/libxt_connbytes.txlate b/extensions/libxt_connbytes.txlate
index f78958d2399c..a6af1b87b310 100644
--- a/extensions/libxt_connbytes.txlate
+++ b/extensions/libxt_connbytes.txlate
@@ -1,14 +1,14 @@
 iptables-translate -A OUTPUT -m connbytes --connbytes 200 --connbytes-dir original --connbytes-mode packets
-nft add rule ip filter OUTPUT ct original packets ge 200 counter
+nft 'add rule ip filter OUTPUT ct original packets ge 200 counter'
 
 iptables-translate -A OUTPUT -m connbytes ! --connbytes 200 --connbytes-dir reply --connbytes-mode packets
-nft add rule ip filter OUTPUT ct reply packets lt 200 counter
+nft 'add rule ip filter OUTPUT ct reply packets lt 200 counter'
 
 iptables-translate -A OUTPUT -m connbytes --connbytes 200:600 --connbytes-dir both --connbytes-mode bytes
-nft add rule ip filter OUTPUT ct bytes 200-600 counter
+nft 'add rule ip filter OUTPUT ct bytes 200-600 counter'
 
 iptables-translate -A OUTPUT -m connbytes ! --connbytes 200:600 --connbytes-dir both --connbytes-mode bytes
-nft add rule ip filter OUTPUT ct bytes != 200-600 counter
+nft 'add rule ip filter OUTPUT ct bytes != 200-600 counter'
 
 iptables-translate -A OUTPUT -m connbytes --connbytes 200:200 --connbytes-dir both --connbytes-mode avgpkt
-nft add rule ip filter OUTPUT ct avgpkt 200 counter
+nft 'add rule ip filter OUTPUT ct avgpkt 200 counter'
diff --git a/extensions/libxt_connlabel.txlate b/extensions/libxt_connlabel.txlate
index 12e4ac035110..cba01d2dd527 100644
--- a/extensions/libxt_connlabel.txlate
+++ b/extensions/libxt_connlabel.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A INPUT -m connlabel --label 40
-nft add rule ip filter INPUT ct label 40 counter
+nft 'add rule ip filter INPUT ct label 40 counter'
 
 iptables-translate -A INPUT -m connlabel ! --label 40 --set
-nft add rule ip filter INPUT ct label set 40 ct label and 40 != 40 counter
+nft 'add rule ip filter INPUT ct label set 40 ct label and 40 != 40 counter'
diff --git a/extensions/libxt_connlimit.txlate b/extensions/libxt_connlimit.txlate
index 758868c4436c..3108a529fdb5 100644
--- a/extensions/libxt_connlimit.txlate
+++ b/extensions/libxt_connlimit.txlate
@@ -1,15 +1,15 @@
 iptables-translate -A INPUT -m connlimit --connlimit-above 2
-nft add set ip filter connlimit0 { type ipv4_addr; flags dynamic; }
-nft add rule ip filter INPUT add @connlimit0 { ip saddr ct count over 2 } counter
+nft 'add set ip filter connlimit0 { type ipv4_addr; flags dynamic; }'
+nft 'add rule ip filter INPUT add @connlimit0 { ip saddr ct count over 2 } counter'
 
 iptables-translate -A INPUT -m connlimit --connlimit-upto 2
-nft add set ip filter connlimit0 { type ipv4_addr; flags dynamic; }
-nft add rule ip filter INPUT add @connlimit0 { ip saddr ct count 2 } counter
+nft 'add set ip filter connlimit0 { type ipv4_addr; flags dynamic; }'
+nft 'add rule ip filter INPUT add @connlimit0 { ip saddr ct count 2 } counter'
 
 iptables-translate -A INPUT -m connlimit --connlimit-upto 2 --connlimit-mask 24
-nft add set ip filter connlimit0 { type ipv4_addr; flags dynamic; }
-nft add rule ip filter INPUT add @connlimit0 { ip saddr and 255.255.255.0 ct count 2 } counter
+nft 'add set ip filter connlimit0 { type ipv4_addr; flags dynamic; }'
+nft 'add rule ip filter INPUT add @connlimit0 { ip saddr and 255.255.255.0 ct count 2 } counter'
 
 iptables-translate -A INPUT -m connlimit --connlimit-upto 2 --connlimit-daddr
-nft add set ip filter connlimit0 { type ipv4_addr; flags dynamic; }
-nft add rule ip filter INPUT add @connlimit0 { ip daddr ct count 2 } counter
+nft 'add set ip filter connlimit0 { type ipv4_addr; flags dynamic; }'
+nft 'add rule ip filter INPUT add @connlimit0 { ip daddr ct count 2 } counter'
diff --git a/extensions/libxt_connmark.txlate b/extensions/libxt_connmark.txlate
index 89423259e9cf..e7bfd721ca99 100644
--- a/extensions/libxt_connmark.txlate
+++ b/extensions/libxt_connmark.txlate
@@ -1,14 +1,14 @@
 iptables-translate -A INPUT -m connmark --mark 2 -j ACCEPT
-nft add rule ip filter INPUT ct mark 0x2 counter accept
+nft 'add rule ip filter INPUT ct mark 0x2 counter accept'
 
 iptables-translate -A INPUT -m connmark ! --mark 2 -j ACCEPT
-nft add rule ip filter INPUT ct mark != 0x2 counter accept
+nft 'add rule ip filter INPUT ct mark != 0x2 counter accept'
 
 iptables-translate -A INPUT -m connmark --mark 10/10 -j ACCEPT
-nft add rule ip filter INPUT ct mark and 0xa == 0xa counter accept
+nft 'add rule ip filter INPUT ct mark and 0xa == 0xa counter accept'
 
 iptables-translate -A INPUT -m connmark ! --mark 10/10 -j ACCEPT
-nft add rule ip filter INPUT ct mark and 0xa != 0xa counter accept
+nft 'add rule ip filter INPUT ct mark and 0xa != 0xa counter accept'
 
 iptables-translate -t mangle -A PREROUTING -p tcp --dport 40 -m connmark --mark 0x40
-nft add rule ip mangle PREROUTING tcp dport 40 ct mark 0x40 counter
+nft 'add rule ip mangle PREROUTING tcp dport 40 ct mark 0x40 counter'
diff --git a/extensions/libxt_conntrack.txlate b/extensions/libxt_conntrack.txlate
index 45fba984ba96..0f44a957878e 100644
--- a/extensions/libxt_conntrack.txlate
+++ b/extensions/libxt_conntrack.txlate
@@ -1,60 +1,60 @@
 iptables-translate -t filter -A INPUT -m conntrack --ctstate NEW,RELATED -j ACCEPT
-nft add rule ip filter INPUT ct state new,related counter accept
+nft 'add rule ip filter INPUT ct state new,related counter accept'
 
 ip6tables-translate -t filter -A INPUT -m conntrack ! --ctstate NEW,RELATED -j ACCEPT
-nft add rule ip6 filter INPUT ct state ! new,related counter accept
+nft 'add rule ip6 filter INPUT ct state ! new,related counter accept'
 
 ip6tables-translate -t filter -A INPUT -m conntrack ! --ctstate NEW -j ACCEPT
-nft add rule ip6 filter INPUT ct state ! new counter accept
+nft 'add rule ip6 filter INPUT ct state ! new counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctproto UDP -j ACCEPT
-nft add rule ip filter INPUT ct original protocol 17 counter accept
+nft 'add rule ip filter INPUT ct original protocol 17 counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack ! --ctproto UDP -j ACCEPT
-nft add rule ip filter INPUT ct original protocol != 17 counter accept
+nft 'add rule ip filter INPUT ct original protocol != 17 counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctorigsrc 10.100.2.131 -j ACCEPT
-nft add rule ip filter INPUT ct original saddr 10.100.2.131 counter accept
+nft 'add rule ip filter INPUT ct original saddr 10.100.2.131 counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctorigsrc 10.100.0.0/255.255.0.0 -j ACCEPT
-nft add rule ip filter INPUT ct original saddr 10.100.0.0/16 counter accept
+nft 'add rule ip filter INPUT ct original saddr 10.100.0.0/16 counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctorigdst 10.100.2.131 -j ACCEPT
-nft add rule ip filter INPUT ct original daddr 10.100.2.131 counter accept
+nft 'add rule ip filter INPUT ct original daddr 10.100.2.131 counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctreplsrc 10.100.2.131 -j ACCEPT
-nft add rule ip filter INPUT ct reply saddr 10.100.2.131 counter accept
+nft 'add rule ip filter INPUT ct reply saddr 10.100.2.131 counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctrepldst 10.100.2.131 -j ACCEPT
-nft add rule ip filter INPUT ct reply daddr 10.100.2.131 counter accept
+nft 'add rule ip filter INPUT ct reply daddr 10.100.2.131 counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctproto tcp --ctorigsrcport 443:444 -j ACCEPT
-nft add rule ip filter INPUT ct original protocol 6 ct original proto-src 443-444 counter accept
+nft 'add rule ip filter INPUT ct original protocol 6 ct original proto-src 443-444 counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctstatus EXPECTED -j ACCEPT
-nft add rule ip filter INPUT ct status expected counter accept
+nft 'add rule ip filter INPUT ct status expected counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack ! --ctstatus CONFIRMED -j ACCEPT
-nft add rule ip filter INPUT ct status ! confirmed counter accept
+nft 'add rule ip filter INPUT ct status ! confirmed counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack ! --ctstatus CONFIRMED,ASSURED -j ACCEPT
-nft add rule ip filter INPUT ct status ! assured,confirmed counter accept
+nft 'add rule ip filter INPUT ct status ! assured,confirmed counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctstatus CONFIRMED,ASSURED -j ACCEPT
-nft add rule ip filter INPUT ct status assured,confirmed counter accept
+nft 'add rule ip filter INPUT ct status assured,confirmed counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctexpire 3 -j ACCEPT
-nft add rule ip filter INPUT ct expiration 3 counter accept
+nft 'add rule ip filter INPUT ct expiration 3 counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctdir ORIGINAL -j ACCEPT
-nft add rule ip filter INPUT ct direction original counter accept
+nft 'add rule ip filter INPUT ct direction original counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctstate NEW --ctproto tcp --ctorigsrc 192.168.0.1 --ctorigdst 192.168.0.1 --ctreplsrc 192.168.0.1 --ctrepldst 192.168.0.1 --ctorigsrcport 12 --ctorigdstport 14 --ctreplsrcport 16 --ctrepldstport 18 --ctexpire 10 --ctstatus SEEN_REPLY --ctdir ORIGINAL -j ACCEPT
-nft add rule ip filter INPUT ct direction original ct original protocol 6 ct state new ct status seen-reply ct expiration 10 ct original saddr 192.168.0.1 ct original daddr 192.168.0.1 ct reply saddr 192.168.0.1 ct reply daddr 192.168.0.1 ct original proto-src 12 ct original proto-dst 14 ct reply proto-src 16 ct reply proto-dst 18 counter accept
+nft 'add rule ip filter INPUT ct direction original ct original protocol 6 ct state new ct status seen-reply ct expiration 10 ct original saddr 192.168.0.1 ct original daddr 192.168.0.1 ct reply saddr 192.168.0.1 ct reply daddr 192.168.0.1 ct original proto-src 12 ct original proto-dst 14 ct reply proto-src 16 ct reply proto-dst 18 counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctstate SNAT -j ACCEPT
-nft add rule ip filter INPUT ct status snat counter accept
+nft 'add rule ip filter INPUT ct status snat counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack --ctstate DNAT -j ACCEPT
-nft add rule ip filter INPUT ct status dnat counter accept
+nft 'add rule ip filter INPUT ct status dnat counter accept'
 
diff --git a/extensions/libxt_cpu.txlate b/extensions/libxt_cpu.txlate
index c59b0e02cba5..937c939e9836 100644
--- a/extensions/libxt_cpu.txlate
+++ b/extensions/libxt_cpu.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A INPUT -p tcp --dport 80 -m cpu --cpu 0 -j ACCEPT
-nft add rule ip filter INPUT tcp dport 80 cpu 0 counter accept
+nft 'add rule ip filter INPUT tcp dport 80 cpu 0 counter accept'
 
 iptables-translate -A INPUT -p tcp --dport 80 -m cpu ! --cpu 1 -j ACCEPT
-nft add rule ip filter INPUT tcp dport 80 cpu != 1 counter accept
+nft 'add rule ip filter INPUT tcp dport 80 cpu != 1 counter accept'
diff --git a/extensions/libxt_dccp.txlate b/extensions/libxt_dccp.txlate
index ea853f6acf62..e8fed1da4c23 100644
--- a/extensions/libxt_dccp.txlate
+++ b/extensions/libxt_dccp.txlate
@@ -1,20 +1,20 @@
 iptables-translate -A INPUT -p dccp -m dccp --sport 100
-nft add rule ip filter INPUT dccp sport 100 counter
+nft 'add rule ip filter INPUT dccp sport 100 counter'
 
 iptables-translate -A INPUT -p dccp -m dccp --dport 100:200
-nft add rule ip filter INPUT dccp dport 100-200 counter
+nft 'add rule ip filter INPUT dccp dport 100-200 counter'
 
 iptables-translate -A INPUT -p dccp -m dccp ! --dport 100
-nft add rule ip filter INPUT dccp dport != 100 counter
+nft 'add rule ip filter INPUT dccp dport != 100 counter'
 
 iptables-translate -A INPUT -p dccp -m dccp --dccp-types CLOSE
-nft add rule ip filter INPUT dccp type close counter
+nft 'add rule ip filter INPUT dccp type close counter'
 
 iptables-translate -A INPUT -p dccp -m dccp --dccp-types INVALID
-nft add rule ip filter INPUT dccp type 10-15 counter
+nft 'add rule ip filter INPUT dccp type 10-15 counter'
 
 iptables-translate -A INPUT -p dccp -m dccp --dport 100 --dccp-types REQUEST,RESPONSE,DATA,ACK,DATAACK,CLOSEREQ,CLOSE,SYNC,SYNCACK,INVALID
-nft add rule ip filter INPUT dccp dport 100 dccp type {request, response, data, ack, dataack, closereq, close, sync, syncack, 10-15} counter
+nft 'add rule ip filter INPUT dccp dport 100 dccp type {request, response, data, ack, dataack, closereq, close, sync, syncack, 10-15} counter'
 
 iptables-translate -A INPUT -p dccp -m dccp --sport 200 --dport 100
-nft add rule ip filter INPUT dccp sport 200 dccp dport 100 counter
+nft 'add rule ip filter INPUT dccp sport 200 dccp dport 100 counter'
diff --git a/extensions/libxt_devgroup.txlate b/extensions/libxt_devgroup.txlate
index aeb597bdc119..dea47a992294 100644
--- a/extensions/libxt_devgroup.txlate
+++ b/extensions/libxt_devgroup.txlate
@@ -1,17 +1,17 @@
 iptables-translate -A FORWARD -m devgroup --src-group 0x2 -j ACCEPT
-nft add rule ip filter FORWARD iifgroup 0x2 counter accept
+nft 'add rule ip filter FORWARD iifgroup 0x2 counter accept'
 
 iptables-translate -A FORWARD -m devgroup --dst-group 0xc/0xc -j ACCEPT
-nft add rule ip filter FORWARD oifgroup and 0xc == 0xc counter accept
+nft 'add rule ip filter FORWARD oifgroup and 0xc == 0xc counter accept'
 
 iptables-translate -t mangle -A PREROUTING -p tcp --dport 46000 -m devgroup --src-group 23 -j ACCEPT
-nft add rule ip mangle PREROUTING tcp dport 46000 iifgroup 0x17 counter accept
+nft 'add rule ip mangle PREROUTING tcp dport 46000 iifgroup 0x17 counter accept'
 
 iptables-translate -A FORWARD -m devgroup ! --dst-group 0xc/0xc -j ACCEPT
-nft add rule ip filter FORWARD oifgroup and 0xc != 0xc counter accept
+nft 'add rule ip filter FORWARD oifgroup and 0xc != 0xc counter accept'
 
 iptables-translate -A FORWARD -m devgroup ! --src-group 0x2 -j ACCEPT
-nft add rule ip filter FORWARD iifgroup != 0x2 counter accept
+nft 'add rule ip filter FORWARD iifgroup != 0x2 counter accept'
 
 iptables-translate -A FORWARD -m devgroup ! --src-group 0x2 --dst-group 0xc/0xc -j ACCEPT
-nft add rule ip filter FORWARD iifgroup != 0x2 oifgroup and 0xc != 0xc counter accept
+nft 'add rule ip filter FORWARD iifgroup != 0x2 oifgroup and 0xc != 0xc counter accept'
diff --git a/extensions/libxt_dscp.txlate b/extensions/libxt_dscp.txlate
index 2cccc3b49cfa..ca2ec7240487 100644
--- a/extensions/libxt_dscp.txlate
+++ b/extensions/libxt_dscp.txlate
@@ -1,5 +1,5 @@
 iptables-translate -t filter -A INPUT -m dscp --dscp 0x32 -j ACCEPT
-nft add rule ip filter INPUT ip dscp 0x32 counter accept
+nft 'add rule ip filter INPUT ip dscp 0x32 counter accept'
 
 ip6tables-translate -t filter -A INPUT -m dscp ! --dscp 0x32 -j ACCEPT
-nft add rule ip6 filter INPUT ip6 dscp != 0x32 counter accept
+nft 'add rule ip6 filter INPUT ip6 dscp != 0x32 counter accept'
diff --git a/extensions/libxt_ecn.txlate b/extensions/libxt_ecn.txlate
index f012f1282a21..8488f8ceb029 100644
--- a/extensions/libxt_ecn.txlate
+++ b/extensions/libxt_ecn.txlate
@@ -1,29 +1,29 @@
 iptables-translate -A INPUT -m ecn --ecn-ip-ect 0
-nft add rule ip filter INPUT ip ecn not-ect counter
+nft 'add rule ip filter INPUT ip ecn not-ect counter'
 
 iptables-translate -A INPUT -m ecn --ecn-ip-ect 1
-nft add rule ip filter INPUT ip ecn ect1 counter
+nft 'add rule ip filter INPUT ip ecn ect1 counter'
 
 iptables-translate -A INPUT -m ecn --ecn-ip-ect 2
-nft add rule ip filter INPUT ip ecn ect0 counter
+nft 'add rule ip filter INPUT ip ecn ect0 counter'
 
 iptables-translate -A INPUT -m ecn --ecn-ip-ect 3
-nft add rule ip filter INPUT ip ecn ce counter
+nft 'add rule ip filter INPUT ip ecn ce counter'
 
 iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 0
-nft add rule ip filter INPUT ip ecn != not-ect counter
+nft 'add rule ip filter INPUT ip ecn != not-ect counter'
 
 iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 1
-nft add rule ip filter INPUT ip ecn != ect1 counter
+nft 'add rule ip filter INPUT ip ecn != ect1 counter'
 
 iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 2
-nft add rule ip filter INPUT ip ecn != ect0 counter
+nft 'add rule ip filter INPUT ip ecn != ect0 counter'
 
 iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 3
-nft add rule ip filter INPUT ip ecn != ce counter
+nft 'add rule ip filter INPUT ip ecn != ce counter'
 
 iptables-translate -A INPUT -m ecn ! --ecn-tcp-ece
-nft add rule ip filter INPUT tcp flags != ecn counter
+nft 'add rule ip filter INPUT tcp flags != ecn counter'
 
 iptables-translate -A INPUT -m ecn --ecn-tcp-cwr
-nft add rule ip filter INPUT tcp flags cwr counter
+nft 'add rule ip filter INPUT tcp flags cwr counter'
diff --git a/extensions/libxt_esp.txlate b/extensions/libxt_esp.txlate
index 5e2f18fa5b27..f6aba52f5223 100644
--- a/extensions/libxt_esp.txlate
+++ b/extensions/libxt_esp.txlate
@@ -1,11 +1,11 @@
 iptables-translate -A FORWARD -p esp -j ACCEPT
-nft add rule ip filter FORWARD ip protocol esp counter accept
+nft 'add rule ip filter FORWARD ip protocol esp counter accept'
 
 iptables-translate -A INPUT  --in-interface  wan --protocol esp -j ACCEPT
-nft add rule ip filter INPUT iifname "wan" ip protocol esp counter accept
+nft 'add rule ip filter INPUT iifname "wan" ip protocol esp counter accept'
 
 iptables-translate -A INPUT -p 50 -m esp --espspi 500 -j DROP
-nft add rule ip filter INPUT esp spi 500 counter drop
+nft 'add rule ip filter INPUT esp spi 500 counter drop'
 
 iptables-translate -A INPUT -p 50 -m esp --espspi 500:600 -j DROP
-nft add rule ip filter INPUT esp spi 500-600 counter drop
+nft 'add rule ip filter INPUT esp spi 500-600 counter drop'
diff --git a/extensions/libxt_hashlimit.txlate b/extensions/libxt_hashlimit.txlate
index 6c8d07f113d2..de6b4a07e670 100644
--- a/extensions/libxt_hashlimit.txlate
+++ b/extensions/libxt_hashlimit.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A OUTPUT -m tcp -p tcp --dport 443 -m hashlimit --hashlimit-above 20kb/s --hashlimit-burst 1mb --hashlimit-mode dstip --hashlimit-name https --hashlimit-dstmask 24 -m state --state NEW -j DROP
-nft add rule ip filter OUTPUT tcp dport 443 meter https { ip daddr and 255.255.255.0 timeout 60s limit rate over 20 kbytes/second burst 1 mbytes} ct state new  counter drop
+nft 'add rule ip filter OUTPUT tcp dport 443 meter https { ip daddr and 255.255.255.0 timeout 60s limit rate over 20 kbytes/second burst 1 mbytes} ct state new  counter drop'
 
 iptables-translate -A OUTPUT -m tcp -p tcp --dport 443 -m hashlimit --hashlimit-upto 300 --hashlimit-burst 15 --hashlimit-mode srcip,dstip --hashlimit-name https --hashlimit-htable-expire 300000 -m state --state NEW -j DROP
-nft add rule ip filter OUTPUT tcp dport 443 meter https { ip daddr . ip saddr timeout 300s limit rate 300/second burst 15 packets} ct state new  counter drop
+nft 'add rule ip filter OUTPUT tcp dport 443 meter https { ip daddr . ip saddr timeout 300s limit rate 300/second burst 15 packets} ct state new  counter drop'
diff --git a/extensions/libxt_helper.txlate b/extensions/libxt_helper.txlate
index 8259aba31968..2d94f740a37d 100644
--- a/extensions/libxt_helper.txlate
+++ b/extensions/libxt_helper.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A FORWARD -m helper --helper sip
-nft add rule ip filter FORWARD ct helper \"sip\" counter
+nft 'add rule ip filter FORWARD ct helper "sip" counter'
 
 iptables-translate -A FORWARD -m helper ! --helper ftp
-nft add rule ip filter FORWARD ct helper != \"ftp\" counter
+nft 'add rule ip filter FORWARD ct helper != "ftp" counter'
diff --git a/extensions/libxt_ipcomp.txlate b/extensions/libxt_ipcomp.txlate
index f9efe53ca75b..877cccbb4ce4 100644
--- a/extensions/libxt_ipcomp.txlate
+++ b/extensions/libxt_ipcomp.txlate
@@ -1,5 +1,5 @@
 iptables-translate -t filter -A INPUT -m ipcomp --ipcompspi 0x12 -j ACCEPT
-nft add rule ip filter INPUT comp cpi 18 counter accept
+nft 'add rule ip filter INPUT comp cpi 18 counter accept'
 
 iptables-translate -t filter -A INPUT -m ipcomp ! --ipcompspi 0x12 -j ACCEPT
-nft add rule ip filter INPUT comp cpi != 18 counter accept
+nft 'add rule ip filter INPUT comp cpi != 18 counter accept'
diff --git a/extensions/libxt_iprange.txlate b/extensions/libxt_iprange.txlate
index 999f4b72a305..803696508c31 100644
--- a/extensions/libxt_iprange.txlate
+++ b/extensions/libxt_iprange.txlate
@@ -1,14 +1,14 @@
 iptables-translate -A INPUT -m iprange --src-range 192.168.25.149-192.168.25.151 -j ACCEPT
-nft add rule ip filter INPUT ip saddr 192.168.25.149-192.168.25.151 counter accept
+nft 'add rule ip filter INPUT ip saddr 192.168.25.149-192.168.25.151 counter accept'
 
 iptables-translate -A INPUT -m iprange --dst-range 192.168.25.149-192.168.25.151 -j ACCEPT
-nft add rule ip filter INPUT ip daddr 192.168.25.149-192.168.25.151 counter accept
+nft 'add rule ip filter INPUT ip daddr 192.168.25.149-192.168.25.151 counter accept'
 
 iptables-translate -A INPUT -m iprange --dst-range 3.3.3.3-6.6.6.6 --src-range 4.4.4.4-7.7.7.7 -j ACCEPT
-nft add rule ip filter INPUT ip saddr 4.4.4.4-7.7.7.7 ip daddr 3.3.3.3-6.6.6.6 counter accept
+nft 'add rule ip filter INPUT ip saddr 4.4.4.4-7.7.7.7 ip daddr 3.3.3.3-6.6.6.6 counter accept'
 
 ip6tables-translate -A INPUT -m iprange ! --dst-range ::2d01-::2d03 -j ACCEPT
-nft add rule ip6 filter INPUT ip6 daddr != ::2d01-::2d03 counter accept
+nft 'add rule ip6 filter INPUT ip6 daddr != ::2d01-::2d03 counter accept'
 
 ip6tables-translate -A INPUT -m iprange ! --dst-range ::2d01-::2d03 --src-range ::2d01-::2d03 -j ACCEPT
-nft add rule ip6 filter INPUT ip6 saddr ::2d01-::2d03 ip6 daddr != ::2d01-::2d03 counter accept
+nft 'add rule ip6 filter INPUT ip6 saddr ::2d01-::2d03 ip6 daddr != ::2d01-::2d03 counter accept'
diff --git a/extensions/libxt_length.txlate b/extensions/libxt_length.txlate
index e777c2653a40..38f835dcac6a 100644
--- a/extensions/libxt_length.txlate
+++ b/extensions/libxt_length.txlate
@@ -1,11 +1,11 @@
 iptables-translate -A INPUT -p icmp -m length --length 86:0xffff -j DROP
-nft add rule ip filter INPUT ip protocol icmp meta length 86-65535 counter drop
+nft 'add rule ip filter INPUT ip protocol icmp meta length 86-65535 counter drop'
 
 iptables-translate -A INPUT -p udp -m length --length :400
-nft add rule ip filter INPUT ip protocol udp meta length 0-400 counter
+nft 'add rule ip filter INPUT ip protocol udp meta length 0-400 counter'
 
 iptables-translate -A INPUT -p udp -m length --length 40
-nft add rule ip filter INPUT ip protocol udp meta length 40 counter
+nft 'add rule ip filter INPUT ip protocol udp meta length 40 counter'
 
 iptables-translate -A INPUT -p udp -m length ! --length 40
-nft add rule ip filter INPUT ip protocol udp meta length != 40 counter
+nft 'add rule ip filter INPUT ip protocol udp meta length != 40 counter'
diff --git a/extensions/libxt_limit.txlate b/extensions/libxt_limit.txlate
index df9ed2d5fd08..fa8e1bc0cf40 100644
--- a/extensions/libxt_limit.txlate
+++ b/extensions/libxt_limit.txlate
@@ -1,8 +1,8 @@
 iptables-translate -A INPUT -m limit --limit 3/m --limit-burst 3
-nft add rule ip filter INPUT limit rate 3/minute burst 3 packets counter
+nft 'add rule ip filter INPUT limit rate 3/minute burst 3 packets counter'
 
 iptables-translate -A INPUT -m limit --limit 10/s --limit-burst 5
-nft add rule ip filter INPUT limit rate 10/second burst 5 packets counter
+nft 'add rule ip filter INPUT limit rate 10/second burst 5 packets counter'
 
 iptables-translate -A INPUT -m limit --limit 10/s --limit-burst 0
-nft add rule ip filter INPUT limit rate 10/second counter
+nft 'add rule ip filter INPUT limit rate 10/second counter'
diff --git a/extensions/libxt_mac.txlate b/extensions/libxt_mac.txlate
index 08696f3deee8..16800179941e 100644
--- a/extensions/libxt_mac.txlate
+++ b/extensions/libxt_mac.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A INPUT -m mac --mac-source 0a:12:3e:4f:b2:c6 -j DROP
-nft add rule ip filter INPUT ether saddr 0a:12:3e:4f:b2:c6 counter drop
+nft 'add rule ip filter INPUT ether saddr 0a:12:3e:4f:b2:c6 counter drop'
 
 iptables-translate -A INPUT -p tcp --dport 80 -m mac --mac-source 0a:12:3e:4f:b2:c6 -j ACCEPT
-nft add rule ip filter INPUT tcp dport 80 ether saddr 0a:12:3e:4f:b2:c6 counter accept
+nft 'add rule ip filter INPUT tcp dport 80 ether saddr 0a:12:3e:4f:b2:c6 counter accept'
diff --git a/extensions/libxt_mark.txlate b/extensions/libxt_mark.txlate
index 6bfb52434df2..6e097091da83 100644
--- a/extensions/libxt_mark.txlate
+++ b/extensions/libxt_mark.txlate
@@ -1,5 +1,5 @@
 iptables-translate -I INPUT -p tcp -m mark ! --mark 0xa/0xa
-nft insert rule ip filter INPUT ip protocol tcp mark and 0xa != 0xa counter
+nft 'insert rule ip filter INPUT ip protocol tcp mark and 0xa != 0xa counter'
 
 iptables-translate -I INPUT -p tcp -m mark ! --mark 0x1
-nft insert rule ip filter INPUT ip protocol tcp mark != 0x1 counter
+nft 'insert rule ip filter INPUT ip protocol tcp mark != 0x1 counter'
diff --git a/extensions/libxt_multiport.txlate b/extensions/libxt_multiport.txlate
index bced1b84c447..422c53febf78 100644
--- a/extensions/libxt_multiport.txlate
+++ b/extensions/libxt_multiport.txlate
@@ -1,14 +1,14 @@
 iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80,81 -j ACCEPT
-nft add rule ip filter INPUT ip protocol tcp tcp dport { 80,81} counter accept
+nft 'add rule ip filter INPUT ip protocol tcp tcp dport { 80,81} counter accept'
 
 iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80:88 -j ACCEPT
-nft add rule ip filter INPUT ip protocol tcp tcp dport 80-88 counter accept
+nft 'add rule ip filter INPUT ip protocol tcp tcp dport 80-88 counter accept'
 
 iptables-translate -t filter -A INPUT -p tcp -m multiport ! --dports 80:88 -j ACCEPT
-nft add rule ip filter INPUT ip protocol tcp tcp dport != 80-88 counter accept
+nft 'add rule ip filter INPUT ip protocol tcp tcp dport != 80-88 counter accept'
 
 iptables-translate -t filter -A INPUT -p tcp -m multiport --sports 50 -j ACCEPT
-nft add rule ip filter INPUT ip protocol tcp tcp sport 50 counter accept
+nft 'add rule ip filter INPUT ip protocol tcp tcp sport 50 counter accept'
 
 iptables-translate -t filter -I INPUT -p tcp -m multiport --ports 10
-nft insert rule ip filter INPUT ip protocol tcp tcp sport . tcp dport { 0-65535 . 10, 10 . 0-65535 } counter
+nft 'insert rule ip filter INPUT ip protocol tcp tcp sport . tcp dport { 0-65535 . 10, 10 . 0-65535 } counter'
diff --git a/extensions/libxt_owner.txlate b/extensions/libxt_owner.txlate
index 86fb0585352f..8fbd68ebab1c 100644
--- a/extensions/libxt_owner.txlate
+++ b/extensions/libxt_owner.txlate
@@ -1,8 +1,8 @@
 iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --uid-owner root -j ACCEPT
-nft add rule ip nat OUTPUT tcp dport 80 skuid 0 counter accept
+nft 'add rule ip nat OUTPUT tcp dport 80 skuid 0 counter accept'
 
 iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --gid-owner 0-10 -j ACCEPT
-nft add rule ip nat OUTPUT tcp dport 80 skgid 0-10 counter accept
+nft 'add rule ip nat OUTPUT tcp dport 80 skgid 0-10 counter accept'
 
 iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner ! --uid-owner 1000 -j ACCEPT
-nft add rule ip nat OUTPUT tcp dport 80 skuid != 1000 counter accept
+nft 'add rule ip nat OUTPUT tcp dport 80 skuid != 1000 counter accept'
diff --git a/extensions/libxt_pkttype.txlate b/extensions/libxt_pkttype.txlate
index 6506a380b6f0..c69f56f9d3cd 100644
--- a/extensions/libxt_pkttype.txlate
+++ b/extensions/libxt_pkttype.txlate
@@ -1,8 +1,8 @@
 iptables-translate -A INPUT -m pkttype --pkt-type broadcast -j DROP
-nft add rule ip filter INPUT pkttype broadcast counter drop
+nft 'add rule ip filter INPUT pkttype broadcast counter drop'
 
 iptables-translate -A INPUT -m pkttype ! --pkt-type unicast -j DROP
-nft add rule ip filter INPUT pkttype != unicast counter drop
+nft 'add rule ip filter INPUT pkttype != unicast counter drop'
 
 iptables-translate -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
-nft add rule ip filter INPUT pkttype multicast counter accept
+nft 'add rule ip filter INPUT pkttype multicast counter accept'
diff --git a/extensions/libxt_policy.txlate b/extensions/libxt_policy.txlate
index 66788a765606..a960b3953772 100644
--- a/extensions/libxt_policy.txlate
+++ b/extensions/libxt_policy.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A INPUT -m policy --pol ipsec --dir in
-nft add rule ip filter INPUT meta secpath exists counter
+nft 'add rule ip filter INPUT meta secpath exists counter'
 
 iptables-translate -A INPUT -m policy --pol none --dir in
-nft add rule ip filter INPUT meta secpath missing counter
+nft 'add rule ip filter INPUT meta secpath missing counter'
diff --git a/extensions/libxt_quota.txlate b/extensions/libxt_quota.txlate
index 911421410696..6edd925db39a 100644
--- a/extensions/libxt_quota.txlate
+++ b/extensions/libxt_quota.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A OUTPUT -m quota --quota 111
-nft add rule ip filter OUTPUT quota 111 bytes counter
+nft 'add rule ip filter OUTPUT quota 111 bytes counter'
 
 iptables-translate -A OUTPUT -m quota ! --quota 111
-nft add rule ip filter OUTPUT quota over 111 bytes counter
+nft 'add rule ip filter OUTPUT quota over 111 bytes counter'
diff --git a/extensions/libxt_rpfilter.txlate b/extensions/libxt_rpfilter.txlate
index 8d7733ba65c5..a551c4195728 100644
--- a/extensions/libxt_rpfilter.txlate
+++ b/extensions/libxt_rpfilter.txlate
@@ -1,8 +1,8 @@
 iptables-translate -t mangle -A PREROUTING -m rpfilter
-nft add rule ip mangle PREROUTING fib saddr . iif oif != 0 counter
+nft 'add rule ip mangle PREROUTING fib saddr . iif oif != 0 counter'
 
 iptables-translate -t mangle -A PREROUTING -m rpfilter --validmark --loose
-nft add rule ip mangle PREROUTING fib saddr . mark oif != 0 counter
+nft 'add rule ip mangle PREROUTING fib saddr . mark oif != 0 counter'
 
 ip6tables-translate -t mangle -A PREROUTING -m rpfilter --validmark --invert
-nft add rule ip6 mangle PREROUTING fib saddr . mark . iif oif 0 counter
+nft 'add rule ip6 mangle PREROUTING fib saddr . mark . iif oif 0 counter'
diff --git a/extensions/libxt_sctp.txlate b/extensions/libxt_sctp.txlate
index 6443abf9c561..0aa7371d08a1 100644
--- a/extensions/libxt_sctp.txlate
+++ b/extensions/libxt_sctp.txlate
@@ -1,44 +1,44 @@
 iptables-translate -A INPUT -p sctp --dport 80 -j DROP
-nft add rule ip filter INPUT sctp dport 80 counter drop
+nft 'add rule ip filter INPUT sctp dport 80 counter drop'
 
 iptables-translate -A INPUT -p sctp --sport 50 -j DROP
-nft add rule ip filter INPUT sctp sport 50 counter drop
+nft 'add rule ip filter INPUT sctp sport 50 counter drop'
 
 iptables-translate -A INPUT -p sctp ! --dport 80 -j DROP
-nft add rule ip filter INPUT sctp dport != 80 counter drop
+nft 'add rule ip filter INPUT sctp dport != 80 counter drop'
 
 iptables-translate -A INPUT -p sctp ! --sport 50 -j DROP
-nft add rule ip filter INPUT sctp sport != 50 counter drop
+nft 'add rule ip filter INPUT sctp sport != 50 counter drop'
 
 iptables-translate -A INPUT -p sctp --sport 80:100 -j ACCEPT
-nft add rule ip filter INPUT sctp sport 80-100 counter accept
+nft 'add rule ip filter INPUT sctp sport 80-100 counter accept'
 
 iptables-translate -A INPUT -p sctp --dport 50:56 -j ACCEPT
-nft add rule ip filter INPUT sctp dport 50-56 counter accept
+nft 'add rule ip filter INPUT sctp dport 50-56 counter accept'
 
 iptables-translate -A INPUT -p sctp ! --sport 80:100 -j ACCEPT
-nft add rule ip filter INPUT sctp sport != 80-100 counter accept
+nft 'add rule ip filter INPUT sctp sport != 80-100 counter accept'
 
 iptables-translate -A INPUT -p sctp ! --dport 50:56 -j ACCEPT
-nft add rule ip filter INPUT sctp dport != 50-56 counter accept
+nft 'add rule ip filter INPUT sctp dport != 50-56 counter accept'
 
 iptables-translate -A INPUT -p sctp --dport 80 --sport 50 -j ACCEPT
-nft add rule ip filter INPUT sctp sport 50 sctp dport 80 counter accept
+nft 'add rule ip filter INPUT sctp sport 50 sctp dport 80 counter accept'
 
 iptables-translate -A INPUT -p sctp --dport 80:100 --sport 50 -j ACCEPT
-nft add rule ip filter INPUT sctp sport 50 sctp dport 80-100 counter accept
+nft 'add rule ip filter INPUT sctp sport 50 sctp dport 80-100 counter accept'
 
 iptables-translate -A INPUT -p sctp --dport 80 --sport 50:55 -j ACCEPT
-nft add rule ip filter INPUT sctp sport 50-55 sctp dport 80 counter accept
+nft 'add rule ip filter INPUT sctp sport 50-55 sctp dport 80 counter accept'
 
 iptables-translate -A INPUT -p sctp ! --dport 80:100 --sport 50 -j ACCEPT
-nft add rule ip filter INPUT sctp sport 50 sctp dport != 80-100 counter accept
+nft 'add rule ip filter INPUT sctp sport 50 sctp dport != 80-100 counter accept'
 
 iptables-translate -A INPUT -p sctp --dport 80 ! --sport 50:55 -j ACCEPT
-nft add rule ip filter INPUT sctp sport != 50-55 sctp dport 80 counter accept
+nft 'add rule ip filter INPUT sctp sport != 50-55 sctp dport 80 counter accept'
 
 iptables-translate -A INPUT -p sctp --chunk-types all INIT,DATA:iUbE,SACK,ABORT:T -j ACCEPT
-nft add rule ip filter INPUT sctp chunk data flags & 0xf == 0x5 sctp chunk init exists sctp chunk sack exists sctp chunk abort flags & 0x1 == 0x1 counter accept
+nft 'add rule ip filter INPUT sctp chunk data flags & 0xf == 0x5 sctp chunk init exists sctp chunk sack exists sctp chunk abort flags & 0x1 == 0x1 counter accept'
 
 iptables-translate -A INPUT -p sctp --chunk-types only SHUTDOWN_COMPLETE -j ACCEPT
-nft add rule ip filter INPUT sctp chunk data missing sctp chunk init missing sctp chunk init-ack missing sctp chunk sack missing sctp chunk heartbeat missing sctp chunk heartbeat-ack missing sctp chunk abort missing sctp chunk shutdown missing sctp chunk shutdown-ack missing sctp chunk error missing sctp chunk cookie-echo missing sctp chunk cookie-ack missing sctp chunk ecne missing sctp chunk cwr missing sctp chunk shutdown-complete exists sctp chunk i-data missing sctp chunk re-config missing sctp chunk pad missing sctp chunk asconf missing sctp chunk asconf-ack missing sctp chunk forward-tsn missing sctp chunk i-forward-tsn missing counter accept
+nft 'add rule ip filter INPUT sctp chunk data missing sctp chunk init missing sctp chunk init-ack missing sctp chunk sack missing sctp chunk heartbeat missing sctp chunk heartbeat-ack missing sctp chunk abort missing sctp chunk shutdown missing sctp chunk shutdown-ack missing sctp chunk error missing sctp chunk cookie-echo missing sctp chunk cookie-ack missing sctp chunk ecne missing sctp chunk cwr missing sctp chunk shutdown-complete exists sctp chunk i-data missing sctp chunk re-config missing sctp chunk pad missing sctp chunk asconf missing sctp chunk asconf-ack missing sctp chunk forward-tsn missing sctp chunk i-forward-tsn missing counter accept'
diff --git a/extensions/libxt_statistic.txlate b/extensions/libxt_statistic.txlate
index 4c3dea4310a2..3196ff20b90d 100644
--- a/extensions/libxt_statistic.txlate
+++ b/extensions/libxt_statistic.txlate
@@ -1,8 +1,8 @@
 iptables-translate -A OUTPUT -m statistic --mode nth --every 10 --packet 1
-nft add rule ip filter OUTPUT numgen inc mod 10 1 counter
+nft 'add rule ip filter OUTPUT numgen inc mod 10 1 counter'
 
 iptables-translate -A OUTPUT -m statistic --mode nth ! --every 10 --packet 5
-nft add rule ip filter OUTPUT numgen inc mod 10 != 5 counter
+nft 'add rule ip filter OUTPUT numgen inc mod 10 != 5 counter'
 
 iptables-translate -A OUTPUT -m statistic --mode random --probability 0.1
 nft # -A OUTPUT -m statistic --mode random --probability 0.1
diff --git a/extensions/libxt_tcp.txlate b/extensions/libxt_tcp.txlate
index a1f0e909bb46..9802ddfe0039 100644
--- a/extensions/libxt_tcp.txlate
+++ b/extensions/libxt_tcp.txlate
@@ -1,32 +1,32 @@
 iptables-translate -A INPUT -p tcp -i eth0 --sport 53 -j ACCEPT
-nft add rule ip filter INPUT iifname "eth0" tcp sport 53 counter accept
+nft 'add rule ip filter INPUT iifname "eth0" tcp sport 53 counter accept'
 
 iptables-translate -A OUTPUT -p tcp -o eth0 --dport 53:66 -j DROP
-nft add rule ip filter OUTPUT oifname "eth0" tcp dport 53-66 counter drop
+nft 'add rule ip filter OUTPUT oifname "eth0" tcp dport 53-66 counter drop'
 
 iptables-translate -I OUTPUT -p tcp -d 8.8.8.8 -j ACCEPT
-nft insert rule ip filter OUTPUT ip protocol tcp ip daddr 8.8.8.8 counter accept
+nft 'insert rule ip filter OUTPUT ip protocol tcp ip daddr 8.8.8.8 counter accept'
 
 iptables-translate -I OUTPUT -p tcp --dport 1020:1023 --sport 53 -j ACCEPT
-nft insert rule ip filter OUTPUT tcp sport 53 tcp dport 1020-1023 counter accept
+nft 'insert rule ip filter OUTPUT tcp sport 53 tcp dport 1020-1023 counter accept'
 
 iptables -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
-nft add rule ip filter INPUT tcp flags fin / fin,ack counter drop
+nft 'add rule ip filter INPUT tcp flags fin / fin,ack counter drop'
 
 iptables-translate -A INPUT -p tcp --syn -j ACCEPT
-nft add rule ip filter INPUT tcp flags syn / fin,syn,rst,ack counter accept
+nft 'add rule ip filter INPUT tcp flags syn / fin,syn,rst,ack counter accept'
 
 iptables-translate -A INPUT -p tcp --syn --dport 80 -j ACCEPT
-nft add rule ip filter INPUT tcp dport 80 tcp flags syn / fin,syn,rst,ack counter accept
+nft 'add rule ip filter INPUT tcp dport 80 tcp flags syn / fin,syn,rst,ack counter accept'
 
 iptables-translate -A INPUT -f -p tcp
-nft add rule ip filter INPUT ip frag-off & 0x1fff != 0 ip protocol tcp counter
+nft 'add rule ip filter INPUT ip frag-off & 0x1fff != 0 ip protocol tcp counter'
 
 iptables-translate -A INPUT ! -f -p tcp --dport 22
-nft add rule ip filter INPUT ip frag-off & 0x1fff 0 tcp dport 22 counter
+nft 'add rule ip filter INPUT ip frag-off & 0x1fff 0 tcp dport 22 counter'
 
 iptables-translate -A INPUT -p tcp --tcp-option 23
-nft add rule ip filter INPUT tcp option 23 exists counter
+nft 'add rule ip filter INPUT tcp option 23 exists counter'
 
 iptables-translate -A INPUT -p tcp ! --tcp-option 23
-nft add rule ip filter INPUT tcp option 23 missing counter
+nft 'add rule ip filter INPUT tcp option 23 missing counter'
diff --git a/extensions/libxt_tcpmss.txlate b/extensions/libxt_tcpmss.txlate
index d3f1b27d18f4..82475e67029d 100644
--- a/extensions/libxt_tcpmss.txlate
+++ b/extensions/libxt_tcpmss.txlate
@@ -1,11 +1,11 @@
 iptables-translate -A INPUT -m tcpmss --mss 42
-nft add rule ip filter INPUT tcp option maxseg size 42 counter
+nft 'add rule ip filter INPUT tcp option maxseg size 42 counter'
 
 iptables-translate -A INPUT -m tcpmss ! --mss 42
-nft add rule ip filter INPUT tcp option maxseg size != 42 counter
+nft 'add rule ip filter INPUT tcp option maxseg size != 42 counter'
 
 iptables-translate -A INPUT -m tcpmss --mss 42:1024
-nft add rule ip filter INPUT tcp option maxseg size 42-1024 counter
+nft 'add rule ip filter INPUT tcp option maxseg size 42-1024 counter'
 
 iptables-translate -A INPUT -m tcpmss ! --mss 1461:65535
-nft add rule ip filter INPUT tcp option maxseg size != 1461-65535 counter
+nft 'add rule ip filter INPUT tcp option maxseg size != 1461-65535 counter'
diff --git a/extensions/libxt_time.txlate b/extensions/libxt_time.txlate
index ff4a7b88a874..7f7251964b18 100644
--- a/extensions/libxt_time.txlate
+++ b/extensions/libxt_time.txlate
@@ -1,26 +1,26 @@
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --weekdays Sa,Su -j REJECT
-nft add rule ip filter INPUT icmp type echo-request  meta day {6,0} counter reject
+nft 'add rule ip filter INPUT icmp type echo-request  meta day {6,0} counter reject'
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --timestart 12:00 -j REJECT
-nft add rule ip filter INPUT icmp type echo-request  meta hour "12:00:00"-"23:59:59" counter reject
+nft 'add rule ip filter INPUT icmp type echo-request  meta hour "12:00:00"-"23:59:59" counter reject'
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --timestop 12:00 -j REJECT
-nft add rule ip filter INPUT icmp type echo-request  meta hour "00:00:00"-"12:00:00" counter reject
+nft 'add rule ip filter INPUT icmp type echo-request  meta hour "00:00:00"-"12:00:00" counter reject'
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2021 -j REJECT
-nft add rule ip filter INPUT icmp type echo-request meta time "2021-01-01 00:00:00"-"2038-01-19 03:14:07" counter reject
+nft 'add rule ip filter INPUT icmp type echo-request meta time "2021-01-01 00:00:00"-"2038-01-19 03:14:07" counter reject'
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestop 2021 -j REJECT
-nft add rule ip filter INPUT icmp type echo-request meta time "1970-01-01 00:00:00"-"2021-01-01 00:00:00" counter reject
+nft 'add rule ip filter INPUT icmp type echo-request meta time "1970-01-01 00:00:00"-"2021-01-01 00:00:00" counter reject'
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestop 2021-01-29T00:00:00 -j REJECT
-nft add rule ip filter INPUT icmp type echo-request meta time "1970-01-01 00:00:00"-"2021-01-29 00:00:00" counter reject
+nft 'add rule ip filter INPUT icmp type echo-request meta time "1970-01-01 00:00:00"-"2021-01-29 00:00:00" counter reject'
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2020-01-29T00:00:00 --timestart 12:00 -j REJECT
-nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"23:59:59" counter reject
+nft 'add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"23:59:59" counter reject'
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2020-01-29T00:00:00 --timestart 12:00 --timestop 19:00 --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
-nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day {1,2,3,4,5} counter reject
+nft 'add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day {1,2,3,4,5} counter reject'
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2020-01-29T00:00:00 --timestart 12:00 --timestop 19:00 ! --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
-nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day {6,0} counter reject
+nft 'add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day {6,0} counter reject'
diff --git a/extensions/libxt_udp.txlate b/extensions/libxt_udp.txlate
index fbca5c12a594..28e7ca206b26 100644
--- a/extensions/libxt_udp.txlate
+++ b/extensions/libxt_udp.txlate
@@ -1,11 +1,11 @@
 iptables-translate -A INPUT -p udp -i eth0 --sport 53 -j ACCEPT
-nft add rule ip filter INPUT iifname "eth0" udp sport 53 counter accept
+nft 'add rule ip filter INPUT iifname "eth0" udp sport 53 counter accept'
 
 iptables-translate -A OUTPUT -p udp -o eth0 --dport 53:66 -j DROP
-nft add rule ip filter OUTPUT oifname "eth0" udp dport 53-66 counter drop
+nft 'add rule ip filter OUTPUT oifname "eth0" udp dport 53-66 counter drop'
 
 iptables-translate -I OUTPUT -p udp -d 8.8.8.8 -j ACCEPT
-nft insert rule ip filter OUTPUT ip protocol udp ip daddr 8.8.8.8 counter accept
+nft 'insert rule ip filter OUTPUT ip protocol udp ip daddr 8.8.8.8 counter accept'
 
 iptables-translate -I OUTPUT -p udp --dport 1020:1023 --sport 53 -j ACCEPT
-nft insert rule ip filter OUTPUT udp sport 53 udp dport 1020-1023 counter accept
+nft 'insert rule ip filter OUTPUT udp sport 53 udp dport 1020-1023 counter accept'
-- 
2.37.4

