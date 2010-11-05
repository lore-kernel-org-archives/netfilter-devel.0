From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 9/9] filter/HWHDR: remove redundant sizeof(char)
Date: Fri,  5 Nov 2010 19:36:23 +0100
Message-ID: <1288982184-23584-10-git-send-email-jengelh@medozas.de>
References: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44417 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab0KESgg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:36:36 -0400
In-Reply-To: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is 1 by definition.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 filter/ulogd_filter_HWHDR.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
index 0e3f627..3b713a5 100644
--- a/filter/ulogd_filter_HWHDR.c
+++ b/filter/ulogd_filter_HWHDR.c
@@ -118,7 +118,7 @@ static int parse_mac2str(struct ulogd_key *ret, unsigned char *mac,
 	char *buf_cur;
 	int i;
 
-	if (len/sizeof(char)*3 + 1 > HWADDR_LENGTH)
+	if (len * 3 + 1 > HWADDR_LENGTH)
 		return ULOGD_IRET_ERR;
 
 	if (len == 0)
-- 
1.7.1

