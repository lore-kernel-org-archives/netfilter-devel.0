Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BF832937A;
	Thu, 24 Sep 2026 01:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790212917; cv=none; b=iQW5dNL5t9xiPrTnO/PgLiSKPtsGGUw4ne4algVJ4SyBTF9PGTEI3HY1LCCTS/JOHKITT6NifjUTv2q4uh2QubQ/owPk/PghKKyUWBTLVseiSMmRb4luoWykK909YdbJIpgm0L1BChrkkAE/tFKcF5MBDZsDlYxWAjRBZmu9pw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790212917; c=relaxed/simple;
	bh=Ky1x7ioEudZ73//KlPA4/klDX34uurbncGA26Tgf0QQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YtPo3dFjUerw12JVXATPaWY4abMnO2ZiWupopmWs+1Z5Gjs/6DWgfhYEkVutxfiGBhnpMSo7VTcke+Fr/aof5W3t4AsNjGP1OfQqNcvBf5FTTPDmfNyOtrLq5oA1BwfaXV0Vuw+hXRLQxEEQkyJ6BAsIsII7J1EGd54lUi5GVCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YxDh8VT2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YxDh8VT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5571F000FF;
	Thu, 24 Sep 2026 01:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790212915;
	bh=zT3bY2II2wr53NkwxCkoYnDwX7Q/6tgIxgma9p9/KrQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YxDh8VT2vFiYWqrirg39aw3vqPKPGRPVP0WRrb9y1JXx4HTwRplcNmVXDxvfwbIkZ
	 Oy/BAXPGnfyo3dhEiWXsnCvtqVyiqqW+lzwjYIZLlDIqLNNaYg463f8niJ8YgXjDjm
	 vimVeZjukBsY7WUp1h1wz5h03x484HBYLRaX9DTGbQj7+mcrxbHLfooWwkOzVRbstV
	 /Rj7CNZD28b6fPsapVdVPp7UkZj/TRSutLAs5d+5qeVC1F0DbftLEE/mpOoodDD0yJ
	 893kFZDyTt5M+cADfBsoQhyjiBPbXRUq+VSIkmF0+n8Lfr6A4eJSU+MWHgs4KIZ2r/
	 rRpy0K6GZDmgA==
Date: Wed, 23 Sep 2026 18:21:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org, Phil Sutter
 <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Aaron Conole <aconole@redhat.com>, Eelco Chaudron
 <echaudro@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko
 <jiri@resnulli.us>, Xin Long <lucien.xin@gmail.com>, Marcelo Ricardo
 Leitner <marcelo.leitner@gmail.com>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kernel@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH net 0/6] ovs, net/sched: fixes for UAF after conntrack
 extension realloc
Message-ID: <20260923182154.07efe6ae@kernel.org>
In-Reply-To: <20260921145655.3167436-1-i.maximets@ovn.org>
References: <20260921145655.3167436-1-i.maximets@ovn.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 21 Sep 2026 16:55:42 +0200 Ilya Maximets wrote:
> One clean up change plus two fixes for the UAF on helper extension
> realloc x 2.  First half for OVS and the second half for the similar
> code in act_ct.  This should cover all the known cases of this problem
> in these two modules.

Florian, Pablo, did you give up on the TC conntrack integration or can
we still hope for an ack? :)
