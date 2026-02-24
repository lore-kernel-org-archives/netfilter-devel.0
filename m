Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83B93090C1
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 06:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771915999; cv=none; b=XPmMZWPLAAFr758aKvjAwIefidJMQPgzekRfUtvKVl0BOOk6r4vqmtv58YIsdwG9xkqbEPPb6B87eppNtpZVuquP2info8mOdwqiLUzVYJxf1eJsSMc+3c+qNPTHkBOpCrNTXA9gTvuQuX7t0/kCZOlAQgcgYsGLs5etMD2EgZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771915999; c=relaxed/simple;
	bh=YUxeWiumDIevi3pfAqr7wG32llGuW6KcesoGqx9k/lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPkX6HA+8rTvVsuYnEzpaICWLijzGpUrs67qFw4gFr24cxVoHO6cxd3ObYUTNPQAseUQG2Et89mVvM62NxhqCPMhKrXVFUXx0LSKVGYjXk5/IOh7R8Wy4cmk0q1XPju61eudVM3QY6qFkH0liN6202IRGMlQIBLtzmH59CrwPlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ltcHuZkC; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ltcHuZkC"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b883c8dfb00so885543566b.1
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Feb 2026 22:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771915996; x=1772520796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYuYJwbEOhynhWIFlwCSfc7cGmzyMZHQheg8tgUujHU=;
        b=ltcHuZkCaNBcYUNGsqjNuv2AU+7UWZgTTTBQFTu2b2wyXQZPCtGVen9cjJcftxJ6dj
         Su8KrAQ12hRZMcnMgexuci4hnCN7PSc1nrZBii4I+uK/80jfvHYp+5SHv5T6ofIXQqcr
         yR8PXWe8gqxJROVK612GItwdR0JxtlSNIIuWbBzdLp4a7hHSUhSIQBciHkR6Ur2xK2Em
         AKF+QHh1XcJ+su/lO+ulIQIg6RHFH4XJm4IciGRmqORYlbs3eNZ1B2r8gGoMkZMYg/bF
         1FK8L/2tuwK3P+kEMBFLY3LVL3sv9zApi3DsPqtR2XsaEQuYjHecAfirVXs3SyZTJ2tP
         qCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771915996; x=1772520796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gYuYJwbEOhynhWIFlwCSfc7cGmzyMZHQheg8tgUujHU=;
        b=V0dnNaTQV4R0/BuusrIGq92UfqcGN2HmM+xwxIH7YHbFDZGMUKAxbEBqL3XrOBdAab
         YEOyYY0lIlfWdcCM7lXZ0L+LLuGJd4VuasILVNOuPSo/LSm59Yuj+Lv1gQfRnRj0s4tc
         AK8rCrB2casWj1b4427tSgOd3Lz3gjtZENKXPI/XexBvPEPKtzIk4Nkk49YK4Y729gcB
         NuLgBx9vWus4Vwfu1n3g3xcfhE3qp85S01ZYwpCIeTyjBVSIfe3krP2fEBnrqKUEYAli
         b7WNAYY1lvlDJ6aBvc0H14urJBR0+2TCi0KQYoX1xP3t3nUnjzP9N/2qY+dy8yMNavss
         YV5w==
X-Forwarded-Encrypted: i=1; AJvYcCUkQa8gq2bv3iP0bgOLQPUITgOVMMREroAREH5M1iFk89XnYkcwVmUIOnRlOlRizW+HEnmO6c4WCmbXQpkYEqA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhLNwRhiRVXBWVgIg9Cksc2XaG05TGWQUPX7+ARlDbkh/UjuJy
	STl5oz7jaTGkNkOOx6D5BQpv86QkED22gvGyqxHtp3SqyoY6koN40Go5
