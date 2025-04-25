Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0066B237176
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Apr 2025 08:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745570669; cv=none; b=Xw9CcbmbK1ZNJ5lLo6Yh82vlLorZatFjYolGwZbcLCTF/uZb6P0t9s/9Lyx0rjXwRdJO0j4bTk/hn+ZkHNtHarKEYc0N5APBIb2fQRGlcHG95U0+aUN2C+1VetcJJbuHOYPNYVxtou2690iEcqoFO5Y2eWaqgQSZ++GOrtVF1mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745570669; c=relaxed/simple;
	bh=+qp9Bi2QO6K3qjablWkezIPmFBgAKJqzlmQfhXbcrYE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=SeA4VsZNzVSa4O+/nbI69zgf7aQ5cJ72zVtWa47iiuCMlCTdBjYIA9S8IWfqmA4EdyMAZjJ5+tE0LkSrIGv7XPFlH44m554KOYq05zENRIJLiDV6LoKxFgRgRgYMYVfBCa2US/r0vk58Nt8l/Ac2TfjPTN5Ouf2jvG/ePze3osQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZjniMU7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZjniMU7q"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6CA2C4CEE4;
	Fri, 25 Apr 2025 08:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745570667;
	bh=+qp9Bi2QO6K3qjablWkezIPmFBgAKJqzlmQfhXbcrYE=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=ZjniMU7qotIdvlQzh9qbUUTN3X4frx07cuIaTOCy05ywr3HtG7jmEg5Qa2I22y+6A
	 cTUTrglzcwBSfdULzjRvmLsHc3mwVTl+vOyxdmHSv3khqb0HUT3etkeM51RYtm6i4a
	 Y2DNQYy/kzFSFVEK4smG446cZR5oj7tpjvuxqPp6szxWRZJSDK83hMFama4Vdp9va7
	 GxFknolYeT9fOZ6YaWWDbDQ1Ue4+5o26lQXZKbDwhvgU8/vgW/+mctT/m6jchwpFAH
	 pV7wOPFCuPB60Ii8HO/imcKKwPcuvId70SFHnG+zk+a2Ew/wolABIN5KcHCCc2A0uJ
	 n8kUqmWemmfew==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EB5C369D5;
	Fri, 25 Apr 2025 08:44:27 +0000 (UTC)
From: Miao Wang via B4 Relay <devnull+shankerwangmiao.gmail.com@kernel.org>
Date: Fri, 25 Apr 2025 16:44:24 +0800
Subject: [PATCH iptables] extensions: libebt_redirect: prevent translation
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250425-xlat-ebt-redir-v1-1-3e11a5925569@gmail.com>
X-B4-Tracking: v=1; b=H4sIAGdLC2gC/x3MMQqAMAxA0atIZgO1qKhXEYeoqQZEJS0ilN7d4
 viG/yN4VmEPQxFB+REv15lRlQUsO50bo6zZYI1tTG0bfA8KyHNA5VUUiWrT2861jhhydCs7ef/
 hCHIHmo+MKaUPJRA0UGoAAAA=
