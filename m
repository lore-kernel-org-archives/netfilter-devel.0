Received: from smtpcmd02102.aruba.it (smtpcmd02102.aruba.it [62.149.158.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675B97494
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 11:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742556096; cv=none; b=cubeUBtpSxnXG7wi6pn6kvCO2G4OVpueCsCEvs9N/2RPui4ZhQPUfIAcnKW4CSBaG4DRg/2mLUPsF0eMldghDtqBsl9dGP2lujijMIy+scDylOwFyhgvxcOQQ0VxcE6DU9HRFtJGrGDDPM8p4dxXN3Ql0jOjf/xmIsAzkwS9uwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742556096; c=relaxed/simple;
	bh=8i2kAW2lZqKYNgpw2xQeE3m9czCfgdlmlzI1k1TfukQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=grTni61Ac7xdae6HlalWcB2u7tAivljXWJ9pdp45wyY7kTzwAvB90FIo2+/EIWiySjrpHYLg/4sfHy3DL49IKbfZj0ti1vHhsoUEA9kdKIeRvvZPfH1PZxfpKCSe69/J4h+U7PaicMcnrOCkPMgxbbqxoKGKMNgp4H/jWLjSEX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=cgDDzJB3; arc=none smtp.client-ip=62.149.158.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="cgDDzJB3"
Received: from [192.168.43.2] ([109.54.149.107])
	by Aruba SMTP with ESMTPSA
	id vaRLtkroSloievaRMtTQwp; Fri, 21 Mar 2025 12:21:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1742556090; bh=8i2kAW2lZqKYNgpw2xQeE3m9czCfgdlmlzI1k1TfukQ=;
	h=Subject:From:To:Date:Content-Type:Mime-Version;
	b=cgDDzJB31HfM64RvedovACXvtE4XKTQHRTRpOcv6FyGf5Vq1GAka70H9gaNEhXCLP
	 CDirDUgkBsgR7UDiHNFZ1CaEVOyHGgkNfFSitiTwXSZyW4nLuI3Mqj2rro+H424OOi
	 MbmsQpEr9fX8VMU4X55Iv48IEuN6GDiftJ/29DikTMfTWfTJvFG3INtuEaTQ5Kcds2
	 bRx8z6kXu0OiqUlgQHXI8cdU3rmCKvO4qIzAblRrzUiwe2l33hefAOkWuD136S8AmM
	 97zGZfQ+4UT/NDXhir1DqLaJ+RhZyE5i9WofJmM4QWBjjxuXW1hQoWuxBMfDaJn6Ub
	 i479BDieWBfrw==
Message-ID: <1742556087.6585.35.camel@trentalancia.com>
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
From: Guido Trentalancia <guido@trentalancia.com>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Cc: Jan Engelhardt <ej@inai.de>, netfilter-devel@vger.kernel.org
Date: Fri, 21 Mar 2025 12:21:27 +0100
In-Reply-To: <Z9w2vLdyQfWepMET@orbyte.nwl.cc>
References: <1741354928.22595.4.camel@trentalancia.com>
	 <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
	 <1741361076.5380.3.camel@trentalancia.com>
	 <931rns88-4o59-s61q-6400-4prp16prsqs7@vanv.qr>
	 <1741367396.5380.29.camel@trentalancia.com>
	 <s4sq15s8-p28r-7o01-03n8-82623p8n3728@vanv.qr>
	 <1741369231.5380.37.camel@trentalancia.com>
	 <Z9w2vLdyQfWepMET@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfDdO8WQ1Zq39Acj4owGqW5MqCea5SsQLAqkowHnmuBY2VzkvxO6l59YZGfMUDIaRZkU9lBUP+NdueDU1JU+kW85DgzWHUjZVqqVUYuK6jSCSKKrEEUWq
 KsodAvEPJYiu1xR5wUIEKnFiz5UrptyGc2B6pGmt7Gbpfdwx2BwauxkcuDLYT4s7Pv8hdmtw2VuTu1uH8FaU82YNQAM09ZRMTHcLNhv8m7g/zF1jsGqsmdLc
 lf/1MQSmF5Z8i/ObrotJIUxt6BQqssFq5B+B3J77UNeuuaa9YmtBt+wA7o1RjIkt

Hello and thanks for your feedback.

On Thu, 20/03/2025 at 16.39 +0100, Phil Sutter wrote:
> On Fri, Mar 07, 2025 at 06:40:31PM +0100, Guido Trentalancia wrote:
> > I am not familiar with the application layer tools such as
> > NetworkManager.
> > 
> > The point is that the underlying issue does not change with
> > auxiliary
> > tools: I believe iptables should not abort setting up all rules,
> > just
> > because one or more of them fail to resolve in DNS.
> 
> There is consensus amongst Netfilter developers that skipping rules
> or
> even parts of them when loading a ruleset is a critical flaw in the
> software because loaded ruleset behaviour is not deterministic
> anymore.

It's the Internet and DNS connectivity that are inherently not
deterministic. The Internet is a best-effort network or in other words
non-deterministic, so any network filter for the Internet can only be
best-effort.

The patch simply makes the netfilter behaviour adaptive to that
inherent principle and fault-tolerant.

> The usual security context demands that behaviour is exactly as
> requested by the user, any bit flipped could disable the whole
> security
> concept. "We printed a warning" is not an excuse to this.

Priting a warning and recoverying in a best-effort manner from an
unrecoverable failure is the best a network filter can do.

A partial failure is always better than a total failure.

> In order to implement the desired behaviour, just call iptables
> individually for each rule and ignore failures. You could also cache
> IP
> addresses, try a new lookup during firewall service startup and fall
> back to the cached entry if it fails.

The former is just an expensive trick. The latter might be an
alternative solution to the problem, but it is more complex than just
rescheduling netfilter setup after network (or DNS) comes up again.

You need quite a lot of C code in order to cache DNS lookups, while you
only need a script to reload the netfilter.

> My personal take is this: If a DNS reply is not deterministic,
> neither
> is a rule based on it. If it is, one may well hard-code the lookup
> result.

There is no prescription on being deterministic, when the underlying
network is inherently non-deterministic.

It has already been discussed that even when DNS Round-Robin is not
being used for a specific host, the host might still change its IP
address on a slowly-varying timescale: in such scenario hostname-based
filtering rules significantly simplify network management and minimize
network downtimes.

In any case, hostname-based rules are optional and using or not using
them is entirely discretional, the patch does not force the use of
hostname-based rules, it just makes them fault-tolerant.

> > As already said, if one or more rules fail then those specific
> > hosts
> > are most likely unreachable anyway.
> 
> No, it just means DNS has failed. The resulting rules use IP
> addresses
> and there is no guarantee these are not reachable. You are making
> assumptions based on your use-case, but the proposed behaviour will
> affect all use-cases (and there is always that special one ... ;).

If a DNS lookup fails, it can be due to a DNS failure as you said but
also to a completely unreachable DNS server or a completely unreachable
network (no connectivity at all): so circumstances might vary.

In the case of an Internet client such as a workstation, most Internet
connectivity happens through DNS lookups: you generally don't type IP
addresses in your web browser or ftp client.

So, if the DNS lookup fails, no matter what the reason actually is (DNS
failure or network failure), the client request will also most probably
fail, no matter whether its resolved IP address is actually reachable
or not, because the request is most likely based on an hostname.

Static IP addresses are normally only used for connectivity between
servers: in that case, the code in the patch is not used and things
stay as they are.

> Cheers, Phil

I hope this helps...

Cheers, Guido
