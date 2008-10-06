From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: ebtables: fix one wrong return value
Date: Mon, 6 Oct 2008 12:51:41 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810061248240.10698@fbirervta.pbzchgretzou.qr>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <1a68c9d72045f79f5b103da31beb8a3e120e9de2.1223294924.git.jengelh@medozas.de> <48EA3B7F.9000007@trash.net> <alpine.LNX.1.10.0810061232490.10698@fbirervta.pbzchgretzou.qr>
 <48EA4032.20300@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41613 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYJFQvn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:51:43 -0400
In-Reply-To: <48EA4032.20300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-10-06 12:43, Patrick McHardy wrote:
>
> The patchset you've sent is missing the patch "fix one wrong return
> value" from your tree.
>
> Please send that one seperately.
>
Oh joy of git-format-patch <NOT_SO_INCLUSIVE_SHA>..HEAD!

Here's PATCH "-01/23":
===
commit 9ea25486b5c9b3aed90525721fe598397a5e2581
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Oct 5 11:26:51 2008 -0400

netfilter: ebtables: fix one wrong return value

Usually -EINVAL is used when checkentry fails (see *_tables).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebtables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 340e1c6..942739d 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -756,7 +756,7 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 	} else if (t->u.target->checkentry &&
 	    !t->u.target->checkentry(name, e, NULL, t->data, hookmask)) {
 		module_put(t->u.target->me);
-		ret = -EFAULT;
+		ret = -EINVAL;
 		goto cleanup_watchers;
 	}
 	(*cnt)++;
