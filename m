Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E46306744;
	Tue, 22 Sep 2026 05:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790056550; cv=none; b=Eiken07oF02NgB0HtyZTjmBUJNEPC+AtKZor6kHDtSBISYR7Vr+3NsUSfzNNQvqbR/Uk380LTYx5GijKNbfpwJzrI/rwHMAYbtUt8g4cmHob08ftgpQ9gWv+DikRde9vaMby1903GAzVLjVU5TioyXnioSY4g47KGPkyaN8aOqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790056550; c=relaxed/simple;
	bh=CF3XLaCrxhkvQd9YB+62gDKmay5ProHUjjadncIq5pA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iD+Uc2WomoCHizM5Z3MuzsDnqRXZzIauS8Q3ASkjEg/mVniE1w4gMh8xy/en2XYG3xePFlMU7IIGjqxI+GfmPUEdGYWbHY/NaSdol2zMJGrV6n445gK5otfotPf97qtgljcJCAoFrX17jcQSmkasZBseqnPr06mXbJHL5gWaSgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vLUWTGP1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vLUWTGP1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=CF3XLaCrxhkvQd9YB+62gDKmay5ProHUjjadncIq5pA=;
	t=1790056548; x=1791266148; b=vLUWTGP1kWvozhR4X6ZjpJudpkkvO6ay8Bnko4U+7anIQF/
	uUC4TuUHIZZi1LCNRdnD+FjZScvJ1esyRoow7wgXuIq8BUHe2q2aQQ6QHv1aIOSdXsv64sSJfhebL
	JQc6F9UIl3+uWC2EeEx1kEy9VhLHD/1r8nwMr/Da6LYzPnTaFCXs7XICaNmqW9IvRWE59j4+5a1Ur
	rDDKyFCEDA7fMP9bWKMBNFitnsd20MxGwBzH17G437c/fRL66mnG7Lfvja+V+1Z64NXnSKWsFyLmd
	W/Wz8e/wumsNxSYvjuYsvKtfBlNGesGl0VqTW6uyG1dxFnexpve1S/VszAkNoGJw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8tTW-00000006hzD-1D9w;
	Tue, 22 Sep 2026 07:55:30 +0200
Message-ID: <b2d23b4a7cb6af54a5575436823d82442d6f6cc6.camel@sipsolutions.net>
Subject: Re: [PATCH net v6 1/2] net: validate virtio checksum start after
 network header
From: Johannes Berg <johannes@sipsolutions.net>
To: Paulos Yibelo <habte.yibelo@gmail.com>, "Michael S. Tsirkin"
	 <mst@redhat.com>
Cc: netdev@vger.kernel.org, richard@nod.at, anton.ivanov@cambridgegreys.com,
 	willemdebruijn.kernel@gmail.com, jasowangio@gmail.com,
 eperezma@redhat.com, 	xuanzhuo@linux.alibaba.com, andrew+netdev@lunn.ch,
 pablo@netfilter.org, 	fw@strlen.de, phil@nwl.cc, razor@blackwall.org,
 idosch@nvidia.com, 	dsahern@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, 	pabeni@redhat.com, horms@kernel.org,
 linux-um@lists.infradead.org, 	virtualization@lists.linux.dev,
 netfilter-devel@vger.kernel.org, 	coreteam@netfilter.org,
 bridge@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Tue, 22 Sep 2026 07:55:29 +0200
In-Reply-To: <CAHv8Y_4OKdVkigToBmXXhhUxu+EL2iWVADZJ=LS4CGqBATgU5g@mail.gmail.com> (sfid-20260922_074449_202856_128C51A3)
References: <20260922030310.8684-1-habte.yibelo@gmail.com>
	 <20260922030310.8684-2-habte.yibelo@gmail.com>
	 <20260922005353-mutt-send-email-mst@kernel.org>
	 <CAHv8Y_4OKdVkigToBmXXhhUxu+EL2iWVADZJ=LS4CGqBATgU5g@mail.gmail.com>
	 (sfid-20260922_074449_202856_128C51A3)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-09-22 at 01:44 -0400, Paulos Yibelo wrote:
> If this sounds good to you I can get started on the modifications.
>=20

No it doesn't, go away and don't just keep sending LLM output without
ever even bothering to look at it.

johannes
