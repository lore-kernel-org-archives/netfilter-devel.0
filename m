Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.243.164.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242863;
	b=y3Jy3PKMJaigDbS1F3QctLuZ6O9nvB56xTZEgVez2BtjmimKdo//7+ZsvRXFmysdp/ZH
	 h8SSMg2mOhNBX7IN+2ucKpq1FEevXSEmzlxlFBZNpHRS4qR4/KcEtcREfS5vSiAEG/9zw
	 OucOcZg1/us212ADsTp0Npx8QnSS+AqniV0VslE24XxnUKvb/LeXg2VcMNqOFDlHd8kE0
	 r+cH2zeq18/j7m0vrtOVNSMtXsPRDbBwRRwOFa3NEj0FGG0eVKYcPI6+1Sg5ujvUq4Zmv
	 haYHyJe/4flHiRU+P/xEtOdGWKBHETM+QGCWtJKTy4wKZS6AE0yi/gTWIcKAlvQRK1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242863;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=3Ei9UHe78HMDbjXsz6CvK1nZyKIgpWfVc4OAzUxUjyQ=;
	b=3oT9JLDwVEAiB6KhxBxtF5xJnaG2KFnnPVKXJVhDX0fJAAQ395OK6A3t/cI6EYxrEOoD
	 RplBid/ZizeW9AvctnbeJDXtJMVQgTe1pQIbQxsAa/HqZgSPYw4IWxdVLdWaQPs4WhJil
	 6BCn411rUVztRHDbxGPb2lrljG4d8hxk2wmDSWebT/MhynHwWQaIeqiakI3mDJmEebYRp
	 I32fuWkJ9g3P+yOQnQvCwalH6RLAmKGwLwP/NoTo82XQLFhzQU4s01JQzR1ykvNOkga3s
	 wHRK1dHuPl14hLfo7dCXHv0CVP9mz6q4ulRKU5Df0gQO/6Slp/JGVAeUEiYUxdrsf3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mails.tsinghua.edu.cn;
	spf=pass smtp.mailfrom=mails.tsinghua.edu.cn;
	dkim=pass header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.a=rsa-sha256 header.s=dkim header.b=E87Z9Uj7;
	arc=none smtp.remote-ip=162.243.164.118
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3EBD606A31C
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2026 16:47:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3EBD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.a=rsa-sha256 header.s=dkim header.b=E87Z9Uj7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-Id:MIME-Version:Content-Transfer-Encoding; bh=3Ei9U
	He78HMDbjXsz6CvK1nZyKIgpWfVc4OAzUxUjyQ=; b=E87Z9Uj72QLN+bMpjN9JD
	GDd/mO/RsIcW7uklvFMrsF23hWYsDNl0zGMARbN6yP1NHuXl8jLE5zwrCZN3xp04
	/WNeZbGtP9Naey8eOBXrbbJ6Q7fPX2djpGLX4GxcOEnlObB43Zlj/DtGiRIUmYs1
	jXufVqUy1UEqaDh1rrCsYc=
Received: from localhost.localdomain (unknown [202.112.47.69])
	by web2 (Coremail) with SMTP id yQQGZQAHMmYf+fFqwDUhAQ--.35224S2;
	Tue, 10 Nov 2026 00:47:27 +0800 (CST)
From: zhangmh25@mails.tsinghua.edu.cn
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	jianjun@tsinghua.edu.cn,
	Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
Subject: [PATCH nf-next v2] netfilter: nf_reject: validate TCP header length before sending resets
Date: Tue, 10 Nov 2026 00:47:26 +0800
Message-Id: <20261109164726.3868529-1-zhangmh25@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:yQQGZQAHMmYf+fFqwDUhAQ--.35224S2
X-Coremail-Antispam: 1UD129KBjvJXoW3AFyrCr43Cw4xJw4rZFyUGFg_yoWfXF1kpa
	y5J34fJ39rKryIyrn7AF48Xw1Syr1kGa13KF4rt3s3Kw15XF10gaySgFW2qas5Jw4fKryI
	qFWjvrW5C3WDXaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9a14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJV
	W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
	0VAGYxC7M4kE6xkIj40Ew7xC0wCY02Avz4vE14v_JwCF04k20xvY0x0EwIxGrwCFx2IqxV
	CFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r10
	6r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxV
	WUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG
	6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_Gr
	UvcSsGvfC2KfnxnUUI43ZEXa7VUUoa0JUUUUU==
X-CM-SenderInfo: x2kd0wlpkskqxpdlz2oowvx0pjkxthxhgxhubq/1tbiAgMGB2rxhqKoUQAAsG

