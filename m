From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH -stable 01/02]: textsearch: fix Boyer-Moore text search bug
Date: Mon, 07 Jul 2008 15:56:57 +0200
Message-ID: <487220A9.7000606@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090208090308070107020402"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61391 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbYGGN5A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:57:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090208090308070107020402
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

These two patches for -stable fix a bug in the BM textsearch
algorithm, leading to false negatives, and packets incorrectly
marked as INVALID by TCP conntrack.

Please apply, thanks.


--------------090208090308070107020402
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

textsearch: fix Boyer-Moore text search bug

Upstream commit aebb6a8:

The current logic has a bug which cannot find matching pattern, if the
pattern is matched from the first character of target string.
for example:
	pattern=abc, string=abcdefg
	pattern=a,   string=abcdefg
Searching algorithm should return 0 for those things.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 44e450bf173eee791911a56f7e65a30d94608cea
tree 9be6fda8b20945d835a0dc6b466341f6cd9132e9
parent 76605033bb81028b4c603a324dcec6793b7da8ae
author Joonwoo Park <joonwpark81@gmail.com> Mon, 07 Jul 2008 15:52:15 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 15:52:15 +0200

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

--------------090208090308070107020402--
