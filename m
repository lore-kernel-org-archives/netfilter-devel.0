Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FF5184E
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 01:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761786286; cv=pass; b=aFIvwRRzvBThoOj3x4+/xMJIW4xhm+2pE1D/+WU0vi2aGQuBPc9YwtNOhkQSQRKx5mtMSTbGRxHz7o+kdBzUfhA+h6AwC5uz6+PXUe0oc45HvvglgrtW4qZEiSglpmnYIxx5nyNDZGRbKM1/a+6axL6VG0PtusL6aGONroyYeew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761786286; c=relaxed/simple;
	bh=PaXVR60inXv85d3iPltxiOyN0TZqp4wY/u8rD7lJh1w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tTdOIw2Oi+vvYxZkymaP+PJR9eg1a+W7glSm8PiVzwxlwjwL73Pjmaxcv0yJlqIUisWFcF4NAGpnjCuz+/Lg7Jn8Hfryuvmwau2bU9B8DRx7S/se+jqKfBis9TqlIhYszoXXMBSmG/KZk14OVdcWzr+4hMqeSlksI5hALxAPqfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=j/MZNIzM reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.218.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="j/MZNIzM"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 18DD7821C5C;
	Thu, 30 Oct 2025 01:04:38 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-7.trex.outbound.svc.cluster.local [100.121.221.249])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 42CB8821CA1;
	Thu, 30 Oct 2025 01:04:37 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761786277; a=rsa-sha256;
	cv=none;
	b=fPkb5Pis/GEJ64Gg7pq2iGDOc08Nqn/0Y/Ft+hHbAteTXDLdSYHwHQG6cJxrsxHxKsIfMf
	DJKUy93tBulPjjVs4AOs2ZSt7ibzkL7zya+OSzjHPVSvUhS+fyCxNq5LMsGKc4YmHEZBmI
	I9kHviwO+2jnTwb1sySfripbg5AdLsuVxZM8uvabuevd6iUx9S26il7u0hzBI0+3VUy7xd
	eNzEEjiHbeEu0rI7GI0jRvPlpHWqUIlX2omfyDpf8u05sWBs1txPCZ0oTBuko3NOJbyQOl
	fi7scbyaMnHv8a+8VEoyyTD+NovdD7WkRJWenmVtEjRgJXHBAcheyV3Er/flcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761786277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNy9X6LxYI10lKMxbUEBjabWnU43SbI+sZJ/WEirSag=;
	b=E69u/XjBPTCqFpCLXQ/0pkAuwnsXX5sRTokRUBol4rY0ya1MMlB+maOr5cIdJt5seCbxaj
	bLg1SnPOH67A4/mNWlARq2qD8hSmGHoKE8t7QuC2GjjlQvCKboSdH2we3h3syXSHZD+pYB
	X6pEAb7+R/2SN7DAQtAErhaKbLc8IJ+n0WuC/CmNRyOHSAToeW8PCYgbFNFjbjg3WBpPk9
	npQKyMBRM4IpIRGKYrxPbqIRChfZsSwhMdfRwd35VUBd5a8vDrpFXsGLUv4z6vztH6FFxQ
	wGUyRVA/PjXlToW1Zh2ka3EnYOhgFzMLZ5yZmZhKu4TbJ2n/UGstSFpJ055KVg==
ARC-Authentication-Results: i=1;
	rspamd-768b565cdb-lcjgk;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Lettuce-Quick: 6b99af0e4ab7dfaf_1761786277968_2359111494
X-MC-Loop-Signature: 1761786277968:2050648916
X-MC-Ingress-Time: 1761786277968
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.221.249 (trex/7.1.3);
	Thu, 30 Oct 2025 01:04:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=PNy9X6LxYI10lKMxbUEBjabWnU43SbI+sZJ/WEirSag=; b=j/MZNIzMW4Um
	kgl5c8RIXBJH6KEL80Y2l/V75Tuy3P6hs16iD76OWmqXVn7uokTI+ZUTCtsUM+GXVH+3dMv+gFtXL
	DMdu6wi5Arh+w20H9Hp28qdlQKd352w5Ky9EU6JJ8iZz6F2qtYrvSQKu7pcnxOSBq7BlmABlpVEqz
	ea707/akCcoZ8EjIwVT7gRvL/Oo8D7i+UR6ylOrGn9w2T2woD7CtABLMH+kAF9s0ALdVUVwI3fZ/M
	PwFx0rlUvWOm4C+dP7b3gLamdz8TC846R1vhcQbzXISDkzhMW8oUQ2Lq5H8KL52zLjyQz0mGbXjZU
	bsgW7AcHVKju0ZOUKrEx1Q==;
Received: from [212.104.214.84] (port=5959 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vEH5g-00000002oRn-2flH;
	Thu, 30 Oct 2025 01:04:35 +0000
Message-ID: <80a6e18535c94b60a226c89b9de06070cd154214.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH nft v6 0/3] doc: miscellaneous improvements
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Date: Thu, 30 Oct 2025 02:04:34 +0100
In-Reply-To: <aQH6T6M-r561jvQ7@strlen.de>
References: <20251028145436.29415-1-fw@strlen.de>
	 <0e0112a16c881a1072c3d9dcba4d323b608674b0.camel@christoph.anton.mitterer.name>
	 <aQH6T6M-r561jvQ7@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-5 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: mail@christoph.anton.mitterer.name

On Wed, 2025-10-29 at 12:28 +0100, Florian Westphal wrote:
>=20
> What about this:
> =C2=A0 Thus, if any base chain uses drop as its policy, the same base
> chain (or a
> =C2=A0 regular chain directly or indirectly called by it) must contain at
> least one
> =C2=A0 *accept* rule to avoid all traffic from getting dropped.

Isn't that still effectively the same?

I mean the whole summary chapter explains things from the view of a
single packet, as was also the case for my last version of this
sentence:
> +  Thus, if any base chain uses drop as its policy, the same base chain (=
or any
> +  regular chain directly or indirectly called by it) must accept a packe=
t or it
> +  is ensured to be ultimately dropped by it.

Your wording changes this now to refer to "all traffic", which I think
make an unnecessary specialised case, namely that, where all packets
would be dropped, unless there's at least one accept rule.

The typical firewalling case is however that for most packets (that
might end up on the system) there actually is no single rule that would
accept them and only some of them get accept.

I simply would let the reference frame on a single packet.


> > IMO it doesn't make things easier for a beginner, if one basically
> > has to read through everything to find all information.
>=20
> I added a reference.=C2=A0 Also keep in mind that nftables will already
> tell
> you about terminal statement not at end.
>=20
> nft add rule ip f c drop counter
> Error: Statement after terminal statement has no effect

Sure. I know.

Is it still mentioned somewhere that "comment" is an exception to the
rule?
I think that should be mentioned, because while people could just try
it out, they shouldn't have to... and even then they couldn't be sure
whether that's actually intended or merely a bug.


> > Als, "or a user-defined", ain't the base chains user-defined,
> > too?
>=20
> Thanks, user-defined is iptables-legacy lingo (base chains always
> exist), old habit.

You're welcome :-)



Cheers,
Chris.
