Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14911442F1
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116221; cv=none; b=PTmKnfTv4YKsmGGiw9PHVwn0kntbHxdgnQ0FoiPGSau68CRnvbUOwjA8nIEj6R1Enc6MyHHe1Oa9mXvy4tmveF8HhmQPvuI87Ts0X/G2e3VONyLN1TuHorTfWDRZqOkJdulZzj3rN6CINCg7pJhilUsLV05Md/5nU+gItoUXfzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116221; c=relaxed/simple;
	bh=6XNDxpQaK73cmBP9RtBEvWml/E/RKYTZxvYYmsjZfqY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4dJzANYsOlI1xm2w+4qgDJJ0qMI3ON8rjADn1q2Hyem4/QkE72RryCzwVg87P7fRz6+VFKIHqoXmdqMVe7p2BoRhDJJMhu75hz1mK7Wzd4Yc/XAogxBu+dOnxpt/lNe8DI6SNE/9sLdPDrZohgh8pX+mFz7bZHe47kDvp3zU7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kT2KH4uK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kT2KH4uK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=W4RIcmRian1ggWj7w4WrIg1aJz/fTyYyah2ffNXi8s8=; b=kT2KH4uKcoNTEta7VKiAf7+ev0
	pZuL7wPqz9cqVsuf7TKWJTL6FApcBCpc4PvkVbnmrmestOfEXMBXrOer697kQJlNwbZUoio95S45Q
	/Pb2geLmMStVitC1XduL4RTVHEN4JiGeud1Is9us4HksCAC2CTJxowvV9rLMuVpEEbzT3US3YrSpC
	7YT03/qTW9rnZ0QF3aVYGk5iiWppKE68Ksl0z7rQdB8MOMHr0lxVPeLp5wXksJECep+RrnBNU6pmI
	PL5MIx/CBXl1KnhiPnQx2+w2HqNLkXywauxcKU7wmmlGRAHWyCxKec8QCvCgPfGZ4OAMMFYWwtdsy
	4/+DX6yg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp62-000000002Uz-2NXG
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 13/14] arptables: Introduce print_iface()
Date: Sat, 27 Jul 2024 23:36:47 +0200
Message-ID: <20240727213648.28761-14-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240727213648.28761-1-phil@nwl.cc>
References: <20240727213648.28761-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Merge conditional interface printing code for input and output interface
into a function.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c | 52 ++++++++++++++--------------------------------
 1 file changed, 16 insertions(+), 36 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index c73833270f0e8..264864c3fb2b2 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -197,13 +197,23 @@ static void nft_arp_print_header(unsigned int format, const char *chain,
 	}
 }
 
+static void print_iface(char letter, const char *iface,
+			unsigned int format, bool invert, const char **sep)
+{
+	if (iface[0] == '\0' || (!strcmp(iface, "+") && !invert)) {
+		if (!(format & FMT_VIA))
+			return;
+		iface = (format & FMT_NUMERIC) ? "*" : "any";
+	}
+	printf("%s%s-%c %s", *sep, invert ? "! " : "", letter, iface);
+	*sep = " ";
+}
+
 static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 				       unsigned int format)
 {
 	const struct arpt_entry *fw = &cs->arp;
-	char iface[IFNAMSIZ+2];
 	const char *sep = "";
-	int print_iface = 0;
 	int i;
 
 	if (strlen(cs->jumpto)) {
@@ -211,40 +221,10 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 		sep = " ";
 	}
 
-	iface[0] = '\0';
-
-	if (fw->arp.iniface[0] != '\0') {
-		strcat(iface, fw->arp.iniface);
-		print_iface = 1;
-	}
-	else if (format & FMT_VIA) {
-		print_iface = 1;
-		if (format & FMT_NUMERIC) strcat(iface, "*");
-		else strcat(iface, "any");
-	}
-	if (print_iface) {
-		printf("%s%s-i %s", sep, fw->arp.invflags & IPT_INV_VIA_IN ?
-				   "! " : "", iface);
-		sep = " ";
-	}
-
-	print_iface = 0;
-	iface[0] = '\0';
-
-	if (fw->arp.outiface[0] != '\0') {
-		strcat(iface, fw->arp.outiface);
-		print_iface = 1;
-	}
-	else if (format & FMT_VIA) {
-		print_iface = 1;
-		if (format & FMT_NUMERIC) strcat(iface, "*");
-		else strcat(iface, "any");
-	}
-	if (print_iface) {
-		printf("%s%s-o %s", sep, fw->arp.invflags & IPT_INV_VIA_OUT ?
-				   "! " : "", iface);
-		sep = " ";
-	}
+	print_iface('i', fw->arp.iniface, format,
+		    fw->arp.invflags & IPT_INV_VIA_IN, &sep);
+	print_iface('o', fw->arp.outiface, format,
+		    fw->arp.invflags & IPT_INV_VIA_OUT, &sep);
 
 	if (fw->arp.smsk.s_addr != 0L) {
 		printf("%s%s-s %s", sep,
-- 
2.43.0

