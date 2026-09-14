Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE60F45DF68;
	Mon, 14 Sep 2026 12:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388933; cv=none; b=P3ET0lN+qkgZvZZLhLqv/ME2IH8JeOBrDoncqvyeFds9GNA1w8GM+mTrY3nVRZGBJjX/A9sKs4JeE8ooBs+LGHX8azPPikyeUCyS/8m1XSQirkHzeVPnB/bXDnAcVb02XGN8yzXzYItQAX1+I3KGnkjwXTlCyYBAtuqG+omg1Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388933; c=relaxed/simple;
	bh=88gjqkU5xAcXF48o6O1dmyPVBsMwJ9OhfUENJXfo0d4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JxkkEaoPchzXb4DoiUVByQzINR2JKHNu3zNWU6c7fgh3PWrnC9hb5RpMYI7OtA5M/rNHqJW7axSM4HhGWWYLUAv/O+opHWJrrAvJdwlzoowr39BZ6527Ee0SCdOa07SlG8GVcU17yrqdbmVerBQGEjsHqtXPWWW5xaheDyt9/bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Tv0/W2bo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Tv0/W2bo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789388928;
	bh=ZcTvJohNr77d40JF4EM+rf0NaLP39PMwUENUc5J5E30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tv0/W2boC7DCz5e03hPfHDNKJyIIDcX4ZUZx//g4I07paFLPdKz1pXA/TH171esk4
	 IsIP1avG57Wep1131WSxMBSkJ0IkScW5Wu6U8NUhBObIaEowLIfebJI6JzhkVeahd3
	 F5rpyQmpCqOHJImRkKfv53jv/Y6J06DPDOXPt5xlwmvGaglGs34W0eix8Py/ZvUmjZ
	 KodqVPJ9pXaSttDU0hZ4Ip4gwq92Dcv8F+DoFm+5ciBBR7ihJ5yoDyJCWaaoShs8Rl
	 +GyY9MqEJARI2wWVowtXa1efJdf7P+Usj1pmIWeLEQLzVa/WG1HjyQ95RTzApRO6OD
	 RWUZIWlTQl2Eg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 779B760055;
	Mon, 14 Sep 2026 14:28:48 +0200 (CEST)
Date: Mon, 14 Sep 2026 14:28:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stable@vger.kernel.org,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: network flow offloading broken in 6.18.45+
Message-ID: <aqfofgtUfyXlfHLr@chamomile>
References: <7dfa42f6-64c1-4084-bfea-d57500c245cf@hauke-m.de>
 <aqcfvRE3aHoAx8s7@chamomile>
 <aqcgG0y-nYz4DWz3@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqcgG0y-nYz4DWz3@chamomile>

Hi,

On Mon, Sep 14, 2026 at 12:13:50AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 14, 2026 at 12:12:16AM +0200, Pablo Neira Ayuso wrote:
> > Hi Hauke,
> > 
> > On Wed, Sep 09, 2026 at 06:29:50PM +0200, Hauke Mehrtens wrote:
> > > Hi,
> > > 
> > > flow offloading is currently broken in Linux 6.18.45.
> > > 
> > > Since the backport of commit b5964aac51e0 ("netfilter: flowtable:
> > > consolidate xmit path") to Linux 6.18.45. This is happening in a router with
> > > traffic from wifi to the Ethernet device when mac80211 returns -EOPNOTSUPP.
> > > 
> > > Upstream fixed it in 871df5007eda ("netfilter: flowtable: bail out if
> > > forward path cannot be discovered") by not offloading the flow at all.
> > > backporting this change looks more complicated.
> > > 
> > > This cam up in a discussion in an OpenWrt PR:
> > > https://github.com/openwrt/openwrt/pull/24800
> > > 
> > > An LLM suggested this change: https://github.com/openwrt/openwrt/pull/24800/changes/394d741e6e76ecd172dbbf1d9ba171e378211734
> > 
> > Patch went away.
> > 
> > > It seams to work, but I do not understand this part of the code god enough
> > > to judge if this is correct.
> > 
> > Could you attach the patch to this email for review?
> 
> I've found it :)
> 
> https://github.com/openwrt/openwrt/commit/d2b53b8043e17087b877bfc2335cbba87dffb4e0

I've proposed the following fix:

https://lore.kernel.org/netfilter-devel/20260914122456.1963453-1-pablo@netfilter.org/
