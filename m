Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCCD30C612
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 21:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756329003; cv=none; b=Iy+zILIZiSJlFaSyJ8UrsKKEZ+pNASHl7KkE49E7KxNm5BXGuuZxmBSdldcmh++msYETGe2dt/nw4kXos1vpU9sSR8qJEJwCZB5p/u+Uvqg5gWmfvSqavNVwYtei9dbhjqO/l/A1l5wQX1HC2bzeDueMSwnNZvTR2vQREGyHG7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756329003; c=relaxed/simple;
	bh=Wr1uaee//hnqJHW+ONznQQxeeOBW/xj7FUv9wmZMoEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFd15cAnOMuBRKjd3bQ0agm0AGgxbuxTrJbar0pO8p1UJTgl8fHDQ8/2+NQWCAtMQfvksAP26liCd+3TSRaY4KR0yVX0/R0Ap7rWyp9c7WcekRyHkkPNl4zkricCvGYBXoVf3/8CNquWWwITYe+I5mrqulxmAwIHCuWhAARw/rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=O8YshyZX; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="O8YshyZX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qN+7YGtbbM5X70cTrGJvDgZmwhEA2rHEF0rRivpS5d0=; b=O8YshyZXTrGHOmq8t6pizJfcH7
	N2INMWqjCe+RvPizgyYPo7DNq1jBZS73M2qNZo08VhZM1bN7nThRyPljh7FIbD3GF6RVsuB1SkXvU
	Qq6ZR3kk8hkWQJm1UEp/LOI0ZPnAL8u6l0hxaNpEvZ2iZqfoxjTQ+Xlwf/iKWi5MwKIPfC/zjnxQl
	3O0po7fxtWJ3kapgWQbgUSiSIYefyGHaRwNDYuRP3+cn1VIGEX7uzHs5et4nGWsSbaU5MgqEgV3w5
	adk64WqrQHNSFFZu4t9soX+pqT981H7D3uebCdJSPi59n/Rcwuy3WUKraiB/xKmVejJwOq7uugwnI
	X7M+Mr2Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1urNP6-00000000512-0Ubp;
	Wed, 27 Aug 2025 23:10:00 +0200
Date: Wed, 27 Aug 2025 23:10:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables monitor json mode is broken
Message-ID: <aK90KI8s-tyLGiVn@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <aK88hFryFONk4a6P@strlen.de>
 <aK9w1Zqmxa9evI4C@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK9w1Zqmxa9evI4C@orbyte.nwl.cc>

On Wed, Aug 27, 2025 at 10:55:49PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Wed, Aug 27, 2025 at 07:12:36PM +0200, Florian Westphal wrote:
> > as subject says, 'nft monitor -j' is broken.
> > Example:
> > 
> > ./run-tests.sh -j testcases/object.t
> > monitor: running tests from file object.t
> > monitor output differs!
> > --- /tmp/tmp.emU4zIN8UT/tmp.C4TeyO6xYk  2025-08-27 19:05:08.039619097 +0200
> > +++ /tmp/tmp.emU4zIN8UT/tmp.jBOL3aIrp5  2025-08-27 19:05:09.062551248 +0200
> > @@ -1 +1 @@
> > -{"delete": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0, "bytes": 26214400, "used": 0, "inv": false}}}
> > +{"delete": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0, "bytes": 0, "used": 0, "inv": false}}}
> > monitor output differs!
> > --- /tmp/tmp.emU4zIN8UT/tmp.C4TeyO6xYk  2025-08-27 19:05:10.095619097 +0200
> > +++ /tmp/tmp.emU4zIN8UT/tmp.Guz55knY19  2025-08-27 19:05:11.117393075 +0200
> > @@ -1 +1 @@
> > -{"delete": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0, "rate": 1, "per": "second", "burst": 5}}}
> > +{"delete": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0, "rate": 0, "per": "error"}}}
> > 
> > I did notice this weeks ago but thought it was a problem on my end
> > and then didn't have time to investigate closer.
> > 
> > But its in fact broken on kernel side, since
> > 
> > netfilter: nf_tables: Reintroduce shortened deletion notifications
> > 
> > In short, unlike the normal output, json output wants to dump
> > everything, but the notifications no longer include the extra data, just
> > the bare minimum to identify the object being deleted.
> 
> Oh crap, I missed this entirely.
> 
> > As noone has complained so far I am inclinded to delete the
> > tests and rip out json support from monitor mode, it seems noone
> > uses it or even runs the tests for it.
> > 
> > Alternatives i see are:
> > 1. implement a cache and query it
> > 2. rework the json mode to be forgiving as to what is set
> >    and what isn't in the object.
> 
> My suggestion:
> - Add special casing for NFT_MSG_DEL* with NFTNL_OUTPUT_JSON as well in
>   monitor.c
> - Pass 'bool delete' to monitor_print_*_json()
> - And on to *_print_json() (or implement *_print_json_bare() to
>   conditionally call from the above
> 
> > Object here also means any object reported in any delete kind,
> > not just NFT_MSG_DELOBJ.  This applies to set elements etc. too,
> > json expects the full info, but the kernel notifications no longer
> > provide this.
> 
> Yes, and there is no proper way to detect these incomplete objects. So
> the only way to fix it is to pass the message type into print routines.
> 
> Funny detail: JSON echo mode is unaffected because it ignores anything
> that's not an add command. %)

Oh, and there is also the same issue regarding flowtable hook deletion
vs. flowtable deletion as fixed by commit 18ddac660dfa1 ("monitor:
Correctly print flowtable updates"). :(
