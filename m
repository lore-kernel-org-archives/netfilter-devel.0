Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74BC1925BF
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 15:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743090049; cv=none; b=m0Ta4uuikcLyn+sDC1lrzejxU7TkYEaK4ibkxEJ6yriW3vq5zr1fGv2NAAYuF4+AM3G42ekDzlFJL/C/0JPfF02W7X6meIdsdDkkeb6db8fqmxc9icGuyw9DKvNs5jQ8VOThCtebKLpVuCb/ajlgKgTZLzd+FVWo9pVYn1GuJIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743090049; c=relaxed/simple;
	bh=og1rChker8+7sgTUx/fiRAGdSeUh3jTiUOX6QbQg7n4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5+gpwJKW7dvhphPv9/ZJfVZiR2mBkZDP78XdB/bqikVq98VSiN3FZivOkFmatrVWoNYiKXfpiIC9xhTrzzP5vZ013+ui6YaLGWJHaAWQ1pwuaDXZCx05uw+7/IEIQo+SsbbmEd4Bpc2cXe55FagfMv0FdF5kVq45KZHQb+mG3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AIlsM/dT; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AIlsM/dT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AIlsM/dT";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AIlsM/dT"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 94D2E6067A; Thu, 27 Mar 2025 16:40:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743090041;
	bh=6532UjoR0v4FaQI7/UNvJHCzITc77EmivFLL8MtHbeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AIlsM/dTo6zX3YgEx4m7l9t/q4+SDWOn3EiKXR11O8eoHfscB/zc4Ys4CqFK3VWh1
	 vHrihBtWEchKt9NLFdglwSxoMbEL4/NOlSFVnOiM3nqPNt1Hv9IPOEKfj1FuYXuRBT
	 gzjReUnQePoWAqZdYUBLomt0taAdApCofXPeu/HOGFEjEa59k9U3F8JZf8vbJt1TjF
	 0tDMwy/8AWUc+uRuDhnYxfQ81goj1EpshBF7K0GDJ3sx0K41csMEkpz/UWKBUS/1Ie
	 d12xplJMH1Yi5EsJJzrSfigYtVc6nzWM0RBd0HinKeGnXD8nbhpdXsKhZTWBEX/XyZ
	 MV4jfdnbBLOmg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F31B56067A;
	Thu, 27 Mar 2025 16:40:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743090041;
	bh=6532UjoR0v4FaQI7/UNvJHCzITc77EmivFLL8MtHbeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AIlsM/dTo6zX3YgEx4m7l9t/q4+SDWOn3EiKXR11O8eoHfscB/zc4Ys4CqFK3VWh1
	 vHrihBtWEchKt9NLFdglwSxoMbEL4/NOlSFVnOiM3nqPNt1Hv9IPOEKfj1FuYXuRBT
	 gzjReUnQePoWAqZdYUBLomt0taAdApCofXPeu/HOGFEjEa59k9U3F8JZf8vbJt1TjF
	 0tDMwy/8AWUc+uRuDhnYxfQ81goj1EpshBF7K0GDJ3sx0K41csMEkpz/UWKBUS/1Ie
	 d12xplJMH1Yi5EsJJzrSfigYtVc6nzWM0RBd0HinKeGnXD8nbhpdXsKhZTWBEX/XyZ
	 MV4jfdnbBLOmg==
Date: Thu, 27 Mar 2025 16:40:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: tolerate empty concatenation
Message-ID: <Z-VxdrgTRO1RTdBq@calendula>
References: <20250324115301.11579-1-fw@strlen.de>
 <Z-Vv1R-OmC2QukpS@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lAp7pC2ZxYWd+uZu"
Content-Disposition: inline
In-Reply-To: <Z-Vv1R-OmC2QukpS@calendula>


--lAp7pC2ZxYWd+uZu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Mar 27, 2025 at 04:33:59PM +0100, Pablo Neira Ayuso wrote:
> Hi Florian,
> 
> On Mon, Mar 24, 2025 at 12:52:58PM +0100, Florian Westphal wrote:
> > Don't rely on a successful evaluation of set->key.
> > With this input, set->key fails validation but subsequent
> > element evaluation asserts because the context points at
> > the set key -- an empty concatenation.
> > 
> > Causes:
> > nft: src/evaluate.c:1681: expr_evaluate_concat: Assertion `!list_empty(&ctx->ectx.key->expressions)' failed.
> > 
> > After patch:
> > internal:0:0-0: Error: unqualified type  specified in set definition. Try "typeof expression" instead of "type datatype".
> > internal:0:0-0: Error: Could not parse symbolic invalid expression
> 
> Maybe block this from the json parser itself?

Maybe this instead? This covers for empty concatenation in both set
key and set data.

--lAp7pC2ZxYWd+uZu
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

commit e0123be7a908d1a4b7c43d0817b9ecccf2bd1416
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Thu Mar 27 16:32:16 2025 +0100

    parser_json: reject empty concatention in set key and data
    
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/src/parser_json.c b/src/parser_json.c
index 17bc38b565ae..513e0b10f028 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1729,6 +1729,13 @@ static struct expr *json_parse_dtype_expr(struct json_ctx *ctx, json_t *root)
 			}
 			compound_expr_add(expr, i);
 		}
+
+		if (list_empty(&expr->expressions)) {
+			json_error(ctx, "Empty concatenation");
+			expr_free(expr);
+			return NULL;
+		}
+
 		return expr;
 	} else if (json_is_object(root)) {
 		const char *key;

--lAp7pC2ZxYWd+uZu--
