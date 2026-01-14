Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB19C38F249
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Jan 2026 15:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768404179; cv=none; b=dHWmDxWx/CU6hrfHyqSFwMWxxVZUi+ihtMA4MPAlew/XqtFNBKVEjXMttzbw9RKMEk+Mii+NbZXocw2jmQugAmxN1g7j11EXJQxECFUrCzG08hUGqdu1Qg/waaUXCSYfqk3IF5hY346haFU1KGfp+ld3BMN2rGXzBNWso8Bn77c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768404179; c=relaxed/simple;
	bh=1h6/C0hvpiiGzZPwV7PBsWUiPt2QaQu1yXqQUa4ZM7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OyNvTYQIjNo6bhJi4gJz/tkCODu1Z+bsxkRetUCguEKwzTQiemVK8WakDYsixTSRHQHTPT7VIbNwD4K8cPlbntdwDBltwSNiMpvV1giQOTxggN7aJWQTznUnmBQ7IHecUi9tzFw6v7XSk49myAVOiHq+V9GcynLkLINQhwQ9L7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=F2AkO80y; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="F2AkO80y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Y0KP+BjQierowUNQ7oMQkV3riAqaHafbRwXaTuETB0Q=; b=F2AkO80y9/+3ghUXrTki898JRv
	JDtCdTfLVNnQe/jZa5LIIqd5jOrD88JG5+Y987/3mC9UfX/nRtIjw+pmgyDvSp7+baBXpyNQ6pcN9
	nAewAcWZWTFxVZuR503+iZEUX32dpVhv9crf/sTXj327dnAmY4giB5pxtHQThz0Dl6KR3/POFPFe6
	bRlGKyPfxKKlXzeyRXiWCi6ClB77DVBjJLvviKuY1XXG/4sKr5sSC9hLCPYD+Xysq1m/a08poLlea
	slu7L9kZathb8OemDGmyr0LBkFLZuRgSp5c4beUYgYmosCCt+MLrvtnkQPsiqLprUn9sR3mRCH5Tv
	lvIk6jJQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vg2b7-000000005UR-0CvF;
	Wed, 14 Jan 2026 16:15:49 +0100
Date: Wed, 14 Jan 2026 16:15:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: Georg Pfuetzenreuter <georg@syscid.com>
Cc: netfilter-devel@vger.kernel.org,
	Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
Subject: Re: [nftables PATCH] json: support element output
Message-ID: <aWezJQrNDkICYd2M@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Georg Pfuetzenreuter <georg@syscid.com>,
	netfilter-devel@vger.kernel.org,
	Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
References: <20251203131736.4036382-2-georg@syscid.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203131736.4036382-2-georg@syscid.com>

Hi Georg,

Sorry for the late reply, I missed your mail last year and am still
recovering from the "big reset". ;)

On Wed, Dec 03, 2025 at 02:17:36PM +0100, Georg Pfuetzenreuter wrote:
> From: Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
> 
> JSON was skipped for `get element` operations. Resolve this by
> introducing JSON output handling for set elements - the structure is
> kept close to what's already implemented for `list set`.
> 
> Signed-off-by: Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>

Patch looks fine apart from:

[...]
> +int do_get_setelems_json(struct netlink_ctx *ctx, struct cmd *cmd, bool reset)
> +{
> +	struct set *set, *new_set;
> +	struct expr *init;
> +	json_t *root = json_array();
> +	int err;

Please stick to reverse christmas tree notation here, i.e. put the
json_t *root on top of the list.

> +
> +	set = cmd->elem.set;
> +
> +	if (set_is_non_concat_range(set))
> +		init = get_set_intervals(set, cmd->expr);
> +	else
> +		init = cmd->expr;
> +
> +	new_set = set_clone(set);
> +
> +	json_array_insert_new(root, 0, generate_json_metainfo());
> +
> +	err = netlink_get_setelem(ctx, &cmd->handle, &cmd->location,
> +				  cmd->elem.set, new_set, init, reset);
> +	if (err >= 0)
> +		json_array_append_new(root, set_print_json(&ctx->nft->output, new_set));

This line exceeds 80 columns, no?

Also, could you please add a test case? A simple one in
tests/shell/testcases/json/ to make sure 'nft -j get element' output is
as expected should be fine.

Thanks, Phil
