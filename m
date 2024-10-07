Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D6C18BC12
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Oct 2024 10:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728296640; cv=none; b=eNsYfetd84AQZcmRSDG4HbX+CTeKVa9yIAS0T5YR8z9y/6IAQvOdovEKWenWavP/GPA6TT7v+IuKVcCCFq3QDOx6o9PSC1SQqMF3sxkzdae/Aob83BrlpP2okhKQdP4rDXbbtEhpC7Q0ELFul1FK9LgZ8PqH57UAgIPIIc6wf0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728296640; c=relaxed/simple;
	bh=1fKDk1ZHwpMFlD6JBkhmaP9jAkncJdfxE+xorcYyF38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4t1s9E+iIRwrQ1u95QMQDpyS0Yd8QLy5Bb//FalMqoJNoszwNEa9q6wmDC5e4PxAzFRaBl83U/YAc8R39/Y3ci+fKJEQKJepSnOAq3jhTcLDD2J5mo33J4jRNEwDwqPmBh2pAwOHrarMjpuEEX/+A4SzWCBCsvBJJQF0cbcesM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sxkuD-0006gE-9j; Mon, 07 Oct 2024 12:23:57 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/5] sets: inform user when set definition contains unknown attributes
Date: Mon,  7 Oct 2024 11:49:38 +0200
Message-ID: <20241007094943.7544-6-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241007094943.7544-1-fw@strlen.de>
References: <20241007094943.7544-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libnftnl detects when the kernel includes extra attributes that are not
recognized.  Expose this to the user.

This could happen when using an older release of libnftl/nftables
with a more recent kernel, where a raw user of the netlink interface
uses an extended/more recent feature set.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h | 2 ++
 src/netlink.c  | 3 +++
 src/rule.c     | 5 +++++
 3 files changed, 10 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 5b3e12b5d7dc..7cbd26897321 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -332,6 +332,7 @@ void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
  * @automerge:	merge adjacents and overlapping elements, if possible
  * @comment:	comment
  * @errors:	expr evaluation errors seen
+ * @incomplete: kernel set additional attributes unknown to this nft version
  * @desc.size:		count of set elements
  * @desc.field_len:	length of single concatenated fields, bytes
  * @desc.field_count:	count of concatenated fields
@@ -357,6 +358,7 @@ struct set {
 	bool			automerge;
 	bool			key_typeof_valid;
 	bool			errors;
+	bool			incomplete;
 	const char		*comment;
 	struct {
 		uint32_t	size;
diff --git a/src/netlink.c b/src/netlink.c
index 25ee3419772b..c057e1d04c28 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1032,6 +1032,9 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	if (comment)
 		set->comment = xstrdup(comment);
 
+	if (!nftnl_set_complete(nls))
+		set->incomplete = true;
+
 	init_list_head(&set_parse_ctx.stmt_list);
 
 	if (nftnl_set_is_set(nls, NFTNL_SET_EXPR)) {
diff --git a/src/rule.c b/src/rule.c
index 9bc160ec0d88..e4fce143d8be 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -405,6 +405,11 @@ static void set_print_declaration(const struct set *set,
 			  set->comment,
 			  opts->stmt_separator);
 	}
+
+	if (set->incomplete)
+		nft_print(octx, "%s%s# Unknown features used (old nft version?)%s",
+			  opts->tab, opts->tab,
+			  opts->stmt_separator);
 }
 
 static void do_set_print(const struct set *set, struct print_fmt_options *opts,
-- 
2.45.2

