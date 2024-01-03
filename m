Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E01D518EA0;
	Wed,  3 Jan 2024 11:30:06 +0000 (UTC)
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
Subject: [PATCH net 0/2] Netfilter fixes for net
Date: Wed,  3 Jan 2024 12:29:59 +0100
Message-Id: <20240103113001.137936-1-pablo@netfilter.org>
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

1) Fix nat packets in the related state in OVS, from Brad Cowie.

2) Drop chain reference counter on error path in case chain binding
   fails.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-01-03

Thanks.

----------------------------------------------------------------

The following changes since commit 9bf2e9165f90dc9f416af53c902be7e33930f728:

  net: qrtr: ns: Return 0 if server port is not present (2024-01-01 18:41:29 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-01-03

for you to fetch changes up to b29be0ca8e816119ccdf95cc7d7c7be9bde005f1:

  netfilter: nft_immediate: drop chain reference counter on error (2024-01-03 11:17:17 +0100)

----------------------------------------------------------------
netfilter pull request 24-01-03

----------------------------------------------------------------
Brad Cowie (1):
      netfilter: nf_nat: fix action not being set for all ct states

Pablo Neira Ayuso (1):
      netfilter: nft_immediate: drop chain reference counter on error

 net/netfilter/nf_nat_ovs.c    | 3 ++-
 net/netfilter/nft_immediate.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)
