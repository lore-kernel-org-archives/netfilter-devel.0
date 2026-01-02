Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E05E30DD1A;
	Fri,  2 Jan 2026 11:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767354111; cv=none; b=qD9wTZGx0zNvqW9nWJPwEpqj+UwipqM7fVWTfBhP07fqvrmfWlSSnQfqUjNnf6Xo5Pqj3P74S/2SyUZZFsGgZk6CBXqczWeodG51OYjzJao/gxWj7tv8qpfFLkr+4+19RgOLHiwENbtW7wFzMJWlaMCNcxoig/3NRJzhZe4atDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767354111; c=relaxed/simple;
	bh=xJM560743YoKbqt7FVPACZ5WWcZMwDbdPk3R3VIZYmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQQ26NCXOMqaauHSAoor14BQZVuQol4h7Y06F0ayaLJglEHc4E81eufgGI5/zATeHyWZHK6VWERmsCjGgWnShg/UEZ4JVgDBYtiIsJ3kFV34H3v4gzRRd3IBW0CooyddU6E6A08glF4O0lSmeaoYxAdqD3FyUAqoHUwLDzlGkGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ECAFD6035A; Fri, 02 Jan 2026 12:41:41 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 1/6] netfilter: nft_set_pipapo: fix range overlap detection
Date: Fri,  2 Jan 2026 12:41:23 +0100
Message-ID: <20260102114128.7007-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260102114128.7007-1-fw@strlen.de>
References: <20260102114128.7007-1-fw@strlen.de>
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

