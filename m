Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A61C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Aug 2021 15:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E248613DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Aug 2021 15:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhHWP6T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbhHWP6Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 11:58:16 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3234C061575
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Aug 2021 08:57:33 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id j14-20020a1c230e000000b002e748b9a48bso248507wmj.0
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Aug 2021 08:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2r2imDY3QPoMJCrBw88GqVYE6K+x9CGud1HyAcA2IbY=;
        b=hEbDwN560VICD0vElFt/sFYtqZqhNENGq8FNo/CGASsc+Pkj7Bb0Xl+aUz20zApM4q
         tKSl9BQjmhDd/ye6GbrFt/6bc83yqUI4YpJ4laDipazTjAx4bJaYfsRqW9QZ1fvm3llt
         Lr6dVZWxXZStsOwxqAnUvUg4A4XragoT45dTWoFKWNCoSXnw0oyPCEjUKN4WjrUmQXBd
         gRO3NKO3sfQnX5l6XxiSXbBS/eOwiZS4nkFXyPhNsGPJmbYZQtrphVKZbmYZMwxL9Ij+
         UxxhnXsya6W8XI38CwE9+lFBwfQcEcD3cGD3bIe1+qXJoZANOpjMt5WpaqfLQ1oFFX1w
         VwwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2r2imDY3QPoMJCrBw88GqVYE6K+x9CGud1HyAcA2IbY=;
        b=YnebtBEEWlI6ewXE0G1JbubFlr/xMbZYB0foajEyPyi5AkM7RFgSF03RQyQ2Kwccn4
         Dv4XyQ01A2mrNZlW/XwIf8Lr4SNKe1AgoQf21h0S3Yr06RY7Cd8/pT1mD+G6pQnS+Cqy
         DGcbPBqs5SaxdNCGvdEjABO1CrA3gMA/NWWRreTe3bRBjE2Y9yDfm1x3poruER8/Nepl
         xJFnvvcQ/rt/KnUEo2mYWVQWzV/PmwW5/ez0EDGUcH9f9rSqpskC8PLyHS41J4fF5lju
         QsgELupEe8Yv9YueiuxXvCn6DhogfLaOoiMohvmEKlM2c7eBTdhZJZgDlxQOoIlRuXGP
         4fYg==
X-Gm-Message-State: AOAM530k9MXL85ZXZjjZ49DgZu8BDyTP2W902d1K7WreIP8GZ0qcW+5s
        wtPgP+3uPxP+3xvvww0ZraneAYpgXmwYoA==
X-Google-Smtp-Source: ABdhPJzvmsCWA9IP4VlXE2o9oXGSdRJMigS2qJXGyFbmw11c9nNQhWPgX3R14d5g+bx3TL0MrV0E6g==
X-Received: by 2002:a05:600c:1ca9:: with SMTP id k41mr16611535wms.39.1629734252182;
        Mon, 23 Aug 2021 08:57:32 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf74b.dynamic.kabel-deutschland.de. [95.91.247.75])
        by smtp.gmail.com with ESMTPSA id m16sm3744501wmq.8.2021.08.23.08.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 08:57:31 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 1/2] tests/conntrack: script for stress-testing ct load
Date:   Mon, 23 Aug 2021 17:57:14 +0200
Message-Id: <20210823155715.81729-2-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823155715.81729-1-mikhail.sennikovskii@ionos.com>
References: <20210823155715.81729-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The tests/conntrack/bulk-load-stress.sh is intended to be used for
stress-testing the bulk load of ct entries from a file (-R option).

Script usage detail is given by the ./bulk-load-stress.sh -h

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 tests/conntrack/bulk-load-stress.sh | 152 ++++++++++++++++++++++++++++
 1 file changed, 152 insertions(+)
 create mode 100755 tests/conntrack/bulk-load-stress.sh

