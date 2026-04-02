Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C8B1BF33
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Apr 2026 14:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775141552; cv=none; b=llh7uG1Kgv4Q94R0YHc3PKbrWemj3vq1os8KHHlOTUOz6yP71DLqs/t15rKWDE4TP8bou1EPNIxRbwnYLnLPmEjdBN9FQGXmXpoWuXbRB0dUBn46YOUsIGhtJqH4NqrYD67T/2oztjVQfzbqOXki3NgRuIyxG6puk5dKMOzdDAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775141552; c=relaxed/simple;
	bh=0AMGpzrfEs3qmwa9gPSBMtYVJZ9aaspj7SHKEE3Sujk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rlIcesF93lu5GnYDINegtCbPh8ewWR7uV19UbPDRY07g+T3UCZ6deBMTedrh638v1oOCSX6Lpdc8agfknOL2NqRXFVRNpZ4I5/cMoqjPBljs+OWBJwtYn3+M7x8DWpq6Pmn2AOqRAKjMVn2suHZtGhsewf9hNKXhAQAeRyambDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qKr0zmtc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qKr0zmtc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5dQxFu/qvAEnaKU1KLhCW0Cz1F29XCNmzuKPqw0bh7E=; b=qKr0zmtcfRDlh/iw2A0eI7i+yt
	GROqZYp4MyaIkaCv+vrag/1cdwla5DmocKIGzq8plMN99EuvErcwwqLwCMEH06kw4QRRKwFK/DmB9
	CLyeZW4BHZ4a4JaPkSkb6TrKgHloxsM4kYaRcxJ0lFNfjJixLlqRJVohwMxce5eFbF1R4qpDikFAO
	E+QPVpjItT63Khma7FXLVn+kS9H+Opy/m+NPalW7fz62EL273lpAOkLcpZiZ3CiCH1COe7+UnxOq6
	57ISUCps6juGB1hLZvZyVuUKTHhLQenCtNXHrnzJg5opRv5d53ML6KbI048JyKjY0EZgDylBosJfk
	B9GhT4Jg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w8JPB-000000001Eo-31YB
	for netfilter-devel@vger.kernel.org;
	Thu, 02 Apr 2026 16:52:21 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] arptables: Warn when ignoring '-p' option
Date: Thu,  2 Apr 2026 16:52:16 +0200
Message-ID: <20260402145216.32228-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Legacy arptables has been silently ignoring this flag (plus mandatory
argument) since day 1. Retain compatibility to that behaviour but inform
users that a part of their rule does nothing.

Since arp is the only family which didn't provide a proto_parse
callback, implement one for the sole purpose of printing the warning. As
a side-effect, caller no longer has to check callback's existence.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c | 8 ++++++++
 iptables/xshared.c | 3 +--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 2140a88d4a6a9..d1e352e54f97c 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -452,6 +452,13 @@ static int get16_and_mask(const char *from, uint16_t *to,
 	return ret;
 }
 
+static void nft_arp_proto_parse_warn(struct iptables_command_state *cs,
+				     struct xtables_args *args)
+{
+	fprintf(stderr,
+		"Warning: Ignoring '-p' option not supported by arptables\n");
+}
+
 static void nft_arp_post_parse(int command,
 			       struct iptables_command_state *cs,
 			       struct xtables_args *args)
@@ -831,6 +838,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	.save_chain		= nft_arp_save_chain,
 	.rule_parse		= &nft_ruleparse_ops_arp,
 	.cmd_parse		= {
+		.proto_parse	= nft_arp_proto_parse_warn,
 		.post_parse	= nft_arp_post_parse,
 		.option_name	= nft_arp_option_name,
 		.option_invert	= nft_arp_option_invert,
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 26e91e370eb84..263dcc32e5eb1 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1657,8 +1657,7 @@ void do_parse(int argc, char *argv[],
 			cs->protocol = optarg;
 
 			/* This needs to happen here to parse extensions */
-			if (p->ops->proto_parse)
-				p->ops->proto_parse(cs, args);
+			p->ops->proto_parse(cs, args);
 			break;
 
 		case 's':
-- 
2.51.0