From: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>

The TCP header validation in both nf_reject_ip_tcphdr_get() and
nf_reject_ip6_tcphdr_get() checks that the TCP segment is at least
sizeof(struct tcphdr) long, but does not verify that the header
length claimed via the data offset is actually present in the packet.
A peer can send a TCP packet claiming a 60-byte header although only
the fixed 20-byte header is present.

The reset generation then computes the ACK number using the claimed
header length, and the subtraction of the data offset from the TCP
segment length underflows, producing a wrapped ACK value in the
generated RST. For a 20-byte segment with doff = 15, ACK bit clear,
sequence number 0, SYN and FIN clear, the RST carries ack_seq
0xffffffd8 instead of a meaningful value.

Reject TCP headers whose data offset is smaller than the fixed header
or exceeds the TCP segment length, and derive that segment length
from the length declared in the IP header rather than from skb->len
(IPv6 packets with a zero payload_len keep the skb-length handling).
On the IPv4 and IPv6 receive paths the skb has already been trimmed
to the declared length by ip_rcv_core() / ip6_rcv_core(), but the
netdev ingress, inet ingress and bridge reject paths pass the
untrimmed frame, where skb->len still counts Ethernet padding and any
trailing bytes the sender appends. There, an skb->len based check
can still accept a data offset that runs past the IP-declared
segment, and the ACK
computation counts padding bytes that were never part of the segment.

For IPv4, use skb_ip_totlen() for both the data offset check and the
ACK computation: BIG TCP GSO packets carry tot_len == 0, and the
helper keeps the skb length for those. For IPv6, use payload_len
minus the extension header chain, and preserve the existing
skb-length handling when payload_len is zero (jumbograms and BIG TCP
aggregates). GRO aggregates keep working: inet_gro_complete() and
ipv6_gro_complete() update tot_len / payload_len to the aggregate
length, and aggregates past 64 KiB are covered by the zero-length
handling on both sides. The TCP checksum validation keeps its
existing skb-length basis and is unchanged; whether it rejects a
padded segment whose checksum was signed over the IP-declared length
depends on skb->ip_summed and the hook, exactly as before this
change.

With connection tracking enabled, segments with an inconsistent data
offset are already flagged by tcp_error() in nf_conntrack_proto_tcp.c
(th->doff*4 < sizeof(struct tcphdr) || tcplen < th->doff*4) on the
paths where conntrack runs before the reject rule, so rulesets with
an early "ct state invalid drop" rule never pass them to the reject
target. The netdev and inet ingress reject paths run before conntrack
and are not covered by that. The affected configurations are stateless
rulesets, netdev-family reject rules, and rulesets whose reject rule
is not preceded by an invalid-state drop.

Discovered through LLM-assisted static review and confirmed by manual
inspection and QEMU testing. Both reject paths were tested with
nftables "reject with tcp reset" rules: on both IPv4 and IPv6, a
probe with doff = 15 produced an RST with a wrapped ack_seq, and with
the fix no RST is generated for such packets while probes with
well-formed headers still get a correct RST. The untrimmed paths were
exercised through a netdev ingress reject rule: a probe whose doff =
15 only fits because of 40 appended trailing bytes still elicited an
RST with the skb->len based check and gets no RST with this change,
and a probe with otherwise well-formed TCP headers plus six bytes of
appended padding is now acknowledged exactly instead of by the padding
length on both families; on IPv4 this is the Ethernet minimum frame
size, while the IPv6 fixed headers alone already exceed that minimum,
so there the bytes are trailing data.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 764d8a9f2407 ("[NETFILTER]: Add IPv6 REJECT target")
Reported-by: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
Reported-by: Jianjun Chen <jianjun@tsinghua.edu.cn>
Link: https://lore.kernel.org/netdev/20261102155622.2658789-1-zhangmh25@mails.tsinghua.edu.cn/
Signed-off-by: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
---
Changes since v1:
- retarget to nf-next, as suggested by Pablo Neira Ayuso;
- rebase onto the current nf-next tree;
- derive the TCP segment length from the IP header instead of
  skb->len, for both the data offset check and the ACK computation,
  so Ethernet padding and trailing bytes on the untrimmed netdev
  ingress and bridge reject paths can no longer make an oversized
  data offset pass the check or skew the ACK (pointed out by the
  netdev AI review);
- use skb_ip_totlen() for the IPv4 length, so BIG TCP GSO packets
  with tot_len == 0 keep the skb-length behaviour;
