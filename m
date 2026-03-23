Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF8836DA10
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Mar 2026 08:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774253297; cv=none; b=qjqfJDUBiiZDlDacz1T8m6P5p1XQB6M/nTNZGWlBPobmO9nhm4GXDmIzXgXfxaK8yY4VWj5q8jVSePEmCjliOS0bqzstT7w1WLDJU6RZyPMNp2S012tJN0baANJRQtC5nZPMa9rIkE+V4CdfKiX/CxgiqtqQ52kFKOFdclPOQ5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774253297; c=relaxed/simple;
	bh=5Zy0XUwX6iIi5GwhjGoPNY3Vg2jY5I/S4eF+tYiFOFE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s+0SqDKiMPGc3czuqcJLzpz1hnYn455c5oQuH/uTCkkUTn9W4aqh1ugypipLoN5lmipwT4GGU+E41u1TeJiAo7mMFC3Gcsi7o6cSHOYLV24qg8edrk9yuJB5JERwIAq6Ml8uQ+6JCGUQ1C/361UFfYr7ULdAze/fTIo+DLIKq58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XWFwbUKZ; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XWFwbUKZ"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c73ba417c6eso1500704a12.3
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Mar 2026 01:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774253295; x=1774858095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/oxuEK0aKiR5BZiJwQM9QbFzk9FiV34b8im9vtCPOQo=;
        b=XWFwbUKZWo7I3MG3tqXs8n0H4sRxFopjfXPGPFNcbMZKUu9ob+LOAD7gOq5j2nuA/X
         SZqmeBdfuZgAcfVUtUUx3/m+RIZ3mAtmrgx4crJLSj1uCP4QmtmMbXOp4hyckRkY2XyF
         rsYS8KX8Vv6mtlMvf90hGC1PDsmJurpXe7iSnSKf1+aGPo2vrX3JEO+v/zolES91AWm6
         +jMGK3AbIFCydspdkPFlCWUMwEXuKqLvdQOYRewVHX91HbrGDrGEiuj4W+dPuQHr6wPv
         z9poGwhtAdUGB/ACXoZV3A3EgwtvM+TsqS04Ia+US+OepwuSqWQ+W9WIUilDuKk5ARUY
         XoZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774253295; x=1774858095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/oxuEK0aKiR5BZiJwQM9QbFzk9FiV34b8im9vtCPOQo=;
        b=ccGcCa9bavyqplRGcqsOR0JKGCXDONgGf37EcWWLVbmHVP7n+ed7jpKLjv2gmshFhU
         TtDHk9k/zeQQ9Ws9tyopl+DBlqqlmBAciFmCzRNc6O/mM7y1kTJyEvj402C68IuZOIx9
         SsdSQMp0g8TS69jMRdu7yANjdET8Wl26uPWDuMUjdeQWKQJKE8kAGYbsjIqPqdr31uWZ
         vI/kWtm/gtJnPu31ptpysCxAwn9qxdbMoT/ktEetWaB+OZOYEZDQobripSwJW5fMRJ+2
         ZZadvktrsnywqUMrsWdRJX67n/gYQBX8HizaemtSmvwTP8svmUyj/OG3cT952+kdmj7R
         QGsQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1NWL1Bm3RAxcxUHSjpBXmKC7ozQtZYrTeY5W9iXr6xY4CITuQHuv8WwMbh6F5Btrd34Wg2NIJgbhjFZaY7hg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnLZVBEZHwX75sRHsb0r3Wyv+av4jTab6UJCx+IpkR7EtACWU1
	FzNr3XoFwyFe4pYwJGhMietVGEoUH59G6mOFWvubENFwQUTawr7l/aBo
X-Gm-Gg: ATEYQzyZgeUsDupT5ZvK69wLM+bAL8SHrbICbs5leibLvotoBXmL0FU8AZCnNC5EwcC
	FMU4NwanxDCaXHTv5w6eNS3l73PXSS0buNqP3dbSkuqJTvAA726iZxlp1V32xMg+hK+sJAGTORQ
	gW0JLt77NPus2K0ZzPVKBzCt+ybH3Rz2q9Iod9FS0FRj+xep7H+zFqKzRiTZ48qUneUFlVkbpOY
	7A0k5+q8iDtTALxlldkXD8IuMmdSRFeR9ICzax3MdRXZnpZiTlapi26vIsnFME8VSTwVoL/0wus
	L1/igX/OiqNoV5Bi6ceXfUMZz2CwKyj80MzPCZlug/MRTAdU2kiITnor2qYFzO4+uR15/jXAGWk
	7E9TSHU9euS6hMIj4gmNUKuBpaGcXAMWhAFpYEaYwfSm95C3GXqhW/iI0Qb8ssQ5VOLoLr9XF8p
	JDrVDXatq+mLlAxfJAU4oej1fB4Z/mnDAuTPB4jL2vcS9XmjgH6uqfLVuUtjd25W3LHdiAizP+h
	7DRvpmBqNU=
