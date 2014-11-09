From: Loganaden Velvindron <logan@elandsys.com>
Subject: [PATCH] From fryasu: Trim kernel struct to allow deletion for TEE
 targets
Date: Sun, 9 Nov 2014 06:15:05 -0800
Message-ID: <20141109141505.GA4546@mx.elandsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.qubic.net ([208.69.177.116]:65066 "EHLO mx.elandsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbaKIOaA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Nov 2014 09:30:00 -0500
Received: from mx.elandsys.com (IDENT:logan@localhost [127.0.0.1])
	by mx.elandsys.com (8.14.5/8.14.5) with ESMTP id sA9EF59J019075
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Sun, 9 Nov 2014 06:15:06 -0800 (PST)
Received: (from logan@localhost)
	by mx.elandsys.com (8.14.5/8.14.5/Submit) id sA9EF5oh023432
	for netfilter-devel@vger.kernel.org; Sun, 9 Nov 2014 06:15:05 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Correct trimming of userspacesize to fix deletions.

Signed-off-by: Loganaden Velvindron <logan@elandsys.com>
---

bz: 884 :

The rule having TEE target with '--oif' option cannot be deleted by iptables command.

  $ iptables -I INPUT -i foo -j TEE --gateway x.x.x.x --oif bar
  $ iptables -D INPUT -i foo -j TEE --gateway x.x.x.x --oif bar
  iptables: No chain/target/match by that name.

I tested on the latest iptables from master and the issue is stil present.

The diff fixes the issue, feedback welcomed.

 extensions/libxt_TEE.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_TEE.c b/extensions/libxt_TEE.c
index 92c7601..66c060d 100644
--- a/extensions/libxt_TEE.c
+++ b/extensions/libxt_TEE.c
@@ -99,7 +99,7 @@ static struct xtables_target tee_tg_reg[] = {
 		.revision      = 1,
 		.family        = NFPROTO_IPV4,
 		.size          = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
-		.userspacesize = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
+		.userspacesize = offsetof(struct xt_tee_tginfo, priv),
 		.help          = tee_tg_help,
 		.print         = tee_tg_print,
 		.save          = tee_tg_save,
@@ -112,7 +112,7 @@ static struct xtables_target tee_tg_reg[] = {
 		.revision      = 1,
 		.family        = NFPROTO_IPV6,
 		.size          = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
-		.userspacesize = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
+		.userspacesize = offsetof(struct xt_tee_tginfo, priv),
 		.help          = tee_tg_help,
 		.print         = tee_tg6_print,
 		.save          = tee_tg6_save,
-- 
2.1.3
