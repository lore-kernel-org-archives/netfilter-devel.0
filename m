From: Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCH 5/8] textsearch: fix finite state machine textsearch for handling case insensitive searching
Date: Sat, 21 Jun 2008 00:54:15 -0700
Message-ID: <1214034855-1358-1-git-send-email-joonwpark81@gmail.com>
Cc: netdev <netdev@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Joonwoo Park <joonwpark81@gmail.com>
To: Thomas Graf <tgraf@suug.ch>, Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <>
References: <>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

For fsm text search, handle case insensitive parameter as -EINVAL.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 lib/ts_fsm.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/lib/ts_fsm.c b/lib/ts_fsm.c
index af575b6..88edffe 100644
--- a/lib/ts_fsm.c
+++ b/lib/ts_fsm.c
@@ -257,7 +257,7 @@ found_match:
 }
 
 static struct ts_config *fsm_init(const void *pattern, unsigned int len,
-				     gfp_t gfp_mask)
+				    u8 icase, gfp_t gfp_mask)
 {
 	int i, err = -EINVAL;
 	struct ts_config *conf;
@@ -269,6 +269,9 @@ static struct ts_config *fsm_init(const void *pattern, unsigned int len,
 	if (len  % sizeof(struct ts_fsm_token) || ntokens < 1)
 		goto errout;
 
+	if (icase)
+		goto errout;
+
 	for (i = 0; i < ntokens; i++) {
 		struct ts_fsm_token *t = &tokens[i];
 
@@ -284,6 +287,7 @@ static struct ts_config *fsm_init(const void *pattern, unsigned int len,
 	if (IS_ERR(conf))
 		return conf;
 
+	conf->icase = icase;
 	fsm = ts_config_priv(conf);
 	fsm->ntokens = ntokens;
 	memcpy(fsm->tokens, pattern, len);
-- 
1.5.4.3

