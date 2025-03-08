Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8E01B4257
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 17:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741455819; cv=none; b=g5sW2oNqb3bQw7m/fR5ajrmO1BveXstVrksnfnX5saDZOUroox530R3qIcu+UdRq3nvDDntKa8Anr+pTo0Hxo6678H1esIdeJT9rt3Ggpn3APSV7SJjbbrNmfLiPAOBa/oHARJyCXQKQdQMdat1Oy+K4kFvlgIwo7+bcWdMyI3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741455819; c=relaxed/simple;
	bh=J7mSJfw47TY7vLqfQnf9yKsVJ8ucR6c7WCDr1gTp0ao=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cA4EXQHkjRySmm57bPeRa9h3lmHiDSpgkh2QQh3OcXgmDN/Pfq4Zb2o8KGmLLedHiO23IA7nlgMNvkwsqTHoN08OpomgHXBTX5eRE5IJ3j+coqYDJNCgkCX975rsNVcMJy6Q8Z0wCbK30yVhcwMGxvhjPSryjtEDUFQAM2t9dec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=GD2eUBia; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="GD2eUBia"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id B923232E01CC;
	Sat,  8 Mar 2025 18:35:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1741455321; x=1743269722; bh=lrfdI661Mk
	ZLKIO2FQjRPNNT9/efGS3nPVVwssHLmuo=; b=GD2eUBiaIGcKnGFCrze/1dJ7pE
	bC9at+qltcQFjA2jqh1E7zzCpQKISs6Lu49k0x+hXbxS8UqlA+2FLILnmK+RYDOv
	EXUMAUBuwzKiwba6M2BfGBhMbgxRewlIF4UVjJlAHxekyv3bTZ0LTsdPuUr/cUkG
	/PHfYa1843KBG3Vos=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id odfQo7AooD3h; Sat,  8 Mar 2025 18:35:21 +0100 (CET)
Received: from mentat.rmki.kfki.hu (84-236-21-15.pool.digikabel.hu [84.236.21.15])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 8F6DF32E01C3;
	Sat,  8 Mar 2025 18:35:20 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 26EA71418A4; Sat,  8 Mar 2025 18:35:20 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 237DA1405D0;
	Sat,  8 Mar 2025 18:35:20 +0100 (CET)
Date: Sat, 8 Mar 2025 18:35:20 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Guido Trentalancia <guido@trentalancia.com>
cc: Reindl Harald <h.reindl@thelounge.net>, Jan Engelhardt <ej@inai.de>, 
    netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
In-Reply-To: <1741381100.5492.17.camel@trentalancia.com>
Message-ID: <79e26959-fdbd-2aa0-7105-8a9cfd7241aa@blackhole.kfki.hu>
References: <1741354928.22595.4.camel@trentalancia.com>  <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>  <d8ad3f9f-715f-436d-a73b-4b701ae96cc7@thelounge.net>  <1741361507.5380.11.camel@trentalancia.com>  <cc4ecd68-6db9-42e6-b0f0-dd3af26712ec@thelounge.net>
  <76043D4F-8298-4D5C-9E98-4A6A002A9F67@trentalancia.com>  <6290cf9a-faff-4e1a-aac4-f12d4744d8b9@thelounge.net>  <1741379855.5492.10.camel@trentalancia.com>  <b6b57494-76cc-4057-aa9b-e88c1438262c@thelounge.net> <1741381100.5492.17.camel@trentalancia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 0%

Hello Guido,

On Fri, 7 Mar 2025, Guido Trentalancia wrote:

> The support for hostname-based rules (including multiple resolutions of
> an hostname) has been there at least since the following commit:
> 
> commit 2ad8dc895ec28a173c629c695c2e11c41b625b6e
> Date:   Mon Feb 21 19:10:10 2011 -0500
> 
> but probably much earlier, so it's been there for more than 20 years !
> 
> Security (and software in general) should not be viewed in absolutistic
> terms, I believe, which is why software has features and options, it
> depends on different circumstances, if an option is there, the user has
> the choice on whether it needs it or not, on whether is convenient or
> not, on whether is safe or not.
> 
> It's just a very simple patch to improve an existing feature. It's up
> to you whether to merge it or not, I can't add much more to this
> discussion at this point because it's just looping...

Yes, because it seems you assume hostnames are stored in the iptables 
rules when it's not. When the rule is entered, hostnames are resolved 
*once* to IP addresses, and the rules with the IP addresses are 
transferred to the kernel and used there. Simple example:

# iptables -A FORWARD -d smtp.google.com -j ACCEPT

Does it mean it's a single rule in the kernel with the hostname 
smtp.google.com? No, not at all:

# iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             eg-in-f26.1e100.net 
ACCEPT     all  --  anywhere             ef-in-f26.1e100.net 
ACCEPT     all  --  anywhere             ed-in-f27.1e100.net 
ACCEPT     all  --  anywhere             ef-in-f27.1e100.net 
ACCEPT     all  --  anywhere             eg-in-f27.1e100.net 

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination    

At the time when the command was entered smtp.google.com could be resolved 
into five IPv4 addresses and that resulted not a single rule with a 
hostname, but five rules with IP addresses. The "iptables -L" simply 
translates back the IP addresses to the corresponding names in the DNS.

If the name resolution of smtp.google.com *changes* after the rule was 
entered, it has no effect whatsoever.

Hostnames in iptables/nftables rules should be avoided, especially for 
dynamically changed hostnames.

Best regards,
Jozsef

> On Fri, 07/03/2025 at 21.48 +0100, Reindl Harald wrote:
> > 
> > Am 07.03.25 um 21:37 schrieb Guido Trentalancia:
> > > Apart from the case of DNS Round-robin, quite often an hostname
> > > (for
> > > example, a server hostname) is DNS-mapped to a static IP address,
> > > but
> > > over the time (several months or years) that IP address might
> > > change,
> > > even though it's still statically mapped.
> > > 
> > > In that case, if a client behind an iptables packet filter does not
> > > use
> > > hostname-based rules, it won't be able to connect to that server
> > > anymore.
> > > 
> > > So, there are cases where hostname-based rules give an advantage.
> > 
> > sorry, but hostanme based access lists are even on a webserver a bad 
> > idea and on a packet filter it's unacceptable
> > 
> > if a host changes it's IP rules have to be adjusted - it's as simple
> > as 
> > that for the past 20 years in networking and will continue so the
> > next 
> > 20 years
> > 
> > ------------
> > 
> > and frankly if a service partner can't assign a static IP it's the
> > wrong 
> > partner to begin with - we are talking about security
> > 
> > either you have a static ip or there is a vpn-tunnel with
> > certificates 
> > done within seconds with wireguard - the dynamic host is the one to 
> > build up the tunnel, case closed
> 
> 

-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
