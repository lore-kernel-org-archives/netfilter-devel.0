Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C07972615
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Aug 2025 15:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754495407; cv=none; b=qWRYdbZ1iKjpgnxyDHgzJaOBgIMPsAcMxlccqxClGzHld0LA9jNj09IbPZagamPR+8EtE5TSMUQ+EaEcI64NJYThQMAnqGjofVOx0o1nbuz0BQINCbOv2xIz4UTbhnErey5/2QVQa97jvndEPdsjIE9LXh09ai1+2clSxZ5nFZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754495407; c=relaxed/simple;
	bh=6rrF513dNPIxwIpPw96nym8ss/zBtbksgI4owRDNHrA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iPnDZ/clfGjWuWxN6YlKMBE9PMLSpd7HhZBibXgW6Lr0f1t4GsgblheOnEvQdQHPL6evo6V6vOb/JdAYdaNVZgt9pCU+TR2BJWeyau51fsrOtszXQwz4Gkcj/1uyNjBjmsVVjf2E4dRjPzfgFc9k2Q9CDr+B485T9FJDUnBjEBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id F2D531003D4513; Wed,  6 Aug 2025 17:50:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id F2ADD11020E00B;
	Wed,  6 Aug 2025 17:50:02 +0200 (CEST)
Date: Wed, 6 Aug 2025 17:50:02 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Subject: Re: [ANNOUNCE] nftables 1.1.4 release
In-Reply-To: <aJNHt1OW7w6SBmsv@calendula>
Message-ID: <7np103p3-6822-3149-q69p-o06n1006pn29@vanv.qr>
References: <aJNHt1OW7w6SBmsv@calendula>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wednesday 2025-08-06 14:16, Pablo Neira Ayuso wrote:
>
>        nftables 1.1.4

https://lore.kernel.org/netfilter-devel/20250417145055.2700920-1-jengelh@inai.de/
is still unmerged; if that could be caught up on that would be nice.
