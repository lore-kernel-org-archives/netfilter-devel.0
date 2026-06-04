Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD75290DBB
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 21:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780607827; cv=none; b=EuFf2o9pfMJpvscxV8u88aQcjJ8gzJhjgTuNKEHEK5BD39CvUEtCN5wcOctxCLuxyai1hByqKQ4hcRHevYBolJXAqSSJ5h/1NbUrWIuJMpqT9FYJxtdH3O1HOWTQjt+NsziOtTUw4mjrMErLoGfYblbPDIP7fF8Ju1ZMu1qznog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780607827; c=relaxed/simple;
	bh=ogzrR6LV1xZ3nyFISn+K7srY+QpjdnUYclMzfhAWNBw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cb+E2gZkxxPFStz2Mo4nKsEZRAbQ53J1H0ukQfX1d41sfOVeL2DPvXfw0GYHcLRDpZ5LiRQeMkdKgUdvEleXgP9M9P7BdeFPev8NsoMrawcQcFij8Lm3BjMrfHwLcp9RSDjGMNfZggYcRkx+K1nh89fWUGqVInJbyZx5kw5IHMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VV9EbUQN; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VV9EbUQN"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45fe59255beso586256f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jun 2026 14:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780607824; x=1781212624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LXDzTwMPrVvi+xD5DF5VhAM609VqNufzmDRRbJGGLI4=;
        b=VV9EbUQN8UGq4DJsBRHbR7vrJJvspcpSasHcPkiuZaBGUnJqTogvwItG5do4lM7nSb
         t49q+8T9Qs67lNN+j+IRS5+dWQID8z7znv/FxL5kQ1yeW42RdCYoUkHqVeSEGdffgTJl
         6UnFA3R/ko3ShMQC2SNTchBR26WmrTPReGnEdbAEMlrOHj5z1gNq8b6Ep2AERE6hAPmp
         KpW7I6V8pj5CABeqae2y0JOGUnaLVz4v8iRWg500GGCCD02G9tHdm9Hda8SLrdHKbeXo
         zA2x8yw7duThACHbr1DHxvy5LywaetXeoR4ZiV/+l0/6JPFHcbCAiU2/LvD5B80iutTI
         WNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780607824; x=1781212624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXDzTwMPrVvi+xD5DF5VhAM609VqNufzmDRRbJGGLI4=;
        b=DhD2GQLD3t0a2UH6AaJ9hMM33fel1Q+YFXAg6xq1U96NH9c7hyHZAexBl5J0Vbk2VK
         eqLpiH7naImNym677EVJvWHb8ugyrP0FPQK+At+1gYBReNo5DjnxbURnbGEhirxsdK0E
         2fXxAHbOdRMGpYkxhQxly2758u23Y71QMfrpJA2zwDpAyAQ3F/1M0Nt2kyfOckhkIAWF
         yTIWs59/gQOicPmIDsGeO8RTYimKv6hi2KU+6TAjD35yAkOdbwwVXd0+702pKtHLr3ct
         OIYzVtQkvo9QT8Z+HKXCSXdvMOXIpEsf17w/cSRSKiADCuVIG95zQrt5eqeLzjmoJAw/
         dLkA==
X-Gm-Message-State: AOJu0YypeQ8AbU15m3gCOBSgbH2dY7klMFMr5g/Z1mtpNVMuq9WUiUgR
	DCy5jsvql5jib4mZJvlTfAZuFkEFrEw4rE6cGyGUKM2vekr9nsmcL5prQihXtyY9Q4o=
X-Gm-Gg: Acq92OHzg6gy1Mv2dWjoVFNqJZ4xTejAPnkISBtT1bfuOI8pjcOilG5x01zGHHIX9in
	bjDPKC7+tEhf2lGjeBvlSCm01i9Bnv8chCpCFeQTWXe13W7emRBf6EIZUKAeIIWe2s/CSBrZlrC
	e4tqj316FhHunSHSiNUmDtmEMRtKHPa4hNeUXJEVoa/SqgAEdR89f30rat3xVd8nFEU9x/c7HVK
	Qq73zasdHV1U+HFezWq6M6TrAQ1pUDk3nePYztDQuaajE4dp3endlfHVpgxVSebpaBe4zXbllpW
	85AarquG3/qdODDezHEZNvaUaNOlKlJKAc66ik6Z273dYz+N4lWKglLzkQpgdcayBu2ZpQ4HnVG
	ZhXCuClEvAQCQFjgvfntT8t2RgxL8MXddQbn3bmpwZXptR+YtMSZTi1DuDSjzASQ2v1cNiCPGMA
	4Vu0Bc2To0neQpNq0c9OFJfJtZbKK6wn0M117WrEgbpirzYCiGT7qhzECamiz5jjSd2ne5uwhF+
	h2WZgn9QefqM/1n7Zi3Iw==
X-Received: by 2002:a05:6000:298e:10b0:45e:93ac:769e with SMTP id ffacd0b85a97d-460302dc502mr831402f8f.6.1780607823824;
        Thu, 04 Jun 2026 14:17:03 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2e4004sm19743833f8f.9.2026.06.04.14.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 14:17:03 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	coreteam@netfilter.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH nf] netfilter: flowtable: fix IP6IP6 tunnel offset double-count with vlan/pppoe encap
Date: Thu,  4 Jun 2026 22:17:00 +0100
Message-ID: <20260604211700.253946-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_flow_ip6_tunnel_proto() stores the return value of ipv6_skip_exthdr()
directly into ctx->tun.hdr_size and then does ctx->offset +=
ctx->tun.hdr_size.

ipv6_skip_exthdr() returns an offset measured from skb->data, i.e. its
result already includes the "sizeof(*ip6h) + ctx->offset" start argument.
So hdr_size ends up containing ctx->offset, and the subsequent
"ctx->offset += ctx->tun.hdr_size" counts the encap offset twice.

This is harmless for a bare IP6IP6 packet, where ctx->offset is 0 on
entry, which is why it has gone unnoticed. But nf_flow_skb_encap_protocol()
advances ctx->offset by VLAN_HLEN / PPPOE_SES_HLEN before the tunnel
parser runs, so for an IP6IP6 flow carried over vlan or pppoe both
ctx->offset and ctx->tun.hdr_size are off by the encap length:

  - nf_flow_tuple_ipv6() then reads the inner header at the wrong offset,
    the computed tuple no longer matches the flowtable entry, and the
    packet silently falls back to the slow path (IP6IP6 rx acceleration
    stops working);
  - on the forward path nf_flow_ip_tunnel_pop() would skb_pull() past the
    inner header.

The IPv4 sibling nf_flow_ip4_tunnel_proto() does this correctly: it stores
a relative header length (iph->ihl << 2) and adds that to ctx->offset.
Make the IPv6 path symmetric by storing the relative size.

Fixes: d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 net/netfilter/nf_flow_table_ip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9c05a50d6013..4c6a68765c6b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -366,7 +366,7 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 		return false;
 
 	if (nexthdr == IPPROTO_IPV6) {
-		ctx->tun.hdr_size = hdrlen;
+		ctx->tun.hdr_size = hdrlen - ctx->offset;
 		ctx->tun.proto = IPPROTO_IPV6;
 	}
 	ctx->offset += ctx->tun.hdr_size;
-- 
2.53.0

