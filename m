From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH 3/7] ebtables-compat: prevent options
 overwrite
Date: Mon, 19 Jan 2015 14:27:46 +0100
Message-ID: <20150119132746.7422.84800.stgit@nfdev.cica.es>
References: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57006 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751582AbbASN1z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:27:55 -0500
In-Reply-To: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Parsing options will be overwritten if every time we load a match
the extension options are merged to the original options.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/xtables-eb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index d0f6a3e..b559a53 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -618,7 +618,6 @@ static void ebt_load_match(const char *name)
 {
 	struct xtables_match *m;
 	size_t size;
-	opts = ebt_original_options;
 
 	m = xtables_find_match(name, XTF_LOAD_MUST_SUCCEED, NULL);
 	if (m == NULL)
@@ -638,6 +637,7 @@ static void ebt_load_match(const char *name)
 
 static void ebt_load_matches(void)
 {
+	opts = ebt_original_options;
 	ebt_load_match("802_3");
 }
 

