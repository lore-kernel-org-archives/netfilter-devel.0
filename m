From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 2/3] Fix warning about undeclared function.
Date: Wed, 18 Jun 2008 17:30:12 +0200
Message-ID: <1213803013-19433-3-git-send-email-eric@inl.fr>
References: <1213803013-19433-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:44491 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYFRPaR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:30:17 -0400
In-Reply-To: <1213803013-19433-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

strerror function was used without inclusion of string.h. This patch adds
the include and fixes the warning.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_ULOG.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index 253bbe0..0b58393 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -6,6 +6,7 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <arpa/inet.h>
+#include <string.h>
 
 
 #include <ulogd/ulogd.h>
-- 
1.5.5.3

