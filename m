Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58182F0689;
	Fri,  2 Jan 2026 11:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767354108; cv=none; b=fktkBusbyowWHrurnHQkxuDKIH2aoUqZcctTF5zaBo5k+3NIQB6q0ccSSXEI1GVXz6i3IDBuoFMj8H5y+HmxJ6Kq+uAirVAbF/ohpsRA36A4XJPC+gpj1NejT3yE2QQNOwqkZrSMQiC+UcmoMuI6inMy5mP6A7cRHSihmJWEdUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767354108; c=relaxed/simple;
	bh=PkqsQtFV8Cs+jDRPKME/NldRbTQ5xo3KpAqRgHeqSvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jkjHNboeaU/iKYXmaprWabkjaxrHlLd/uwVWULYYkWx0kl806die2RS5YB40ElgIfJT/QOa/v/1NvTjZbFb88ut/KmjglN2hhOhkoDbhvZPmU/QeT3ZjjTJ1vldFNGDusJ0VebHaaBnm2rZ2Ao9YaPRSp8axMnbNctTciSdwdFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9D587602F8; Fri, 02 Jan 2026 12:41:37 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/6] netfilter: updates for net
Date: Fri,  2 Jan 2026 12:41:22 +0100
Message-ID: <20260102114128.7007-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*:

1) Fix overlap detection for nf_tables with concatenated ranges.
   There are cases where element could not be added due to a conflict
   with existing range, while kernel reports success to userspace.
2) update selftest to cover this bug.
3) synproxy update path should use READ/WRITE once as we replace
   config struct while packet path might read it in parallel.
   This relies on said config struct to fit sizeof(long).
   From Fernando Fernandez Mancera.
4) Don't return -EEXIST from xtables in module load path, a pending
   patch to module infra will spot a warning if this happens.
   From Daniel Gomez.
5) Fix a memory leak in nf_tables when chain hits 2**32 users
   and rule is to be hw-offloaded, from Zilin Guan.
6) Avoid infinite list growth when insert rate is high in nf_conncount,
   also from Fernando.

Please, pull these changes from:
The following changes since commit dbf8fe85a16a33d6b6bd01f2bc606fc017771465:

  Merge tag 'net-6.19-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2025-12-30 08:45:58 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-01-02

for you to fetch changes up to 7811ba452402d58628e68faedf38745b3d485e3c:

  netfilter: nf_conncount: update last_gc only when GC has been performed (2026-01-02 10:44:28 +0100)

----------------------------------------------------------------
netfilter pull request nf-26-01-02

----------------------------------------------------------------
Daniel Gomez (1):
      netfilter: replace -EEXIST with -EBUSY

Fernando Fernandez Mancera (2):
      netfilter: nft_synproxy: avoid possible data-race on update operation
      netfilter: nf_conncount: update last_gc only when GC has been performed

Florian Westphal (2):
      netfilter: nft_set_pipapo: fix range overlap detection
      selftests: netfilter: nft_concat_range.sh: add check for overlap detection bug

Zilin Guan (1):
      netfilter: nf_tables: fix memory leak in nf_tables_newrule()

 net/bridge/netfilter/ebtables.c                    |  2 +-
 net/netfilter/nf_conncount.c                       |  2 +-
 net/netfilter/nf_log.c                             |  4 +-
 net/netfilter/nf_tables_api.c                      |  3 +-
 net/netfilter/nft_set_pipapo.c                     |  4 +-
 net/netfilter/nft_synproxy.c                       |  6 +--
 net/netfilter/x_tables.c                           |  2 +-
 .../selftests/net/netfilter/nft_concat_range.sh    | 45 +++++++++++++++++++++-
 8 files changed, 56 insertions(+), 12 deletions(-)
# WARNING: 0000-cover-letter.patch lacks signed-off-by tag!
# WARNING: skip 0000-cover-letter.patch, no "Fixes" tag!
# INFO: 0001-netfilter-nft_set_pipapo-fix-range-overlap-detection.patch fixes commit from v5.6~21^2~5^2~5
# WARNING: skip 0002-selftests-netfilter-nft_concat_range.sh-add-check-fo.patch, no "Fixes" tag!
# INFO: 0003-netfilter-nft_synproxy-avoid-possible-data-race-on-u.patch fixes commit from v5.4-rc1~131^2~26^2~23
# WARNING: skip 0004-netfilter-replace-EEXIST-with-EBUSY.patch, no "Fixes" tag!
# INFO: 0005-netfilter-nf_tables-fix-memory-leak-in-nf_tables_new.patch fixes commit from v6.5-rc2~22^2~39^2~5
# INFO: 0006-netfilter-nf_conncount-update-last_gc-only-when-GC-h.patch fixes commit from v5.19-rc1~159^2~45^2~2
