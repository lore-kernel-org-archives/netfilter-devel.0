Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEF41339A4
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jul 2025 09:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753350270; cv=none; b=awP04EHLkdl52qWKZqYzXhy95hgAC96O/obYMbPirm20PstvbH5f+IoQaN0yh0mCvXb/2koFr0tG7oGn+nPbnoABd6QD+NiXdT5QVh82/E/+OQQK4han+95mV9WU7uShP9xWe4FC1WgNiUKil1YkXGT3I3zaRvLy/bcAvAtuqtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753350270; c=relaxed/simple;
	bh=RQyUh0mRKrlUSyPyR/FZhZdRoQHnhOMByiZYyAMau+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gz85UXXJb3w6gMoDw/1d4Gnf8qXjIUNzFf8Jc+TYtSstezIbZLvHTMbeySWQKPIKCTdP3otkWV76z2INI5OcSEtzFyRsqdzH2ab7zN4zhlK8Hfz/v8A3fOUOREd0hquvizDd1KiXofwkU8729cf+olsThcGWVxb8h8nsxSByd+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=h9OR5tql; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=h9OR5tql; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="h9OR5tql";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="h9OR5tql"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C649C60264; Thu, 24 Jul 2025 11:44:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753350258;
	bh=Hfcy5osnuVn6lyZQ5skrXUzz5fJaMV2YeRh61TKBQQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h9OR5tqlabyjJ0xQUPcvQFDp6zRDrRjBOtUnNbZDP98UcY7Z5RWvKedBtykqCV8on
	 EnLhK+aSS+6VMzYMqfp9zveW12my8ebWnIbgR/2h8d8+ISdFVL3G3I2OK5PfabnYyn
	 w0knO9DCgHpI7NIVu1IgVuoBmTvWsV0mwdvgTZrrln1rYReeph2KCebaBxLSvLgAdG
	 IwLCwbpUH2TuqDiemS4qGMAloNNlzTP6So0Kfnt6IqDS3tebsapnvnAsHcAcy+9gZs
	 +xFDcJQTuSG9cPxnFKz2StMBu7atgeeorCg+OORLwjz9xKmH4huaaT+uikbIqOjo2Y
	 5iuG1979fwbtA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1C6D660253;
	Thu, 24 Jul 2025 11:44:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753350258;
	bh=Hfcy5osnuVn6lyZQ5skrXUzz5fJaMV2YeRh61TKBQQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h9OR5tqlabyjJ0xQUPcvQFDp6zRDrRjBOtUnNbZDP98UcY7Z5RWvKedBtykqCV8on
	 EnLhK+aSS+6VMzYMqfp9zveW12my8ebWnIbgR/2h8d8+ISdFVL3G3I2OK5PfabnYyn
	 w0knO9DCgHpI7NIVu1IgVuoBmTvWsV0mwdvgTZrrln1rYReeph2KCebaBxLSvLgAdG
	 IwLCwbpUH2TuqDiemS4qGMAloNNlzTP6So0Kfnt6IqDS3tebsapnvnAsHcAcy+9gZs
	 +xFDcJQTuSG9cPxnFKz2StMBu7atgeeorCg+OORLwjz9xKmH4huaaT+uikbIqOjo2Y
	 5iuG1979fwbtA==
Date: Thu, 24 Jul 2025 11:44:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser_bison: fix memory leak when parsing flowtable
 hook declaration
Message-ID: <aIIAbqru_zAWLtFv@calendula>
References: <netfilter-devel>
 <20250723150021.10811-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250723150021.10811-1-fw@strlen.de>

On Wed, Jul 23, 2025 at 05:00:11PM +0200, Florian Westphal wrote:
> When the hook location is invalid we error out but we do leak both
> the priority expression and the flowtable name.  Example:
> 
> valgrind --leak-check=full nft -f flowtable-parser-err-memleak
> [..] Error: unknown chain hook
> hook enoent priority filter + 10
>      ^^^^^^
> [..]
> 2 bytes in 1 blocks are definitely lost in loss record 1 of 3
>    at: malloc (vg_replace_malloc.c:446)
>    by: strdup (in libc.so.6)
>    by: xstrdup (in libnftables.so.1.1.0)
>    by: nft_lex (in libnftables.so.1.1.0)
>    by: nft_parse (in libnftables.so.1.1.0)
>    by: __nft_run_cmd_from_filename (in libnftables.so.1.1.0)
>    by: nft_run_cmd_from_filename (in libnftables.so.1.1.0)
> 
> First two reports are due to the priority expression: this needs to call
> expr_free().  Third report is due to the flowtable name, the destructor
> was missing so add one.
> 
> After fix:
> All heap blocks were freed -- no leaks are possible
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks
