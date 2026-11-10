Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.186
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794325926;
	b=z7nVhHsORaU/ExJkDaZ/iFy4C78PNFhochyppv1NQ3CLfktbDAA0GhdFASm7icm7x9WT
	 2CvvE2dlNnaomNXW6vcN1zlg9DRapNt9t6C+tmhj2ziNqJ7yKQigrDvpwzjDcxn0bYVGx
	 qTuCuYAo+RKO52nlJoNPGxclMDNI8oKyByt/PFL6Z/G9eK7L04UsBTLcgrt7VUIbazSay
	 /B7Yys0PlPaZqMLn5GfSbxIZD0S2quVJHQmYmBBC6EJcdHipQyj9520G3kJcFOuui91ys
	 iv2MPAAuR2BIZEk2o+E/Af11lTf8OgPoM8/JQjPMNt80CNxPFCnVqyNFKFe5OQl/j0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794325926;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:CC:Subject:In-Reply-To:
	 Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zrMcVk/FXBVd+TGYXJcrqn9TJIqgyPhhxmNRvtTxdwY=;
	b=0zYnNFkdGhgrRtnPkh1PB7wLbJbg2DjQIP+8KJdcuW+bF8XUPLS1phqbV3Yu/lOMigTn
	 Mg6ilo3vJXpw+zzQFAkgTde8CTFKE83WRZjwenAiLSRdssUvbQ38lyGMvRoyXWDypCAYA
	 CDZkMYGbnrysm15j6gxavIqVK24DdjrVUS2Sxxk6yVr2MZUT4LTAkvml6xwzmW0xRTi4f
	 5hq2Jefm91C1W6SPb0ceWQONNRprEPus5LWfbsHNM2UfWjNy4LERmpFoFWb6INXhY9V20
	 l4Fg3Qahxk1HAPTqpFIfBv1WykCmBlipPgrZ7y8eM3svBREvyStt+xsp/s/yikrV8nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="LAO6VCj/";
	arc=none smtp.remote-ip=95.215.58.186
Received: from mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E3B606A320
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 15:52:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87E3B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LAO6VCj/
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=I48YjLcxJvx4CWukts+x9dGdBS0QAfV6VzkLdQtjevU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794325923; v=1; x=1794930723;
 b=LAO6VCj/jP97doJQdG9N7nDKXV86mxjgXAenEhMMC4DEMioHzogsAR3u4dnk7G+xT/vASlEn
 8H0KwD//3y7rPZOujqEXkoyxyVbiEaozExAGmmv8kSVpAhvr8eoF1QA5LvgFAAEqdNqWMTUylEu
 XUClkzHN2xVrI8jjGczIs2Mo=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9b44e70281ab94c0;
	Tue, 10 Nov 2026 15:52:03 +0000
X-Mizu-Trace-ID: 9b44e70281ab94c0
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 15:51:58 +0000
From: Bradley Morgan <bradley.morgan@linux.dev>
To: jiangjiehua1@huawei.com
CC: audit@vger.kernel.org, coreteam@netfilter.org, eparis@redhat.com,
 fw@strlen.de, linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org, paul@paul-moore.com, rrobaina@redhat.com,
 zhangchangzhong@huawei.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_audit=3A_fix_incomplete_N?=
 =?US-ASCII?Q?ETFILTER=5FPKT_records_and_return_void?=
