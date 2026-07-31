Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D98C40759B
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 11:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498841; cv=none; b=hTqsvoFy7MH/c5mtzOtdiA8fhOJhGAF0FP/2K4Ows3zFqeA55KdY2ItqDIyTMAK01pWpBVdjIo5a7p2MERsmUO9t1G5ou3L5KsGPjxIsOuts2o4iCFy5cSsbCLyKuUrG44KQBoY20r50O2fX5jJJmd/BR84OdCT5iqGgRlMFRbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498841; c=relaxed/simple;
	bh=sBj6Fg2UEygDiBCzeHK0S/aXD8dKiWcPJBWg2y3Syjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HKySWB138pj9U+91mtxQw34H3wgWh2Czu0scbUhMgNjRf3WhjbHV12aeotsjJWXhMKuHFlnswMR60FEJchRhcVCvct6vHA+WImxUxpOEYWvjkw2kP4CF5fMKLKHXGPkiRobty3n1+/OMDsrEHxCI4bKovZmB+6ozOQbAhuNDOV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qx4cDIMG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qx4cDIMG"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B04DC60191;
	Fri, 31 Jul 2026 13:53:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785498834;
	bh=R8jA/J8PO79XI5ZXd6BXAwSEqp0qn+zNw0AID4mmPug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qx4cDIMGVfTh2Pl+ZHhGcR4lvg4z/rt/UYtlTGDmQo84ZxbuY12gypnfcESNJrOW0
	 H81a+ezHSVLqlooKa8spui0zU5mcqGdG701yiWq1E3s2IdFXUjwnjd5rZ30L2hNcHS
	 x2b2hBZSEReR6HHlNo+pIT6o5PZT0KgRUdQlJu8MQagLTgkXKiSESn30KxCoWvfnKH
	 l5rRTdMY8pHJYlLcHkgZgR9YT7RUiB0J9CeeYcPxQvN6N+WLDtOZHOvlWox++1w7Dw
	 fcqSvZ1ZSt0itEGempIAuR9YOy4hd8DUqATDx4Pl0VKh77DvWOn2sQZy8KOzsRXM9p
	 yC0JaXcaLA20g==
Date: Fri, 31 Jul 2026 13:53:52 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Avinash Duduskar <avinash.duduskar@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft v2] datatype: accept a numeric cgroupsv2 id on input
Message-ID: <amyM0DqEImxfc8gK@chamomile>
References: <20260729173748.1033454-1-avinash.duduskar@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260729173748.1033454-1-avinash.duduskar@gmail.com>

On Wed, Jul 29, 2026 at 11:07:48PM +0530, Avinash Duduskar wrote:
> nft prints non-existent cgroup names as the raw id using PRIu64, but
> cgroupv2_type_parse() only stats /sys/fs/cgroup/<identifier>, so the
> listing does not load back:
> 
>   # nft list set ip t s
>   table ip t {
>           set s {
>                   type cgroupsv2
>                   elements = { 50834 }
>           }
>   }
>   # nft delete element ip t s { 50834 }
>   Error: cgroupv2 path fails: No such file or directory
> 
> The element cannot be deleted by key once its cgroup is gone, only
> flushed with the set, and a dump does not restore. The json dump has
> the same problem, and the stale id has been visible in the wild since
> 2022 (see Link). tests/shell/testcases/packetpath/cgroupv2 already
> works around this in cleanup().
> 
> Fall back to integer_type_parse() when the path does not resolve, as
> boolean_type_parse() already does. The path lookup stays first, so a
> cgroup named as a number still resolves as a path. Improving the
> integer parser is left for a follow-up as discussed in v1.
> 
> Fixes: 38228087252c ("src: add cgroupsv2 support")
> Link: https://lore.kernel.org/netfilter-devel/fabde324-383a-622c-7e69-32c9b2d06191@gmail.com/
> Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
> ---
> Changes since v1 (https://lore.kernel.org/netfilter-devel/20260727082427.740789-1-avinash.duduskar@gmail.com/):
> - drop the strict decimal parser, delegate to integer_type_parse()
>   (Pablo, Phil)
> - json test arm uses a here-string instead of a tempfile (Phil)
> - shorter commit message and test
> 
>  src/datatype.c                                |  13 +-
>  .../shell/testcases/parsing/cgroupv2_stale_id | 129 ++++++++++++++++++
>  .../parsing/dumps/cgroupv2_stale_id.json-nft  |  11 ++
>  .../parsing/dumps/cgroupv2_stale_id.nft       |   0
>  4 files changed, 151 insertions(+), 2 deletions(-)
>  create mode 100755 tests/shell/testcases/parsing/cgroupv2_stale_id
>  create mode 100644 tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.json-nft
>  create mode 100644 tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.nft
> 
> diff --git a/src/datatype.c b/src/datatype.c
> index 4dbca16e..5b3b350c 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -1665,9 +1665,18 @@ static struct error_record *cgroupv2_type_parse(struct parse_ctx *ctx,
>  		 SYSFS_CGROUPSV2_PATH, sym->identifier);
>  	cgroupv2_path[sizeof(cgroupv2_path) - 1] = '\0';
>  
> -	if (stat(cgroupv2_path, &st) < 0)
> +	if (stat(cgroupv2_path, &st) < 0) {
> +		struct error_record *erec;
> +		int stat_errno = errno;
> +
> +		/* the listing prints a raw id once the path is gone */
> +		erec = integer_type_parse(ctx, sym, res);
> +		if (!erec)
> +			return NULL;
> +		erec_destroy(erec);

Any reason to ignore the error that integer_type_parse() provides?
Instead I would suggest:

                if (erec)
                        return erec;

Thanks.

>  		return error(&sym->location, "cgroupv2 path fails: %s",
> -			     strerror(errno));
> +			     strerror(stat_errno));
> +	}
>  
>  	ino = st.st_ino;
>  	*res = constant_expr_alloc(&sym->location, &cgroupv2_type,
