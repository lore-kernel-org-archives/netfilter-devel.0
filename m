Received: from mail-oo1-f100.google.com (mail-oo1-f100.google.com [209.85.161.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99008368D7D
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2026 09:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781863087; cv=none; b=Te5tURQlz8DW4O7j1jFRyyu52GFL2CR1JckneAf9Zco/688jclNzp+DbUN2VyUpMYKBi2wHkpqjPceIzwrtUrj2I74C+8g5MMauP8DlDaotgS3yUsnFebcETh2HIWkEo7YNoDG1ud9RVhXkzlbg3X8upNnu+2R/77460EhcBLbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781863087; c=relaxed/simple;
	bh=hk2+uuYecO2IQQF9bcMQEfm2EUhrTFMxzsBYQSG8ZtI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i2HP/yiZJiIe+HAkRL2kXLsBq5mRnKXhnPaa052dS/6Y59UdFlOlPvnxQ4jT3sATAF73jb+pd8L/fn4hD1sAvtKk7RfSo0AdJjXdfrh/Za8O/86KI4pt+iprzTmx5w9FhjmNMy2gLSHzp78zhjOcl9O3kYqlgMvXHhvlZhqtpKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=QznLjs9B; arc=none smtp.client-ip=209.85.161.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QznLjs9B"
Received: by mail-oo1-f100.google.com with SMTP id 006d021491bc7-69de16f5f79so1038162eaf.0
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2026 02:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781863082; x=1782467882;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U57pja5e0yJSy8SFBtN6ioJCsbtDVqRKjAnvzO5IXeQ=;
        b=pX3xUDrlqvODxNI3Wt4sSTucbG3Ii702b4doCjdklTrGo/YBvgy0qO+4ovuBqgEj76
         XC8Y1isAIhoRv9T9G9qKQ2t/LOHw/98nUWHblpNxkF/Jf+WpqbM/9hjmRCsuCIYDV0mA
         WDW/pSnR6uGdh2Az6A3JLEIvfuGPpk0ikko7E8TkR/MlAp9c2GY9v3Afkgah/4A6ofSq
         0mDLzDN6RN9FPHHeuNcKlvlhK7PWR9bdk5n6wLaivC71SubTGQSgoffgPo7HSVKl61gv
         2QN2Ux90+hFe68690FGxkJrlTbcXA97glLV1XGvBrXv8rVNkg9noytSHAUxLzL1lI0nD
         QLZw==
X-Forwarded-Encrypted: i=1; AFNElJ9g0Nfb9938FrmN+Eb81ZdjsY8uN+hGHG6g4LJpgVwAMjWXfsfgEzECQU1W/zDgOQZgtswzYI5j7fTUokAH+nQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDWTLcmL1FWwX6qfBSR5PK6jkQo9OLYDGpC6550ZEnQ5lnKUzM
	rPLgyWXWdHVrYm59cARbezZIMtQ7LUNYWAXZ1ifrKI1HGZEs7L534IlvONdfi4Fnfr+u5pd6X89
	KFgn7zrdocQnM40WMJ7swRsXY/JCzC1uN8WCgLoeWph22MPydi14sudtilTQMVmlSVi69mbmpOJ
	QiePc/yJLRY+Z736v9oiQSWEHzVujeLJIjaFFmvQ3aPaLasmCGOJhhLZf0ZC76QCz0N9k8INuyU
	JJzKzC4N601EJ4kuVvGaGahSCjeLA==
X-Gm-Gg: AfdE7clYY3sfAK6ywSaTfrmrH6Rsq/tUu9Ib3pHC3IF/a8zOlE7KtQ2nudNu9xhsY78
	csGHK0GBVR2pB7Fn27J7NPJYb52OB7B/UbUNJok540WHAOTXvycoIer5DV7/rbEv9WIO610Af2V
	9rrr3CUSqfTMeb3MwEKEDSBoE3IGqxIJ3DX7aHyQv8/0gexu7VDArkVOnnZnD6Jqw1k/MDBVWi7
	g2Jtcc3i6cB2+eb5lntF3dGMoU2pcaDjVNOcXvyJ91AJHTPS+idnVcb2HgxyO73NLpjQePtsqz4
	sGmtOyI5Kb5eG3cT/nhmY4dqJgIlabVcBbWXOz2iWGh4Hi+zBbLfDvkiDwAKg4H1EfGn3l8lqsQ
	pdBJ0HTqurMygqshZ4QLDDTT3MOkmdV3y5iw7n4FmIa0heSgr7wEjzupC0RA/id3G8t8P50Xzoz
	HyuwIwhAsIAYHVnuAI6ZrsunpxIleG9U301K8uvsWt4tcsdZe5mw==
X-Received: by 2002:a05:6820:1391:b0:69d:f7bf:c53f with SMTP id 006d021491bc7-6a0de0e5ca0mr1391371eaf.39.1781863082265;
        Fri, 19 Jun 2026 02:58:02 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-18.dlp.protect.broadcom.com. [144.49.247.18])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-6a0d8da63b9sm107747eaf.7.2026.06.19.02.58.01
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jun 2026 02:58:02 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30bdfcf7c14so7977890eec.0
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2026 02:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781863080; x=1782467880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U57pja5e0yJSy8SFBtN6ioJCsbtDVqRKjAnvzO5IXeQ=;
        b=QznLjs9B8KH1PgsSBwi4eSo2Q4TzpP6KxpoqRJBPPGQVbFaU4K0u8mJZ2Z468/iWjk
         +XvcI8j7zC7nSReIxgeYagABmqTrblFYZ28mSLobGCBKprg77wZAgjMhJls2TN4Ljgan
         eTgcHFN9vEt5EDVYpP5BGG7avN7JrSDdragNk=
X-Forwarded-Encrypted: i=1; AFNElJ+iVM19h/HiL3TWSxMJ3I1exPoTIVJ6baqbvWTXhakAQx/1V3rCHpZis56fbBTzCu1tWx5ljUyvhel7i4l7Sag=@vger.kernel.org
X-Received: by 2002:a05:7300:2310:b0:304:705f:e4e8 with SMTP id 5a478bee46e88-30c0d1123b2mr821999eec.32.1781863080549;
        Fri, 19 Jun 2026 02:58:00 -0700 (PDT)
X-Received: by 2002:a05:7300:2310:b0:304:705f:e4e8 with SMTP id 5a478bee46e88-30c0d1123b2mr821973eec.32.1781863079967;
        Fri, 19 Jun 2026 02:57:59 -0700 (PDT)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c06d5bec5sm1851910eec.26.2026.06.19.02.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 02:57:59 -0700 (PDT)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH v6.1 0/3] Fix CVE-2026-23272
Date: Fri, 19 Jun 2026 02:28:47 -0700
Message-Id: <20260619092850.1274076-1-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

To fix CVE-2026-23272, commit def602e498a4 is required; however,
it depends on commit d4b7f29eb85c and 8d738c1869f6. Therefore,
both patches have been backported to v6.1.

Florian Westphal (1):
  netfilter: nf_tables: always increment set element count

Pablo Neira Ayuso (2):
  netfilter: nf_tables: fix set size with rbtree backend
  netfilter: nf_tables: unconditionally bump set->nelems before
    insertion

 include/net/netfilter/nf_tables.h |  6 +++
 net/netfilter/nf_tables_api.c     | 72 ++++++++++++++++++++++++++-----
 net/netfilter/nft_set_rbtree.c    | 43 ++++++++++++++++++
 3 files changed, 110 insertions(+), 11 deletions(-)

-- 
2.53.0

