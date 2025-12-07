Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F5F17E4;
	Sun,  7 Dec 2025 23:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765148966; cv=none; b=bvz5PEcNFavyA72V+WJ5NxoLk/wVUi/hReg9hvnTk1yQ4CmSWSj31XvzKJLJXQwm0q4rkmGcC25cVVeR9WvebhGirJRqRNrrb+yS3IZgZtlqwJipPLhKo1Z/ZDm6YW+C/cEyOrOH1k9eksrw4TUHlEHYcqIBG0JbPm47QJbtKSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765148966; c=relaxed/simple;
	bh=jVdfdZp1YQJuAUkroqBJ2R1cQ3KIxe24JOMT7p7hZGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F4LhjXo41B+VtRMSKZA6pN5cIWSHludiHi+7Hau+LR4iIj5oc3LzaGsusy6lOkagMUzTh9+fuDpxIJ8Kr/LVIW01yCAg9kXHCSDIYtZksCMqK0ecHG99GgDBdoCBIdI78z+W8nBaTgIi67EGmcy3flontlh6dj0GIUtsbF4lvT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7tRW+BB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7tRW+BB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AF4C4CEFB;
	Sun,  7 Dec 2025 23:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765148965;
	bh=jVdfdZp1YQJuAUkroqBJ2R1cQ3KIxe24JOMT7p7hZGQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N7tRW+BBZFnADElMuzzTPbi2FXMuf/o9WVXdDlNASAbKa6p7DcI8Dmc+fD7h2fXHb
	 zd7ZQqzepfLKgYxa30E+Da948tT3sDJtVpphLTRtbXgFPeUs/AFG7jRnP6ravAeWjs
	 ffDqqLpBOQqSIiIOyBuNZFE0fiRQzZTd1HaIYxE+vXpcC7ShnmwQbcWP7glCEW0itS
	 rlqDpOA+/jc0cm/x/zrOQ5pSbxV8ENtywsLUBtB3Ta8YiIzomsq3/TCSW2EuXnmHV5
	 oRkMXxT6rrEfOo8SmdKKji4lE4RoUEimODTBerMl3uoGaUfKDGr29+ONSI0CeD3GgZ
	 lqrm0EC/AeFeQ==
Date: Sun, 7 Dec 2025 15:09:24 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
 <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter
 <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, David Ahern <dsahern@kernel.org>, Shuah Khan
 <shuah@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH nf-next 0/5] Add IP6IP6 flowtable SW acceleration
Message-ID: <20251207150924.13a8ef15@kernel.org>
In-Reply-To: <aTX3tncSC5GqW-ES@lore-desk>
References: <20251207-b4-flowtable-offload-ip6ip6-v1-0-18e3ab7f748c@kernel.org>
	<20251207130654.698001f3@kernel.org>
	<aTX3tncSC5GqW-ES@lore-desk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 7 Dec 2025 22:55:02 +0100 Lorenzo Bianconi wrote:
> > net/netfilter/nf_flow_table_ip.c:383:29: error: invalid use of undefine=
d type =E2=80=98const struct inet6_protocol=E2=80=99
> >   383 |                 ret =3D ipprot->handler(skb);
> >       |                             ^~ =20
>=20
> Hi Jakub,
>=20
> I guess CONFIG_IPV6 is not enabled, right? I will fix it.

IDK, it's run but TC folks I don't see the artifact for config=20
in the logs.=20
