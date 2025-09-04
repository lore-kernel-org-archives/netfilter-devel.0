Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BAD2E88B0
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 22:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757024984; cv=none; b=JGIVcJ83w9xk+1K7jzrW6p05J5jJ3iihq3Gjd4cNd4co/LL7ZPiL8zZIIgMD70tgVuXY9e3sqVs7vutMzNJrnMq/+xzxDu8X7z2IxKugeStwwt40y9OXlZRLhz2HruoI+sFghVbHd8ryJTnQAxXOrzExBDu4/yDFsmeV1q1TeU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757024984; c=relaxed/simple;
	bh=zY1kWxSoCtj5xT1u6NlFPjk4S3noh++4aDkC0X6zCWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVh7hy5iuWgIPhunUVn2OZ1L9kSp2Q6KdvqOCj1MZo4juPppyKRoHis8dyq5QbM+POAEHfklJf0lRi/Wv1vnysVjF13ciw6wgFQnt+gujhIO7P8U/wdlaDRUDASOV9SKGjcK9zlZeaCPHAdxPvtVgEMrj4hLLhmnIN/R1doPngs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=oc2bxN0J; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="oc2bxN0J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hxeRmW5IXx5nVL1SyqsHTwBBR9yS45GG8s2sARtQJ7A=; b=oc2bxN0JmR6pnH5uBmTSKrZGRt
	ZLWTESGO0vByz4UTJCLhEnX7y0P1D/mN6lKTTZNwU/Az6WUHlyBQvaW+hD4hdNS6z8hB3oI1uFd/8
	2tobWNjf5yS6QlHN5yMFB4WQho7hwfi6+USgUSJTul8QgnSfAL5iEk6d+u0T2qF0rPhQ4980v+F7H
	GlS8tfCOmYOPxiJ5jjSUZjkDqRqrgwrd+xW14oON8JTequIZN8W7lq34rkSTykcF74+Bv6ZRbj862
	stsNN3HINDVvnR0g2aYo5/bCZEzRIW9CjYIHkWnLDY/CK6DGEifN9j2Zek8uN4OW8ItRL8/7TJNqp
	k4WRgwHQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuISa-000000003i1-3Ym1;
	Fri, 05 Sep 2025 00:29:40 +0200
Date: Fri, 5 Sep 2025 00:29:40 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v5 2/3] parser_bison: Accept ASTERISK_STRING in
 flowtable_expr_member
Message-ID: <aLoS1AjaK4ml3Csd@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250731222945.27611-1-phil@nwl.cc>
 <20250731222945.27611-3-phil@nwl.cc>
 <aLmuUveL_X-grotG@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLmuUveL_X-grotG@calendula>

