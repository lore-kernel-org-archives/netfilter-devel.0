Received: from slateblue.cherry.relay.mailchannels.net (slateblue.cherry.relay.mailchannels.net [23.83.223.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDBA28466F
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 00:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761697690; cv=pass; b=pS5cvDMZVZd81GFHhUk4Z+wbwHGNhXIl5u4tvngsGzBi5W2iMjyhOh6tUb6cQ16h2uTIb6lJPe92ZEWqyxg0YTarIPQWfEkMrxxNz3a91oZdJd1aG83QEEzaJoVamoUFReI/9ctylBX3oq0aBl9D5mL1hIyvhuoAtnfsglMBz9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761697690; c=relaxed/simple;
	bh=e+x74ZBnRJLQhJBOktqS9+QflNVNV2ePi1/6YN+UVv4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s6NacZQgIuNwJw8pzYY6BvOaZFKzSm4pzWY0gW8sWyfuf0C34t00NklUQNQW1LZq8e3QTFO8XGD0NqpAT5/gGZvyphsS2/QnLfB1r4t9IsZ/FqH6liD7PnTj7K+Pf17dYvOxPeTArZd1HuVMAxpbQEuMW5Qd1qhutTD6FJg2yCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=vV25EJDV reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.223.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="vV25EJDV"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 0EF49581064;
	Wed, 29 Oct 2025 00:28:02 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-7.trex.outbound.svc.cluster.local [100.124.54.161])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 0F6C45814E3;
	Wed, 29 Oct 2025 00:28:00 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761697681; a=rsa-sha256;
	cv=none;
	b=nxTc07FrNl8/vDpG+BBqpKUHrQEHLJVhsSWJvd2UlqefuR2Lj44cAzGodHAOF19+NZwsO8
	nGjuylQ+Se0N92kcn1xqmftHJnjLnPe3SOHW40XIw7KE2QWuVICdmC6GPlrLqbEO7M2Qhk
	DJdn934mc+7bsiEcTXBnnYGEDayK67PtSPccddS3q9zYj4xOF3G8XNcZhNRswHZNqFRjgE
	XADOphorRsW7o3M4Ou6EWa1hJvkMPpTcpQ/ajL/zCDZpi+yIuypfQmFK7m+qFyx+UMlVPa
	y7GQjigxPSPl7z2gQgc84lI31sl7+583aQQLVfDM7pzdXhGpQIKscSknCKE94w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761697681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+x74ZBnRJLQhJBOktqS9+QflNVNV2ePi1/6YN+UVv4=;
	b=bdJZYTAMHBkhI6xxtJMmT8dGs4t8FHbNHOC8Z2YTyVeFeCCM4YbevsHS1eahKRBdc7fiKw
	WRiT8/EqrYdC9vH3VmRQcQRhR8SidTCq5O3JHQkyeLMcUbX2bmAwT78UTgNUrn2ntrQBCS
	UWNcB0tBAwlx2Ad6W3XiAt7WhErdgSj1uWqhSK2CEvfNfBpfIc2rsEvoN5S+nQoG6MUpOl
	3PI+JHFZAVg75ZgVFwqb062afRYMq7Xu8jAxZyo//oE5AaBzjvrs+H7+Fm8i2M8re+d4T/
	REvKKURmKmbtaC/gi1GB93NnHXdMqYSg68MTEuHHEsqE/X1SSQYgDa9Mk1osPA==
ARC-Authentication-Results: i=1;
	rspamd-77bb85d8d5-ccpr4;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Whimsical-Cellar: 7a6ac2ab53bb6d4f_1761697681905_394741268
X-MC-Loop-Signature: 1761697681905:1070742260
X-MC-Ingress-Time: 1761697681905
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.124.54.161 (trex/7.1.3);
	Wed, 29 Oct 2025 00:28:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=e+x74ZBnRJLQhJBOktqS9+QflNVNV2ePi1/6YN+UVv4=; b=vV25EJDVhRrr
	dPp+9xt1hcSN5mnTXif5L7WJ0NmOcGTiUi4JOm/bWJkFx88m0jd0sgiQ6u7uwOlxWbcjJ/w22Iia8
	Ub7VuLJ8KiXctF0Jtuuu/EvdyK2YvA4ICpX1IcliPHqc3GUN2sufYpk96fdnfL6PGZNnP/ZUVrPnY
	XpSLvdmT2bOZ0kk3Mmec8qJm3xkAx6KRi51HO1ezvyyGCH9op3PeqmYGCYrm9k/zoMANSNTSJ5jgd
	T6Ps2fu5sFD7JgVO20ssqMVP069KdGvaQzBmwUo7Y/A5yD2mGVE1UvWqkGQSYLb/WW/qTvoFI/Fpc
	ziUbjUOidzrTcbKPIohGmg==;
Received: from [212.104.214.84] (port=44951 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vDu2h-0000000DIOC-0trU;
	Wed, 29 Oct 2025 00:27:59 +0000
Message-ID: <b66cb7d6e998dcb76cee90694d4632c6d7122153.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH 0/8] improve systemd service
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, jengelh@inai.de
Date: Wed, 29 Oct 2025 01:27:57 +0100
In-Reply-To: <aQDwcsK0RKsrtVop@strlen.de>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
	 <aQDwcsK0RKsrtVop@strlen.de>
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

On Tue, 2025-10-28 at 17:33 +0100, Florian Westphal wrote:
> > This is a first series of patches that tries to improve the
> > included
> > `nftables.service`.
>=20
> Sir, this is netfilter-devel and not nftables-systemd-devel@.

Uhm? nftables ships the .service file, none of this was about systemd
development itself, there doesn't seem to be a dedicated list for
nftables and no one complained about me posting nftables manpage
patches on netfilter-devel.


> I have no horse in this race but I don't want to have too many
> changes
> to this thing.
>=20
> I see Jans original service file) as convinience / ease-of-use
> contribution
> not as something that should be maintained continuously.

Hope that I don't negatively affect anyone's use case for this, but if
the file isn't meant to be maintained, shouldn't it then rather be
dropped?
That would kinda encourage downstreams to think themselves what proper
firewall service file should do any whether any hardening or error-
prone behaviour is desired or not.



> Its waaaay to many tiny patches.=C2=A0 The first 4 patches could easily b=
e
> squashed into one without making it hard to review.

Merely did this out of courtesy so that you could easier pick what you
want to have and what not... squashing them is always a matter of
minutes.


I'm absolutely fine if none of these patches gets merged, I merely
based them on the unit file I'm using for my cluster here.

Incidentally, I'd have considered the one that doesn't cause a short
flush on restart the most important one, so not sure if the others
alone make that big change...


Cheers,
Chris.
