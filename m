Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC96D22FACA
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Apr 2025 12:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744893598; cv=none; b=Bre9xqdw48cIFDAeaSIA60HaNtZP4YIyTnzfSDu6UcjQ9ydTodiACFYYBYRQ2KbioJcnshhyUysfHYePA4bKZQ/MjoP0yCxp7nqK6aHv6amC1MvKJ4A/0olTfgw7DepBGMxIdTUwOHZ6cucHVcv0dBb4re80uNwlIdulq9bkrcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744893598; c=relaxed/simple;
	bh=PRsx+721Idwkz8WTiiZ3rujtD7Urf/tIEdAo9KZXjHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kA16kiMnMwJ1MQL0yO4eJySLa7ULJFMfoAY85huUOmJrPUg3gQAQrD8THBWNCviKFwg5MQ7N5MWlymwF3fjnc10J1jFE1GPwVj299hEE018/0Xjsa5JlRETDQ47USghcWKC4sRQYIpEqAmemFdHNQb43LdAhwyLE9woS19YCssw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VJOcsdbH; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VaT9ioH2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VJOcsdbH";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VaT9ioH2"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 40D9260A50; Thu, 17 Apr 2025 14:39:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744893594;
	bh=1ogi2/SvXmtxmnl4aayj5nN4xBQQo0jT11/5346Vqp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VJOcsdbHDtlvuia+qD/kLpeigrWgxrjtldecMtEYbkw3tCae7YpU/14lHD1n5aLpa
	 GRURqwIbs8iNgrj/jhELD3Rip0AB4l3oSwt0c8k2YNmxq+f3YSAe9/xu4LvQ9vRk3L
	 zunE72oQo7mi+5k5lbgVfW7lJv7R+8E1cVBs+wGbuviopnh73HWiRjojswOkPlc109
	 MrarXr2xMrqX+3oLXAY04nECuGYsGw6TK6/b5fbCr8Oz3/BeF30WtgOt1nt/+epkQ8
	 DEaoiYJfhwzHue3y2nZDrcMiC7tj9xtiBWsW3TsSa8buJPPahSrfJidnsDa4N5XucL
	 c/9GCTryNxATQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 04A91609F4;
	Thu, 17 Apr 2025 14:39:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744893592;
	bh=1ogi2/SvXmtxmnl4aayj5nN4xBQQo0jT11/5346Vqp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VaT9ioH2zUA9gXkC0NKhvbSwV1eOX3eL3y4u2bkpC9k3lR+ztiuscD5vYy5VfPqBD
	 sgyC5O/B8SHUQ+OqRmR37rn4WFc8vTqOnLQfnsOFUuYJOpQVmT+U61VwPaqz3E91eN
	 3PLjY9khzViya5Ql7Xg0aQZauZkSujNszEboAmKJWmODdIwhOT8YpLcEFQztTP8Hb2
	 8JYiRqOcPbVXGSAuqPtui8n3aGOlzkn1tX+JdiVo2NulwB/kAw6cwsTI1h9cTmnHuH
	 6y+EPKcRKCHZd7qf+2UcpB3vzSQ/HqEyr7XBeU/M14eC6XsXbgM22wzBDGeUJWuXYx
	 QRhRTHUYnLxzA==
Date: Thu, 17 Apr 2025 14:39:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <ej@inai.de>
Cc: Phil Sutter <phil@nwl.cc>, Dan Winship <danwinship@redhat.com>,
	Eric Garver <eric@garver.life>, Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org, fw@strlen.de,
	Kevin Fenzi <kevin@scrye.com>,
	Matthias Gerstner <matthias.gerstner@suse.com>, arturo@debian.org
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
Message-ID: <aAD2lOV4FBvA_oKx@calendula>
References: <20250228205935.59659-1-jengelh@inai.de>
 <Z8muJWOYP3y-giAP@egarver-mac>
 <Z9wgoHjQhARxPtqm@orbyte.nwl.cc>
 <831bd90a-4305-489c-9163-827ad0b04e98@redhat.com>
 <Z-QjsRMmEq90F6Qg@orbyte.nwl.cc>
 <s0r11o2s-35ns-4sp9-1s0p-6n7n5r743581@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s0r11o2s-35ns-4sp9-1s0p-6n7n5r743581@vanv.qr>

Hi Jan,

On Wed, Mar 26, 2025 at 11:21:09PM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2025-03-26 16:56, Phil Sutter wrote:
> >
> >The suggested 'flush ruleset' stems from Fedora's nftables.service and
> >is also present in CentOS Stream and RHEL. So anyone running k8s there
> >either doesn't use nftables.service (likely, firewalld is default) or
> >doesn't restart the service. Maybe k8s should "officially" conflict with
> >nftables and iptables services?
> 
> It definitely should.
> 
> For example, in openSUSE we already added an extra constraint between
> firewalld <-> nftables, so k8s should likely get a similar treatment.
> 
> fail2ban is also interesting, but a solved problem
> (equally added ordering constraints to the distro years ago).

I think this still needs one more iteration based on the feedback,
Phil mentioned one issue with flush ruleset that I can remember.

Thanks.
