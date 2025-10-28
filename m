Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0E334C804
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673050; cv=none; b=tu+EmxpEUDVZhzkUCWsBiJvIJdRghZeMfxsIjkwAlHeqvETHJ0uvyuCjn5grutnpCeEZnQJox2+Lf1gV3LMSI7xaBcLO7zOo0+Y1h//VA9L8EhSkXjrcC4mdB07HWetpqh6r+u0DwtPDOJM05KDfl9YXPJvFKJOt8cyxlaUoXo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673050; c=relaxed/simple;
	bh=m3S8BDFRVNXDYyOT6GiJ2sFDTuGDJjB2++aU6j9JyqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uYqr+nt2DvItcIZtroAAeaIIfg1Xj6K0LzZGn/lLeYf6RRKVk6DORZWhD79OHi2vE3PCJYrZp1PSuU8hc+r8JfnqbaR/K4af7KzsAIEeBSCszIh3tovHYKUXBLn/TmDtM/IAe1fJxdEKZElaQiItlb4h/bGOLTv2TMMEMWIPQqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6999861B21; Tue, 28 Oct 2025 18:37:26 +0100 (CET)
Date: Tue, 28 Oct 2025 18:37:26 +0100
From: Florian Westphal <fw@strlen.de>
To: Jan Engelhardt <ej@inai.de>
Cc: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 8/9] tools: flush the ruleset only on an actual dedicated
 unit stop
Message-ID: <aQD_VkOf5ZA22DDK@strlen.de>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
 <20251024023513.1000918-9-mail@christoph.anton.mitterer.name>
 <q48p3nq8-5969-0qp9-po30-nrn7s1q53109@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q48p3nq8-5969-0qp9-po30-nrn7s1q53109@vanv.qr>

Jan Engelhardt <ej@inai.de> wrote:
> >@@ -19,7 +19,15 @@ RemainAfterExit=yes
> > 
> > ExecStart=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
> > ExecReload=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
> >-ExecStop=@sbindir@/nft flush ruleset
> >+ExecStop=:/bin/sh -c 'job_type="$$( /usr/bin/systemctl show --property JobType --value "$$(/usr/bin/systemctl show --property Job --value %n)" )"\n\
> >+                      case "$${job_type}" in\n\
> >+                      (stop)\n\
> >+                       @sbindir@/nft flush ruleset;;\n\
> >+                      (restart|try-restart)\n\
> >+                       printf \'%%s: JobType is `%%s`, thus the stop is ignored.\' %n "$${job_type}" >&2;;\n\
> >+                      (*)\n\
> >+                       printf \'%%s: Unexpected JobType `%%s`.\' %n "$${job_type}" >&2; exit 1\n\
> >+                      esac'
> 
> No, let's not do this.

Agree, thanks Jan for reviewing.
