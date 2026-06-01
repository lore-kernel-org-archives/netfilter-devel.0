Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7D6233936;
	Mon,  1 Jun 2026 11:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315172; cv=none; b=cIwGLIXGxcdZRnBeDWNPwhTbmqF49xobR4xTboHKR5O109kI6kJk2ezd8I81qrMhxS7yUrhSZkeZYj8kb0vOhwzN9vYVsd8D8Ap7UjSw+ZYeAVfF0dwmn9k+wQeUu9cRzi6tzbrIAp5G3cG6i/nrSECa9J3XY+x3aw1/8AfqDbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315172; c=relaxed/simple;
	bh=rzcvFHdIg2YLu+67W3itUs1GRbkJnvyvgP3X45yvV7U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=StCB2Kq34pts+v+nk4QfAT1MPfC4bSjTvxg7yuK3+B9voC2zuQTgh2fm2LshipvzvcM7I8VIyhX9D0EiXTb5Se5O5i8HbUdLIGgPgKv4SBdU794dAmgn8W4FD+0C/Zjt+M97rR77iEvCIcX7h4SfIT+lyG3ZnNP0bSW0GqMaa9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vbKtqexf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vbKtqexf"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8A990601A6;
	Mon,  1 Jun 2026 13:59:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780315168;
	bh=a+XPh7763qpTeOpjYIBP2EfSEUaot2xMO9vBrP3UCX8=;
	h=From:To:Cc:Subject:Date:From;
	b=vbKtqexfYbPUtitgArdenQcZqc3mBGj8CTfXYKm+nLfcmtcxrcVshWvpsNMdb41Bn
	 hw6On3L/92p+X3aoPlIHj68XalSEGvbWm9mWigvuwsP1P2cYpcsPlqPy7GzHXSCOHS
	 +VOTXBNxAFtbjNZCJfB4zQad/khB0EKduBjTXwMzOnHHjjqsBe7TatkwMl/bMnv5ld
	 mXbqPFPc41HdPygCxAcubbX6cdfUXP+gsjF7PQmwmwK8z3nofJdLOvlxtZ6Jy2BzXv
	 wNEEsLBcJ7erZ2kbet1RBfpps4cvHzazZ270OKZafMf8xLBPb0GA/iWZLODDwhFV/Z
	 CDszqOMZTcl7A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 0/9] Netfilter/IPVS fixes for net
Date: Mon,  1 Jun 2026 13:59:14 +0200
Message-ID: <20260601115923.433946-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) Fix splat with PREEMPT_RCU because smp_processor_id() in nfqueue,
   from Fernando Fernandez Mancera.

2) Fix possible use of pointer to old IPVS scheduler after RCU grace
   period when editing service, from Julian Anastasov.

3) Fix possible forever RCU walk over rt->fib6_siblings in nft_fib6,
   if rt is unlinked mid-iteration, apparently same issue happens in
   the fib6 core. From Jiayuan Chen.

4) Add mutex to guard refcount in synproxy infrastructure, since
   concurrent hook {un}registration can happen.
   From Fernando Fernandez Mancera.

5) Bail out if IRC conntrack helper fails to parse a command, do not
   try parsing using other command handlers, from Florian Westphal.
   This fixes a possible out-of-bound read.

6) Possible use-after-free in nft_tunnel by releasing template dst
   after all references has been dropped, from Tristan Madani.

7) Ignore conntrack template in nft_ct, from Jiayuan Chen.

8) Missing skb_ensure_writable() in ebt_snat, Yiming Qian.

9) Remove multi-register byteorder support, this allows for kernel
   stack info leak, from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-06-01

Thanks.

----------------------------------------------------------------

The following changes since commit 78ef59e7a6459b16f8102e0ee1c718443323d1af:

  Merge branch 'wireguard-fixes-for-7-1-rc6' (2026-05-29 13:01:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-06-01

for you to fetch changes up to bb061d3de41707415269be75ebf700efb03ec212:

  netfilter: nft_byteorder: remove multi-register support (2026-06-01 13:43:53 +0200)

----------------------------------------------------------------
netfilter pull request 26-06-01

----------------------------------------------------------------
Fernando Fernandez Mancera (2):
      netfilter: xt_NFQUEUE: prefer raw_smp_processor_id
      netfilter: synproxy: add mutex to guard hook reference counting

Florian Westphal (2):
      netfilter: conntrack_irc: fix possible out-of-bounds read
      netfilter: nft_byteorder: remove multi-register support

Jiayuan Chen (2):
      netfilter: nft_fib_ipv6: bail out of sibling walk if rt got unlinked
      netfilter: nft_ct: bail out on template ct in get eval

Julian Anastasov (1):
      ipvs: clear the svc scheduler ptr early on edit

Tristan Madani (1):
      netfilter: nft_tunnel: fix use-after-free on object destroy

Yiming Qian (1):
      netfilter: bridge: make ebt_snat ARP rewrite writable

 include/net/ip_vs.h               |  3 +--
 net/bridge/netfilter/ebt_snat.c   |  3 +++
 net/ipv6/netfilter/nft_fib_ipv6.c |  3 +++
 net/netfilter/ipvs/ip_vs_ctl.c    | 13 ++++++----
 net/netfilter/ipvs/ip_vs_sched.c  | 14 +++++------
 net/netfilter/nf_conntrack_irc.c  |  4 +--
 net/netfilter/nf_synproxy_core.c  | 24 +++++++++++++-----
 net/netfilter/nft_byteorder.c     | 51 +++++++++++++++------------------------
 net/netfilter/nft_ct.c            |  8 +++---
 net/netfilter/nft_ct_fast.c       |  2 +-
 net/netfilter/nft_tunnel.c        |  2 +-
 net/netfilter/xt_NFQUEUE.c        |  2 +-
 12 files changed, 68 insertions(+), 61 deletions(-)
