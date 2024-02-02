Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499AC47A4C
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706881999; cv=none; b=nl9P7DuIiSeK51CHVlh4Dmly05p4RUiz3BIoG7oRjieogd4yu+hTSmthOb3CLwiOsPdeLbMkCyuiphu+1GpSPifTqH6wl1iDCgVDDfmO0ZW4BhlJ/tEWMuaXohnKG3PVdFh5Yb/yxUrbGcp1857DLYxJdCoZ/STFG1OQ5WCM02w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706881999; c=relaxed/simple;
	bh=T66u9flDxSHzypb1uBh1ccZEVQy7uz+uwMndQ5lxyEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jg1EpJzwj06u9mVbWykK9klrlQ5MauiWpdtbpw5pZE5oN3nVY0FyxWvvnqgHsR0qWEyj7PSOO8BceMTGM7OcEAvhSLEcHz9+v7tdPkrbJIm1Rwi0MvT285KruoMftk8joMijqeByAfe0dKNsrG1k3e6kEEkVWiPAcMDdV4PvFb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EBwhO9Eg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EBwhO9Eg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CpLoSQVzMGi7hxZcl319SntBYAKRO7qQe0bV/qo0nOY=; b=EBwhO9EgH4erAnZkSQJ6nbvY0K
	NaSVjWZDKlD4pKra8Eb+OccLBC+E5dX1cTfkbyNYIB1RHBQMpVCQlg6PuEe8kib+J5rIKRTX6rV/L
	itDp3EATWzum0M1sBTGHgH9HYr2lcKSmrtJata7Z1ubhvdt46TUja428Wxp7C42Um2BCp/W1KrUkQ
	gCBy+iaP3NPhPpYql3M7TQVlQ0w+W6s5lrNUfsjxZaBWEBfRF4v82RtoKt3DpUrZM/X5JIVJdXsVc
	IAVv7Adm16VByyPB9BOaM8v5lsa3zjsULGqDY3vURibYPeApFAiL/gJq/19PWjb6AW7beet+uu4B6
	W5uvCeeQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtyf-000000003BU-3z6v;
	Fri, 02 Feb 2024 14:53:10 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 07/12] extensions: rt: Save/xlate inverted full ranges
Date: Fri,  2 Feb 2024 14:53:02 +0100
Message-ID: <20240202135307.25331-8-phil@nwl.cc>
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

Also translate plain '-m rt' match into an exthdr exists one.

Fixes: 9dbb616c2f0c3 ("extensions: libip6t_rt.c: Add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_rt.c      | 28 ++++++++++++++++++++--------
 extensions/libip6t_rt.t      |  2 +-
 extensions/libip6t_rt.txlate |  4 ++--
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index d5b0458bb397e..6db09f0b2cdc8 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -152,13 +152,18 @@ static void rt_parse(struct xt_option_call *cb)
 	}
 }
 
