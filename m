Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02831DA57;
	Thu,  8 Oct 2026 03:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429050; cv=none; b=tgubAAS2RH/n2/ePfJECwwphnUdFH6vLlEPwvDPUYM173pnreyAWePp0xc0B+tgo1+bV8f5bXs37ar0Yh3Tp7AcDYl+w4BDpGZxJL1xkuQV9nErSDkfbHgdwJjJX7cBEQbsAb9AyMjf9qXG/yRhCcxTXHLsOT7vPwel/vu8A7pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429050; c=relaxed/simple;
	bh=TQ2iUFMwvL7RF9GVlG5grjdNcDasf2Uxxka0SgKT0cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7lgmUKBkT8JSAnt3UJweRkDbsa+4OJz79syTI7f48+INcyvcxaiaMV0DGp04vSIj90XnJ6N01IoT7yQpXIuBBeNIxtxFu15grYfNijc5A2TyoOCoYX5hnB4h7L4yJUwv7Oo0RMp7ircwz7nSptjVWraEodVj8xZ0jUn+UVLR8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.b=VK4qdkri; arc=none smtp.client-ip=111.22.67.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.b="VK4qdkri"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=VK4qdkri3Fir7Ua5Ca6ybw5owzi/xCkA8W8Z5xoIluxIBH7IHpiTKTsHAaSxkpRU3BS76pyuJJNAq
	 jeSUrM7zy6q6cze5qq2VAho7o/0+DcO9Kd30Mzz7+3iByBvbKO8wHc5M+ZfssbJt7zCMmm/lRLZY5v
	 buvNRhZNF/wguwbA=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee86ac709b0125-5052a;
	Thu, 08 Oct 2026 11:10:41 +0800 (CST)
X-RM-TRANSID:2ee86ac709b0125-5052a
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.99])
	by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee26ac709af673-024c3;
	Thu, 08 Oct 2026 11:10:41 +0800 (CST)
X-RM-TRANSID:2ee26ac709af673-024c3
From: lvjunyu <lvjunyu@cmss.chinamobile.com>
To: netdev-bot+sashiko@kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kuba@kernel.org,
	lvjunyu <lvjunyu@cmss.chinamobile.com>
Subject: Re: [PATCH v2] netfilter: nf_nat: Fix stale outer UDP checksum on VXLAN encapsulated packets
Date: Tue, 22 Sep 2026 14:14:41 +0800
Message-ID: <20260922061441.752117-1-lvjunyu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921130312.686493-1-lvjunyu@cmss.chinamobile.com>
References: <20260921130312.686493-1-lvjunyu@cmss.chinamobile.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On the Sashiko AI review comments:

> [Medium] Peer call-site divergence: after this patch nf_nat's
> __udp_manip_pkt() treats a CHECKSUM_PARTIAL skb whose offload target...

The flowtable software path (nf_flow_nat_ip_udp) is not reached by
the packets this patch fixes. VXLAN outer headers are locally
generated via vxlan_xmit() -> udp_set_csum() and traverse OUTPUT ->
POSTROUTING, where they hit the conntrack NAT path
(__udp_manip_pkt). The flowtable hook (nf_flow_offload_ip_hook)
processes forwarded flows with offloaded conntrack entries; the
VXLAN outer flow uses a random source port (MASQUERADE
--random-fully) and represents a new conntrack entry that has not
yet been offloaded.

The architectural inconsistency is acknowledged: if flowtable
offload of VXLAN tunnel flows is ever introduced, the same LCO
detection would be needed in nf_flow_nat_ip_udp(). The
zero-checksum gate difference (do_csum = !!hdr->check vs.
udph->check || ip_summed == CHECKSUM_PARTIAL) is pre-existing and
unrelated to this patch.

> [Medium] Incomplete/asymmetric fix: the same unguarded
> nf_csum_update() pattern exists at three sibling sites...

The LCO state being fixed is specific to the UDP encapsulation
path: udp_set_csum() LCO branch writes a complete checksum into
uh->check while setting csum_start to the inner transport header.
This split state does not occur for the sibling call sites:

- tcp_manip_pkt(): TCP checksum includes the pseudo-header
  (addresses + ports); the offload target is the TCP header itself
  (csum_start points at the TCP header, not an inner header), so
  the offload-target test would not match.

- icmpv6_manip_pkt(): ICMPv6 checksum includes a pseudo-header;
  the offload target is the ICMPv6 header itself.

- Headers embedded in ICMP errors (via
  nf_nat_icmp_reply_translation): these are byte copies in the
  ICMP payload, not live checksum-offloaded data; ip_summed is
  typically NONE or COMPLETE.

- nf_nat_*_csum_recalc(): handles length field changes in the
  pseudo-header, a different scenario.

Putting the offload-target test in a shared helper (e.g.,
wrapping nf_csum_update()) is architecturally sound and could be
done as a follow-up. This patch is intentionally scoped to the
UDP path where the bug is observed and verified.

> [Low] The new comment states that both the address and the port
> delta are "applying the address and port deltas with the wrong
> sign"...

The reviewer is correct. The two cases are distinct:

- Port delta (pseudohdr=false, PARTIAL): no-op -- neither branch
  in inet_proto_csum_replace4() is taken.

- Address delta (pseudohdr=true, PARTIAL): applied to wrong seed
  -- the else-if(pseudohdr) branch operates on an uncomplemented
  value.

The comment will be reworded to distinguish "not applied at all"
(port) from "applied to the wrong seed" (address) in the next
revision.

pw-bot: cr


