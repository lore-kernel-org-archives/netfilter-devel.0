From: <gregkh@suse.de>
Subject: patch textsearch-fix-boyer-moore-text-search-bug.patch added to 2.6.25-stable tree
Date: Wed, 16 Jul 2008 22:42:41 -0700
Message-ID: <20080717054700.912041454459@imap.suse.de>
References: <487220A9.7000606@trash.net>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: joonwpark81@gmail.com, davem@davemloft.net, kaber@trash.net,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbYGQFrD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 01:47:03 -0400
In-Reply-To: <487220A9.7000606@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

     Subject: textsearch: fix Boyer-Moore text search bug

to the 2.6.25-stable tree.  Its filename is

     textsearch-fix-boyer-moore-text-search-bug.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org  Wed Jul 16 22:27:41 2008
From: Joonwoo Park <joonwpark81@gmail.com>
Date: Mon, 07 Jul 2008 15:56:57 +0200
Subject: textsearch: fix Boyer-Moore text search bug
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Message-ID: <487220A9.7000606@trash.net>

From: Joonwoo Park <joonwpark81@gmail.com>

Upstream commit aebb6a849cfe7d89bcacaaecc20a480dfc1180e7

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
 lib/ts_bm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -63,7 +63,7 @@ static unsigned int bm_find(struct ts_co
 	struct ts_bm *bm = ts_config_priv(conf);
 	unsigned int i, text_len, consumed = state->offset;
 	const u8 *text;
-	int shift = bm->patlen, bs;
+	int shift = bm->patlen - 1, bs;
 
 	for (;;) {
 		text_len = conf->get_next_block(consumed, &text, conf, state);


Patches currently in stable-queue which might be from joonwpark81@gmail.com are

queue-2.6.25/textsearch-fix-boyer-moore-text-search-bug.patch
