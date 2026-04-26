Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0FD23507C
	for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2026 14:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777214942; cv=none; b=Ko+qj0NJYK1DDi95y36k9g/WyZS3JuaTynt1LJc3CQ82ZG9icRuqiXCC2rRQ1AwwkVEVmEJYckFVk6/THWNKtxwORfSUwyx7J6SnN7FPO/f6ogC/zAI9tNCE+jGuvOxx+qWyMuGF08n4uTLqebbxXjvS+mFB0b/3boDVYMDx4GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777214942; c=relaxed/simple;
	bh=vsm/Vin6fhEHMK5Rg/gfXmdGW6NjOiPfcld3a7a7Zqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GJnWuwQLrcF90zBPGcHXWcu2NoqPkFOZIKCynJPEWo9KfDzaeDm+fxYhVtLHnZVClqkvAXmX+KlrhSAjZHKuWmZX4OelO3U0sNtJd6mY9dc4rNgT8cEcPaBaHXAB6Nkh9DmUkdiytlo7PikI6CQzjSZvnm44nMd+9gri/KLTIkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NenE3BRc; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NenE3BRc"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8acae26e564so113142676d6.2
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2026 07:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777214941; x=1777819741; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZLYe3X7mIdfpi7a+4xLOp68gaR+hsDkG8LtdUaDQjF4=;
        b=NenE3BRcLW34Jayeyr81Rdt1Zunk2n3OcSKDbKUkSndZ0irM9vsWGeFB2cTG+SK39g
         f2ZRdW8UlOO/tGmmespooz6WOSBI1CBQoYWX6oLnkpqeEQDp3hcU3LwsU1RNTpd1nI7o
         /WNuy3zwMo751bQ3AJW7Ij0y8BrNIT0M+Js8Thf89EX03zHW3f0+CLdB9/yweyKi7m0g
         vcByteO/ISTpDr+pQcDLCovC6WC3LJBMdP8s0IgY2ic+pJg6DowPYqoL60Oyt4qSd3By
         1AiR1DnQuGNNmmHfmtw55B5QLnq8xQx3vMqTQBjEd7M3mn8C4pJsQ7bXphAUzPtcv88g
         rE+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777214941; x=1777819741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZLYe3X7mIdfpi7a+4xLOp68gaR+hsDkG8LtdUaDQjF4=;
        b=j1UTOfyFMGwFA+SnzktoYHsHxtbVCNB0aSieYAONvb6QTOD9/38jvb3QT53grqsfnL
         dBaX1zQM/8ymbg8eq/DK3djtJ871iCguprV1g+BgLxnOyIGr/CyIv6o9LE53ESShTtb8
         NohlxItjWeJyVr2zaQ3I2SFQ09AlmYxtTmjBReK2r8clKQdrkVrlF0tuOkm09fi+oGdi
         jTK0BAnzOFuJSGA6WjchuiFFO0p9VdjEuQjzLFIIa0POXkuVje3b2QOxXF9Q8d7+eKky
         IOqa5iIf/mQEbQ7AxcZDvHK/dd07t5eGCxfJQYcxRBicPKLo0qCKn9X7FFTK5NEzeAbA
         u49Q==
X-Forwarded-Encrypted: i=1; AFNElJ/bbXbIPbWwJBfO5nZMV66jbXN24BH7EKvlSppHjJdNz/33NxiZStS2fVrDp+j2oi9aCrzHL5/wSD4AyHVQb28=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNo3p6FpYXP+cTjPulIgXX5Pj+9Ff5pzLM+S6N/tmHukr5aGI5
	Bkl8vwpciF/mNyQcKCabCnwtxNrCiQ5amrsMA8qI+B33VJozgzb1L1XG
X-Gm-Gg: AeBDieuv+2PxMK78LaAfqJu3hVYZZFoHPXL0Sw7RtNV8DRKd9pTdToKtTwP84Fd2eya
	Y0+f3E/j991RWmJbaIJYJkflRKXfI8cTuowtJpUnsjJNaDSwoxsyPS7GFjxyrMSYxSiZh0Vbd+/
	8ojiZo8CPsGowrWnTndo6tzpNAQu4+4VTtW9AmCj3KOBAXicxeqHRWQSQ4EJ3X/eq0Sje9fRdob
	sKlA0fNVRPKpGKedjdhaiAQICq2IcRWkUnVgfJ/uAT+LYbevZm5Gn9fJbnDDSgQyhDtCiLLE8Fj
	mCXsiIbsnUHUJHfIanPxYV4VUOadnW/cTiI0FoRBl02VAQgNl34stTaZzQM7HpnzGO/m/cx2m2v
	7pIyl7e/pSg5M9xm0T/k6I9HQAjD5nIvjcckTSioiX3OefAg8n7Gk13KpjCIZVxF5c0LZDihV+z
	z2sSbgqfkzEcca8TpzUGp21RPu2UEiEOweL3R7k+FXq1VpDYHhK77bRrYvqbhlSw8DtQoJhHEcH
	NvyVhLPTDc0TYzoLdfRWqoRzf7kAlUj6P72IcCfVg1wBTpyL+tX0BWghqKMVVHev1CBU4iTkqk=
X-Received: by 2002:ad4:5bef:0:b0:8ac:ae21:46e with SMTP id 6a1803df08f44-8b03a1885ecmr509647676d6.31.1777214940620;
        Sun, 26 Apr 2026 07:49:00 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aebc655sm232579146d6.48.2026.04.26.07.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 07:48:59 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Yi Chen <yiche.cy@gmail.com>
Subject: [PATCH net v2 2/2] sctp: discard stale INIT after handshake completion
Date: Sun, 26 Apr 2026 10:46:41 -0400
Message-ID: <5788c76c1ee122a3ed00189e88dcf9df1fba226c.1777214801.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1777214801.git.lucien.xin@gmail.com>
References: <cover.1777214801.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

After an association reaches ESTABLISHED, the peer’s init_tag is already
known from the handshake. Any subsequent INIT with the same init_tag is
not a valid restart, but a delayed or duplicate INIT.

Drop such INIT chunks in sctp_sf_do_unexpected_init() instead of
processing them as new association attempts.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
v2:
  - Fix INIT tag comparison by converting the on-wire init_tag to host byte
    order before comparing it with asoc->peer.i.init_tag.
---
 net/sctp/sm_statefuns.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7b823d759141..8e89a870780c 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1556,6 +1556,12 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	/* Tag the variable length parameters.  */
 	chunk->param_hdr.v = skb_pull(chunk->skb, sizeof(struct sctp_inithdr));
 
+	if (asoc->state >= SCTP_STATE_ESTABLISHED) {
+		/* Discard INIT matching peer vtag after handshake completion (stale INIT). */
+		if (ntohl(chunk->subh.init_hdr->init_tag) == asoc->peer.i.init_tag)
+			return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	}
+
 	/* Verify the INIT chunk before processing it. */
 	err_chunk = NULL;
 	if (!sctp_verify_init(net, ep, asoc, chunk->chunk_hdr->type,
-- 
2.47.1

