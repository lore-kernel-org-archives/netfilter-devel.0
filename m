Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1262253359;
	Thu, 21 Aug 2025 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755787647; cv=none; b=b1KWSE6naVroOrgO21Qw6Rd1/hQKYxSJV0sB30FtPt/62qNYEwTnNcHVrm14nVOOz71DqGvSZ5xQIVA1g/J7qE1cCOWyIWda62gMWQKKnC/je9JNa/HyXBdMeHPjrzZ53JwZadf+V99DYVZ0NXxKceWBhb8/SXYXsojCowlPfOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755787647; c=relaxed/simple;
	bh=69Jw2Jxys8t4+vWvpxm0TD+lT6lPUWlfyE3Zxx1THZU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e2DA9cw6Ilhghj5vQs5uDJa2FdE/XZ34E8Fqfk8TkEdoo0/m4JO7ppPko1wXWlgieE2WFxCQqIC4oXGwuqE1VJvKSuPwOcCbEoUw1wpqtID/cQVUfcRnrKnIQrOiAlmiwvDjzoNkEi7MBgThaw8RE2Olw5rxP7b31Dj9EgKfC1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVc1vezA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVc1vezA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F4AC4CEEB;
	Thu, 21 Aug 2025 14:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755787647;
	bh=69Jw2Jxys8t4+vWvpxm0TD+lT6lPUWlfyE3Zxx1THZU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NVc1vezArIbFmWA7MMJqwJdUrhYsIVgot/A1Ix0h6TbcXDxZokYCmbYcMZmAKn1mq
	 ONz9+M1rkyXufz16BEasYGh7kHJ3l9hPQMzAKXdh5UYi1YHBzyUFJBh5SmCSr9EZcS
	 pTbr+xGfviJ10Wh45M53HQt4E3U9dXuCXsd+3Obur8klpRbAaY3E3Qj/MqNaPBjpHz
	 IZKZYkk4fs+LZNRYlLswiBjQPbmpL0mdofleyAsrJs5l09Ti292FxbA2cd0a+ae67V
	 B3Xv7Npr2l72cdJkn/n490ZrIe9uLbyp7VrRp7c3dRXrzp4mhc/Yz775mo9dxwANLx
	 ujzI/hbYR85Ag==
Date: Thu, 21 Aug 2025 07:47:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_reject: don't leak dst refcount for
 loopback packets
Message-ID: <20250821074726.7cc3f294@kernel.org>
In-Reply-To: <aKXV_3J4iDkhQ06R@strlen.de>
References: <20250820123707.10671-1-fw@strlen.de>
	<aKXKpE35H7KBzdBa@calendula>
	<aKXLsoLkSdnEU_at@calendula>
	<aKXV_3J4iDkhQ06R@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 Aug 2025 16:04:47 +0200 Florian Westphal wrote:
> > > Quick question: does inconditional route lookup work for br_netfilter?  
> > 
> > Never mind, it should be fine, the fake dst get attached to the skb.  
> 
> Good point, this changes behaviour for br_netfilter case, we no
> longer call nf_reject_fill_skb_dst() then due to the fake dst.
> 
> I don't think br_netfilter is supposed to do anything (iptables
> -j REJECT doesn't work in PRE_ROUTING), and we should not encourage
> use of br_netfilter with nftables.
> 
> What about adding a followup patch, targetting nf, that adds:
> 
> if (hook == NF_INET_PRE_ROUTING && nf_bridge_info_exists(oldskb))
> 	return;
> 
> ?
> 
> After all, there is no guarantee that we have the needed routing
> info on a bridge in the first place.

Pablo, are you okay with that plan? Would be great to ship this to
Linus and therefore net-next today, given the checks recently added
there..
