Received: from out28-173.mail.aliyun.com (out28-173.mail.aliyun.com [115.124.28.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551F11A08AF;
	Thu,  8 Oct 2026 02:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791427563; cv=none; b=SpSn7Gby7qNHXGLWiUKDLE2NsLbUCca1wVDm6OQtgEhkrmgyQBQa8HhAzA9z/KomnDe/mLOTlj7tznQHhl0ZLi2e7kILWFeNDNGIfST3/MbPiyh9/HfKJQU85eFDx3eTQaZFhponJomvrekO7DQLjFfO5jAbi7ufEqD6OVlHJIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791427563; c=relaxed/simple;
	bh=UfDhaCDDMm7kAZVIqt+mVGPSLmZKVM6WAVVA2x99/M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MT0zWSMOGgqaZeja//OPnruLlkVON4GQGxGTDDCS5PnN3iQEi851SKWz0hkcUHx5qjperBai8/ca1FByg4CAcYE+xy6074DRiUHQTrpSJj5sipE22vRuvMWd2AhP5/xHri79HZRcUmkzT6Qai5b/6D3XEqXxJtdIc3o1XQuHTuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=B7bGeyL0; arc=none smtp.client-ip=115.124.28.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="B7bGeyL0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1791427552; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=lI1GALVEJrn/SwrfBIlIqj+oyWhvCwuNikjGXJLM/cc=;
	b=B7bGeyL0Sjt9ituliz5YB4DxXk1uRUCnOwYwbXchZEESertJtD1cbQPeQsY1qG+BQ+60OMH2TjLlthgQWCGEMbQHm/jYC4Q65zGkJTieqOoz4cAoyQXxobj3RrZuk2CVtdt5pJiiHFzdrXXnc360aYdmfylDvoKGRIMl0LfrT+w=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.08667126|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.141551-0.00588351-0.852565;FP=18319517013567864945|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033032053168;MF=guozh23@xiaopeng.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.jWKvv6R_1791427549;
Received: from localhost(mailfrom:guozh23@xiaopeng.com fp:SMTPD_---.jWKvv6R_1791427549 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 10:45:50 +0800
From: Guo Zihao <guozh23@xiaopeng.com>
To: netdev-bot+sashiko@kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ebtables: ebt_802_3: drop short frames before the match reads LLC
Date: Thu,  8 Oct 2026 10:45:49 +0800
Message-ID: <20261008024549.4115339-1-guozh23@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <179077865471.434549.9648522947578914338@kernel.org>
References: <179077865471.434549.9648522947578914338@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Thanks for the review. All five findings check out against the source,
and I have posted v2 addressing them:

https://lore.kernel.org/netdev/20261008024539.4106699-1-guozh23@xiaopeng.com/

Point by point:

[High] skb_header_pointer() negative offset. Agreed, and I was wrong to
doubt __skb_header_pointer() in v1. v2 now uses

    skb_header_pointer(skb, skb_mac_offset(skb), hlen, &_frame)

which covers paged frames as well, instead of my hand-rolled linear-only
check.

[High] The abs(mac_offset) threshold was inconsistent across hooks.
Gone with skb_header_pointer(); the requirement is now expressed as
"bytes from the mac header" and follows whatever the hook did to the
mac header, including the br_send_bpdu() path where mac_offset is 0.

[High] hotdrop silently ignored by ebtables legacy. The match now
returns false instead, the ebt_stp_mt() pattern, so legacy ebtables and
nftables agree again. The commit message also points users who want such
frames dropped at a plain "--802_3 -j DROP" rule rather than hiding a
drop inside a SAP/TYPE check.

[Medium] Reading 23 bytes for a SAP-only rule. v2 reads only
offsetof(struct ebt_802_3_hdr, llc.ui.ctrl) = 16 bytes unless a TYPE
constraint is set, so a 21-byte topology change BPDU still matches
"--802_3 --802_3-sap 0x42 -j ACCEPT" like it did before (the union type
and the control byte are only needed for the TYPE match).

[Low] Fixes tag. v2 carries

    Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

pw-bot: cr

Guo Zihao
