Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFD82DB780
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 23:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773184143; cv=none; b=HnVdT8bLEv18xgjO6Fls7K+MRBVha6PbIqToRU3MFBhtqQcsEDg/9lr8Ee4lRPjdmW4/7NzrM5ammeCdr/7bAOFZW3t9fU4ZfO07userN2RV9d39Zgo2AKC7Ed53s+E3GFaLuTWVA6TM4om4A3GNz3Xx1eC/sZ408fJONedKfZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773184143; c=relaxed/simple;
	bh=ZKepyzWF9vZrdtPQWN0ODdLSvdYymTbVK+UsruI09X8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VKQULEPlWokNy8UGrz6HYqLPcVBzRAQr7s0E2wOQ1pFTjFaNVJySlXwTtK1ircPg8iVl3J6tIYOOFiDCHbY20eCHviA0aS2Ig6eqKV6cd7eU1wLqs/xhBJCefz0kHzeC+LD6c+y9zONCAec9LOOLutjVQFo51I/MNrToIgMxyCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=AsrC0CwN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="AsrC0CwN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eTyDEI1FRRcdKf1n4Vr7Cmc0p2zwShoYxtEbVXtnWAk=; b=AsrC0CwN2QNIrD0V5STDYTJUG8
	9XU/ITqYfQx6hrM13asZEubtG7n1qFQ9h06dUJhG2qlSyDX3JJu9wbJ0TemFy8+tdX7HK4Gp1Z5Na
	erv55A7vU0yJLmFb7VftsCFBj/sMXpGhh91mrfiRUuRS3+NYLj9e+c6a59OUOyt/K8KtjdXa1pllA
	yChtu3ONgaho4HUSKMtNFvCJYBf93AupBnq+geW3qpbgbuVVBISMV3w/gfvAZHeoEYa8RHQvzcY3d
	XSAEpnKJ4xw7tElSYPCQI7zgFmk0ZDXg3Lm1BpDhr0HYQFujkor1CIQjrwGOZytPGtjexOnbaakjN
	4ZZXjiFA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w06CB-000000004nP-0PcP;
	Wed, 11 Mar 2026 00:08:59 +0100
Date: Wed, 11 Mar 2026 00:08:59 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] tests: py: use `os.unshare` Python function
Message-ID: <abCki9aBa8wVBvQi@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20260305175358.806280-1-jeremy@azazel.net>
 <aasRsr93TOUuH_Xb@orbyte.nwl.cc>
 <20260306183553.GA5468@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306183553.GA5468@celephais.dreamlands>

Hi Jeremy,

On Fri, Mar 06, 2026 at 06:35:53PM +0000, Jeremy Sowden wrote:
> On 2026-03-06, at 18:41:06 +0100, Phil Sutter wrote:
> >On Thu, Mar 05, 2026 at 05:53:58PM +0000, Jeremy Sowden wrote:
> > > Since Python 3.12 the standard library has included an `os.unshare` function.
> > > Use it if it is available.
> > 
> > This patch breaks py test suite cases involving time-related matches,
> > e.g. 'meta time "1970-05-23 21:07:14"'. It expects:
> > 
> > | cmp eq reg 1 0x002bd503 0x43f05400
> 
> 	$ TZ=UTC-2 perl -MPOSIX=strftime -le 'my $ns = hex $ARGV[0]; print strftime "%Y-%m-%d %H:%M:%S", localtime int $ns / 1000000000' 0x002bd50343f05400
> 	1970-05-23 21:07:14
> 
> > but instead the rule serializes into:
> > 
> > | cmp eq reg 1 0x002bd849 0x74a8f400
> 
> 	$ TZ=UTC-2 perl -MPOSIX=strftime -le 'my $ns = hex $ARGV[0]; print strftime "%Y-%m-%d %H:%M:%S", localtime int $ns / 1000000000' 0x002bd84974a8f400
> 	1970-05-23 22:07:14
> 
> > Do you see that too?
> 
> Yes, e.g.:
> 
> 	6: WARNING: line 4: 'add rule netdev test-netdev egress meta time > "2022-07-01 11:00:00" accept': '[ cmp gt reg 1 0x16fda8f3 0x1977a000 ]' mismatches '[ cmp gt reg 1 0x16fdac39 0x4a304000 ]'
> 
> As with your example, the discrepancy is an hour:
> 
> 	$ TZ=UTC-2 perl -MPOSIX=strftime -le 'my $ns = hex $ARGV[0]; print strftime "%Y-%m-%d %H:%M:%S", localtime int $ns / 1000000000' 0x16fda8f31977a000
> 2022-07-01 11:00:00
> 
> 	$ TZ=UTC-2 perl -MPOSIX=strftime -le 'my $ns = hex $ARGV[0]; print strftime "%Y-%m-%d %H:%M:%S", localtime int $ns / 1000000000' 0x16fdac394a304000
> 2022-07-01 12:00:00
> 
> which suggests it's time-zone related.  Didn't see anything about that
> in the doc's.  Will take a closer look.  Apologies.

Yes, it's odd. Neither unshare module nor 'unshare -n' behave like this,
even though os.unshare is described as doing the same as unshare command
does. It also doesn't mangle os.environ['TZ'] value, no idea why it
messes with this.

> PS UTC-2 is exotic. :)

Maybe it's Ander Juaristi's native timezone, he added the tests in
commit 0518ea3f70d8c ("tests: add meta time test cases"). And then I
did:

commit 7e326d697ecf43ea029de5584e59701eb61ca87e
Author: Phil Sutter <phil@nwl.cc>
Date:   Sat Nov 16 22:32:18 2019 +0100

    tests/py: Set a fixed timezone in nft-test.py
    
    Payload generated for 'meta time' matches depends on host's timezone and
    DST setting. To produce constant output, set a fixed timezone in
    nft-test.py. Choose UTC-2 since most payloads are correct then, adjust
    the remaining two tests.
    
    Fixes: 0518ea3f70d8c ("tests: add meta time test cases")
    Signed-off-by: Phil Sutter <phil@nwl.cc>
    Acked-by: Ander Juaristi <a@juaristi.eus>
    Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

So that's how UTC-2 became py test suite's native timezone. :D

Cheers, Phil
