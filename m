From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: iptables-nftables rebased upon 1.4.19.1
Date: Wed, 24 Jul 2013 20:03:37 +0200
Message-ID: <20130724180337.GA7003@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42247 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab3GXSDn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:03:43 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I have rebased iptables-nftables upon the current iptables git master.
The previous version was based on 1.4.15.

http://git.netfilter.org/iptables-nftables/

I have applied the attached patch to the first commit to include
aliasing support, which was not available at the time 1.4.15 was out.

Please, refresh your repository. Thanks.

Regards.

--cWoXeonUoKmBZSoM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="rebase.patch"

diff --git a/configure.ac b/configure.ac
index ec4de70..6fd1655 100644
--- a/configure.ac
+++ b/configure.ac
@@ -215,6 +215,7 @@ Iptables Configuration:
   IPQ support:				${enable_libipq}
   Large file support:			${enable_largefile}
   BPF utils support:			${enable_bpfc}
+  nftables support:			${enable_nftables}
 
 Build parameters:
   Put plugins into executable (static):	${enable_static}
diff --git a/iptables/nft.c b/iptables/nft.c
index 0e75f0d..91383bf 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -676,8 +676,6 @@ static void nft_match_save(struct nft_rule_expr *expr)
 	if (match == NULL)
 		return;
 
-	printf("-m %s", name);
-
 	mtinfo = nft_rule_expr_get(expr, NFT_EXPR_MT_INFO, &len);
 	if (mtinfo == NULL)
 		return;
@@ -688,6 +686,11 @@ static void nft_match_save(struct nft_rule_expr *expr)
 
 	memcpy(&emu->data, mtinfo, len);
 
+	if (match->alias)
+		printf("-m %s", match->alias(emu));
+	else
+		printf("-m %s", match->name);
+
 	/* FIXME missing parameter */
 	match->save(NULL, emu);
 
@@ -716,8 +719,6 @@ static void nft_target_save(struct nft_rule_expr *expr)
 	if (target == NULL)
 		return;
 
-	printf("-j %s", name);
-
 	tginfo = nft_rule_expr_get(expr, NFT_EXPR_TG_INFO, &len);
 	if (tginfo == NULL)
 		return;
@@ -728,6 +729,11 @@ static void nft_target_save(struct nft_rule_expr *expr)
 
 	memcpy(emu->data, tginfo, len);
 
+	if (target->alias)
+		printf("-j %s", target->alias(emu));
+	else
+		printf("-j %s", target->name);
+
 	/* FIXME missing parameter */
 	target->save(NULL, emu);
 
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 0203b69..a687575 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -608,7 +608,16 @@ static void command_jump(struct iptables_command_state *cs)
 
 	cs->target->t = xtables_calloc(1, size);
 	cs->target->t->u.target_size = size;
-	strcpy(cs->target->t->u.user.name, cs->jumpto);
+	if (cs->target->real_name == NULL) {
+		strcpy(cs->target->t->u.user.name, cs->jumpto);
+	} else {
+		/* Alias support for userspace side */
+		strcpy(cs->target->t->u.user.name, cs->target->real_name);
+		if (!(cs->target->ext_flags & XTABLES_EXT_ALIAS))
+			fprintf(stderr, "Notice: The %s target is converted into %s target "
+				"in rule listing and saving.\n",
+				cs->jumpto, cs->target->real_name);
+	}
 	cs->target->t->u.user.revision = cs->target->revision;
 	xs_init_target(cs->target);
 
@@ -637,7 +646,14 @@ static void command_match(struct iptables_command_state *cs)
 	size = XT_ALIGN(sizeof(struct xt_entry_match)) + m->size;
 	m->m = xtables_calloc(1, size);
 	m->m->u.match_size = size;
-	strcpy(m->m->u.user.name, m->name);
+	if (m->real_name == NULL) {
+		strcpy(m->m->u.user.name, m->name);
+	} else {
+		strcpy(m->m->u.user.name, m->real_name);
+		if (!(m->ext_flags & XTABLES_EXT_ALIAS))
+			fprintf(stderr, "Notice: the %s match is converted into %s match "
+				"in rule listing and saving.\n", m->name, m->real_name);
+	}
 	m->m->u.user.revision = m->revision;
 	xs_init_match(m);
 	if (m == m->next)

--cWoXeonUoKmBZSoM--
