Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788182;
	b=PX3F4IORVQMlbteiXs/KHQk9+FYwJdJQQ6D/t48SgkMDgQBap3ImStL14EOHZVKs/LeM
	 GrGW4CZehUHRsEaAxXjeqEZ43A3ZGFstIKx2zEh3ct2xCOEoOSFBzf2sk5YgjwUD5M14c
	 N6IDrxSk1h0/V0IqNUaY/JSelL6AomJEuHgUR8OxhWFtK5hBQkAxNRNY29DSmh/T2NhwY
	 icUfJ1XzCFrGFcls7hTUD/9G1VmHdRfV5Gaw5sAB4qFsw1EeUvqlWC3qro0AlRKBEEzKD
	 1t0pfwzpE4vbpKyVrgdeeYAM5om+VR5JcHsPF0r6iXlAURJxc73ID2hyujd/s6Fldcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788182;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=vlI37qzSCoQGFD/l2JGedcjxmNZl705tmChdchxcl5s=;
	b=dgP/6sBxVKDXOo3uKCXa2ZUG0oFZcAv67JpG01iYF5Oh+0moOwlEZUxvOIDJb2gwGSJq
	 6466CMgY1sLNUkCaiOOv7DI1HPMyTkWJC8G7pm8mA9W/AYcucJ94fULVsqkwzwooEl4XN
	 n7WwmHtTpeeR5AtqbhjJtGGQ3s8wxYxN7AylIQjCsGQaNo9Z8qXt4ZB2mjWBTmLtsJXRc
	 O0GWUyyuLocKhIpYSBGS6reQHIfZT46MNln5Jc8IMpfrRMimg/ds/Bg2uiidX6VZtkI31
	 nFjsgEZ6oujsjlHXEft2KcvEfcvfZSYWke67AgUmetnlUu4suR+9jPQ8XppVkdfrbIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=gZCdQyYG;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D73D606A329;
	Mon, 16 Nov 2026 00:16:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D73D606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=gZCdQyYG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788178;
	bh=vlI37qzSCoQGFD/l2JGedcjxmNZl705tmChdchxcl5s=;
	h=From:To:Cc:Subject:Date:From;
	b=gZCdQyYGUx1zpJVMSlFTvbgT7sgfmMvC4XQNrW2khO7FgswPdguQvB3P26wfbhGh4
	 Dce/KKmX7cSuRSA/MQ3p14OTxnll8mpbjFIxrz8uolGMxBjsQd7zeVNS4txp81+PSC
	 Clv2on7NCLPDhh66Cn3gF6g94XQDqk0Vr7pHEtChZp6nBHZn8hlofj42BouBe589H+
	 e/7doxflZ/7IQ3mDG/QvHcj7w2ikeXVmCatMy0RTSachgm87VhakESkrKEBhj+sjKV
	 vgKDecRK8QLmpcIludcax0OyTO7Y4K9H1+pXC/wqy41LToDxPT9zWZB6bI4oPAbPUr
	 WyAJe6SEWLvBg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 29C0D60058;
	Mon, 16 Nov 2026 01:16:18 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next,v2 00/13] Netfilter updates for net-next
Date: Mon, 16 Nov 2026 01:15:59 +0100
Message-ID: <20261116001612.2806263-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,
 
The following patchset contains Netfilter updates for net-next, mostly
including flowtable fixes and improvements:
 
1) Do not offload flows to hardware from the packet path if they are
   already being torn down.
 
2) Fetch hardware stats when a flow is deleted, so the last stats sync
   with the conntrack entry is no longer missed. Update the mtk_ppe and
   airoha drivers to use this. From Lorenzo Bianconi and me.
 
3) Fix xt_time monthday computation for dates from 2040 on by using
   time64_to_tm() instead of the days_since_epoch[] table. This also
   shrinks the xt_time object by about 23%. From Fernando F. Mancera.
 
4) Do not offload multicast flows from nft_flow_offload, from Koral Ilgun.
 
