Return-Path: <SRS0=9u1R=UN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDFDC31E4B
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 17:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E817121848
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 17:07:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KM72gDLw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfFNRHq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 13:07:46 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34392 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFNRHp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 13:07:45 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so1277962plt.1
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 10:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5mut3VHzc++C89VlR82Fhk54RhCT7KtndHaimCD8j3U=;
        b=KM72gDLwxkYQm0NCimzopMLxB/eJ7RAbmZfr2TV8wxeqm3A4jb2kyeBnsAvHuOy/Z9
         rL5tV6IUDqeZawyPNW5K5AfLG3znBTX2c7rNuoN3RNkHQ88nmN/lla1VYDEAWrpQ/7et
         VhDr/VdJvEY2kRV5x8jhU4hkeTGEgQ7YVJL6TJ6AsDmRi9lkjouIsBRt2KeJIubSoCxm
         IVK5jWxBSCGroGU6A+skwyDpM5NMn/k8mZL0j7RFQFHCymewa0pCcXXC3CISJkXDrtJu
         nKiBEWCI2Pw1X5hznU2UNF7hoX2kLYQTe+bojh3gHAW/H5RyWzSOPlFvVDTWcXPJgc17
         l9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5mut3VHzc++C89VlR82Fhk54RhCT7KtndHaimCD8j3U=;
        b=b/5fqQrrGYMXUkje+vfqFcjlDMNgVoS79eynaPvOEuXzgyu2jZfXMjSe9Ihnwy+ndi
         uJlzJChUjfAV1jVuwCBNIA5yp5KxrIk25OTVDwUxqFfAjwAda7HdwPnc+OV771fVvo0q
         i34Y1J3UqXmvKAHE7walmXq9lOXu+nZVb9Gdvx+liLjBGSRQjw3aEEZHZbSm5UTdL88G
         spU/hI0roDRFAD10elGnSKo6Byo+nYQzzNC+PqpK8TtIdWeZiOVgckPKRB0z7toicqco
         6UHF8a3RUeOiHRU4Oh8C6BzFlTJ8V6Qmhm3elw2g4XHfSk14JgC5nfRBZgpRaqZijBro
         tzjA==
X-Gm-Message-State: APjAAAV1Ap4/8RIlpAbM9UI6dyxtdp31T6EyD9I4poTdLex8/+5hgAAf
        z7ICxhw1jSDhHeZy7kO8NI0zVP3udMo=
X-Google-Smtp-Source: APXvYqy6vfjTdOTR2vhyq0PaOgbMbRuEYNHf5hxpx/Qb7zmRmxd/+QVVBm26rbubgqN9VH+ZRVpoBg==
X-Received: by 2002:a17:902:e281:: with SMTP id cf1mr14359618plb.271.1560532064665;
        Fri, 14 Jun 2019 10:07:44 -0700 (PDT)
Received: from shekhar.domain.name ([59.91.149.38])
        by smtp.gmail.com with ESMTPSA id c26sm1044503pfr.71.2019.06.14.10.07.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 10:07:44 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH WIP v1]tests: Makefile.am (Work in Progress)
Date:   Fri, 14 Jun 2019 22:37:33 +0530
Message-Id: <20190614170733.4164-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I have been trying to make a Makefile.am for the tests in nftables
so that all of them run when 'make check' is used.To do this, i have
done the following changes:
1. add AM_PATH_PYTHON statement to configure.ac
2. add tests in the SUBDIRS in Makefile.am
3. add a Makefile.am file in the tests directory

For now this is just for the two python tests, other tests will be added later.

Whenever i copy the .py test files from tests/json_echo and tests/py and paste them in the tests/ directory,
the Makefile.am runs and generates a report. But if the .py files remain where they are and 
are not copied, the Makefile.am fails to run.

I am not sure why. I have already specified there correct location in the Makefile.am.

Result when the two files are copied in tests directory:

