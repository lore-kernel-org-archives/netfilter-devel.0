Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E55C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Jan 2021 00:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D989225AC
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Jan 2021 00:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAXA0B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Jan 2021 19:26:01 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:38442 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbhAXA0A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Jan 2021 19:26:00 -0500
Received: by mail-wm1-f50.google.com with SMTP id y187so7600871wmd.3
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Jan 2021 16:25:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fiD6ShV9WdvwE35tCTVDktM9FR0Pg/bbWfKOAmX7OVI=;
        b=Ch+YHEHGi9srAzat8CvaTYwQ20IrEo5fVc9/MGzA2gtDMu2HDA9hk+j+me5KV0Yz2E
         YPIxNrWAAqvX+LMC/d6J+8ZHqRyF+FcVERMHMqGYDKwweoj8Q+znQBwITII1xlce/Oyq
         JiXT/Fm8nfoGMQ7txASSL4ld3kjv5eclqPNv9mCbDTdkKaK/G6Vjv1uHEBcsUbkUKt+C
         AvMIbrtvcSlPpFf4ZLrM8SFJ8qkC1/gRBiv04s31WupFD63oXijff8TMmJU+yNPo3jKY
         +wRj9AG8Xi6TXsToKtmbwn+MgFbbS5tJyMRZbdrHkVNP2ENcAcnw30G4VTWKRHzpFdGo
         02OA==
X-Gm-Message-State: AOAM530oF62JtN8HuPa1kuw8b/dPLHrliJlIBcvKjnHG2ExFpvvWt1U7
        9GWBuoQ1HdLZ6B/Forkx3II7ttDhp8gNyw==
X-Google-Smtp-Source: ABdhPJzjh59EC1rzgTO8sSc2ceFZ+5DZY6p0cP81hTLgwFALZSrs3MT+z2YfzmHQ+4pfcMgOU9uPug==
X-Received: by 2002:a05:600c:4e92:: with SMTP id f18mr670612wmq.126.1611447917954;
        Sat, 23 Jan 2021 16:25:17 -0800 (PST)
Received: from localhost ([213.194.141.17])
        by smtp.gmail.com with ESMTPSA id a6sm15786883wmj.27.2021.01.23.16.25.17
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 16:25:17 -0800 (PST)
Subject: [conntrack-tools PATCH 2/3] tests: introduce some basic testcases for
 the new conntrack-tools testing framework
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Sun, 24 Jan 2021 01:25:16 +0100
Message-ID: <161144776375.52227.12269218816564941347.stgit@endurance>
In-Reply-To: <161144773322.52227.18304556638755743629.stgit@endurance>
References: <161144773322.52227.18304556638755743629.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce some initial basic testcases for configuration parsing and standard daemon startup and
shutdown routines.

This should give an example of how the framework works.

Here is an example of running this:

=== 8< ===
$ cd tests/ ; sudo ./cttools-testing-framework.py
[cttools-testing-framework.py] INFO: --- running test: stats_general
[cttools-testing-framework.py] INFO: --- passed test: stats_general
[cttools-testing-framework.py] INFO: --- running test: stats_network
[cttools-testing-framework.py] INFO: --- passed test: stats_network
[cttools-testing-framework.py] INFO: --- running test: stats_runtime
[cttools-testing-framework.py] INFO: --- passed test: stats_runtime
[cttools-testing-framework.py] INFO: --- running test: stats_process
[cttools-testing-framework.py] INFO: --- passed test: stats_process
[cttools-testing-framework.py] INFO: --- running test: stats_queue
[cttools-testing-framework.py] INFO: --- passed test: stats_queue
[cttools-testing-framework.py] INFO: --- running test: stats_ct
[cttools-testing-framework.py] INFO: --- passed test: stats_ct
[cttools-testing-framework.py] INFO: --- running test: stats_expect
[cttools-testing-framework.py] INFO: --- passed test: stats_expect
[cttools-testing-framework.py] INFO: ---
[cttools-testing-framework.py] INFO: --- finished
[cttools-testing-framework.py] INFO: --- passed tests: 7
[cttools-testing-framework.py] INFO: --- failed tests: 0
[cttools-testing-framework.py] INFO: --- scenario failure: 0
[cttools-testing-framework.py] INFO: --- total tests: 7
=== 8< ===

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
HINT: if you fuzz a bit the conntrackd.conf file in this scenario these simple tests fails with
several segfaults.

 env.yaml       |    2 ++
 scenarios.yaml |   19 +++++++++++++++++++
 tests.yaml     |   41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)

diff --git a/tests/env.yaml b/tests/env.yaml
new file mode 100644
index 0000000..8a7514b
--- /dev/null
+++ b/tests/env.yaml
@@ -0,0 +1,2 @@
+- CONNTRACKD: ../src/conntrackd
+- CONNTRACK: ../src/conntrack
diff --git a/tests/scenarios.yaml b/tests/scenarios.yaml
new file mode 100644
index 0000000..a47e1a1
--- /dev/null
+++ b/tests/scenarios.yaml
@@ -0,0 +1,19 @@
+- name: simple_stats
+  start:
+    - rm -f /var/lock/conntrack.lock
+    - |
+      cat << EOF > /tmp/conntrackd_test_simple_stats
+      General {
+        HashSize 8192
+        LockFile /var/lock/conntrack.lock
+        UNIX { Path /var/run/conntrackd.ctl }
+      }
+      Stats {
+        LogFile on
+      }
+      EOF
+    - $CONNTRACKD -C /tmp/conntrackd_test_simple_stats -d
+  stop:
+    - $CONNTRACKD -C /tmp/conntrackd_test_simple_stats -k
+    - rm -f /var/lock/conntrack.lock
+    - rm -f /tmp/conntrackd_test_simple_stats
diff --git a/tests/tests.yaml b/tests/tests.yaml
new file mode 100644
index 0000000..8324dbe
--- /dev/null
+++ b/tests/tests.yaml
@@ -0,0 +1,41 @@
+- name: stats_general
+  scenario: simple_stats
+  # check that we can obtain stats via unix socket: general
+  test:
+    - $CONNTRACKD -C /tmp/conntrackd_test_simple_stats -s | grep -q "cache stats"
+
+- name: stats_network
+  scenario: simple_stats
+  # check that we can obtain stats via unix socket: network (no output)
+  test:
+    - $CONNTRACKD -C /tmp/conntrackd_test_simple_stats -s network
+
+- name: stats_runtime
+  scenario: simple_stats
+  # check that we can obtain stats via unix socket: runtime
+  test:
+    - $CONNTRACKD -C /tmp/conntrackd_test_simple_stats -s runtime | grep -q uptime
+
+- name: stats_process
+  scenario: simple_stats
+  # check that we can obtain stats via unix socket: process (no output)
+  test:
+    - $CONNTRACKD -C /tmp/conntrackd_test_simple_stats -s process
+
+- name: stats_queue
+  scenario: simple_stats
+  # check that we can obtain stats via unix socket: queue (no output)
+  test:
+    - $CONNTRACKD -C /tmp/conntrackd_test_simple_stats -s queue
+
+- name: stats_ct
+  scenario: simple_stats
+  # check that we can obtain stats via unix socket: ct
+  test:
+    - $CONNTRACKD -C /tmp/conntrackd_test_simple_stats -s ct | grep -q traffic
+
+- name: stats_expect
+  scenario: simple_stats
+  # check that we can obtain stats via unix socket: expect (no output)
+  test:
+    - $CONNTRACKD -C /tmp/conntrackd_test_simple_stats -s expect

