Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680E71991C9
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 15:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743090201; cv=none; b=aVH3VUKX6zGamtKGF/fenh3iWUaKaNGGQPz28rrjVMNAZD5ev22Hv9bz4s9uY4HB4dUep9H3C6a62smXvdyf21bWaOMPXLQBmeWR14gKzQdrd+XpK118BuvAk62cVxRu2eTDrM9zLOGuITvCQVo7y6FV4178j+MCiialnxHN40c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743090201; c=relaxed/simple;
	bh=yBhLvKASpsCqtKDJeOyGP4YCvqgEJe5Oij/uC8xaYGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PsY2tv50sstxCBSF1LYSdOw1hHXm9AGkXOA1PMrSoNFS1pmOTaJDX/jBqFRIIfIqWidYp4E9Gx3MSP+7DTf4CMQivpEnpcxb5oZrQrQvxUu7OSV62zS8VQv9TAxpCwmoTZThSgxYtHXZYPq+ffnOFktBCzXqg4e7EAoNLnPItxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HgrTApLh; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hBxZU+RM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HgrTApLh";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hBxZU+RM"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 238C260613; Thu, 27 Mar 2025 16:34:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743089640;
	bh=/4RMw844gfqAN3CMgajKjPgOXWkYhYOrhc+nF4Dzrvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HgrTApLhK7KpB7YcHQTB0objJMsQ4yGBjB/oA4kr/CNqKQUtpksQdZcs7Y3JgEK6j
	 FnA8y3lYJ5WWx2AIYdEVSw2FtRjWPYA92+FQtmkliX8oB6oScKuLqnRsdIbLvW/F4q
	 qO4MJb/MIP+yp/c5HW4IHH3pM9pPgpF/zwWIcwOdUXODiyioVgpzHSKwimD9Nzm/Ug
	 c1NR5bRfS4pE2bebiynpN7v2YXU+yCmy/yUtLY4BxdYoVTr9fQvIiEYjXSfDRPCCqC
	 9o89Y/OAvaNPq1IIwRyku8hHQIwXyfVrZ/zkUp7MLEz5NS5yl1hF162fixjWcGcakT
	 SRWAEccLKM5Wg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7D72160613;
	Thu, 27 Mar 2025 16:33:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743089639;
	bh=/4RMw844gfqAN3CMgajKjPgOXWkYhYOrhc+nF4Dzrvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hBxZU+RMcEYFcnn73QApoIZg+Ji8Y7Jpw2DiTVIHOevHxyFd3HRHaaCg9oFyVDdOq
	 EYsX5yribNG0Z1asJahgOinepq9ZmCMR03jYvF8LtL2LofeiKFEWXOP6uRTNQThLOf
	 FNGdqeP4abKCQ8X4rUS8mMxZQ2KWU+BOWwOjfP0VeUnvkCQSuBp/bRYSX3U5P7hoaa
	 RjEOeqXwEjMnBtBudGvsptOv3c+0f9Rb198iZVIQExkwNdcBpENThHQnrHgu/xTLvD
	 zApUSkWkkdQcYYC9LKuOfbvDcSqeHNWHFmGn6LvVzdleJzTU+fw8f23MYb2A1ALoOv
	 C6TkIeuynC4ig==
Date: Thu, 27 Mar 2025 16:33:57 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: tolerate empty concatenation
Message-ID: <Z-Vv1R-OmC2QukpS@calendula>
References: <20250324115301.11579-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4QXrznYuPLGaHlyg"
Content-Disposition: inline
In-Reply-To: <20250324115301.11579-1-fw@strlen.de>


--4QXrznYuPLGaHlyg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Florian,

On Mon, Mar 24, 2025 at 12:52:58PM +0100, Florian Westphal wrote:
> Don't rely on a successful evaluation of set->key.
> With this input, set->key fails validation but subsequent
> element evaluation asserts because the context points at
> the set key -- an empty concatenation.
> 
> Causes:
> nft: src/evaluate.c:1681: expr_evaluate_concat: Assertion `!list_empty(&ctx->ectx.key->expressions)' failed.
> 
> After patch:
> internal:0:0-0: Error: unqualified type  specified in set definition. Try "typeof expression" instead of "type datatype".
> internal:0:0-0: Error: Could not parse symbolic invalid expression

Maybe block this from the json parser itself?

--4QXrznYuPLGaHlyg
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/parser_json.c b/src/parser_json.c
index 17bc38b565ae..8d5aa480ae04 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3395,6 +3395,14 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 		return NULL;
 	}
 
+	if (set->key->etype == EXPR_CONCAT &&
+	    list_empty(&set->key->expressions)) {
+		json_error(ctx, "Empty set type.");
+		set_free(set);
+		handle_free(&h);
+		return NULL;
+	}
+
 	if (!json_unpack(root, "{s:o}", "map", &tmp)) {
 		if (json_is_string(tmp)) {
 			const char *s = json_string_value(tmp);

--4QXrznYuPLGaHlyg--
