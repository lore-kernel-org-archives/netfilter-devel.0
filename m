Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422194;
	b=NCfjTIVSpW0apKDgEtPndjpY2pBEIQlp5xbyE6XWE46CDj5rb0Oke5gpssosHE3A2jvM
	 THcm8rdBFkoDMd5LVIsTapCIvwaTBB2xqllJvx9ILJjdWatwscSu8EfVIue4vlNCYvXel
	 vro1Ni/b+7u+Pmup74YVz0RIAPv/g6p2Ere2kggyCMJwm/iWR84pHp9I328BqwOgAeQZ+
	 Ejmpt22zoBRGGOg5ROHpAqGTDIDgCw4PyMYqzddaHHOxOpNRsLL5UsNr6KrNJQQQQZYPi
	 EETsXVLfRmgBGCc3oBRdIixf6Gh0sSAzYsiVvd3P3cxo8tKV809hAMwXMHaeQAAKGDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422194;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=EYYBZweTFbgEHPbYMbybod7rnUu2C7irlTalCiIKRiY=;
	b=W/cIreMqEsoyVxcqSniye/VFppBH6uie/zAn7mp0XHEJYhzCepVCsXZflddxuofJudfg
	 19nEAqL431lJPUex5Pb1Cl2DxqiZDxJ67l7HoMkukJMKgC26lwsbQkV6bpaPaui2z6Uj6
	 QYNfbd+N3V/cPVK4vZmmIXVBUTeV0ERFa+urwM6wxAwSfbv3LOnHBWuPR/oknSnDRHlaa
	 DmLaLMQEn/EFCWC0Z+evLamiaYd7phSvRxAH/q71Tg1ZLmCZoKvNn1qxZyoRzj1MHTZ1m
	 4I5Abq1ebZyICS++j/OEEaV7/2egb43xEhlkiy/XQDc5rTD/ibfh0kyTson95vwyLBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=EyPKsr7Q;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAB6607D372;
	Mon, 19 Oct 2026 15:03:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BAB6607D372
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=EyPKsr7Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792422192;
	bh=EYYBZweTFbgEHPbYMbybod7rnUu2C7irlTalCiIKRiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyPKsr7QxrpppeLpBD6bAo0WBFBXRM27ebYP9k8JpW9OHK/XNVsam3JhdP2Qk+cRg
	 SsrzZFMf41b/JY5FBY1Shh5SkMWdsy0B2RXOXxC35sNbiXjjmObzZzcV0sZ4DxvXaC
	 T9Q1mi0dIrBvOiiSgyob1Z8uDPPsusqcXB57p8jM6oa00nerr/ja5DlwCdJg59X7Om
	 KxqcWv0+1Z/oLbQunElkeZb0xBLgWpSS5H0T6UqxlOiq+b2njmsoJNEqVespn9E2xd
	 fx4UONQIzeLag+iqhrJXRYjyyn0yKWgL+23pWOxMt64gn6gtUlg9XEU5fhu784qSbQ
	 Q+PLt9bH0DGLA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id ED0A660074;
	Mon, 19 Oct 2026 17:03:11 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 10/10] netfilter: nf_conntrack_netlink: fix inverted IPv6 tuple filter
Date: Mon, 19 Oct 2026 17:02:49 +0200
Message-ID: <20261019150249.1879516-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019150249.1879516-1-pablo@netfilter.org>
References: <20261019150249.1879516-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Liu Chao <liuc63@xiaopeng.com>

ctnetlink_filter_match_tuple() returns 0 (no match) when the IPv6
source or destination address differs from the filter, because the
!ipv6_addr_cmp() test is inverted.  ipv6_addr_cmp() returns 0 when
the addresses are equal, so the negation makes the branch trigger on
a match instead of a mismatch, which is the opposite of the IPv4
path above.

Drop the '!' so the IPv6 branch returns 0 only when the addresses
differ, matching the IPv4 semantics and the caller's expectation.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Cc: stable@vger.kernel.org
Signed-off-by: Liu Chao <liuc63@xiaopeng.com>
Reviewed-by: Weibin Liu <liuwb@xiaopeng.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4e5d7c701436..cc8695d5356d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1098,13 +1098,13 @@ static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
 		break;
 	case NFPROTO_IPV6:
 		if ((flags & CTA_FILTER_FLAG(CTA_IP_SRC)) &&
-		    !ipv6_addr_cmp(&filter_tuple->src.u3.in6,
-				   &ct_tuple->src.u3.in6))
+		    ipv6_addr_cmp(&filter_tuple->src.u3.in6,
+				  &ct_tuple->src.u3.in6))
 			return 0;
 
 		if ((flags & CTA_FILTER_FLAG(CTA_IP_DST)) &&
-		    !ipv6_addr_cmp(&filter_tuple->dst.u3.in6,
-				   &ct_tuple->dst.u3.in6))
+		    ipv6_addr_cmp(&filter_tuple->dst.u3.in6,
+				  &ct_tuple->dst.u3.in6))
 			return 0;
 		break;
 	}
-- 
2.47.3

