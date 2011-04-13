From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 19/26] libxtables: pass struct xt_entry_{match,target} to x6 parser
Date: Wed, 13 Apr 2011 18:13:40 +0200
Message-ID: <1302711228-15947-20-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42470 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933075Ab1DMQOK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:10 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    4 ++++
 xtoptions.c          |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 6167f4d..afade14 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -126,6 +126,10 @@ struct xt_option_call {
 			uint32_t mark, mask;
 		};
 	} val;
+	union {
+		struct xt_entry_match **match;
+		struct xt_entry_target **target;
+	};
 };
 
 /**
diff --git a/xtoptions.c b/xtoptions.c
index 939e686..b3acff9 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -384,6 +384,7 @@ void xtables_option_tpcall(unsigned int c, char **argv, bool invert,
 	cb.ext_name = t->name;
 	cb.data     = t->t->data;
 	cb.xflags   = t->tflags;
+	cb.target   = &t->t;
 	t->x6_parse(&cb);
 	t->tflags = cb.xflags;
 }
@@ -417,6 +418,7 @@ void xtables_option_mpcall(unsigned int c, char **argv, bool invert,
 	cb.ext_name = m->name;
 	cb.data     = m->m->data;
 	cb.xflags   = m->mflags;
+	cb.match    = &m->m;
 	m->x6_parse(&cb);
 	m->mflags = cb.xflags;
 }
-- 
1.7.1

