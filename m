Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD2CC433DB
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Jan 2021 00:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1445206DC
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Jan 2021 00:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbhAXA3s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Jan 2021 19:29:48 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:56056 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbhAXA3r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Jan 2021 19:29:47 -0500
Received: by mail-wm1-f47.google.com with SMTP id c124so7460286wma.5
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Jan 2021 16:29:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GEBQGxw+DDSKiK2ykIlDfqM7t5KimcItshW5BLnh7FY=;
        b=VLNtS3kmAldKjKxmh17XEYgo9VTWM/a/hNR0IRd/r+deiKA6fC2wNX9FxFUBscpyfd
         xI4y/owylmVAZjyvYxnDh0k8cdeZVfQ5P4HToc604wGalhvHuHBXrpC60TUg0gEpxDS0
         vWMPJ7600AMwaH66k4ZV84nOdyJ02N/3eYheyofk0lK2nZ/luJ/gANwJzJ/4ePWsMtl7
         PKC9B4V5B3h8f5qfHKszsjrO50NAHHtPowEJ7h0o/lG0qSeSc7Vq5C31KsPwabnWRNlF
         lfjankRC1Ug7DYDAST8w4+9DffV4rvrqZ2I4aUhcHof3B6zmjrCokj5JK++2MTzrrsio
         t+5w==
X-Gm-Message-State: AOAM532M5WCVHh78HO61KyK+Dy0TzRqLjWB3kOOpgMpV33av2x7W39pQ
        gdDkCyh0qyl62UcfWIAMj5iCjKcqFOGxKg==
X-Google-Smtp-Source: ABdhPJxlf9MktBw1tTEGjvyJpWE5XK4pwOj8AVHjPhzsp6k7TVZb24/kdxj9fJWUJVcUKtC+8pa33g==
X-Received: by 2002:a1c:3b44:: with SMTP id i65mr744589wma.53.1611448144378;
        Sat, 23 Jan 2021 16:29:04 -0800 (PST)
Received: from localhost ([213.194.141.17])
        by smtp.gmail.com with ESMTPSA id s3sm15864487wmc.44.2021.01.23.16.29.03
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 16:29:03 -0800 (PST)
Subject: [conntrack-tools PATCH 3/3] tests: introduce replicating scenario and
 simple icmp test case
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Sun, 24 Jan 2021 01:29:03 +0100
Message-ID: <161144792308.52227.966057147639970534.stgit@endurance>
In-Reply-To: <161144773322.52227.18304556638755743629.stgit@endurance>
References: <161144773322.52227.18304556638755743629.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduces a new scenario with a virtual network layout that was previously designed by
Pablo (see commit 7f1fb5dad90f04caa94f4fcefd1340aeb2c2f0e3).

The scenario is called 'basic_2_peer_network_tcp_notrack' and can be used to test conntrack entry
replication in TCP/NOTRACK mode with both caches disables. In this mode entry syncronization should
happen basically in the same instant the event is produced.

The testcase is very simple, but works really well:
 * send 1 ping to a network peer across the router
 * verify the conntrack entry has been replicated to the stand-by router

=== 8< ===
$ cd tests ; sudo ./cttools-testing-framework.py --single tcp_notrack_replicate_icmp
[cttools-testing-framework.py] INFO: --- running test: tcp_notrack_replicate_icmp
[cttools-testing-framework.py] INFO: --- passed test: tcp_notrack_replicate_icmp
[cttools-testing-framework.py] INFO: ---
[cttools-testing-framework.py] INFO: --- finished
[cttools-testing-framework.py] INFO: --- passed tests: 1
[cttools-testing-framework.py] INFO: --- failed tests: 0
[cttools-testing-framework.py] INFO: --- scenario failure: 0
[cttools-testing-framework.py] INFO: --- total tests: 1
=== 8< ===

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---

HINT: while developing this scenario/testcase I already detected several bugs. How to trigger them
is left as an exercise for the reader. I will send detailed (failure) testcases in other patch
series.

 scenarios.yaml |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests.yaml     |   11 +++++++++++
 2 files changed, 112 insertions(+)

diff --git a/tests/scenarios.yaml b/tests/scenarios.yaml
index a47e1a1..798d9eb 100644
--- a/tests/scenarios.yaml
+++ b/tests/scenarios.yaml
@@ -17,3 +17,104 @@
     - $CONNTRACKD -C /tmp/conntrackd_test_simple_stats -k
     - rm -f /var/lock/conntrack.lock
     - rm -f /tmp/conntrackd_test_simple_stats
