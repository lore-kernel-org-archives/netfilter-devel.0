Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F852116E9
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 15:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760626822; cv=none; b=hu2mRJKB0ttvIN9DwZNtudzSxB6RGuae0nWof7wBi/KsKmsUEqxsX9O4fPzS2zyMJzUJ/Tot2fEgcRhGjWSv8ft6o4hrMaL7uJMZtS4kc8RevvTEbY+JQurBer9R9dvtsNJsdlW/S/CHjB30ocW0xPIJEbc0HkJAhcMFiWjDq4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760626822; c=relaxed/simple;
	bh=BFTPyGcZoZFHKBZNz6kWJMZTt+1biHDZ6TCFv2vavD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKp067OWBjzKOvMrxuFn+YNkZ8+MwrMj0WdWHe9snmskXQoKeXgGaWCVA01Qd8I1IFk531gLKRE4tzTpq4CZAEhkcH7XFEvIeyLROhqOMeoR7QAQfG17c59b1P97eDrcDqGX/Jeds1vkTW9xb73E5krb4Eu2zofyZm2VMz2GKqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 35F9E6109E; Thu, 16 Oct 2025 17:00:19 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/4] evaluate: reject tunnel section if another one is already present
Date: Thu, 16 Oct 2025 16:59:36 +0200
Message-ID: <20251016145955.7785-5-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251016145955.7785-1-fw@strlen.de>
References: <20251016145955.7785-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Included bogon causes a crash because the list head isn't initialised
due to tunnel->type == VXLAN.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                            | 38 ++++++++++++++++---
 .../bogons/nft-f/tunnel_in_tunnel_crash       | 10 +++++
 2 files changed, 42 insertions(+), 6 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/tunnel_in_tunnel_crash

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 4e028d31c165..3c21c7584d01 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -144,6 +144,19 @@ static bool already_set(const void *attr, const struct location *loc,
 	return true;
 }
 
+static bool tunnel_set_type(const struct location *loc,
+			    struct obj *obj, enum tunnel_type type, const char *name,
+			    struct parser_state *state)
+{
+	if (obj->tunnel.type) {
+		erec_queue(error(loc, "Cannot create new %s section inside another tunnel", name), state->msgs);
+		return false;
+	}
+
+	obj->tunnel.type = type;
+	return true;
+}
+
 static struct expr *ifname_expr_alloc(const struct location *location,
 				      struct list_head *queue,
 				      const char *name)
@@ -4980,11 +4993,15 @@ erspan_block		:	/* empty */	{ $$ = $<obj>-1; }
 erspan_block_alloc	:	/* empty */
 			{
 				$$ = $<obj>-1;
+
+				if (!tunnel_set_type(&$$->location, $$, TUNNEL_ERSPAN, "erspan", state))
+					YYERROR;
 			}
 			;
 
 erspan_config		:	HDRVERSION	NUM
 			{
+				assert($<obj>0->tunnel.type == TUNNEL_ERSPAN);
 				$<obj>0->tunnel.erspan.version = $2;
 			}
 			|	INDEX		NUM
@@ -5017,6 +5034,10 @@ geneve_block		:	/* empty */	{ $$ = $<obj>-1; }
 geneve_block_alloc	:	/* empty */
 			{
 				$$ = $<obj>-1;
+				if (!tunnel_set_type(&$$->location, $$, TUNNEL_GENEVE, "geneve", state))
+					YYERROR;
+
+				init_list_head(&$$->tunnel.geneve_opts);
 			}
 			;
 
@@ -5024,6 +5045,8 @@ geneve_config		:	CLASS	NUM	OPTTYPE	NUM	DATA	string
 			{
 				struct tunnel_geneve *geneve;
 
+				assert($<obj>0->tunnel.type == TUNNEL_GENEVE);
+
 				geneve = xmalloc(sizeof(struct tunnel_geneve));
 				geneve->geneve_class = $2;
 				geneve->type = $4;
@@ -5034,10 +5057,6 @@ geneve_config		:	CLASS	NUM	OPTTYPE	NUM	DATA	string
 					YYERROR;
 				}
 
-				if (!$<obj>0->tunnel.type) {
-					$<obj>0->tunnel.type = TUNNEL_GENEVE;
-					init_list_head(&$<obj>0->tunnel.geneve_opts);
-				}
 				list_add_tail(&geneve->list, &$<obj>0->tunnel.geneve_opts);
 				free_const($6);
 			}
@@ -5055,11 +5074,15 @@ vxlan_block		:	/* empty */	{ $$ = $<obj>-1; }
 vxlan_block_alloc	:	/* empty */
 			{
 				$$ = $<obj>-1;
+
+				if (!tunnel_set_type(&$$->location, $$, TUNNEL_VXLAN, "vxlan", state))
+					YYERROR;
 			}
 			;
 
 vxlan_config		:	GBP	NUM
 			{
+				assert($<obj>0->tunnel.type == TUNNEL_VXLAN);
 				$<obj>0->tunnel.vxlan.gbp = $2;
 			}
 			;
@@ -5123,13 +5146,16 @@ tunnel_config		:	ID	NUM
 			}
 			|	ERSPAN	erspan_block_alloc '{' erspan_block '}'
 			{
-				$<obj>0->tunnel.type = TUNNEL_ERSPAN;
+				$2->location = @2;
 			}
 			|	VXLAN	vxlan_block_alloc '{' vxlan_block '}'
 			{
-				$<obj>0->tunnel.type = TUNNEL_VXLAN;
+				$2->location = @2;
 			}
 			|	GENEVE	geneve_block_alloc '{' geneve_block '}'
+			{
+				$2->location = @2;
+			}
 			;
 
 tunnel_block		:	/* empty */	{ $$ = $<obj>-1; }
diff --git a/tests/shell/testcases/bogons/nft-f/tunnel_in_tunnel_crash b/tests/shell/testcases/bogons/nft-f/tunnel_in_tunnel_crash
new file mode 100644
index 000000000000..9f029807f521
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/tunnel_in_tunnel_crash
@@ -0,0 +1,10 @@
+table netdev x {
+	tunnel geneve-t {
+		vxlan {
+			gbp 200
+		}
+		geneve {
+			class 0x1 opt-type 0x1 data "0x12345678"
+		}
+	}
+
-- 
2.51.0

