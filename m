Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BB22264BA
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 16:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757002390; cv=none; b=CDDWcWipwIo+GY5zAgtCRVOLh64MkKwEkObDOQpLwM5H2W4IBPhiM8WG+2kzpvfSceGXATXt/WItFFqzg7UmkbvQip4z+USDkyKJNyv5pWHrjxDaLlu6S9rEg9kATKYIsoCSKX+3oNKYKcqzO9aHJrjAESCbYK/et6u/petMP1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757002390; c=relaxed/simple;
	bh=EfbSakiE+SCdhsNQiZC+joDHf/xCx0pU8xoavoMK9VM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=setKFECU8f1YUKwNEdqwnL5KGnjpjCMgYN+Sxa3GZMAWQkDE0xXXjebAVNp/AvWXb7bwJN40LCcPNpLXfazEch2sFPEsXcruMXxJMjF6s606qDY1RtwxO0Kck7RwAqbrEqfLMxGgUzkTnoUiQr1D0EAOfQBUwtqlRXyavXY1T78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GhzS38rK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GhzS38rK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ep+wP4oUnWldvKFlPIQgWfod23qQiz1z2O9zaxYcIKs=; b=GhzS38rKx/lj55NkvRLBNsKZhr
	SLfF7um2yITvX2N/Y9sC2eRfilmUa3e2Jdc7MN51MR9B4vhfcT1olVrcgpATPi4HjxNvAr+IK/iLT
	dJ38v7e7eVGgBd/TZfHfo7HdUvjb/Q3IHaMkHlgBEos0ZqxIeCnL4S+/mAWwmUORjeTbj0r4shJSq
	0petT+ZxgYWJTz2J3INPmgvDZvlM37EsZ2vJ0zNFKBBifMtaUP+DXXsjf5eE2mx4R1R+YPVr7pZYa
	VetuTodQKCxKMEP1pjiM5pEXTTShYDo51Q5ueUJ13l/MI3W5ySE+9uffbfiovNP7txK7HQ2nIa5a3
	teHVpiFA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuCaA-00000000179-293X;
	Thu, 04 Sep 2025 18:13:06 +0200
Date: Thu, 4 Sep 2025 18:13:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v4 2/8] tests: py: Enable JSON and JSON schema by
 default
Message-ID: <aLm6kp0mJfge4_Me@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250904152454.13054-1-phil@nwl.cc>
 <20250904152454.13054-3-phil@nwl.cc>
 <aLmwcg4B6JwfqQfR@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLmwcg4B6JwfqQfR@calendula>

On Thu, Sep 04, 2025 at 05:29:54PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 04, 2025 at 05:24:48PM +0200, Phil Sutter wrote:
> > Introduce -J/--disable-json and -S/--no-schema to explicitly disable
> > them if desired.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  tests/py/nft-test.py | 16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > index 984f2b937a077..12c6174b01257 100755
> > --- a/tests/py/nft-test.py
> > +++ b/tests/py/nft-test.py
> > @@ -1488,7 +1488,11 @@ def set_delete_elements(set_element, set_name, table, filename=None,
> >  
> >      parser.add_argument('-j', '--enable-json', action='store_true',
> >                          dest='enable_json',
> > -                        help='test JSON functionality as well')
> > +                        help='test JSON functionality as well (default)')
> > +
> > +    parser.add_argument('-J', '--disable-json', action='store_true',
> > +                        dest='disable_json',
> > +                        help='Do not test JSON functionality as well')
> 
> Would it be possible to have common options to the different tests?
> 
> 1/8 uses -s and -j.
> 
> I am not sure we have to worry about breaking backward for test
> syntax, we only run this.

It's a bit of a mess with nft-test.py as it always performs standard
syntax testing and JSON syntax is an add-on one may enable (or not). So
to test JSON only, I'd have to refactor the ~300 lines long rule_add()
function. Not the worst thing to do, but much more work than "just"
having --enable-json being the default.

Cheers, Phil
