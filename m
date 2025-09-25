Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46868286897
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 14:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758809267; cv=none; b=QTqrDu1l8atSB8uadcNs/QBYjC2HLEn0mlCzKQT1VCSL/IuAWSiWYkfT/nt7Y5+QtFhJ4wTHNz838Gw9z7NxfAx3PMCaavbbQHdFV7Fn70kpmJuJB1nvlzCYT+Pl5RrbDqyhTOlJyUgARNBuLGfSetj7tUGc+0wa4M8ezKg1y44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758809267; c=relaxed/simple;
	bh=8miqsK95zyDj09oru8NNu+eg1uBQR/hO42xBp401dpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R4uLykrcIntzWG3XZweMjtFmCkQSkV0+fJ+4O/DmJd3jpbYZ4wcGu1s3PQF2ylkjTBL6zCreLP/VwwUN1oGiI8oHh9HrZDdiHjumibe/FaCi6YHDIf9e7zgHugWsUkPLt4ci+DwtCuL3nopABNFN4eT+8DECM+X18MvF1x/RKr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ki9rByPN; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tb1yWNTo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ki9rByPN";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tb1yWNTo"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 246D460273; Thu, 25 Sep 2025 16:07:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758809261;
	bh=YuOeSde2TbRAQb9esi/ujGhscZ4uULaVv25Yc4jxFAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ki9rByPNn+aJW06cnTZCk4jnVbdcniCclRP9GOdjbZCP2YNDsRJ6ZLzuHOwWxXw+4
	 pI8qkZcojU2D8h3jwOeQhKuIqRYWmjy7calRRgcG8Mf2b7gszfxKlPR6UqLXsxWtzV
	 HIAcYvi6ea9jC86ucNSp1gW1NOo9e6Jif0Bau3sNDA4i5WhcsUBvwsA+UfS5VxHMPs
	 UI7Zn9WlpcSF5v3cwukc0z5yiUB2IRh7e5Pl65AhXF0f8JmftvtwLovnfPodEdi9xC
	 wW17Tr5ZrNWjpkD6+OjhXnt3yNeszh3VEeohqDH6pZRm2h+uT4vy2PzSjOAUpm/nNF
	 4cPAszKD5ywZw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3CAD76026D;
	Thu, 25 Sep 2025 16:07:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758809260;
	bh=YuOeSde2TbRAQb9esi/ujGhscZ4uULaVv25Yc4jxFAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tb1yWNToPOxc2ZKy8yFlA6VrTzK8vmPya6q612cOecSivniCnxIsgw9FqgdtPEFO7
	 CmB6eyJc/iGUzGfHcskhkDTZcJi965LBMUgoYHsPW4XcrfZYei6fh1scAJj5Z8KgMd
	 1I8fICG0BDfMp0SR5oCpx0uCO1kVt3V0/PVxP9PC2RdD9f2L/Jwy4yhrTZestuxyxw
	 RcMttYfzdbspJoB3bnRDvqnrmyrkXXy685C3GqqJPJmPzc9htjnWGFIzpd7IDFcqLk
	 B5uNZuwhU7SApkLYAcA9CSj61fkdXFIk2XREgEO+AFGWvq9IgI0mFdL708cl20d2h+
	 ImV51MFCvG4KQ==
Date: Thu, 25 Sep 2025 16:07:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Christoph Anton Mitterer <calestyo@scientia.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: bug: nft -n still shows "resolved" values for iif and oif
Message-ID: <aNVMqSlTNkGFRoPR@calendula>
References: <f2c46dc450b3223834cd837882877f892b234491.camel@scientia.org>
 <e19bafc0-61c9-47af-afb6-15f886cc4d37@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e19bafc0-61c9-47af-afb6-15f886cc4d37@suse.de>

On Thu, Sep 25, 2025 at 02:36:15PM +0200, Fernando Fernandez Mancera wrote:
> 
> 
> On 9/24/25 11:48 PM, Christoph Anton Mitterer wrote:
> > Hey.
> > 
> > E.g.:
> > # nft list ruleset
> > table inet filter {
> > 	chain input {
> > 		type filter hook input priority filter; policy drop;
> > 		ct state { established, related } accept
> > 		iif "eth0" accept
> > 	}
> > }
> > #  nft -n list ruleset
> > table inet filter {
> > 	chain input {
> > 		type filter hook input priority 0; policy drop;
> > 		ct state { 0x2, 0x4 } accept
> > 		iif "eth0" accept
> > 	}
> > }
> > 
> > 
> > IMO especially for iif/oif, which hardcode the iface ID rather than
> > name, it would IMO be rather important to show the real value (that is
> > the ID) and not the resolved one... so that users aren't tricked into
> > some false sense (when they should actually use [io]ifname.
> > 
> 
> Hi,
> 
> AFAICS, the current -n is just a combination of '--numeric-priority
> --numeric-protocol --numeric-time'. Although, the message displayed when
> using --help is misleading.
> 
> -n, --numeric                   Print fully numerical output.
> 
> I propose two changes:
> 
> 1. Adjust the description when doing --help
> 2. Introduce a new "--numeric-interface" which prevents resolving iif or
> oif.

I wonder if there is a use-case for this.

> Another possible solution could be to use --numeric to do not resolve
> iif/oif but then it would mean we should not resolve ANYTHING as "Print
> fully numerical output." mentions.
> 
> What do you think? I can send a patch and test it.

It would good to check if there are more datatypes that are hiding a
number value behind to decide what to do with -n/--numeric.
