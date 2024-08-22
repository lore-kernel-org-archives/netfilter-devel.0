Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0407F4405;
	Thu, 22 Aug 2024 00:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724285836; cv=none; b=r+/1vjMpOdjbiJixBOTJt3Som6QnXDg/6cqkccpPuw6SQjy3zEqB8pDNpC3Jh0/uI2kw9Ozm5l4MJKTcWwbYH+vKe6Imr5TZZc6dWXrYfdODifle9v3RZyBvnN/YxwxAKKoz4vaDX9+O1Lj3hG3Ki9hfFiz9zuvA37dGI1IM0yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724285836; c=relaxed/simple;
	bh=qDmpzNy3x7c860yQIQ/G59wbMOPGSCg5fuJv/uzcO6g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ks2AodRGUiLkfWZrtMwmAGJBZrCLq9o+pk0pmLv/d8jaRD3OTWA7IYy5CuOs5edJbqqj7krEVs32Mhysn13hxIWmCjCKcaDnzBLRNW/AVFATdUelKNb3Ez6pHB0Q+bGL0NefyBHju4ijW8VsQ9AgKBLWE/fUui92NOK35dlwoMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Thu, 22 Aug 2024 02:17:04 +0200
Message-Id: <20240822001707.2116-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for net:

Patch #1 disable BH when collecting stats via hardware offload to ensure
	 concurrent updates from packet path do not result in losing stats.
	 From Sebastian Andrzej Siewior.

Patch #2 uses write seqcount to reset counters serialize against reader.
	 Also from Sebastian Andrzej Siewior.

Patch #3 ensures vlan header is in place before accessing its fields,
	 according to KMSAN splat triggered by syzbot.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-08-22

Thanks.

----------------------------------------------------------------

The following changes since commit 807067bf014d4a3ae2cc55bd3de16f22a01eb580:

  kcm: Serialise kcm_sendmsg() for the same socket. (2024-08-19 18:36:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-08-22

for you to fetch changes up to 0509ac6c6a9a282ade4ad79b04665395691f73b1:

  netfilter: flowtable: validate vlan header (2024-08-21 23:42:49 +0200)

----------------------------------------------------------------
netfilter pull request 24-08-22

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      netfilter: flowtable: validate vlan header

Sebastian Andrzej Siewior (2):
      netfilter: nft_counter: Disable BH in nft_counter_offload_stats().
      netfilter: nft_counter: Synchronize nft_counter_reset() against reader.

 net/netfilter/nf_flow_table_inet.c | 3 +++
 net/netfilter/nf_flow_table_ip.c   | 3 +++
 net/netfilter/nft_counter.c        | 9 +++++++--
 3 files changed, 13 insertions(+), 2 deletions(-)
