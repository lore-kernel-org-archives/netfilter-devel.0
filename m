From: Patrick McHardy <kaber@trash.net>
Subject: textsearch: fix Boyer-Moore text search bug
Date: Mon, 30 Jun 2008 17:56:11 +0200 (MEST)
Message-ID: <20080630155611.24326.60153.sendpatchset@localhost.localdomain>
References: <20080630155609.24326.34250.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39800 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbYF3P4N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:56:13 -0400
In-Reply-To: <20080630155609.24326.34250.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

textsearch: fix Boyer-Moore text search bug

The current logic has a bug which cannot find matching pattern, if the
pattern is matched from the first character of target string.
for example:
	pattern=abc, string=abcdefg
	pattern=a,   string=abcdefg
Searching algorithm should return 0 for those things.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cf07ecdeb187d567890ade083f0c1fa298085dee
tree 6a7cf5c6bdc80c75ec843d8ee44cd98039ca6fd7
parent 5c61a61f0df27eba716646da0b7371bf49f13d89
author Joonwoo Park <joonwpark81@gmail.com> Mon, 30 Jun 2008 17:40:34 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 30 Jun 2008 17:40:34 +0200

 lib/ts_bm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ts_bm.c b/lib/ts_bm.c
index d90822c..4a7fce7 100644
--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -63,7 +63,7 @@ static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
 	struct ts_bm *bm = ts_config_priv(conf);
 	unsigned int i, text_len, consumed = state->offset;
 	const u8 *text;
-	int shift = bm->patlen, bs;
+	int shift = bm->patlen - 1, bs;
 
 	for (;;) {
 		text_len = conf->get_next_block(consumed, &text, conf, state);
