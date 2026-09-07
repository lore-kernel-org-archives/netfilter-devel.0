Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA9A3FD12A
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 06:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763373; cv=none; b=ijzb7bs5rCokORokfI+Zv2BX1C3MiBBSTPjnUBbvjjOoQaN1g0dMjTlTWtBxZ+MzdbNfh98hh7FBCp7QRCkVPD8lONyFMrXzunBtUhHBzErACRmYExwF8HpXRI/2xRMV0KKrmlUmwKesc8wxDunPNuU+fJSKAKCB+1t9hnQXuxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763373; c=relaxed/simple;
	bh=obCt6dFIrhqK0L3cVGv0aYy1LeuBf7kuUudz81Z9e3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7qzdHUswd8YhxyHEpLtF1i+f/OAzuhiJak0sBoWK6dw1FPwT/4tWRfXlQuz9FmtKzoW8Zz1Q4HmcEtPvYwBqhHJH3rLQjBxLjTwRrY5ePxEU8YWC6XQ987DUViWO5E18Fr4IIDsXa7XaUwCR02lKS7Syl8OUvEapRMW9X8tnHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2CM20xR; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2CM20xR"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-39647aa9d52so3151336a91.0
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Sep 2026 23:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788763371; x=1789368171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ar25cKs1gH5uWsuIBDWcu71MwwQW4FbjSNAQqbQcxuM=;
        b=R2CM20xRVjgggwT6RZ9dSkgejffFNsFnk969uwIletslHRlWM2AM0Cr8kzvGwf0yIl
         KwcsFLjVvcdoDeCfOsMvAm3K8Bs5OVwPjV8UDfFU0Xzggvboue9dQHK76Z5jdfGzpHXu
         BCZRG0b0yewzeZP5AsHry0GMqg41JJeyKlT9JtQR2UTY51q01WcvdTmvV/SMUorTz49I
         lpQoRa5E5ThOZc03Ojhal46F72whX7RZr6teukT5BaQPcxImtFYlzRS8+UKvJL7sO2E7
         Lo0ejR9ivA8OWn1sKu06ohAqoIt8XJC/6cdTjVRfF0plg+mgmkLOgxnHU1/jkuEGPf2A
         gQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788763371; x=1789368171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ar25cKs1gH5uWsuIBDWcu71MwwQW4FbjSNAQqbQcxuM=;
        b=PE0uS7BpyQC1Sc5UmZla3hjMTC4loiFg0+3XywMQrrrGe6iL2iqRQKhCKzYAYpUZBa
         Fm+UGbZDNmrdXdCx6W+6GtWpmDG65xt/VUkIX5al6k1BVwjCBgg0cHHmieO0U/Kve59h
         ZFl94tnM6rsfX0ElP6rTk73al30DhLcvwPzBDHrOp/N2yzlE8iQiuQWdp3IsqKW19fie
         BGYt70cv/pu9yBNw5wwvHhUaoPs8f/HhYlLsIq7fTNWy+LlHMuOqBnC6m+TFGuUgnYvJ
         knqKy2ds5ZgFU30EnZbr/pWyPVSABXT2ieQ+bqHEPuA6ziP+NFAkRCqO4kG7ciYwuzXy
         ujQg==
X-Gm-Message-State: AFuF++n5IJKCpLkm8n1SdWyMU4QlnSZISpI+Fvj5SjThrasH7xUa+HL2
	HlNOzsjNK93ObLf0NTzlqxFDOgyXgUGkeZ4IcsLYvf6Mnv0XQkxk3Uyt
X-Gm-Gg: AYBFou1OpyC5du8h1j5FikVupQwOI1vQfWM0YsQrqizwy5SdCWYYYLYWtBeWn7afPfF
	XMijp+LJ2KIhaCRBkCgY53EVFHK2BC/sSNlVqkmbkAUUi0rMff2754uMsAS1lKnZZnZU/tuJ6IE
	BjcUqqMJI9Zjy+hBfbsbH+MD4vNLKOcvyzVEfVyLfgl8QJgiEqzHfu6Y0BXjYWN0pXkpe4G7/+w
	AauWAeZOsjidGqmm2uC2wqpJGqHy0pOaw95K+Re0XnczFjajvym7oIvgWDM/qaHenVDOnGE6iUB
	nqShBRGRMPlyGnhx+yL7rUx/ncSBudZR5mG0VIfV6VZbf8HSGaGBYhHHSs9XA76WRuf2e6CVArI
	auDSbAgxJeqCiEquPWE0WKYOIGW8L776fCwkr2u9sinbHvsg7qbQjmQMHAqTrOtqak5E3aQRoMN
	H9mIhtotXHMHGnRU10nk0fjZGmlsB9atKIK3mnrDYz6JK63sv8IE9DkULotm6GMOt2montPuqNv
	GCHgNUZuubhOQ==
X-Received: by 2002:a17:90b:4ac5:b0:398:9beb:a2ba with SMTP id 98e67ed59e1d1-39b087fb503mr30411442a91.28.1788763371277;
        Sun, 06 Sep 2026 23:42:51 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3356dc5c04dsm14377817eec.8.2026.09.06.23.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:42:50 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 1/3] net: ipv4: fix typo "alignement" in comment
Date: Mon,  7 Sep 2026 12:12:36 +0530
Message-ID: <20260907064239.39910-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907064239.39910-1-hemanth.selam@gmail.com>
References: <20260907064239.39910-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "alignement" to "alignment", reported by scripts/checkpatch.pl
using the misspelling list in scripts/spelling.txt.  Only touches comments,
no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 net/ipv4/netfilter/arp_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index a87e07e80d0d..b680bd14d329 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -59,7 +59,7 @@ static inline int arp_devaddr_compare(const struct arpt_devaddr_info *ap,
 /*
  * Unfortunately, _b and _mask are not aligned to an int (or long int)
  * Some arches dont care, unrolling the loop is a win on them.
- * For other arches, we only have a 16bit alignement.
+ * For other arches, we only have a 16bit alignment.
  */
 static unsigned long ifname_compare(const char *_a, const char *_b, const char *_mask)
 {
-- 
2.48.1

