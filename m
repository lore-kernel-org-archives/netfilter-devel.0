Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C9922B8A2
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 07:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741765651; cv=none; b=G/Uusc3ku1Hrm3hAb5VJKGk0wAfcW5g6dc5lF6d91aFUDvEUf0OeOYFrmRTeZw/KIOoWOhX1TuSji1enzizheOYi9UmnSduZQLKRbM11KlIoo4OVQ2Rez1iYSa5brnURbHEfGqV4I6oxz3bQngw8wkkLjIbVSZY5N5piWWmurkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741765651; c=relaxed/simple;
	bh=QxlyWoAKAcsHwTLeljh4Bal9HDhmN6DewOtJH7dlGRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETMI0IA2rPBZ4aycXpMuYcj2DQ+yPtGJqluONs1a/6x60hBG2xC23J6AGsb1FoVaAU8GvCGKLZif/Xq17iAgjC32cHQ3q2lBW9REI79trgOzGwvtfNNeoGZG41UHal4I1TPqVPU5N+mTp/q5ruh0iS/n3+ryHqxoWEq9k1oxieo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsGoJ-0003LX-6u; Wed, 12 Mar 2025 08:47:27 +0100
Date: Wed, 12 Mar 2025 08:47:27 +0100
From: Florian Westphal <fw@strlen.de>
To: Corubba Smith <corubba@gmx.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2 2/8] ulogd: add ulogd_parse_configfile public
 function
Message-ID: <Z9E8D1XcLL2Lh_xW@strlen.de>
References: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
 <4d7fe1dc-73ee-4e9e-b418-8f5fb87c1e4c@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d7fe1dc-73ee-4e9e-b418-8f5fb87c1e4c@gmx.de>

Corubba Smith <corubba@gmx.de> wrote:
> Provide a new function `ulogd_parse_configfile()` in the public
> interface, which wraps `parse_config_file()` to parse a section of the
> config file and communicates found errors to the user. It can be used
> as a drop-in replacement because arguments and return value are
> compatible.

Most patches in this series no longer apply to ulogd2.git,
can you rebase and resend?

Thanks!

> +int ulogd_parse_configfile(const char *section, struct config_keyset *ce)
> +{
> +	int err;
> +
> +	err = config_parse_file(section, ce);
> +
> +	switch(err) {
> +		case 0:
> +			return ULOGD_IRET_OK;
> +			break;

Up to you if you want to change it or not; you can reduce one
indent level:

	switch(err) {
	case 0:
		return ULOGD_IRET_OK;
...
