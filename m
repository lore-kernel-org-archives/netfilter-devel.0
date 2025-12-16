Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E52334C23;
	Tue, 16 Dec 2025 19:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765912161; cv=none; b=cRfPyz7oHYI+Ir+4ZaAZVBJTaRtDTkR+z+eF4KC4c2PXhPpIUy4P7Wsamzem5HYPLEzng5bcmBuawG+dXxdMevlaMH5ktBGWukvYMf+ab+y2S6fHJjD4hpUA4P6V13iWXPeecjp3xS7n7wtdLfIZMlc0De8m0YtSepKc+fPZ514=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765912161; c=relaxed/simple;
	bh=M6XMhZ4ji2CTokSc6rHWQaDFL0G07+hVWjNjEHdsBBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUkCeU8WdxSGFZTlTbKY3LvyHqACHKHU5Orx1GrBzo7MBdnPwSAWf8y7HHWX+UW+C7h/enxQis8i14Z6jotDF/I/JpLrkQWXAQhnvw51PElOANvInGV09Cdn+4M/gCOkYiz7+oy5ba+K6zWU/ELI58X6zPUZFJIWfRvKrPW1EOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8DD336060A; Tue, 16 Dec 2025 20:09:17 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 2/6] netfilter: nf_nat: remove bogus direction check
Date: Tue, 16 Dec 2025 20:09:00 +0100
Message-ID: <20251216190904.14507-3-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216190904.14507-1-fw@strlen.de>
References: <20251216190904.14507-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jakub reports spurious failures of the 'conntrack_reverse_clash.sh'
selftest.  A bogus test makes nat core resort to port rewrite even
though there is no need for this.

When the test is made, nf_nat_used_tuple() would already have caused us
to return if no other CPU had added a colliding entry.
Moreover, nf_nat_used_tuple() would have ignored the colliding entry if
their origin tuples had been the same.

All that is left to check is if the colliding entry in the hash table
is subject to NAT, and, if its not, if our entry matches in the reverse
direction, e.g. hash table has

addr1:1234 -> addr2:80, and we want to commit
addr2:80   -> addr1:1234.

Because we already checked that neither the new nor the committed entry is
subject to NAT we only have to check origin vs. reply tuple:
for non-nat entries, the reply tuple is always the inverted original.

Just in case there are more problems extend the error reporting
in the selftest while at it and dump conntrack table/stats on error.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20251206175135.4a56591b@kernel.org/
Fixes: d8f84a9bc7c4 ("netfilter: nf_nat: don't try nat source port reallocation for reverse dir clash")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c                        | 14 +-------------
 .../net/netfilter/conntrack_reverse_clash.c        | 13 +++++++++----
 .../net/netfilter/conntrack_reverse_clash.sh       |  2 ++
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 78a61dac4ade..e6b24586d2fe 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -294,25 +294,13 @@ nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
 
 	ct = nf_ct_tuplehash_to_ctrack(thash);
 
-	/* NB: IP_CT_DIR_ORIGINAL should be impossible because
-	 * nf_nat_used_tuple() handles origin collisions.
-	 *
-	 * Handle remote chance other CPU confirmed its ct right after.
-	 */
-	if (thash->tuple.dst.dir != IP_CT_DIR_REPLY)
-		goto out;
-
 	/* clashing connection subject to NAT? Retry with new tuple. */
 	if (READ_ONCE(ct->status) & uses_nat)
 		goto out;
 
 	if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-			      &ignored_ct->tuplehash[IP_CT_DIR_REPLY].tuple) &&
-	    nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
-			      &ignored_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple)) {
+			      &ignored_ct->tuplehash[IP_CT_DIR_REPLY].tuple))
 		taken = false;
-		goto out;
-	}
 out:
 	nf_ct_put(ct);
 	return taken;
diff --git a/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c b/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c
index 507930cee8cb..462d628cc3bd 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c
@@ -33,9 +33,14 @@ static void die(const char *e)
 	exit(111);
 }
 
-static void die_port(uint16_t got, uint16_t want)
+static void die_port(const struct sockaddr_in *sin, uint16_t want)
 {
-	fprintf(stderr, "Port number changed, wanted %d got %d\n", want, ntohs(got));
+	uint16_t got = ntohs(sin->sin_port);
+	char str[INET_ADDRSTRLEN];
+
+	inet_ntop(AF_INET, &sin->sin_addr, str, sizeof(str));
+
+	fprintf(stderr, "Port number changed, wanted %d got %d from %s\n", want, got, str);
 	exit(1);
 }
 
@@ -100,7 +105,7 @@ int main(int argc, char *argv[])
 				die("child recvfrom");
 
 			if (peer.sin_port != htons(PORT))
-				die_port(peer.sin_port, PORT);
+				die_port(&peer, PORT);
 		} else {
 			if (sendto(s2, buf, LEN, 0, (struct sockaddr *)&sa1, sizeof(sa1)) != LEN)
 				continue;
@@ -109,7 +114,7 @@ int main(int argc, char *argv[])
 				die("parent recvfrom");
 
 			if (peer.sin_port != htons((PORT + 1)))
-				die_port(peer.sin_port, PORT + 1);
+				die_port(&peer, PORT + 1);
 		}
 	}
 
diff --git a/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh b/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh
index a24c896347a8..dc7e9d6da062 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh
@@ -45,6 +45,8 @@ if ip netns exec "$ns0" ./conntrack_reverse_clash; then
 	echo "PASS: No SNAT performed for null bindings"
 else
 	echo "ERROR: SNAT performed without any matching snat rule"
+	ip netns exec "$ns0" conntrack -L
+	ip netns exec "$ns0" conntrack -S
 	exit 1
 fi
 
-- 
2.51.2

