Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8706AC432BE
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Sep 2021 11:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FA2961057
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Sep 2021 11:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbhIBLdv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Sep 2021 07:33:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230256AbhIBLdv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Sep 2021 07:33:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630582372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UI8SrSsAgaBRGvO9QqEKZTG9LYM0R6+2xxhLk+5Gz38=;
        b=QDwyomxOX62vVorV7Syi1A2UW6ZNoRiNZUcNisaOHd2EQi3k03WWCsv65H2r2skFGckJZi
        FkVMwr2qoN1fVBLs4qLpMchreLXSOkdAK2RvqZEkAI/XG/7iA+qgc66UK+z30JO6pi/jLE
        VCG3JmlRE4xO5EkfMgf7rxOiKiTm/X4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-HmYCbDBJMP6ECFY5nT5jZg-1; Thu, 02 Sep 2021 07:32:51 -0400
X-MC-Unique: HmYCbDBJMP6ECFY5nT5jZg-1
Received: by mail-wm1-f72.google.com with SMTP id v2-20020a7bcb420000b02902e6b108fcf1so864975wmj.8
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Sep 2021 04:32:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UI8SrSsAgaBRGvO9QqEKZTG9LYM0R6+2xxhLk+5Gz38=;
        b=TKLxOYLTFyU28F7IuovHf2aogUc8jUZbesAYbW1dcEb4WYrf5hS01QzVTmrlYmNfnu
         OVtLZ/3m3ThaPmSPRFwJdaIr9fnJIzpenCAvM8ffcqdls/aH2YslcUIwfA2VCUX4iSbx
         JvUu6eWnuUsjiHx1Vw84R2AA897N60MsP6fbmWbQiuZnRKg2PntWqglkBvMZSBYCB4SG
         v+ex4ERcgkvmUDBt0PYu2aHcQRAIHy0KiIP7w+0k6wHLpna8bI74BWjuj0AQouw2eNEh
         T0MDi5Uq4tegLuKVuB8HaXsT8JMkiq4mN1Z2TaUZQxsyYhH6W/BPm6oiSKCHzDXCzwOK
         Rv4g==
X-Gm-Message-State: AOAM531EkDJGtDIr99q0fiyqgP+d0RDtkqbiL30bplJr0ikgA498jSOf
        YlNcP7tECA/7eVmpKap85yHjmfTBf6jyCz4xf0zF5kh/DVpxT9KjCj2LspcoRShj3tRyyBrBMMT
        zWgPKANXnPSq+8jER/TbR7qEWFqGSLStcJQXVkhhB9TAcimhuaGnNok9JzZpBI/0HEa8I0onjWC
        HPkw==
X-Received: by 2002:adf:9e01:: with SMTP id u1mr3291599wre.250.1630582369653;
        Thu, 02 Sep 2021 04:32:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdBs59EtJbDKQT2JaykW6S4ZM/ySfo3XBsz8+hsuPiE8qLxAZBSVkzxQzFVH97XKrwNbycJg==
X-Received: by 2002:adf:9e01:: with SMTP id u1mr3291579wre.250.1630582369481;
        Thu, 02 Sep 2021 04:32:49 -0700 (PDT)
Received: from localhost ([185.112.167.33])
        by smtp.gmail.com with ESMTPSA id c7sm1343534wmq.13.2021.09.02.04.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 04:32:49 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] iptables-test.py: print with color escapes only when stdout isatty
Date:   Thu,  2 Sep 2021 13:33:07 +0200
Message-Id: <20210902113307.2368834-1-snemec@redhat.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When the output doesn't go to a terminal (typical case: log files),
the escape sequences are just noise.

Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 iptables-test.py | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 90e07feed365..e8fc0c75a43e 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -32,22 +32,25 @@ EXTENSIONS_PATH = "extensions"
 LOGFILE="/tmp/iptables-test.log"
 log_file = None
 
+STDOUT_IS_TTY = sys.stdout.isatty()
 
-class Colors:
-    HEADER = '\033[95m'
-    BLUE = '\033[94m'
-    GREEN = '\033[92m'
-    YELLOW = '\033[93m'
-    RED = '\033[91m'
-    ENDC = '\033[0m'
+def maybe_colored(color, text):
+    terminal_sequences = {
+        'green': '\033[92m',
+        'red': '\033[91m',
+    }
+
+    return (
+        terminal_sequences[color] + text + '\033[0m' if STDOUT_IS_TTY else text
+    )
 
 
 def print_error(reason, filename=None, lineno=None):
     '''
     Prints an error with nice colors, indicating file and line number.
     '''
-    print(filename + ": " + Colors.RED + "ERROR" +
-        Colors.ENDC + ": line %d (%s)" % (lineno, reason))
+    print(filename + ": " + maybe_colored('red', "ERROR") +
+        ": line %d (%s)" % (lineno, reason))
 
 
 def delete_rule(iptables, rule, filename, lineno):
@@ -282,7 +285,7 @@ def run_test_file(filename, netns):
     if netns:
         execute_cmd("ip netns del ____iptables-container-test", filename, 0)
     if total_test_passed:
-        print(filename + ": " + Colors.GREEN + "OK" + Colors.ENDC)
+        print(filename + ": " + maybe_colored('green', "OK"))
 
     f.close()
     return tests, passed

base-commit: e438b9766fcc86d9847312ff05f1d1dac61acf1f
-- 
2.33.0

