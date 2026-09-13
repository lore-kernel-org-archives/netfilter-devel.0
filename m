Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A814A3246ED;
	Sun, 13 Sep 2026 22:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789337634; cv=none; b=W0w+hNauukVJgt+nui12wbRf2ISIyNuxmHZy79C+qEi6CjzXUM8SRPE8nC/ilMnOuoR4O+Pa1Po44iRZJnbAnqTNCeOFarN2XW70Gq7LtQi4OuW9yoypxyiDgS6eNKgiIm3wDctThxnPV1cE45WhRtLzKr1ro/SMRGHy/vO7mQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789337634; c=relaxed/simple;
	bh=XLKPiu0LjX4Rn4hnXEeRyCvJpv/nG5FQrd6Mv64g9wc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0ixSbmh5cFJRXiRJHm0xbew3QGOc56Kxr75ZgrHbvgf+QFifrYXPl5uZ5FWR0h47422rw+7hPVityPZD0Wdc6edoEbiukf+8k3/0pBZFXVI4/IUYusbLuzLIyZkF/RyMD4l3+EJmsSEZ1mB2TOhTgZfM193cs6VimpA0qWTvaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=j0bwlEXe; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="j0bwlEXe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789337630;
	bh=9Qq4YgpOqFzsu9JyjEWX74jLdnvCcAI0LlXyTxBRWYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j0bwlEXex8n13VdPB7bklUo4uu0GNc+AjQC0YPlhbT9n6K8c9JV+sYKK9hqoFspaJ
	 b9M1L8xdvcneAVJ0JLygZOhmKUAag1MCbZtin9BaF1JRThqikre78aK1jmiE0Tohrl
	 qhanJZ176FoSirYD0CNesFgzfTibdHgZepHOltUsfMqlTuOUdKGjuhRa1SYUKRCcHx
	 oP1CrFftVvzGQ2p+nd5/dwY3HQU9+563Ma+YHXPNIMBYBsn6eQSXrJq3a6vR2fLvwH
	 +11AHAKZOySJIXRd/f+LKPosnPeTjgFiZo+OBNVAxv6OusUECOTNgbROd8lavuDWoX
	 GK4MQbynPu0QA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6E7C16005B;
	Mon, 14 Sep 2026 00:13:50 +0200 (CEST)
Date: Mon, 14 Sep 2026 00:13:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stable@vger.kernel.org,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: network flow offloading broken in 6.18.45+
Message-ID: <aqcgG0y-nYz4DWz3@chamomile>
References: <7dfa42f6-64c1-4084-bfea-d57500c245cf@hauke-m.de>
 <aqcfvRE3aHoAx8s7@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqcfvRE3aHoAx8s7@chamomile>

On Mon, Sep 14, 2026 at 12:12:16AM +0200, Pablo Neira Ayuso wrote:
> Hi Hauke,
> 
> On Wed, Sep 09, 2026 at 06:29:50PM +0200, Hauke Mehrtens wrote:
> > Hi,
> > 
> > flow offloading is currently broken in Linux 6.18.45.
> > 
> > Since the backport of commit b5964aac51e0 ("netfilter: flowtable:
> > consolidate xmit path") to Linux 6.18.45. This is happening in a router with
> > traffic from wifi to the Ethernet device when mac80211 returns -EOPNOTSUPP.
> > 
> > Upstream fixed it in 871df5007eda ("netfilter: flowtable: bail out if
> > forward path cannot be discovered") by not offloading the flow at all.
> > backporting this change looks more complicated.
> > 
> > This cam up in a discussion in an OpenWrt PR:
> > https://github.com/openwrt/openwrt/pull/24800
> > 
> > An LLM suggested this change: https://github.com/openwrt/openwrt/pull/24800/changes/394d741e6e76ecd172dbbf1d9ba171e378211734
> 
> Patch went away.
> 
> > It seams to work, but I do not understand this part of the code god enough
> > to judge if this is correct.
> 
> Could you attach the patch to this email for review?

I've found it :)

https://github.com/openwrt/openwrt/commit/d2b53b8043e17087b877bfc2335cbba87dffb4e0
