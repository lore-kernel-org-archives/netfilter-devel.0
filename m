Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243E2361970;
	Mon, 24 Aug 2026 02:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787538983; cv=none; b=s6NWpplrYJQUn2HMrj94QTpQZM77A3w2Ci1FAzHBDyn0T7sW2dCpXRI/Jsp7jXqFWHDMqwTusUybgpr+5MN9NrD3ESeDDSCjWU+Mc4aLXZxLbX/MkUgmChxGDgKVIl/0ESNE2aaPRYVYQ7UQGJK4jLfPooN67jBrmRok8kCbpjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787538983; c=relaxed/simple;
	bh=XAQhw2DAELXbMhOtLuwXtBEHurz/vLsnJyUpShH7ldU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EoynoqCs4ELyW7jnDrU1MXwZ6BLuVjUnElXRPeC2bcgL84BMPuluZRgalQMNSD7Kbr7FS8OtRMHrlABzTxfJj4vQNAq8h53N/jA9HdAQgM9bPOeSSos8DrRrxDpxFp+nL87wDbjXyooNn1X3nfZDmL34Q1qUz82ifgolYAooSug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=WqArCXXJ; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="WqArCXXJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=z1
	9ziYzlRKZx6zie0RnE6wXWzn/6qa4EAc4MT1IdAEg=; b=WqArCXXJqwKu/X7PI0
	yLaZ3V10HnzgQyBlNQMBFdJ/1Ljff0C0txNycMCFUNicYey2vY53m+WCLI38thPf
	qhbyDFoKdC/2Jn+UZgIle+zSeCR0KvXkFkQ6Wmf2MBejM8mLhA1VzShjARhg/yZU
	CEtnmyFbFSXUS9midTzU7i2T4=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgAHXPpIrYtqen0JOw--.16017S2;
	Mon, 24 Aug 2026 10:32:42 +0800 (CST)
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
Subject: [PATCH net-next v2] netfilter: nf_conntrack_h323: fix double cursor advance in decode_int()
Date: Mon, 24 Aug 2026 10:32:38 +0800
Message-Id: <20260824023238.205772-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgAHXPpIrYtqen0JOw--.16017S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kry7Wr13KF1kuF1rZr1rXrb_yoW8Wr45pr
	ZxK3y7Gr9rXF4Ska1jga97Ary7J395Gr43WryrtrWFk398JFWUWFW5K34YgFy7Jr4kJFyD
	ZF15ZF47Aa1kZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjuWLUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3gr6P2qLrUppZgAA3Y

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