Making check in tests
make[1]: Entering directory '/home/shekhar/at1_nftables/tests'
make  check-TESTS
make[2]: Entering directory '/home/shekhar/at1_nftables/tests'
make[3]: Entering directory '/home/shekhar/at1_nftables/tests'
FAIL: run-test.py
PASS: nft-test.py
============================================================================
Testsuite summary for nftables 0.9.0
============================================================================
# TOTAL: 2
# PASS:  1
# SKIP:  0
# XFAIL: 0
# FAIL:  1
# XPASS: 0
# ERROR: 0
============================================================================
See tests/test-suite.log
Please report to netfilter-devel@vger.kernel.org
============================================================================
Makefile:592: recipe for target 'test-suite.log' failed
make[3]: *** [test-suite.log] Error 1
make[3]: Leaving directory '/home/shekhar/at1_nftables/tests'
Makefile:698: recipe for target 'check-TESTS' failed
make[2]: *** [check-TESTS] Error 2
make[2]: Leaving directory '/home/shekhar/at1_nftables/tests'
Makefile:778: recipe for target 'check-am' failed
make[1]: *** [check-am] Error 2
make[1]: Leaving directory '/home/shekhar/at1_nftables/tests'
Makefile:494: recipe for target 'check-recursive' failed
make: *** [check-recursive] Error 1

=============================================================================

Result when they remain where they are:

Making check in tests
make[1]: Entering directory '/home/shekhar/at1_nftables/tests'
make  check-TESTS
make[2]: Entering directory '/home/shekhar/at1_nftables/tests'
make[3]: Entering directory '/home/shekhar/at1_nftables/tests'
/usr/bin/python json_echo/run-test.py
Error: flush ruleset failed: Error: syntax error, unexpected '{'
{"nftables": [{"flush": {"ruleset": null}}]}
^

Makefile:903: recipe for target 'run-test.py' failed
make[3]: *** [run-test.py] Error 1
make[3]: Leaving directory '/home/shekhar/at1_nftables/tests'
Makefile:698: recipe for target 'check-TESTS' failed
make[2]: *** [check-TESTS] Error 2
make[2]: Leaving directory '/home/shekhar/at1_nftables/tests'
Makefile:778: recipe for target 'check-am' failed
make[1]: *** [check-am] Error 2
make[1]: Leaving directory '/home/shekhar/at1_nftables/tests'
Makefile:494: recipe for target 'check-recursive' failed
make: *** [check-recursive] Error 1


Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
 Makefile.am       |  4 +++-
 configure.ac      |  3 +++
 tests/Makefile.am | 19 +++++++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)
 create mode 100644 tests/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index e567d32d..adccf7ff 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,10 +4,12 @@ SUBDIRS = 	src	\
 		include	\
 		files	\
 		doc		\
-		py
+		py	\
+		tests
 
 EXTRA_DIST =	tests	\
 		files
 
+
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnftables.pc
diff --git a/configure.ac b/configure.ac
index e3c0be2b..04ad1180 100644
--- a/configure.ac
+++ b/configure.ac
@@ -21,6 +21,8 @@ AC_ARG_ENABLE([man-doc],
 	      [], [enable_man_doc=yes])
 AM_CONDITIONAL([BUILD_MAN], [test "x$enable_man_doc" = "xyes" ])
 
+AM_PATH_PYTHON([1.0])
+
 # Checks for programs.
 AC_PROG_CC
 AC_PROG_MKDIR_P
@@ -126,6 +128,7 @@ AC_CONFIG_FILES([					\
 		files/osf/Makefile			\
 		doc/Makefile				\
 		py/Makefile				\
+		tests/Makefile				\
 		])
 AC_OUTPUT
 
diff --git a/tests/Makefile.am b/tests/Makefile.am
new file mode 100644
index 00000000..6b87af9e
--- /dev/null
+++ b/tests/Makefile.am
@@ -0,0 +1,19 @@
+
+checkdir=tests 
+
+python_PYTHON= run-test.py nft-test.py
+
+
+run-test.py: 
+	$(PYTHON) json_echo/run-test.py
+
+nft-test.py: 
+	$(PYTHON) py/nft-test.py
+	
+
+##run_test_py_SOURCES=json_echo/run-test.py
+
+##nft_test_py_SOURCES=py/nft-test.py
+
+TESTS= $(python_PYTHON)
+ 
-- 
2.17.1

