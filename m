Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794766721;
	b=TqcQ6W9Yo5Cjk1pjLfEk6iMG6SpxCMIz2rAomekHCKNyFyROe9sCnPK3TkCW3TYLNxyR
	 wz4X+5osJguUoCNLoChk5sZUASA/87WgbnTmoCiYfN4GozqI4PG48HApAQArTV7UzcU2K
	 Xz0n2pLmlDs1vIW4VKiMtNE1NcG8RREjMFRIzWGPGrN8uC+XE3Gf8UnVhzafZzHL1MQJk
	 1l9VtUgvZ2kmgOh5oDnN2Aw/HjzzLXS3AGWrpKXvl1Mc5+LXOM0oCN9sFW/3Sl+eXupqc
	 a+JhxZHRm/O751Bz+/P2/sl8PBtSqACTRkmKuDTDWn7J7XjVN9w1CuQxKhD3zWdafiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794766721;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1On2wFuhrsrFz+cCwtUpF+vNJ1lq0zP48pW/+qijtss=;
	b=ghr1iqGxOrxzrbWgVSnIUoBb3FATMHYPyGtwK5OmbDarM5tGfRqYQ2/a44+3DwV6PwJy
	 NMyywD37uEYVParNoy3Wx/6r9OrNPZ1hOc3Yigk0Qj2MkUitWOOrsFNKcr4nhQo6LBwz2
	 kK0QJZSTgyWn7fWpzMi9eTV8mr4MVgv5lZo4vfAFufU41yAj0Br1LpsBCWQuHOvkHghOg
	 49TnhewoPSJjEURwKDH57lo35LnycNxB17OqcMMZiRlw4byIrxushcGUj0DcLS0Q5W50X
	 ZOLBWDPUsFT4Ju1zOYkUXT9TZoI+2uE45vJvJ5u/6FwWcsq6GaRBzFtt1VGCcJTvyZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C42606A31D
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 18:18:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7C42606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 14AED6055A; Sun, 15 Nov 2026 19:18:32 +0100 (CET)
Date: Sun, 15 Nov 2026 19:18:31 +0100
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v10 0/6] ipset: replace internal hash table with
 rhashtable
Message-ID: <avn3d1TtvftVLoDc@strlen.de>
References: <20261112143818.30638-1-fw@strlen.de>
 <9a882426-58aa-c14d-fe99-64538c98d293@netfilter.org>
 <avXuJ0GBdzyxK-_w@strlen.de>
 <bbc263cd-5ceb-f183-439b-44909adef4ed@netfilter.org>
 <avbGlZBumFgTJyVY@strlen.de>
 <4075f44d-baca-ce2c-3892-81652ef19ce7@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4075f44d-baca-ce2c-3892-81652ef19ce7@netfilter.org>

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > > I pushed a few of the test updates to ipset.git, but not this 
> > > > 3-part-series:
> > > > 
> > > > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261111101603.22698-1-fw@strlen.de/
> > > > 
> > > > First one passes on either rhashtable branch or main, but I'm not sure
> > > > it should :-)
> > > > 
> > > > Resp. I'm not sure what the contract/expected behavior of net,iface set 
> > > > type is when the address matches the net/mask entry, but the interface 
> > > > doesn't.  I followed existing behaviour, so that test would enshrine 
> > > > that: it stops matching more candidates.
> > > 
> > > Hm, it shouldn't. The expected behaviour is as follows: if the net/mask 
> > > entry matches but the interface not, then the code should continue trying 
> > > to find matching entries but just with the same mask value and not with 
> > > other ones. That way the same net/mask entry behind multiple interfaces is 
> > > supported and matched.
> > 
> > In that case a v11 might be needed; the conversion follows the observed
> > behavior.
> 
> This is strange because the current code does return the expected 
> behaviour. I have just updated the tests with a case which checks it.

Thanks, passes for me both with main and rhashtable_v10, I just
mis-parsed what you wrote...
