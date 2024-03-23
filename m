Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2BF611A
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2024 09:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711185442; cv=none; b=DN6davBJSQYg3q9VEiLhr5RKvIjRXFbASbBJ9csoNa6ltDJz+mryMDWMowoN80f0AGqSAT1m6k0rrcuS//i+q6FN31crpbNDUotVy9DZS7wlDkyyWcR/cdextDpciErTKNQB/AfFcj5qXX/EwTMTTJXTU/WOmuLaTyQgCcxC6Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711185442; c=relaxed/simple;
	bh=i4heoLYsCOL/zTXfaFGxK5P8THRHTZe2Sqd1d2wsmQg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eibdb0SJjiiy4SAgwT4xr4lWJhE+kRFqtpEUh46bbPfVvUeM91NC1D/kgwACE8Tabp9FnAtfPXfjhjit+/pyhbilqv9xLG16O9qo4JAy1Sp3oGeNWrcXOemXfux4LNvJOv++UZMifMu9XrW+HZTCJZpW3hW6BQe8LmMTL1azNwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gnumonks.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gnumonks.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
	(envelope-from <laforge@gnumonks.org>)
	id 1rnx9X-00ADyW-A3
	for netfilter-devel@vger.kernel.org; Sat, 23 Mar 2024 09:54:59 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.97)
	(envelope-from <laforge@gnumonks.org>)
	id 1rnx9O-00000003ByS-0QW4
	for netfilter-devel@vger.kernel.org;
	Sat, 23 Mar 2024 09:54:50 +0100
Date: Sat, 23 Mar 2024 09:54:50 +0100
From: Harald Welte <laforge@gnumonks.org>
To: netfilter-devel@vger.kernel.org
Subject: nftables documentation improvement?
Message-ID: <Zf6Y2s6eyrhlWLZz@nataraja>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Dear netfilter project,

In my recent interaction explaining nftables to some other users I am
under the impression that there is likely some improvement possible to
the nftables wiki.

The wiki is full of details about the individual expressions, actions,
etc. - but I think what's lacking (or I couldn't find it) is some kind
of conscise overall description of the terminology + the general
high-level architecture of the ruleset.

You can find some description in the first two paragraphs of 
https://wiki.nftables.org/wiki-nftables/index.php/Simple_rule_management
but that doesn't define the terms used (action, expression, statement,
...)

You can find an overview of the terms used in
https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes
[but then actually with imprecise language like "rule refers to an
action to be configured within a chain." while a rule actually consists
of matching expressions and an action"]

I'd be willing to try to write a proposed improvded text expressing what
I have in mind.  I'd prefer to do that as some separate wiki page as a
draft for you guys to review before deciding whether to use it in the
main wiki pages.  I just didn't want to write it as unformatted
plain-text here in e-mail and then later have to re-format in wiki
syntax.

So in short: If anybody would be willing to add an account for me, I'd
give it a shot and you can decide if you think what I'd consider an
improvement is also one in your point of view.

Thanks,
	Harald

p.s.: I'm not subscribed to the list since becoming emeritus status a long
time ago, so please Cc me in any responses.

-- 
- Harald Welte <laforge@gnumonks.org>          https://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