X-Change-ID: 20250425-xlat-ebt-redir-aa40928f6fae
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc, Miao Wang <shankerwangmiao@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2854;
 i=shankerwangmiao@gmail.com; h=from:subject:message-id;
 bh=ra9gJwUVtpXUZiFC4v0yxVqP5go6nVeFVB5HO6rfqmY=;
 b=owEBbQKS/ZANAwAKAbAx48p7/tluAcsmYgBoC0tqPn06r5bYMz7zLfByOzpBpV+I1GLKKtAbO
 q94tw3mzyWJAjMEAAEKAB0WIQREqPWPgPJBxluezBOwMePKe/7ZbgUCaAtLagAKCRCwMePKe/7Z
 buN1D/93/M4LGV9bnJPPOnCZ2e4EfbURGDN+LowfyN02532uUtDp661sSgdT33+qhsAfV6XDJFV
 K1CTgPvj26ROziBNMFD3gvTROV/EBd9Q/0mq2YzDYwvY79e7twpcHgxAr7wNjAxYi5+0wFbHSYS
 JnRa4PhsFnjeKBxsjSk1U50O718qf/zU6i49A390dcmUKa1WERv9uBDLjbyBmtt+q0/runOUlkJ
 QQ0NOpl10p8Q+wllC06dkh4xiePrKWjMExUSke+wAfje8gxZLmFlHZC/ASOuroZ0SvI0j3oQmcL
 W9NXM11zr2fPNpqwFJlzjjqvSjEPtOy5IgMKUuNIH7yR3xM/ZROIUvTN1ax8Xy8+vpvcHff916a
 0WHsAr1DZ4EWnm5YwbwfVWgyh5jaxWQPGshM5+nH5XM91317yyCGcwvw/8ql1nUPCbqRvqB9qjj
 PhuCKB7hXDztwAg7ScvMN6sL3Udhfr5gXcRjlpVIJCrb+1wQyjKDiQZmmFZSfbUP22pdJUbfbHs
 u0nMbSc+YrUGrRALZl5XasZtCYxYedaDBfH27RQzlPPrwOAHTsbrNKY7m1V40UbI4naird6Fefz
 lm/g8EhybuFKHUaA0SSU6+NdFQUbZhTzRf8XRMWBV6vZIOTEYHfNNh4cfd1gudMytNlfL93iqXo
 /2n16VlusFHkk6A==
X-Developer-Key: i=shankerwangmiao@gmail.com; a=openpgp;
 fpr=6FAEFF06B7D212A774C60BFDFA0D166D6632EF4A
X-Endpoint-Received: by B4 Relay for shankerwangmiao@gmail.com/default with
 auth_id=189
X-Original-From: Miao Wang <shankerwangmiao@gmail.com>
Reply-To: shankerwangmiao@gmail.com

From: Miao Wang <shankerwangmiao@gmail.com>

The redirect target in ebtables do two things: 1. set skb->pkt_type to
PACKET_HOST, and 2. set the destination mac address to the address of
the receiving bridge device (when not used in BROUTING chain), or the
receiving physical device (otherwise). However, the later cannot be
implemented in nftables not given the translated mac address. So it is
not appropriate to give a specious translation.

This patch adds xt target redirect to the translated nft rule, to ensure
it cannot be later loaded by nft, to prevent possible misunderstanding.

Fixes: 24ce7465056ae ("ebtables-compat: add redirect match extension")
Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
---
 extensions/libebt_redirect.c      | 2 +-
 extensions/libebt_redirect.txlate | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libebt_redirect.c b/extensions/libebt_redirect.c
index a44dbaec6cc8b12f20acd31dcb1360ac7245e349..83d2b576cea5ae625f3bdf667ad56fc57c1665d9 100644
--- a/extensions/libebt_redirect.c
+++ b/extensions/libebt_redirect.c
@@ -77,7 +77,7 @@ static int brredir_xlate(struct xt_xlate *xl,
 {
 	const struct ebt_redirect_info *red = (const void*)params->target->data;
 
-	xt_xlate_add(xl, "meta pkttype set host");
+	xt_xlate_add(xl, "meta pkttype set host xt target redirect");
 	if (red->target != EBT_CONTINUE)
 		xt_xlate_add(xl, " %s ", brredir_verdict(red->target));
 	return 1;
diff --git a/extensions/libebt_redirect.txlate b/extensions/libebt_redirect.txlate
index d073ec774c4fa817e48422fb99aaf095dd9eab65..abafd8d15aef8349d29ad812a03f0ebeeaea118c 100644
--- a/extensions/libebt_redirect.txlate
+++ b/extensions/libebt_redirect.txlate
@@ -1,8 +1,8 @@
 ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect
-nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host accept'
+nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host xt target redirect accept'
 
 ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect --redirect-target RETURN
-nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host return'
+nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host xt target redirect return'
 
 ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect --redirect-target CONTINUE
-nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host'
+nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host xt target redirect'

---
base-commit: 192c3a6bc18f206895ec5e38812d648ccfe7e281
change-id: 20250425-xlat-ebt-redir-aa40928f6fae

Best regards,
-- 
Miao Wang <shankerwangmiao@gmail.com>


