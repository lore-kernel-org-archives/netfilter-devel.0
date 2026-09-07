Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5B43CB554
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 09:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774770; cv=none; b=DnFlDOs6auaq9WWIipsbNXUDZIGVuV3ZuxZteJA3X6eTemVDocS/9bsqDSK40NH7PVlAX1JI6UtWL8Vj8b5QcVSAFzeV9yyy/+gYstUL/ToASlf53mnfjRnJ6bEkw8V0cB/BNZcSLYdPezHnL7zizHnugHmNfrHAJuJVdizgWao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774770; c=relaxed/simple;
	bh=cqlFSrgeVcyAu1DwjM5N2nW2E2ZNBwopzV3zyer3On4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KpbngPtov79LJwsm9vCn6IPsoWgo7Dnm/ZD3mkI5h5hXfiL1Z8cVD3Kq068VnbUReqqWLx5YxiheKSzJFsg51rGjn47FNYkGKmyQmLEJiby4lb470dRbN9yfxbFlzrb+Z1iiZzMsXvu6NtAmPz0nKqM9OB6uQV46Ul/AnlSCkpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bjLwZjxq; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bjLwZjxq"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc1cf287ef8so2904356a12.3
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 02:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788774768; x=1789379568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iLGaza3s6F5rgIQf4Pq3PulD1HjtmOc+h6lAEkmWtfU=;
        b=bjLwZjxqs6MoH7uIcpsGHtDVI9kXVStsDfRBRRognSb1JCxLQh1n+wyNUtlKNwyVSa
         1idNSCcz7PUMJARA9h2KsWv/MBgaEFd/+dysIFEPTwPya9ALc8Gsvd/96xSUyvJ0zhxF
         254x1gKhTc9mLrUsS637Wwwpi5P+ZF9MNZX1nByvRUMX3kzi2nuZABbGGoArtAnZQlTT
         SXwY2sW0z53WVUkgky+Qb2JSLa01zfegGOCo8Zu9x0uKxiZGp2lcwBU5ZNRv8WjgLzX2
         2s3YT4mKFyZq9nPpcGe51v+MJa9x8+EJmpf9Cn8nbMGv82qIXBYOWZxQ89fbHYiBTq5S
         jIKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788774768; x=1789379568;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iLGaza3s6F5rgIQf4Pq3PulD1HjtmOc+h6lAEkmWtfU=;
        b=aJTDcZKmDh/9DTYWYYjpP7El4AFyTGC7d6q6YLTSLXMf3c89kMXhths8SfW3fW9B8x
         fZNE7cZHIRfepjuv+IT3mniGTbkvwFGERRYFYjNBCPEJ7lECl6yX5/yf5A25w0JdNs0r
         2aRnvYcs/HI7qbTIl4gDhC1s6K031++79z6zyRTX+y0eqKQ7BjoCfJzIJWCbECB5KIO+
         zyw0P8QmGq+Hd6JzSXaPHRYfWoi1zLTPopuvXtm3oon//YeU8kRC4uM3srPZUAXqqORw
         P7vY1sqjVQv8ix2cHsTVQ1Ev8HbvSILJqdCXoLzYcsltU18JpLYOw/inBZYuxI/N0SCM
         2YkA==
X-Gm-Message-State: AFuF++mWjwd97RV0zlLTTXICTVcAng62K1D78g6QVOOO0P1AQFUIE3mo
	bjyofRZhLtd13XsRr4SrE5z5vfAyOLMRT21BXRLSeHRI69EImivn09dqB0hgCEVa6l4=
X-Gm-Gg: AYBFou0Cyq3ibKCe2sWdQGj+TOWYr/LayREq60CMi4KkqueVCTyY73EGucevSx7qmXS
	l7fFabpQFkFe22uOHCIUKzPq1sWTZvq6rLWDrOgy1xYBuwBj+2eShF/vgS654aIeERrk/abfO6Y
	G3ImN1SILUeCj+7e66X9ag6frlTal0h8Dn1Cvu0Aw9d3OtdE8MEJGd39qqm3DDHu+ZNgCZdVz3F
	nI+IKwcDsYu0gkjsCBm5WnVTaqkYBYuHY/WtZCtnd/8XtjkRxffuM6xgX8CvassD+aJh1oJPz+P
	nIUKpJ62B2zcj1GdSIsBgOwktAot26RsN9sfuTdYo6TfEsqKXecukiLvy7DOBptC8vfWIdM690R
	pV/cTbkbXKegzaacJRqtrgWXvPtw9ECEhCic6tF/diC36b3Ameh82xx58A8yo790QerjJ/CvbEc
	aEqZBlos2n1G1FSnP6/CtKQU+9kmn/f1LkgUotqWAplNciJEj5sonHJUoFcgu2DQMM76b1TK7h1
	rE7oimcZGOXAylWP1LSlay4
X-Received: by 2002:a17:90b:1d52:b0:398:dcef:c040 with SMTP id 98e67ed59e1d1-39b26242a20mr34261880a91.19.1788774768453;
        Mon, 07 Sep 2026 02:52:48 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14332405e92sm18924258c88.8.2026.09.07.02.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 02:52:48 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
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
Subject: [PATCH nf-next v2 0/3] netfilter: fix typos in comments
Date: Mon,  7 Sep 2026 15:22:38 +0530
Message-ID: <20260907095241.24441-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Three comment typos under netfilter, split one per component.  Found with scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Comments only, no code
changes.

v1 went out with a bare [PATCH] and a "net:" subject prefix.  As
maintainer-netdev.rst asks, v2 designates the patches to a tree, and
each subject now names the component it touches instead of "net:".  The
series is rebased onto that tree; the diff is unchanged.

v1: https://lore.kernel.org/all/20260907064239.39910-1-hemanth.selam@gmail.com/


Hemanth Selam (3):
  netfilter: arp_tables: fix typo "alignement" in comment
  netfilter: ipset: fix typo "artifical" in comment
  selftests: netfilter: fix typo "adress" in comment

 net/ipv4/netfilter/arp_tables.c                                 | 2 +-
 net/netfilter/ipset/ip_set_core.c                               | 2 +-
 tools/testing/selftests/net/netfilter/conntrack_icmp_related.sh | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

