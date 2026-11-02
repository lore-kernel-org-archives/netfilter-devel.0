Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.243.164.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793634991;
	b=x+N35isOe0p3zogQ+4kMEWaIRQktx5o2+yMCXihXyMyESqJP3A05r8jVrugdV3opu5fg
	 LHXbZN64KZYMLRDw+QaVOX7m3vi92SnkY+Zrjb9WqNDLpaug1p2pl3VgnA87tJlML14Fl
	 aST03Mk8JhicEd4tcFge+TX13iEp5pLD89LRN6r3UtxxvO9tDwjQ3TxdMC8XVR1gDzSqc
	 UtHarVg4RTlWf7v47792ym3B1xmNT9tgqFQGyKhVsCRe6tz6HnKqNDPzq8X+684m58iSB
	 gO+4SfJQb02LFMIiss6bDl8Mc32ZmuRNJJ4Ws0xulIu8P1plo7m7fvfrxmbpsdr/SGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634991;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=iw0A/6qXyey37hvqhs6dNwEmzIY1VT/a5QdELgvzmDg=;
	b=tD1mxxK+frvFjMLKdV3OA/Vglnl0JXERrHUTyR6zusID0Afm4LpN8C38SZQ688pRXQUT
	 94cjtezF1xibNOgNzeWdJ2SMSO5iwSieOJmHZLSdWeD6OPLg2mA1IoVPmA16Vn4g33efy
	 /ofCtoeKbpV5r7t0bNRg9HqT1xkBhW9WC+JynVXZK5woVAepSkO0yRBrOGNiYa3nK1SJ+
	 xr7RQy9QiKAkw1sHMbjn5+qGAf6HqtrvUYpVA6rqg4yAItlfX0GNIuk2L9YNL4AZj8/KQ
	 8cQ/vIEmthShAYTWGx3OXoK2yR5MHIolaa+XIG0HfPGCtx0cvjh0/aw83PTuPsnE06Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mails.tsinghua.edu.cn;
	spf=pass smtp.mailfrom=mails.tsinghua.edu.cn;
	dkim=pass header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.a=rsa-sha256 header.s=dkim header.b=nt59HVOC;
	arc=none smtp.remote-ip=162.243.164.118
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00DD606E032;
	Mon,  2 Nov 2026 15:56:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D00DD606E032
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.a=rsa-sha256 header.s=dkim header.b=nt59HVOC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-Id:MIME-Version:Content-Transfer-Encoding; bh=iw0A/
	6qXyey37hvqhs6dNwEmzIY1VT/a5QdELgvzmDg=; b=nt59HVOCF3BiLHluALOqA
	xJpjiVE366RtBkK6daL2Scdcmt1Ix1zqTymDxfZcL3FBna2EijoMjWcEHJpZSPOH
	qPaHFm2WVLUjZdGrRk5+qyJyp2BFYbBA3a//DClZ5djtaGxLhRW9aMiNou9D/bSk
	g32SIBfieyrKOr4zhymrlo=
Received: from localhost.localdomain (unknown [202.112.47.69])
	by web2 (Coremail) with SMTP id yQQGZQCHtGiosuhqKf0BAQ--.27816S2;
	Mon, 02 Nov 2026 23:56:24 +0800 (CST)
From: zhangmh25@mails.tsinghua.edu.cn
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	pablo@netfilter.org,
	coreteam@netfilter.org,
	stable@vger.kernel.org,
	zhangmh25@mails.tsinghua.edu.cn,
	jianjun@tsinghua.edu.cn
Subject: [PATCH net] netfilter: nf_reject: validate TCP header length before sending resets
Date: Mon,  2 Nov 2026 23:56:22 +0800
Message-Id: <20261102155622.2658789-1-zhangmh25@mails.tsinghua.edu.cn>
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
X-CM-TRANSID:yQQGZQCHtGiosuhqKf0BAQ--.27816S2
X-Coremail-Antispam: 1UD129KBjvJXoWxurW3Wr1xAr4fGryxXr1fJFb_yoW5AFy5pa
	47tw1xA39rKryjyFn7uF48JF1rWF4kGF47WFWFy3s3Kwn8Ja18KayS9ry7uayaya1xKF4f
	XFWjqw4jy3WDJFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBq14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_JF0_Jw1lc2xSY4AK67AK6ryrMxAIw2
	8IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4l
	x2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrw
	CI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI
	42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z2
	80aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjDDG7UUUUU==
X-CM-SenderInfo: x2kd0wlpkskqxpdlz2oowvx0pjkxthxhgxhubq/1tbiAgMTB2roVIJoagAAsD

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
or exceeds the available TCP segment length. This prevents generating
resets with an ACK number derived from an invalid TCP header length.

Found during a systematic audit of TCP header validation in the
netfilter reject paths. Tested in network namespaces with nftables
"reject with tcp reset" rules: on both IPv4 and IPv6, a probe with
doff = 15 produced an RST with a wrapped ack_seq; with the fix no
RST is generated for such packets, while probes with well-formed
headers still get a correct RST.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 764d8a9f2407 ("[NETFILTER]: Add IPv6 REJECT target")
Reported-by: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
Reported-by: Jianjun Chen <jianjun@tsinghua.edu.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 5 +++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 59ec465a9..0e8823a7d 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -189,6 +189,11 @@ nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
 	if (oth == NULL)
 		return NULL;
 
+	/* Reject invalid or truncated TCP headers. */
+	if (oth->doff < sizeof(struct tcphdr) / 4 ||
+	    oldskb->len - ip_hdrlen(oldskb) < (oth->doff << 2))
+		return NULL;
+
 	/* No RST for RST. */
 	if (oth->rst)
 		return NULL;
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 07cdaa10d..9dc112e50 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -223,6 +223,11 @@ nf_reject_ip6_tcphdr_get(struct sk_buff *oldskb,
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