+
+- name: basic_2_peer_network_tcp_notrack
+  start:
+    - ip netns add ns1
+    - ip netns add ns2
+    - ip netns add nsr1
+    - ip netns add nsr2
+    - ip link add veth0 netns ns1 type veth peer name veth1 netns nsr1
+    - ip link add veth0 netns nsr1 type veth peer name veth0 netns ns2
+    - ip link add veth2 netns nsr1 type veth peer name veth0 netns nsr2
+    - ip -net ns1 addr add 192.168.10.2/24 dev veth0
+    - ip -net ns1 link set up dev veth0
+    - ip -net ns1 ro add 10.0.1.0/24 via 192.168.10.1 dev veth0
+    - ip -net nsr1 addr add 10.0.1.1/24 dev veth0
+    - ip -net nsr1 addr add 192.168.10.1/24 dev veth1
+    - ip -net nsr1 link set up dev veth0
+    - ip -net nsr1 link set up dev veth1
+    - ip -net nsr1 route add default via 192.168.10.2
+    - ip netns exec nsr1 sysctl -q net.ipv4.ip_forward=1
+    - ip -net nsr1 addr add 192.168.100.2/24 dev veth2
+    - ip -net nsr1 link set up dev veth2
+    - ip -net nsr2 addr add 192.168.100.3/24 dev veth0
+    - ip -net nsr2 link set up dev veth0
+    - ip -net ns2 addr add 10.0.1.2/24 dev veth0
+    - ip -net ns2 link set up dev veth0
+    - ip -net ns2 route add default via 10.0.1.1
+    - |
+      cat << EOF > /tmp/ruleset.nft
+      table ip filter {
+        chain postrouting {
+          type nat hook postrouting priority srcnat; policy accept;
+            oif veth0 masquerade
+        }
+      }
+      EOF
+    - ip netns exec nsr1 nft -f /tmp/ruleset.nft
+    - |
+      cat << EOF > /tmp/nsr1.conf
+      Sync {
+        Mode NOTRACK {
+          DisableExternalCache on
+          DisableInternalCache on
+        }
+        TCP {
+          IPv4_address 192.168.100.2
+          IPv4_Destination_Address 192.168.100.3
+          Interface veth2
+          Port 3780
+        }
+      }
+      General {
+        LogFile on
+        LockFile /var/lock/conntrack-nsr1.lock
+        UNIX { Path /var/run/conntrackd-nsr1.ctl }
+      }
+      EOF
+    - |
+      cat << EOF > /tmp/nsr2.conf
+      Sync {
+        Mode NOTRACK {
+          DisableExternalCache on
+          DisableInternalCache on
+        }
+        TCP {
+          IPv4_address 192.168.100.3
+          IPv4_Destination_Address 192.168.100.2
+          Interface veth0
+          Port 3780
+        }
+      }
+      General {
+        LogFile on
+        LockFile /var/lock/conntrack-nsr2.lock
+        UNIX { Path /var/run/conntrackd-nsr2.ctl }
+      }
+      EOF
+    # finally run the daemons
+    - ip netns exec nsr1 $CONNTRACKD -C /tmp/nsr1.conf -d
+    - ip netns exec nsr2 $CONNTRACKD -C /tmp/nsr2.conf -d
+    # make sure they are alive and connected before considering the scenario started
+    - timeout 5 bash -c -- '
+      while ! ip netns exec nsr1 $CONNTRACKD -C /tmp/nsr1.conf -s | grep -q "server=connected"
+      ; do sleep 0.5 ; done'
+    - timeout 5 bash -c -- '
+      while ! ip netns exec nsr1 $CONNTRACKD -C /tmp/nsr1.conf -s | grep -q "client=connected"
+      ; do sleep 0.5 ; done'
+    - timeout 5 bash -c -- '
+      while ! ip netns exec nsr2 $CONNTRACKD -C /tmp/nsr2.conf -s | grep -q "server=connected"
+      ; do sleep 0.5 ; done'
+    - timeout 5 bash -c -- '
+      while ! ip netns exec nsr2 $CONNTRACKD -C /tmp/nsr2.conf -s | grep -q "client=connected"
+      ; do sleep 0.5 ; done'
+  stop:
+    - $CONNTRACKD -C /tmp/nsr1.conf -k 2>/dev/null
+    - $CONNTRACKD -C /tmp/nsr2.conf -k 2>/dev/null
+    - rm -f /tmp/ruleset.nft /tmp/nsr2.conf /tmp/nsr1.conf
+    - rm -f /var/lock/conntrack-nsr1.lock /var/lock/conntrack-nsr2.lock
+    - ip netns del ns1 || true
+    - ip netns del ns2 || true
+    - ip netns del nsr1 || true
+    - ip netns del nsr2 || true
diff --git a/tests/tests.yaml b/tests/tests.yaml
index 8324dbe..872269d 100644
--- a/tests/tests.yaml
+++ b/tests/tests.yaml
@@ -39,3 +39,14 @@
   # check that we can obtain stats via unix socket: expect (no output)
   test:
     - $CONNTRACKD -C /tmp/conntrackd_test_simple_stats -s expect
+
+- name: tcp_notrack_replicate_icmp
+  scenario: basic_2_peer_network_tcp_notrack
+  # check that we can replicate a ICMP conntrack entry in a 2 conntrackd TCP/NOTRACK setup
+  test:
+    # PING should inject an ICMP conntrack entry in nsr1
+    - ip netns exec ns1 ping -c1 10.0.1.2 >/dev/null
+    # verify conntrack entry is then replicated to nsr2, wait up to 5 seconds
+    - timeout 5 bash -c -- '
+      while ! ip netns exec nsr2 $CONNTRACK -L -p icmp 2>/dev/null | grep -q icmp
+      ; do sleep 0.5 ; done'

