Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0BD4F55BE
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 18:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483984; cv=none; b=ksVph9xGAY2MSj0TUh3RvAjo5mOaLWjCPQ6J1GujjEIBBV3rcWpsqk794XD0OZGK3WslmIDGk3K1/jOhRkBZg/lR1/tm+Zc1OUQh7wll59/mERvBpVV3AbxZfUmYNMA0K8S/o4bXW5oFbSnbUVnJQoQpRVIP71fnSZ0CB8e+82M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483984; c=relaxed/simple;
	bh=LDDO1DYha6J1XWLrOKG8bKry48LwVRcgOnBE9Prshpk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WkReUgPElKeTtqsLPfPZBFyoalmjWqns8VM/ZV5/7LmJSeYphoJWBssSendugxnpGjDLhLXNqyV5rCMLL+vJdFrgwkyOxQ3ulzjgUK+pcwbl/2gg56Z6bDz0TU4O06dvJKTZKuQLHk/SIX+6U1m7txfjbysbNeOuN2TH34kloNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kqNTwtOG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kqNTwtOG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KEPeMqdRjuIoxOyYjjqLThZFb7fFExkaort5YMgoNrg=; b=kqNTwtOGZJXjjODJ4PWGJSWMPA
	yeNW5gTtt1tXOK7Uw6sCx1ATCVbUwIbCNW+LSR0RqVDB4BYFQHuSt7r0TqW9ZyuloMTg0YG22n3sq
	GQ/6P603CCS5Q6I/WWmNgeQamb9HQhB3tvgbZVPNHNc1oaJYdP7D9EMiswuBgXhlWd+kGgF/7+lme
	hfQmy3qNPlSmjZ+XwFdZhDC5oKhXX7TC3XZxQzx61nRFhZN8/v5uwjbZoI+yAWpA9BE8JXUarU67v
	0GvypgWMvqJDd8IEMALRn6m8HD3HtYzGiFYtxgVMH6swnYwGGBQrYgUB/FgnS1SWymu5qyL2x49Lq
	Di5tcrCg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xEsok-000000002J9-45lb;
	Thu, 08 Oct 2026 20:26:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Balazs Gulacsi <m2gulbal@gmail.com>
Subject: [iptables PATCH] extensions: libxt_conntrack: Fail on untranslatable state match
Date: Thu,  8 Oct 2026 20:23:51 +0200
Message-ID: <20261008182605.257290-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Iptables' conntrack match supports combined matching on ct->state bits
as well as the NAT bits in ct->status. The kernel extension matches if
any of the bits is set, i.e. '-m conntrack --ctstate NEW,DNAT' matches
packets in either NEW state or DNAT status or both. Therefore,
translating this sample match into 'ct status dnat ct state new' is
wrong: The nftables rule matches only if both statements match.

The only way to achieve this in nftables seems to be by duplicating the
rule which is not feasible within the xlate infrastructure. So instead
just abort the translation.

This is a partial revert of commit 1a13277f88099 ("extensions:
libxt_conntrack: Fix for ignored ctstates in translation") which turned
an incomplete translation into an incorrect one.

Cc: Balazs Gulacsi <m2gulbal@gmail.com>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1826
Fixes: 26ec09bf6b9b6 ("extensions: libxt_conntrack: provide translation for DNAT and SNAT --ctstate")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Sorry for the back'n'forth here. While updating nfbz#1826 after pushing
the "fix", I noticed my comment explaining why I didn't submit the patch
back in January. This patch tidies up the loose ends.
---
 extensions/libxt_conntrack.c      | 12 ++++++++----
 extensions/libxt_conntrack.txlate | 15 ---------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 4ac4fba00c9c5..ebf8d6ebbee86 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1201,6 +1201,9 @@ static void addr_xlate_print(struct xt_xlate *xl,
 	}
 }
 
+#define XT_CONNTRACK_STATE_SDNAT	( XT_CONNTRACK_STATE_SNAT | \
+					  XT_CONNTRACK_STATE_DNAT )
+
 static int _conntrack3_mt_xlate(struct xt_xlate *xl,
 				const struct xt_xlate_mt_params *params,
 				int family)
@@ -1227,15 +1230,16 @@ static int _conntrack3_mt_xlate(struct xt_xlate *xl,
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_STATE) {
-		if ((sinfo->state_mask & XT_CONNTRACK_STATE_SNAT) ||
-		    (sinfo->state_mask & XT_CONNTRACK_STATE_DNAT)) {
+		if (sinfo->state_mask & XT_CONNTRACK_STATE_SDNAT) {
+			if (sinfo->state_mask & ~XT_CONNTRACK_STATE_SDNAT)
+				return 0;
+
 			xt_xlate_add(xl, "%sct status %s%s", space,
 				     sinfo->invert_flags & XT_CONNTRACK_STATE ? "!= " : "",
 				     sinfo->state_mask & XT_CONNTRACK_STATE_SNAT ? "snat" : "dnat");
 			space = " ";
 		}
-		if (sinfo->state_mask & ~(XT_CONNTRACK_STATE_SNAT |
-					  XT_CONNTRACK_STATE_DNAT)) {
+		if (sinfo->state_mask & ~XT_CONNTRACK_STATE_SDNAT) {
 			xt_xlate_add(xl, "%sct state ", space);
 			state_xlate_print(xl, sinfo->state_mask,
 					  sinfo->invert_flags & XT_CONNTRACK_STATE);
diff --git a/extensions/libxt_conntrack.txlate b/extensions/libxt_conntrack.txlate
index e7255e2a516fd..eeb1b1a53d66b 100644
--- a/extensions/libxt_conntrack.txlate
+++ b/extensions/libxt_conntrack.txlate
@@ -63,18 +63,3 @@ nft 'add rule ip filter INPUT ct status dnat counter accept'
 
 iptables-translate -t filter -A INPUT -m conntrack ! --ctstate DNAT -j ACCEPT
 nft 'add rule ip filter INPUT ct status != dnat counter accept'
-
-iptables-translate -t filter -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED,DNAT -j ACCEPT
-nft 'add rule ip filter INPUT ct status dnat ct state related,established counter accept'
-
-iptables-translate -t filter -A INPUT -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j ACCEPT
-nft 'add rule ip filter INPUT ct status != dnat ct state ! related,established counter accept'
-
-iptables-translate -t filter -A INPUT -m conntrack --ctstate ESTABLISHED,DNAT --ctstatus CONFIRMED -j ACCEPT
-nft 'add rule ip filter INPUT ct status dnat ct state established ct status confirmed counter accept'
-
-iptables-translate -t filter -A INPUT -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT --ctstatus CONFIRMED -j ACCEPT
-nft 'add rule ip filter INPUT ct status != dnat ct state ! related,established ct status confirmed counter accept'
-
-iptables-translate -t filter -A INPUT -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT ! --ctstatus CONFIRMED -j ACCEPT
-nft 'add rule ip filter INPUT ct status != dnat ct state ! related,established ct status ! confirmed counter accept'
-- 
2.54.0