In-Reply-To: <20261110122939.45373-1-jiangjiehua1@huawei.com>
Message-ID: <F79DD66E-99AE-44E0-87A3-E7B2FE704290@linux.dev>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 10 November 2026 12:29:39 GMT, JiangJieHua <jiangjiehua1@huawei.com>
wrote:
>Commit f19590b07cb6 ("audit: add audit_log_nf_skb helper function") and
>commit 15b0c43aa621 ("audit: include source and destination ports to
>NETFILTER_PKT") introduced audit_log_nf_skb() and its transport header
>parsing.
>
>The helper returned early with -ENOMEM when skb_header_pointer() failed
>for
>the network header, and the later port parsing did the same for the
>transport header.  Such an early return skips the remaining fields, so the
>NETFILTER_PKT record is emitted with only "mark=" and without the address
>and protocol fields.
>
>Log the address and protocol once the network header is available, and
>route the error paths through placeholder logging: a missing network
>header
>logs "saddr=? daddr=? proto=-1", as the pre-refactoring callers did, and a
>transport header that cannot be read where one is expected logs
>"sport=? dport=?".  The same "proto=-1" placeholder is used for an
>unknown bridge ethertype and an unknown nfproto, which previously printed
>"proto=?".
>
>Validate the IP version and the IPv4 header length, since bridge packets
>can reach the audit hook without the receive path validating them.  Locate
>the transport header from the network header instead of relying on
>skb_transport_offset(), which is not guaranteed to point at the transport
>header.  For IPv4, a non-first fragment or an unreadable transport header
>logs unknown ports; protocols without ports are unaffected.  For IPv6, a
>non-first fragment leaves proto at IPPROTO_FRAGMENT (44) and a negative
>offset from ipv6_skip_exthdr() means the extension header chain cannot be
>parsed; in both cases the transport header is not available, so keep the
>addresses and protocol and do not log ports.
>
>Both callers ignore the return value (net/netfilter/nft_log.c and
>net/netfilter/xt_AUDIT.c), so make the helper return void instead of
>inventing error codes for a value nobody consumes.
>
>A packet whose network header cannot be read now logs:
>
>  before: mark=0x0
>  after:  mark=0x0 saddr=? daddr=? proto=-1
>
>A TCP packet whose transport header cannot be read now logs:
>
>  before: mark=0x0
>  after:  mark=0x0 saddr=10.20.0.2 daddr=10.20.0.1 proto=6 sport=? dport=?
>
>Fixes: f19590b07cb6 ("audit: add audit_log_nf_skb helper function")
>Fixes: 15b0c43aa621 ("audit: include source and destination ports to NETFILTER_PKT")

This code looks very, very confusing. :(

>Signed-off-by: JiangJieHua <jiangjiehua1@huawei.com>
>---
> include/linux/audit.h |  12 ++---
> kernel/audit.c        | 114 ++++++++++++++++++++++--------------------
> 2 files changed, 65 insertions(+), 61 deletions(-)
>
>diff --git a/include/linux/audit.h b/include/linux/audit.h
>index 767e349d4834..8263257a010e 100644
>--- a/include/linux/audit.h
>+++ b/include/linux/audit.h
>@@ -197,8 +197,8 @@ extern int audit_log_subj_ctx(struct audit_buffer *ab, struct lsm_prop *prop);
> extern int audit_log_obj_ctx(struct audit_buffer *ab, struct lsm_prop
> *prop);
> extern int audit_log_task_context(struct audit_buffer *ab);
> extern void audit_log_task_info(struct audit_buffer *ab);
>-extern int audit_log_nf_skb(struct audit_buffer *ab,
>-			    const struct sk_buff *skb, u8 nfproto);
>+extern void audit_log_nf_skb(struct audit_buffer *ab,
>+			     const struct sk_buff *skb, u8 nfproto);
> 
> extern int		    audit_update_lsm_rules(void);
> 
>@@ -276,11 +276,9 @@ static inline int audit_log_task_context(struct audit_buffer *ab)
> static inline void audit_log_task_info(struct audit_buffer *ab)
> { }
> 
>-static inline int audit_log_nf_skb(struct audit_buffer *ab,
>-				   const struct sk_buff *skb, u8 nfproto)
>-{
>-	return 0;
>-}
>+static inline void audit_log_nf_skb(struct audit_buffer *ab,
>+				    const struct sk_buff *skb, u8 nfproto)
>+{ }
> 
> static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
> {
>diff --git a/kernel/audit.c b/kernel/audit.c
>index 631d6d4a23cf..c5997077a46b 100644
>--- a/kernel/audit.c
>+++ b/kernel/audit.c
>@@ -2511,8 +2511,8 @@ void audit_log_path_denied(int type, const char *operation)
> 	audit_log_end(ab);
> }
> 
>-int audit_log_nf_skb(struct audit_buffer *ab,
>-		     const struct sk_buff *skb, u8 nfproto)
>+void audit_log_nf_skb(struct audit_buffer *ab,
>+		      const struct sk_buff *skb, u8 nfproto)
> {
> 	/* find the IP protocol in the case of NFPROTO_BRIDGE */
> 	if (nfproto == NFPROTO_BRIDGE) {
>@@ -2532,24 +2532,32 @@ int audit_log_nf_skb(struct audit_buffer *ab,
> 	case NFPROTO_IPV4: {
> 		struct iphdr iph;
> 		const struct iphdr *ih;
>+		int thoff;
>+		bool frag;
> 
> 		ih = skb_header_pointer(skb, skb_network_offset(skb),
> 					sizeof(iph), &iph);
> 		if (!ih)
>-			return -ENOMEM;
>+			goto unknown_proto;
>+		if (ih->version != 4 || ih->ihl < 5)
>+			goto unknown_proto;
>+
>+		thoff = skb_network_offset(skb) + ih->ihl * 4;
>+		frag = ntohs(ih->frag_off) & IP_OFFSET;
>+
>+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
>+				 &ih->saddr, &ih->daddr, ih->protocol);
> 
> 		switch (ih->protocol) {
> 		case IPPROTO_TCP: {
> 			struct tcphdr _tcph;
> 			const struct tcphdr *th;
> 
>-			th = skb_header_pointer(skb, skb_transport_offset(skb),
>-						sizeof(_tcph), &_tcph);
>-			if (!th)
>-				return -ENOMEM;
>-
>-			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
>-					 &ih->saddr, &ih->daddr, ih->protocol,
>+			th = skb_header_pointer(skb, thoff, sizeof(_tcph),
>+						&_tcph);
>+			if (frag || !th)
>+				goto unknown_ports;
>+			audit_log_format(ab, " sport=%hu dport=%hu",
> 					 ntohs(th->source), ntohs(th->dest));
> 			break;
> 		}
>@@ -2558,13 +2566,11 @@ int audit_log_nf_skb(struct audit_buffer *ab,
> 			struct udphdr _udph;
> 			const struct udphdr *uh;
> 
>-			uh = skb_header_pointer(skb, skb_transport_offset(skb),
>-						sizeof(_udph), &_udph);
>-			if (!uh)
>-				return -ENOMEM;
>-
>-			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
>-					 &ih->saddr, &ih->daddr, ih->protocol,
>+			uh = skb_header_pointer(skb, thoff, sizeof(_udph),
>+						&_udph);
>+			if (frag || !uh)
>+				goto unknown_ports;
>+			audit_log_format(ab, " sport=%hu dport=%hu",
> 					 ntohs(uh->source), ntohs(uh->dest));
> 			break;
> 		}
>@@ -2572,19 +2578,14 @@ int audit_log_nf_skb(struct audit_buffer *ab,
> 			struct sctphdr _sctph;
> 			const struct sctphdr *sh;
> 
>-			sh = skb_header_pointer(skb, skb_transport_offset(skb),
>-						sizeof(_sctph), &_sctph);
>-			if (!sh)
>-				return -ENOMEM;
>-
>-			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
>-					 &ih->saddr, &ih->daddr, ih->protocol,
>+			sh = skb_header_pointer(skb, thoff, sizeof(_sctph),
>+						&_sctph);
>+			if (frag || !sh)
>+				goto unknown_ports;
>+			audit_log_format(ab, " sport=%hu dport=%hu",
> 					 ntohs(sh->source), ntohs(sh->dest));
> 			break;
> 		}
>-		default:
>-			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
>-					 &ih->saddr, &ih->daddr, ih->protocol);
> 		}
> 
> 		break;
>@@ -2594,28 +2595,36 @@ int audit_log_nf_skb(struct audit_buffer *ab,
> 		const struct ipv6hdr *ih;
> 		u8 nexthdr;
> 		__be16 frag_off;
>+		int thoff;
> 
> 		ih = skb_header_pointer(skb, skb_network_offset(skb),
> 					sizeof(iph), &iph);
> 		if (!ih)
>-			return -ENOMEM;
>+			goto unknown_proto;
>+		if (ih->version != 6)
>+			goto unknown_proto;
> 
> 		nexthdr = ih->nexthdr;
>-		ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(iph),
>-				 &nexthdr, &frag_off);
>+		thoff = ipv6_skip_exthdr(skb,
>+					 skb_network_offset(skb) + sizeof(iph),
>+					 &nexthdr, &frag_off);
>+
>+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
>+				 &ih->saddr, &ih->daddr, nexthdr);
>+
>+		if (thoff < 0)
>+			break;
> 
> 		switch (nexthdr) {
> 		case IPPROTO_TCP: {
> 			struct tcphdr _tcph;
> 			const struct tcphdr *th;
> 
>-			th = skb_header_pointer(skb, skb_transport_offset(skb),
>-						sizeof(_tcph), &_tcph);
>+			th = skb_header_pointer(skb, thoff, sizeof(_tcph),
>+						&_tcph);
> 			if (!th)
>-				return -ENOMEM;
>-
>-			audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
>-					 &ih->saddr, &ih->daddr, nexthdr,
>+				goto unknown_ports;
>+			audit_log_format(ab, " sport=%hu dport=%hu",
> 					 ntohs(th->source), ntohs(th->dest));
> 			break;
> 		}
>@@ -2624,13 +2633,11 @@ int audit_log_nf_skb(struct audit_buffer *ab,
> 			struct udphdr _udph;
> 			const struct udphdr *uh;
> 
>-			uh = skb_header_pointer(skb, skb_transport_offset(skb),
>-						sizeof(_udph), &_udph);
>+			uh = skb_header_pointer(skb, thoff, sizeof(_udph),
>+						&_udph);
> 			if (!uh)
>-				return -ENOMEM;
>-
>-			audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
>-					 &ih->saddr, &ih->daddr, nexthdr,
>+				goto unknown_ports;
>+			audit_log_format(ab, " sport=%hu dport=%hu",
> 					 ntohs(uh->source), ntohs(uh->dest));
> 			break;
> 		}
>@@ -2638,19 +2645,14 @@ int audit_log_nf_skb(struct audit_buffer *ab,
> 			struct sctphdr _sctph;
> 			const struct sctphdr *sh;
> 
>-			sh = skb_header_pointer(skb, skb_transport_offset(skb),
>-						sizeof(_sctph), &_sctph);
>+			sh = skb_header_pointer(skb, thoff, sizeof(_sctph),
>+						&_sctph);
> 			if (!sh)
>-				return -ENOMEM;
>-
>-			audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
>-					 &ih->saddr, &ih->daddr, nexthdr,
>+				goto unknown_ports;
>+			audit_log_format(ab, " sport=%hu dport=%hu",
> 					 ntohs(sh->source), ntohs(sh->dest));
> 			break;
> 		}
>-		default:
>-			audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
>-					 &ih->saddr, &ih->daddr, nexthdr);
> 		}
> 
> 		break;
>@@ -2659,11 +2661,15 @@ int audit_log_nf_skb(struct audit_buffer *ab,
> 		goto unknown_proto;
> 	}
> 
>-	return 0;
>+	return;
>+
>+unknown_ports:
>+	audit_log_format(ab, " sport=? dport=?");
>+	return;
> 
> unknown_proto:
>-	audit_log_format(ab, " saddr=? daddr=? proto=?");
>-	return -EPFNOSUPPORT;
>+	audit_log_format(ab, " saddr=? daddr=? proto=-1");
>+	return;
> }
> EXPORT_SYMBOL(audit_log_nf_skb);
> 
>

--- Thanks!
