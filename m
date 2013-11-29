From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] nftables: segfault in top scope define
Date: Fri, 29 Nov 2013 12:30:04 -0800
Message-ID: <20131129203003.GA22533@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:36826 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab3K2UaG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:30:06 -0500
Received: by mail-pb0-f54.google.com with SMTP id un15so15066596pbc.13
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2013 12:30:06 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Nftables segfaults if a symbol is added in top_scope, because of a missing
init_list_head.  Trivial example:

    define ip_set = {192.168.1.2, 192.168.2.3}
    add rule filter output ip daddr $ip_set counter

This closes netfilter bugzilla #877.

Reported-by: Anandraj M <anandrm@gmail.com>
Signed-off-by: Phil Oester <kernel@linuxace.com>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nft-top_scope

diff --git a/src/parser.y b/src/parser.y
index a49e5c2..c6f8c9d 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -32,6 +32,7 @@ void parser_init(struct parser_state *state, struct list_head *msgs)
 {
 	memset(state, 0, sizeof(*state));
 	init_list_head(&state->cmds);
+	init_list_head(&state->top_scope.symbols);
 	state->msgs = msgs;
 	state->scopes[0] = scope_init(&state->top_scope, NULL);
 }

--a8Wt8u1KmwUX3Y2C--
