From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH 4/7] ebtables-compat: prevent same matches
 to be included multiple times
Date: Mon, 19 Jan 2015 14:27:51 +0100
Message-ID: <20150119132751.7422.77819.stgit@nfdev.cica.es>
References: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57013 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751508AbbASN2A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:28:00 -0500
In-Reply-To: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Using two matches options results in two copies of the match being included
in the nft rule.

Example before this patch:
 % ebtables-compat -A FORWARD -p 0x0800 --ip-src 10.0.0.1 --ip-dst 10.0.0.2 -j ACCEPT
 % ebtables-compat -L
 [...]
 -p 0x0800 --ip-src 10.0.0.1 --ip-dst 10.0.0.2 --ip-src 10.0.0.1 --ip-dst 10.0.0.2 -j ACCEPT

Example with this patch:
 % ebtables-compat -A FORWARD -p 0x0800 --ip-src 10.0.0.1 --ip-dst 10.0.0.2 -j ACCEPT
 % ebtables-compat -L
 [...]
 % -p 0x0800 --ip-src 10.0.0.1 --ip-dst 10.0.0.2 -j ACCEPT

[Note: the br_ip extension comes in a follow-up patch]

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/xtables-eb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index b559a53..a078679 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -644,6 +644,14 @@ static void ebt_load_matches(void)
 static void ebt_add_match(struct xtables_match *m,
 			  struct xtables_rule_match **rule_matches)
 {
+	struct xtables_rule_match *i;
+
+	/* match already in rule_matches, skip inclusion */
+	for (i = *rule_matches; i; i = i->next) {
+		if (strcmp(m->name, i->match->name) == 0)
+			return;
+	}
+
 	if (xtables_find_match(m->name, XTF_LOAD_MUST_SUCCEED, rule_matches) == NULL)
 		xtables_error(OTHER_PROBLEM,
 			      "Unable to add match %s", m->name);

