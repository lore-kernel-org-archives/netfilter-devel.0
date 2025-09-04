Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE15136988
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757010838; cv=none; b=aEzNoMCPa6qOuQYqS3iCQJNdZlIFXa/ga/0lG6qCpJoTT7fb7bOYqikvFCBMX1X9SyNjF1SAFfub1WmzbSnGBAEU2pUw7Bwzk1ODLN4JhDHM8QZKV5tc+N6lSM81Fet769l3ovaxNLy49O42J0wa3EBVueFUtRicM+g2gN/dPP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757010838; c=relaxed/simple;
	bh=wQMbgPLt+cSiqmepnUH8JIKBCpkuFaHg+s9n0uFDSEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V1+rRDuD9cvZpl706nsh/xsUsWGXwwZ7jiN+fY6QA8MbdUuAfNlDhvKtfABIlkzOaDFNdS8xGV1rTBWf24hFPY3+jd/omRH9XYLQSzQ6oLvYS3UfDkf+UZ43uARlj8pGvaNw9g4aD18Pd0J+TYnmBeEfO1h+aNgSw1aTfiGrz6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HVdMbvIJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HVdMbvIJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1K+8TiqoB4k3E50aXvyf75GjJvxoQAe9Py2yQCjnqwI=; b=HVdMbvIJWjYgMLEYGX2emcY/RW
	9lk7drrWKfuJqdmu0Z78+7YXEDPsKG3GT5RN/94D6cyO1qUkQFvboP+ptWR8f+dGMunuHXpNJqV82
	Zvtfe36viHhHznTNu8X4s9NX5kH9JTzFukUoQ235e1+5frVop7LtWk1oIxXXDTeI45Le4o57AVrXP
	WK8EFAWH1xU76GVCene85gr7bR8/vjnKt2fp6B6+QoFieJyoLLHUSr3Y4Z2kCWl15xyRZAlAV0PjR
	/whFs0Jba17n9EAjG2aWB7BC6ZwaCE47rbAsDJnqoNycxcRkCbknAcztjFVf35wU3P/KU5b8acdgn
	Lup0VkkQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuEmN-0000000012N-165m;
	Thu, 04 Sep 2025 20:33:51 +0200
Date: Thu, 4 Sep 2025 20:33:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v4 2/8] tests: py: Enable JSON and JSON schema by
 default
Message-ID: <aLnbjSgT5GuY0SHX@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250904152454.13054-1-phil@nwl.cc>
 <20250904152454.13054-3-phil@nwl.cc>
 <aLmwcg4B6JwfqQfR@calendula>
 <aLm6kp0mJfge4_Me@orbyte.nwl.cc>
 <aLnEqJBm6tNK4IrQ@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLnEqJBm6tNK4IrQ@calendula>

On Thu, Sep 04, 2025 at 06:56:08PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 04, 2025 at 06:13:06PM +0200, Phil Sutter wrote:
> > On Thu, Sep 04, 2025 at 05:29:54PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Sep 04, 2025 at 05:24:48PM +0200, Phil Sutter wrote:
> > > > Introduce -J/--disable-json and -S/--no-schema to explicitly disable
> > > > them if desired.
> > > > 
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > ---
> > > >  tests/py/nft-test.py | 16 ++++++++++++----
> > > >  1 file changed, 12 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > > > index 984f2b937a077..12c6174b01257 100755
> > > > --- a/tests/py/nft-test.py
> > > > +++ b/tests/py/nft-test.py
> > > > @@ -1488,7 +1488,11 @@ def set_delete_elements(set_element, set_name, table, filename=None,
> > > >  
> > > >      parser.add_argument('-j', '--enable-json', action='store_true',
> > > >                          dest='enable_json',
> > > > -                        help='test JSON functionality as well')
> > > > +                        help='test JSON functionality as well (default)')
> > > > +
> > > > +    parser.add_argument('-J', '--disable-json', action='store_true',
> > > > +                        dest='disable_json',
> > > > +                        help='Do not test JSON functionality as well')
> > > 
> > > Would it be possible to have common options to the different tests?
> > > 
> > > 1/8 uses -s and -j.
> > > 
> > > I am not sure we have to worry about breaking backward for test
> > > syntax, we only run this.
> > 
> > It's a bit of a mess with nft-test.py as it always performs standard
> > syntax testing and JSON syntax is an add-on one may enable (or not). So
> > to test JSON only, I'd have to refactor the ~300 lines long rule_add()
> > function. Not the worst thing to do, but much more work than "just"
> > having --enable-json being the default.
> 
> Oh, I see, so this is:
> 
> * no -j, then only standard is tested.
> * -j, both standard and json are tested.
> 
> Maybe more simple is to reverse this logic, ie.
> 
> * no -j, then both standard and json syntax are tested.
> * -s, only standard is tested.

So basically rename -J to -s in my patch? ;)
Note that -s clashes with --schema (although one could drop it as my
patch enables it by default, as well).

> Does this help?

Let me suggest an alternative: I promise to refactor that famous italian
pasta style function into smaller chunks like:

- Gather test data from files
- Instantiate a rule object with methods:
  - apply()
  - json_apply()
  - validate_payload()
  - validate_listing()
- Perform checks as per user choice (-j, -s, both/none)

And we live with the inconsistent UI for now?

Cheers, Phil
