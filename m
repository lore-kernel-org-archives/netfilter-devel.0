From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] src: netlink_delinearize: Fix datatype for len
Date: Mon, 29 Feb 2016 01:10:43 +0530
Message-ID: <20160228194043.GA15021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34375 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbcB1Tkv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Feb 2016 14:40:51 -0500
Received: by mail-pf0-f177.google.com with SMTP id 4so1176840pfd.1
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Feb 2016 11:40:51 -0800 (PST)
Received: from gmail.com ([171.50.127.0])
        by smtp.gmail.com with ESMTPSA id m5sm32759437pfi.84.2016.02.28.11.40.47
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sun, 28 Feb 2016 11:40:49 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Change the data type of len from unsigned int to int in order to make
it valid for checks like

if (len < 0)

The issue was brought into attention by the unexplained behavior of
frag with frag-off. Bugzilla entry:
https://bugzilla.netfilter.org/show_bug.cgi?id=935

This patch fixes this bug, however there are still issues with frag
that need to be fixed.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 src/netlink_delinearize.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ae6abb0..2d7a417 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -107,7 +107,7 @@ static void netlink_release_registers(struct netlink_parse_ctx *ctx)
 static struct expr *netlink_parse_concat_expr(struct netlink_parse_ctx *ctx,
 					      const struct location *loc,
 					      unsigned int reg,
-					      unsigned int len)
+					      int len)
 {
 	struct expr *concat, *expr;
 
@@ -134,7 +134,7 @@ err:
 static struct expr *netlink_parse_concat_data(struct netlink_parse_ctx *ctx,
 					      const struct location *loc,
 					      unsigned int reg,
-					      unsigned int len,
+					      int len,
 					      struct expr *data)
 {
 	struct expr *concat, *expr, *i;
-- 
1.9.1

