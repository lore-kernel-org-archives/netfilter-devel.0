Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E493532E75E
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Nov 2025 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762268297; cv=none; b=Uznd9L4F57vD2gkFan5xp1ZXZ72GpQL5wt8PAtXXZUjtu8g9AdnEpOIf4ygwzcg4xY8Fbjw2qtHY/3jX3ZRXu1KE1egj7TPSg/VQ3mEarz8e7ndMMaA3k9RjtW2BgyB8hGN0PHrptsugTKAs0cLLGi8LyFMJYArq4F1QXppIuLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762268297; c=relaxed/simple;
	bh=inDzx/S8cSkg3dwC/uO23c8W2vRyNZzLVUHSMHmPaCg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uXDNQwyycnIfchZWs8tTSmNZTPXVYDn3h7eCh4U6hwWe3oneMf7lI6cwyu3jVgFdGVQuvXXSeRJdMnH0hFr2OsWRpTmTKoAHn6pBrG/3SDAuV7S+CdFFYmjsQ/DmNnxhvYZkIofcQYG5vEhCsCTS6n3Eloyq7AC+8p+kyvBsyi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=et2xYnab; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="et2xYnab"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b72134a5125so177948966b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Nov 2025 06:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762268294; x=1762873094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/l16ttdB2MK5S2rHLIiMDaDf51UWK0TbRnH8/E42ilk=;
        b=et2xYnab7rTSLTjjg+Z8Pg9S/HksYuq74Ev2MiNyZPZomJX6bSdv9i6vJW1EIMiB7H
         LcxwGzeFSbDhPkgfM/AzAFM03ZToydeScsJUJNAhG6LrkepAhay8FL/CcVJAoxk57yHb
         iSgKePHrMuFmx+CFhouuUT49Wx0kbJiYhS9OkIlwVbYS933qfWTZ9kMayukXOxN15IbP
         qawc/fA6WrLNfbG+ROgzPjEro1H3gb1bmhghS8+ucEbQcD+V7R0JTNcVD8wC+mZHGUH/
         ZN/T40cU2LlwoJ4BJhXgwXErz7QQ1EOXY1orB4ZJTgZoW7zf5jSD77BHg/B7OzvQBruV
         sSLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762268294; x=1762873094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/l16ttdB2MK5S2rHLIiMDaDf51UWK0TbRnH8/E42ilk=;
        b=bYOiBTmZMoGZkVueM0/q+WocZ9i+yBv6xmmDON6fscJb3RNHWhsnYQQi7GxL0/jjML
         OK366mXcWYddutFKJa5yLXTBBRD7nO7wM5LFIXwKmVpVGHcyi7bHva7bvDsVxcrJapee
         DREV5iuidpba7C2G4AkIPuvvMMbLF/U7sqPBuIxjmscXnaKz/MbXuFSmSv2m8Pj5J6oy
         nl8y/lW365SWD9X622wzR0wehVF0M4589KtNIiDfnOXOXoBXqjBwFVuZiC9sI2orR99r
         t96r6YBx85sD5cIuqiU3NHp686KNyS93u1ytf0dpa/Nr5CwOJ3UO6C/MDDABLReF3pDd
         MELA==
X-Gm-Message-State: AOJu0YzDCYrrOapxeKcCvyNHxTOkBCDexgR8maT75dgL8/WkXS8nysP0
	rrv5m0pBjIh9qSvIsqDgrpl7jgiZhxIi0rzqPgIpuIhX3vwvtdODu6l2
X-Gm-Gg: ASbGncuwQmlxqZtN+NnywGOBSrwBPjnGc/Kdvmsjj1fhbE7WY4kiBoZt9CK3keaPnqC
	yCI9vYZ6by9WsBtvcsBtYq5zXnXrmi9DUGGynkjlL6azL0HNpZrucs3N3pnFXrUzFomLrjohq8O
	xWtrpUz3pxDG4CTV674eQMoh/frgQmZRf6/G+PE7ZPIOpUu+hIQ0Po4v/DWJEOEjvToSKPpX7EY
	v783quwWWrSV0GZvY9Pevl8IfBnWskkExoF5qhd6IftGwtlnaiV8pDc/zjuX1dnhprc9QrI6wzt
	dC9qhTP6RDMwRAMZMDFhmZSZRd2r/0pj9Z4GGPYkuwYP/EEUDxkFhR+Pd6n80ivF2ipJrRwqiuw
	6M5ZZ01Da2Tle243KS1xNRUTpixvJL7+Ks10Qq8nY9Y4hQ3MTrxBnASU+WXQWs7Pn+0AlPTn56I
	ZkQ7aJ3u/DM0VI6tJjyPuRcTrsBg9tSbUSsl7UxXzriSor3GKa9LV9CKSwEQ8r4brNKg2PX67gw
	S+E36jLrA==
X-Google-Smtp-Source: AGHT+IFoBSG/LmTvbfsb0CiqfJ3IGEEn0aKFuWDCFW1M6Vz6/5HAUfuq0eiik8IrlE2I5ZwBHF/nxg==
X-Received: by 2002:a17:906:b00e:b0:b70:7e10:4f4b with SMTP id a640c23a62f3a-b707e104f68mr1269603266b.18.1762268293920;
        Tue, 04 Nov 2025 06:58:13 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723f6e2560sm232681666b.46.2025.11.04.06.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 06:58:13 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
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
Subject: [PATCH v16 nf-next 0/3] conntrack: bridge: add double vlan, pppoe and pppoe-in-q
Date: Tue,  4 Nov 2025 15:57:25 +0100
Message-ID: <20251104145728.517197-1-ericwouds@gmail.com>
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

Eric Woudstra (3):
  netfilter: utils: nf_checksum(_partial) correct data!=networkheader
  netfilter: bridge: Add conntrack double vlan and pppoe
  netfilter: nft_chain_filter: Add bridge double vlan and pppoe

 net/bridge/netfilter/nf_conntrack_bridge.c | 92 ++++++++++++++++++----
 net/netfilter/nft_chain_filter.c           | 58 +++++++++++++-
 net/netfilter/utils.c                      | 28 +++++--
 3 files changed, 153 insertions(+), 25 deletions(-)

-- 
2.50.0

