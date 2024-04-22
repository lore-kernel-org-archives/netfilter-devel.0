Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D801804E;
	Mon, 22 Apr 2024 20:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713818010; cv=none; b=JPzDyuyErOej7WyZ45kgCjncCCN25jDtHq4+D3NDEDGHKTxBvkK9N/ancs8GtfU7peEIoU06Fuuvm8pKhqFqTf2VpAzWZrF6J5LSSwz1eBOhrAy9dQNyHuJdgyy4zmgkYoLJg+mWJ/Y7zuXJpFXBeB2YwT4ejEEgVAkLLO2h74k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713818010; c=relaxed/simple;
	bh=oJNjSmrjRwMWFDXQiqjE79MB5ONPcCgCcg3s+otQ4/s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SW7F6CAe0J04uN3fzELDKg8+T/M1RJuBYDu4XztvezCsxK4prBvTOkfDx3BqsaWa83I5xSyr4Omh/fM2EDNFeaYpqQdPkel1yJ9+YkjGzzXEoRpKX/ypwnUihE4LqEKCDfM7m5+atKf2TkPmhuXvyvqMtyM0eu2GIHVgnRKsmPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9AcwCOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9AcwCOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D2BC113CC;
	Mon, 22 Apr 2024 20:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713818010;
	bh=oJNjSmrjRwMWFDXQiqjE79MB5ONPcCgCcg3s+otQ4/s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=L9AcwCOxBUxSQLf7OB8mDMR7o0hOYpJo3e1H0sjPBhg+RYANmcuAnCUngFyHrt56h
	 yQ6Sah9rWlKGRJLEe/4Wppn9z/0NFWvAQ0EqJgmGyFi1zwSA50NDyVujEFIs+W7bI/
	 bFisV6bRI8JHQyfwnfhE0XQgttmsXJbcoGUr3evdLHTraJJIkhm9uYGpCn8Ab2WvRu
	 putNkmE+PgWnaxZebD35Xr7EwkDoXVgfC61VKbSG9H35LvvAueGx3GYAsGf5Ujeqtb
	 Nmseo7ssUrk18QlaWJRik/sgcdNqVKQIB2dptsF6MP7nuq457/Q7shWz5gqVV4+Li1
	 kh6LYUL5XtVwg==
Date: Mon, 22 Apr 2024 13:33:28 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>, Jacob Keller
 <jacob.e.keller@intel.com>, Jozsef Kadlecsik <kadlec@netfilter.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 4/4] netfilter: nfnetlink: Handle ACK flags
 for batch messages
Message-ID: <20240422133328.3d626130@kernel.org>
In-Reply-To: <20240418095153.47eb18a7@kernel.org>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
	<20240418104737.77914-5-donald.hunter@gmail.com>
	<ZiFKvyvojcIqMQ3R@calendula>
	<20240418095153.47eb18a7@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Apr 2024 09:51:53 -0700 Jakub Kicinski wrote:
> On Thu, 18 Apr 2024 18:30:55 +0200 Pablo Neira Ayuso wrote:
> > Out of curiosity: Why does the tool need an explicit ack for each
> > command? As mentioned above, this consumes a lot netlink bandwidth.  
> 
> I think that the tool is sort of besides the point, it's just a PoC.
> The point is that we're trying to describe netlink protocols in machine
> readable fashion. Which in turn makes it possible to write netlink
> binding generators in any language, like modern RPC frameworks.
> For that to work we need protocol basics to be followed.
> 
> That's not to say that we're going to force all netlink families to
> change to follow extra new rules. Just those that want to be accessed
> via the bindings.

Pablo, any thoughts? Convinced? Given this touches YNL in significant
ways I'd prefer to merge it to net-next.
