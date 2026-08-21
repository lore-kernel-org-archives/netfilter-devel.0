Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B8130568F;
	Fri, 21 Aug 2026 06:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787295230; cv=none; b=eLxWDrGTEJBp6JnJCFJoh8lpEfJPAPsa0kyVn7WE1KoBfY8Ow88cm7+AT5y+Uzsowjim/JTnIixqDwGV15v5qr+OuIXGTnCVZhhob0as5zwNw5A5QonwoCENsDGHNKKMv+CyAMvW4wJx2JaHqmte+X+wdhwWj8mmlZcot3m3aVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787295230; c=relaxed/simple;
	bh=ldZNRvlu97rfpX+QNcQmwNXSPgx4MCegm+liDWtc89A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cNThWgUTHGVSoFj2TmmvO6L6K2twWn4ZilO82HpirJCLvKbYOjZePitCu7BnCCy00D7G1TUsZS6/Ujuq3h/ex32YYkAVhk7kJSaP1J3PpqAW8bku8ajEVNrN5vEM/jlKN2mCCDDFuyw/nDOvVPYQBoasa3w1ARSgnWa6owHFxXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=YQceVb1H; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="YQceVb1H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=0j
	FgTP983VS4DNdECUgkLZK3SDwibegoRo9L/KQvF/0=; b=YQceVb1HHN7eYt/xQc
	9g971f+jWY9zR9tlOQowDIKEhvfR2Y+JFdTpGJq5/NdwtUaoHppeVO+bUe+FJi1r
	qHR6cJyVyd1su1/CeebU9rSq8Ya9Kgbo0lsbKcxDhJMX6Y2PTYrmxNP+BPyQ/uYV
	xRbGP1nY7np1QmbAQZ7nfdOsM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wA3pcqt9YdqIzfLRA--.20490S2;
	Fri, 21 Aug 2026 14:52:31 +0800 (CST)
From: luoqing <l1138897701@163.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	Jing Min Zhao <zhaojignmin@hotmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] netfilter: nf_conntrack_h323: fix double cursor advance in decode_int()
Date: Fri, 21 Aug 2026 14:52:29 +0800
Message-Id: <20260821065229.121871-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3pcqt9YdqIzfLRA--.20490S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kry7Wr13KF1kuF1rZr1rXrb_yoW8Ww4Dpr
	ZxK39rGr9xXF4Skw4jga97AFyxJ398Cr43WryrtayFk398JF4UWay5K34YgFy7Jr4kJFyU
	AF1YvFZrAa1kXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjuWLUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3g8laWqH9a86nwAA3P

From: Qing Luo <luoqing@kylinos.cn>

In the CONS case of decode_int(), when the field is actually decoded
(base is not NULL and the field carries the DECODE attribute),
get_uint() already advances the bitstream cursor by 'len' bytes.  The
subsequent unconditional "bs->cur += len" then advances the cursor a
second time over the same data, so the parser skips 'len' extra bytes.

All fields following such an integer are decoded from a wrong bit
position.  This affects the timeToLive field in RAS
RegistrationRequest/RegistrationConfirm messages: subsequent fields
(e.g. transport addresses) end up being parsed from arbitrary offsets
inside the message, so the helper may create expectations based on
bogus addresses/ports.

Only advance the cursor manually when get_uint() was not called, so
that the value bytes are consumed exactly once in either case.

Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 6830c9da3507..a51275cc4d0f 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -336,8 +336,9 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
 			unsigned int v = get_uint(bs, len) + f->lb;
 			PRINT(" = %u", v);
 			*((unsigned int *)(base + f->offset)) = v;
+		} else {
+			bs->cur += len;
 		}
-		bs->cur += len;
 		break;
 	case UNCO:
 		BYTE_ALIGN(bs);
-- 
2.25.1

