Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBB41BC41
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 13:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743082191; cv=none; b=pZtyW2I+f4PlhP9M1IOn99acwDCPbGiQwBB417onlC9uWoDAusQUJzmhIGTU084Xtxj07u3F6WB8lehT3nwOo7iMneaxZFt5X4Jni7rB7EMbtuhTpXQQ4o88iaeCInouNsDb2/difvK2axq9kfgD/vMoyVT4IBIeCxiYwLp0Hms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743082191; c=relaxed/simple;
	bh=6TGhwDdjM0S+VtTgOxSU9rUZPXPbef7+sdccY0RpqH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B5oc+YyDoyip8WpNfqN4JVKRHMPuuqXMfCY3QlVCzr3jwiY3wmBzz2XHv9tNroHi3dX2HDldYa/R4hIaP5XJAj/hY29ODwhXOvaTyzRjSE+YnT4tcaRymrVyfYV5BPa1hlVZ5qx1kVCMtt5hetHiR/6Q4dhjj2qQaMCAhukOjoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=e0GNBqr4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="e0GNBqr4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RErU8pcc1RxaYZCfVTirrZ1GuTsOdSDhdJ9mUVyHWNc=; b=e0GNBqr4RFxq4ipPD6nkODB5EO
	fLgvBGskctAr7CSDRmYBN5W2l8ZbwGQ/ncXxc0vyf1QB+iQivhYteIcJ4lEhth13EPx2jF50SlztE
	uFd6esLDJP+Jd1uoKlyDYOpiBLajbU6czD1nTwAgGgEqBUHRCQIEqE2dRbEPAvc8wJL6Rwur71Bjk
	W8kfCilxlmXtKPZBNlg1eeZi+E6d7+2M1R5OLkANYJLWvOpNzqdvr+SUwkeKHy6gCK8OebE2Cijb9
	poIvfaZc3a/QX0RSqa4DOgGW+s34eCt7Ucr3GHJ0g8YeB0zI9vOFvdKljAaPcIrqvLdh2StbTDAxH
	LFBUh08A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1txnIm-0000000041z-0QaC;
	Thu, 27 Mar 2025 14:29:44 +0100
Date: Thu, 27 Mar 2025 14:29:44 +0100
From: Phil Sutter <phil@nwl.cc>
To: Dan Winship <danwinship@redhat.com>
Cc: Eric Garver <eric@garver.life>, Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org, fw@strlen.de, pablo@netfilter.org,
	Kevin Fenzi <kevin@scrye.com>,
	Matthias Gerstner <matthias.gerstner@suse.com>, arturo@debian.org
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
Message-ID: <Z-VSyAvlOdRlsoxO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Dan Winship <danwinship@redhat.com>, Eric Garver <eric@garver.life>,
	Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	fw@strlen.de, pablo@netfilter.org, Kevin Fenzi <kevin@scrye.com>,
	Matthias Gerstner <matthias.gerstner@suse.com>, arturo@debian.org
References: <20250228205935.59659-1-jengelh@inai.de>
 <Z8muJWOYP3y-giAP@egarver-mac>
 <Z9wgoHjQhARxPtqm@orbyte.nwl.cc>
 <831bd90a-4305-489c-9163-827ad0b04e98@redhat.com>
 <Z-QjsRMmEq90F6Qg@orbyte.nwl.cc>
 <4cf4948f-e330-45e9-98b9-bbef7e2007be@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cf4948f-e330-45e9-98b9-bbef7e2007be@redhat.com>

On Thu, Mar 27, 2025 at 07:12:29AM -0400, Dan Winship wrote:
> On 3/26/25 11:56, Phil Sutter wrote:
> > The suggested 'flush ruleset' stems from Fedora's nftables.service and
> > is also present in CentOS Stream and RHEL. So anyone running k8s there
> > either doesn't use nftables.service (likely, firewalld is default) or
> > doesn't restart the service. Maybe k8s should "officially" conflict with
> > nftables and iptables services?
> 
> (It's weird that nftables.service is part of the nftables package, when
> with iptables it was in a separate package, iptables-services? But
> that's not a discussion for this mailing list...)
> 
> >> (If the nftables "owner" flag thwarts "flush ruleset", then that's
> >> definitely *better*, though that flag is still too new to help very much.)
> > 
> > Yes, "owned" tables may only be manipulated by their owner. Firewalld
> > will use it as well, for the same reason as k8s.
> 
> So in the long run, this solves my problem, even if static firewalls are
> using "flush ruleset".
> 
> >> Once upon a time, it was reasonable for the system firewall scripts to
> >> assume that they were the only users of netfilter on the system, but
> >> that is not the world we live in any more. Sure, *most* Linux users
> >> aren't running Kubernetes, but many people run hypervisors, or
> >> docker/podman, or other things that create a handful of dynamic
> >> iptables/nftables rules, and then expect those rules to not suddenly
> >> disappear for no apparent reason later.
> > 
> > The question is whether the nftables and iptables services are meant for
> > the world we live in now.
> 
> If they're not, then distros shouldn't install them by default. Having
> them installed on the system (or provided as an example in the nftables
> sources) suggests to admins that it's reasonable to use them. (And
> having nftables.service use "flush ruleset" suggests to admins that
> that's a reasonable command for them to run when they are building their
> own things based on our examples.)

We're drifting into downstream details here, but I agree that we should
have nftables-service(s) RPM which is not installed by default.

> > At least with iptables, it is very hard not to
> > stomp on others' feet when restarting.
> 
> Sure, there's nothing that can be done to improve the situation with
> iptables. It just doesn't have the features needed to support multiple
> users well. But nftables does. That's the whole point of multiple tables
> isn't it?

Probably, yes. Tables only separate name spaces, though. The actual
merge points are the netfilter hooks and tables don't matter there. The
problem of rule ordering in a builtin iptables chain has become a
problem of base chain ordering in a hook. Eventually rules are
serialized and since one can't undo an earlier drop/reject, there's
still room for conflicts. Real concurrent use therefore requires a
mediating agent like firewalld and a more abstract language than "accept
this, drop that".

> > With nftables, we could cache the
> > 'add table' commands for use later when stopping the service. There is
> > margin for error though since the added table may well exist already.
> 
> I was thinking more like, the service documents that all of your rules
> have to be in the table 'firewall', and while it may not actually
> *prevent* you from setting up rules in other tables, it doesn't make any
> effort to make that work either:
> 
> ExecStart=/sbin/nft 'destroy table firewall; add table firewall; include
> "/etc/sysconfig/nftables.conf";'
> ExecReload=/sbin/nft 'destroy table firewall; add table firewall;
> include "/etc/sysconfig/nftables.conf";'
> ExecStop=/sbin/nft destroy table firewall

Since tables are bound to an IP version (or "inet"), a single table may
or may not suffice for users. Apart from that, one may even do:

| ExecStart=nft 'add table firewall { include "/etc/sysconfig/nftables.conf"; }'

One can't dump the current ruleset into that file anymore, though.

Anyway, I think we're playing hide'n'seek here: Even if nftables service
sticks to a given (set of) table(s), base chains may easily break k8s.
Marking the two as conflicting with systemd is a better choice IMO.

Cheers, Phil
