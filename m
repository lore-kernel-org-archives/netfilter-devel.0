Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ED033C51B;
	Mon, 12 Jan 2026 09:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768209821; cv=none; b=gOQYXuPsXEzORh6rTei+qcv0KfuX4VC69apAjO03BAbstR9z1uXI2C/2ndE4WdVSRQodj9nHeMqQ/M+lfORadUUUrd5HeDjodD2UilRjBARQ1/i/uBX0AOL9WiBpcKaRSvl2QXpyqWB/NE72zXmMFxTS0i7LPizrKYy55pdZljY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768209821; c=relaxed/simple;
	bh=UDF25lfYu2q7ad5OaqwLD7z5ozQ5qut8XIB0wx6p8Cc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=fM2nfK98nIcx31Q6spjWh+1SyNvyVnUDBNlLKM0ZCRAlfcskt4UmpH9SMBb6HkoREXm9dyR9SC+IR9LXvJONVDfen7udcvxISQcGbk8M8Ajwg9hvN8SjcoOiyGxqtH3WKAlTmslWitkp2Cc9INgQcls8LMMmc/bbSlQJAqf7NZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=uoAud1wP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OLZm1lJC; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="uoAud1wP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OLZm1lJC"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 01C8814000A2;
	Mon, 12 Jan 2026 04:23:39 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 12 Jan 2026 04:23:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1768209818;
	 x=1768296218; bh=lzWxlvrKpcrXEIRzWq8neU3zC0hTlV62S50r4rTDl7A=; b=
	uoAud1wPNw1fKoCA+iCd2GpHOtK+nZgILvqLrU8vY0EmszjIXJX0/5bbSi0mgo3A
	YlVqo3ny3DtpN9IkxMv1rEAehNRWGn5cOEHZ9h8gMVCeIX81NKpUqLoGrcwoOv/c
	DtR15tpjwvGZYZ7derWxiUThPhqdSVj63u3lMQR47jhIIye7eTgCea333aaPoicE
	tQtODbBdLBORClGt9CO7KIaa3gkF2rKonyuVnE5g69tr/lmYNL5UGTN0oTPP6cbF
	a3cAfDcaaNe0Asc67kiNAFkOL5NxMZ9uzqh5EwutmRsLyBU740c8fPEjDJItJrRd
	qE9XcNXdsmoRxd6Wq/UHBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768209818; x=
	1768296218; bh=lzWxlvrKpcrXEIRzWq8neU3zC0hTlV62S50r4rTDl7A=; b=O
	LZm1lJCbwlv1/Uw9qcywRt1288n+m5CdCTqlVLo9MCvk2EBmw01AA9w7od7YpckU
	of8S62HijVYI+3780K7pGmv8BmvLasrYi7GmIE95Wy9EjhEpDEimfui/LMyajOl7
	KzECuczdP2x3M0NAWdV66ABXfnZrEq5NSfG1Wd4kGBCEPg89hLmBtS8b4KYEqtQy
	XDNEu5rFEXjaJgAURjgD9qKbQyM7s0vykazKgkdnQfDOb1fvmU0y6neo4nJmUp1x
	fPjNJ4bTW8SfHZokFJMAoiGddFx2IgqaDvATOlOKis6xQwHsQsmUcdnXvj6gMQsG
	hCcBbx7qtUmMVNYQfqCUA==
X-ME-Sender: <xms:mr1kaUPNVuxKVEWpGn3MGtqAPbkVzSEsb0bhIwym_-fcflFf7SlJNA>
    <xme:mr1kaVxrssznn0ktqV5l8WYQApJR06mR-eAgqt3zZJ7RiEdMd6WlROUQhoMvSPnU0
    fjJlSQUUREYZcr_xYSsP-8WJdpFKL7ayS-98TTlFXWVziwsPynWpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduudejtdekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepvdfhvdekueduveffffetgfdvveefvdelhedvvdegjedvfeehtdeggeevheefleej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudehpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtoh
    epvgguuhhmrgiivghtsehgohhoghhlvgdrtghomhdprhgtphhtthhopehhohhrmhhssehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkuhgsrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtohepthhhohhmrghsrdifvghishhsshgthhhuhheslhhinhhuthhrohhnihigrdgu
    vgdprhgtphhtthhopegrnhgurhgvfieslhhunhhnrdgthhdprhgtphhtthhopegtohhrvg
    htvggrmhesnhgvthhfihhlthgvrhdrohhrghdprhgtphhtthhopehkrggulhgvtgesnhgv
    thhfihhlthgvrhdrohhrghdprhgtphhtthhopehprggslhhosehnvghtfhhilhhtvghrrd
    horhhg
