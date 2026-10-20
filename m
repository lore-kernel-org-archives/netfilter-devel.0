Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792454630;
	b=sdzab64nPVRGfWQN5AuWPnFvFFdEAFSty8GQvwN4HEaxGIAtHlEFE+07K34RlpuDHnTb
	 S0have+BLCV01JAsx3PHETaVJGY7B0OwjJIQITE2+AXHSjeb68XvwDFl13q801uVwhfTN
	 Tmd9yD98WqqlDKllsEaiGbc9nXTGLCzVam5aCzEr9GXilPAILNp+u/6g1hEIZbQWSlUdW
	 ysG5vCoZ4I20ySelyL504yphik2ifjs9iIkHAvL8Ts+qC6K6Hc4DBpiKpcO1jVDNJHUhb
	 mqhwksQiN+sM7+q9PE5ZTqF/PtDGhyZKKh5VA5Lwe2gdMeOoVZbtbqrSu20BO8LCkaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792454630;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-ZohoMailClient;
	bh=rMhii++LuIz1+H39a3LBlswVbxuJqVt4fJ68I0eVunI=;
	b=xiXCyfN/bVEYroz4+BHpmi3fRSqvF6NjrhzftiRT0inOTYKGRr5ZyCnt5mNiSNVGdYRY
	 +rOmjHyOr0N1YY0Rq5vAYI6kXrNtOHhudKfpU1izCMBZVHFBDoxfY5WADoTyiAZbKmmYz
	 Z21eBFM7kP7jZjyKFXEHlj+g5jGO5vanruRjFcAQPYzLfbr55mGrQLMuG+5nLQcSOn/LW
	 7Ac3I7aYaihlFDeMjiOv4fqe+l9O8yC7zQ6A68L9mLX5foqT5X+RsegsvRvEHtM27PVJ3
	 yLD7R4k3lIFWW13UiVikhqeO4QkTz2jFDAYh69inXDpHvunOg59KAjbG/7kY3XOImSg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=laveeshb@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=aVn6BzjF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BC4606A319;
	Tue, 20 Oct 2026 00:03:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3BC4606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=laveeshbansal.com header.i=laveeshb@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=aVn6BzjF
ARC-Seal: i=1; a=rsa-sha256; t=1792454595; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=JOFe4dhvskZmPNBkKkp/GIEuU+shW69pc6l0shMYMffCKlVYGquv7+zb2wt3YGXtlaFqC8052FUuN9DC1iIkq68O4Qq5y8SsxEZmpnSWjTYwNxmC1hMxHsEzgIakAiOygIrZw3R/vCEmQfMwUL37FyNamCsbDiKg52OfSJBAej8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1792454595; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=rMhii++LuIz1+H39a3LBlswVbxuJqVt4fJ68I0eVunI=; 
	b=Q1hqFp0zx/Fn+P8KxDPLDZhB+mLO5kd9GKx8qEA43dXZzDdoHfBXpKcGsgf9+R5sTBgR1Csny0GZqr55/8D3PohccXGutqsgXaCQEAOsQubJD68CdjWNqYn6SmPTVvK52O8aabA1/bbp/UCsq8LR7fHC0cBbA5gE6CpuvdfmHik=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792454595;
	s=zoho; d=laveeshbansal.com; i=laveeshb@laveeshbansal.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=rMhii++LuIz1+H39a3LBlswVbxuJqVt4fJ68I0eVunI=;
	b=aVn6BzjF/VpAUGRzbSLjwfIa3aFmTBlzVs55kiGoc9P61ziz3rgW9UTCHOn3kYmV
	6dVN7P2ZwNQqxiWSfhxqM1yVRyZyQxnMUR8sDRcM0qWg4r9KPzdZgNkiSwKQQs2J3+m
	1/sxM+7msnlxDYnSwSKBHRt1gOVtUVrK6uaDEyt8=
Received: by smtp.zohomail.com with SMTPS id 1792454593922169.64375551083128;
	Mon, 19 Oct 2026 17:03:13 -0700 (PDT)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH 0/2] netfilter: bridge: refragment packets with a vlan tag moved by the bridge
Date: Mon, 19 Oct 2026 17:03:06 -0700
Message-ID: <20261020000308.37362-1-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi,

This fixes the syzbot report "WARNING in nf_ct_bridge_post":

  https://syzkaller.appspot.com/bug?extid=a8ba738fe2db6b4bb27f

It has been open since November 2025 and has a C reproducer.

With vlan_filtering on, a frame whose tag protocol differs from the
bridge's vlan_protocol (802.1Q on an 802.1ad bridge, or the other way
round) gets its tag moved back into the packet after bridge conntrack
has defragmented it. In postrouting nf_ct_bridge_refrag() no longer
recognises the protocol, warns and drops it.

The warning is only part of it. Fragmented IPv4 and IPv6 packets through
such a bridge are dropped, everything else works, so it looks like an MTU
problem: a 3000 byte ping in an 802.1Q vlan across an 802.1ad bridge with
bridge conntrack gets no reply, across an 802.1Q bridge it does.

Patch 1 skips over the tag in nf_ct_bridge_refrag() and puts it back on
each fragment. Patch 2 adds a selftest for it.

The Fixes: tags in patch 1 are the initial bridge conntrack support and
its IPv6 support, both from v5.3.

I tested this in QEMU guests on 7.3 and on v5.4, v6.1, v6.12 and v7.2, on
arm64 and on x86_64 with KVM. The selftest fails on all of them without
patch 1 (the control passes, the six other pings fail and the kernel
warns) and passes with it. The frame from the syzbot reproducer warns
without patch 1 and does not with it.

On a kernel with KASAN, lockdep, DEBUG_ATOMIC_SLEEP, kmemleak and
DEBUG_NET the selftest shows nothing, and neither do packets whose inner
ethertype an nft postrouting rule rewrites after defragmentation (to ARP,
and IPv4/IPv6 labelled as each other): they are dropped without a warning
or a leak. It builds without warnings with W=1 and CONFIG_IPV6=n or
CONFIG_BRIDGE_VLAN_FILTERING=n, and checkpatch.pl --strict is clean.

A tagged egress port (hardware tag together with the in-band tag), jumbo
frames, and br_netfilter enabled together with bridge conntrack were also
run: all fail on the unpatched kernel and pass with patch 1, except a
smaller egress mtu, where the 802.1Q bridge behaves the same.

Thanks,
Laveesh

Laveesh Bansal (2):
  netfilter: bridge: refragment packets with a vlan tag moved by the
    bridge
  selftests: netfilter: add bridge conntrack test for vlan protocol
    mismatch

 include/linux/netfilter_bridge.h              |   4 +
 net/bridge/netfilter/nf_conntrack_bridge.c    |  43 ++++-
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/bridge_ct_vlan_proto.sh     | 182 ++++++++++++++++++
 tools/testing/selftests/net/netfilter/config  |   1 +
 5 files changed, 227 insertions(+), 4 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/bridge_ct_vlan_proto.sh

-- 
2.54.0 (Apple Git-157)

