Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE5D217F31
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Nov 2025 19:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762716284; cv=none; b=mQDyIjYIUAUkIN1xyMu6yFOKLlZrgfouleAou7MwMmNiflVLYi1z8+zVclSsNErEPzDDod0JpfDnp+Wja+M6aBuIypoaTyLqkY8Xx8jxOJw+TbkhuBSpQ7coqfEdLq5LdEHJIWtRdUtQJg0QfXhlP02+Q/5wht01cmkHQPLgmo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762716284; c=relaxed/simple;
	bh=/E2065CYZGXfqGZTKvMv4TkgohZjDxfQeXejzHAHj4c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DyugGoIaLEniaOuD9GgyJYioHurpoogn0oBuSc44gu9dUe8wedF9uVzQ+7kUo5trODF8Xfahlyj3199wVMNRyL08n9+uuqcLLxT1YBvEaYyDJ0wrw/EHybUTfKLMSwmpC5Ya/u50NN4vSMmGzoPE4Nikhy9SS+2K8vLyK5u7YKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i6dTkOa9; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i6dTkOa9"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6408f9cb1dcso4007590a12.3
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Nov 2025 11:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762716281; x=1763321081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TIKKGAUxLaG+QVE3XjDCtS0yAOmsRVmTQnPpcMwaNFo=;
        b=i6dTkOa9gYlF3U9nMkC004x/rZ30yV9M3mv+6qYKUkatMfq9cbfHAXeuQFC3pJbnDq
         I2c64cZ+Nwwrm8sJv1RG6LGlPclmLc0iB0WmpwlXkSzbtS9P18+4oNJS7UVUOSaE3QGv
         Aik+ogNOsGEUq2CIbKHfaORZJYsBnThQwKid/zQdqtlxWapQfBeOAmyfS+F4uMxj1ew/
         o9OqtZ3X773yNKUonCgN+1vmBICzW0aqgkZ9Z2SwWCZQMbwBgABdkHrAVOMKk9nqaUGW
         63QLG14msXymsSCEE/gboDSEgcxomPVyKTPKdnj+0A/VS/B0p6bqrmunddtqrQQC0O3k
         miIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762716281; x=1763321081;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TIKKGAUxLaG+QVE3XjDCtS0yAOmsRVmTQnPpcMwaNFo=;
        b=xKkgtm363TMmQRbgPZNDzjZP81qgj5WGUvv6bsbNYYy3ASxFhconzJxS7piqbOyu3r
         6kdcOZEkAcAGZbAOYdfY7nV258+OqUOJB0ozcwlNbbV/YIIb4que/J1NyDkNCi8NCZk2
         G56zobKGuDKvm764QomMeKepXZfh1ObPHr9MhJYv6N+54aXioviQ/dxZ52LER1dw7W1u
         CjUgA2agD+AEJlVrKhJ3Ismjaovp29NQtvQa3bhtC55EO2xGZzXEha02RZ8DDu8pZmmT
         RahVuA1/7aH+9rJ7LXcNbNCxVirlQzX3z5lcG9dVZZCrHGH0AUQp3jYpi55JtUTW8jEE
         EGmw==
X-Gm-Message-State: AOJu0YzoU0IyOYaSuWJM68i/fPuTuSD+1N/96Aa/RD5kFfcVvpAXPac7
	O2/+sqaRVH4umqrOKkqM2TkPvR2saoex+wQ48AoBv1Zb47w64RiC8sma
X-Gm-Gg: ASbGncvq1Cv6N6MCOVWRJ9xMkQ5GQ54J80IBQsdPN6xJC9TOd52iq9O8oFmsFAlaMJk
	tDQhEsr4q/cQo8TXIqLtUQGL2pXhr3cAlFf0X2iemgiED3FYy3tdXV2vPDX6GVJa9+6iw6OS1jo
	WTrXNBU0iiD03Al6g24Wg250+PqbQEsdUxujCgJgGE+YySTL9DSN7KwwSfO3gtZyUdGYEeWtAyb
	NVXqO00Q1oWmMmu9rpZYbkPUZ/q448kUKjduz/pH6wSEA65v+xaf7+RXDxwC7J1Ik5WDbIj4uvH
	Gyuk2L0/TlcJo4WNNuq3g+AF0gHOQF+U+wBvoxDu8JrFIjLISwB2gquQ1UtSCCsL60+9tW/zBsq
	8+pMX+/zMDXG3Qj4+BtGJ57+HX9JJc6LqEhVOzRSF7vanJXH0OPNKIshuAetwjP8vrnasL+egsn
	TV1N+R9CC/CwCCIJQdyst9fdeNF0Vn7Y6VOTj6idGo0BPYiPEL5omWjYMsN5oaIhUOoWc1vFE=