- derive the IPv6 extension header length from the parser's own
  offset basis, so the calculation does not assume that the skb data
  starts at the network header;
- document the conntrack reachability limitation pointed out by
  Pablo Neira Ayuso;
- drop the stable Cc and target nf-next following maintainer
  feedback.
 net/ipv4/netfilter/nf_reject_ipv4.c | 20 +++++++++++++++++++-
 net/ipv6/netfilter/nf_reject_ipv6.c | 28 ++++++++++++++++++++++++----
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 7cb33af671e2..31c72b30bcf2 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -176,6 +176,7 @@ nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
 			struct tcphdr *_oth, int hook)
 {
 	const struct tcphdr *oth;
+	unsigned int tcplen;
 
 	/* IP header checks: fragment. */
 	if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
@@ -189,6 +190,22 @@ nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
 	if (oth == NULL)
 		return NULL;
 
+	/* Reject invalid or truncated TCP headers.  Use the length
+	 * declared in the IP header: the netdev ingress and bridge
+	 * reject paths see untrimmed skbs, where skb->len may include
+	 * Ethernet padding and trailing bytes past tot_len.
+	 * skb_ip_totlen() keeps the skb length for BIG TCP GSO
+	 * aggregates, which carry tot_len == 0.
+	 */
+	tcplen = skb_ip_totlen(oldskb);
+	if (tcplen < ip_hdrlen(oldskb) + sizeof(struct tcphdr))
+		return NULL;
+	tcplen -= ip_hdrlen(oldskb);
+
+	if (oth->doff < sizeof(struct tcphdr) / 4 ||
+	    tcplen < (oth->doff << 2))
+		return NULL;
+
 	/* No RST for RST. */
 	if (oth->rst)
 		return NULL;
@@ -240,7 +257,8 @@ static void nf_reject_ip_tcphdr_put(struct sk_buff *nskb, const struct sk_buff *
 		tcph->seq = oth->ack_seq;
 	} else {
 		tcph->ack_seq = htonl(ntohl(oth->seq) + oth->syn + oth->fin +
-				      oldskb->len - ip_hdrlen(oldskb) -
+				      skb_ip_totlen(oldskb) -
+				      ip_hdrlen(oldskb) -
 				      (oth->doff << 2));
 		tcph->ack = 1;
 	}
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5e08d8529cc8..634304d2ad4e 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -198,18 +198,33 @@ nf_reject_ip6_tcphdr_get(struct sk_buff *oldskb,
 	const struct ipv6hdr *oip6h = ipv6_hdr(oldskb);
 	u8 proto;
 	__be16 frag_off;
-	int tcphoff;
+	int tcphoff, start;
 
 	proto = oip6h->nexthdr;
-	tcphoff = ipv6_skip_exthdr(oldskb, ((u8 *)(oip6h + 1) - oldskb->data),
-				   &proto, &frag_off);
+	start = (u8 *)(oip6h + 1) - oldskb->data;
+	tcphoff = ipv6_skip_exthdr(oldskb, start, &proto, &frag_off);
 
 	if ((tcphoff < 0) || (tcphoff > oldskb->len)) {
 		pr_debug("Cannot get TCP header.\n");
 		return NULL;
 	}
 
-	*otcplen = oldskb->len - tcphoff;
+	/* Use the length declared in the IPv6 header: the netdev ingress
+	 * and bridge reject paths see untrimmed skbs, where skb->len may
+	 * include Ethernet padding and trailing bytes past payload_len.
+	 * Preserve the existing skb-length handling when payload_len is
+	 * zero.
+	 */
+	if (oip6h->payload_len) {
+		unsigned int ext_len = tcphoff - start;
+
+		if (ntohs(oip6h->payload_len) <
+		    ext_len + sizeof(struct tcphdr))
+			return NULL;
+		*otcplen = ntohs(oip6h->payload_len) - ext_len;
+	} else {
+		*otcplen = oldskb->len - tcphoff;
+	}
 
 	/* IP header checks: fragment, too short. */
 	if (proto != IPPROTO_TCP || *otcplen < sizeof(struct tcphdr)) {
@@ -223,6 +238,11 @@ nf_reject_ip6_tcphdr_get(struct sk_buff *oldskb,
 	if (otcph == NULL)
 		return NULL;
 
+	/* Reject invalid or truncated TCP headers. */
+	if (otcph->doff < sizeof(struct tcphdr) / 4 ||
+	    *otcplen < (otcph->doff << 2))
+		return NULL;
+
 	/* No RST for RST. */
 	if (otcph->rst) {
 		pr_debug("RST is set\n");
-- 
2.34.1

