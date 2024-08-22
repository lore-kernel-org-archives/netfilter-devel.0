Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A0D16EB54;
	Thu, 22 Aug 2024 10:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724321932; cv=none; b=jRDHCWj0e4rf38SWqUzvnyVJrwXU5w+rlGtxt4phjq+pfzpXC66cQ8LcllF/WCaOI9SR5PHSgaX/ovcTbh356M/81pf7PXOdcEOuUObJX/7ZIk0bXbukG+GcuqIVRFim216s+yGAw0Ks0DSXdxfAOP8Jhj75SWIehjr26wN8rBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724321932; c=relaxed/simple;
	bh=IVTuXysU78MLZKwd8/TLm8jZlEvjvqK9x+LTyFpBZfw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Kavxz7Rr/r0jSq16uXWFuNfYOSwwm+PbXtLqLmHju0BTNhh4RQa2q41sNQ/qQyheNybqT5Qz10vdPCovOL8Fznbrp24l+7mqCK4Tk5duxnUpQMfznN3ejvvZ3Abtdu1McHEAoXRXBhbXhAAp8HX1i+V0fZdugA2wyUnwd1AqmGQ=
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
Subject: [PATCH net,v2 0/3] Netfilter fixes for net
Date: Thu, 22 Aug 2024 12:18:39 +0200
Message-Id: <20240822101842.4234-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: including suggestion from Eric Dumazet on patch #3.

-o-

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

for you to fetch changes up to 6ea14ccb60c8ab829349979b22b58a941ec4a3ee:

  netfilter: flowtable: validate vlan header (2024-08-22 12:14:18 +0200)

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
