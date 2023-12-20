Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B8D482CD
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mcTtv0ja"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=w2IYuDf7rURhIrZYyrbrBL8mmPMDAgMVxZzkfnFMmuY=; b=mcTtv0janhnjQUCM0czoPbd/UK
	l91oWS/deqlD+LFye7CsOpMDoNYFdoDNbOwD+JsjeVDXo3h9k0lFSIsKtlnRL35wUMdltaEhrq5fy
	yXl4iNyqudjLGPqS9+DZc4aShrLQxnROf8fyvSQFa9i/KebRy6lB/Y4+xBCIMJOWqnZlJB+vK4bev
	RGU9FKBbDoIPPws4YOm2Kl1kIj9zQWqmFzZjQOT4QXj9pQp4F6mUuBU5UsGrIHJGQ6WZuFo8W8v2+
	LRgKRmw4eKNi7eO45pZ05LAyFKc7ox0Y+7nm7kTKSJ2g0o4CFIoKF/qkWDQh0UGuN4GsykRfur40L
	QZLSyxlg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5k-0004KG-Ni
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 05/23] ebtables: Support for guided option parser
Date: Wed, 20 Dec 2023 17:06:18 +0100
Message-ID: <20231220160636.11778-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160636.11778-1-phil@nwl.cc>
References: <20231220160636.11778-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adjust ebt_load_match() and ebt_command_default() to expect
x6_options/x6_parse fiels to be set instead of the traditional ones.

Much of this is c'n'p from command_default() in xshared.c, but due to
ebtables' custom match data structure (combining matches and watchers),
sharing the code is probably not feasible.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 108 ++++++++++++++++++++----------------------
 1 file changed, 51 insertions(+), 57 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index c3cf1c2c74104..e8cdd7eaa8e44 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -170,36 +170,6 @@ static void ebt_list_extensions(const struct xtables_target *t,
 	}*/
 }
 
-#define OPTION_OFFSET 256
-static struct option *merge_options(struct option *oldopts,
-				    const struct option *newopts,
-				    unsigned int *options_offset)
-{
-	unsigned int num_old, num_new, i;
-	struct option *merge;
-
-	if (!newopts || !oldopts || !options_offset)
-		return oldopts;
-	for (num_old = 0; oldopts[num_old].name; num_old++);
-	for (num_new = 0; newopts[num_new].name; num_new++);
-
-	ebtables_globals.option_offset += OPTION_OFFSET;
-	*options_offset = ebtables_globals.option_offset;
-
-	merge = xtables_malloc(sizeof(struct option) * (num_new + num_old + 1));
-	memcpy(merge, oldopts, num_old * sizeof(struct option));
-	for (i = 0; i < num_new; i++) {
-		merge[num_old + i] = newopts[i];
-		merge[num_old + i].val += *options_offset;
-	}
-	memset(merge + num_old + num_new, 0, sizeof(struct option));
-	/* Only free dynamically allocated stuff */
-	if (oldopts != ebt_original_options)
-		free(oldopts);
-
-	return merge;
-}
-
 void nft_bridge_print_help(struct iptables_command_state *cs)
 {
 	const struct xtables_rule_match *m = cs->matches;
@@ -327,7 +297,12 @@ static void ebt_load_match(const char *name)
 	m->m->u.user.revision = m->revision;
 	xs_init_match(m);
 
-	opts = merge_options(opts, m->extra_opts, &m->option_offset);
+	if (m->x6_options != NULL)
+		opts = xtables_options_xfrm(opts, NULL,
+					    m->x6_options, &m->option_offset);
+	else if (m->extra_opts != NULL)
+		opts = xtables_merge_options(opts, NULL,
+					     m->extra_opts, &m->option_offset);
 	if (opts == NULL)
 		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
 }
@@ -354,8 +329,12 @@ static void ebt_load_watcher(const char *name)
 
 	xs_init_target(watcher);
 
