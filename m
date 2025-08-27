Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DF61E260A;
	Wed, 27 Aug 2025 17:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756315536; cv=none; b=X0xJFnBj5+tE/JyutKpw+1tH+ogl4lSnq6W3zcY+KZ/1CZ62EnrmnDl0xGk/bdT4lcb46tkYb9qZ3nHka7oMGeetSOjknj8yJIzOKjRbfweah+0so5MVeiCMrmZbRUtPOhRIVULM6/EuVrTa93qbbH/4P9w0BuRzaQjPPOhFvto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756315536; c=relaxed/simple;
	bh=wm5q3311w3PMeL0qpicmfZ/AZ2IOTk8tndI7x4ZOfDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PgGvTblqJn39YWz0alcV8XAvq7MJ2z/amAfwf+WRLWaEh93CymbvVE86KObAbuilQgJOdE4vu5knDg5rLow6auwCkxhIjqMWYnypFlrMzIhNyz/GT8sDpELdFneZ9qrN/h6WPDLGRl4ov+jYRbOAskzwW/Nb7cbOr+eRzTjL0m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B99E36034D; Wed, 27 Aug 2025 19:25:31 +0200 (CEST)
Date: Wed, 27 Aug 2025 19:25:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Fabian =?iso-8859-1?Q?Bl=E4se?= <fabian@blaese.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2] icmp: fix icmp_ndo_send address translation for reply
 direction
Message-ID: <aK8_i-_-Kmbozl0H@strlen.de>
References: <20250825201717.3217045-1-fabian@blaese.de>
 <20250825203826.3231093-1-fabian@blaese.de>
 <aK7KYr5D7bD3OcHb@strlen.de>
 <e1bf6193-d075-4593-81ef-99e8b93a4f74@blaese.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1bf6193-d075-4593-81ef-99e8b93a4f74@blaese.de>

Fabian Bläse <fabian@blaese.de> wrote:
> To avoid unnecessary translations, I suggested the direction-specific checks.
> Another option is to simplify them to:
> 
>      if (!(ct->status & IPS_NAT_MASK)) { … }

Yes, you can update the test from
        if (!ct || !(ct->status & IPS_SRC_NAT)) {

to
        if (!ct || !(ct->status & IPS_NAT_MASK)) {

Not related to your change:

I suspect there is a very small risk that kcsan could report a data
race here, given ct->status can be modified on other CPU.

But maybe, while at it, replace this with
READ_ONCE(ct->status) & ...

> Correct — the change not only fixes SNAT-in-reply handling, but also adds
> proper handling for DNAT in the reply direction, which was missing entirely.
> I will update the commit message to reflect this.

Thanks!
