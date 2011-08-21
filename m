From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 15/21] libip6t_dst: restore setting IP6T_OPTS_LEN flag
Date: Sun, 21 Aug 2011 13:09:30 +0200
Message-ID: <1313924977-8623-16-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38759 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab1HULJz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:55 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bug origin is in commit v1.4.11~26^2~18.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_dst.c |    3 +++
 tests/options-most.rules |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 4125bd3..3fd4c01 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -111,6 +111,9 @@ static void dst_parse(struct xt_option_call *cb)
 
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
+	case O_DSTLEN:
+		optinfo->flags |= IP6T_OPTS_LEN;
+		break;
 	case O_DSTOPTS:
 		optinfo->optsnr = parse_options(cb->arg, optinfo->opts);
 		optinfo->flags |= IP6T_OPTS_OPTS;
diff --git a/tests/options-most.rules b/tests/options-most.rules
index 1209091..cd6aab8 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -79,6 +79,8 @@
 -A matches
 -A matches -m conntrack ! --ctstate NEW ! --ctproto tcp ! --ctorigsrc ::1/127 ! --ctorigdst ::2/127 ! --ctreplsrc ::2/127 ! --ctrepldst ::2/127 ! --ctorigsrcport 3 ! --ctorigdstport 4 ! --ctreplsrcport 5 ! --ctrepldstport 6 ! --ctstatus ASSURED ! --ctexpire 8:9
 -A matches
+-A matches -m dst ! --dst-len 12
+-A matches
 -A matches -p esp -m esp --espspi 1
 -A matches
 -A matches -p esp -m esp --espspi :2
-- 
1.7.3.4

