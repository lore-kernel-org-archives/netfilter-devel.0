Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794310285;
	b=DJFtdLM0DUKVPWtp+phXU4cLAXbPNu5PwnXAR4RLs3Hg/WJYJ16yp0FuzIPBZwbaOEUL
	 zyuVOxwqUhy9mWRgHi9CQpFgyIq9ClHqOxzuJlQRXNsnkgps1QSzfJhc8INKi/Ip2S6U5
	 wqAaf3BlHhoKXorYJ/YgZZ/i2cT1rH4P8UQDSsY/IqHJe099RDDDa4ALYbRh1sZF/l9SV
	 2G4VUo3sZvdrdjxMv2dEnUWb2iNfQalfuDkcffA6BgwHzYUbpG42g6Z83ef3k/NuI+Oip
	 5vvlQiGJSW9HdDXuXPxPqMhoyCpRSMpEbM6ryxak5wTRrB5UuumNKBfGQIAnKRHi+fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794310285;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=YNvbDX5GZoykBGORHisupVHuAa7wnlS0Wpxyq/NqfE4=;
	b=0sryxz7DSY3UQr9K8gpDAapoQ6yXRPDAxEsFsbeLcZcwepfHoVRKqYduShn+LyiUDJkU
	 MBIKOEw/ZSyRh8wEaFlaNFZZP5gNjmW/S5++20JaDg/DJkjYP5HoJpHlghfLA08s3wa4P
	 8/mQLttlIDpgVg4icgj521XjK5jkzGmPAcQssvzvz8yWS5hO3p6Xjh1sCe7Y86cP64XAu
	 yhlurv+hPbtUa2/Blec0M4FqX7O9O6vM6UJJnTPyXw1uUYvNQ8jm/Hh0ZazozNK6sQpr9
	 sIkOE+r5/fbZd1divI75F5i+K5P3kWljDksHZ9AyRDbBqQi9WbHZVO2VVlwn1uExzJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=aTdrh3xj;
	arc=none smtp.remote-ip=113.46.200.225
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE70606A325;
	Tue, 10 Nov 2026 11:31:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACE70606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=aTdrh3xj
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YNvbDX5GZoykBGORHisupVHuAa7wnlS0Wpxyq/NqfE4=;
	b=aTdrh3xjFkqdQyfNv2eUk72tdmzzxQBJtM/7OkJqmED5lm/CTKuu8X/BWqApKUIe5Q1nLnHrY
	Vqunuh+a5yRElVNyYZTHWxC9aPZFy4rge0xnLB9l9DnuA69Q+CJo/gRCJm5i3iG5wvt5Wy13QzT
	WmVMa5gKtea2ZaLz40CFqHQ=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jP4Gk4SYgz1K96b;
	Tue, 10 Nov 2026 19:31:10 +0800 (CST)
Received: from whupemp200008.china.huawei.com (unknown [7.152.184.21])
	by mail.maildlp.com (Postfix) with ESMTPS id 53D8A4058E;
	Tue, 10 Nov 2026 19:31:19 +0800 (CST)
