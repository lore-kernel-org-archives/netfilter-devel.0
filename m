Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DF33A961A;
	Tue, 15 Sep 2026 08:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789460134; cv=none; b=h5NsRtGAtIVAAQd0Udbi3XwozPu4MNfTuR2S2IbVziiaht/kn1lYSmiEwhzycICmEjJca+oK1tcg0RoaIxDz+0f3o+qVHH402TOqeIpNXsDV74cZBhUacrZSzTmKiV8uDqYMIfyY4k9F25wfD4VGOOyU3sJ+M27bqmJRdV4u4Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789460134; c=relaxed/simple;
	bh=cPRbZPEs8ojOrPWPVXYqdY5vmFNELiY+U1btNbqjbqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OL9/LKzmbqXxjil7oOM/m0qZlrh78YjV2NSkobuaHSRe+cfUrD/DNEfIHvKjfz6fKv+ibQxxeELlXhIZmULa4unfryB3kfAr7+zjmQmp4FOmOE+UczvX6uzFp1ma1D9W2oN1Awo3WhkMkrkJC3uFX1IGe6AODIpybSBUb0Bs3rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OA4GbUeH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OA4GbUeH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789460123;
	bh=+mLf7YJol3PGpt7VzxE3z1ex1n/DMEGBgz1mEFBBuqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OA4GbUeHsWCMBylKJv5e4/ybLArn0rDP3Hiyj7oUY1xdS56Y+NRjZ9OOd/ggGguNY
	 AIJEcP3UFMFkymnwKuPaTW5gDAZVLKBwThHwei8lDdkvOpUBOvobvGYmbJKTEJu+/4
	 7esN1I9zbRhsMVLGJuHCKOmau1+7hJfeMu6Cfl71TOKswGQgNyvof6Y4XuRc4dvZM/
	 HoO0wSUPF3wkmqrNcdMceCaTXNR8qNfRz5PfYAQWuo6y+heHlOG0Ynzm5Qeqc3eQkJ
	 yoH+AfsanB7Ds0Vja2uvi+w+FwIfuR3ASboQ0HMjIiFCz4OSLhvlA/KNStW2ngXGyv
	 6PiaeSMmVURpg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D28EF60054;
	Tue, 15 Sep 2026 10:15:22 +0200 (CEST)
Date: Tue, 15 Sep 2026 10:15:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stable@vger.kernel.org,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: network flow offloading broken in 6.18.45+
Message-ID: <aqj-mK5O-J4PcbLv@chamomile>
References: <7dfa42f6-64c1-4084-bfea-d57500c245cf@hauke-m.de>
 <aqcfvRE3aHoAx8s7@chamomile>
 <aqcgG0y-nYz4DWz3@chamomile>
 <aqfofgtUfyXlfHLr@chamomile>
 <aqfqQPP2Y7iG3kM_@chamomile>
 <a031049b-ca94-4e11-b7b8-7b4c2acba954@hauke-m.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a031049b-ca94-4e11-b7b8-7b4c2acba954@hauke-m.de>

On Tue, Sep 15, 2026 at 02:20:25AM +0200, Hauke Mehrtens wrote:
> On 9/14/26 14:36, Pablo Neira Ayuso wrote:
> > On Mon, Sep 14, 2026 at 02:28:49PM +0200, Pablo Neira Ayuso wrote:
> > > Hi,
> > > 
> > > On Mon, Sep 14, 2026 at 12:13:50AM +0200, Pablo Neira Ayuso wrote:
> > > > On Mon, Sep 14, 2026 at 12:12:16AM +0200, Pablo Neira Ayuso wrote:
> > > > > Hi Hauke,
> > > > > 
> > > > > On Wed, Sep 09, 2026 at 06:29:50PM +0200, Hauke Mehrtens wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > flow offloading is currently broken in Linux 6.18.45.
> > > > > > 
> > > > > > Since the backport of commit b5964aac51e0 ("netfilter: flowtable:
> > > > > > consolidate xmit path") to Linux 6.18.45. This is happening in a router with
> > > > > > traffic from wifi to the Ethernet device when mac80211 returns -EOPNOTSUPP.
> > > > > > 
> > > > > > Upstream fixed it in 871df5007eda ("netfilter: flowtable: bail out if
> > > > > > forward path cannot be discovered") by not offloading the flow at all.
> > > > > > backporting this change looks more complicated.
> > > > > > 
> > > > > > This cam up in a discussion in an OpenWrt PR:
> > > > > > https://github.com/openwrt/openwrt/pull/24800
> > > > > > 
> > > > > > An LLM suggested this change: https://github.com/openwrt/openwrt/pull/24800/changes/394d741e6e76ecd172dbbf1d9ba171e378211734
> > > > > 
> > > > > Patch went away.
> > > > > 
> > > > > > It seams to work, but I do not understand this part of the code god enough
> > > > > > to judge if this is correct.
> > > > > 
> > > > > Could you attach the patch to this email for review?
> > > > 
> > > > I've found it :)
> > > > 
> > > > https://github.com/openwrt/openwrt/commit/d2b53b8043e17087b877bfc2335cbba87dffb4e0
> > > 
> > > I've proposed the following fix:
> > > 
> > > https://lore.kernel.org/netfilter-devel/20260914122456.1963453-1-pablo@netfilter.org/
> > 
> > Actually, this v2 should work:
> > 
> > https://lore.kernel.org/netfilter-devel/20260914123334.1964397-1-pablo@netfilter.org/
> 
> Hi Pablo,
> 
> Thank you for looking into this.
> 
> I think we have to handle DEV_PATH_MTK_WDMA like we do it with DEV_PATH_DSA
> in nft_dev_path_info() too.

I don't think you can find DEV_PATH_MTK_WDMA from nft_dev_path_info().

There is a story about this: Felix needed a way to expose the MTK SoC
capabilities in some way to drivers, he decided to use the
.fill_forward_path interface for this purpose.

See mtk_flow_get_wdma_info(), it makes a direct call to
dev_fill_forward_path() to get the DEV_PATH_MTK_WDMA.
Therefore, it is not possible to see DEV_PATH_MTK_WDMA from
nft_dev_path_info() because it does not belong there.

I suggested a new interface for this but SoC requirements were not
clear at the time IIRC.

My patch is a workaround, so dev_fill_forward_path() does not fail for
this case.

> mt7915_net_fill_forward_path() from
> drivers/net/wireless/mediatek/mt76/mt7915/main.c could also return
> -ENODEV like mac80211 does.
> Should we backport 871df5007eda to 6.18 instead?

Does 871df5007eda fix the issue for you?

If I understood correctly, this simply results in not setting up the
flowtable bypass? ie. ethernet to wifi will just fall back to classic
forwarding path.
