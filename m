Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B7445D5CC;
	Mon, 14 Sep 2026 12:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789389382; cv=none; b=fpg0PHJxq4C/SO0SWwPr2G3JeX9kFFHpbnl9AiM3I1rzO+/iWMs8y1pWn00tlCoZjsLM/2o8mYXS9AJLeIO3qpv++dAA6jiG6Yvmmw9jRG9bUqG0tRCgm0HLTleXU6/R4ApN8UWkOLPaUBjLKwES2LQ8tZQbK1GvlseU6gcN4js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789389382; c=relaxed/simple;
	bh=UJ2r+DIdSWg4RDwYkHkxMWw4tiGTfXUq6IKdgvtGVmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7XIUeDZqXnMkP6BbNSHL5rK+wrUb8/WpFC2lJh6oulNgTNQnA13PG84nxeGmj1byH0okTYlpVWEr69HyWda7gjXuOxKzetaev+rUlX0iw8YzaESCX543R8qGrblTjihx3BG+AuzrJ2bKBjrYVg4DNYY1xeMHmLCKKKM+3KlLmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Tq8ZuVN3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Tq8ZuVN3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789389378;
	bh=NP+qx6KPd2izD8GZkscicDmC9TOW22fQf6ELEFHElZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tq8ZuVN3iZkAfg3dOEdfoRL+QtFHyJLGJZp/2y+u+jIk8HyNzCujdqS+PxG30U7jD
	 TFQBCNlcFWq5/QALnLSjnB3cnrxn2Gqb72rEJ+/2nOBfu7/d00tODb1jzso0eGoevJ
	 G9W4Fri8sl6qFYDgFmwBIMJnJPRi78Mr7I0Rzs2VDRzI2kK+91sAShyH6SI1geF+mF
	 VeyIcIz1F+eNEf56PcPkHYXEz+3D1IPraw/MRNus7Gsn1aeNoX+XRxEHLgPAO/HMPX
	 TRKon8vWMUW3T69vXK8WJXdAkwnaBgcHWRhYCSBa/0S2bye4+hvo6botT30i73woIq
	 UnjpNrGz2pDNA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CE6D260055;
	Mon, 14 Sep 2026 14:36:18 +0200 (CEST)
Date: Mon, 14 Sep 2026 14:36:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stable@vger.kernel.org,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: network flow offloading broken in 6.18.45+
Message-ID: <aqfqQPP2Y7iG3kM_@chamomile>
References: <7dfa42f6-64c1-4084-bfea-d57500c245cf@hauke-m.de>
 <aqcfvRE3aHoAx8s7@chamomile>
 <aqcgG0y-nYz4DWz3@chamomile>
 <aqfofgtUfyXlfHLr@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqfofgtUfyXlfHLr@chamomile>

On Mon, Sep 14, 2026 at 02:28:49PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Mon, Sep 14, 2026 at 12:13:50AM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Sep 14, 2026 at 12:12:16AM +0200, Pablo Neira Ayuso wrote:
> > > Hi Hauke,
> > > 
> > > On Wed, Sep 09, 2026 at 06:29:50PM +0200, Hauke Mehrtens wrote:
> > > > Hi,
> > > > 
> > > > flow offloading is currently broken in Linux 6.18.45.
> > > > 
> > > > Since the backport of commit b5964aac51e0 ("netfilter: flowtable:
> > > > consolidate xmit path") to Linux 6.18.45. This is happening in a router with
> > > > traffic from wifi to the Ethernet device when mac80211 returns -EOPNOTSUPP.
> > > > 
> > > > Upstream fixed it in 871df5007eda ("netfilter: flowtable: bail out if
> > > > forward path cannot be discovered") by not offloading the flow at all.
> > > > backporting this change looks more complicated.
> > > > 
> > > > This cam up in a discussion in an OpenWrt PR:
> > > > https://github.com/openwrt/openwrt/pull/24800
> > > > 
> > > > An LLM suggested this change: https://github.com/openwrt/openwrt/pull/24800/changes/394d741e6e76ecd172dbbf1d9ba171e378211734
> > > 
> > > Patch went away.
> > > 
> > > > It seams to work, but I do not understand this part of the code god enough
> > > > to judge if this is correct.
> > > 
> > > Could you attach the patch to this email for review?
> > 
> > I've found it :)
> > 
> > https://github.com/openwrt/openwrt/commit/d2b53b8043e17087b877bfc2335cbba87dffb4e0
> 
> I've proposed the following fix:
> 
> https://lore.kernel.org/netfilter-devel/20260914122456.1963453-1-pablo@netfilter.org/

Actually, this v2 should work:

https://lore.kernel.org/netfilter-devel/20260914123334.1964397-1-pablo@netfilter.org/
