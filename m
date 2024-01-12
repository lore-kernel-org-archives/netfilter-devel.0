Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA3B745E1
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2024 16:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] set_elem: use nftnl_data_cpy() in NFTNL_SET_ELEM_{KEY,KEY_END,DATA}
Date: Fri, 12 Jan 2024 17:21:12 +0100
Message-Id: <20240112162112.49146-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use safe nftnl_data_cpy() to copy key into union nftnl_data_reg.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: do not skip s->flags update.

 src/set_elem.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/src/set_elem.c b/src/set_elem.c
index 884faff432a9..08b0dccb190c 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -117,6 +117,7 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 		       const void *data, uint32_t data_len)
 {
 	struct nftnl_expr *expr, *tmp;
+	int ret = 0;
 
 	nftnl_assert_attr_exists(attr, NFTNL_SET_ELEM_MAX);
 	nftnl_assert_validate(data, nftnl_set_elem_validate, attr, data_len);
@@ -126,12 +127,10 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 		memcpy(&s->set_elem_flags, data, sizeof(s->set_elem_flags));
 		break;
 	case NFTNL_SET_ELEM_KEY:	/* NFTA_SET_ELEM_KEY */
-		memcpy(&s->key.val, data, data_len);
-		s->key.len = data_len;
+		ret = nftnl_data_cpy(&s->key, data, data_len);
 		break;
 	case NFTNL_SET_ELEM_KEY_END:	/* NFTA_SET_ELEM_KEY_END */
-		memcpy(&s->key_end.val, data, data_len);
-		s->key_end.len = data_len;
+		ret = nftnl_data_cpy(&s->key_end, data, data_len);
 		break;
 	case NFTNL_SET_ELEM_VERDICT:	/* NFTA_SET_ELEM_DATA */
 		memcpy(&s->data.verdict, data, sizeof(s->data.verdict));
@@ -145,8 +144,7 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_DATA:	/* NFTA_SET_ELEM_DATA */
-		memcpy(s->data.val, data, data_len);
-		s->data.len = data_len;
+		ret = nftnl_data_cpy(&s->data, data, data_len);
 		break;
 	case NFTNL_SET_ELEM_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
 		memcpy(&s->timeout, data, sizeof(s->timeout));
@@ -181,7 +179,8 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 		break;
 	}
 	s->flags |= (1 << attr);
-	return 0;
+
+	return ret;
 }
 
 EXPORT_SYMBOL(nftnl_set_elem_set_u32);
-- 
2.30.2

