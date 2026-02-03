Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D08395269
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 08:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770108223; cv=none; b=peS/GaAJh7aApjwuRQw5zhxnviDe8s4x3PTg5g6RuVY8Qmg/4rO4Niw2ZC871v6eXOEA65ql1HXzjAjfXCKrtpbWc/zKYqGqvpwPk0dZW/gGRIQcdjqYr/D8SjMZu5C+do7uUvBoO6hMozV0yn2xq/ezIv+WwuyZxeeTpkCYWWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770108223; c=relaxed/simple;
	bh=/vj8FfFEYx4ybfsw1a4KFbNnoLnIwN3x1fS6W+SsamE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e3+Q+ItEziFiBELvQY1/EhoW2v+0R67oWIZdmNSzX51A06+bJXXeBXY5/+8fvLvS2b1RHzp7A8OHAYxRCrb8F2usKYafmtO3Zj+zA88f/M+x2y6VOzijxoqc0NmEnBOZNPSFr3jVay5Q55eikzP3NMDjvRuOC1SwzxqeBNuKsjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DXWZfW1P; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DXWZfW1P"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-124afd03fd1so7927280c88.0
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Feb 2026 00:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770108221; x=1770713021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LMDFXYLSzSLdaG2mbvsH2lIntPnUeMn+Wtbmb/TRzL4=;
        b=DXWZfW1Pbqf5tAchQwTkhkzEkKpbYmUAmkOVc09XZQgaChOEXeb0cleetV6fPnLkxj
         ySLv83h5Y7Whi/4zpTCbPd3qnu493aUfwP8uIcc1gO7OotsIZ3GXnbE9xxp2HG8wXXO9
         nQmcygmf7jH4fKSZb8sCzTcdyYejKlYnb31bKpQfBoJXEtHS2iDlOuFXLitoEhltwiDa
         2K07J+CHxXQuP4B+/jtwQnnl8xxBVRCvGVH2PuqqS/Z2HQOkPZ41QO/IgZpfeVK9zkLC
         2e8S7P/WcscKuFo3s7qwEbjNV0DyJMre7ovPR4TmoqIB03pxvDrh+yZJYLjMli41oR//
         xcRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770108221; x=1770713021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LMDFXYLSzSLdaG2mbvsH2lIntPnUeMn+Wtbmb/TRzL4=;
        b=dPoydDa1oCNmvyadyIr4N3/SXszlXl4N3Zew532LeUr3b7Z2/qW8bFl5rYLbvW6RCD
         76Wjs7DlXEASc/9WagHPHw/ZoJi6kAg3NIPM+LkGWYvjU70yhf3aYy/KqhPyUrHz8jcH
         LZJKPQ0/Qps6bKI08BPx7wunG9KQsL0wWdXZMb5Eud0LeR1iMFOda3KnN5yCHm7RdV1O
         Xrasb1RAczLFDmshlszpixhoSH0WvI3CL5dm/+2dRN6fvPoLU8153XS5tvK67XjGSLNV
         yHZuj5tGrXd0QEbdLXo2jIdoYp+1aF4gK34N6l/PISV98HM1aVW/zpRqsCQou1JV9Erq
         6k/A==
X-Forwarded-Encrypted: i=1; AJvYcCWiazH0V4DeCJ/SnVPU7L9naEA+hF8RMa53PzxKhjm7rKbx/aV8V3GsGdKYPZl+junM6SqJKlFpzX44D8B4gc8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ7dq/PFHA/kbeNITvzFnuVPjeyIG1si8zKehoHdMymozTzzLO
	kuYe72TkFtZy9z0FNrA6qzfQK9FlVAsVinqSmi05twm6dvv1qSCvyv92
X-Gm-Gg: AZuq6aK+YGqLZ2Qx8ppdo/mqxMc2Q8oRYL3Zs32mEpXu7mhZOQpWRnjuO2Yh2YjX98l
	7Rw2uaAF9U4+d09DFEIwhzmMBXWvI6eDuZBCqHzwx3MYwYCjw4mIGbupXdB+r5SVbaq+r2hFsOY
	JVNs/Z1ROtrAhW9m3SA7vPTJ/1xOHycu7kpXW5OS9u/v2DorN1S5tKKPf/2FDune5d/EGdcia6l
	4PjIVtDeYGnsEgydwpZcwgy8YovExag1ZYyWVPs5BJaeDaROIBbwpUMdi8AEIMS4eI9al8tWQeR
	UqplTLYP+x0FgVYrjIIxGH/XUYUcNiIsb0fq+wHiZZeor5FBC18L+NgV2m8dNQ4u8ELqa2o2FT3
	iSvvWEBEOqRgg3SAIU9m5VFHj6zaeK+VH3UtxZaoYBJIry0IiRvbsJH8snl9t1BUcz6WmAwHDr1
	JYvOG7SUuBxdkgZbWY5uCcb0j+QzAzzDUCK6JMcg85SnyUykeZtOTFPOJiLpeIkPsedlsB+lMPY
	gUakVWdMw==
X-Received: by 2002:a05:7022:7a6:b0:11b:95fe:beed with SMTP id a92af1059eb24-125c0ffbbecmr5515230c88.38.1770108220751;
        Tue, 03 Feb 2026 00:43:40 -0800 (PST)
Received: from localhost.localdomain (108-214-96-168.lightspeed.sntcca.sbcglobal.net. [108.214.96.168])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a9d7f597sm19048396c88.5.2026.02.03.00.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 00:43:40 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH] netfilter: bpf: add missing declaration for bpf_ct_set_nat_info
Date: Tue,  3 Feb 2026 16:43:23 +0800
Message-ID: <20260203084323.2685140-1-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building with Sparse (C=2), the following warning is reported:

net/netfilter/nf_nat_bpf.c:31:17: warning: symbol 'bpf_ct_set_nat_info'
 was not declared. Should it be static?

This function is a BPF kfunc and must remain non-static to be visible
to the BPF verifier via BTF. However, it lacks a proper declaration
in the header file, which triggers the sparse warning.

Fix this by adding the missing declaration in
include/net/netfilter/nf_conntrack_bpf.h inside the CONFIG_NF_NAT
conditional block.

Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 include/net/netfilter/nf_conntrack_bpf.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
index 2d0da478c8e0..25b51fa783c8 100644
--- a/include/net/netfilter/nf_conntrack_bpf.h
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -33,6 +33,9 @@ static inline void cleanup_nf_conntrack_bpf(void)
     (IS_MODULE(CONFIG_NF_NAT) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
 
 extern int register_nf_nat_bpf(void);
+int bpf_ct_set_nat_info(struct nf_conn___init *nfct,
+			union nf_inet_addr *addr, int port,
+			enum nf_nat_manip_type manip);
 
 #else
 
-- 
2.43.0

