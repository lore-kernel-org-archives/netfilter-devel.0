From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=201/5=5D=20netfilter=3A=20nf=5Ftables=3A=20fix=20anonymous=20sets?=
Date: Mon, 10 Dec 2012 18:20:08 +0100
Message-ID: <1355160012-13952-2-git-send-email-kaber@trash.net>
References: <1355160012-13952-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36283 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2LJRbl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:31:41 -0500
In-Reply-To: <1355160012-13952-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

Commit a109bd34 (netfilter: nf_tables: don't report anonymous sets) bro=
ke
use of anonymous sets by not reporting the created set name to userspac=
e
anymore. Anonymous sets are created using "set%d", the notification is
needed so elements can be added to the finally chosen name.

set set%d@filter/inet <anonymous,constant>
	key: type 12 len 4
set set%d@filter/inet
element 0x00000002
element 0x00000001
internal:0:0-0: Error: Could not add set elements: Object not found

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 3 +--
 1 Datei ge=C3=A4ndert, 1 Zeile hinzugef=C3=BCgt(+), 2 Zeilen entfernt(=
-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index f701dc0..570b877 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1915,8 +1915,7 @@ static int nf_tables_newset(struct sock *nlsk, st=
ruct sk_buff *skb,
 		goto err2;
=20
 	list_add_tail(&set->list, &table->sets);
-	if (!(set->flags & NFT_SET_ANONYMOUS))
-		nf_tables_set_notify(&ctx, set, NFT_MSG_NEWSET);
+	nf_tables_set_notify(&ctx, set, NFT_MSG_NEWSET);
 	return 0;
=20
 err2:
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
