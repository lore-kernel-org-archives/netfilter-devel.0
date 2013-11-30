From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] nftables: add 'delete map' syntax
Date: Sat, 30 Nov 2013 12:41:21 -0800
Message-ID: <20131130204121.GA23143@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57480 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3K3UlX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 15:41:23 -0500
Received: by mail-pd0-f172.google.com with SMTP id g10so15600846pdj.17
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Nov 2013 12:41:22 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Creating a map is done via "add map".  However, to delete a map requires using
"delete set", which is confusing.  Add the appropriate synonym to parser.  
The downside to this is that one can now delete a set with "delete map", but
this seems a minor issue.  It could of course be fixed by adding a new
CMD_OBJ_MAP.

This closes netfilter bugzilla #879.

Reported-by: Bjørnar Ness <bjornar.ness@gmail.com>
Signed-off-by: Phil Oester <kernel@linuxace.com>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nft-map_delete

diff --git a/src/parser.y b/src/parser.y
index a49e5c2..c736240 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -604,6 +604,10 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
+			|	MAP		set_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
+			}
 			|	ELEMENT		set_spec	set_expr
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SETELEM, &$2, &@$, $3);

--huq684BweRXVnRxX--
