Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DD14E3242;
	Fri,  9 Oct 2026 15:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791558283; cv=none; b=mj5JEXIVuBVcWkkZU3lCFnj7XEn6ZIKLFRd0pTR8JjNXD9TTPJUoGRUunct8zApQREfK33PC+YHcZVIUnX/QaFhUz8JLCps6N2zkrdoDmPg3oMsR64z9n6/6UNoFkvh07eaBycW6Px7dJLxjUOlUfbZ4XKxzAY9oBE+UwPj82xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791558283; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f65PS2SW2K0+9rTPQ42gv855Xkd0Byv7bDzlTqm/3Lb7MqrDTXggqjufcrhgGOk0ifbCkmeEz/0aoTPpPl7zY7mMpGx6bwAniIPZe1SLakF6SR2xJlVbOsqO5QBi1z/BnCZJcQhPVlkotMEZxvZrstZdu3G6Qe+bfdonxR9hjfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vx9+TnRm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vx9+TnRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297311F000FF;
	Fri,  9 Oct 2026 15:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791558282;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vx9+TnRmKH4AP2NgbOuAqFhoCoBdoxS2W7uUiw385ILRdmbPApTYdNVIMxoguuBF6
	 A9trxsbn4Cvg+52zk222RT9XmxZL/eAANTmCuFoCppmWKoRw3zjhFGCQbX055sfns4
	 p2DEsDT2zggmAoYpWgmqLjdjWZM3EMoA85fZ2jzvbL6VEhR5GU+YMxBFXSwke11v7P
	 r6VVNDyAxGTh2Qf9HDPZxIYKr8aUTX4G03z3ry6wi7qFSdX5MU/7na2b3SJky1QG+M
	 I8fUY16pQXN5uyqcc0Zb2bC71qVHWgZeFDem6szHBB5m8pws7MLp2ZkkGIKTNN2M9M
	 C1itnOyOcSo9Q==
From: netdev-bot+sinfo@kernel.org
To: Gabriel Goller <g.goller@proxmox.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>,
 Ido Schimmel <idosch@nvidia.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH net-next] netfilter: bridge: refragment reassembled
 packets passed up
Date: Fri, 09 Oct 2026 15:04:40 +0000
Message-ID: <179155828067.2527009.9838753386350423335@kernel.org>
In-Reply-To: <20261009150246.443127-1-g.goller@proxmox.com>
References: <20261009150246.443127-1-g.goller@proxmox.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
