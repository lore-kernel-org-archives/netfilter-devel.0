Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EA5188591;
	Fri, 23 Aug 2024 14:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724424286; cv=none; b=e/wsr3051A3my4Q2CRPj8DstkuGmdC49bA/iN0I8YkJVPQFnSFRhQo+kWUZAShjBbpGvPq/hA8pW1XQfIvEZg9NCs7zYUuE/0S/48QjVO3h4IPjgAqc71po6D3jeshoJECOgkQR8dZTYi4Xiph6mByLfcFevvPj+5i2z/ahj64A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724424286; c=relaxed/simple;
	bh=gS6dfDMZfebrIIAxUK4kHi8Fpd44OwLvCR/Ke9Tyb4A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VXiZpCfVJyueL52uzXawYu2NNiuNQ39i1lvIN065Ms4WlxeGmCcmoX/wKkTati4gd567Jpxae8z1NQTB9V/W2UDwTe3rUFyjHVpsag67WI7Mlvnd8AWwOHQ6KBHcRxTD5NlKXdvupyogvYHPSgPgbLEU8wfQsaPZAwV8jrObdyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A46vNcYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A46vNcYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A2EC32786;
	Fri, 23 Aug 2024 14:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724424286;
	bh=gS6dfDMZfebrIIAxUK4kHi8Fpd44OwLvCR/Ke9Tyb4A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=A46vNcYCKrI1bCXbORQIPRHTZCBeNQHHtt2qJe3YO88F2+6hk7z47jL1oO2nmyQcj
	 X86S8EzFkp6JxwerRoFTsJiyuMvw70UwVUmdzOCZYC7CzOni/BuoMjCa6EYfdBnVCq
	 F68IdtIgcVlb6qbJJJy0p74B3ItEiAZn+ZpX0lxvkMx9F/+jN6y79uvf6IS9uQSrva
	 +2CrQ2WecPPcNWMalg2gA+ieSkBCgS3gHa6IhyQQHLL7YmDpO94KEYWPdz1muEJ3Ks
	 GhJ7cro67LVZPVHhIFZ7KbjdCn9F3M6XlgkzjBaJlYoM//ulIIEX/9qmDEtiitauaG
	 /ImCUCVdI7QrQ==
Date: Fri, 23 Aug 2024 07:44:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
 <kadlec@netfilter.org>, "David S. Miller" <davem@davemloft.net>, David
 Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, leit@meta.com, netfilter-devel@vger.kernel.org (open
 list:NETFILTER), coreteam@netfilter.org (open list:NETFILTER),
 netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
 linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH nf-next 1/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <20240823074444.7de6a99f@kernel.org>
In-Reply-To: <20240822175537.3626036-1-leitao@debian.org>
References: <20240822175537.3626036-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 22 Aug 2024 10:55:35 -0700 Breno Leitao wrote:
> This option makes IP_NF_IPTABLES_LEGACY user selectable, giving
> users the option to configure iptables without enabling any other
> config.

Some tests seem to be missing options entries from their configs after
this change: amt.sh, udpgro.sh, udpgro_fwd.sh
