From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/13] libxt_u32: add missing call to xtables_option_parse
Date: Mon,  9 May 2011 11:37:01 +0200
Message-ID: <1304933832-16412-4-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51662 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab1EIJhS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:18 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_u32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 0df28a8..9198edc 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -111,6 +111,7 @@ static void u32_parse(struct xt_option_call *cb)
 	const char *start = cb->arg;
 	int state = 0;
 
+	xtables_option_parse(cb);
 	data->invert = cb->invert;
 
 	/*
-- 
1.7.1

