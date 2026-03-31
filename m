Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C6B37EFED
	for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2026 06:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774937685; cv=none; b=QTubEtCl4EI6wM6rDwGPY8Ws80smMwU19c/pkVzbjzvgiIPh1ZuI5731R06h0UKiahcQMX+ABWjT43QvLG+pa3/r9m9rvVnjv/c2wq7IQ41/eWjbEHohJWVHv1gQy8PO/QuQ5iuj/FmJKPoTnzA8U74sfCClAe+iyybxrsKH888=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774937685; c=relaxed/simple;
	bh=+MVwa06bQ80jTsJAxdYTPPItAkzHNOIIwQDDMrjTfLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxszdQXVdF3cFpkTHpPc2mLl7UlCRAC1cOYmP9Aqt1ibvLMWeHxT7lSyQ/bJyIirXWTy7Cxyp6ux9SiD1Q2aWiDoN/dKT1NO09HvnQUR8KEYadndpP71UHAOj70XG26Y3p9xXkrLttDk20/x1BMPEZM+MeQ/xYgLDbPualv4G3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N28C7yGI; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N28C7yGI"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-829ac4670c4so3849576b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 23:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774937683; x=1775542483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bkzyJ4oLOwweestkp4e2+gtljA8YSDiok5IOKRVAFxc=;
        b=N28C7yGIHxXtTsQUQvJnagExwZq9OdR3fGxH2aynR9nmtIINYAuBrw4tR1dNIxM4u6
         M17p/Nyq9ZyieWueXt9XNZQCnx3cwJ3xSY32FoCyYpNeda24tr1EPBV0BRs2F0yx47ni
         Xlw4x/BoQSaTeap3QXPbWjJVDChh9sP5rnpO7DY6y7Qdtqs/1GkJC+oon1ibtdvGiEqD
         mc2L9uqNysR3t9ZZaMxLVG7d9iW3w5la/TS53m7h6Da+UnInNeLc/wSB/d6l+7QrnuTe
         WWk2SkAAbLcgOQqhZbw1+GlntZ1QYn6FFzPWeg2uTJSUVBClum3nzgj7XP4JnyuAkMjH
         2ggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774937683; x=1775542483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bkzyJ4oLOwweestkp4e2+gtljA8YSDiok5IOKRVAFxc=;
        b=ltusqa23C8XfwvkxKuRAH5nl1SW1lMzdq1wTPt9+ujF8QIL93Uxm+ExRb35m2vqKRW
         W+egv72HAcnSjaI9V+IxY/Ei/X/t8uBS95UdaFA8IajqQAKjXXx5QyKPOAs8cT4knIYV
         saFK2gbtS9vwPj7GOZ1CG4wulw8zhdPm30lO/4dCxNFtg4pse5kqz1Vs9iqeG+YOITMm
         HMiTxxdnto5uanl7LStiqvZxT26I+DRSZYHiecclp9tVsv845yIzNh+/tkbd5LQ2pacY
         5FX1q6dvwnk5TtX5NxMp0Q+8fBIsvfTVsc6UvOzVjZI9iQh+CxgTfgO17GoFsPlNFUHZ
         wCvg==
X-Forwarded-Encrypted: i=1; AJvYcCUDbhoALZaepPwJUdit63OjirUFh7CDj8ZspkUyUxfR0StOkihxWR1mXPS35GxsdquKOp0ZcR81mcK5Ss8dvjo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLXSB8Emzxi7i03oyPZ6oipEDS+T2UmqaGO+Or2+JoHWcP0s6P
	H48en7NVj8WB0y8adZ7Wk5PjZth2TwItpWJZQ9WEN48O+4zTX1Lppbgj
X-Gm-Gg: ATEYQzx0sJU6W19I9YTlnep+JtMTxKVjS1qd/W3lZJEWRzejUC0apjNbZ4YjvY+KQG2
	8JIzwZgNM6gmOZQGZtUSmcZs7FjB3AdRBGCsVzugxDLd1+FNHVY8UJQKYQL0UQ7k4Uy3TOTGHnE
	tJipzmAw1K0UIy2hTa7wJFiVug5DHxCP7lUa1HkgAkeSSIVF1jaB5LxxzWtA1ZFPA4h/sIUDMnT
	2U7420RinoO4C/f+e3C8T50hGNRnx+uUOBuGUSMxGCpfluGPQTQUVQ7tzbkccx8kfaVBWiiLbFi
	Y5Dh7xOgcB02QD05yYFmWttVe9Ht0ZX7PYvLcMU1vyU1CI3zNXFWxddNhI0hPHagtTiyyLEG9Bp
	s16J79CYLezGlRJiRr2XaYqVH/HljCK0UeL3UVYiMee6QPIXjV+noaAfm/sjVq37+vfOzI42GFf
	9iCHc4oy+CLoehZdJIy+mVKZdY3oVEp8KKJ+YBmOm/5TA2gg==
X-Received: by 2002:a05:6a00:2d0c:b0:829:9c5d:4342 with SMTP id d2e1a72fcca58-82c96024f3dmr15124148b3a.54.1774937683377;
        Mon, 30 Mar 2026 23:14:43 -0700 (PDT)
Received: from localhost.localdomain ([47.236.127.140])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca8498779sm8984835b3a.25.2026.03.30.23.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 23:14:42 -0700 (PDT)
From: Qi Tang <tpluszz77@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Qi Tang <tpluszz77@gmail.com>
Subject: [PATCH v2] netfilter: ctnetlink: zero expect NAT fields when CTA_EXPECT_NAT absent
Date: Tue, 31 Mar 2026 14:14:33 +0800
Message-ID: <20260331061434.84238-1-tpluszz77@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260329165217.241038-1-tpluszz77@gmail.com>
References: <20260329165217.241038-1-tpluszz77@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ctnetlink_alloc_expect() allocates expectations from a non-zeroing
slab cache via nf_ct_expect_alloc().  When CTA_EXPECT_NAT is not
present in the netlink message, saved_addr and saved_proto are
never initialized.  Stale data from a previous slab occupant can
then be dumped to userspace by ctnetlink_exp_dump_expect(), which
checks these fields to decide whether to emit CTA_EXPECT_NAT.

The safe sibling nf_ct_expect_init(), used by the packet path,
explicitly zeroes these fields.

Zero saved_addr, saved_proto and dir in the else branch, guarded
by IS_ENABLED(CONFIG_NF_NAT) since these fields only exist when
NAT is enabled.

Confirmed by priming the expect slab with NAT-bearing expectations,
freeing them, creating a new expectation without CTA_EXPECT_NAT,
and observing that the ctnetlink dump emits a spurious
CTA_EXPECT_NAT containing stale data from the prior allocation.

Fixes: 076a0ca02644 ("netfilter: ctnetlink: add NAT support for expectations")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603310541.XVM8V7WG-lkp@intel.com/
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
---

Changes in v2:
  - Wrap zeroing in #if IS_ENABLED(CONFIG_NF_NAT) to fix build
    when CONFIG_NF_NAT is disabled (kernel test robot)

Link: https://lore.kernel.org/all/20260329165217.241038-1-tpluszz77@gmail.com/
 net/netfilter/nf_conntrack_netlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c57c665363e0..6d7eab7e8cf8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3593,6 +3593,12 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 						 exp, nf_ct_l3num(ct));
 		if (err < 0)
 			goto err_out;
+#if IS_ENABLED(CONFIG_NF_NAT)
+	} else {
+		memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
+		memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
+		exp->dir = 0;
+#endif
 	}
 	return exp;
 err_out:
-- 
2.43.0