X-Google-Smtp-Source: AGHT+IHcavlGRtCMXIYLReGyT/wu2uhwzR3CuuOMBLjG6pTiN0jeib0DEyX5FIv4+8BofcYcOeVwtg==
X-Received: by 2002:a17:906:d554:b0:b72:d001:7653 with SMTP id a640c23a62f3a-b72e02d62cemr545418666b.19.1762716281018;
        Sun, 09 Nov 2025 11:24:41 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf97e447sm919652466b.42.2025.11.09.11.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 11:24:40 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v17 nf-next 0/4] conntrack: bridge: add double vlan, pppoe and pppoe-in-q
Date: Sun,  9 Nov 2025 20:24:23 +0100
Message-ID: <20251109192427.617142-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conntrack bridge only tracks untagged and 802.1q.

To make the bridge-fastpath experience more similar to the
forward-fastpath experience, introduce patches for double vlan,
pppoe and pppoe-in-q tagged packets to bridge conntrack and to
bridge filter chain.

Changes in v17:

- Add patch for nft_set_pktinfo_ipv4/6_validate() adding nhoff argument.
- Stopped using skb_set_network_header() in nft_set_bridge_pktinfo,
   using the new offset for nft_set_pktinfo_ipv4/6_validate instead.
- When pskb_may_pull() fails in nft_set_bridge_pktinfo() set proto to 0,
   resulting in pktinfo unspecified.

Changes in v16:

- Changed nft_chain_filter patch: Only help populating pktinfo offsets,
   call nft_do_chain() with original network_offset.
- Changed commit messages.
- Removed kernel-doc comments.

Changes in v15:

- Do not munge skb->protocol.
- Introduce nft_set_bridge_pktinfo() helper.
- Introduce nf_ct_bridge_pre_inner() helper.
- nf_ct_bridge_pre(): Don't trim on ph->hdr.length, only compare to what
   ip header claims and return NF_ACCEPT if it does not match.
- nf_ct_bridge_pre(): Renamed u32 data_len to pppoe_len.
- nf_ct_bridge_pre(): Reset network_header only when ret == NF_ACCEPT.
- nf_checksum(_partial)(): Use of skb_network_offset().
- nf_checksum(_partial)(): Use 'if (WARN_ON()) return 0' instead.
- nf_checksum(_partial)(): Added comments

Changes in v14:

- nf_checksum(_patial): Use DEBUG_NET_WARN_ON_ONCE(
   !skb_pointer_if_linear()) instead of pskb_may_pull().
- nft_do_chain_bridge: Added default case ph->proto is neither
   ipv4 nor ipv6.
- nft_do_chain_bridge: only reset network header when ret == NF_ACCEPT.

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

Eric Woudstra (4):
  netfilter: utils: nf_checksum(_partial) correct data!=networkheader
  netfilter: bridge: Add conntrack double vlan and pppoe
  netfilter: nft_set_pktinfo_ipv4/6_validate: Add nhoff argument
  netfilter: nft_chain_filter: Add bridge double vlan and pppoe

 include/net/netfilter/nf_tables_ipv4.h     | 21 +++--
 include/net/netfilter/nf_tables_ipv6.h     | 21 +++--
 net/bridge/netfilter/nf_conntrack_bridge.c | 92 ++++++++++++++++++----
 net/netfilter/nft_chain_filter.c           | 59 ++++++++++++--
 net/netfilter/utils.c                      | 28 +++++--
 5 files changed, 176 insertions(+), 45 deletions(-)

-- 
2.50.0

