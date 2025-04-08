Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DBE1CCEE2;
	Tue,  8 Apr 2025 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122395; cv=none; b=Yltupl4GGaDwBB/JolUQvuSxtw+u3UF71VshZBgmamNmvB6WPob3fwDGP66c0MqDtHxOr7ZltivSQINAQAzrU1nerLKhqWCtxE9mIWabJzXFj6en0KQI59evstnr9ocF5lC/La/Vlj17cqmYVT7Ic5+jPm2IQSJdaUWSmV5zTgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122395; c=relaxed/simple;
	bh=l+rq4i8J5Ngw2JGG5LfWtQw/3Dy/KRpSN3Qn/Hiz+sg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pHtVb32b4F7QFoqK9cqKMWoR6xrDuARgu/LlKNtAGB6KhvSrMtlY+ybYyNMHq2oT9HEdIW3GwYEPAfnQkTgHX4qt9+fqzGh9GNQN9Ji/Pgq0ofM/4bZ6MI5741BtWAL76AoH7OYdlIXVwXHoiEROphLfbRi1HFO7ZhXfuihN4BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CPfErlG8; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPfErlG8"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e61da95244so9320325a12.2;
        Tue, 08 Apr 2025 07:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122392; x=1744727192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nXIabCjmMZX+FDkTq1YmGQSIJSKoWD1ZNsXqU2bqHAc=;
        b=CPfErlG8TaXPGVYuKYg3Ya55Y3egeO7OgAZ4rPTX5zhBmu+lkgVK+aWFKsEtZ3p7tS
         VQJhyrQBBoMmFmQXOeV1aL2S+VQ/Q0gQZcSFFiCslsEP3brZpeat0YPZqjDsK9Vu4qHU
         nRSFVsX9Gt/J41afjF4ji7OD37kqduUMwv+tbhacb78L0bkRAjo1QROkcq49YyNYgsWC
         eEVR7j8PTEvnp7cBCUIc7N1ForSKC+GCeiXKq011vNpGzovOzm62LaAWcfb2Of/NVK4H
         21ITY9dcWseaduQ8Mkgw5HrkhaSxrkQejPDmLpyaz2DMgJv2u1isBUVqFa1AtCihe1Z4
         Dq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122392; x=1744727192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nXIabCjmMZX+FDkTq1YmGQSIJSKoWD1ZNsXqU2bqHAc=;
        b=UfwKUQLh+GEXLi6jixdyIO51ER+hSdQOAb9dji9BlaYqFwpQQYNuwuRidP9cXrky+d
         b4zFwr9GLIsXu/IfGV8UadYyWQ8h+dcTaTOpX17xHavWHJiHe/7G0p9lk8rTxZ+k/Jqp
         pDznmRcAiHcb+OCUL7CcIyPM0BhfQAWXGWuBTbK4sohOXI+QYLAJJgmlX/TcnDAZz+xY
         13Yk3lobcepFREXGoYbhrxRE/AJKSFUd/+Q+VBSFMa4zWMzqvRbm/uvdSwkpYhTpk27H
         1H8HME5vxeXgFJ55r0ZGu8edJdKhZDDGndrFL44BixDsNYhfpTWwyJ7OF/c7R8gON1Zq
         6DLg==
X-Forwarded-Encrypted: i=1; AJvYcCXcU4awRMVgQQYvrajmi17j0CX1IojnLrEoFHnXuGYbiwM6kvtjKkwy9YSHNssnfwN4n6Yz7wY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxowyvGopas7kSWrZ7gsIN6NGkbZ/K3EpG72YMViIz8PyAuERJr
	OCRpDoXigf4fnZoEWKg4kl/+QiMU89Ftsv4ewAvjo2cYnuvv7KmH
X-Gm-Gg: ASbGncsT9+8qQaem2d9pbvbYZFNXmNg0z86sYNLJ2PaTpZrDhcq2Dq4nf+t6lGz7Fjx
	SA9jNIU4V9//M3rzPcAvoXvjwl1gVN9N349UNOM3GbFFh88QsNczHx62UkJizBjDlNw1l/ed3GK
	JdCwpmdkiHsFZhRWwU0ZL0gTITo1sI6OM5iIpO/y6ac9y/xMIhPPAG9JT3NmODZJGUAosg6Y7eX
	GDztBpyM6YStvVgAgt+4DUvUpPjb3wKHdZwOturqOVKHGF9V5byUV0XrVXfwaTiSnCBRR1eAj+W
	2P8s6chF5SAc+0a54DPuVuEUJ+8FEGbRwx3ajhKPk0PAS5btfW9C0kl2ZMJ6Z/bVXkSFTkerPES
	mg2U9nkK+r7HvpBqqFoi7SeGe6Fr5+TvK4cZNCb9zfDf6sGkLIpiHPNWpuah97ag=
X-Google-Smtp-Source: AGHT+IHhJGLMZljze0+v79hLavxELQKwwnzzaeNKQU7oqe/wMLuyNCH91Efq9UB9Y8f+2RQTaGEw3A==
X-Received: by 2002:a17:907:2d87:b0:ac7:391b:e68b with SMTP id a640c23a62f3a-ac7d1c1dfb0mr1456005766b.61.1744122391898;
        Tue, 08 Apr 2025 07:26:31 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfee2591sm926664566b.79.2025.04.08.07.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:26:31 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v11 nf-next 0/2] conntrack: bridge: add double vlan, pppoe and pppoe-in-q
Date: Tue,  8 Apr 2025 16:26:17 +0200
Message-ID: <20250408142619.95619-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conntrack bridge only tracks untagged and 802.1q.

To make the bridge-fastpath experience more similar to the
forward-fastpath experience, add double vlan, pppoe and pppoe-in-q
tagged packets to bridge conntrack and to bridge filter chain.

Changes in v11:

- nft_do_chain_bridge(): Proper readout of encapsulated proto.
- nft_do_chain_bridge(): Use skb_set_network_header() instead of thoff.
- removed test script, it is now in separate patch.

v10 split from patch-set: bridge-fastpath and related improvements v9

Eric Woudstra (2):
  netfilter: bridge: Add conntrack double vlan and pppoe
  netfilter: nft_chain_filter: Add bridge double vlan and pppoe

 net/bridge/netfilter/nf_conntrack_bridge.c | 83 ++++++++++++++++++----
 net/netfilter/nft_chain_filter.c           | 37 ++++++++++
 2 files changed, 108 insertions(+), 12 deletions(-)

-- 
2.47.1