On Thu, Sep 04, 2025 at 05:20:50PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Fri, Aug 01, 2025 at 12:29:44AM +0200, Phil Sutter wrote:
> > All clauses are identical, so instead of adding a third one for
> > ASTERISK_STRING, use a single one for 'string' (which combines all three
> > variants).
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Changes since v3:
> > - Cover interface wildcards in nft.8
> > ---
> >  doc/nft.txt        | 30 ++++++++++++++++++++++++++----
> >  src/parser_bison.y | 11 +----------
> >  2 files changed, 27 insertions(+), 14 deletions(-)
> > 
> > diff --git a/doc/nft.txt b/doc/nft.txt
> > index 8712981943d78..42cdd38a27b67 100644
> > --- a/doc/nft.txt
> > +++ b/doc/nft.txt
> > @@ -387,13 +387,19 @@ add table inet mytable
> >  CHAINS
> >  ------
> >  [verse]
> > -{*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' [*device* 'device'] *priority* 'priority' *;* [*policy* 'policy' *;*] [*comment* 'comment' *;*] *}*]
> > +____
> > +{*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' ['DEVICE'] *priority* 'priority' *;* [*policy* 'policy' *;*] [*comment* 'comment' *;*] *}*]
> >  {*delete* | *destroy* | *list* | *flush*} *chain* ['family'] 'table' 'chain'
> >  *list chains* ['family']
> >  *delete chain* ['family'] 'table' *handle* 'handle'
> >  *destroy chain* ['family'] 'table' *handle* 'handle'
> >  *rename chain* ['family'] 'table' 'chain' 'newname'
> >  
> > +'DEVICE' := {*device* 'DEVICE_NAME' | *devices = {* 'DEVICE_LIST' *}*}
> > +'DEVICE_LIST' := 'DEVICE_NAME' [*,* 'DEVICE_LIST']
> > +'DEVICE_NAME' := 'string' | 'string'***
> > +____
> > +
> >  Chains are containers for rules. They exist in two kinds, base chains and
> >  regular chains. A base chain is an entry point for packets from the networking
> >  stack, a regular chain may be used as jump target and is used for better rule
> > @@ -436,7 +442,7 @@ Apart from the special cases illustrated above (e.g. *nat* type not supporting
> >  
> >  * The netdev family supports merely two combinations, namely *filter* type with
> >    *ingress* hook and *filter* type with *egress* hook. Base chains in this
> > -  family also require the *device* parameter to be present since they exist per
> > +  family also require the 'DEVICE' parameter to be present since they exist per
> >    interface only.
> >  * The arp family supports only the *input* and *output* hooks, both in chains of type
> >    *filter*.
> > @@ -449,7 +455,13 @@ Apart from the special cases illustrated above (e.g. *nat* type not supporting
> >  The *device* parameter accepts a network interface name as a string, and is
> >  required when adding a base chain that filters traffic on the ingress or
> >  egress hooks. Any ingress or egress chains will only filter traffic from the
> > -interface specified in the *device* parameter.
> > +interface specified in the *device* parameter. The same base chain may be used
> > +for multiple devices by using the *devices* parameter instead.
> > +
> > +With newer kernels there is also basic support for wildcards in 'DEVICE_NAME'
> > +by specifying an asterisk suffix. The chain will apply to all interfaces
> > +matching the given prefix. Use the *list hooks* command to see the current
> > +status.
> 
> Maybe explain here too that newer kernels also allow to pre-register a
> match on unexisting devices (specify version), while old kernel fail
> with ENOENT?

ACK, will do!

> >  The *priority* parameter accepts a signed integer value or a standard priority
> >  name which specifies the order in which chains with the same *hook* value are
> > @@ -763,11 +775,16 @@ per element comment field
> >  FLOWTABLES
> >  -----------
> >  [verse]
> > -{*add* | *create*} *flowtable* ['family'] 'table' 'flowtable' *{ hook* 'hook' *priority* 'priority' *; devices = {* 'device'[*,* ...] *} ; }*
> > +____
> > +{*add* | *create*} *flowtable* ['family'] 'table' 'flowtable' *{ hook* 'hook' *priority* 'priority' *; devices = {* 'DEVICE_LIST' *} ; }*
> >  *list flowtables* ['family'] ['table']
> >  {*delete* | *destroy* | *list*} *flowtable* ['family'] 'table' 'flowtable'
> >  *delete* *flowtable* ['family'] 'table' *handle* 'handle'
> >  
> > +'DEVICE_LIST' := 'DEVICE_NAME' [*,* 'DEVICE_LIST']
> > +'DEVICE_NAME' := 'string' | 'string'***
> > +____
> > +
> >  Flowtables allow you to accelerate packet forwarding in software. Flowtables
> >  entries are represented through a tuple that is composed of the input interface,
> >  source and destination address, source and destination port; and layer 3/4
> > @@ -786,6 +803,11 @@ The *priority* can be a signed integer or *filter* which stands for 0. Addition
> >  and subtraction can be used to set relative priority, e.g. filter + 5 equals to
> >  5.
> >  
> > +With newer kernels there is basic support for wildcards in 'DEVICE_LIST' by
> > +specifying an asterisk suffix. The flowtable will apply to all interfaces
> > +matching the given prefix. Use the *list hooks* command to see the current
> > +status.
> 
>                                                         ... to see the
> hooks that are that registered per device that match on the wildcard
> device.

LGTM!

Thanks, Phil
