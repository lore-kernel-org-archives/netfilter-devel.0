Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D642E2022CF
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 07:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730186053; cv=none; b=pUgjq0ZusL0lD6yixQEjcL55AcmiaPd3yufTbvuYxXN8/XE6VygM+pVVqBiIki/M3hJ/CK6XKRNEMY1zJQuNI/3VbiUM5onbZZWpeKebwikjruiF8A58aYFJbRhzrCOEpzfrfs6S0m4BncOvSZlAcJCkDMNhOOl/ku5QliGjwZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730186053; c=relaxed/simple;
	bh=p2brhliS19c3CU5S3evjoWN8ibQO6V3uK/Qlw8eFivs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UC4B1W3hkAxamtpk+8i3uov1TX+iGMF3YC9yUDd1VYEzHm5kV03iONJw3O+s5QBPOtXoQht2qYBA/T/ETVHYwhJy2NWnd8G5ZalqA8inpk03nUUZnAebpON5ARB3rTmH+O+5mds27Hj4PX0bdS8e0J0kjufLbBPZq+jAHx3kzzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t5gQU-0004Pf-0F; Tue, 29 Oct 2024 08:14:02 +0100
Date: Tue, 29 Oct 2024 08:14:01 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: don't rely on writable test directory
Message-ID: <20241029071401.GA16769@breakpoint.cc>
References: <20241022140956.8160-1-fw@strlen.de>
 <ZyAeJ0lvifWevOuM@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyAeJ0lvifWevOuM@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Oct 22, 2024 at 04:09:54PM +0200, Florian Westphal wrote:
> >  tmpfile1=$(mktemp -p .)
> > -if [ ! -w $tmpfile1 ] ; then
> > +if [ ! -w "$tmpfile1" ] ; then
> >          echo "Failed to create tmp file" >&2
> > -        exit 0
> > +        exit 77
> >  fi
> >  
> > +trap "rm -rf $tmpfile1 $tmpfile2" EXIT # cleanup if aborted
> > +set -e
> > +
> >  tmpfile2=$(mktemp -p .)
> > -if [ ! -w $tmpfile2 ] ; then
> > +if [ ! -w "$tmpfile2" ] ; then
> >          echo "Failed to create tmp file" >&2
> >          exit 0
> 
> this does not return 77, see below...

I only changed first invocation, if pwd is ro, that will
have failed already.

I can make that consistent if you prefer.
