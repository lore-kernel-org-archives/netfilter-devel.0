Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D5523D7EA
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Dec 2025 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764688880; cv=none; b=X2gyiiODPJOwBBvxPHGBDMeWlgFVN4674fKUii0xGmyNDxqTAQnZCN0cwJLlvXtLVzqJB0ZX0PvbTSI0USX3UAodIz3atnqdqQe2QTsmK5CeCtEm1bc4GQN3SdDwfTXQL8mkVUTwu0P5/NIEDyLsDHrZ+8tET4nv1RrjK4wHCak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764688880; c=relaxed/simple;
	bh=I3Eaq0thncInCh1rbsixoDyAZQKnHwEZvmKdkICZgV8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=COqLFrAgS2vCq+KSzSFFZLKjJqJfzrpdV+QIaZ49BsrE4XffPUSgYBDEWIVj3gv7tRp8GNApUFCcuhWqx4NO15ZMTD3QDupTdoHP9/W6pfF9nRTmj3gfa3F4JN2j0hYehsfMj4wYtD8Vy3R0BqJRD0HeisYPYr8Ay5r+30qAZSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1BA5A603CD; Tue, 02 Dec 2025 16:21:15 +0100 (CET)
Date: Tue, 2 Dec 2025 16:21:10 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: sbrivio@redhat.com
Subject: pipapo with element shadowing, wildcard support
Message-ID: <aS8D5pxjnGg6WH-2@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/ivR+yC1kiOl+Enr"
Content-Disposition: inline


--/ivR+yC1kiOl+Enr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I am currently looking into pipapo and wildcard matching.
Before going into a bit more details consider the following
example set:

 map s {
   typeof iifname . ip saddr . oifname : verdict
   flags interval
 }

This works fine, but pipapo comes with caveats.
1. Currently pipapo allows to insert a 'narrow' key like e.g.:
  add element t s {  "lo" . 127.0.0.1 . "lo"  : accept }

  ... and then add a 'broader' one afterwards, e.g.:
  add element t s {  "lo" . 127.0.0.1/8 . "lo"  : drop }

but this doesn't work when placing these add calls in the
reverse order (you get -EEXIST).

Question would be if it makes sense to relax the -EEXIST checks so that in
step 1 the wider key could be inserted first and then allow it to be
(partially) shadowed later.

Things get worse when adding wildcard support:

 map s {
   typeof iifname . ip saddr . oifname : verdict
   flags interval
   elements = { "*" . 127.0.0.5 . "" : jump test1,
                "*" . 127.0.0.1 . "" : jump test2,
                "lo" . 127.0.0.1 . "" : jump test3,
                "lo" . 127.0.0.5 . "" : jump test4 }
 }

(requires attached nft hack to permit both "*" and "" identifiers)

Example is same as before:
 add element inet t s '{  "lo" . 127.0.0.1 . "" counter : jump testlo1 }'
 add element inet t s '{  "lo" . 127.0.0.0/8 . "" counter : jump testW1 }'

 works but not vice versa.  (fails with -EEXIST).

If the existing behavior is ok as-is, i.e. userspace has to pre-order the
add calls, then no changes are needed.

But I dislike this, I don't think users should be expected to first
autoremove existing elements, then add the new element, then add back the
old, wider entry.

I also worry that we could end up with subtle bugs, e.g. rule(set) dumps
that can't be restored because of element ordering tripping over -EEXIST
test.

Do you think that:
   add element inet t s '{  "lo" . 127.0.0.0/8 . ...'
   add element inet t s '{  "lo" . 127.0.0.1 . ...'

should work, i.e. second element add should work (and override the
pre-existing entry in case new entry is more specific)?

AFAICS the 'override' part isn't as easy as relaxing the -EEXIST checks;
we would have to re-order the elements internally, else even 'lo 127.0.0.1'
would match the /8 entry first, so we would require to order the elements
so the most narrow element is placed first in the lookup table.

That in turn won't be nice to handle from kernel, so I wonder if nftables
needs to do more work here, similar to how we 'auto-merge' for rbtree/interval
set types?

Before I spend more time on it, has anyone looked into this before?

Thanks!

--/ivR+yC1kiOl+Enr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=nft-wildcard-support-hack.diff

diff --git a/src/evaluate.c b/src/evaluate.c
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -378,11 +378,10 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 	memset(data + len, 0, data_len - len);
 	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
 
-	if (strlen(data) == 0)
-		return expr_error(ctx->msgs, expr,
-				  "Empty string is not allowed");
+	datalen = strlen(data);
+	if (datalen)
+		datalen--;
 
-	datalen = strlen(data) - 1;
 	if (data[datalen] != '*') {
 		/* We need to reallocate the constant expression with the right
 		 * expression length to avoid problems on big endian.
@@ -395,11 +394,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 		return 0;
 	}
 
-	if (datalen == 0)
-		return expr_error(ctx->msgs, expr,
-				  "All-wildcard strings are not supported");
-
-	if (data[datalen - 1] == '\\') {
+	if (datalen > 0 && data[datalen - 1] == '\\') {
 		char unescaped_str[data_len];
 
 		memset(unescaped_str, 0, sizeof(unescaped_str));
diff --git a/src/segtree.c b/src/segtree.c
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -412,7 +412,8 @@ void concat_range_aggregate(struct expr *set)
 				unsigned int str_len = prefix_len / BITS_PER_BYTE;
 				char data[str_len + 2];
 
-				mpz_export_data(data, r1->value, BYTEORDER_HOST_ENDIAN, str_len);
+				if (str_len)
+					mpz_export_data(data, r1->value, BYTEORDER_HOST_ENDIAN, str_len);
 				data[str_len] = '*';
 
 				tmp = constant_expr_alloc(&r1->location, r1->dtype,

--/ivR+yC1kiOl+Enr--
