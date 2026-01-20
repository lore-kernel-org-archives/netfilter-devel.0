Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED0043D4F5
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 14:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918127; cv=none; b=ndv0xOfjCKFXOgEONEeYzIJ8HJf42Q7e2/cyv2hgshlzdV/7IM5omT4ZLSyahuiMMFhZgeKiXqho+A0T/K+AHtgKRvUpH3VcZH1jeipDcMbNiidF+KlUy1reHHKH5rwES9MAhVI6BEM/C5iwUvSp/jLrStsbPZkg7PKs+pEjoJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918127; c=relaxed/simple;
	bh=vYYbY9T6Z32WUsF2w5OG9sC4VzZ0BygaKzma2AUtmmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pf79GVWF1cVFpbe9+Slqr/bKt2G0bwNbXKa/0fE5DFxPAEyWNiCq36wCanCDGTIS61URMKGLa77ZrHOdR30kewT7Yw31wEYkjEXMRd4fAijy/v9LooLe1TgD3uV4UaUJYUEQt7ay9qB0R9M1kFF73GDc4yOBTyt+YIjKXliohOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EFTYPvSW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EFTYPvSW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oVauxCrIupQ+blxMiaHTmOMth9byWfblu66C8WNi3Kw=; b=EFTYPvSW3EaXzG4f7gLLxQHySW
	Tvh91Z8OH42I4cyK1TNxLgLoBjnTziJ1Ah9xD3MOxI3s8tZqc0nocpFSlyY89LxP3F2o8iT1UFfIz
	XBHYE0N0mu1ZmWiYHUue9B0ne+ZV9vs+Wkf6tBGNVBWGieisDTF7Tqs+DNCUBe9LsW6JdKaZ0SKXf
	LI5nT0qhSBnM5SH2wrBIm5wN+Ee7gO5oDrm1ITmPu/BkZuNqVIirhEed8WtZGWazsl0aowZiW2Ias
	FTHq+7/441/C30O2C9I80bgwcRVeKGo6Y4l24aCibTCii0NibbPATseWTYtWivYzWwgzveGucAlbg
	1l7TItRA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1viCPL-000000007eK-3CXn;
	Tue, 20 Jan 2026 15:08:35 +0100
Date: Tue, 20 Jan 2026 15:08:35 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v5 1/3] parser_json: support handle for rule positioning
 in explicit JSON format
Message-ID: <aW-MY7iZLC-iVuht@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20260119140813.536515-1-knecht.alexandre@gmail.com>
 <20260119140813.536515-2-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119140813.536515-2-knecht.alexandre@gmail.com>

Hi Alexandre,

On Mon, Jan 19, 2026 at 03:08:11PM +0100, Alexandre Knecht wrote:
> Implementation details:
> - CTX_F_IMPLICIT flag (bit 10) marks implicit add commands
> - CTX_F_EXPR_MASK uses inverse mask for future-proof expression flag filtering
> - Handle-to-position conversion in json_parse_cmd_add_rule()
> - Variables declared at function start per project style

Thanks for your follow-up, just two nits:

[...]
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 7b4f3384..87266de6 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
[...]
> @@ -3201,6 +3209,18 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
>  		h.index.id++;
>  	}
>  
> +	/* For explicit add/insert/create commands, handle is used for positioning.
> +	 * Convert handle to position for proper rule placement.
> +	 * Skip this for implicit adds (export/import format).
> +	 */
> +	if (!(ctx->flags & CTX_F_IMPLICIT) &&
> +	    !json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
> +		if (op == CMD_INSERT || op == CMD_ADD || op == CMD_CREATE) {
> +			h.position.id = h.handle.id;
> +			h.handle.id = 0;
> +		}
> +	}

Please merge the nested if-conditionals. I suggest sorting expressions
from cheap to expensive:

|	if (!(ctx->flags & CTX_F_IMPLICIT) &&
|	    (op == CMD_INSERT || op == CMD_ADD || op == CMD_CREATE) &&
|	    !json_unpack(root, "{s:I}", "handle", &h.handle.id)) {

[...]
> @@ -4344,6 +4364,8 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
>  	};
>  	unsigned int i;
>  	json_t *tmp;
> +	uint32_t old_flags;
> +	struct cmd *cmd;

Please use Reverse Christmas Tree notation, i.e. reverse-sort variable
definitions by line length.

Thanks, Phil
