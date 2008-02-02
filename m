From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 08/34]  Added explicit null termination of the hostname buffer
Date: Sat,  2 Feb 2008 22:24:03 +0100
Message-ID: <12019874704144-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46018 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761964AbYBBWPW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:15:22 -0500
In-Reply-To: <12019874701366-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Based on From Marius Tomaschewski <mt@suse.de> work on ulogd.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 41ebe5b... bf400d7... M	filter/raw2packet/ulogd_raw2packet_LOCAL.c
 filter/raw2packet/ulogd_raw2packet_LOCAL.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_LOCAL.c b/filter/raw2packet/ulogd_raw2packet_LOCAL.c
index 41ebe5b..bf400d7 100644
--- a/filter/raw2packet/ulogd_raw2packet_LOCAL.c
+++ b/filter/raw2packet/ulogd_raw2packet_LOCAL.c
@@ -92,6 +92,7 @@ void _init(void)
                   strerror(errno));
         exit(2);
     }
+    hostname[sizeof(hostname)-1] = '\0';
     /* strip off everything after first '.' */
     if ((tmp = strchr(hostname, '.')))
         *tmp = '\0';
-- 
1.5.2.5

