Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E567381B0
	for <netfilter-devel@vger.kernel.org>; Sun, 28 Jul 2024 23:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722209861; cv=none; b=fsjvZHqo5oRyjuIUwNJz4j2iPY1oBqKrpY/K1CLCHKmLEwrbHT1X7PZ82ODPduk8n2DREMs1g4s3k8SXYXJZORbsW/ubMSaotRX8VZInjFZ71fRrhAMDYqGWikGV8JK6ddCiZl0eCcBpoBFds2CuGTI212/mOsTG5Tc4XeL5XNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722209861; c=relaxed/simple;
	bh=O4uBoBaDXxJhG2xtLTwUA9/UpK6cANQDcGPH+fPlfc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxQ3jlKiixZ7Oq0wmb6o1VgQtypGUIkYFDKO8EpsnR0PrskarlO7Av3pUqP9JFZIQkGPQYc4d7jhXT1xKWASb5q/K6jZQlXsdPG//VzpuyzkWX6Itno+/e8gYozvOOty4cD91NwtL/FjNdbXL8cIDdslL9rfWvbb74bBE63FJAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sYDSK-0008PM-1T; Mon, 29 Jul 2024 01:37:36 +0200
Date: Mon, 29 Jul 2024 01:37:36 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft 1/4] doc: add documentation about list hooks feature
Message-ID: <20240728233736.GA31560@breakpoint.cc>
References: <20240726015837.14572-1-fw@strlen.de>
 <20240726015837.14572-2-fw@strlen.de>
 <ZqNlvkJ2YSc-KIKb@calendula>
 <20240726123152.GA3778@breakpoint.cc>
 <ZqbR0yOY87wI0VoS@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqbR0yOY87wI0VoS@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Not really, why would eth0 and eth1 be related here?
> 
> Note that you can specify:
> 
>   list hooks ip device enp0s25
> 
> this shows the hooks that will be exercised for a given packet family,
> ie. IPv4 packets will exercise the following hooks.
> 
> family ip {
>         hook ingress {
>                  0000000000 chain netdev x y [nf_tables]
>         }
>         hook prerouting {
>                 -0000000400 ipv4_conntrack_defrag [nf_defrag_ipv4]
>                 -0000000200 ipv4_conntrack_in [nf_conntrack]
>         }
>         hook input {
>                  0000000000 chain ip filter in [nf_tables]
>                 +2147483647 nf_confirm [nf_conntrack]
>         }
>         hook forward {
>                 -0000000225 selinux_ip_forward
>         }
>         hook output {
>                 -0000000400 ipv4_conntrack_defrag [nf_defrag_ipv4]
>                 -0000000225 selinux_ip_output
>                 -0000000200 ipv4_conntrack_local [nf_conntrack]
>         }
>         hook postrouting {
>                 +0000000225 selinux_ip_postroute
>                 +2147483647 nf_confirm [nf_conntrack]
>         }
> }
> 
> This is _not_ showing the list of hooks for a given family.

I now realize that whats in the tree today is not what I wrote originally.
So this is neither showing the hooks that will be execrised (packet
can't be input and forward...).  But ok.  I don't know what to do now.

> What I meant is that user could filter out by ingress and egress
> device to fetch the hooks that are traversed in such case, ie.
> 
>   list hooks ip iifname eth0 oifname eth1
> 
> to get the traversal of hooks for IPv4 packets, assuming eth0 as
> ingress device and eth1 as egress device.

No idea how to make this, or I fail to understand.

> > What would make more sense to me is to allow
> > 
> > list hooks netdev
> >
> > and then have nft fetch list of all network devices and then query them
> > all.
> 
> Makes sense, it currently fails with EINVAL because no device has been
> specified.

I'll try to add it, but I don't know if I should toss these patches
first or not :/
