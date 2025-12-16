Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24119265CA8;
	Tue, 16 Dec 2025 19:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765912153; cv=none; b=kbHNC8Q4EEXUdLs5kc4/46WooKUF7QmCtctbwpjLEzxxF/gKOjKkihxfSEjnjrlKJSzQs78PMJrODXqiTUBnAF58MaQhYosV17MLIKYiR+1NO3O4uw4zzpLFWnq0oNVN3fkD9jMNDPARgRIxXepwDvFwWpndjCj4JUoCuMCpqRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765912153; c=relaxed/simple;
	bh=K7j8EhOuhxmVWmCa4WA1h/DSVIfonZwqI/e7hXyWS08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jhq9YW1kJf7RjWbUAaZdyetNc53pB+4vNGKv3bgne0V4MVve5yrWpFvKjYzYnGtGzMaSnrnEDMRNOsM6RzmQ8jHKjI8TyRkueN/g4KrfbnwmmajZ/BccMI9mLqWTy4s7LFYYA1Y+7KMbpwMbhk6tJLq3NAvHGPoo1RI9SQ6V6I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D99896024F; Tue, 16 Dec 2025 20:09:08 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/6] netfilter: updates for net
Date: Tue, 16 Dec 2025 20:08:58 +0100
Message-ID: <20251216190904.14507-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*:

1)  Jozsef Kadlecsik is retiring.  Fortunately Jozsef will still keep an
    eye on ipset patches.

2)  remove a bogus direction check from nat core, this caused spurious
    flakes in the 'reverse clash' selftest, from myself.

3) nf_tables doesn't need to do chain validation on register store,
   from Pablo Neira Ayuso.

4) nf_tables shouldn't revisit chains during ruleset (graph) validation
   if possible.  Both 3 and 4 were slated for -next initially but there
   are now two independent reports of people hitting soft lockup errors
   during ruleset validation, so it makes no sense anymore to route
   this via -next given this is -stable material. From myself.

5) call cond_resched() in a more frequently visited place during nf_tables
   chain validation, this wasn't possible earlier due to rcu read lock,
   but nowadays its not held anymore during set walks.

6) Don't fail conntrack packetdrill test with HZ=100 kernels.

Please, pull these changes from:
The following changes since commit 885bebac9909994050bbbeed0829c727e42bd1b7:

  nfc: pn533: Fix error code in pn533_acr122_poweron_rdr() (2025-12-11 01:40:00 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-12-16

for you to fetch changes up to fec7b0795548b43e2c3c46e3143c34ef6070341c:

  selftests: netfilter: packetdrill: avoid failure on HZ=100 kernel (2025-12-15 15:04:04 +0100)

----------------------------------------------------------------
netfilter pull request nf-25-12-16

----------------------------------------------------------------
Florian Westphal (4):
      netfilter: nf_nat: remove bogus direction check
      netfilter: nf_tables: avoid chain re-validation if possible
      netfilter: nf_tables: avoid softlockup warnings in nft_chain_validate
      selftests: netfilter: packetdrill: avoid failure on HZ=100 kernel

Jozsef Kadlecsik (1):
      MAINTAINERS: Remove Jozsef Kadlecsik from MAINTAINERS file

Pablo Neira Ayuso (1):
      netfilter: nf_tables: remove redundant chain validation on register store

 CREDITS                                            |  1 +
 MAINTAINERS                                        |  1 -
 include/net/netfilter/nf_tables.h                  | 34 ++++++---
 net/netfilter/nf_nat_core.c                        | 14 +---
 net/netfilter/nf_tables_api.c                      | 84 +++++++++++++++++-----
 .../net/netfilter/conntrack_reverse_clash.c        | 13 ++--
 .../net/netfilter/conntrack_reverse_clash.sh       |  2 +
 .../packetdrill/conntrack_syn_challenge_ack.pkt    |  2 +-
 8 files changed, 107 insertions(+), 44 deletions(-)

# WARNING: skip 0001-MAINTAINERS-Remove-Jozsef-Kadlecsik-from-MAINTAINERS.patch, no "Fixes" tag!
# INFO: 0002-netfilter-nf_nat-remove-bogus-direction-check.patch fixes commit from v6.12-rc1~38^2^2~13
# INFO: 0003-netfilter-nf_tables-remove-redundant-chain-validatio.patch fixes commit from v4.18-rc1~114^2~78^2~5
# WARNING: skip 0004-netfilter-nf_tables-avoid-chain-re-validation-if-pos.patch, no "Fixes" tag!
