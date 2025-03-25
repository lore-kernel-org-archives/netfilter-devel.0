Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CF423E356
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 06:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742882511; cv=none; b=jlDIzKa+8+8VN6hl9/IsgC77Wdy8JWzFu6nJZ+8iH4xaHaaYtmnywUv7QYA7CohQPC24NY1no9R4XXPew0FPNCKMy5Rym78xqnf2fsj7aZwGS2sazPPa/toKnIjA2yMkOcz1Sk3l32p+1PrFFmN1WzOFafoo4E3nGLdfjEWAux4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742882511; c=relaxed/simple;
	bh=5dN8Ev+lEDHLFPuxUVm/HwwsciezMd6SwyNdjOCbzys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZKsuJOP2TmlWn0sRXphYG/mYM1jwMWdoRqTty/PwjYFViecN1m2ah/eer1acIzjmlMdWFdqUcCrcHua8Ahq7RcoQD42rshuNQMJZ1X70oDSRCV4iEHLyRq/WqdvwFICkQztAxCdumfQu1Vk51JqYAPutP8ufinTjwB6Qv45phY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1twxMB-0001V0-Ne; Tue, 25 Mar 2025 07:01:47 +0100
Date: Tue, 25 Mar 2025 07:01:47 +0100
From: Florian Westphal <fw@strlen.de>
To: Corubba Smith <corubba@gmx.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2] nfct: add flow end timestamp on hashtable purge
Message-ID: <20250325060147.GB4481@breakpoint.cc>
References: <23d650c0-265b-4b74-afb3-17efba8c96b2@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23d650c0-265b-4b74-afb3-17efba8c96b2@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Corubba Smith <corubba@gmx.de> wrote:
> In polling mode during normal operation, as well as in event mode with
> hashtable when an overrun occurs, the hashtable is fully re-synced
> against conntrack. When removing flows from the hashtable that are no
> longer in conntrack, there is no way to get the actual end timestamp of
> the flow from conntrack because it is already gone. Since the last
> conntrack data in the hashtable for these flows will never contain an
> end timestamp in this case, set_timestamp_from_ct() will always fall
> back to using the current time, aka when the plugin determines that the
> flow disappeared from conntrack. That is only an approximation, but
> should be good enough; and certainly more accurate than no end timestamp
> at all.

Makes sense to me, I'll apply it later today unless there are
objections.
