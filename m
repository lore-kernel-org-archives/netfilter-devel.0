Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE73207A0B
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 09:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762422990; cv=none; b=W2qfucmmcS/KOvLUFWVtyBeHn44GYS2IN/wt9AHwY2XI0pq+lgoU+14V3IoYWauKp8oxb7l41h2EgHN3G8IuFvZ0XXYyAJvMCVFRLZAV07Bt5IgKf61uNRAFrLxCcuR0Osy0uIFgZxA469tmYmS7b+qPsiWvQ6EiCHDM0gLYGz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762422990; c=relaxed/simple;
	bh=fqv4Y2a3t19Q/DPHWDXV+B64Op83PPY8yHE+kN4en/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzlIqfpCug5tgG/SjhmoCxSRm3KAvyeirONcFL6M+UeuAv1wMJldI7ynIZv4zNs69GTRBNifRoKJfdaU8yxWA6Q+jEome+fcvllQd+IZ5VmhSLkZWb0lbTewvlmdRYUhvy5OjMwWud+ZNMCeO137+9q4uQAq+6KwPGSANDZDCDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KzWiSVPR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KzWiSVPR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DGHVEUgUE/LFxsrnNsKnNZ7dkXIZUY4cnAuGiB0k6js=; b=KzWiSVPRsJJimKndXKu17p+R5/
	E2mO3WC5bGvVBi3BBoIm7656rXMx9/4wh2E/PxV4ZlrlkHdgPnqrvCHUakGs734fD0y0IZa1X+S+j
	3vhipDf4JMg46T0HqPr8rHIKg7rE8WuVKecVw9hKV4r8lTf0sxnkTOExwLYF/f4aMsRbSwexTYcuC
	pNVAL85VUfg2UMMjDqGGeO2lSmEL/GIclXxBKUEs1X0FDJbGTo6xqIoNJA296+FGSG0fy9W8XK01j
	jYMzeibaenws1ZkML/bDKFBLi2xhOlfoDeBs7yDG+czhVFcLPGH9reIHwX/78tn8R4QlQ7a3+hpQ2
	mN0nCaQA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vGwj5-000000000tX-1SMb;
	Thu, 06 Nov 2025 10:56:19 +0100
Date: Thu, 6 Nov 2025 10:56:19 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf v3] parser_json: support handle for rule positioning
 in JSON add rule
Message-ID: <aQxwwwlTFj12H8TN@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20251106083551.137310-1-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106083551.137310-1-knecht.alexandre@gmail.com>

On Thu, Nov 06, 2025 at 09:35:51AM +0100, Alexandre Knecht wrote:
> This patch enables handle-based rule positioning for JSON commands by
> distinguishing between explicit and implicit "add" operations:
> 
> - Explicit commands ({"add": {"rule": ...}}) route through
>   json_parse_cmd_replace, which converts the handle field to position,
>   enabling rules to be inserted at specific locations
> - Implicit commands ({"rule": ...} from export/import) continue
>   using json_parse_cmd_add, which ignores handles for backward
>   compatibility
> 
> The semantics are:
>   ADD with handle:    inserts rule AFTER the specified handle
>   INSERT with handle: inserts rule BEFORE the specified handle
> 
> This maintains export/import compatibility while enabling programmatic
> rule positioning via the JSON API.
> 
> Includes comprehensive test cases covering:
> - Multiple additions at the same handle position
> - INSERT before handle
> - Error handling for deleted handles
> - Export/import compatibility (implicit adds ignore handles)
> 

Fixes: fb557b5546084 ("JSON: Sort out rule position and handles in general")

> Link: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20251029224530.1962783-2-knecht.alexandre@gmail.com/
> Suggested-by: Phil Sutter <phil@nwl.cc>
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
> ---
>  src/parser_json.c                             |   7 +-
>  .../0008rule_add_position_comprehensive_0     | 135 ++++++++++++++++++
>  2 files changed, 139 insertions(+), 3 deletions(-)
>  create mode 100755 tests/shell/testcases/json/0008rule_add_position_comprehensive_0
> 
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 7b4f3384..b9b3bef0 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -4045,7 +4045,8 @@ static struct cmd *json_parse_cmd_replace(struct json_ctx *ctx,
>  		return NULL;
>  	}
>  
> -	if ((op == CMD_INSERT || op == CMD_ADD) && h.handle.id) {
> +	if (h.handle.id &&
> +	    (op == CMD_INSERT || op == CMD_ADD || op == CMD_CREATE)) {
>  		h.position.id = h.handle.id;
>  		h.handle.id = 0;
>  	}
> @@ -4328,9 +4329,9 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
>  		enum cmd_ops op;
>  		struct cmd *(*cb)(struct json_ctx *ctx, json_t *, enum cmd_ops);
>  	} parse_cb_table[] = {
> -		{ "add", CMD_ADD, json_parse_cmd_add },
> +		{ "add", CMD_ADD, json_parse_cmd_replace },
>  		{ "replace", CMD_REPLACE, json_parse_cmd_replace },
> -		{ "create", CMD_CREATE, json_parse_cmd_add },
> +		{ "create", CMD_CREATE, json_parse_cmd_replace },
>  		{ "insert", CMD_INSERT, json_parse_cmd_replace },
>  		{ "delete", CMD_DELETE, json_parse_cmd_add },
>  		{ "list", CMD_LIST, json_parse_cmd_list },

Doesn't this break "add" and "create" for all ruleset items other than
rules? Looks like the quick fix I suggested does not work at all, sorry.

Cheers, Phil
