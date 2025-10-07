Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510F742AA3
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 15:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759852645; cv=none; b=SsPf8Rnf6Fy2gnR9S7mBRkC57UVnAnfJmyCOGai6JGAf/+ZT5RJHxTf8QtW85l8apvJ/UD8vLJw5r+SRnQ22lMP5JpEwh9L02DRJ3pQrreIB/Wipn1NbpjoDcYSGN+H+gD7XvXJx8i8WxjQ8rVuQwKrGNQ1rWPEeDkDWH8UTJPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759852645; c=relaxed/simple;
	bh=qvS0KnllWegE+y86sKNxl/XYeQiCcQE467TlMscnXsI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=faiUqGb2qn0469CGh9/6QprYUWTkEtxH5axCJ+TBVijuQisoPGoOPLyobiLRA84tlgcTa8v4mbf4BkT9hU5ApHq8onQq3iAFhcncCpgBX7uZFnCUo1hdh7XjU3TfS6BQ4suWFX5Fy4/awcbTfmtvexmxlcEkL4UB/R7ZQRcrqOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=SKo+4zNm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="SKo+4zNm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hs10FDuPXGhKzz/nrLFVUiOQ6vEDg1FnbOym1TNSBfc=; b=SKo+4zNm0HNknuAZ0f7WNQ8kO0
	7aFGIF8z8lTyYdMVZluv3hfX8eGAtFTAlMbVyEDcv3Opeb+tm5+eJbHN9pO2+B/cyDz7tRBYjQB71
	N4bT17IbjTV1E0F4eeQIRXhPXXIX2ZyxstuLbWJKdQpsaxPJP8F0G8ZuUGynra5SOQV/QIzLTKrq4
	YpqEv9pp0VH2nXG/jR7UXQzM0Vnva2rn8e2RX5XncVaBP/ZEG0x1U5hmpSNN5Q0LOrgCrbVwkAyNJ
	E0amuCSaXESKvCBr0siyAjIZAgPwUwVs9XMpmoE08bpLmTJzr56sB41zAvLA4cQFMKKXWWzd/qtcS
	Sw9nIEQw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1v6A3t-000000004Wo-10jQ;
	Tue, 07 Oct 2025 17:57:13 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH] mnl: Drop asterisk from end of NFTA_DEVICE_PREFIX strings
Date: Tue,  7 Oct 2025 17:55:17 +0200
Message-ID: <20251007155707.340-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The asterisk left in place becomes part of the prefix by accident and is thus
both included when matching interface names as well as dumped back to user
space.

Fixes: c31e887504a90 ("mnl: Support simple wildcards in netdev hooks")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This is covered by existing tests already. Looks like this late
conversion to NFTA_DEVICE_PREFIX went entirely untested by accident.
---
 src/mnl.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index bba34b73a708f..ab4a7dbc8d252 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -815,9 +815,16 @@ static bool is_wildcard_str(const char *str)
 
 static void mnl_nft_attr_put_ifname(struct nlmsghdr *nlh, const char *ifname)
 {
-	uint16_t attr = is_wildcard_str(ifname) ?
-			NFTA_DEVICE_PREFIX : NFTA_DEVICE_NAME;
+	uint16_t attr = NFTA_DEVICE_NAME;
+	char pfx[IFNAMSIZ];
 
+	if (is_wildcard_str(ifname)) {
+		snprintf(pfx, IFNAMSIZ, "%s", ifname);
+		pfx[strlen(pfx) - 1] = '\0';
+
+		attr = NFTA_DEVICE_PREFIX;
+		ifname = pfx;
+	}
 	mnl_attr_put_strz(nlh, attr, ifname);
 }
 
-- 
2.51.0

