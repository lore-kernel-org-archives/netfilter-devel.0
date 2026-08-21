Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F2F352C5B;
	Fri, 21 Aug 2026 02:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787279400; cv=none; b=HiHGRgyBu6rFKDyBGyEMoKo/Rp4NsfbFKtQWboWk375Hd2yy04vsq0M4tS/05E3gxy2LcMDT1YHS2MlvZDsTxaN2mJRKpqHbpj+3asmuCdG82R+rsCUrjTeRC/BqNsajc34AjD1kdXLPaWFxeUq9lJ8yVXqInALA2IN/NMY654c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787279400; c=relaxed/simple;
	bh=iH7ooZJTdpvcJWdjV+zxvNjGfu5XUqI4sU1V3ZeJ9tk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=HjOkKI/R64j4hZcPcrbpUNUxM7OyeFcQHFjbk0QPrdDoWWA2PJr5Xg8/VfOlidHTiX0R0OEuvdm0BARaG5N53kqTiqpcR/76Tx+oWi74mAXLGredgKbsz3rbjEU8aVgLsxK6ah3Y9Eq5g7pEPQ+CBJakg20Hj8GEKbbRmXJzE88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=elv/mH15; arc=none smtp.client-ip=117.135.210.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="elv/mH15"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=VOIRasaHTfH/EEOo1OTJ0DKlCglO983xDsTy/l3yny0=;
	b=elv/mH15Gpt8qIpUpr9GQZC/n98iss8gMrwsFsD0ywRkWf5dmt+J5abTbAsyFp
	YDyd79l1x3hfZygvutnvUTH1bNfQARy48VL+7Tm4ohex7lMsauUzYxp9ySqtnkqw
	YWivE85VsRc8/2551lZi8mEIicE7zO4jQSGk6fn2bQ3DI=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDH_7PEt4dqrHfkGQ--.21430S2;
	Fri, 21 Aug 2026 10:28:22 +0800 (CST)
From: Linkui Xiao <xiaolinkui@126.com>
To: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: [PATCH] netfilter: osf: remove unreachable break in nf_osf_ttl()
Date: Fri, 21 Aug 2026 10:28:17 +0800
Message-Id: <20260821022817.153861-1-xiaolinkui@126.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDH_7PEt4dqrHfkGQ--.21430S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr4rJr1rJF45XrWkCr1DAwb_yoWfJFX_ur
	y7XrZ2qF4YvrZxAw1fu3y3AF9ayw18WF97Xr9rXw47Z34DW3yjyaykWFZ0vry7Ww4kWa4Y
	yas3Jryjy34fGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbCtC3UUUUU==
X-CM-SenderInfo: p0ld0z5lqn3xa6rslhhfrp/xtbBqQabcmqHt8aLsAAA3h

From: Linkui Xiao <xiaolinkui@kylinos.cn>

In nf_osf_ttl(), the break statement after return in NF_OSF_TTL_TRUE
case is unreachable dead‑code. The return statement exits the function
immediately, so break will never execute.

Remove the useless break, no functional change.

Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
---
 net/netfilter/nfnetlink_osf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 92002079f8ea..a3f855905d52 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -36,7 +36,6 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
 	switch (ttl_check) {
 	case NF_OSF_TTL_TRUE:
 		return ip->ttl == f_ttl;
-		break;
 	case NF_OSF_TTL_NOCHECK:
 		return 1;
 	case NF_OSF_TTL_LESS:
-- 
2.25.1