X-Received: by 2002:a17:903:1a0f:b0:2b0:4f82:74b1 with SMTP id d9443c01a7336-2b0827c165emr102975785ad.44.1774253294945;
        Mon, 23 Mar 2026 01:08:14 -0700 (PDT)
Received: from SLSGDTSWING002.tail0ac356.ts.net ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083549f63sm99706195ad.30.2026.03.23.01.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 01:08:14 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH nf] netfilter: nf_conntrack_sip: fix use of uninitialized rtp_addr in process_sdp
Date: Mon, 23 Mar 2026 16:07:29 +0800
Message-ID: <20260323080727.2932866-3-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

process_sdp() declares union nf_inet_addr rtp_addr on the stack and
passes it to the nf_nat_sip sdp_session hook after walking the SDP
media descriptions. However rtp_addr is only initialized inside the
media loop when a recognized media type with a non-zero port is found.

If the SDP body contains no m= lines, only inactive media sections
(m=audio 0 ...) or only unrecognized media types, rtp_addr is never
assigned. Despite that, the function still calls hooks->sdp_session()
with &rtp_addr, causing nf_nat_sdp_session() to format the stale stack
value as an IP address and rewrite the SDP session owner and connection
lines with it.

With CONFIG_INIT_STACK_ALL_ZERO (default on most distributions) this
results in the session-level o= and c= addresses being rewritten to
0.0.0.0 for inactive SDP sessions. Without stack auto-init the
rewritten address is whatever happened to be on the stack.

Fix this by pre-initializing rtp_addr from the session-level connection
address (caddr) when available, and tracking via a have_rtp_addr flag
whether any valid address was established. Skip the sdp_session hook
entirely when no valid address exists.

Fixes: 4ab9e64e5e3c ("[NETFILTER]: nf_nat_sip: split up SDP mangling")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 net/netfilter/nf_conntrack_sip.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 4ab5ef71d96db..17af0ff4ea7ab 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1040,6 +1040,7 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 	unsigned int port;
 	const struct sdp_media_type *t;
 	int ret = NF_ACCEPT;
+	bool have_rtp_addr = false;
 
 	hooks = rcu_dereference(nf_nat_sip_hooks);
 
@@ -1056,8 +1057,11 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 	caddr_len = 0;
 	if (ct_sip_parse_sdp_addr(ct, *dptr, sdpoff, *datalen,
 				  SDP_HDR_CONNECTION, SDP_HDR_MEDIA,
-				  &matchoff, &matchlen, &caddr) > 0)
+				  &matchoff, &matchlen, &caddr) > 0) {
 		caddr_len = matchlen;
+		memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
+		have_rtp_addr = true;
+	}
 
 	mediaoff = sdpoff;
 	for (i = 0; i < ARRAY_SIZE(sdp_media_types); ) {
@@ -1091,9 +1095,11 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 					  &matchoff, &matchlen, &maddr) > 0) {
 			maddr_len = matchlen;
 			memcpy(&rtp_addr, &maddr, sizeof(rtp_addr));
-		} else if (caddr_len)
+			have_rtp_addr = true;
+		} else if (caddr_len) {
 			memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
-		else {
+			have_rtp_addr = true;
+		} else {
 			nf_ct_helper_log(skb, ct, "cannot parse SDP message");
 			return NF_DROP;
 		}
@@ -1125,7 +1131,7 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 
 	/* Update session connection and owner addresses */
 	hooks = rcu_dereference(nf_nat_sip_hooks);
-	if (hooks && ct->status & IPS_NAT_MASK)
+	if (hooks && ct->status & IPS_NAT_MASK && have_rtp_addr)
 		ret = hooks->sdp_session(skb, protoff, dataoff,
 					 dptr, datalen, sdpoff,
 					 &rtp_addr);
-- 
2.43.0

