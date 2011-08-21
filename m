From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 14/21] libip6t_hbh: restore setting IP6T_OPTS_LEN flag
Date: Sun, 21 Aug 2011 13:09:29 +0200
Message-ID: <1313924977-8623-15-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38762 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab1HULJz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:55 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bug origin is in commit v1.4.11~26^2~17.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_hbh.c |    1 +
 tests/options-most.rules |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 809e80d..c0389ed 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -108,6 +108,7 @@ static void hbh_parse(struct xt_option_call *cb)
 	case O_HBH_LEN:
 		if (cb->invert)
 			optinfo->invflags |= IP6T_OPTS_INV_LEN;
+		optinfo->flags |= IP6T_OPTS_LEN;
 		break;
 	case O_HBH_OPTS:
 		optinfo->optsnr = parse_options(cb->arg, optinfo->opts);
diff --git a/tests/options-most.rules b/tests/options-most.rules
index 6839d89..1209091 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -94,6 +94,8 @@
 -A matches -m hashlimit --hashlimit-upto 1/hour --hashlimit-burst 1 --hashlimit-name mini3
 -A matches -m hashlimit --hashlimit-upto 1/day --hashlimit-burst 1 --hashlimit-name mini4
 -A matches
+-A matches -m hbh ! --hbh-len 5
+-A matches
 -A matches -m ipvs --vaddr fe80::/64 --vport 1 --vdir REPLY --vmethod GATE --vportctl 21
 -A matches
 -A matches -m length --length 1
-- 
1.7.3.4

