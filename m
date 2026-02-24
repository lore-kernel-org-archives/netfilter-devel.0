Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1717930506A
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 06:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771915995; cv=none; b=UapVzskIMom1KbC3jEuzVH323oY4kcJAARAWN1LudQYLGvDQSwCpfzc6CGzWQdtInmNQJL/YUj+FU6IWDyBM3g5AL+sjvl6hkpdmeCrz3kJkPOFbCTzfJQ0obZ2/a16jQlipdkj7aHAf8pWjejlrXarlf6vHpRvNLD/RcejB+CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771915995; c=relaxed/simple;
	bh=lP3kra2h8AICEkoINsLGhXhIuRHfsSfxRft5F4Y06uY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G1rHh92SXepSrt6jsibcWV7YNXl/+GaIGDgHx27dR1Kqvml694v/vHYiUG9sPgxPOYrJrMvqVbRRfTNs/mARTuxz2i9KNva5wvEw2M9A3wnr9w7Y4DTI1M3evgEdw0DYP72R3Un0Y8c60XoHiRlHJc+1Oc86dYecUNBaM687Kpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EA66euve; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EA66euve"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65c5a7785b4so7843255a12.1
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Feb 2026 22:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771915992; x=1772520792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zv3dlNi6mMAZcD4s6zkCWcTjX0AEel78U/A2n3eqi1w=;
        b=EA66euvee/okA1s/FCGDdkiZjtNziaI0tN7oh4S1XrTBRvIPLqkQxfzq7ve1+HDvis
         VYr11HYk32T2ps+XOTAMiJZx3Ir7Wt+7h3C1EHFOkQEGWBUAPKn2gR1gqscslcroLqsG
         UaJPwL5wH8gokO96M9OjATXqqAa3fJbw+DWgP/q6Y3WpNnqAdL4ZuQiJvNrRPxyu2eQh
         DkhsQk94rI60UarLTOP+JwoVGwcvF3UcGlFWsiuSXAizv2lMfQe/9r08bXlX17+ibP1Z
         tU55XKkIfZF5ApmAs1yJY3k5xlQ3OySBqe6ECRfoEbSpifhFPyLRyaYm+wo1dDENHkzX
         qKag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771915992; x=1772520792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zv3dlNi6mMAZcD4s6zkCWcTjX0AEel78U/A2n3eqi1w=;
        b=a8YaPZxNFv6EeyG1Cdj/nloPpeDU4nXhzF6VorwBI26Uhw/iXkos592NCJCe54YqKA
         InU06/aVkcUrzu8+MpAnVMkDb8DXi3WaUVT9Y9JG8Ixzv8vyrinf7Ql544r8mkQ1byw1
         CRR2SabqB9QcIbWxTpTetPKLBQzn3hYP7OHU9epjW2acXjmwizeEBZSqPfpSp6ks8TOB
         QILnw4U4asUTAqXxmDWJUUSaO9zcTEFrOyYCOhBh0IcLIX40giCXVbR7GMliuqAg4mOi
         O5dlm7yIh+mRdEkemByAWhYW8xq8WLGar8Gk2OmL6Hr4+GlNoNCzQn+Zutojjq0+Hb5o
         zF2A==
X-Forwarded-Encrypted: i=1; AJvYcCVhLEM5b0CGYShOWCEupFDtd+n1HsKE61PeK9XgYfR1MNMvzmhiF7ygMm+zqdk90CwtRaGvqJ98pYsqk1euyN0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe9NxtEVTTkk+EbDRmJmIta/6xx1ikk0LmOjGbBlVv/AohRgUt
	LqUsN5Vm6uUG/JkgQ31rtEFzC7nMTPcEfeK9KjcR09Mn+CncxqFXfNhM
X-Gm-Gg: ATEYQzycok3SyYQN3o3kRf2zYys+bOfeUyojswvaBJXYXm1eMVIHAa+rt+SlhCzSwFd
	CL81wXRVP9YQsRdWrumeXOZykwuj/zTMqnWnlMtUoS1cEhl9QzmFXwjlmEPN3EkXtwC+fs0RM7c
	TsqaxbNHPyucFAkZ1NqSm3lRx7tF59X+h9c1vDnfaD9LN7tGFsvmvbNlQr+qj4vSceFmyd235nI
	WtSSPwQNmXW0k/rKBAk8C/54XmKyZveiifTvBrn9rD0CaGNhCaRKhDbVQDYndSNnmyxdGx300JU
	xedPnluMhjekkhST5+0oXyfuBITyOXRm08HNiKGa5s49CpCefKPKOqQ5MoUP35Rv3LMAohN79k9
	B7xdKcR9xXuY5L7SWprtnDuA8recFLOZLUtsrQCoTWcqLXuwVjnZfekZfABKR0M1dR5p6nxEguA
	MwHlQ0YVVBg5wrwQrLTWlIgniDsX2x4DG0o8UbLCyBC+D5JhhJTwcxNTLEGdALlJ4xqdcze1lV+
	U1E0cG6kFnzuGMFMvlIX0i8/l4e4J3hdSUxYrIYr2YsWOSW3FMwQdY=
X-Received: by 2002:a05:6402:2346:b0:659:4b76:74f5 with SMTP id 4fb4d7f45d1cf-65ea4f06505mr7015657a12.27.1771915992251;
        Mon, 23 Feb 2026 22:53:12 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65eaba13866sm3096698a12.18.2026.02.23.22.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 22:53:11 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v19 nf-next 0/5] conntrack: bridge: add double vlan, pppoe and pppoe-in-q
Date: Tue, 24 Feb 2026 07:53:01 +0100
Message-ID: <20260224065307.120768-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Conntrack bridge only tracks untagged and 802.1q.

To make the bridge-fastpath experience more similar to the
forward-fastpath experience, introduce patches for double vlan,
pppoe and pppoe-in-q tagged packets to bridge conntrack and to
bridge filter chain.

Changes in v19:

- Add net: pppoe: avoid zero-length arrays in struct pppoe_hdr.
   (It was part of other patch-set of mine, moved to this patch-set)

Changes in v18:

- Rebased
- ‎nf_conntrack_bridge: added #include <linux/ppp_defs.h>
- nf_checksum(_partial)(): changed WARN_ON to WARN_ON_ONCE.
- nft_set_bridge_pktinfo(): changed call to pskb_may_pull() to
   skb_header_pointer().

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

Eric Woudstra (5):
  net: pppoe: avoid zero-length arrays in struct pppoe_hdr
  netfilter: utils: nf_checksum(_partial) correct data!=networkheader
  netfilter: bridge: Add conntrack double vlan and pppoe
  netfilter: nft_set_pktinfo_ipv4/6_validate: Add nhoff argument
  netfilter: nft_chain_filter: Add bridge double vlan and pppoe

 drivers/net/ppp/pppoe.c                    |  2 +-
 include/net/netfilter/nf_tables_ipv4.h     | 21 +++--
 include/net/netfilter/nf_tables_ipv6.h     | 21 +++--
 include/uapi/linux/if_pppox.h              |  4 +
 net/bridge/netfilter/nf_conntrack_bridge.c | 93 ++++++++++++++++++----
 net/netfilter/nft_chain_filter.c           | 59 ++++++++++++--
 net/netfilter/utils.c                      | 28 +++++--
 7 files changed, 182 insertions(+), 46 deletions(-)

-- 
2.53.0

