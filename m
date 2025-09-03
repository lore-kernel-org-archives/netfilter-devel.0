Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7742F2F3C30
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 11:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756898003; cv=none; b=REsuNx6Q5Nu3WmVdenmkTSN9Qnei1B2/IZkHJsYNVadFsEadA1FKtVlD52mElLU368PenHdBMxxoQg+yN1KIJBiapLMXZp2X3ast5eDZ9nctzghihGG+QcrnXxNXB6D674PqLqXzSkhBQMVuITBkOkUWYcE8HSqSVzbRAl3UV+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756898003; c=relaxed/simple;
	bh=TFjjTdbpG8a1UBLQGD2J3WrbvGbAVTdbd1bwyCTnZx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mfPwu2LUuJmxlJFV5og/7oya74LFqkFRu1Pjlx1TS36Mf0pKdq2ErHbS8EDAq11mRWO/tRVM5/wgyMKotxi93lpV1n3NLLFXHFHXtWGjyC7k2cQy7k+uFPHwrFCatL33idVwvdMMw9tUnbH7DqVlXZsBMqq6Q3MPvt0FGTkoKFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PO72v1zf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PO72v1zf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+nowqS12ICVRaNc+1GAOBry5g99qguzlTCEW1/9HH5Y=; b=PO72v1zfSQ+oZ/wYjRYc/YosuX
	N3eTolrnrrcWOLEr3LJj5isOZ2PN1XQCAoqcbXd5CnVFHl8H8lHsYjMVB0MOt7GvJrNvXGnI8klEt
	a2JcepDV8evKv0GJV/l6hj6gI9QXJF4qoJbOcJ4qzDpSAhZ7HOSWQxOICalIuMqAlTKuQAUF7wxP9
	OXIZ5P+LV+YUWYVrRB7ZUCKTcBBDv6uyko4SuMKAvnHS9lYOs00MkyEAWN9ef+hziTPj3+hTo2G+6
	WSmrU1q6nyNxSV2UY/wp8gSnAMq1nRet12jbSPRycBQNKbS0j1CtWCnhA1w+SRrM3MWNoYV2wgGqE
	y+0n8IFg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utlQV-000000004FD-0Hw4;
	Wed, 03 Sep 2025 13:13:19 +0200
Date: Wed, 3 Sep 2025 13:13:19 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 3/7] tests: py: Set default options based on
 RUN_FULL_TESTSUITE
Message-ID: <aLgizxSnV01aXTmf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250829155203.29000-1-phil@nwl.cc>
 <20250829155203.29000-4-phil@nwl.cc>
 <aLcOTrTUs5D95pKN@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLcOTrTUs5D95pKN@calendula>

On Tue, Sep 02, 2025 at 05:33:34PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 29, 2025 at 05:51:59PM +0200, Phil Sutter wrote:
> > Automake is supposed to set this for a full testrun.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  tests/py/nft-test.py | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > index 78f3fa9b27df7..52be394c1975a 100755
> > --- a/tests/py/nft-test.py
> > +++ b/tests/py/nft-test.py
> > @@ -1517,6 +1517,13 @@ def set_delete_elements(set_element, set_name, table, filename=None,
> >      signal.signal(signal.SIGINT, signal_handler)
> >      signal.signal(signal.SIGTERM, signal_handler)
> >  
> > +    try:
> > +        if os.environ["RUN_FULL_TESTSUITE"] != 0:
> > +            enable_json_option = True
> > +            enable_json_schema = True
> > +    except KeyError:
> > +        pass
> 
> I would revisit options for tests to:
> 
> 1) Run all tests by default, ie. native syntax and json.
> 2) Add options to run native syntax (-pick-one-here) and json test only (-j).

Ah, that's indeed a sensible measure - I did the same for
iptables-test.py and the nice side-effect is that adding a new test-mode
won't require education for callers, they just run it as well.

> 
> Option 1) (default) will be fine for make check... and CI in general.
> Option 2) will be only useful for development, for troubleshooting
> broken tests.
> 
> Then, add the env variable to shortcircuit tests with distcheck-hook:

The interesting part is missing here. ;)
I didn't find a better way to avoid test suite runs from 'make
distcheck' while retaining 'make check'.

Cheers, Phil