diff --git a/tests/conntrack/bulk-load-stress.sh b/tests/conntrack/bulk-load-stress.sh
new file mode 100755
index 0000000..de7bd8d
--- /dev/null
+++ b/tests/conntrack/bulk-load-stress.sh
@@ -0,0 +1,152 @@
+#!/bin/bash
+
+DEFAULT_CT="../../src/conntrack"
+DEFAULT_SPORT_COUNT=0xffff
+DEFAULT_DPORT_COUNT=0x2
+DEFAULT_TMP_FILE="./ct_data.txt"
+DEFAULT_CT_ZONE=123
+DEFAULT_GEN_ONLY=0
+DEFAULT_CLEANUP_INDIVIDUAL=0
+
+
+CT=$DEFAULT_CT
+SPORT_COUNT=$DEFAULT_SPORT_COUNT
+DPORT_COUNT=$DEFAULT_DPORT_COUNT
+TMP_FILE=$DEFAULT_TMP_FILE
+CT_ZONE=$DEFAULT_CT_ZONE
+GEN_ONLY=$DEFAULT_GEN_ONLY
+CLEANUP_INDIVIDUAL=$DEFAULT_CLEANUP_INDIVIDUAL
+
+
+print_help()
+{
+  me=$(basename "$0")
+
+  echo "Script for stress-testing bulk ct entries load (-R option)"
+  echo ""
+  echo "Usage: $me [options]"
+  echo ""
+  echo "Where options can be:"
+  echo ""
+  echo "-dpc <dst_port_count> -  number of destination port values."
+  echo "                         Default is ${DEFAULT_DPORT_COUNT}."
+  echo ""
+  echo "-spc <src_port_count> -  number of source port values."
+  echo "                         Default is ${DEFAULT_SPORT_COUNT}."
+  echo ""
+  echo "-ct <ct_tool_path>    -  path to the conntrack tool."
+  echo "                         Default is ${DEFAULT_CT}."
+  echo ""
+  echo "-z <ct_zone>          -  ct zone to be used."
+  echo "                         Default is ${DEFAULT_CT_ZONE}."
+  echo ""
+  echo "-f <tmp_file_name>    -  tmp file to be used to generate the ct data to."
+  echo "                         Default is ${DEFAULT_TMP_FILE}."
+  echo ""
+  echo "-g                    -  Generate tmp file and exit."
+  echo ""
+  echo "-h                    -  Print this help and exit."
+}
+
+
+while [ $# -gt 0 ]
+do
+  case "$1" in
+    -spc)  SPORT_COUNT=${2:-}
+      if [ -z "$SPORT_COUNT" ]
+      then
+        echo "Source port must be specified!"
+        print_help
+        exit 1
+      fi
+      shift
+      ;;
+    -dpc)  DPORT_COUNT=${2:-}
+      if [ -z "$DPORT_COUNT" ]
+      then
+        echo "Destination port must be specified!"
+        print_help
+        exit 1
+      fi
+      shift
+      ;;
+    -ct)   CT=${2:-}
+      if [ -z "$CT" ]
+      then
+        echo "conntrack path must be specified!"
+        print_help
+        exit 1
+      fi
+      shift
+      ;;
+    -z)    CT_ZONE=${2:-}
+      if [ -z "$CT_ZONE" ]
+      then
+        echo "ct zone must be specified!"
+        print_help
+        exit 1
+      fi
+      shift
+      ;;
+    -f)    TMP_FILE=${2:-}
+      if [ -z "$TMP_FILE" ]
+      then
+        echo "Tmp file must be specified!"
+        print_help
+        exit 1
+      fi
+      shift
+      ;;
+    -g)    GEN_ONLY=1
+      ;;
+    -ci)   CLEANUP_INDIVIDUAL=1
+      ;;
+    -h)    print_help
+      exit 1
+      ;;
+    *)     echo "Unknown paramerer \"$1\""
+      print_help
+      exit 1
+      ;;
+  esac
+  shift
+done
+
+
+function ct_data_gen()
+{
+  for (( d = 1; d <= $DPORT_COUNT; d++ )) do
+    for (( s = 1; s <= $SPORT_COUNT; s++ )) do
+      echo "-I -w $CT_ZONE -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport ${s} --dport ${d} --state LISTEN -u SEEN_REPLY -t 50"
+    done
+  done
+}
+
+ct_data_gen > $TMP_FILE
+
+NUM_ENTRIES=$(cat ${TMP_FILE} | wc -l)
+
+echo "File ${TMP_FILE} is generated, number of entries: ${NUM_ENTRIES}."
+
+if [ "$GEN_ONLY" -eq "1" ]; then
+  exit 0
+fi
+
+echo "Loading ${NUM_ENTRIES} entries from ${TMP_FILE} .."
+sudo time -p ${CT} -R $TMP_FILE
+
+if [ "$CLEANUP_INDIVIDUAL" -eq "1" ]; then
+  sed -i -e "s/-I/-D/g" -e "s/-t 50//g" $TMP_FILE
+
+  NUM_ENTRIES=$(cat ${TMP_FILE} | wc -l)
+
+  echo "File ${TMP_FILE} is updated, number of entries: ${NUM_ENTRIES}."
+
+  echo "Cleaning ${NUM_ENTRIES} entries from ${TMP_FILE} .."
+  sudo time -p ${CT} -R $TMP_FILE
+fi
+
+
+echo "Cleaning up zone ${CT_ZONE}.."
+sudo time -p ${CT} -D -w $CT_ZONE > /dev/null
+rm $TMP_FILE
-- 
2.25.1