X-ME-Proxy: <xmx:mr1kaZzJrTJHc79Cm6tZL_j6WVMV3y1XxKHQPT1LOiE1nTAQefAg9A>
    <xmx:mr1kaZtymw50frqsfty9G1mv6g3JDx_nc0qrdcVLXx7_v1zPgcpyRw>
    <xmx:mr1kaTF-7lIAdn5cWYE-yLEJSMfj2a_APZV7lzafp-ASyiCFqTZbkw>
    <xmx:mr1kaX6Qqb5MuMs_preQ2e_korGZWo1WLUB8hDaixTu1t_oSoxu_Qg>
    <xmx:mr1kaWhvF0zHso7pEhn9tUEEmVarYffKWqLOIwwxN9tvYNC5T5BzH_q2>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id F2EAA700069; Mon, 12 Jan 2026 04:23:37 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AZiuWalixslg
Date: Mon, 12 Jan 2026 10:23:07 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 "Andrew Lunn" <andrew@lunn.ch>, "Pablo Neira Ayuso" <pablo@netfilter.org>,
 "Jozsef Kadlecsik" <kadlec@netfilter.org>, "Florian Westphal" <fw@strlen.de>,
 "Phil Sutter" <phil@nwl.cc>, linux-kernel@vger.kernel.org,
 Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Message-Id: <22075614-c2b6-447d-8cf8-fff547d98ecc@app.fastmail.com>
In-Reply-To: 
 <20260112090140-8b5fb693-989f-4af6-b65c-9c24a12d8779@linutronix.de>
References: <20260105-uapi-limits-v1-0-023bc7a13037@linutronix.de>
 <20260105-uapi-limits-v1-3-023bc7a13037@linutronix.de>
 <d3554d2d-1344-45f3-a976-188d45415419@app.fastmail.com>
 <20260109111310-4b387d2e-1459-4701-9e58-dc02ad74c499@linutronix.de>
 <20260112090140-8b5fb693-989f-4af6-b65c-9c24a12d8779@linutronix.de>
Subject: Re: [PATCH RFC net-next 3/3] netfilter: uapi: Use UAPI definition of INT_MAX
 and INT_MIN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026, at 09:06, Thomas Wei=C3=9Fschuh wrote:
> On Fri, Jan 09, 2026 at 11:20:22AM +0100, Thomas Wei=C3=9Fschuh wrote:
>> On Mon, Jan 05, 2026 at 02:02:17PM +0100, Arnd Bergmann wrote:
>> >=20
>> > - put the __KERNEL_INT_MIN into a different header -- either a new =
one
>> >   or maybe uapi/linux/types.h
>>=20
>> > - use the compiler's built-in __INT_MIN__ instead of INT_MIN in
>> >   UAPI headers.
>>=20
>> If we can rely on compiler built-ins I would prefer this option.
>
> It turns out that the compiler only provides __INT_MAX__, not __INT_MI=
N__.
> We can derive INT_MIN from INT_MAX as done in the original commit, but
> open-coding it is ugly as heck. So we are back to a definition in a he=
ader
> file again.

Indeed, even gcc's own limits.h does the derivation of each
signed type's limits like

#undef INT_MIN
#define INT_MIN (-INT_MAX - 1)
#undef INT_MAX
#define INT_MAX __INT_MAX__

so it's clearly safe, but open-coding is not very clear.

> What about putting them in uapi/linux/types.h or adding a new
> uapi/linux/typelimits.h?

Those both seem fine to me. Or possibly a netfilter-specific
macro in uapi/linux/netfilter.h, as all three headers that
actually need INT_MIN are all netfilter specific and include
that header already.

      Arnd
