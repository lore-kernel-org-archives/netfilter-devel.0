Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B064D42;
	Wed,  6 Dec 2023 10:04:02 -0800 (PST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 0/6] Netfilter fixes for net
Date: Wed,  6 Dec 2023 19:03:51 +0100
Message-Id: <20231206180357.959930-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for net:

1) Incorrect nf_defrag registration for bpf link infra, from D. Wythe.

2) Skip inactive elements in pipapo set backend walk to avoid double
   deactivation, from Florian Westphal.

3) Fix NFT_*_F_PRESENT check with big endian arch, also from Florian.

4) Bail out if number of expressions in NFTA_DYNSET_EXPRESSIONS mismatch
   stateful expressions in set declaration.

5) Honor family in table lookup by handle. Broken since 4.16.

6) Use sk_callback_lock to protect access to sk->sk_socket in xt_owner.
   sock_orphan() might zap this pointer, from Phil Sutter.

All of these fixes address broken stuff for several releases.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-12-06

Thanks.

----------------------------------------------------------------

The following changes since commit 54d4434da824460a190d547404530eff12a7907d:

  Merge branch 'hv_netvsc-fix-race-of-netvsc-vf-register-and-slave-bit' (2023-11-21 13:15:05 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-12-06

for you to fetch changes up to 7ae836a3d630e146b732fe8ef7d86b243748751f:

  netfilter: xt_owner: Fix for unsafe access of sk->sk_socket (2023-12-06 17:52:15 +0100)

----------------------------------------------------------------
netfilter pull request 23-12-06

----------------------------------------------------------------
D. Wythe (1):
      netfilter: bpf: fix bad registration on nf_defrag

Florian Westphal (2):
      netfilter: nft_set_pipapo: skip inactive elements during set walk
      netfilter: nf_tables: fix 'exist' matching on bigendian arches

Pablo Neira Ayuso (2):
      netfilter: nf_tables: bail out on mismatching dynset and set expressions
      netfilter: nf_tables: validate family when identifying table via handle

Phil Sutter (1):
      netfilter: xt_owner: Fix for unsafe access of sk->sk_socket

 net/netfilter/nf_bpf_link.c    | 10 +++++-----
 net/netfilter/nf_tables_api.c  |  5 +++--
 net/netfilter/nft_dynset.c     | 13 +++++++++----
 net/netfilter/nft_exthdr.c     |  4 ++--
 net/netfilter/nft_fib.c        |  8 ++++++--
 net/netfilter/nft_set_pipapo.c |  3 +++
 net/netfilter/xt_owner.c       | 16 ++++++++++++----
 7 files changed, 40 insertions(+), 19 deletions(-)
