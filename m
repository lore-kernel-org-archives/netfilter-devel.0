Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0C81DF989
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 09:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730195332; cv=none; b=qRmFpwy9pflN3RF3mj2evBwD/hi5Hk9SjOKE/dKG/kEcuLHojbQBNHbNTnKgys7+MUr4tVUw71QI4ua4ZrZ8QDxDl+vHKXlXvqtF6YWp3KGekCa+9PlEpaiwg/YgPtLJc3E9haT3/bOupv+KgU/OgeIoaSW2ziRjqCO3/8bkK58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730195332; c=relaxed/simple;
	bh=lJa/t4sDF5ro77BvNn1Pz3Z4naoXMJeAH+JbAyCaiPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYPtAhQ70Qc55NEegKt7ihl3xEsP22O+HerVi8MOmL9jZMUOyGN3G8ymwgHZRAxXNb/029WQifIu2a8qngil6d/pGdp+sVQIEqNxptYmZgYAXCNVzjduHe/khhNpMrYq2LVpPINT+N0l4J6XNrjU4grPvr9aWxnekPe+v8qHWc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=55038 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t5iqA-006fui-9E; Tue, 29 Oct 2024 10:48:44 +0100
Date: Tue, 29 Oct 2024 10:48:40 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: don't rely on writable test directory
Message-ID: <ZyCveExccCSaK4sA@calendula>
References: <20241022140956.8160-1-fw@strlen.de>
 <ZyAeJ0lvifWevOuM@calendula>
 <20241029071401.GA16769@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241029071401.GA16769@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Tue, Oct 29, 2024 at 08:14:01AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Oct 22, 2024 at 04:09:54PM +0200, Florian Westphal wrote:
> > >  tmpfile1=$(mktemp -p .)
> > > -if [ ! -w $tmpfile1 ] ; then
> > > +if [ ! -w "$tmpfile1" ] ; then
> > >          echo "Failed to create tmp file" >&2
> > > -        exit 0
> > > +        exit 77
> > >  fi
> > >  
> > > +trap "rm -rf $tmpfile1 $tmpfile2" EXIT # cleanup if aborted
> > > +set -e
> > > +
> > >  tmpfile2=$(mktemp -p .)
> > > -if [ ! -w $tmpfile2 ] ; then
> > > +if [ ! -w "$tmpfile2" ] ; then
> > >          echo "Failed to create tmp file" >&2
> > >          exit 0
> > 
> > this does not return 77, see below...
> 
> I only changed first invocation, if pwd is ro, that will
> have failed already.

Right.

> I can make that consistent if you prefer.

Sure, go ahead and push this out if it helps you with virtme-ng

Thanks!