+static bool skip_segsleft_match(uint32_t min, uint32_t max, bool inv)
+{
+	return min == 0 && max == UINT32_MAX && !inv;
+}
+
 static void
 print_nums(const char *name, uint32_t min, uint32_t max,
 	    int invert)
 {
 	const char *inv = invert ? "!" : "";
 
-	if (min != 0 || max != 0xFFFFFFFF || invert) {
+	if (!skip_segsleft_match(min, max, invert)) {
 		printf(" %s", name);
 		if (min == max) {
 			printf(":%s", inv);
@@ -210,6 +215,7 @@ static void rt_print(const void *ip, const struct xt_entry_match *match,
 static void rt_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)match->data;
+	bool inv_sgs = rtinfo->invflags & IP6T_RT_INV_SGS;
 
 	if (rtinfo->flags & IP6T_RT_TYP) {
 		printf("%s --rt-type %u",
@@ -217,10 +223,9 @@ static void rt_save(const void *ip, const struct xt_entry_match *match)
 			rtinfo->rt_type);
 	}
 
-	if (!(rtinfo->segsleft[0] == 0
-	    && rtinfo->segsleft[1] == 0xFFFFFFFF)) {
-		printf("%s --rt-segsleft ",
-			(rtinfo->invflags & IP6T_RT_INV_SGS) ? " !" : "");
+	if (!skip_segsleft_match(rtinfo->segsleft[0],
+				 rtinfo->segsleft[1], inv_sgs)) {
+		printf("%s --rt-segsleft ", inv_sgs ? " !" : "");
 		if (rtinfo->segsleft[0]
 		    != rtinfo->segsleft[1])
 			printf("%u:%u",
@@ -244,10 +249,14 @@ static void rt_save(const void *ip, const struct xt_entry_match *match)
 
 }
 
+#define XLATE_FLAGS (IP6T_RT_TYP | IP6T_RT_LEN | \
+		     IP6T_RT_RES | IP6T_RT_FST | IP6T_RT_FST_NSTRICT)
+
 static int rt_xlate(struct xt_xlate *xl,
 		    const struct xt_xlate_mt_params *params)
 {
 	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)params->match->data;
+	bool inv_sgs = rtinfo->invflags & IP6T_RT_INV_SGS;
 
 	if (rtinfo->flags & IP6T_RT_TYP) {
 		xt_xlate_add(xl, "rt type%s %u",
@@ -255,15 +264,18 @@ static int rt_xlate(struct xt_xlate *xl,
 			      rtinfo->rt_type);
 	}
 
-	if (!(rtinfo->segsleft[0] == 0 && rtinfo->segsleft[1] == 0xFFFFFFFF)) {
-		xt_xlate_add(xl, "rt seg-left%s ",
-			     (rtinfo->invflags & IP6T_RT_INV_SGS) ? " !=" : "");
+	if (!skip_segsleft_match(rtinfo->segsleft[0],
+				 rtinfo->segsleft[1], inv_sgs)) {
+		xt_xlate_add(xl, "rt seg-left%s ", inv_sgs ? " !=" : "");
 
 		if (rtinfo->segsleft[0] != rtinfo->segsleft[1])
 			xt_xlate_add(xl, "%u-%u", rtinfo->segsleft[0],
 					rtinfo->segsleft[1]);
 		else
 			xt_xlate_add(xl, "%u", rtinfo->segsleft[0]);
+	} else if (!(rtinfo->flags & XLATE_FLAGS)) {
+		xt_xlate_add(xl, "exthdr rt exists");
+		return 1;
 	}
 
 	if (rtinfo->flags & IP6T_RT_LEN) {
diff --git a/extensions/libip6t_rt.t b/extensions/libip6t_rt.t
index 56c8b077267ce..1c219d664bff7 100644
--- a/extensions/libip6t_rt.t
+++ b/extensions/libip6t_rt.t
@@ -4,7 +4,7 @@
 -m rt ! --rt-type 1 ! --rt-segsleft 12:23 ! --rt-len 42;=;OK
 -m rt;=;OK
 -m rt --rt-segsleft :;-m rt;OK
--m rt ! --rt-segsleft :;-m rt;OK
+-m rt ! --rt-segsleft :;-m rt ! --rt-segsleft 0:4294967295;OK
 -m rt --rt-segsleft :3;-m rt --rt-segsleft 0:3;OK
 -m rt --rt-segsleft 3:;-m rt --rt-segsleft 3:4294967295;OK
 -m rt --rt-segsleft 3:3;-m rt --rt-segsleft 3;OK
diff --git a/extensions/libip6t_rt.txlate b/extensions/libip6t_rt.txlate
index 67d88d07732cc..1c2f74a588750 100644
--- a/extensions/libip6t_rt.txlate
+++ b/extensions/libip6t_rt.txlate
@@ -17,7 +17,7 @@ ip6tables-translate -A INPUT -m rt --rt-segsleft 13:42 -j ACCEPT
 nft 'add rule ip6 filter INPUT rt seg-left 13-42 counter accept'
 
 ip6tables-translate -A INPUT -m rt --rt-segsleft 0:4294967295 -j ACCEPT
-nft 'add rule ip6 filter INPUT counter accept'
+nft 'add rule ip6 filter INPUT exthdr rt exists counter accept'
 
 ip6tables-translate -A INPUT -m rt ! --rt-segsleft 0:4294967295 -j ACCEPT
-nft 'add rule ip6 filter INPUT counter accept'
+nft 'add rule ip6 filter INPUT rt seg-left != 0-4294967295 counter accept'
-- 
2.43.0