-	opts = merge_options(opts, watcher->extra_opts,
-			     &watcher->option_offset);
+	if (watcher->x6_options != NULL)
+		opts = xtables_options_xfrm(opts, NULL, watcher->x6_options,
+					    &watcher->option_offset);
+	else if (watcher->extra_opts != NULL)
+		opts = xtables_merge_options(opts, NULL, watcher->extra_opts,
+					     &watcher->option_offset);
 	if (opts == NULL)
 		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
 }
@@ -450,37 +429,50 @@ int ebt_command_default(struct iptables_command_state *cs,
 	struct ebt_match *matchp;
 
 	/* Is it a target option? */
-	if (t && t->parse) {
-		if (t->parse(cs->c - t->option_offset, cs->argv,
-			     ebt_invert, &t->tflags, NULL, &t->t))
-			return 0;
+	if (cs->target != NULL &&
+	    (cs->target->parse != NULL || cs->target->x6_parse != NULL) &&
+	    cs->c >= cs->target->option_offset &&
+	    cs->c < cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
+		xtables_option_tpcall(cs->c, cs->argv, ebt_invert,
+				      cs->target, &cs->eb);
+		return 0;
 	}
 
 	/* check previously added matches/watchers to this rule first */
 	for (matchp = cs->match_list; matchp; matchp = matchp->next) {
 		if (matchp->ismatch) {
 			m = matchp->u.match;
-			if (m->parse &&
-			    m->parse(cs->c - m->option_offset, cs->argv,
-				     ebt_invert, &m->mflags, NULL, &m->m))
-				return 0;
+			if (!m->parse && !m->x6_parse)
+				continue;
+			if (cs->c < m->option_offset ||
+			    cs->c >= m->option_offset + XT_OPTION_OFFSET_SCALE)
+				continue;
+			xtables_option_mpcall(cs->c, cs->argv, ebt_invert,
+					      m, &cs->eb);
+			return 0;
 		} else {
 			t = matchp->u.watcher;
-			if (t->parse &&
-			    t->parse(cs->c - t->option_offset, cs->argv,
-				     ebt_invert, &t->tflags, NULL, &t->t))
-				return 0;
+			if (!t->parse && !t->x6_parse)
+				continue;
+			if (cs->c < t->option_offset ||
+			    cs->c >= t->option_offset + XT_OPTION_OFFSET_SCALE)
+				continue;
+			xtables_option_tpcall(cs->c, cs->argv, ebt_invert,
+					      t, &cs->eb);
+			return 0;
 		}
 	}
 
 	/* Is it a match_option? */
 	for (m = xtables_matches; m; m = m->next) {
-		if (m->parse &&
-		    m->parse(cs->c - m->option_offset, cs->argv,
-			     ebt_invert, &m->mflags, NULL, &m->m)) {
-			ebt_add_match(m, cs);
-			return 0;
-		}
+		if (!m->parse && !m->x6_parse)
+			continue;
+		if (cs->c < m->option_offset ||
+		    cs->c >= m->option_offset + XT_OPTION_OFFSET_SCALE)
+			continue;
+		xtables_option_mpcall(cs->c, cs->argv, ebt_invert, m, &cs->eb);
+		ebt_add_match(m, cs);
+		return 0;
 	}
 
 	/* Is it a watcher option? */
@@ -488,12 +480,14 @@ int ebt_command_default(struct iptables_command_state *cs,
 		if (!(t->ext_flags & XTABLES_EXT_WATCHER))
 			continue;
 
-		if (t->parse &&
-		    t->parse(cs->c - t->option_offset, cs->argv,
-			     ebt_invert, &t->tflags, NULL, &t->t)) {
-			ebt_add_watcher(t, cs);
-			return 0;
-		}
+		if (!t->parse && !t->x6_parse)
+			continue;
+		if (cs->c < t->option_offset ||
+		    cs->c >= t->option_offset + XT_OPTION_OFFSET_SCALE)
+			continue;
+		xtables_option_tpcall(cs->c, cs->argv, ebt_invert, t, &cs->eb);
+		ebt_add_watcher(t, cs);
+		return 0;
 	}
 	if (cs->c == ':')
 		xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
-- 
2.43.0

