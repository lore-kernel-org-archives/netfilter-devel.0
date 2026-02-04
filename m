Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F0841C2E7
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 15:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219521; cv=none; b=T1MwqM6pFmj/1iYvWpg+VIm6V52l4OlyUBtfo4M0C7USTw4VEidMit3FSvxu7Gf+Z4I2fMFr3ykBajKi/4pYQUoKNWRBKCEEXn33Mzp+J42aQxNgxYF4TeocbYIm4NAA5DLw+UqPA/BEpqJnL+WV5SqQxoGG5hRNdWqzXF4eS/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219521; c=relaxed/simple;
	bh=6eRxcKcX/7d4u13eNT9ExdaPC9M+E4rZi+n/Mbmvpto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oda1l++g4DWyK3M/Qhlfika6cw1m4HDX+prXDrXs1ih9XiohoQC7FQp68ShpW8bRMG6+5xgENkHbBtWs9pOYjY3LS0ktZWnWWcLh0RAzkRfr6EA9SbDdD67ZwRIz7g6crJKQO/4cfdheLpZz8623jnRwgO1q9Qdmqj7K7POVqtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WKOF0t0c; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKOF0t0c"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-794ed669269so17111837b3.1
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Feb 2026 07:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770219520; x=1770824320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+n47fh2bFXkrYOprTyVzl4j2TOZ+to9r5iYbqmKrvQ=;
        b=WKOF0t0cDjNYodE/lR0HstzMD4SVx1gJ8WVZpMqVdFaRY19OisBP+dCoKR6YfZ/cXl
         nH19uAvqptnRMXRLQl2DZHv+oXBh4xBs0MWYlBcYEXMnk5hrM7Qr0dim2ruADqNdkOoE
         NI4urFYy1AXD7w2CalcEOMUgRKcVsuawI1kPyLhQ/3WKOS7Y2nDObKPtyaOuzG6XKAzn
         u0Nowqe8vMx79vot0AaSdMarxT4x6Thg0mYZRRMOC2QHgIEEBWHKxQG5kp2Gknck4HG5
         /x65D5b7ZmUsr2kfNefoySqxV9bFOCOwelKYnr2hR2gKQz6VDnSYZGFr4WIWQ+3OizaE
         Hqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770219520; x=1770824320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r+n47fh2bFXkrYOprTyVzl4j2TOZ+to9r5iYbqmKrvQ=;
        b=LC+XNo0Gcx5/uMrWf0WMXuxczUAQGNO6Pvp6p+q7vVs6qfBGiMu5navcMf4mtY6Let
         jiDyoYK2jQLEFpb0lgNTzdPq3TR7KKgDeUbfCkKH4dI8lEIGdsveLV9fVHbxbGjeAOVH
         r0yx//tJ51eJfUA6+LWC6dql7TQP4BUjcYU/bw+tc3G5SgCSes3XPPV92LJaQ8Vogcvb
         pEtypEzDhktKbXxwGYcR1FKUfncg8D8Sru0rbcP+NzxIK5JwV1PT6MPE+3KMgaZ5aHGW
         M4HzmgzSW9oGpUZxw4UTW1fJpvGC/FkSKCpQqTQg2O9Qw2XE0mIBtGHSsl7ry284YSgc
         7bzg==
X-Forwarded-Encrypted: i=1; AJvYcCW1tYGoQk+1Y/D4t24fijWNPErCIIjad+L3JxOSbEFnkl1CnRfp/DcTkkG3AARKYJPWhpyAky009ssT4+UFYGI=@vger.kernel.org
X-Gm-Message-State: AOJu0YysWZiO3pwGkFrqKzz6Dj6C2bFbLvTVTh//NS/KcTmoEQOnWmDV
	bz8Eto132JlwzH3PYh2wjK6sOdX0h0Wof26NtSwUVXDBYYffspY6jKbW
X-Gm-Gg: AZuq6aIpzgQWV91NtLG7zu5Zp64mcRjp9ccL03INCUpq7LsRRvekprc8tSZVFKs58Ej
	01ysL6BY/NiUiBjdsMjB273JaiAzpCrCXbN6xzjdj33Xf6EZHspQrhi1mo4AVhVw29EyMM46QBo
	ftdZ/v340sFmOFY4vNuw3k/lTudnulaZKPrPI3CwThBqVK0Bg8dQDm0ac9gdZy6lOPlP7ycJjlT
	cPVKXFwa8YDVifKzQwatgJ8wl/kLVA9PZ0xquoaTPAQpPrdooIvVgir97MYn2/yMPLbGVwtLjXn
	N/n12LPk9sLjgqoVjZFfOmr8HhritnyXpf1uzQeN6vNvcEL7k+9iAvfZEX/WZ2snJDrs5jnmTBK
	uHD7mhysZY3nCAcNq90jb5TvvFQ0jhsOm6lOZV/K50NmFu0yYnk1cJn7TXwbsj2VwsZIpTBRZ4w
	JpgfydgzgiOZFvAZMlUnhaVVdKJm+UlrtOhxksbezoxrOAbrHsBxxS/QPcyGjXRmCEyyAKzwwCj
	lHJ7L7BJIHo5w6P2/VU
X-Received: by 2002:a05:690c:6d0a:b0:795:905:c047 with SMTP id 00721157ae682-7950905c920mr12338527b3.3.1770219520334;
        Wed, 04 Feb 2026 07:38:40 -0800 (PST)
Received: from localhost.localdomain (108-214-96-168.lightspeed.sntcca.sbcglobal.net. [108.214.96.168])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-794fefedd4bsm23609397b3.48.2026.02.04.07.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 07:38:40 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH v4 2/5] netfilter: ftp: annotate nf_nat_ftp_hook with __rcu
Date: Wed,  4 Feb 2026 23:38:09 +0800
Message-ID: <20260204153812.739799-3-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260204153812.739799-1-sun.jian.kdev@gmail.com>
References: <aYM6Wr7D4-7VvbX6@strlen.de>
 <20260204153812.739799-1-sun.jian.kdev@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nf_nat_ftp_hook is an RCU-protected pointer but lacks the
proper __rcu annotation. Add the annotation to ensure the declaration
correctly reflects its usage via rcu_dereference().

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 include/linux/netfilter/nf_conntrack_ftp.h | 2 +-
 net/netfilter/nf_conntrack_ftp.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_ftp.h b/include/linux/netfilter/nf_conntrack_ftp.h
index 0e38302820b9..f31292642035 100644
--- a/include/linux/netfilter/nf_conntrack_ftp.h
+++ b/include/linux/netfilter/nf_conntrack_ftp.h
@@ -26,7 +26,7 @@ struct nf_ct_ftp_master {
 
 /* For NAT to hook in when we find a packet which describes what other
  * connection we should expect. */
-extern unsigned int (*nf_nat_ftp_hook)(struct sk_buff *skb,
+extern unsigned int (__rcu *nf_nat_ftp_hook)(struct sk_buff *skb,
 				       enum ip_conntrack_info ctinfo,
 				       enum nf_ct_ftp_type type,
 				       unsigned int protoff,
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 617f744a2e3a..74811893dec4 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -43,7 +43,7 @@ module_param_array(ports, ushort, &ports_c, 0400);
 static bool loose;
 module_param(loose, bool, 0600);
 
-unsigned int (*nf_nat_ftp_hook)(struct sk_buff *skb,
+unsigned int (__rcu *nf_nat_ftp_hook)(struct sk_buff *skb,
 				enum ip_conntrack_info ctinfo,
 				enum nf_ct_ftp_type type,
 				unsigned int protoff,
-- 
2.43.0

