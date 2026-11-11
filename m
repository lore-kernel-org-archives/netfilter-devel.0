Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=94.136.29.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395606;
	b=rmhZllQ8R+2xE8ms4p23+m/iiC7rJl0EpHcURTRc/0MM4SA5z15185ff9swKii5aAdk4
	 i73xXFrczFZFLE/tV9BtAF5HFP/aYiPQU3VE94adUrCvCeVdH//H6bX6NrX8lPfoVYHLR
	 4D/BB8pJngNcSfC+H+Ej3wILX5N5px4NQd8TytVqjkKBkKYVvjW6MASH3dQy7I9JhZq6o
	 IAy4ccoDgZQbEGtZt78vyVDw12SqogJPYxmAjEpmNTfzA0N9063n0VCB8kvVIAblyyfOl
	 haxWOfaU+pgshN/vNCkjfJU5Vk/eSvrFLHzvkrtUJp/FjhQ1lY1gnEqa5q6hVjMZbTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395606;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-Bm-Milter-Handled:
	 X-Bm-Transport-Timestamp;
	bh=kvWD9EQTMwYBo2ig95vUjM3dPcRLEkFL5l+720cDBdI=;
	b=Q7NtysnPWqCoxb792DY0UwWjyBVUIZ5LcmVAq1ebDXiG7uN0VsKxcO5ZxCH0TWRbWlfp
	 oJcKT/QSMbcrPKXWou7OT8mQYW4UVpkOxZJIzJWj94mzOW0o6K0eUSTlPcKxVS5isXSHD
	 ghSQRjOSlbH5/cr8Nj7NVS0aBPBPX3rjnwv0oRqI5PI+hV/bHr7J4xEsraFfN1k9YNbYX
	 G90D1Lc8AMlmfVDxg9zsIRZR4w/pIyEsuxaertzEVY6VppaCxLklqYLOOh9GKQIapy4wb
	 S9HxXzUMM8iCvVq1nweHk4cERAoliMJOhazQSmdcokXaEQBxJzROiC2Zc+xPLI1wX1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=proxmox.com;
	spf=pass smtp.mailfrom=proxmox.com;
	arc=none smtp.remote-ip=94.136.29.106
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A3A606A326
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 11:13:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1A3A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id CF60B48206;
	Wed, 11 Nov 2026 12:13:16 +0100 (CET)
From: Stefan Hanreich <s.hanreich@proxmox.com>
To: netfilter-devel@vger.kernel.org
Cc: Stefan Hanreich <s.hanreich@proxmox.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next 0/3] netfilter: nf_tables: speed up loading rulesets with many sets
Date: Wed, 11 Nov 2026 12:12:43 +0100
Message-ID: <20261111111250.226432-1-s.hanreich@proxmox.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1794395595795

In nft_table, while chains and objects are looked up by name in a
hashtable, sets are only kept in a linked list. Looking up a set by name
and allocating a name for an anonymous set both require walking this
list. This makes applying a ruleset take time quadratic in the number of
sets. This series addresses this by storing sets the same way as chains
and objects.

Patch 1 adds a hashtable for set lookups by name, as already done for
chains and objects. This covers creating sets, adding and deleting set
elements, and expressions referring to a set by name.

Patch 2 stops walking the transaction list when binding an anonymous
set once the transaction creating the set is found. This early exit was
lost in commit 6a0a8d10a366 ("netfilter: nf_tables: use-after-free in
failing rule with bound set").

Patch 3 takes the numbers for anonymous set names from a per-table
counter, similar to anonymous chains, instead of searching all sets of
the table for the smallest unused number.

The changes in this patch series cause set names in lookups to be cut
off at the first NUL byte, as for chains and objects, so a name like
"foo\0bar" refers to an existing set "foo" instead of matching no set.
Also, anonymous set numbers are no longer reused, and all name formats
such as "__set%d" and "__map%d" share one counter. nft does not depend
on the actual numbers.

Time to load the rulesets with "nft -f", in seconds, as printed by the
script below (perf stat, mean of 5 runs):

Without any patches (at 734bef54):

named sets, 1000:
          0.022394 +- 0.000179 seconds time elapsed  ( +-  0.80% )
named sets, 5000:
           0.31914 +- 0.00670 seconds time elapsed  ( +-  2.10% )
named sets, 10000:
            1.3933 +- 0.0232 seconds time elapsed  ( +-  1.67% )
anon sets, 1000:
           0.03728 +- 0.00271 seconds time elapsed  ( +-  7.27% )
anon sets, 5000:
            0.8123 +- 0.0110 seconds time elapsed  ( +-  1.36% )
anon sets, 10000:
            3.6800 +- 0.0508 seconds time elapsed  ( +-  1.38% )


With all 3 patches applied:

named sets, 1000:
           0.00884 +- 0.00115 seconds time elapsed  ( +- 12.96% )
named sets, 5000:
           0.04680 +- 0.00450 seconds time elapsed  ( +-  9.62% )
named sets, 10000:
           0.09196 +- 0.00523 seconds time elapsed  ( +-  5.69% )
anon sets, 1000:
         0.0089494 +- 0.0000518 seconds time elapsed  ( +-  0.58% )
anon sets, 5000:
           0.05008 +- 0.00468 seconds time elapsed  ( +-  9.35% )
anon sets, 10000:
          0.090748 +- 0.000146 seconds time elapsed  ( +-  0.16% )

#!/bin/sh
named() {
	echo "add table inet t"
	echo "add chain inet t c"
	for i in $(seq 1 "$1"); do
		echo "add set inet t s$i { type ipv4_addr; }"
		echo "add rule inet t c ip saddr @s$i counter"
	done
}

anon() {
	echo "add table inet t"
	echo "add chain inet t c"
	for i in $(seq 1 "$1"); do
		echo "add rule inet t c ip saddr { 10.0.0.1, 10.0.0.2 } counter"
	done
}

rules=$(mktemp)
for type in named anon; do
	for n in 1000 5000 10000; do
		$type "$n" > "$rules"
		echo "$type sets, $n:"
		perf stat --null -r 5 --pre "nft flush ruleset" nft -f "$rules" 2>&1 |
			grep 'time elapsed'
	done
done
rm "$rules"

Stefan Hanreich (3):
  netfilter: nf_tables: use a hashtable for set lookups by name
  netfilter: nf_tables: stop bind walk at anonymous set creation
  netfilter: nf_tables: use a counter for anonymous set names

 include/net/netfilter/nf_tables.h |  10 +-
 net/netfilter/nf_tables_api.c     | 170 +++++++++++++++++++++---------
 2 files changed, 127 insertions(+), 53 deletions(-)


base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.47.3


