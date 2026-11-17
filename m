Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931159;
	b=auSBZebpUZ0N2Z+Wf22iDPk9GsUdXCYgQfEgt4UnrDwB/SeFeFrWerbik29y5Ums1jUg
	 +88ZGgnHWTRoyf5O08o0koR1X5saqag2ZnnR1tTZtUifzSIKCKa6AVgbkW73UJaa/8vHz
	 wHx1d35qbHYeRBTp9ZQ+58fL7AhmGveOrJYSuiYVvvcGajKCW5Po53cjFbl+XYW2hfWp7
	 qfvu9lVSQdTRLq/nZQ/j5vfq2PbNS6/y/L0E7p0j7w6nAFv468f6wLfrsw5Jh1p7C7AfQ
	 xDdVrwGfynKWEYt49trHwnBfLa7PIs97f8JyPAP8HyMN031BceLEEKSISv0SBPSn31w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931159;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=tHEw5Su7v4bGBj8B87/CZb0lfkXXIwLfC4ZeQTBg4X0=;
	b=cfKwPaGRXkqVfAnUc/Cm0nhlvXAysXixCHcD6YAugWxTqfTusFOsfXujaNFDiM1yeUhX
	 4TQLr/QWZu0OR69hHbPwUmw2NzczzQXRtpWvucMQidsEPINcF8iPDNouFIPwa7hT0DKri
	 d+qO3W4nrrT3W+5wcIf8sdiRtUJWqRXawVqG+BqdcOAzhWlE1ZcqUQ3VlkV8UYNBvXxrC
	 cWKrGbYWSRawN2FS+wdEtARiaJ7ba6U8SedVsKUwEc8SrMGbIdS0oGxaMAeswz9CqtyIU
	 zlVCj2FeTj2TtQ4zcd9JFfhFtEGFyIZ+g4Wegz3flfSdLhiOX+CPCS0ofApmpkUGfaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24967606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 15:59:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24967606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4938560342; Tue, 17 Nov 2026 16:59:17 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnetfilter_log 1/2] utils: nfulnl_test: print NFULA_HWTYPE/HWLEN/HWHEADER
Date: Tue, 17 Nov 2026 16:58:59 +0100
Message-ID: <20261117155900.31418-2-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117155900.31418-1-fw@strlen.de>
References: <20261117155900.31418-1-fw@strlen.de>
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

print_pkt() only read NFULA_PACKET_HDR and NFULA_HWADDR.

Extend this to include NFULA_HWTYPE/NFULA_HWLEN/NFULA_HWHEADER
and fix up the existing test case to expect the new output.

While at it, also print the bridge port, if any, so that future
test cases can check for their presence.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 utils/nfulnl_test.c  | 26 ++++++++++++++++++++++++++
 utils/nfulnl_test.sh |  4 ++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/utils/nfulnl_test.c b/utils/nfulnl_test.c
index 840c0bea3a86..b6427957e01b 100644
--- a/utils/nfulnl_test.c
+++ b/utils/nfulnl_test.c
@@ -11,9 +11,11 @@ static int print_pkt(struct nflog_data *nfad)
 	uint32_t outdev, indev, hw_addrlen;
 	struct nfulnl_msg_packet_hdr *ph;
 	struct nfulnl_msg_packet_hw *hw;
+	uint16_t hwhdrlen;
 	int payload_len;
 	char *payload;
 	char *prefix;
+	char *hwhdr;
 	int i;
 
 	ph = nflog_get_msg_packet_hdr(nfad);
@@ -34,16 +36,40 @@ static int print_pkt(struct nflog_data *nfad)
 		printf("%02x ", hw->hw_addr[hw_addrlen - 1]);
 	}
 
+	/* NFULA_HWTYPE/NFULA_HWLEN/NFULA_HWHEADER: emitted by
+	 * nfulnl_put_hwheader() in the kernel, independently of
+	 * NFULA_HWADDR above. Only printed when the kernel decided the
+	 * hook is on indev's input path (see nfulnl_pre_egress()); a
+	 * missing hw_header= token is how a test asserts that exclusion.
+	 */
+	hwhdr = nflog_get_msg_packet_hwhdr(nfad);
+	if (hwhdr) {
+		hwhdrlen = nflog_get_msg_packet_hwhdrlen(nfad);
+
+		printf("hw_type=0x%04x hw_hdrlen=%u hw_header=",
+			nflog_get_hwtype(nfad), hwhdrlen);
+		for (i = 0; i < hwhdrlen; i++)
+			printf("%02x", (unsigned char)hwhdr[i]);
+		printf(" ");
+	}
+
 	printf("mark=%u ", nflog_get_nfmark(nfad));
 
 	indev = nflog_get_indev(nfad);
 	if (indev > 0)
 		printf("indev=%u ", indev);
 
+	indev = nflog_get_physindev(nfad);
+	if (indev > 0)
+		printf("physindev=%u ", indev);
+
 	outdev = nflog_get_outdev(nfad);
 	if (outdev > 0)
 		printf("outdev=%u ", outdev);
 
+	outdev = nflog_get_physoutdev(nfad);
+	if (outdev > 0)
+		printf("physoutdev=%u ", outdev);
 
 	prefix = nflog_get_prefix(nfad);
 	if (prefix)
diff --git a/utils/nfulnl_test.sh b/utils/nfulnl_test.sh
index b23ccab04bae..d97f82a366ab 100755
--- a/utils/nfulnl_test.sh
+++ b/utils/nfulnl_test.sh
@@ -49,8 +49,8 @@ ping6 -q -c "$PING_COUNT" ::1 > /dev/null
 wait
 
 set +e
-cnt4=$(grep -c '^hw_protocol=0x0800 hook=0 hw_addrlen=6 hw_addr=00:00:00:00:00:00 mark=0 indev=1 prefix="test icmp " payload_len=84' "$out")
-cnt6=$(grep -c '^hw_protocol=0x86dd hook=0 hw_addrlen=6 hw_addr=00:00:00:00:00:00 mark=0 indev=1 prefix="test icmp6 " payload_len=104' "$out")
+cnt4=$(grep -c '^hw_protocol=0x0800 hook=0 hw_addrlen=6 hw_addr=00:00:00:00:00:00 hw_type=0x0304 hw_hdrlen=14 hw_header=0000000000000000000000000800 mark=0 indev=1 prefix="test icmp " payload_len=84' "$out")
+cnt6=$(grep -c '^hw_protocol=0x86dd hook=0 hw_addrlen=6 hw_addr=00:00:00:00:00:00 hw_type=0x0304 hw_hdrlen=14 hw_header=00000000000000000000000086dd mark=0 indev=1 prefix="test icmp6 " payload_len=104' "$out")
 
 [ "$cnt4" -ne 4 ] && die "Expected 2 counts each for ipv4 and ipv6, got $cnt4, $cnt6"
 [ "$cnt6" -ne 4 ] && die "Expected 2 counts each for ipv4 and ipv6, got $cnt4, $cnt6"
-- 
2.56.1

