From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH v3 2/2] xtables: function zero_entries removed
Date: Mon, 17 Jun 2013 11:26:11 +0200
Message-ID: <20130617092611.2814.61698.stgit@localhost>
References: <20130617092600.2814.15883.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62709 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3FQJ0K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:26:10 -0400
Received: by mail-wi0-f172.google.com with SMTP id c10so2056316wiw.5
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2013 02:26:09 -0700 (PDT)
Received: from [127.0.0.1] ([46.182.90.24])
        by mx.google.com with ESMTPSA id fv11sm20673382wic.11.2013.06.17.02.26.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 17 Jun 2013 02:26:08 -0700 (PDT)
In-Reply-To: <20130617092600.2814.15883.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/xtables.c |   25 +++++--------------------
 1 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index a06988e..cfc91e4 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -549,14 +549,6 @@ check_entry(const char *chain, const char *table,
 }
 
 static int
-zero_entries(const xt_chainlabel chain, int verbose,
-	     struct xtc_handle *handle)
-{
-	/* XXX iterate over chains and reset counters */
-	return 1;
-}
-
-static int
 list_entries(struct nft_handle *h, const char *chain, const char *table,
 	     int rulenum, int verbose, int numeric, int expanded,
 	     int linenumbers)
@@ -1171,8 +1163,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 		ret = nft_rule_flush(h, chain, *table);
 		break;
 	case CMD_ZERO:
-		/* FIXME */
-//		ret = zero_entries(chain, cs.options&OPT_VERBOSE, *handle);
+		ret = nft_chain_zero_counters(h, chain, *table);
 		break;
 	case CMD_ZERO_NUM:
 		/* FIXME */
@@ -1188,22 +1179,16 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 				   cs.options&OPT_NUMERIC,
 				   cs.options&OPT_EXPANDED,
 				   cs.options&OPT_LINENUMBERS);
-/*		if (ret && (command & CMD_ZERO))
-			ret = zero_entries(chain,
-					   cs.options&OPT_VERBOSE, *handle);
-		if (ret && (command & CMD_ZERO_NUM))
-			ret = iptc_zero_counter(chain, rulenum, *handle); */
+		if (ret && (command & CMD_ZERO))
+			ret = nft_chain_zero_counters(h, chain, *table);
 		break;
 	case CMD_LIST_RULES:
 	case CMD_LIST_RULES|CMD_ZERO:
 	case CMD_LIST_RULES|CMD_ZERO_NUM:
 		/* FIXME */
 		ret = list_rules(h, chain, *table, rulenum, cs.options&OPT_VERBOSE);
-/*		if (ret && (command & CMD_ZERO))
-			ret = zero_entries(chain,
-					   cs.options&OPT_VERBOSE, *handle);
-		if (ret && (command & CMD_ZERO_NUM))
-			ret = iptc_zero_counter(chain, rulenum, *handle); */
+		if (ret && (command & CMD_ZERO))
+			ret = nft_chain_zero_counters(h, chain, *table);
 		break;
 	case CMD_NEW_CHAIN:
 		ret = nft_chain_user_add(h, chain, *table);

