Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477DA30170D;
	Thu, 30 Oct 2025 08:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761813403; cv=none; b=Bn0/t3duKkIZ9rIu9i14mu3t7f35dOacbiYNO04AgpMXMkRLZxtVlgqMuM3L2wOmbMoW5y9lMEcJUf4/HS9ifrpXLJ2biKrPwuoUJ4VHVi9Mb1bZm7raweLjdlDPC1/SaAdacFyJUX/eMU6MZsdflypCfvz3BUh/kl4qM1uvlXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761813403; c=relaxed/simple;
	bh=1JNCPHckQsQWix8dflRYg6fL5EFdVbqFZ47yvvDxetQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h+l0uPAeGQ3v2//24baLnu3yIIgesUXjMe5Uyea7OXZqHIvUW7/lzHw3LOTx7n4jI+sX6+Ys2tgz7xp6ib2FUWyChSLrIK37e7/2UdeVmFCIOWzKB5WNWXR6WPz9M0TZ0R2gg6jwoETY4H3tei47GXaNBqJKRpKrIhuGYxRI2wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b301ppCx; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b301ppCx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761813401; x=1793349401;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1JNCPHckQsQWix8dflRYg6fL5EFdVbqFZ47yvvDxetQ=;
  b=b301ppCxpzlRK8ExXn7IFEWb6H3hpc5LJ9J9dWJ0l0F/N3NzSzRDB1IS
   jJTJ7NuaNGZHJPtld8o/LXxiq9Vn7CGKk9CZB7IFqHTzBASUIv6BwnM7X
   Hnld7besXux+Qads0wwkYXhFKhqEjLmy0Dc6/jBbS+cUc/CVmwZHo+CFF
   4iiDvKo3GbMHWI+iGmSZXzOBnRfTujUgnY8IzCVc0q62OCRNUQquB8fFK
   D4559WKEog522wt48GwP0HqlMe1VMVQVUEvRyxE79VdHG6pxuMuuuKJoj
   WVU1YadmpqCL8rzqI1BkJIJ+k0VBxhPVU24uf3sWe0xH2WNZYlntNpRh3
   Q==;
X-CSE-ConnectionGUID: Ne1ivf9aQe+6ZHaAo9MrOw==
X-CSE-MsgGUID: zLQoWG3ORoKRfmSjMUSVyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="67600484"
X-IronPort-AV: E=Sophos;i="6.19,266,1754982000"; 
   d="scan'208";a="67600484"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 01:36:40 -0700
X-CSE-ConnectionGUID: D+2op7OhQIa4sO1T8EBovg==
X-CSE-MsgGUID: dIReLDwRTZy6lSWzPzt7zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,266,1754982000"; 
   d="scan'208";a="185774788"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa006.fm.intel.com with ESMTP; 30 Oct 2025 01:36:35 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 2586695; Thu, 30 Oct 2025 09:36:34 +0100 (CET)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH net-next v1 1/1] treewide: Rename ERR_PTR_PCPU() --> PCPU_ERR_PTR()
Date: Thu, 30 Oct 2025 09:35:53 +0100
Message-ID: <20251030083632.3315128-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the namespace of specific ERR_PTR() macro leading the thing.
This is already done for IOMEM_ERR_PTR(). Follow the same pattern
in PCPU_ERR_PTR().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---

I believe taking it via net-next makes most of sense, if no objections.

 include/linux/err.h           | 2 +-
 kernel/events/hw_breakpoint.c | 4 ++--
 net/netfilter/nf_tables_api.c | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index 1d60aa86db53..8aafcf9492a4 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -42,7 +42,7 @@ static inline void * __must_check ERR_PTR(long error)
 }
 
 /* Return the pointer in the percpu address space. */
-#define ERR_PTR_PCPU(error) ((void __percpu *)(unsigned long)ERR_PTR(error))
+#define PCPU_ERR_PTR(error) ((void __percpu *)(unsigned long)ERR_PTR(error))
 
 /* Cast an error pointer to __iomem. */
 #define IOMEM_ERR_PTR(error) (__force void __iomem *)ERR_PTR(error)
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 8ec2cb688903..67fc1367d649 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -849,7 +849,7 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 
 	cpu_events = alloc_percpu(typeof(*cpu_events));
 	if (!cpu_events)
-		return ERR_PTR_PCPU(-ENOMEM);
+		return PCPU_ERR_PTR(-ENOMEM);
 
 	cpus_read_lock();
 	for_each_online_cpu(cpu) {
@@ -868,7 +868,7 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 		return cpu_events;
 
 	unregister_wide_hw_breakpoint(cpu_events);
-	return ERR_PTR_PCPU(err);
+	return PCPU_ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eed434e0a970..1b5286545a3c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2228,14 +2228,14 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
 	err = nla_parse_nested_deprecated(tb, NFTA_COUNTER_MAX, attr,
 					  nft_counter_policy, NULL);
 	if (err < 0)
-		return ERR_PTR_PCPU(err);
+		return PCPU_ERR_PTR(err);
 
 	if (!tb[NFTA_COUNTER_BYTES] || !tb[NFTA_COUNTER_PACKETS])
-		return ERR_PTR_PCPU(-EINVAL);
+		return PCPU_ERR_PTR(-EINVAL);
 
 	newstats = netdev_alloc_pcpu_stats(struct nft_stats);
 	if (newstats == NULL)
-		return ERR_PTR_PCPU(-ENOMEM);
+		return PCPU_ERR_PTR(-ENOMEM);
 
 	/* Restore old counters on this cpu, no problem. Per-cpu statistics
 	 * are not exposed to userspace.
-- 
2.50.1

