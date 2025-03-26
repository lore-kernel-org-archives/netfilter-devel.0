Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142EC2620CD
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 22:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743027681; cv=none; b=QkzdkNnWOk+NATRu95tkDkuWfryVsCHKjxdvGQQ67Qyu+yrZ3Lz5bKlcoE5/iWfqqQBm2cX7vGoek8u5cko4tH4mNf0LmfN6ERG5G6UyyfFohzFVkI7G24xD/hg9vyLQoEWWG59WH4dapu94mVflCUPEG70csJriZPxeBwee5Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743027681; c=relaxed/simple;
	bh=mjZ2pESv4SUgAK89WKgsJ8JnYxXSMP5WJspMWCGJM/4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=i67ot+8zj2cuyh0RP/wKZ23f3tAgp6LQZUGgvQ3xbuABWXH5O1CLmBOtga4C5u8Y3SlGg7Pr0uhC2iCVDiFt2AWwzAapqCSZ4aG/z8cdL2VM+nJ3RyywsgKvwgmdWwb+YrIrlsD4KxI9QWOL2ZF93ph+53KCQBkXPeLspoUt3WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 7FB851003A832D; Wed, 26 Mar 2025 23:21:09 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 7E013110035500;
	Wed, 26 Mar 2025 23:21:09 +0100 (CET)
Date: Wed, 26 Mar 2025 23:21:09 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Phil Sutter <phil@nwl.cc>
cc: Dan Winship <danwinship@redhat.com>, Eric Garver <eric@garver.life>, 
    Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org, 
    fw@strlen.de, pablo@netfilter.org, Kevin Fenzi <kevin@scrye.com>, 
    Matthias Gerstner <matthias.gerstner@suse.com>, arturo@debian.org
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
In-Reply-To: <Z-QjsRMmEq90F6Qg@orbyte.nwl.cc>
Message-ID: <s0r11o2s-35ns-4sp9-1s0p-6n7n5r743581@vanv.qr>
References: <20250228205935.59659-1-jengelh@inai.de> <Z8muJWOYP3y-giAP@egarver-mac> <Z9wgoHjQhARxPtqm@orbyte.nwl.cc> <831bd90a-4305-489c-9163-827ad0b04e98@redhat.com> <Z-QjsRMmEq90F6Qg@orbyte.nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2025-03-26 16:56, Phil Sutter wrote:
>
>The suggested 'flush ruleset' stems from Fedora's nftables.service and
>is also present in CentOS Stream and RHEL. So anyone running k8s there
>either doesn't use nftables.service (likely, firewalld is default) or
>doesn't restart the service. Maybe k8s should "officially" conflict with
>nftables and iptables services?

It definitely should.

For example, in openSUSE we already added an extra constraint between
firewalld <-> nftables, so k8s should likely get a similar treatment.

fail2ban is also interesting, but a solved problem
(equally added ordering constraints to the distro years ago).
