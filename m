Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02220528452;
	Fri, 16 Oct 2026 16:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167630; cv=none; b=f01rwufw9GPd4kMhdNvmge8F3F/b2pvx8X++xyQejPZH6xF0n8qqHigVaq34POYh56z9oIvpmuKdmkavj/8GoXhrxPBn+jOWyEExEGXs6GWTYL7GxugfgVLQBNYY0YHmBCC8yxiqs5W9m3PqRFsLN5eHRIM9j7EVhXPyQs3TeFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167630; c=relaxed/simple;
	bh=h2VtlyQh8P+LO9nN6/lenuqctdjkpkvcErfDdP/bz1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDWDz44G0ucFOotYYlCPBXZebnz+H6eE4iwrFQBYoylMx3ulT4keYDuYhOjiMqDo+lhWvw1OLAye0DyWQeplbcGXjZ6TwMrFC1pZxPhctWdTDvlRp6qOn4lflqyQNt60jn1DFgKre1byC4kWJj/Ij/rhraBQTxAe+LA2hfd8Qec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4E86A60327; Fri, 16 Oct 2026 18:20:24 +0200 (CEST)
Date: Fri, 16 Oct 2026 18:20:23 +0200
From: Florian Westphal <fw@strlen.de>
To: zihan xi <zihanx@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, virtualization@lists.linux.dev,
	intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org,
	pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
	kaber@trash.net, jengelh@medozas.de, andrew+netdev@lunn.ch,
	mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com, aleksander.lobakin@intel.com,
	ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me,
	magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
	willemb@google.com, alice.kernel@fastmail.im,
	eilaimemedsnaimel@gmail.com, imv4bel@gmail.com,
	shiming.cheng@mediatek.com, sd@queasysnail.net, vega@nebusec.ai,
	root@tr0jan.top
Subject: Re: [PATCH nf v8 0/3] netfilter: bound asynchronous packet
 duplication
Message-ID: <atJOxy1Q4twlJSJB@strlen.de>
References: <cover.1792048855.git.zihanx@nebusec.ai>
 <atCtUFcG9b4ykXY3@strlen.de>
 <CAANe3eTSz3-EE0=9JNFBMFDqZ9NUfScHdi8EN30UVaTiRq0vcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAANe3eTSz3-EE0=9JNFBMFDqZ9NUfScHdi8EN30UVaTiRq0vcg@mail.gmail.com>

zihan xi <zihanx@nebusec.ai> wrote:
> I will send a one-patch v9 series for the NFQUEUE guard preservation
> only. It does not address netdev duplication or claim to provide a
> general facility for bounding every asynchronous duplication path.

makes sense to me, thanks!
