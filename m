Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D03E22F17B;
	Tue,  8 Apr 2025 16:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744130447; cv=none; b=TsKn67kDpLkZzcSSS0IhN3LyaxGPS2M7UnDecMkF/EIKmM4oCol3lv22g6BcF8VdrvIBZUD93dQwFJF/I0fipe2924b4j+b2RwpGb7F8RQRretGfCDJ0Z9umowx1QY4Nj+KJjHxzs/8zXcOFLI4O+vb05TO6y4DqXSz7Sml2eTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744130447; c=relaxed/simple;
	bh=I8vlLpjHcKixlNnee9qQYRSKIq0vzo3OM9ZYXwQvMo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7VthtTJTTrmxq6xV4Hkt3RqY/L926g3SfWbPlC4S5/L6QEtv/ctVpQzDDweLhfAI5cW6Jevsh4zJDwi76iu8zXxydHlCWplYAWAXB5H9Tlf7wzkyOtydPO9b9xiUT9LR8NRR6Sm5Jq8urwv0rPy3ZWElQdvveCpMA3FohFqLOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OtVOLTit; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f3vPUZfS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OtVOLTit";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f3vPUZfS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1DCF9603AC; Tue,  8 Apr 2025 18:40:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744130443;
	bh=E6bo8R1g3j8fQftb7Htfmeaods5Ry60+30dXgh8MLco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OtVOLTitbFsUsj+Jb6w311ZFSg4dSorcyC/B4PfNtVDaeBTKAgo74Y32f1YreLuLn
	 kpFAB4iojvweLVzutiT7lWGNKLDajPjqfKd0+eGrdZaUrekJln3PbasvBkX3QLEyQm
	 npjtIHmTmjWxZDpIi65FdNh9LAjsb5kt9ZDcdWlJ827FomloFLJOEbX8M6QaRY6ZDn
	 DFekOoOFM7A7oj7cx0dudMD4yicoj+w4IGjK91vkT8Gq9sukLaDTaVQzBBzZ0zhKTf
	 GvNlVFp5aQTknSKU7gZvWMXKePjGkU6pKU/jZMFpWYnIFvNnxIkyzm5RIywsq/F05D
	 4dX57KpsfADQQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 96862603AC;
	Tue,  8 Apr 2025 18:40:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744130440;
	bh=E6bo8R1g3j8fQftb7Htfmeaods5Ry60+30dXgh8MLco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f3vPUZfSQv+MMCu/Ce5THBljmzldxHs9c1xRZyAQVWIl2hG9Mq3Jv1uY+ZNPrVyQX
	 LVhJsAz/pFMfqitWf5QIFKfMvUGZWfUxcD30shPH/i0/a+tMYKp1KyCy3RSbIHI4xt
	 dI55GfI1NUF1+eDJHbmhBy+3aI5jv5QmPyqRjHtVPPlo8P4Y3bA2bEPF0n6NyXbK6F
	 qaAJOonklSXM9Yzgyz266k9rhHQE1jUumme/DXggXFtTdJflTi0YpjO5+CEYkZTpbX
	 +mt3r4QqnpkNp84lUxuo09LK5PWfmEVeA0g3Q5jEYcj/puWCEz6/E0NOLmhv4V/dsX
	 Nigc4gJ9h5U2w==
Date: Tue, 8 Apr 2025 18:40:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Eric Woudstra <ericwouds@gmail.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v11 nf-next 1/2] netfilter: bridge: Add conntrack double
 vlan and pppoe
Message-ID: <Z_VRhgHY4KEgbg92@calendula>
References: <20250408142619.95619-1-ericwouds@gmail.com>
 <20250408142619.95619-2-ericwouds@gmail.com>
 <20250408163931.GA11581@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250408163931.GA11581@breakpoint.cc>

On Tue, Apr 08, 2025 at 06:39:31PM +0200, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
> > This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
> > packets that are passing a bridge.
> 
> Conntrack is l2 agnostic, so this either requires distinct
> ip addresses in the vlans/pppoe tunneled traffic or users
> need to configure connection tracking zones manually to
> ensure there are no collisions or traffic merges (i.e.,
> packet x from PPPoE won't be merged with frag from a vlan).

There are conntrack zones.
