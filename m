Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58075390C9E;
	Sun, 13 Sep 2026 22:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789337542; cv=none; b=az1Lwgwyu1+PS5Dn2/FdjK37pNUx18s3oetZFQJ7nBWNAf5Zzex+B65SqURQPD9f3DrLBGZsnUAc1p8KhiGN1ljiR+/Y9eleqgTUgiB4q1/IPFLdw4ExBwpNUhrhTEztTw+GdFbwAqo/0HKiKqHcQsxcdNz+ZifL5B53tZ+73Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789337542; c=relaxed/simple;
	bh=XfTMzgpSMJDp9Ib78sUZKa2WH0c+7+ufSCLyIggQGEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4ZbVpQ7bfpqLTQYndacPjrnh0qAAZwe06JmTUaJexFodLKY/N3i7I6sJaY12OZSXJBXiqBgsKvYoCK/EyV7nhb5cLIaAeR/8cREO58w+efDS/6O1dN6OSKwmsk9xPvCRcXwIGXyMA1SwABKS1cHr+otqepvMMuwvJsgrRR84ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dIBL9Dh4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dIBL9Dh4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789337535;
	bh=B6erEurSeK3IOCHg4FHichbep/sok8bKkr3OG42L1fI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dIBL9Dh4tP5Ph+9GKAV1xazh02Ib5oIDRx65EgJU9BloLEZKL8J2+EfSHQ1a/kjAZ
	 l6yeF2ZHyShjrcpFaD2tRiwpfxC/frOLN/cVrE4oTlOKps+3qS+G35FGXIy8fGXUqg
	 3jWd4pVDznTGzRInnofYVKxxk8prdxufr6z/lg61/laHQ415aBq0XZbo/O6yCEhvqK
	 rZe6c8QCbQ/+/hvv4aozKAbRs6neRn3VylaqD6BEPLISoJbAYlwMg4bs3WYTKtuZWm
	 GCQa8dYql0mSWhoeL/hFH1fiVURBX7P/tBQ6uBEm+XF/5+yKBRSsWG4FYjTGAuCKIm
	 2SVH8MmF5/NLA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DC49260055;
	Mon, 14 Sep 2026 00:12:15 +0200 (CEST)
Date: Mon, 14 Sep 2026 00:12:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stable@vger.kernel.org,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: network flow offloading broken in 6.18.45+
Message-ID: <aqcfvRE3aHoAx8s7@chamomile>
References: <7dfa42f6-64c1-4084-bfea-d57500c245cf@hauke-m.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7dfa42f6-64c1-4084-bfea-d57500c245cf@hauke-m.de>

Hi Hauke,

On Wed, Sep 09, 2026 at 06:29:50PM +0200, Hauke Mehrtens wrote:
> Hi,
> 
> flow offloading is currently broken in Linux 6.18.45.
> 
> Since the backport of commit b5964aac51e0 ("netfilter: flowtable:
> consolidate xmit path") to Linux 6.18.45. This is happening in a router with
> traffic from wifi to the Ethernet device when mac80211 returns -EOPNOTSUPP.
> 
> Upstream fixed it in 871df5007eda ("netfilter: flowtable: bail out if
> forward path cannot be discovered") by not offloading the flow at all.
> backporting this change looks more complicated.
> 
> This cam up in a discussion in an OpenWrt PR:
> https://github.com/openwrt/openwrt/pull/24800
> 
> An LLM suggested this change: https://github.com/openwrt/openwrt/pull/24800/changes/394d741e6e76ecd172dbbf1d9ba171e378211734

Patch went away.

> It seams to work, but I do not understand this part of the code god enough
> to judge if this is correct.

Could you attach the patch to this email for review?

Thanks.
