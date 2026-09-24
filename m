Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAD93F12E5;
	Thu, 24 Sep 2026 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270290; cv=none; b=cxyx5nVNPFHWGMHWRkufCOrWJ13sZ3yhH2Apm+FLbSHmcAUfUhh2PiT0qqsOu2L9aYw0qBlr3mXBFU6uZf5gI+l6glqf8U4VQvovAdavIKnZuWoUJ0w2fX7dTPYs4Y1jN594HO0L6EDQbrAuI3z1KARzKQYHwmhdlMir+fhE1mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270290; c=relaxed/simple;
	bh=OqajQe8QEnAY4peKBL7bBwYtDL5rUL6DmZKld9YtEJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NZRZ6liAwmbxZ+ZBnlWPONkXavRorbgBZg2wN8IUn5GP3LV4FyFicJWlDFoTvgtbXc+EOrYBCrlM+bkzCq7fAzfM1TuKOjjynmuP/UqUAq5bdbu7EsaBk95MnyqXRd0AmEtLPYWP8VJCSP2KWgJinWgsyYCtB0fFFniKrP/uly4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFb1KWLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFb1KWLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84CF1F000FF;
	Thu, 24 Sep 2026 17:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790270289;
	bh=E8FD4iT6RJg3BgIUMg1u6lq1AX2COPGo3VlgxX8d3j4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bFb1KWLfsVCfUNGf+4PHOZ6lOgMe6SwcajHMwk56U8Fa+GX2ljNEmHA5KRn3ss0ST
	 NTSEaL+MjRAJzME2l+QO1Mls8EstWL6jr6DxGSdjLtTEG3rsu2Jb0GTGx2DL+KGq3H
	 ipF40Ay6CajjrrElzhXEKf8h7IiadJUYcT5dZukeqXkCRZE3FmsdI64q+wiHTqqAO9
	 I2eQ1MgvqpKCGNuREB55Lt9UhM8kMQSLymhgu5F505Naiec7yVrCX50Bz5ToR8A5o+
	 THT4B0Ja6xkIIf2v+caT4h1lUIswlSDyyO9Oft/aoVXe8K+xBrgEsQXqEEkion/xnu
	 +yj1e5V91ReJQ==
Date: Thu, 24 Sep 2026 10:18:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Paulos Yibelo <habte.yibelo@gmail.com>,
 netdev@vger.kernel.org, richard@nod.at, anton.ivanov@cambridgegreys.com,
 johannes@sipsolutions.net, jasowangio@gmail.com, eperezma@redhat.com,
 xuanzhuo@linux.alibaba.com, andrew+netdev@lunn.ch, pablo@netfilter.org,
 fw@strlen.de, phil@nwl.cc, razor@blackwall.org, idosch@nvidia.com,
 dsahern@kernel.org, davem@davemloft.net, pabeni@redhat.com,
 horms@kernel.org, linux-um@lists.infradead.org,
 virtualization@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v6 1/2] net: validate virtio checksum start after
 network header
Message-ID: <20260924101808.638f2d22@kernel.org>
In-Reply-To: <20260923081209-mutt-send-email-mst@kernel.org>
References: <20260922030310.8684-1-habte.yibelo@gmail.com>
	<20260922030310.8684-2-habte.yibelo@gmail.com>
	<willemdebruijn.kernel.259bc7096258d@gmail.com>
	<willemdebruijn.kernel.2cdfef118aa1d@gmail.com>
	<20260923061215-mutt-send-email-mst@kernel.org>
	<CANn89iJaE5UarTdg6FMEp=rZ9mG3g=xrVRLyvMS5S02iE8CwGg@mail.gmail.com>
	<20260923081209-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 23 Sep 2026 22:02:57 -0400 Michael S. Tsirkin wrote:
> $ git grep 'skb->csum_start\ ='
> drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:        skb->csum_start = (unsigned char *)th - skb->head;
> drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_start = (unsigned char *)uh - skb->head;
> drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_start = (unsigned char *)uh - skb->head;
> drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_start = (unsigned char *)tcp - skb->head;
> drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_start = (unsigned char *)tcp - skb->head;

These are HW-GRO, ASIC coalesced TCP segments so it better know 
the _correct_ offsets of things. And it's hardly remote-provided?

> drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:         skb->csum_start = skb_transport_header(skb) - skb->head;

selftest
