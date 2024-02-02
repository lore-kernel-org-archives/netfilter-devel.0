Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1F047768
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706881999; cv=none; b=I7mXlasDGmrWrezz670y04wVX0ED7EWQ4vDtLi+Ofi5aZW5OxB5YVmLFD+Ht1IGkH+fYXQ+71oQ142q4UZPsynHZk5+qSduivDTQcXs1acFHxHP+dPlnuEasftnDnvZifXDnclENensHksuCxaHKIlYA8jej2rKv6pkbpjh69K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706881999; c=relaxed/simple;
	bh=b689QcH7smJBy7/yvzuaG3UDWHMFsZKVALl8w/5k1fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3eRt7lXSG/e7zyk8Lq9FvSSrsOvk0APfci/EJrad0FCFgmoNQmJGw6fzM9/Sydi0h323HObPvKflGy7QuzKostb8uC1kOv1j8AJ8VTgVtZ5beOwpUCtqrdVEM6GeQKV0qq3FBR1JyHWTRRluoHEW9KC0cId8Jd8SJNuqAa1juk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nLfFtTNO; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nLfFtTNO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=trVW2SFRkOe9IZFWFkZhYcBv0WOHU0ccJUQUbQNoJ98=; b=nLfFtTNOXOVF1JWBHBxIx+zn3u
	FdqwdHihfLKd6CqEW0kqjwI0ArLs1h/NZ0+TvNLXDWz7Q9T0DdLL1i6dHEWGTJLFfqSXrr53ouRHK
	CbbMD+Me7Myx+7HJcS1XKaunmtv1Ehupv3cmQQnM5RX9x9VhgZldZRlstLxUX8cugDtD5Do0T3s14
	Bp9AzMCbj668AOAkNBPHY3w8CPfV4/+Z0jJagxwZy5+Ai5N0cwmBl0FoNau4KR8Pg5Hxq0KXOCCOo
	PCfW3ae5ZRdw2lwoasgHHXUAorWc8WA4R7DUzeVCSUYGMAoigII7up9/cXzkFwAHwts+z/poz1By5
	e3MunWYg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtyk-000000003C8-3A6t;
	Fri, 02 Feb 2024 14:53:14 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 05/12] extensions: frag: Save/xlate inverted full ranges
Date: Fri,  2 Feb 2024 14:53:00 +0100
Message-ID: <20240202135307.25331-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202135307.25331-1-phil@nwl.cc>
References: <20240202135307.25331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also translate plain '-m frag' match into an exthdr exists one.

Fixes: bd5bbc7a0fbd8 ("extensions: libip6t_frag: Add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_frag.c      | 27 ++++++++++++++++++---------
 extensions/libip6t_frag.t      |  2 +-
 extensions/libip6t_frag.txlate |  4 ++--
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 49c787e709a9e..ed7fe10a4716d 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -89,13 +89,18 @@ static void frag_parse(struct xt_option_call *cb)
 	}
 }
 
+static bool skip_ids_match(uint32_t min, uint32_t max, bool inv)
+{
+	return min == 0 && max == UINT32_MAX && !inv;
+}
+
 static void
 print_ids(const char *name, uint32_t min, uint32_t max,
 	    int invert)
 {
 	const char *inv = invert ? "!" : "";
 
-	if (min != 0 || max != 0xFFFFFFFF || invert) {
+	if (!skip_ids_match(min, max, invert)) {
 		printf("%s", name);
 		if (min == max)
 			printf(":%s%u", inv, min);
@@ -139,11 +144,10 @@ static void frag_print(const void *ip, const struct xt_entry_match *match,
 static void frag_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_frag *fraginfo = (struct ip6t_frag *)match->data;
+	bool inv_ids = fraginfo->invflags & IP6T_FRAG_INV_IDS;
 
-	if (!(fraginfo->ids[0] == 0
-	    && fraginfo->ids[1] == 0xFFFFFFFF)) {
-		printf("%s --fragid ",
-			(fraginfo->invflags & IP6T_FRAG_INV_IDS) ? " !" : "");
+	if (!skip_ids_match(fraginfo->ids[0], fraginfo->ids[1], inv_ids)) {
+		printf("%s --fragid ", inv_ids ? " !" : "");
 		if (fraginfo->ids[0]
 		    != fraginfo->ids[1])
 			printf("%u:%u",
@@ -173,22 +177,27 @@ static void frag_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --fraglast");
 }
 
+#define XLATE_FLAGS (IP6T_FRAG_RES | IP6T_FRAG_FST | \
+		     IP6T_FRAG_MF | IP6T_FRAG_NMF)
+
 static int frag_xlate(struct xt_xlate *xl,
 		      const struct xt_xlate_mt_params *params)
 {
 	const struct ip6t_frag *fraginfo =
 		(struct ip6t_frag *)params->match->data;
+	bool inv_ids = fraginfo->invflags & IP6T_FRAG_INV_IDS;
 
-	if (!(fraginfo->ids[0] == 0 && fraginfo->ids[1] == 0xFFFFFFFF)) {
-		xt_xlate_add(xl, "frag id %s",
-			     (fraginfo->invflags & IP6T_FRAG_INV_IDS) ?
-			     "!= " : "");
+	if (!skip_ids_match(fraginfo->ids[0], fraginfo->ids[1], inv_ids)) {
+		xt_xlate_add(xl, "frag id %s", inv_ids ?  "!= " : "");
 		if (fraginfo->ids[0] != fraginfo->ids[1])
 			xt_xlate_add(xl, "%u-%u", fraginfo->ids[0],
 				     fraginfo->ids[1]);
 		else
 			xt_xlate_add(xl, "%u", fraginfo->ids[0]);
 
+	} else if (!(fraginfo->flags & XLATE_FLAGS)) {
+		xt_xlate_add(xl, "exthdr frag exists");
+		return 1;
 	}
 
 	/* ignore ineffective IP6T_FRAG_LEN bit */
diff --git a/extensions/libip6t_frag.t b/extensions/libip6t_frag.t
index 57f7da27d5e1d..ea7ac8995c27c 100644
--- a/extensions/libip6t_frag.t
+++ b/extensions/libip6t_frag.t
@@ -1,6 +1,6 @@
 :INPUT,FORWARD,OUTPUT
 -m frag --fragid :;-m frag;OK
--m frag ! --fragid :;-m frag;OK
+-m frag ! --fragid :;-m frag ! --fragid 0:4294967295;OK
 -m frag --fragid :42;-m frag --fragid 0:42;OK
 -m frag --fragid 42:;-m frag --fragid 42:4294967295;OK
 -m frag --fragid 1:42;=;OK
diff --git a/extensions/libip6t_frag.txlate b/extensions/libip6t_frag.txlate
index 2b6585afbc826..e250587e7682c 100644
--- a/extensions/libip6t_frag.txlate
+++ b/extensions/libip6t_frag.txlate
@@ -17,7 +17,7 @@ ip6tables-translate -t filter -A INPUT -m frag --fraglast -j ACCEPT
 nft 'add rule ip6 filter INPUT frag more-fragments 0 counter accept'
 
 ip6tables-translate -t filter -A INPUT -m frag --fragid 0:4294967295
-nft 'add rule ip6 filter INPUT counter'
+nft 'add rule ip6 filter INPUT exthdr frag exists counter'
 
 ip6tables-translate -t filter -A INPUT -m frag ! --fragid 0:4294967295
-nft 'add rule ip6 filter INPUT counter'
+nft 'add rule ip6 filter INPUT frag id != 0-4294967295 counter'
-- 
2.43.0

