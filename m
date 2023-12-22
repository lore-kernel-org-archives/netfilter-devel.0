Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F72156DE;
	Fri, 22 Dec 2023 10:42:16 +0000 (UTC)
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
Date: Fri, 22 Dec 2023 11:42:03 +0100
Message-Id: <20231222104205.354606-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[ resent, apparently this was only posted to netfilter-devel@vger.kernel.org,
  not to netdev@vger.kernel.org ]

Hi,

The following patchset contains Netfilter fixes for net:

1) Skip set commit for deleted/destroyed sets, this might trigger
   double deactivation of expired elements.

2) Fix packet mangling from egress, set transport offset from
   mac header for netdev/egress.

Both fixes address bugs already present in several releases.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-12-20

Thanks.

----------------------------------------------------------------

The following changes since commit 8353c2abc02cf8302d5e6177b706c1879e7b833c:

  Merge branch 'check-vlan-filter-feature-in-vlan_vids_add_by_dev-and-vlan_vids_del_by_dev' (2023-12-19 13:13:59 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-12-20

for you to fetch changes up to 7315dc1e122c85ffdfc8defffbb8f8b616c2eb1a:

  netfilter: nf_tables: skip set commit for deleted/destroyed sets (2023-12-20 13:48:00 +0100)

----------------------------------------------------------------
netfilter pull request 23-12-20

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: nf_tables: set transport offset from mac header for netdev/egress
      netfilter: nf_tables: skip set commit for deleted/destroyed sets

 include/net/netfilter/nf_tables_ipv4.h | 2 +-
 net/netfilter/nf_tables_api.c          | 2 +-
 net/netfilter/nf_tables_core.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)
