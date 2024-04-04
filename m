Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B6C26AC2;
	Thu,  4 Apr 2024 10:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712227426; cv=none; b=jzsFMmQkxE2nMgQVDcr9+eqVO7iEtDmLKQfi0h0/jIqJ5RiOSSFv18j/VkTG7BI/YKeXZ+OfHay5PdIX+AVoKu9OZW++4tXzZJI5kwj5BPLJq6m36MHZXqWTrWQliwQ0bO+98MPqmMbBLtueCjHLh8D9SKfQ2B2TE/TkJgzdjWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712227426; c=relaxed/simple;
	bh=RV15jL2ldhYz9H9Y53+nV6vwcOAW20x+bTHRM+hXZnQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sqFVqqqQzNa5LdTZ/QW0yQ3i0ZR4YFkvDTs97gNwpo3a7xfe0vdo6XE/tac8chaR4HX98WMkNMwrZCYi4tELwjLjx7/StJIxMnc5o2OdLDrsJabVn2hoaiguvQzdr5NLP0VBkPV3uD4E/kVyc2hAB0YL9xMZ8vMyDene5wGh+n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 0/6] Netfilter fixes for net
Date: Thu,  4 Apr 2024 12:43:28 +0200
Message-Id: <20240404104334.1627-1-pablo@netfilter.org>
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

Patch #1 unlike early commit path stage which triggers a call to abort,
         an explicit release of the batch is required on abort, otherwise
         mutex is released and commit_list remains in place.

Patch #2 release mutex after nft_gc_seq_end() in commit path, otherwise
         async GC worker could collect expired objects.

Patch #3 flush pending destroy work in module removal path, otherwise UaF
         is possible.

Patch #4 and #6 restrict the table dormant flag with basechain updates
	 to fix state inconsistency in the hook registration.

Patch #5 adds missing RCU read side lock to flowtable type to avoid races
	 with module removal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-04-04

Thanks.

----------------------------------------------------------------

The following changes since commit 72076fc9fe60b9143cd971fd8737718719bc512e:

  Revert "tg3: Remove residual error handling in tg3_suspend" (2024-04-04 10:51:01 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-04-04

for you to fetch changes up to 1bc83a019bbe268be3526406245ec28c2458a518:

  netfilter: nf_tables: discard table flag update with pending basechain deletion (2024-04-04 11:38:35 +0200)

----------------------------------------------------------------
netfilter pull request 24-04-04

----------------------------------------------------------------
Pablo Neira Ayuso (5):
      netfilter: nf_tables: release batch on table validation from abort path
      netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path
      netfilter: nf_tables: flush pending destroy work before exit_net release
      netfilter: nf_tables: reject new basechain after table flag update
      netfilter: nf_tables: discard table flag update with pending basechain deletion

Ziyang Xuan (1):
      netfilter: nf_tables: Fix potential data-race in __nft_flowtable_type_get()

 net/netfilter/nf_tables_api.c | 50 +++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 16 deletions(-)
