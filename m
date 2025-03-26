Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07FA3A1BA
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004607; cv=none; b=R3xjYXOQRo0aTAKunlAvzzUGv3nw00VVk+VXMI/bLP+y2SHhx6b+ebZEpTdixlrgJIE07h69dBcXMzN/yfHcZs8VU6SiNenYMx0v72mQRSj19bTzcGxyAtlCUT716o56yGHDtKsPTUM/iop2jSmRwXhfSoUCG9odqsstmpNPv+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004607; c=relaxed/simple;
	bh=oHMe2+x78PxVqNujGFkLVNFh/q7HSXaMtUZeMilqZs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tjxAwwGsN1AHhLz1Dr07jPC+tAei5zQfMifmOQ/+ZlCThtQyGnPDjKdRR4UfZwsyqW2N0BG77bD0BvusTHwdVv/keRNofXrE8iyGvzhs8Zby+XqUw2KT260zCLYyO+W2CEWie4gX5uhbbauPG5JL1jwhMT5c4FbgN4/YmLqAqLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Mke7IHL4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Mke7IHL4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SOTmvraqIIp5QbgHm46mtOhIoe0PBopeHfGzPkwiu28=; b=Mke7IHL4Wd7xJJHyEZo+9DFLBw
	jBlTSb3bEG0fLtbDSobshGWC+F2j8hYpzd4RtXOXPJE7ULLFdmx6K3o473ceOfNo2QWZyCrt+Z1xO
	CjxvqU7268XNsHCbqPneh5L5OdeKyRxN09pnRjtmO+CaukMnm3KpD0YMM63s2XmbJUCkYmZyejnDn
	hz7A3CPFd92umW6Zd02y8GU8XEwfn1jaVCe+BafUGYIE+eFYFwpcq6+OfvjLdq31tI0IGZHF4xYgl
	f7Mk2EdWtdCf1P8QPt1FhwBohkGO3N5YukNrVpNPI9J/9oP+IUQDeBuIiXKjL07ma3MmuwIAIMvYt
	IK1N9gWg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1txT7J-000000003xV-1qGw;
	Wed, 26 Mar 2025 16:56:33 +0100
Date: Wed, 26 Mar 2025 16:56:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Dan Winship <danwinship@redhat.com>
Cc: Eric Garver <eric@garver.life>, Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org, fw@strlen.de, pablo@netfilter.org,
	Kevin Fenzi <kevin@scrye.com>,
	Matthias Gerstner <matthias.gerstner@suse.com>, arturo@debian.org
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
Message-ID: <Z-QjsRMmEq90F6Qg@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Dan Winship <danwinship@redhat.com>, Eric Garver <eric@garver.life>,
	Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	fw@strlen.de, pablo@netfilter.org, Kevin Fenzi <kevin@scrye.com>,
	Matthias Gerstner <matthias.gerstner@suse.com>, arturo@debian.org
References: <20250228205935.59659-1-jengelh@inai.de>
 <Z8muJWOYP3y-giAP@egarver-mac>
 <Z9wgoHjQhARxPtqm@orbyte.nwl.cc>
 <831bd90a-4305-489c-9163-827ad0b04e98@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <831bd90a-4305-489c-9163-827ad0b04e98@redhat.com>

On Mon, Mar 24, 2025 at 09:34:26PM -0400, Dan Winship wrote:
> On 3/20/25 10:05, Phil Sutter wrote:
> > IMO we should at least include the builtin 'flush ruleset'
> 
> Boooo!

Hi Dan!

> In kubernetes, kube-proxy's iptables mode polls the iptables rules once
> every 30 seconds to make sure that the admin didn't do "systemctl
> restart iptables" or "firewall-cmd --restart" and COMPLETELY BREAK
> KUBERNETES[1]. The kube-proxy nftables mode *doesn't* currently do this,
> because it assumes nobody would be so rude as to flush the entire nft
> ruleset rather than only deleting and recreating their own table...[2]

The suggested 'flush ruleset' stems from Fedora's nftables.service and
is also present in CentOS Stream and RHEL. So anyone running k8s there
either doesn't use nftables.service (likely, firewalld is default) or
doesn't restart the service. Maybe k8s should "officially" conflict with
nftables and iptables services?

> (If the nftables "owner" flag thwarts "flush ruleset", then that's
> definitely *better*, though that flag is still too new to help very much.)

Yes, "owned" tables may only be manipulated by their owner. Firewalld
will use it as well, for the same reason as k8s.

> Once upon a time, it was reasonable for the system firewall scripts to
> assume that they were the only users of netfilter on the system, but
> that is not the world we live in any more. Sure, *most* Linux users
> aren't running Kubernetes, but many people run hypervisors, or
> docker/podman, or other things that create a handful of dynamic
> iptables/nftables rules, and then expect those rules to not suddenly
> disappear for no apparent reason later.

The question is whether the nftables and iptables services are meant for
the world we live in now. At least with iptables, it is very hard not to
stomp on others' feet when restarting. With nftables, we could cache the
'add table' commands for use later when stopping the service. There is
margin for error though since the added table may well exist already.

> If you're going to have a static nftables ruleset thing, please restrict
> it to a single table, and never ever ever do "flush ruleset".

Cheers, Phil
