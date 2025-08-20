Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71644A01;
	Wed, 20 Aug 2025 00:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755651524; cv=none; b=JOR06J2fN8XurhJ+Ix0wRXH465UAJIn5SNgyVfEmiccn/broE8dtUF214CMbTwDFgvl3ICA83VU/75oWP0mv8IGRCf1QsAKnVgcFU/wOeOEtOVqEpDurG9enoi+ZhrC9VyQnrPMEEaW9kH/mJeYqF0PrN2ao08CdP1e4/15XKkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755651524; c=relaxed/simple;
	bh=/349ALdsu4QBDpaXh3U9xGpGjsaL10DyieyEXYkgeSs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A3GHpsObI6Avogv4hII/FFtvCTUoJJIn/9TgNQDCvUrqrreHXMnAWn5xcTaJypQRLERr+cdSXunLndFC4KWr2mMBN5BEm2saVIThWbL5G6GzOl7qT7UYJ1CUP+FvGUX60YtoSbV2hLDKdtEACyoQ6B7Rc/LR9dtZ9Jl5FV3KZOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATcMYPB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATcMYPB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0EBC4CEF1;
	Wed, 20 Aug 2025 00:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755651524;
	bh=/349ALdsu4QBDpaXh3U9xGpGjsaL10DyieyEXYkgeSs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ATcMYPB4KRqpAleWMOvmhVlKcZdpONku/9K5sCzlADLVRkrdf8ogJh/7c7DS54K/S
	 hXXXPomJ5r75cKXxwktrQ6MS8n8rrRuyoUDHi+vlZQv/Jkqtzo5dbq5/1GlEq478LL
	 NxnpRAanHm0IArifUsELU0TWiFoCRPv2PZfrbcRufy8PrJ2I7GljRiE37EOvT5JdXj
	 eFtjm6dbsXqMFn8GRYrzuRyZ+xpzZWFkLj9riYSST9PhSVzX7CjJcBJ+2TSX1bTAhc
	 wwOQ2mx4dTS0CzcqTkHG7qszkhsW2iCtyLdVa5WjDgmsppMQOhgCoU2OESbOU2IMv6
	 GursPn9kkxY8Q==
Date: Tue, 19 Aug 2025 17:58:42 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot ci <syzbot+ci77a5caa9fce14315@syzkaller.appspotmail.com>,
 abhishektamboli9@gmail.com, andrew@lunn.ch, ayush.sawal@chelsio.com,
 coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
 edumazet@google.com, fw@strlen.de, gregkh@linuxfoundation.org,
 herbert@gondor.apana.org.au, horms@kernel.org, kadlec@netfilter.org,
 linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev, mhal@rbox.co,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com,
 pablo@netfilter.org, sdf@fomichev.me, steffen.klassert@secunet.com,
 syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: net: Convert to skb_dstref_steal and
 skb_dstref_restore
Message-ID: <20250819175842.7edaf8a5@kernel.org>
In-Reply-To: <68a49b30.050a0220.e29e5.00c8.GAE@google.com>
References: <20250818154032.3173645-1-sdf@fomichev.me>
	<68a49b30.050a0220.e29e5.00c8.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 Aug 2025 08:41:36 -0700 syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v2] net: Convert to skb_dstref_steal and skb_dstref_restore
> https://lore.kernel.org/all/20250818154032.3173645-1-sdf@fomichev.me
> * [PATCH net-next v2 1/7] net: Add skb_dstref_steal and skb_dstref_restore
> * [PATCH net-next v2 2/7] xfrm: Switch to skb_dstref_steal to clear dst_entry
> * [PATCH net-next v2 3/7] netfilter: Switch to skb_dstref_steal to clear dst_entry
> * [PATCH net-next v2 4/7] net: Switch to skb_dstref_steal/skb_dstref_restore for ip_route_input callers
> * [PATCH net-next v2 5/7] staging: octeon: Convert to skb_dst_drop
> * [PATCH net-next v2 6/7] chtls: Convert to skb_dst_reset
> * [PATCH net-next v2 7/7] net: Add skb_dst_check_unset

> ***
> 
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
> Tested-by: syzbot@syzkaller.appspotmail.com

Hi Aleksandr!

Could we do something about this Tested-by: tag?
Since the syzbot CI reports are sent in reply to a series patchwork and
other tooling will think that syzbot is sending it's Tested-by tag for
this series.

In some cases we know that the issues found are unrelated, or rather
expect them to be fixed separately.

Could we perhaps indent the tag with a couple of spaces? Not 100% sure
but I _think_ most tools will match the tags only from start of line.
