From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: abort autogen on subcommand failure
Date: Sat, 20 Aug 2011 16:59:22 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108201659140.25053@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:34059 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab1HTO7Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Aug 2011 10:59:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 8ed1c866e2e7716a1f7330a79c9268c7356c60ac (v6.8-1-g8ed1c86)
commit 94de0ce4cce9d104c0a3e189208445b15f0ea2cd
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Aug 1 21:26:24 2011 +0200

build: abort autogen on subcommand failure

Needed to stop an automated build process when automake requirements
are not fulfilled.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 autogen.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index d0d5d98..9c0f327 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/sh -e
 
 aclocal -I m4
 autoreconf -fi
-- 
# Created with git-export-patch

