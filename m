Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE8D3B3894
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785175118; cv=none; b=hazlve1LNLtdTKi+RUX6ECbDMybHzlbks/sbx7dHS+7dNk+QGNBCevzIOm1kj0D5/8i25DcX3z0WCv9IamQnb/yrP703KsHgSy5z1Hie155foeufWRl4ztB+8phlICWmnEpVFoVCBQBW8WfxAwDaF1hjs6OSqKPggU7JTJzKmZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785175118; c=relaxed/simple;
	bh=dwOheTaJfvGLDz0P2FsnKIqHTyLtFCrPmJa9ENBsfK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phKUpjg2K8tsgG88/nKLxYDL+Pgp4HDov0xFMaPuAs6wWEWGzs+BC59Jxhw3QouqLknHMB0CtGx8LuJoZmShTCNKOIHkLqaU3ReLMPQHhmuREtG2Cj1C4FxdUrmEkqNGyR50fiqiXDljSPW/h7sGSmoRCf0jHyR3y7OyFVmS1wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LS0o3pYb; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LS0o3pYb"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84a2c90e383so152484b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 10:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785175114; x=1785779914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rPloXk15f/pP0jxxbC4FyVb07gsy9C4WQc039d5/Ubc=;
        b=LS0o3pYb1r9tN5ibLlJh9PWrKwK6harOj0lLd1zB/1PQr6oXrDt9WqSi0HCOXz0nSf
         Mivzhl/1LsMY/VTI3EOJYcges/Ip759ZN02BIUbsQGwbG7nlIeTmw94L9ppaqs2agrYB
         /QDxEBwVePyy415v4UidO2fzoBFyQlwcjMeTNu4yOZDyplGMyvv9qqwPDBW6oRD1lPb/
         K31ix378IK4hF58xu2Iv8/D6vJRBGfOtPP3sf5KMfpUI9g66WnElZiHIka174ihq9KdI
         uNrRE5Bpe4bpEJsQxrP+LeTcrQ7p2qnf1Gz9hnxsMZgBJddYndnUkM9hwqH3L+a08RjT
         0VQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785175114; x=1785779914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rPloXk15f/pP0jxxbC4FyVb07gsy9C4WQc039d5/Ubc=;
        b=rmY1vA6MqNu4tsx+ZF+NhFy+OVOI/Uo4FDKK3DPYc9elHqqDCduBgu/ztqqYqR6Fls
         eSUukB3qxgMtk/qoaJeHFeI3RioA3HySvNitlLuwZabUFYwEEh6h17xC6HvXqwxDujCs
         NG8JXPuaWHQKkgTgXh29emjNgxRXCu4TXCgWs3KJqRJsh4Ub5JGA58qErWHZvaUeFFdW
         xoSqosHVRG6wZCBEhF31b1zzqZBiFllKqghnZBX5nhs8pbs0GeyFpEWVI6Q3wu+irnVb
         sWQl2qB8tjru4vhY34u7I4OWLaPl1e0lnhhk+/RBViUAwk8wWQqZxRs/F4bkkJ3azXw/
         Y+Zw==
X-Gm-Message-State: AOJu0YznFnIMa9K0dv5fpW/mn7bqYPY2YhraQMFGWXfv4SCQAMlb1CSX
	RyAtIcKFazx+643C+sNpj8Zq+eGZMEFYarad2F4H+pdz6XvuJazHay28XZAOvc1k3/1GjA==
X-Gm-Gg: AR+sD13nwjqr5/CXvyVhln/Csac2mQWJmoIu3Cw/soHw85Z+z9Vu/VV4rRI5UR790xl
	8l2YoEqJLSpiwfNLZGMXXtifAFHwnEwxEtLJ0TrnqNzwxXOsT6fL8EJ+Z8XOeZswq1YsEkmnd67
	9UQ2QL0HsAnlGeQOGvwcPENHb8tZ/d6JT8cHr89I/Gu9Buc4U0x0BiEBGdYfpFwJOcmoxKQfifq
	b5zvKiaRASoGrLQgs6QDcC2/DLnEdBTM5upfC+0OruEZAV62TRHsYMr7RzOS8/wfjN6mYem1Wy+
	KU7X4Sv38oHNKLHt3v6ULJbJFvHZ00Q3ZoZdejKUin/Jp425KTdc/5gz92RhtXxtIFkFQ10m0qr
	9fc8tnZ+PWW9HFBvAyFqY/OoEWk87exCCs04EwMZl/Y3Eu0IgehdqCbUmM0uthurr3+5ZLQErR/
	9HcUN5NL1JMv/Zomw+K89E
