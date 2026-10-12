Received: from out28-196.mail.aliyun.com (out28-196.mail.aliyun.com [115.124.28.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BB534A796;
	Mon, 12 Oct 2026 09:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791796122; cv=none; b=FgVB3IucFzNF2+1e4XoD7YYe3YntoH+kJw6CRfCMtb8kpVrHIK+aXxtt1LZOeVYSbZyvE7rLtFsvfkuFqBi62vTxYyeopB2zSvKf1d15AiI+nkNIwPAAKrDdcDvTnSYPWu2XqN7a927xkolREWGLr5IWYoRfffnO/I92WOoILl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791796122; c=relaxed/simple;
	bh=odsw1nspqDLtzhjFN7YBFhG9v/fxzPRQkVr8H3riC0c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jaC5gwwWpi0qK4KElnL7WmTse8y4MaZbGOYljnOKfEzS+C3TmRJVA/+cRpQDBbzJkQ94GESRFJ57vmsCIfelvg4WQ72Ex4MxRUwWr/piyhbuZ2I75a65BWZYbi0T4EwyJdN3zVEwCoTz2EhQ5znRo3AI3pj3uDDswxjYoTx44as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=Tn7tK5zm; arc=none smtp.client-ip=115.124.28.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="Tn7tK5zm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1791796116; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=xK1kQ29AHu7i9jACy0bPf/jFUizZClRpLg5DsoLoqFE=;
	b=Tn7tK5zmxkjHarVFFmjh072XenIEmtqtakgC6HyTLZ4Oz+/nhYXWhqaURs9J+qzrpnGn8xuBTMxpiY1ig2h1UBH0XQsYRMDSXfN4HujZ3lOf1Ohpq/IhZlX6zFC71ALzmO5gyDs7ouDIpWKhL704R+aNf+XA9jnuzKWJg1e69m4=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.08644862|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0185914-0.00172889-0.97968;FP=16464164499535474191|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037022039;MF=zhugl3@xiaopeng.com;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.ja0Vm6s_1791796115;
Received: from DESKTOP-UL5U09E.xiaopeng.local(mailfrom:zhugl3@xiaopeng.com fp:SMTPD_---.ja0Vm6s_1791796115 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 17:08:35 +0800
From: Guanglei Zhu <zhugl3@xiaopeng.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuwb@xiaopeng.com
Subject: [PATCH] netfilter: nf_conntrack_h323: fix NULL deref in decode_seqof()
Date: Mon, 12 Oct 2026 17:08:35 +0800
Message-ID: <20261012090835.920932-1-zhugl3@xiaopeng.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

decode_seqof() loads son from f->fields and dereferences son->attr
in the item loop without a NULL check.  A number of SEQOF entries
in nf_conntrack_h323_types.c carry a NULL fields pointer, so a
crafted packet that makes one of these optional fields present with
a nonzero item count dereferences NULL in the loop.

Skip the decoding when fields is NULL.

Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
---
Verified on a KASAN kernel with a test module calling decode_seqof()
with a fields=NULL SEQOF entry and a nonzero item count: NULL deref
report at son->attr (read of size 2 at address 0x4).

 net/netfilter/nf_conntrack_h323_asn1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 6830c9da3..0d07d0276 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -691,6 +691,8 @@ static int decode_seqof(struct bitstr *bs, const struct field_t *f,
 	}
 
 	/* Decode nested field */
+	if (!f->fields)
+		return H323_ERROR_NONE;
 	son = f->fields;
 	if (base)
 		base -= son->offset;
-- 
2.43.0

