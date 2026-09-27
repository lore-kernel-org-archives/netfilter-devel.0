Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E38C54704C
	for <netfilter-devel@vger.kernel.org>; Sun, 27 Sep 2026 04:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790483524; cv=none; b=KRJM2Yu6xYsQn2DilOpkN4VGEiohxhhJanQi1bey3bmVI1H8oKxKlM5nM5Cpv/oCv5EML54CRftKJglz/5Lco9S0MaXpNuUpDiUcNHG1IO2lAZpigcQ4xQm6ogznjezcWB7lutE9RVnYBwOGFGwMej8IoNY1QiDg7/hoa3jREMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790483524; c=relaxed/simple;
	bh=kKGtxVUKPtQ0j31gyrV1yVNdSd0n7CPMai1BfRcV/zI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O038y0JXNfw8hUfnW4sUSFzzLYVV2sG7VqoOVCCWZeQx3iM7xyHSGsY6uH1127CrTsLQ27VlVv3RTyzqf5MTxJvAeVuvm2g7+B8y9hJ8X1UhHaGc32KjkYzoGOkfyEKpVZUm2iMRaZYJWWa7CEOMKIg8hImSdDjjACGz2s7eBFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=KEc4xjl7; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="KEc4xjl7"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccb1a98fso1544117a91.1
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 21:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790483523; x=1791088323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OwbJ4pEmU8P1v6WkKeChtnGUndufDFY/6HPdG1aruyQ=;
        b=KEc4xjl78+Wh2Xx2cfIlDjPh0MLb+Q6051xzCn0OOXBn3DmpF1SFPYhkJpQSzM8jqy
         grMx+LAN1Q0TtF0Z7G1adWcf6Uj25qsEnq+n85DCPEMoMYChBX5Hr+pMD3C61iCKtDod
         eiufpALaFW5hdpwQ2N7iLoW8VYS64SEQo4rHeh8Sugi3WrlLewSRlPVT4O5f66f45uyL
         zQdytsYOi8wovi/yd74d9y0BnXDj2hnsYyjNmSZTZo43ueq3kJnU8YbbllOefm/5KcFW
         ox6LeFfKG3XeggTOk0sP49S+NkiCML+8UZ+SnNYNapotKJz9UM6ZcAmBAOr2JkrScMCe
         MfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790483523; x=1791088323;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OwbJ4pEmU8P1v6WkKeChtnGUndufDFY/6HPdG1aruyQ=;
        b=r5hGUJne7gqgmQkPArMlLtSdPvUImDRrOyWPOhI8ULdyaPxNHj9I+4hqMkjpS6QyrS
         UahaysX6tmgZwi1gMAUPqzsDdeef8Ik04mpi4oiOddudYcf7V2XkOnvlrD3c4fIwgcAa
         yX7g6eCM8tipqdIx8jthO9B7IM4EOKe0YUSPy4MOn4CwTl5NxePZX97SPB3gWZKXgWy1
         fF0dzLWQ3i1OTRXeBQ6miDoX7cs6ulCJN7ZgoCTmUnxKV29tC6ujllk9HcUx/O5Oojac
         NBlT8xueinxe7GfwZKGbg9BGf22L53Y2PGaCHUiBviS9UXj+7cUac6SZTqhVLZCjxX0+
         7H8w==
X-Gm-Message-State: AFq9FYJPOJGptW7HfECK7+53CuTLs349iD6nU2jWe908yrUNuHmikIb8
	j86hi5hh75aahcRr3CO+n/uRxIT7lpojbkOMadDhFtd4IcmrehXpzVKOyjIw3J9cmVhJkpvG5lR
	nC2zeJFqD
X-Gm-Gg: AYBFou0dr4HpIae6c1Bt8UASuxN6ssNBc+a9+/YqWWYH2DQdeLoJmOhWnO26Dgq4MxV
	XA3+WrgTm364TinwEwjEVDkF/7RmdiBP66ACUDkpdunUFfNWZEtweiq8uVLHkyW8f4/diZ/h02j
	bl6Z8cHHPgwMkD8D/3rQDvc33c6msCxb/S6LUGRqo+OCiURKeT9nVQD0B22B94Knrc0t0YiaZRH
	npRNKsMkb80jzpnHG6APJxIpQZCAv2bhoOXlplzxYD5m/DB0Qt0krKurlEiijHk5rV7jCXMqSB8
	sVVonvsHaT0nfhKRvTmF/0yfZzP1xSMbQ6Hk+5bfINNNgk43HMx8tZj0fiVJJICeBIjai74iSul
	bTDfN7Jk1qy5UorcoMK0laGYdvedhhaq1B5PojYjuvbAIP2df2YpoiHFqWh04ztuhEN5oy/teMk
	yxOa0lhN/0UrkaQp5aTctpgddBiDiebI/UP52tzeGKN8E/Ej5cTtj+t7D1/otmAmsJA6nvzegI4
	/Nck9Pl04y4RGR96IPqIlimWWOu/A==
X-Received: by 2002:a17:90a:ce:b0:3a0:4146:2955 with SMTP id 98e67ed59e1d1-3a0bb6596f3mr3377478a91.61.1790483522629;
        Sat, 26 Sep 2026 21:32:02 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0e05d674dsm2795629a91.4.2026.09.26.21.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 21:32:02 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zihanx@nebusec.ai
Subject: [PATCH nf v4 0/1] netfilter: x_tables: avoid holding mutex over faultable user copies
Date: Sun, 27 Sep 2026 04:31:38 +0000
Message-ID: <cover.1790439054.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

This patch keeps faultable user-page accesses outside the per-family mutexes
in the legacy IPv4, IPv6 and ARP x_tables GET_INFO/GET_ENTRIES paths.

v3 Link: https://lore.kernel.org/all/cover.1789885804.git.zihanx@nebusec.ai/

Zihan Xi (1):
  netfilter: x_tables: avoid holding mutex over faultable user copies

 net/ipv4/netfilter/arp_tables.c | 49 ++++++++++++++++---
 net/ipv4/netfilter/ip_tables.c  | 87 +++++++++++++++++++++++++++++----
 net/ipv6/netfilter/ip6_tables.c | 87 +++++++++++++++++++++++++++++----
 3 files changed, 197 insertions(+), 26 deletions(-)

-- 
2.43.0