X-Received: by 2002:a05:6a00:2e9f:b0:848:2a69:97be with SMTP id d2e1a72fcca58-84e8d06df52mr342369b3a.10.1785175114203;
        Mon, 27 Jul 2026 10:58:34 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([219.141.235.82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e53418f58sm3391117b3a.40.2026.07.27.10.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 10:58:33 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	zhaojignmin@hotmail.com,
	kaber@trash.net,
	vega@nebusec.ai,
	zhilinz@nebusec.ai,
	enjou1224z@gmail.com
Subject: [PATCH nf 1/1] netfilter: h323: keep NAT mangling aligned with parsed transport
Date: Tue, 28 Jul 2026 01:58:23 +0800
Message-ID: <68faab5bf406aad612233e76994c649fbc547b8d.1785133455.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1785133455.git.zhilinz@nebusec.ai>
References: <cover.1785133455.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhiling Zou <zhilinz@nebusec.ai>

nf_nat_h323's set_addr() chooses the TCP or UDP NAT mangler from the
packet's current IPv4 protocol byte. H.323 conntrack helpers run later
from the conntrack helper path, so a packet can be accepted and assigned
to a UDP RAS or TCP signaling helper before another hook rewrites the IP
protocol byte.

When the current IP protocol no longer matches the helper's transport,
the parser and NAT mangler use different transport-header bases. In the
RAS case, ras_help() parses addresses relative to the UDP payload, while
set_addr() can call the TCP mangler and use a forged TCP data offset.
That can make the NAT match offset extend past the skb tail.

Select the mangler from nf_ct_protonum(ct), the stable L4 protocol stored
in the conntrack tuple, instead of the live IP header. H.245 parsing is
TPKT/TCP based even though the registered H.245 helper can be bound to a
UDP conntrack from userspace; ignore those non-TCP bindings before the
TCP parser feeds offsets to NAT.

Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
---
 net/ipv4/netfilter/nf_nat_h323.c       | 9 +++++++--
 net/netfilter/nf_conntrack_h323_main.c | 4 ++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 183e8a3ff2bab..98d50b3a6be2c 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -37,7 +37,8 @@ static int set_addr(struct sk_buff *skb, unsigned int protoff,
 	buf.port = port;
 	addroff += dataoff;
 
-	if (ip_hdr(skb)->protocol == IPPROTO_TCP) {
+	switch (nf_ct_protonum(ct)) {
+	case IPPROTO_TCP:
 		if (!nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
 					      protoff, addroff, sizeof(buf),
 					      (char *) &buf, sizeof(buf))) {
@@ -51,7 +52,8 @@ static int set_addr(struct sk_buff *skb, unsigned int protoff,
 		if (th == NULL)
 			return -1;
 		*data = skb->data + ip_hdrlen(skb) + th->doff * 4 + dataoff;
-	} else {
+		break;
+	case IPPROTO_UDP:
 		if (!nf_nat_mangle_udp_packet(skb, ct, ctinfo,
 					      protoff, addroff, sizeof(buf),
 					      (char *) &buf, sizeof(buf))) {
@@ -62,6 +64,9 @@ static int set_addr(struct sk_buff *skb, unsigned int protoff,
 		 * or pull everything in a linear buffer, so we can safely
 		 * use the skb pointers now */
 		*data = skb->data + ip_hdrlen(skb) + sizeof(struct udphdr);
+		break;
+	default:
+		return -1;
 	}
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 24931e379985b..9cac3e5ab39ef 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -539,6 +539,10 @@ static int h245_help(struct sk_buff *skb, unsigned int protoff,
 	if (ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY)
 		return NF_ACCEPT;
 
+	/* H.245 is TPKT/TCP; ignore manual bindings to other L4 protocols. */
+	if (nf_ct_protonum(ct) != IPPROTO_TCP)
+		return NF_ACCEPT;
+
 	pr_debug("nf_ct_h245: skblen = %u\n", skb->len);
 
 	spin_lock_bh(&nf_h323_lock);
-- 
2.43.0
