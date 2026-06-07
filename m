Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2F1388377;
	Sun,  7 Jun 2026 09:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780825811; cv=none; b=GAx9lNU522hxB5H2hoBykQtdgpxUkn3O0/TS+6ketYHXF1R9qsnsr8bo77+rQhIINpMr7wzrKF0BI/c+6GvLo3VEqjTU7kHZKMQcXkfOydJQPgwxKFOVaFj4BMVEkdgB1Ehqv5w6Tla1m0w6rzkAtN4Eb5LM3hLur9c8eeYEQYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780825811; c=relaxed/simple;
	bh=oTD6nAG9RV1jtJYtpP65xMkApypxQLYVjuY3wE3Zlyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWRuLCPmS8KTTXYM2kyM2x1jNiK0v+rYmF8PFJularqSS45uFd2cLlhrf9AD6sDyz+iHPB2NpthlX1gSGZjN5nwDkHXD3lKPxXd2jrbehNFdx/RNbLltCyGjCn85PjFe20W9boVZ+TfO9II4hTKkfKLyT3GinhW+T8BZCCGPC+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iXUOi+f/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iXUOi+f/"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7FE896017D;
	Sun,  7 Jun 2026 11:50:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780825809;
	bh=alNfBkjo+TWivPDZty4XaiUW768UPCeiyUW10r6btvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXUOi+f///bjrdjghytHY8EHiHvnihyEBzAQx+blWKMuPBOGMv6z5laV9A2nAQdvB
	 +Vq6kpiI8VEpORnSSx9+tS6HFONcd0+JBr2+ji/hF7fjzcHyhg8S9ARVIbpAxRyi6/
	 yEp2j71xyeOwkfohosIbd8GK+tcQBgaBg6rgnHnRBacefrdH+SxtrS8kL3yvxltRRd
	 +WQalPMeYUaLWEx8n7xpH52SV7tH6Ol+/Psyxf2DWNFIu7dImjb6AfGdTvftlZEgIL
	 1Rst6VnChp8d7VnjtdVuxLvveaZvy77kFqMuO/Ea5hkQYBccQNt3naMQeJNuO+xCV6
	 HvNLmpDNzPBXw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 05/15] netfilter: synproxy: adjust duplicate timestamp options
Date: Sun,  7 Jun 2026 11:49:44 +0200
Message-ID: <20260607094954.48892-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260607094954.48892-1-pablo@netfilter.org>
References: <20260607094954.48892-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

RFC 9293 does not mention anything about duplicated options and each
networking stack handles it in their own way. Currently, Linux kernel is
processing options sequentially and in case of duplicated timestamp
options, the value from the latest one overrides the others.

As SYNPROXY is modifying only the first timestamp option found, a packet
can reach the backend server and it might parse the wrong timestamp
value. Let's just continue parsing the following options and in case a
duplicated timestamp is found, adjust it too.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_synproxy_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index f99c22f57b7e..a0bcf188810d 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -233,7 +233,6 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 				}
 				inet_proto_csum_replace4(&th->check, skb,
 							 old, *ptr, false);
-				return true;
 			}
 			optoff += op[1];
 		}
-- 
2.47.3

