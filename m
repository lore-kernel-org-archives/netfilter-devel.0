Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FB833C1AD
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Mar 2026 20:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773088186; cv=none; b=d1YPR+zjBHdzuHiGOsRjDUBxDD31xDiMl1NgzVit9xIGHdzMnEoGMLlotpcl9l5PEx874xoj6ostVaFObd3dB6z+45RSSQsoYD+THH3pIrZMoHN6OfTeFCGJz6gaGHwkI3J3zyZ3szYTwjmM8bn4IWxZEoSlo0wjxtbs4GI9eyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773088186; c=relaxed/simple;
	bh=FYmBR/S5VtkwG0kIxbT5dr5Oycz6LDoAxdpAvV9QcLs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LbqeOfFlCqZKlsXgf4rYjkdJSckQSZ1Di1fJu100S4Dow/foIqQVXbCa5sEAXux/p9Wz4lCwAkYTYn+Dmqtgs5oRZaJ5pscsy9zEt5qdVuFjc7gyvT3LCRzhi+QStX8yqek6uk1s/ekx/sE200FUn+9ZoExluQup2SOrgWatw2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vdwaa.nl; spf=fail smtp.mailfrom=vdwaa.nl; dkim=pass (1024-bit key) header.d=kpnmail.nl header.i=@kpnmail.nl header.b=aNDN9zGp; arc=none smtp.client-ip=195.121.94.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vdwaa.nl
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=vdwaa.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kpnmail.nl header.i=@kpnmail.nl header.b="aNDN9zGp"
X-KPN-MessageId: b2a952c9-1bf6-11f1-89dd-00505699b430
Received: from smtp.kpnmail.nl (unknown [10.31.155.8])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id b2a952c9-1bf6-11f1-89dd-00505699b430;
	Mon, 09 Mar 2026 21:29:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kpnmail.nl; s=kpnmail01;
	h=mime-version:message-id:date:subject:to:from;
	bh=oziL3okFY4/KgpjPl6fqmz/HNPx1XTMGB5iJgS4pypU=;
	b=aNDN9zGpNbly812oelQlGQGQ4SP7o/Zyzy8SjlItvoIEPd/55WGJV9flsi7FBJmHwXbtMour2Z6Xn
	 TwkMqCFeZ+CQxwf5crqeJAbUU4+oDxWM8Vgz2UryjdQU5FAbwX4tp2ghdf1DPoQWdg28FenkI9II9V
	 rXkl+Ll92srYdmtc=
X-KPN-MID: 33|QNPq7l9c4UeSJuoY7lE7qmcxFuP9K59JYDKBASk2XxZ330GE5IH4E0vvqB6oRsY
 xaz7mKGTLKF0IuzT+z0t07ah8ZOXG6++teKuaKH1/O5o=
X-KPN-VerifiedSender: No
X-CMASSUN: 33|surHEPlIj5D8UvRhvJ/XuFNlueepbTkamNoGHFsJ9mulXQkrm0uypI4+Z+IK6wa
 NlN2Bbx6TTGnmB2j8t4gncA==
Received: from natrium (77-171-66-179.fixed.kpn.net [77.171.66.179])
	by smtp.kpnmail.nl (Halon) with ESMTPSA
	id b284890f-1bf6-11f1-9c04-00505699d6e5;
	Mon, 09 Mar 2026 21:29:39 +0100 (CET)
From: Jelle van der Waa <jelle@vdwaa.nl>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	Jelle van der Waa <jelle@vdwaa.nl>
Subject: [PATCH] netfilter: nf_tables: Fix typo in enum description
Date: Mon,  9 Mar 2026 21:29:33 +0100
Message-ID: <20260309202933.12490-1-jelle@vdwaa.nl>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the spelling of "options".

Signed-off-by: Jelle van der Waa <jelle@vdwaa.nl>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 45c71f7d21c2..dca9e72b0558 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -884,7 +884,7 @@ enum nft_exthdr_flags {
  * @NFT_EXTHDR_OP_TCPOPT: match against tcp options
  * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
  * @NFT_EXTHDR_OP_SCTP: match against sctp chunks
- * @NFT_EXTHDR_OP_DCCP: match against dccp otions
+ * @NFT_EXTHDR_OP_DCCP: match against dccp options
  */
 enum nft_exthdr_op {
 	NFT_EXTHDR_OP_IPV6,
-- 
2.53.0

