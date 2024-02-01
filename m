Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109D25B669
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2024 13:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795463; cv=none; b=n42zMq0ZOU1OCtunNr/FWZezxpvf4LiXvW5wcs0jDvNNttjY2aulTDdr7M56t1tse/87vQ1MMaUMQnf2r8++gVAQj3n/1IfYeSRfPIzMKXXQoL/YnNGIDf7Xa8HVDrJZ123oEpULT368yK6rK7674gz6JOv8DzDya/PsohVgjUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795463; c=relaxed/simple;
	bh=yUvm/vsBdMrWGhr8ELnDsx7eqoz+hCn/KKkshaVRt2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnNxHKzc42bSso/NvQ3ei/HoLtlXT3r3mxDHP8SlXV2apxtaqYIPrffCYwthgdi1qSUdIUgKwiQLvTakHEDWCbwpn1yjoyv6emYhbNrO/x3U4YRDzQ6Dq6AkQII/jifmI4hL97S6kstIyEZOcfls5pphxSgEyXXk2f+sZueEwIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Yzh+Ntkw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Yzh+Ntkw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=m/HOl2okEE47l37xMeuo8HjdsleSTPtfgXty8K0LVSQ=; b=Yzh+Ntkwmzzs08adJJpCE10BM7
	DLcfDhYRQQWHiedA+b0acjomkQxXPf62g0HhrWVvO6x12iUKV1YHUwj+qrn2Noj+gNOFztsf0A2AH
	zg/IKpLDhnRCIsuLZorMVfGcGw0M3kFnngfmndsVblHaoEpkYiPPvPb5ZybhIsyImYXArfbBL9J2+
	kSVQlskqkmRw2/7AAHTcjsFl6tllaVKG6vGH+OJbZoQqZKVPgrq5O9LknDfskmYe+xKUcQZWWJHdf
	lMDs4IhL2oWaZ6UKoplXunZ7ovps9BpJvasDr95mY69t6xwzYp1GmnCDXqBxYmMdi7YuNS7vupkri
	znMS1OOA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVXT1-000000001M4-2sFk;
	Thu, 01 Feb 2024 14:50:59 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 6/7] xshared: Introduce xtables_clear_args()
Date: Thu,  1 Feb 2024 14:50:56 +0100
Message-ID: <20240201135057.24828-7-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240201135057.24828-1-phil@nwl.cc>
References: <20240201135057.24828-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Perform struct xtables_args object deinit in a common place, even though
it merely consists of freeing any IP addresses and masks.

This fixes for a memleak in arptables-translate as the check for
h->family didn't catch the value NFPROTO_ARP.

Fixes: 5b7324e0675e3 ("nft-arp: add arptables-translate")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c         |  5 +----
 iptables/iptables.c          |  5 +----
 iptables/xshared.c           |  8 ++++++++
 iptables/xshared.h           |  2 ++
 iptables/xtables-translate.c | 12 +-----------
 iptables/xtables.c           |  5 +----
 6 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 4b5d4ac6878b7..f9ae18aed8041 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -892,10 +892,7 @@ int do_command6(int argc, char *argv[], char **table,
 		e = NULL;
 	}
 
-	free(saddrs);
-	free(smasks);
-	free(daddrs);
-	free(dmasks);
+	xtables_clear_args(&args);
 	xtables_free_opts(1);
 
 	return ret;
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 5ae28fe04a5f5..8eb043e9b736e 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -887,10 +887,7 @@ int do_command4(int argc, char *argv[], char **table,
 		e = NULL;
 	}
 
-	free(saddrs);
-	free(smasks);
-	free(daddrs);
-	free(dmasks);
+	xtables_clear_args(&args);
 	xtables_free_opts(1);
 
 	return ret;
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 7d073891ed5c3..0b2724a3e5162 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -2185,3 +2185,11 @@ make_delete_mask(const struct xtables_rule_match *matches,
 
 	return mask;
 }
+
+void xtables_clear_args(struct xtables_args *args)
+{
+	free(args->s.addr.ptr);
+	free(args->s.mask.ptr);
+	free(args->d.addr.ptr);
+	free(args->d.mask.ptr);
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 2a9cdf45f581a..7d4035ec03e52 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -333,4 +333,6 @@ unsigned char *make_delete_mask(const struct xtables_rule_match *matches,
 
 void iface_to_mask(const char *ifname, unsigned char *mask);
 
+void xtables_clear_args(struct xtables_args *args);
+
 #endif /* IPTABLES_XSHARED_H */
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index ad44311230323..8ebe523c447f2 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -349,17 +349,7 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 
 	h->ops->clear_cs(&cs);
 
-	if (h->family == AF_INET) {
-		free(args.s.addr.v4);
-		free(args.s.mask.v4);
-		free(args.d.addr.v4);
-		free(args.d.mask.v4);
-	} else if (h->family == AF_INET6) {
-		free(args.s.addr.v6);
-		free(args.s.mask.v6);
-		free(args.d.addr.v6);
-		free(args.d.mask.v6);
-	}
+	xtables_clear_args(&args);
 	xtables_free_opts(1);
 
 	return ret;
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 22d6ea58376fc..5d73481c25761 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -264,10 +264,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 
 	h->ops->clear_cs(&cs);
 
-	free(args.s.addr.ptr);
-	free(args.s.mask.ptr);
-	free(args.d.addr.ptr);
-	free(args.d.mask.ptr);
+	xtables_clear_args(&args);
 	xtables_free_opts(1);
 
 	return ret;
-- 
2.43.0

