From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 2/3] Fix ulogd --info when displaying some default value.
Date: Thu,  7 Feb 2008 09:22:20 +0100
Message-ID: <12023725412388-git-send-email-eric@inl.fr>
References: <12023725412-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43539 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754374AbYBGIWX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:22:23 -0500
In-Reply-To: <12023725412-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

THis patch fixes a crash in ulogd2 when dealing with default value given
as string.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 fe4106a... de2fd96... M	src/ulogd.c
 src/ulogd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index fe4106a..de2fd96 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -290,7 +290,7 @@ void get_plugin_infos(struct ulogd_plugin *me)
 				case CONFIG_TYPE_STRING:
 					printf("String");
 					printf(", Default: %s", 
-					       me->config_kset->ces[i].u.value);
+					       me->config_kset->ces[i].u.string);
 					break;
 				case CONFIG_TYPE_INT:
 					printf("Integer");
-- 
1.5.2.5

