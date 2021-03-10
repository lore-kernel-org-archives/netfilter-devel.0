Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D59C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Mar 2021 12:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C09E64FE5
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Mar 2021 12:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhCJMhd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 07:37:33 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:36785 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbhCJMhG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 07:37:06 -0500
Received: by mail-wr1-f48.google.com with SMTP id u14so23145097wri.3
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Mar 2021 04:37:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=vuVt5QcG8C2+Dpx7+Ib7265GaQAy0gGfGDMJW3ZnrTU=;
        b=rlAKB/u0TafcRZjDxrxYhs+ABewmVB96urNRPKM7epH/0hkOfYfsLFqZmFuPswkEkK
         dHt4HwzW7BYntiHMNZOWfBj6llnj5+DefS8APmKAAUiGdUVxVbEQqf+tCyHW438YfbvA
         cUHX6OwGhgpolOjqv8DVgSRs3SLcjdE3DsdvxIj8BJP0LfiGtdOxz5JLhcxcbYUQzvnV
         3ifae/kClsO1OhKijhVSejhMW8OZEUQh3QSxahF8V+saJ807zJxvMq6I85chOb73iMVY
         V837fu6eCuutZguF1ZOIyOfvE33JKAWPZ9ZHvVj26ly9yN5lT1li4YS1svjZ9e5DH3eh
         1PAA==
X-Gm-Message-State: AOAM533NeadRMZ+TaU/3+vI5tL+eJq8imghdXj/dTRiOFcWWvcuVyWOU
        X2bm80GeizpwKxHYnP+L8wSTeksRiPQJ/Q==
X-Google-Smtp-Source: ABdhPJylqDGWmro6oMcRNKu2siZ6lngFmw9Hv+hEuyhW1n+ERuB0IZOAj2H33RvmW2e+eBBE1SvCOw==
X-Received: by 2002:a5d:640b:: with SMTP id z11mr3239209wru.327.1615379824834;
        Wed, 10 Mar 2021 04:37:04 -0800 (PST)
Received: from localhost (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id g202sm9141455wme.20.2021.03.10.04.37.03
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:37:04 -0800 (PST)
Subject: [conntrack-tools PATCH 1/2] tests: conntrackd: add testcase for
 missing hashtable buckets and max entries
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Wed, 10 Mar 2021 13:37:03 +0100
Message-ID: <161537982333.41950.4295612522904541534.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This test case covers missing hashtable buckets and max entries configuration options. There should
be a value for them, otherwise the daemon segfaults.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 tests/conntrackd/scenarios.yaml |    5 +++++
 tests/conntrackd/tests.yaml     |   31 +++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/tests/conntrackd/scenarios.yaml b/tests/conntrackd/scenarios.yaml
index 6c425d0..65d6fa4 100644
--- a/tests/conntrackd/scenarios.yaml
+++ b/tests/conntrackd/scenarios.yaml
@@ -1,3 +1,8 @@
+- name: empty
+  start:
+    - ":"
+  stop:
+    - ":"
 - name: simple_stats
   start:
     - rm -f /var/lock/conntrack.lock
diff --git a/tests/conntrackd/tests.yaml b/tests/conntrackd/tests.yaml
index 872269d..307f38f 100644
--- a/tests/conntrackd/tests.yaml
+++ b/tests/conntrackd/tests.yaml
@@ -50,3 +50,34 @@
     - timeout 5 bash -c -- '
       while ! ip netns exec nsr2 $CONNTRACK -L -p icmp 2>/dev/null | grep -q icmp
       ; do sleep 0.5 ; done'
+
+- name: hash_defaults_segfault
+  scenario: empty
+  test:
+    - rm -f /var/lock/conntrack.lock
+    - |
+      cat << EOF > /tmp/conntrackd_notrack_hash_defaults
+      Sync {
+        Mode NOTRACK { }
+        Multicast {
+          IPv4_address 225.0.0.50
+          Group 3780
+          IPv4_interface 127.0.0.1
+          Interface lo
+          SndSocketBuffer 1249280
+          RcvSocketBuffer 1249280
+          Checksum on
+        }
+      }
+      General {
+        LogFile on
+        Syslog on
+        LockFile /var/lock/conntrackd.lock
+        UNIX { Path /var/run/conntrackd.sock }
+        NetlinkBufferSize 2097152
+        NetlinkBufferSizeMaxGrowth 8388608
+      }
+      EOF
+    - $CONNTRACKD -C /tmp/conntrackd_notrack_hash_defaults -d
+    - $CONNTRACKD -C /tmp/conntrackd_notrack_hash_defaults -s | grep -q "cache"
+    - $CONNTRACKD -C /tmp/conntrackd_notrack_hash_defaults -k

