Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DD618C36
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726239483; cv=none; b=CNFyOER50mgJXziIa58DL5OK2jJijAXSlOYsnyeOTxglrje8tEyPczcez9IDCMa8yCpHFVDh5kTIAWm/0ClenaUIMohp8HkR6DiUK6S3fXbjwX88m/eXq/DLo8eefiDQ+146WvvF+6fdG26CYBAtlVT63hVxT5b6djvwNcB/XK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726239483; c=relaxed/simple;
	bh=qbE9qzIZErSLkM9Pidq/aDJGYJDq964sLIxbi1pAmrM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ikf2gRJstEVTA/xiPCsyuJ24woUFX9SgNK6T1mGnx77DvIbw5Rceu3tVbQlypDEC3piIUj+nq4NomCG1NZMNduTb9koH33oEBWOl4NF5uQr3r4WycKTui7i5rYORoDtoCmAwrnwphN4QZ1HYgv4Uk3edA8ItobjR50/kSfZM75E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=X29c2z+X; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="X29c2z+X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=26S/Phjoyc5TRoF/bQEDZ+1HfQmxPm3Nq0TcCXrccMk=; b=X29c2z+Xh3UYyTw//jZXimuzG3
	ZxuGZAdOQAuwpk/mftB8S7bP1wBRn3GmlT7/Bx00clUGt18DcKP7dkp8Xj9/nG174suQRw+CFib4k
	l2PnnQFkDwIUVu3Nt3gLyPuVkO8XIY4hGLKzL+/4+7a1GRA+YjtN7DrscPtAbgXbo7JSDQktQP/gB
	/+HlMjoXxIaXH3ifr1NwDuOuYAZjcm+pRWnCUHiUYfkkJvKgEZ8romMAlq505h9Mk2EaCIjniMyM9
	5VoYlKLn1KSbeoq5bG989+Gsc1uuYKWEF2Xg7f7cfk/2LMw7eoTOc6fUBA1AxOQZ1u6AbWylFQaz0
	EARWxM6g==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sp7k8-000000004xF-25IE;
	Fri, 13 Sep 2024 16:57:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH] extensions: TPROXY: Fix for translation being non-terminal
Date: Fri, 13 Sep 2024 16:57:48 +0200
Message-ID: <20240913145748.32436-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nftables users have to explicitly add a verdict: xt_TPROXY's
tproxy_tg4() returns NF_ACCEPT if a socket was found and assigned,
NF_DROP otherwise.

Fixes: a62fe15abcc99 ("extensions: xt_TPROXY: add txlate support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_TPROXY.c      |  2 ++
 extensions/libxt_TPROXY.txlate | 14 +++++++-------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index ffc9da1383b8c..5bdefee0e33a4 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -178,6 +178,8 @@ static int tproxy_tg_xlate(struct xt_xlate *xl,
 		xt_xlate_add(xl, "meta mark set meta mark & 0x%x xor 0x%x",
 			     ~mask, info->mark_value);
 
+	/* unlike TPROXY target, tproxy statement is non-terminal */
+	xt_xlate_add(xl, "accept");
 	return 1;
 }
 
diff --git a/extensions/libxt_TPROXY.txlate b/extensions/libxt_TPROXY.txlate
index 239bbe0dc8f9f..f000baab50e03 100644
--- a/extensions/libxt_TPROXY.txlate
+++ b/extensions/libxt_TPROXY.txlate
@@ -1,20 +1,20 @@
 iptables-translate -t mangle -A PREROUTING -p tcp -j TPROXY --on-port 12345 --on-ip 10.0.0.1 --tproxy-mark 0x23/0xff
-nft 'add rule ip mangle PREROUTING ip protocol tcp counter tproxy to 10.0.0.1:12345 meta mark set meta mark & 0xffffff00 xor 0x23'
+nft 'add rule ip mangle PREROUTING ip protocol tcp counter tproxy to 10.0.0.1:12345 meta mark set meta mark & 0xffffff00 xor 0x23 accept'
 
 iptables-translate -t mangle -A PREROUTING -p udp -j TPROXY --on-port 12345 --on-ip 10.0.0.1 --tproxy-mark 0x23
-nft 'add rule ip mangle PREROUTING ip protocol udp counter tproxy to 10.0.0.1:12345 meta mark set 0x23'
+nft 'add rule ip mangle PREROUTING ip protocol udp counter tproxy to 10.0.0.1:12345 meta mark set 0x23 accept'
 
 iptables-translate -t mangle -A PREROUTING -p udp -j TPROXY --on-port 12345 --on-ip 10.0.0.1
-nft 'add rule ip mangle PREROUTING ip protocol udp counter tproxy to 10.0.0.1:12345'
+nft 'add rule ip mangle PREROUTING ip protocol udp counter tproxy to 10.0.0.1:12345 accept'
 
 iptables-translate -t mangle -A PREROUTING -p udp -j TPROXY --on-ip 10.0.0.1 --on-port 0
-nft 'add rule ip mangle PREROUTING ip protocol udp counter tproxy to 10.0.0.1'
+nft 'add rule ip mangle PREROUTING ip protocol udp counter tproxy to 10.0.0.1 accept'
 
 iptables-translate -t mangle -A PREROUTING -p tcp -j TPROXY --on-port 12345
-nft 'add rule ip mangle PREROUTING ip protocol tcp counter tproxy to :12345'
+nft 'add rule ip mangle PREROUTING ip protocol tcp counter tproxy to :12345 accept'
 
 iptables-translate -t mangle -A PREROUTING -p tcp -j TPROXY --on-port 0
-nft 'add rule ip mangle PREROUTING ip protocol tcp counter tproxy to :0'
+nft 'add rule ip mangle PREROUTING ip protocol tcp counter tproxy to :0 accept'
 
 ip6tables-translate -t mangle -A PREROUTING -p tcp -j TPROXY --on-port 12345 --on-ip dead::beef --tproxy-mark 0x23/0xffff
-nft 'add rule ip6 mangle PREROUTING meta l4proto tcp counter tproxy to [dead::beef]:12345 meta mark set meta mark & 0xffff0000 xor 0x23'
+nft 'add rule ip6 mangle PREROUTING meta l4proto tcp counter tproxy to [dead::beef]:12345 meta mark set meta mark & 0xffff0000 xor 0x23 accept'
-- 
2.43.0

