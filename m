From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] nftables: adjust example file for new chain type syntax
Date: Fri, 29 Nov 2013 12:32:29 -0800
Message-ID: <20131129203228.GB22533@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="v9Ux+11Zm5mwPlX6"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43344 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3K2Uca (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:32:30 -0500
Received: by mail-pb0-f42.google.com with SMTP id uo5so15180886pbc.1
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2013 12:32:30 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Example file has not been updated with new syntax.

Signed-off-by: Phil Oester <kernel@linuxace.com>


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nft-example

diff --git a/files/examples/sets_and_maps b/files/examples/sets_and_maps
index 8dfe9f8..adfc688 100755
--- a/files/examples/sets_and_maps
+++ b/files/examples/sets_and_maps
@@ -37,7 +37,7 @@ table filter {
 	chain input_1 { counter; }
 	chain input_2 { counter; }
 	chain input {
-		hook NF_INET_LOCAL_IN 0
+		type filter hook input priority 0
 
 		# symbolic anonymous sets
 		meta iif $local_ifs tcp dport $tcp_ports counter

--v9Ux+11Zm5mwPlX6--
