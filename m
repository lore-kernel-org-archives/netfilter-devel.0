From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] build: remove -fPIC flag
Date: Fri,  5 Nov 2010 19:30:42 +0100
Message-ID: <1288981844-22714-2-git-send-email-jengelh@medozas.de>
References: <1288981844-22714-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33313 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab0KESar (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:30:47 -0400
In-Reply-To: <1288981844-22714-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libtool automatically adds PIC flags as needed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 78a0e35..4aff85c 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -21,4 +21,4 @@
 LIBVERSION=0:0:0
 
 CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS=-fPIC -Wall -Wextra -Wno-unused-parameter
+AM_CFLAGS = -Wall -Wextra -Wno-unused-parameter
-- 
1.7.1

