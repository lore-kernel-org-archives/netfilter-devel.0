Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46CB2D5C97
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773163148; cv=none; b=rYAV00RA/XlfX1Dn5oskxByDCWjEEieeP06CDCAls4KVKs0tMzvOMjRIHEPkGEpBIUshJGQslqRK116ezPiGvPKDPbSfUJmFS6Y/NzB+IAAi005b5Knifsxvz8mjB+LFNXbsrNQIvn33bcdlBMxgujoeY0vn1sBwwaHM4vg0lnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773163148; c=relaxed/simple;
	bh=Nzeo64w/xrbU+We+ISdpLuP1zGqpqHfMMOabvtBZDu0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=G9O97twCa/0dYvPdfXIRraF1L6XFYWXymJMp8bqZQIay3QaLkfxtw0QrYBMQu95n090B7uLJQMxxlHCa48T9QfRyq26ea3u6MI8F79nh8ZaOTQAjuPWTrYld7AyN7C1KBdFxJdw9aWsMwPmm3Mml0lEwXVP1wmXPg8kgLGaUbYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MsbMVkft; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MsbMVkft"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bjvpnTc2xE63WVXpYPK8t8GbhXIH61UfvGPrKNs5izw=; b=MsbMVkftQHG+vJ4F0n0wDb2HSk
	zp1syD+v7fH1TCPXjlRXx9aGR4xLV6oCdbz+gKEM1A0aYXjh67IWBICZJwDuaAOPJW/JInM9O0Gfo
	QiemJJrtjZFJIaVvslat/cuOPbqe7S8kC+T5z+v58xs/4nBtTbx3vbjoTBm3XXgiXSW0/jJbffELU
	Fj5J2LOoNyNtCWCONJuqxFdep9aMoFFv6ECo4WX1eRjlN5ea8iSAC7YdzvodbqCb9bvnJX/wf4eTm
	0+jfJXVUZIP63jfKm5/ubeKRr/cdQVxG5SQcklNM3qADs+86XkDsk+/mgSD2Yvbgxj/Llweqzwvnl
	QgO5QDPw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w00jS-000000007wL-1KPE
	for netfilter-devel@vger.kernel.org;
	Tue, 10 Mar 2026 18:18:58 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xtables-translate: Return non-zero if translation fails
Date: Tue, 10 Mar 2026 18:18:53 +0100
Message-ID: <20260310171853.26362-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Untranslated parts in output are easily overlooked and also don't disrupt
piping into nft (which is a bad idea to begin with), so make a little
noise if things go sideways:

| # iptables-translate -A FORWARD -m recent --set
| nft # -A FORWARD -m recent --set
| Translation not (fully) implemented

| # cat /tmp/input.ipt
| *filter
| -A FORWARD -s 1.2.3.4
| -A FORWARD -m recent --set
| COMMIT
| # iptables-restore-translate -f /tmp/input.ipt
| # Translated by iptables-restore-translate v1.8.13 on Tue Mar 10 17:29:17 2026
| add table ip filter
| add rule ip filter FORWARD ip saddr 1.2.3.4 counter
| # -t filter -A FORWARD -m recent --set
| iptables-translate-restore: line 3 failed

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-translate.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 3d8617f05b120..74cc8efffc0eb 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -297,8 +297,8 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 
 	switch (p.command) {
 	case CMD_APPEND:
-		ret = 1;
-		if (!xlate(h, &p, &cs, &args, true, nft_rule_xlate_add))
+		ret = xlate(h, &p, &cs, &args, true, nft_rule_xlate_add);
+		if (!ret)
 			print_ipt_cmd(argc, argv);
 		break;
 	case CMD_DELETE:
@@ -310,8 +310,8 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 	case CMD_REPLACE:
 		break;
 	case CMD_INSERT:
-		ret = 1;
-		if (!xlate(h, &p, &cs, &args, false, nft_rule_xlate_add))
+		ret = xlate(h, &p, &cs, &args, false, nft_rule_xlate_add);
+		if (!ret)
 			print_ipt_cmd(argc, argv);
 		break;
 	case CMD_FLUSH:
@@ -558,7 +558,7 @@ static int xtables_xlate_main(int family, const char *progname, int argc,
 
 	ret = do_command_xlate(&h, argc, argv, &table, false);
 	if (!ret)
-		fprintf(stderr, "Translation not implemented\n");
+		fprintf(stderr, "Translation not (fully) implemented\n");
 
 	nft_fini(&h);
 	xtables_fini();
-- 
2.51.0