X-Gm-Gg: AZuq6aIxNZ/pd9+sdhbb+yQOGlm9YTC3gtrnMDX4R6DycgFg2LSEWjXfWw3HnMd4wxS
	r1bMi/6KkkWxxz1xeGUJYk/iq9zPoOZ50E+kasKEoaKNzN7HV4Ab4F2VigFEkacqDcTv7t/s6Fi
	4CmANWAyIC8Yc4gOEFMQDGrgpZ/F+8uNg/pU5BPPgmGVmg5kPgyW9N8Nt48WRYx95kIxK5iRhSx
	RNthFj11OOBrXiGEeXoe9OGWLxUgvl+SLdFxhB4inFHNezfv3R+TD7fEwhqrJJR82dcJWelal8I
	fW3yqLJ598rFAmK1beij37u37pRcamaHbBBabg6WC8xjOm5NGioEpcQOXk+w1H38SLaLLsw31ta
	u71742FM8iVYUEgKwo+m6g/Opsr6yGMO7juhKoCPdAvU2tRgyWKxnUgTHCAG4nf+wj3pc6hXzXU
	p4bgYmoZkpME7O2rjFSi7TMXJjUz5tUroG7LkyoYDBiV9sSMx3p40423h1DoNKBoHPaCByydi57
	zrfVVY0eRWNcGiKp844rWcQUAx6bHE3uiu1jrCutTBowGjnrkq87zY=
X-Received: by 2002:a17:906:c08f:b0:b88:5b21:b162 with SMTP id a640c23a62f3a-b9081b4e959mr536995366b.28.1771915995872;
        Mon, 23 Feb 2026 22:53:15 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65eaba13866sm3096698a12.18.2026.02.23.22.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 22:53:14 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v19 nf-next 2/5] netfilter: utils: nf_checksum(_partial) correct data!=networkheader
Date: Tue, 24 Feb 2026 07:53:03 +0100
Message-ID: <20260224065307.120768-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224065307.120768-1-ericwouds@gmail.com>
References: <20260224065307.120768-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the conntrack hook it may not always be the case that:
skb_network_header(skb) == skb->data, i.e. skb_network_offset(skb)
is zero.

This is problematic when L4 function nf_conntrack_handle_packet()
is accessing L3 data. This function uses thoff and ip_hdr()
to finds it's data. But it also calculates the checksum.
nf_checksum() and nf_checksum_partial() both use lower skb-checksum
functions that are based on using skb->data.

Adjust for skb_network_offset(skb), so that the checksum is calculated
correctly.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/utils.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 008419db815a..4f8b5442b650 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -124,16 +124,25 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 		    unsigned int dataoff, u8 protocol,
 		    unsigned short family)
 {
+	unsigned int nhpull = skb_network_offset(skb);
 	__sum16 csum = 0;
 
+	if (WARN_ON_ONCE(!skb_pointer_if_linear(skb, nhpull, 0)))
+		return 0;
+
+	/* pull/push because the lower csum functions assume that
+	 * skb_network_offset(skb) is zero.
+	 */
+	__skb_pull(skb, nhpull);
 	switch (family) {
 	case AF_INET:
-		csum = nf_ip_checksum(skb, hook, dataoff, protocol);
+		csum = nf_ip_checksum(skb, hook, dataoff - nhpull, protocol);
 		break;
 	case AF_INET6:
-		csum = nf_ip6_checksum(skb, hook, dataoff, protocol);
+		csum = nf_ip6_checksum(skb, hook, dataoff - nhpull, protocol);
 		break;
 	}
+	__skb_push(skb, nhpull);
 
 	return csum;
 }
@@ -143,18 +152,25 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			    unsigned int dataoff, unsigned int len,
 			    u8 protocol, unsigned short family)
 {
+	unsigned int nhpull = skb_network_offset(skb);
 	__sum16 csum = 0;
 
+	if (WARN_ON_ONCE(!skb_pointer_if_linear(skb, nhpull, 0)))
+		return 0;
+
+	/* See nf_checksum() */
+	__skb_pull(skb, nhpull);
 	switch (family) {
 	case AF_INET:
-		csum = nf_ip_checksum_partial(skb, hook, dataoff, len,
-					      protocol);
+		csum = nf_ip_checksum_partial(skb, hook, dataoff - nhpull,
+					      len, protocol);
 		break;
 	case AF_INET6:
-		csum = nf_ip6_checksum_partial(skb, hook, dataoff, len,
-					       protocol);
+		csum = nf_ip6_checksum_partial(skb, hook, dataoff - nhpull,
+					       len, protocol);
 		break;
 	}
+	__skb_push(skb, nhpull);
 
 	return csum;
 }
-- 
2.53.0