5) Make the nf_hooks_lwtunnel sysctl read-only in non-init netns so
   unprivileged users cannot toggle the global static branch.
   From Pablo Neira Ayuso.
 
6) Purge the remaining flowtable entries directly when the flowtable
   is destroyed instead of going through the hardware offload
   workqueue, which may fail to allocate work.
 
7) Remove a no-op loop initializer in the nf_queue selftest to silence
   a clang -Wunused-value warning. From Sasha Levin.
 
8) Do not scrub the skb as crossing netns in the IPIP flowtable tx
   path, so the skb mark is preserved.

9) Do not let the DEV_PATH_TUN entry set h_source from the tunnel
   device's dev_addr. Before this patch, fast-path frames went out with
   part of the tunnel's local IP address as the Ethernet source MAC.
   This broke offloaded flows on DS-Lite over PPPoE. From Marek
   Majkowski.
 
10) Clear IPS_OFFLOAD_BIT only once, as part of the one-time teardown
    transition. Before this patch, a repeated teardown of an expired
    hardware flow could clear the bit owned by a replacement flow for
    the same conntrack entry. From João Silva.
 
11) Call skb_ensure_writable() in nfnetlink_queue before writing
    NFQA_L2HDR over the mac header. Before this patch, the write could
    corrupt cloned frames that bridge flooding sends to other ports.
    From Tamaki Yanagawa.
 
12) Add a UDP flowtable offload selftest for IPv4 and IPv6, with and
    without masquerade. From Jiri Peska.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-11-16

Thanks.

----------------------------------------------------------------

The following changes since commit 573af801552999954caa8347e4490b04cf4763f0:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-11-12 14:54:47 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-11-16

for you to fetch changes up to 03b7948d634a19df8b6a31c75055cf03194aaba2:

  selftests: netfilter: add UDP flowtable offload test (2026-11-16 01:05:20 +0100)

----------------------------------------------------------------
netfilter pull request 26-11-16

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: xt_time: fix monthday computation for dates past 2039

Jiri Peska (1):
      selftests: netfilter: add UDP flowtable offload test

João Silva (1):
      netfilter: flowtable: do not clear the offload bit twice

Koral Ilgun (1):
      netfilter: nft_flow_offload: do not offload multicast

Lorenzo Bianconi (1):
      net: airoha: update stats on flow deletion

Marek Majkowski (1):
      netfilter: flowtable: tunnel device poisons h_source of fast-path frames

Pablo Neira Ayuso (5):
      netfilter: flowtable: do not hw offload flows in teardown state
      netfilter: flowtable: retrieve stats on flow deletion
      net: ethernet: mtk_ppe: update stats on flow deletion
      netfilter: flowtable: purge entries immediately when destroying the flowtable
      netfilter: flowtable: do not scrub as crossing netns

Sasha Levin (1):
      selftests: netfilter: nf_queue: drop the no-op loop initializer

Tamaki Yanagawa (1):
      netfilter: nfnetlink_queue: make skb writable before writing NFQA_L2HDR

 drivers/net/ethernet/airoha/airoha_ppe.c           |  31 +--
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |  32 ++-
 include/net/netfilter/nf_flow_table.h              |   3 +-
 net/netfilter/nf_flow_table_core.c                 |  35 ++-
 net/netfilter/nf_flow_table_ip.c                   |   4 +-
 net/netfilter/nf_flow_table_offload.c              |  83 ++++---
 net/netfilter/nf_flow_table_path.c                 |   7 +-
 net/netfilter/nfnetlink_queue.c                    |   7 +-
 net/netfilter/nft_flow_offload.c                   |   5 +
 net/netfilter/xt_time.c                            |  82 +------
 tools/testing/selftests/net/netfilter/Makefile     |   1 +
 tools/testing/selftests/net/netfilter/nf_queue.c   |   2 +-
 .../selftests/net/netfilter/nft_flowtable_udp.sh   | 238 +++++++++++++++++++++
 13 files changed, 390 insertions(+), 140 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_flowtable_udp.sh
