Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD4DC352A1
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 15:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiLGPIi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 10:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLGPIi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 10:08:38 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E4C140448
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 07:08:36 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mm@skelett.io, ecklm94@gmail.com, akp@cohaesio.com, fw@strlen.de,
        arturo@netfilter.org, phil@nwl.cc, eric@regit.org,
        sbrivio@redhat.com, ffmancera@riseup.net, nevola@gmail.com,
        ssuryaextr@gmail.com
Subject: [PATCH nft] src: Add GPLv2+ header to .c files of recent creation
Date:   Wed,  7 Dec 2022 16:08:15 +0100
Message-Id: <20221207150815.73934-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch comes after a proposal of mine at NFWS 2022 that resulted in
agreement to license recent .c files under GPLv2+ by the attendees at this
meeting:

- Stefano Brivio
- Fernando F. Mancera
- Phil Sutter
- Jozsef Kadlecsik
- Florian Westphal
- Laura Garcia
- Arturo Borrero
- Pablo Neira

It has already happened that one of the external library dependencies
was moved to GPLv3+ (libreadline), resulting in a change to libedit by
default in b4dded0ca78d ("configure: default to libedit for cli").

I have added the GPLv2+ header to the following files:

                        Authors
                        -------
src/cmd.c               Pablo
src/fib.c               Florian
src/hash.c              Pablo
src/iface.c             Pablo
src/json.c              Phil + fixes from occasional contributors
src/libnftables.c       Eric Leblond and Phil
src/mergesort.c         Elise Lenion
src/misspell.c          Pablo
src/mnl.c               Pablo + fixes from occasional contributors
src/monitor.c           Arturo
src/numgen.c            Pablo
src/osf.c               Fernando
src/owner.c             Pablo
src/parser_json.c       Phil + fixes from occasional contributors
src/print.c             Phil
src/xfrm.c              Florian
src/xt.c                Pablo

Eric Leblond and Elise Lennion did not attend NFWS 2022, but they
acknowledged this license update already in the past when I proposed
this to them in private emails.

Update COPYING file too to refer that we are now moving towards GPLv2 or
any later.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I am also Cc'ing the following authors that I did not reach out yet:

src/tcpopt.c            Manuel Messner
src/socket.c            Mate Eckl
src/rt.c                Anders K. Pedersen
src/ipopt.c             Stephen Suryaputra

in case they have a chance to acknowledge the update of the license header
of their original .c files to GPLv2+.

 COPYING           | 8 ++++----
 src/cmd.c         | 8 ++++++++
 src/fib.c         | 4 ++--
 src/hash.c        | 4 ++--
 src/iface.c       | 4 ++--
 src/json.c        | 8 ++++++++
 src/libnftables.c | 5 ++---
 src/mergesort.c   | 4 ++--
 src/misspell.c    | 8 ++++++++
 src/mnl.c         | 4 ++--
 src/monitor.c     | 4 ++--
 src/numgen.c      | 4 ++--
 src/osf.c         | 8 ++++++++
 src/owner.c       | 8 ++++++++
 src/parser_json.c | 8 ++++++++
 src/print.c       | 5 ++---
 src/xfrm.c        | 6 ++++--
 src/xt.c          | 6 +++---
 18 files changed, 77 insertions(+), 29 deletions(-)

diff --git a/COPYING b/COPYING
index bf7f06ebabe0..a0dd81b918a2 100644
--- a/COPYING
+++ b/COPYING
@@ -1,8 +1,8 @@
+Original author of nftables distributed the code under the terms of the
+GPL version 2 *only*. New code though is moving to GPL version 2 or any
+later which is the preferred license for this project these days.
 
-nftables is distributed under the terms of the GPL version 2. Note that
-*only* version 2 of the GPL applies, not "any later version".
-
-Patrick McHardy <kaber@trash.net>
+Pablo Neira Ayuso <pablo@netfilter.org>
 
 -------------------------------------------------------------------------------
 
diff --git a/src/cmd.c b/src/cmd.c
index 63692422e765..9e375078b0ac 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -1,3 +1,11 @@
+/*
+ * Copyright (c) 2020 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
 #include <erec.h>
 #include <mnl.h>
 #include <cmd.h>
diff --git a/src/fib.c b/src/fib.c
index c6ad0f9c5d15..98c5786891f7 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -4,8 +4,8 @@
  * Copyright (c) Red Hat GmbH.	Author: Florian Westphal <fw@strlen.de>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
  */
 
 #include <nftables.h>
