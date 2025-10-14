Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82A030CD80
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2025 11:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760442221; cv=none; b=gzN3LGqzg9gwLQEeuhP0kj/j8gm6eGwelE9i3cxRfnMGsS5ZJYUPD+bibQVxC/6fYp2+WPOKPDG0kHgF0eQPfSOvnIU5U+doakVZkKnzz02fuRPX54+GRT0sv5DGEJKbpCKsMcRu7I5gc8h3vr7UU1q1Z2ZiTTUHSwGDEHvdTUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760442221; c=relaxed/simple;
	bh=9Anz8SdWCHj//cI708iSDs2qphpPgNV3XK3W9CnyRRY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IJYro8VYiDP0R4IGJv4nkxHznBzfExwIed7mopwPb/qTAw60vl3Snhhatbl8UdPqCSo4th2hQzJkuHd/ig2g+j//YT0TzT4wmRx0oVe8kzWJu0gigkpwPP25u8JAgxS9touqZmOs5Z+cq8+Hdd3+EDfai+F1q/08cjYBr46cLoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=whrYiz/X; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="whrYiz/X"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b50206773adso1125289066b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2025 04:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1760442218; x=1761047018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tzi/ei+DoEPQ0UXsEb+6ZYb7S4ThZhfVu5KSSSvXqaE=;
        b=whrYiz/X92bu0MLAMI7oDBmG4J8MsyotukbZ+P9yvz3KFXjkRjiet6ecHeVRQCe7nk
         ZG30hDJPH4FeW9jPnBO4TCFnRZw0anVkNwUTWCMzrk6JowQL1/W9vrvsauMs9BZCjFfH
         7/xwgtIQO+RGWny2R9IgouA1UdCOf4qUcYCse2KhGH4X35rHLuVfnzGb8XmnKC/rjxBZ
         P5c1sFZGxGe/nsba18UqhxbpvFquIdq8ohZAnTFPSI9jEAp2dfXdkD0lm6lfRCbwbnKN
         xWJsqK/ht+fs7XVhe0AoBjLEEi2ZprMmC5Xqz0vnMnoIqAWtr7IUt0kzn2XPvVp16LSg
         +MBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760442218; x=1761047018;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tzi/ei+DoEPQ0UXsEb+6ZYb7S4ThZhfVu5KSSSvXqaE=;
        b=pIChnThPw7QXKetLk4IoKRwcK34jIzgKov70bRyNNYaSidQNadGMriMhwgZ6ATC0KT
         HFIyHnsVd88FJB5CGuh4jmI5prHDhhQQT3T59R0WvjSk4kTctMkmZrXzMEGtHRbUqQ7K
         RWOC54kIfGkGJRpUXLzON2pPKTlddmNQ65m5pwvlNIMkA6Tw0xX9oNrzDRIx9ErYEH/E
         BwpUp+na7nwnN0N4OMQK1CECE3w/LZe83rHJAYvZH0c4PtEz3wuajVi9KpvR3H9FilLs
         Cq5IdZIDYkrpmN0EqqZixvQe3IBZ9eMwor+O78CGrlRRNoO5hn5PBTpGjIwGYxWebHRn
         4zRw==
X-Forwarded-Encrypted: i=1; AJvYcCWWaym8J0CsXdOlLoYDrjC+BT+5Np1owrzc7MZwBjMgK7LdLpLjGClSNDsCafiwLYVu+mUgfZFgdVWSZMezUCk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwifBkAiIjQQPUuaykURgiwiSOFqAUCuaBvFpANJGzMpSF+Ue0t
	jcYHoHVt08n//CRJFTmQQXDSeJCQ5PBW9th5YU6NknRO5HQ54o80pHihCONthfw33zc=
X-Gm-Gg: ASbGnctnzD0s9Bxf4CZxU/myOq8SOztqbjEXhXx41CO7nmmBGEZZl+xSH/sgdxgCAmw
	I3JBRMhlCZfmcRN3QJoHEUCqiRLGCpcF9cme1NOQ3PotzqSkBxJ02cjlsuqsdd2o1KmFbFl10X6
	/E10kgHT4bl3pX2SLJcl8BTF3ljy/yZADBcJB1PM523QTwFa1YIEI5Mx4cbhbuYlXV/qOkaVyRR
	mh8Xuye5cRDe7DamuhR4uy8IB6tRzhKRJwwW6cSV0KNoMYkgyDsG0XU6l1GDEeGX+Skz8W9EWhd
	cgZff4bsWFcVC799JF1QDkFTNHgnKbOTwKrIrc2lcNfVHdGhvv0S5GNioR2gLMIrn8rI2UDlk5D
	e39ctX85NbDv1XWoIhmIPyqBVCiJ1VAZNliMO3ypyRd8QflZdNab/JJirac98tPPVIEduwvzeDw
	b9kOqt0BfUaJB48g==
X-Google-Smtp-Source: AGHT+IGZy8B5qcY5omdqnsSW8uejd8MU/DWT1dZAEfS/f9Fb8Rfos0k20W7zR+hFEx57vClHrSnnPQ==
X-Received: by 2002:a17:907:8694:b0:b40:7305:b93d with SMTP id a640c23a62f3a-b50bcbe2701mr3007302166b.2.1760442218015;
        Tue, 14 Oct 2025 04:43:38 -0700 (PDT)
Received: from VyOS.. (089144196114.atnat0005.highway.a1.net. [89.144.196.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d8c129c4sm1150091766b.41.2025.10.14.04.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 04:43:37 -0700 (PDT)
From: Andrii Melnychenko <a.melnychenko@vyos.io>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] netfilter: Added nfct_seqadj_ext_add() for ftp's conntrack.
Date: Tue, 14 Oct 2025 13:43:34 +0200
Message-ID: <20251014114334.4167561-1-a.melnychenko@vyos.io>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There was an issue with NAT'ed ftp and replaced messages
for PASV/EPSV mode. "New" IP in the message may have a
different length that would require sequence adjustment.

Signed-off-by: Andrii Melnychenko <a.melnychenko@vyos.io>
---
 net/netfilter/nf_conntrack_ftp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 617f744a2..555ff77f4 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -390,6 +390,8 @@ static int help(struct sk_buff *skb,
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED &&
 	    ctinfo != IP_CT_ESTABLISHED_REPLY) {
+		if (!nf_ct_is_confirmed(ct))
+			nfct_seqadj_ext_add(ct);
 		pr_debug("ftp: Conntrackinfo = %u\n", ctinfo);
 		return NF_ACCEPT;
 	}
-- 
2.43.0

