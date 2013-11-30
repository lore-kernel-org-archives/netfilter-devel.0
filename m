From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] nftables: missing set cleanup in do_command_list
Date: Sat, 30 Nov 2013 12:15:52 -0800
Message-ID: <20131130201551.GA23089@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62852 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3K3UPx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 15:15:53 -0500
Received: by mail-pb0-f48.google.com with SMTP id md12so16121746pbc.7
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Nov 2013 12:15:53 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

When listing a table in interactive mode, the set list is not cleaned up.  Thus
the number of displayed sets grows with each successive listing.  Attached
patch adds the necessary list cleanup to do_command_list.

Reported-by: Bjørnar Ness <bjornar.ness@gmail.com>
Signed-off-by: Phil Oester <kernel@linuxace.com>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nft-set_free

diff --git a/src/rule.c b/src/rule.c
index 39a66d7..ec8b6a4 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -665,6 +665,11 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		chain_free(chain);
 	}
 
+	list_for_each_entry_safe(set, nset, &table->sets, list) {
+		list_del(&set->list);
+		set_free(set);
+	}
+
 	return 0;
 }
 

--WIyZ46R2i8wDzkSu--