diff --git a/src/hash.c b/src/hash.c
index 42c504073ae8..a3fd0872c3b9 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -4,8 +4,8 @@
  * Copyright (c) 2016 Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
  */
 
 #include <nftables.h>
diff --git a/src/iface.c b/src/iface.c
index c0642e0cc397..3647778c1f0d 100644
--- a/src/iface.c
+++ b/src/iface.c
@@ -2,8 +2,8 @@
  * Copyright (c) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
  */
 
 #include <stdio.h>
diff --git a/src/json.c b/src/json.c
index 6662f8087736..ba5a4fb75dc3 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1,3 +1,11 @@
+/*
+ * Copyright (c) Red Hat GmbH.  Author: Phil Sutter <phil@nwl.cc>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <string.h>
diff --git a/src/libnftables.c b/src/libnftables.c
index a376825d7309..ec01a427d6cc 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -2,9 +2,8 @@
  * Copyright (c) 2017 Eric Leblond <eric@regit.org>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
  */
 #include <nftables/libnftables.h>
 #include <erec.h>
diff --git a/src/mergesort.c b/src/mergesort.c
index dca71422dd94..a3a9d6050ccb 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -2,8 +2,8 @@
  * Copyright (c) 2017 Elise Lennion <elise.lennion@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
  */
 
 #include <stdint.h>
diff --git a/src/misspell.c b/src/misspell.c
index 6536d7557a44..8992c75e7bc1 100644
--- a/src/misspell.c
+++ b/src/misspell.c
@@ -1,3 +1,11 @@
+/*
+ * Copyright (c) 2018 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
 #include <stdlib.h>
 #include <string.h>
 #include <limits.h>
diff --git a/src/mnl.c b/src/mnl.c
index e87b033870b0..62b0b59c2da8 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -2,8 +2,8 @@
  * Copyright (c) 2013-2017 Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
diff --git a/src/monitor.c b/src/monitor.c
index 4b55872b5388..9692b859e6eb 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -2,8 +2,8 @@
  * Copyright (c) 2015 Arturo Borrero Gonzalez <arturo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
  */
 
 #include <string.h>
diff --git a/src/numgen.c b/src/numgen.c
index ea2b262605f7..256514d14671 100644
--- a/src/numgen.c
+++ b/src/numgen.c
@@ -4,8 +4,8 @@
  * Copyright (c) 2016 Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
  */
 
 #include <nftables.h>
diff --git a/src/osf.c b/src/osf.c
index cb58315d714d..c611b542206d 100644
--- a/src/osf.c
+++ b/src/osf.c
@@ -1,3 +1,11 @@
+/*
+ * Copyright (c) 2018 Fernando Fernandez Mancera <ffmancera@riseup.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
 #include <nftables.h>
 #include <expression.h>
 #include <utils.h>
diff --git a/src/owner.c b/src/owner.c
index 2d98a2e98028..804e8c8b7342 100644
--- a/src/owner.c
+++ b/src/owner.c
@@ -1,3 +1,11 @@
+/*
+ * Copyright (c) 2021 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
 #include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
diff --git a/src/parser_json.c b/src/parser_json.c
index aa00e9ecd65c..5b47e69ccae0 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1,3 +1,11 @@
+/*
+ * Copyright (c) Red Hat GmbH.  Author: Phil Sutter <phil@nwl.cc>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
 #define _GNU_SOURCE
 #include <errno.h>
 #include <stdint.h> /* needed by gmputil.h */
diff --git a/src/print.c b/src/print.c
index d1b25e8be871..4896e13c2ca5 100644
--- a/src/print.c
+++ b/src/print.c
@@ -2,9 +2,8 @@
  * Copyright (c) 2017 Phil Sutter <phil@nwl.cc>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
  */
 
 #include <stdarg.h>
diff --git a/src/xfrm.c b/src/xfrm.c
index 80f0ea037429..b27821a922f5 100644
--- a/src/xfrm.c
+++ b/src/xfrm.c
@@ -1,9 +1,11 @@
 /*
  * XFRM (ipsec) expression
  *
+ * Copyright (c) Red Hat GmbH.  Author: Florian Westphal <fw@strlen.de>
+ *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
  */
 
 #include <nftables.h>
diff --git a/src/xt.c b/src/xt.c
index a54173522c22..cde98ced2f48 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -2,9 +2,9 @@
  * Copyright (c) 2013-2015 Pablo Neira Ayuso <pablo@netfilter.org>
  * Copyright (c) 2015 Arturo Borrero Gonzalez <arturo@debian.org>
  *
- * This program is free software; you can redistribute it and/or modifyi
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
  */
 
 #include <stdlib.h>
-- 
2.30.2

