Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48A32AD25
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 16:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758818740; cv=none; b=F1bdJL8yj52OYocZ5S4FOdH9zESav3BiYZdUzTQM02CdimtNsZbGBUdyuNmbBdiAVt22eUhZx8od949Wo0Rz/RlZw0hSKuQwWu+UpChHeOWaEI5f93iqrnLfLwvMm0X7oK5QU6kqi083Xn1h6r+pzEg4DtryCS/Dt8Le1TkoZRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758818740; c=relaxed/simple;
	bh=0+rezIJXHr6uoRrQXmshviapGKORSlW1uX8YUJnUN5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h7x4w+CXRiG2+P+BVVWi8Aok/Fu56nJ2PJ/MGsj7ViPig8bJjVlbIej8pdYnwLx4ChuPNoI7CW61v+opEqCGaKvM2mB7cuRK8kFur98DKRB2iz+tppDbUEXhfOBEh4LaMZd03TZCHC9tYcmsGhi+paiGYJlGrkyuXd4n2cYmtxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CC36960698; Thu, 25 Sep 2025 18:45:34 +0200 (CEST)
Date: Thu, 25 Sep 2025 18:45:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: bug: nft -n still shows "resolved" values for iif and oif
Message-ID: <aNVxqaP7iZpeMh6S@strlen.de>
References: <f2c46dc450b3223834cd837882877f892b234491.camel@scientia.org>
 <aNVUxFz1RDsu7wuk@strlen.de>
 <658f160530a48d923a345334fca2729c879762de.camel@scientia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <658f160530a48d923a345334fca2729c879762de.camel@scientia.org>

Christoph Anton Mitterer <calestyo@scientia.org> wrote:
> On Thu, 2025-09-25 at 16:42 +0200, Florian Westphal wrote:
> > Christoph Anton Mitterer <calestyo@scientia.org> wrote:
> > > IMO especially for iif/oif, which hardcode the iface ID rather than
> > > name, it would IMO be rather important to show the real value (that
> > > is
> > > the ID) and not the resolved one.
> > 
> > Seems like a bad idea.  Existing method will make
> > sure that if the device is renamed the output will change.
> 
> But AFAIU only when it's renamed, not when it's e.g. removed and then
> brought back?

Sure, only when renamed.  When you remove it raw value is shown
and it won't match anymore.

> I mean sometimes (admittedly rarely) I unload for example my wifi
> driver modules and reload them (when the driver or firmware got in a
> weird state and doesn't seem to recover).
> Then my wifi iface would get a new ID, wouldn't id?

Sure but why do you use iif with a interface that gets removed in
between?

> Maybe one could make iif/oif a special case... where the numeric value
> is written and in a comment "(current: <name>)"?

I find that even worse compared to new command line option and i don't
see what added value it would provide or what confusion it would avoid.

iif and iifname are not the same and people should not expect them to
be.

If you use iif, then you specifically ask to continue matching on rename
of the interface, whereas iifname would stop matching.

If you use iifname, then you ask to match when interfaces get brought up
and down dynamically, e.g. ppp/dialup or virtual vpn interfaces.

Really, just use iifname if in doubt.