Received: from localhost.localdomain (10.50.85.93) by
 whupemp200008.china.huawei.com (7.152.184.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 10 Nov 2026 19:31:18 +0800
From: JiangJieHua <jiangjiehua1@huawei.com>
To: Paul Moore <paul@paul-moore.com>
CC: <audit@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Eric Paris
	<eparis@redhat.com>, Ricardo Robaina <rrobaina@redhat.com>, Florian Westphal
	<fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<zhangchangzhong@huawei.com>
Subject: [PATCH] audit: fix incomplete NETFILTER_PKT records and return void
Date: Tue, 10 Nov 2026 20:29:39 +0800
Message-ID: <20261110122939.45373-1-jiangjiehua1@huawei.com>
X-Mailer: git-send-email 2.33.8
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
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemp200008.china.huawei.com (7.152.184.21)

Commit f19590b07cb6 ("audit: add audit_log_nf_skb helper function") and
commit 15b0c43aa621 ("audit: include source and destination ports to
NETFILTER_PKT") introduced audit_log_nf_skb() and its transport header
parsing.

The helper returned early with -ENOMEM when skb_header_pointer() failed for
the network header, and the later port parsing did the same for the
transport header.  Such an early return skips the remaining fields, so the
NETFILTER_PKT record is emitted with only "mark=" and without the address
and protocol fields.

Log the address and protocol once the network header is available, and
route the error paths through placeholder logging: a missing network header
logs "saddr=? daddr=? proto=-1", as the pre-refactoring callers did, and a
transport header that cannot be read where one is expected logs
"sport=? dport=?".  The same "proto=-1" placeholder is used for an
unknown bridge ethertype and an unknown nfproto, which previously printed
"proto=?".

Validate the IP version and the IPv4 header length, since bridge packets
can reach the audit hook without the receive path validating them.  Locate
the transport header from the network header instead of relying on
skb_transport_offset(), which is not guaranteed to point at the transport
header.  For IPv4, a non-first fragment or an unreadable transport header
logs unknown ports; protocols without ports are unaffected.  For IPv6, a
non-first fragment leaves proto at IPPROTO_FRAGMENT (44) and a negative
offset from ipv6_skip_exthdr() means the extension header chain cannot be
parsed; in both cases the transport header is not available, so keep the
addresses and protocol and do not log ports.

Both callers ignore the return value (net/netfilter/nft_log.c and
net/netfilter/xt_AUDIT.c), so make the helper return void instead of
inventing error codes for a value nobody consumes.

A packet whose network header cannot be read now logs:

  before: mark=0x0
  after:  mark=0x0 saddr=? daddr=? proto=-1

A TCP packet whose transport header cannot be read now logs:

  before: mark=0x0
  after:  mark=0x0 saddr=10.20.0.2 daddr=10.20.0.1 proto=6 sport=? dport=?

Fixes: f19590b07cb6 ("audit: add audit_log_nf_skb helper function")
Fixes: 15b0c43aa621 ("audit: include source and destination ports to NETFILTER_PKT")
Signed-off-by: JiangJieHua <jiangjiehua1@huawei.com>
---
 include/linux/audit.h |  12 ++---
 kernel/audit.c        | 114 ++++++++++++++++++++++--------------------
 2 files changed, 65 insertions(+), 61 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 767e349d4834..8263257a010e 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -197,8 +197,8 @@ extern int audit_log_subj_ctx(struct audit_buffer *ab, struct lsm_prop *prop);
 extern int audit_log_obj_ctx(struct audit_buffer *ab, struct lsm_prop *prop);
 extern int audit_log_task_context(struct audit_buffer *ab);
 extern void audit_log_task_info(struct audit_buffer *ab);
-extern int audit_log_nf_skb(struct audit_buffer *ab,
-			    const struct sk_buff *skb, u8 nfproto);
+extern void audit_log_nf_skb(struct audit_buffer *ab,
+			     const struct sk_buff *skb, u8 nfproto);
 
 extern int		    audit_update_lsm_rules(void);
 
@@ -276,11 +276,9 @@ static inline int audit_log_task_context(struct audit_buffer *ab)
 static inline void audit_log_task_info(struct audit_buffer *ab)
 { }
 
-static inline int audit_log_nf_skb(struct audit_buffer *ab,
-				   const struct sk_buff *skb, u8 nfproto)
-{
-	return 0;
-}
+static inline void audit_log_nf_skb(struct audit_buffer *ab,
+				    const struct sk_buff *skb, u8 nfproto)
+{ }
 
 static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
 {
diff --git a/kernel/audit.c b/kernel/audit.c
index 631d6d4a23cf..c5997077a46b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2511,8 +2511,8 @@ void audit_log_path_denied(int type, const char *operation)
 	audit_log_end(ab);
 }
 
-int audit_log_nf_skb(struct audit_buffer *ab,
-		     const struct sk_buff *skb, u8 nfproto)
+void audit_log_nf_skb(struct audit_buffer *ab,
+		      const struct sk_buff *skb, u8 nfproto)
 {
 	/* find the IP protocol in the case of NFPROTO_BRIDGE */
 	if (nfproto == NFPROTO_BRIDGE) {
@@ -2532,24 +2532,32 @@ int audit_log_nf_skb(struct audit_buffer *ab,
 	case NFPROTO_IPV4: {
 		struct iphdr iph;
 		const struct iphdr *ih;
+		int thoff;
+		bool frag;
 
 		ih = skb_header_pointer(skb, skb_network_offset(skb),
 					sizeof(iph), &iph);
 		if (!ih)
-			return -ENOMEM;
+			goto unknown_proto;
+		if (ih->version != 4 || ih->ihl < 5)
+			goto unknown_proto;
+
+		thoff = skb_network_offset(skb) + ih->ihl * 4;
+		frag = ntohs(ih->frag_off) & IP_OFFSET;
+
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
+				 &ih->saddr, &ih->daddr, ih->protocol);
 
 		switch (ih->protocol) {
 		case IPPROTO_TCP: {
 			struct tcphdr _tcph;
 			const struct tcphdr *th;
 
-			th = skb_header_pointer(skb, skb_transport_offset(skb),
-						sizeof(_tcph), &_tcph);
-			if (!th)
-				return -ENOMEM;
-
-			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
-					 &ih->saddr, &ih->daddr, ih->protocol,
+			th = skb_header_pointer(skb, thoff, sizeof(_tcph),
+						&_tcph);
+			if (frag || !th)
+				goto unknown_ports;
+			audit_log_format(ab, " sport=%hu dport=%hu",
 					 ntohs(th->source), ntohs(th->dest));
 			break;
 		}
@@ -2558,13 +2566,11 @@ int audit_log_nf_skb(struct audit_buffer *ab,
 			struct udphdr _udph;
 			const struct udphdr *uh;
 
-			uh = skb_header_pointer(skb, skb_transport_offset(skb),
-						sizeof(_udph), &_udph);
-			if (!uh)
-				return -ENOMEM;
-
-			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
-					 &ih->saddr, &ih->daddr, ih->protocol,
+			uh = skb_header_pointer(skb, thoff, sizeof(_udph),
+						&_udph);
+			if (frag || !uh)
+				goto unknown_ports;
+			audit_log_format(ab, " sport=%hu dport=%hu",
 					 ntohs(uh->source), ntohs(uh->dest));
 			break;
 		}
@@ -2572,19 +2578,14 @@ int audit_log_nf_skb(struct audit_buffer *ab,
 			struct sctphdr _sctph;
 			const struct sctphdr *sh;
 
-			sh = skb_header_pointer(skb, skb_transport_offset(skb),
-						sizeof(_sctph), &_sctph);
-			if (!sh)
-				return -ENOMEM;
-
-			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
-					 &ih->saddr, &ih->daddr, ih->protocol,
+			sh = skb_header_pointer(skb, thoff, sizeof(_sctph),
+						&_sctph);
+			if (frag || !sh)
+				goto unknown_ports;
+			audit_log_format(ab, " sport=%hu dport=%hu",
 					 ntohs(sh->source), ntohs(sh->dest));
 			break;
 		}
-		default:
-			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
-					 &ih->saddr, &ih->daddr, ih->protocol);
 		}
 
 		break;
@@ -2594,28 +2595,36 @@ int audit_log_nf_skb(struct audit_buffer *ab,
 		const struct ipv6hdr *ih;
 		u8 nexthdr;
 		__be16 frag_off;
+		int thoff;
 
 		ih = skb_header_pointer(skb, skb_network_offset(skb),
 					sizeof(iph), &iph);
 		if (!ih)
-			return -ENOMEM;
+			goto unknown_proto;
+		if (ih->version != 6)
+			goto unknown_proto;
 
 		nexthdr = ih->nexthdr;
-		ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(iph),
-				 &nexthdr, &frag_off);
+		thoff = ipv6_skip_exthdr(skb,
+					 skb_network_offset(skb) + sizeof(iph),
+					 &nexthdr, &frag_off);
+
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
+				 &ih->saddr, &ih->daddr, nexthdr);
+
+		if (thoff < 0)
+			break;
 
 		switch (nexthdr) {
 		case IPPROTO_TCP: {
 			struct tcphdr _tcph;
 			const struct tcphdr *th;
 
-			th = skb_header_pointer(skb, skb_transport_offset(skb),
-						sizeof(_tcph), &_tcph);
+			th = skb_header_pointer(skb, thoff, sizeof(_tcph),
+						&_tcph);
 			if (!th)
-				return -ENOMEM;
-
-			audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
-					 &ih->saddr, &ih->daddr, nexthdr,
+				goto unknown_ports;
+			audit_log_format(ab, " sport=%hu dport=%hu",
 					 ntohs(th->source), ntohs(th->dest));
 			break;
 		}
@@ -2624,13 +2633,11 @@ int audit_log_nf_skb(struct audit_buffer *ab,
 			struct udphdr _udph;
 			const struct udphdr *uh;
 
-			uh = skb_header_pointer(skb, skb_transport_offset(skb),
-						sizeof(_udph), &_udph);
+			uh = skb_header_pointer(skb, thoff, sizeof(_udph),
+						&_udph);
 			if (!uh)
-				return -ENOMEM;
-
-			audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
-					 &ih->saddr, &ih->daddr, nexthdr,
+				goto unknown_ports;
+			audit_log_format(ab, " sport=%hu dport=%hu",
 					 ntohs(uh->source), ntohs(uh->dest));
 			break;
 		}
@@ -2638,19 +2645,14 @@ int audit_log_nf_skb(struct audit_buffer *ab,
 			struct sctphdr _sctph;
 			const struct sctphdr *sh;
 
-			sh = skb_header_pointer(skb, skb_transport_offset(skb),
-						sizeof(_sctph), &_sctph);
+			sh = skb_header_pointer(skb, thoff, sizeof(_sctph),
+						&_sctph);
 			if (!sh)
-				return -ENOMEM;
-
-			audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
-					 &ih->saddr, &ih->daddr, nexthdr,
+				goto unknown_ports;
+			audit_log_format(ab, " sport=%hu dport=%hu",
 					 ntohs(sh->source), ntohs(sh->dest));
 			break;
 		}
-		default:
-			audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
-					 &ih->saddr, &ih->daddr, nexthdr);
 		}
 
 		break;
@@ -2659,11 +2661,15 @@ int audit_log_nf_skb(struct audit_buffer *ab,
 		goto unknown_proto;
 	}
 
-	return 0;
+	return;
+
+unknown_ports:
+	audit_log_format(ab, " sport=? dport=?");
+	return;
 
 unknown_proto:
-	audit_log_format(ab, " saddr=? daddr=? proto=?");
-	return -EPFNOSUPPORT;
+	audit_log_format(ab, " saddr=? daddr=? proto=-1");
+	return;
 }
 EXPORT_SYMBOL(audit_log_nf_skb);
 
-- 
2.33.8

