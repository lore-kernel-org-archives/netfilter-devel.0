Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2903596B;
	Fri,  4 Jul 2025 19:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751656332; cv=none; b=SIzmDVgZj1kYLg+SY1HADL91C8EHYxgnPM/6silGMg3ryDfMo0qaxTDvnJaHRMZ3/lfYp0/bLLtioLHNnTBGQaXeKob54B1YzXjB/c5lsEmL0LrkMtOB1fE6at8VJlWX9V0Cy926XxT84uilNrF97388E9sNRnVVmoVCUwFxRUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751656332; c=relaxed/simple;
	bh=gGLH/JlKTyA6/p/VgBdxmkkBmO8oVKYwNmqtLQvoMnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qXc0noYXHtfJYfi4EdThgr0fGeTlCxJ9nePVZkknX5mkujXz6pJffvCd1Xs9O9Xtuo+IqQ79YCx3atX/8MBl1bJaP8JDw0i0mKIQUBjJ5frOuqa5vJn8xtZtqh9RGlq9oCeHsKBuBYay4eYAvTLNGoV0LIHPXxhNCA5MLmJPuiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lYpNp0Sk; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lYpNp0Sk"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ae0bde4d5c9so235230066b.3;
        Fri, 04 Jul 2025 12:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751656329; x=1752261129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=arcq/ErtOfcFvfh9otQX41x8yyrUNGvPRfyCCfAn7OI=;
        b=lYpNp0SkR+B6sOMxGxPbuKmnEYFOY1KcJ+okddYVoiNTue19rdqQDqAllb6krb7PoL
         PAvqnJ70/ZlCyIRIaAc78Wgvcr9aTLS4KHgcVJbBwIbr2Ez7320SHWCZPxpsE/R2YN0L
         mKPaofeDxbQpLDhWaTn2vn1YBpEjYRcIonh4IJYqS5VkZggMBgQJ3peC7ONfs9OlAhAi
         baGCJT7uQ1rbgBxi8avF4LLqwoo9QQ2b9mTu5LlE6gh1ltiEJtWrNRrzlIIiJn+dqyuP
         3CDN6RFfLtHftDMQv0KegN0oW6IQ2vdql3AVlhh90xlRoHgx/X5BeemgdHU1Q/lM/1gp
         jtHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751656329; x=1752261129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=arcq/ErtOfcFvfh9otQX41x8yyrUNGvPRfyCCfAn7OI=;
        b=U3OnRcl21k5yzV70lhF38AL57whNbIJz6g8YWBLq3SFu58pI6jQWyNC/gdOq3kJAvB
         C+635BT3sENG51THXDIjOpCmj67nGfOHwqbXB19kYllIOuK01v81GkPDmfqBn980Exsd
         p4gbZMkbFHHCCakasoPaBb01a4TFEvyNg5dRuvdc/qwj+r0vzSGbfCYaf15r51Bq6gr4
         AYke8rSRpEYGfDHnRW98852r4ZPMRcwFqayMa6YK4yo6eor9yUYnJ+83O3AYTF2w35A5
         CrwhrU+x6jyAA2BMu+3HyMVZjYlER48tD5CW8vt8UPHtc5sdUU/dYBAk2JznA1cs94kN
         ozTg==
X-Forwarded-Encrypted: i=1; AJvYcCXJguxVTYBjwsnHd3jT7yAiqb0sjZQsVJcxghnIdviNXJ5jLIxb2SyX765KM8vDmdhvgvkQ2Y4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3fmaynmIY38K0Oo0qQG1uhkpomdxwotoabNiLeeftHC8V69NK
	GH1iB/S6tOJS7QAcZ9EZFRsjyGS1L26caO/DANoT/dWLgBCiyWmeUZe3
X-Gm-Gg: ASbGncu8GfVPU85ekpQ+Nqr9uuCi56EgydivZfAb4p1vRaoBZuVnT5IGGMzxIRPKFQn
	L900QptC5v4qvIummmgJG1LpxkUSYaWdzRQWuwPB7DgJD1ifz+twxW7datONczzOCi/bGjC2PLK
	JlYmAO9StND1wGO6ReeuNYO2bAvuqQTuibI11JfuR4RK1gotd9PkKcmaKZJnzJc0c0xh5fiqS7o
	3c5ejVLx3d7fgPvIw3orjopkhW5HEJV5JI5zmNqROCWV7XOR3WZrx0ws6etRR9b33Babnc+e54J
	Uc7688kj2OU/tVf6YmJy/r0Yyka3gSD7lRtddv9WfKqzVorw9n4Wx6VeoNktho+jJsu96OtLhpR
	kzYOxXxP8JUv+JqtoFkmh6tthJR4JtoZmHBOC3AozVQ3YOdxf6r8x5hNkgUisHjgYdSLtUEgRIZ
	Mp698i
X-Google-Smtp-Source: AGHT+IH6Wy6t35yxZwdbREf2KP8F/vMkR0pCc84m0GGVPeJFvjbmyJnNONYiLqB7H1xjJWBsRk1v+g==
X-Received: by 2002:a17:907:e90c:b0:ae3:5887:4219 with SMTP id a640c23a62f3a-ae3fbd49cbdmr332139166b.45.1751656328560;
        Fri, 04 Jul 2025 12:12:08 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6ac5fd7sm219476366b.103.2025.07.04.12.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 12:12:08 -0700 (PDT)
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
Subject: [PATCH v13 nf-next 0/3] conntrack: bridge: add double vlan, pppoe and pppoe-in-q
Date: Fri,  4 Jul 2025 21:11:32 +0200
Message-ID: <20250704191135.1815969-1-ericwouds@gmail.com>
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

Changes in v13:

- Do not use pull/push before/after calling nf_conntrack_in() or
   nft_do_chain().
- Add patch to correct calculating checksum when skb->data !=
   skb_network_header(skb).

Changes in v12:

- Only allow tracking this traffic when a conntrack zone is set.
- nf_ct_bridge_pre(): skb pull/push without touching the checksum,
   because the pull is always restored with push.
- nft_do_chain_bridge(): handle the extra header similar to
   nf_ct_bridge_pre(), using pull/push.

Changes in v11:

- nft_do_chain_bridge(): Proper readout of encapsulated proto.
- nft_do_chain_bridge(): Use skb_set_network_header() instead of thoff.
- removed test script, it is now in separate patch.

v10 split from patch-set: bridge-fastpath and related improvements v9

Eric Woudstra (3):
  netfilter: utils: nf_checksum(_partial) correct data!=networkheader
  netfilter: bridge: Add conntrack double vlan and pppoe
  netfilter: nft_chain_filter: Add bridge double vlan and pppoe

 net/bridge/netfilter/nf_conntrack_bridge.c | 88 ++++++++++++++++++----
 net/netfilter/nft_chain_filter.c           | 52 ++++++++++++-
 net/netfilter/utils.c                      | 22 ++++--
 3 files changed, 139 insertions(+), 23 deletions(-)

-- 
2.47.1

