Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA7436B903;
	Mon,  3 Aug 2026 23:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798287; cv=none; b=sZa/3xGgvOZNQ4XsX993xZm48SGaFJHzHJvmvc07hCMDveb+eRsLejH+jHLXG9KSzacb5uXm+SUAwsxTqqgQZ72+2fh+xs8xo915nHF5X0G8Vqk9JGRdeEz7pWuAHH6HXLF6ZinTeX3gSmQLqeuZ8c2wPpvZ0wKiIfUY+H0qVKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798287; c=relaxed/simple;
	bh=fV/vX0cIO+XOnCK8fEAz4VAe9VlB7u00hYokhyGjVqo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7hm/klo8MJxqgk71KHN8s5i6XCBUqlU5lBOL3MwkXVpatnWwkFNkvZfhXTgRyP8QSHXGv69/PLx0q81NaniDWfRIpksBMYSi/FAGRCIgTmL81U7mzm/ixgZybb2pmhFAjxh1gczcVto+hti0a3m4xAaosuVSemaniqjjBvtBSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5YRIR3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5YRIR3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D161F000E9;
	Mon,  3 Aug 2026 23:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798286;
	bh=fV/vX0cIO+XOnCK8fEAz4VAe9VlB7u00hYokhyGjVqo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=H5YRIR3CHWiNY/c5PS7hpBEM5SvdP1bB1Oaemh0JigG0eNSRmCSsQacOKyETPPAJE
	 yA6FnmKO/JlkeSdvQd1F/2dkyi5ePa11dVs8+YYXbyWtFWbJpbrN4v7JJeMJOajjea
	 iSax2OhUv1laUmnjs2zTIASOlP0D1CI2HxX4aAwQUpM4zTMzNvI1qm4Aalmkxf3MfQ
	 pWglChs0lK0BRA+Q9yc+7pTGIRI6I+thy4MWjfbBeVZZZvi0FAn1E7AC6LqVpAGrgh
	 dRYWWuai2Nish2+5YiA9ZV+1pOW+q5QAhSI2cMagY9Wa6eGGHdqcb7cKd0AjlM8Peg
	 UEEZ6n4X/yh+w==
Date: Mon, 3 Aug 2026 16:04:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>, Vladimir Oltean
 <vladimir.oltean@nxp.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Pablo Neira
 Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Jamal
 Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jiri
 Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org,
 syzbot+5a66db916cdde0dbcc1c@syzkaller.appspotmail.com, Xiang Mei
 <xmei5@asu.edu>, stable@vger.kernel.org
Subject: Re: [PATCH net v2] net: flow_offload: serialize driver callback
 lists
Message-ID: <20260803160444.44a1cf32@kernel.org>
In-Reply-To: <20260726120338.488658-1-bestswngs@gmail.com>
References: <20260719175028.988301-2-bestswngs@gmail.com>
	<20260726120338.488658-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 26 Jul 2026 05:03:15 -0700 Weiming Shi wrote:
> Add a flow-offload callback mutex and hold it across direct and indirect
> setup, callback ownership transfer and rollback. Move indirect-unregister
> list removal into the flow-offload core, and keep indirect-device
> registration transactional on setup failure. When TC must reject an
> indirect bind after callback installation, unwind only the callbacks
> created by that bind so existing callbacks remain intact.

Isn't the unbind / rollback stuff mostly orthogonal to the locking?
Looks like the patch should be split.
