Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0751C84D6
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Mar 2025 09:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742636018; cv=none; b=a7XtcXIzeCfba4Qs32EQOxxVlEVXIm1ftYEB45+1ceuKFLmTwNIVkdARv/XAXAdIx48VpkIJNCbkRL1XMVBRRGTH6+f6etrewhMwjMm9BxTSpnNCjCkZNyeozmnKM6loMESnJvmgSue1INIVn5MjdH5Tw9wDZQG9prEm9OuGZmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742636018; c=relaxed/simple;
	bh=qiWSKpJjg8J0wR+rnKVrAWk5Gkrz2vXDBwquf2iTOpo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Lr7NVZkjB+Yg5u9UiNcdcHvp9iBPXteGsQuOzE56lr1o3isodGuWt019fId6wj5SvWqwtJGi15et26p2Jkiav780TDwNR5jlUHrc4xnWKVCcvZrsbyxLYShddRL/GIbNt1+jqt3nC/+P54O2WdlXPhA5tQOswojqQxZ566Jfkko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 970C8100FC56BB; Sat, 22 Mar 2025 10:24:59 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 96BEE110014B25;
	Sat, 22 Mar 2025 10:24:59 +0100 (CET)
Date: Sat, 22 Mar 2025 10:24:59 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Duncan Roe <duncan_roe@optusnet.com.au>
cc: Arturo Borrero Gonzalez <arturo@debian.org>, 
    Pablo Neira Ayuso <pablo@netfilter.org>, Jan Engelhardt <jengelh@inai.de>, 
    netfilter-devel@vger.kernel.org, fw@strlen.de, matthias.gerstner@suse.com, 
    phil@nwl.cc, eric@garver.life
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
In-Reply-To: <Z94XLnSQRfMh9THs@slk15.local.net>
Message-ID: <22n4s4s4-8155-708o-4091-q6o3nq313641@vanv.qr>
References: <20250228205935.59659-1-jengelh@inai.de> <Z8jDjlJcehMB_Z9F@calendula> <dfaada92-44ca-44c1-83e4-5844191ff57b@debian.org> <Z94XLnSQRfMh9THs@slk15.local.net>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Saturday 2025-03-22 02:49, Duncan Roe wrote:
>>
>> I have mixed feelings about having this systemd service file in this repository.
>> Will this file be maintained wrt. systemd ecosystem updates? Or will it be
>> outdated and neglected after a few years?

There are no changes expected to be necessary.

>> For most folks, I assume they will run nftables via firewalld or any other
>> ruleset manager, unless they know what they are doing. And if they know what
>> they are doing (i.e, they have crafted their own firewalling system), then
>> most likely the systemd config in this repo is ignored.

This is just a launcher, not the ruleset itself.
And with /etc/init.d/boot.local practically gone on modern systems,
it's not as simple anymore to just slap nft -f.. in boot.local.

