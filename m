Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6A2275B1D;
	Mon, 18 Aug 2025 10:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755514622; cv=none; b=n+xCBsewRiDIRqT06iaaioF962iiKyQWIHEUnVWxcAsY7Bg01706NN/ZsoAMWB2q6Ngpf2GpJ4wVhyLVTzLVANWiKFjFnMa/SyPxKF2FMjQU1a9bR8ZH/XS4b2sWF6p8ROsqEYvRH4A3gB1cUqjcZb+KKHr+WFXA1kaAN4OCL+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755514622; c=relaxed/simple;
	bh=2w+EuXC/u8IFg9jA7o7kqWSy53CjQy5oq5noneEIrJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJ2RMXKKhtHvIkyaF5pmPkYKyOIYsxguuJDwu3iqgHUJnQTvHSDYXmKpkCSM/Ts87fE+tAyOO1cxeZThIX4XkN0C7JIQrIKHF8K+M3hPHdN0lPKHuCFwVKYnqggzdCu5E5uARoHuI3ylfFDNe3F8tPHrqEFsn//JvxgrQPH4BvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=M9dAqPvr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="M9dAqPvr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=h9WHAFB/RGgGKVIByINwvuyekvUFaG5ctKYRf81tJDo=; b=M9dAqPvr3u2gj5uo/AYom+dfop
	FhVtQVRbBUJ2D7+d3fuvtZV1aAhSH3rcuYx+pkF8Fs5uVxKg/C+iIwRnla/lATfqtYJg/s0N2lVud
	S9IBWtok30UYLJ53v6rHb0ZDSDUf0/as7ja/+2ueNzmDSNz+9gfqFOegPfz+0Cxz4MLfh7oxHi+7c
	wX77fA8hQEZKr3o4J/K7J9OsGwpD9W89l/3KshUwZOiGPnZTt+42wYm7YxIG975rhky18FJkMj8Ol
	7X1c5rYWNMWG5M38x03qgeUmezhVZInaTujPobu5Hb8xeegsvl9Pyx2H0IoXaZWekvqAYIqzoeUsz
	gMKuII5w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1unxXs-000000003R7-1iFi;
	Mon, 18 Aug 2025 12:56:56 +0200
Date: Mon, 18 Aug 2025 12:56:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-modules@vger.kernel.org, Yi Chen <yiche@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: modprobe returns 0 upon -EEXIST from insmod
Message-ID: <aKMG-LqLs3yaBDiJ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-modules@vger.kernel.org, Yi Chen <yiche@redhat.com>,
	netdev@vger.kernel.org
References: <aKEVQhJpRdiZSliu@orbyte.nwl.cc>
 <8a87656d-577a-4d0a-85b1-5fd17d0346fe@csgroup.eu>
 <aKLzsAX14ybEjHfJ@orbyte.nwl.cc>
 <edfed2af-8b4d-4afb-b999-5c46b7d46fba@csgroup.eu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <edfed2af-8b4d-4afb-b999-5c46b7d46fba@csgroup.eu>

On Mon, Aug 18, 2025 at 12:07:18PM +0200, Christophe Leroy wrote:
> [+ Netfilter lists]
> 
> Hi Phil
> 
> Le 18/08/2025 à 11:34, Phil Sutter a écrit :
> > [Vous ne recevez pas souvent de courriers de phil@nwl.cc. Découvrez pourquoi ceci est important à https://aka.ms/LearnAboutSenderIdentification ]
> > 
> > Hi Christophe,
> > 
> > On Sun, Aug 17, 2025 at 05:54:27PM +0200, Christophe Leroy wrote:
> >> Le 17/08/2025 à 01:33, Phil Sutter a écrit :
> >>> [Vous ne recevez pas souvent de courriers de phil@nwl.cc. D?couvrez pourquoi ceci est important ? https://aka.ms/LearnAboutSenderIdentification ]
> >>>
> >>> Hi,
> >>>
> >>> I admittedly didn't fully analyze the cause, but on my system a call to:
> >>>
> >>> # insmod /lib/module/$(uname -r)/kernel/net/netfilter/nf_conntrack_ftp.ko
> >>>
> >>> fails with -EEXIST (due to a previous call to 'nfct add helper ftp inet
> >>> tcp'). A call to:
> >>>
> >>> # modprobe nf_conntrack_ftp
> >>>
> >>> though returns 0 even though module loading fails. Is there a bug in
> >>> modprobe error status handling?
> >>>
> >>
> >> Read the man page : https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flinux.die.net%2Fman%2F8%2Fmodprobe&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C34b49eb3d0544fc683e608ddde3a75b2%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638911064858807750%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=%2F70LV37Zb%2FNeiBV59y9rvkLGh0xsqga08Nl3c5%2BVU5I%3D&reserved=0
> >>
> >> In the man page I see:
> >>
> >>              Normally, modprobe will succeed (and do nothing) if told to
> >> insert a module which is already present or to remove a module which
> >> isn't present.
> > 
> > This is not a case of already inserted module, it is not loaded before
> > the call to modprobe. It is the module_init callback
> > nf_conntrack_ftp_init() which returns -EEXIST it received from
> > nf_conntrack_helpers_register().
> > 
> > Can't user space distinguish the two causes of -EEXIST? Or in other
> > words, is use of -EEXIST in module_init callbacks problematic?
> 
> So if I understand correctly the load fails because it is in conflict 
> with another module ?

Yes, it tries to signal that there is already a conntrack helper for
FTP. It is a stub redirecting to an implementation in user space, but
that's just details.

> Then I think the error returned by nf_conntrack_helpers_register() 
> shouldn't be EEXIST but probably EBUSY.

Sounds good! We could at least adjust the module_init callback return
code from EEXIST to EBUSY so the change has minimal impact.

Thanks for your help, Christophe!

Cheers, Phil
