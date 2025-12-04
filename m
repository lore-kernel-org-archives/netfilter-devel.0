Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA59C2E282B
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Dec 2025 11:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764847263; cv=none; b=i98RBzNC4Rj5BjvCcyPm1tdco6GZRuFuVKS0loeVLJw3oW6FxFolfayieBpq1gCbNvURbMiSnSGYeD05NwDp8hhDL7gKXp5dHLbxAQGiHmP2eLPpcTRPxF6I/IQUhSPXrNqnC8VacqzNTRkSmbiLqBAx8F1rJUtHYLXkks8qkjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764847263; c=relaxed/simple;
	bh=xJM560743YoKbqt7FVPACZ5WWcZMwDbdPk3R3VIZYmE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UtXgi5GeHEpLnKXL1/eibP05BqeaLDNJ741YKZ2qUw7SpwlGKHUh5KWp2MYZFY+aw6pJbZw3j5q/iQseSu8oFOpMSbRGIfu3sY5vqdrmWvxvxmptQqJWxiqDPJcnpNorcm47c+3lmue3nP8Lpj7P9rJYKkM9g5gnUC6bdnVvUPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A5EB560331; Thu, 04 Dec 2025 12:20:52 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/2] netfilter: nft_set_pipapo: fix range overlap detection
Date: Thu,  4 Dec 2025 12:20:35 +0100
Message-ID: <20251204112041.27440-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

set->klen has to be used, not sizeof().  The latter only compares a
single register but a full check of the entire key is needed.

Example:
table ip t {
        map s {
                typeof iifname . ip saddr : verdict
                flags interval
        }
}

nft add element t s '{ "lo" . 10.0.0.0/24 : drop }' # no error, expected
nft add element t s '{ "lo" . 10.0.0.0/24 : drop }' # no error, expected
nft add element t s '{ "lo" . 10.0.0.0/8 : drop }' # bug: no error

The 3rd 'add element' should be rejected via -ENOTEMPTY, not -EEXIST,
so userspace / nft can report an error to the user.

The latter is only correct for the 2nd case (re-add of existing element).

As-is, userspace is told that the command was successful, but no elements were
added.

After this patch, 3rd command gives:
Error: Could not process rule: File exists
add element t s { "lo" . 127.0.0.0/8 . "lo"  : drop }
                  ^^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: 0eb4b5ee33f2 ("netfilter: nft_set_pipapo: Separate partial and complete overlap cases on insertion")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 112fe46788b6..6d77a5f0088a 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1317,8 +1317,8 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		else
 			dup_end = dup_key;
 
-		if (!memcmp(start, dup_key->data, sizeof(*dup_key->data)) &&
-		    !memcmp(end, dup_end->data, sizeof(*dup_end->data))) {
+		if (!memcmp(start, dup_key->data, set->klen) &&
+		    !memcmp(end, dup_end->data, set->klen)) {
 			*elem_priv = &dup->priv;
 			return -EEXIST;
 		}
-- 
2.51.2

