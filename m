Received: from cornsilk.maple.relay.mailchannels.net (cornsilk.maple.relay.mailchannels.net [23.83.214.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF22A2D593E
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 00:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.214.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761699324; cv=pass; b=USF5W0twRpisB/XkAqLcTG9LXlQ9S4XHzpGFStqpSMe38OfPNmKTnrNe3rVzYX+/Vh/j59WP0RvPfesRgKzb686mTVoiTkxIr1PSZJw+u8BXOjmfaG4ewFa+q+Bl3P8NfoJGlY+RlK6ZnDFwDZD7Fu4xHeOnMhiBQSVesnqqh4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761699324; c=relaxed/simple;
	bh=f/H/QWbq7jftmlwuwXTIB9BZuLH8FLgrT6xFom2qzMQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sUKjkV98tTUSqFWavs9n49oHRnenFaM8rPf7lpbarPdE56sjCnyq+xHcBhKFIf60lpyc5z9o2fSTWjRyYJNoqoKpxoc7r9QYl9lO2hdHz78ApbVu36fQGiV2BH40Y9zohB8euCvr9bTkg4VXMmlzAInyAUT7htxsiXodjDMc/oA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.214.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id E2A89120D8C;
	Wed, 29 Oct 2025 00:55:20 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-118-36-217.trex-nlb.outbound.svc.cluster.local [100.118.36.217])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 14FA51210EC;
	Wed, 29 Oct 2025 00:55:19 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761699320; a=rsa-sha256;
	cv=none;
	b=gvBnnyfW2iJM+wFCA3GRwhF+cNTCSVmYWXM30PIyDZ/obyCM8kUyYxtTlsTCGRQemzYLv3
	/IRLnr7lZVclLx41Mni6FV9ySi/oeR3K0k60GPZTybNf6+bF2048ZLTpbfxdKszbI3ThZH
	yLWktNjNpEGcmG+62ZlzZOvM4LYHlHC00r2SGqnNxGrMY2Nubzn1/1l3271RIvVtpVm5iX
	GUnOsAAC+Z6F5fA0pHoXYFkOhNlN13OYtrn8hbxTF5Qer8jLBl5bBwfquWv6pjDTrBj7ns
	Prc8TVYHCYT9Pj1hRKqwU3zb43Vt4RxGv0pVDj9DeX7X7AZEjQcAUFjyxTL5Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761699320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f/H/QWbq7jftmlwuwXTIB9BZuLH8FLgrT6xFom2qzMQ=;
	b=nEZ4xFr1mEF/bbZzUK7izVo4irWf4LcRxl7/vC7CxiftiQY+InEg7imsyF/6M70KbgZdVt
	ZYVCcwKAfxFfv6Z6b6Q72W3PdFCJqsB0KvjAIzQJnFZlIowsrIpoTpqIxJSnWZv2nsbAzh
	878/xSSqdD7M550ISuVApaA05N5VeMftXk1Tnjtihvx485pal+EPVYPlpCmenz8T9ua0YQ
	Rtk8rrHbNmR6hj2xBqx58CvYTgL+E1spwA9amj3+iC7RBz/W9h6rCfJ4dFlFvSqfpIB19M
	88qPmhis0OMFSRNYrv5SXTa8fXOwQqhr8VszM8yu1n1bZclztcO6qBBkraRoYg==
ARC-Authentication-Results: i=1;
	rspamd-768b565cdb-sfz8m;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Abortive-Whispering: 2da1f0ed1dd6f90d_1761699320768_1526398407
X-MC-Loop-Signature: 1761699320768:836518248
X-MC-Ingress-Time: 1761699320767
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.118.36.217 (trex/7.1.3);
	Wed, 29 Oct 2025 00:55:20 +0000
Received: from [212.104.214.84] (port=18843 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vDuT8-0000000DNeS-1BLz;
	Wed, 29 Oct 2025 00:55:18 +0000
Message-ID: <7c3760d6afad70f7579311022748363f7d5f5c77.camel@scientia.org>
Subject: Re: nftables.service hardening ideas
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Date: Wed, 29 Oct 2025 01:55:16 +0100
In-Reply-To: <aQDuvGsDwlaiK94D@strlen.de>
References: <71e8f96ac2cd1ee0ab8676facb04b40870a095a1.camel@scientia.org>
	 <aQDuvGsDwlaiK94D@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-5 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

Hey.

On Tue, 2025-10-28 at 17:26 +0100, Florian Westphal wrote:
> Christoph Anton Mitterer <calestyo@scientia.org> wrote:
> > This would be ideas about further hardening nftables.service,
> > primarily
> > using the options from systemd.exec(5).
>=20
> Whats the point?=C2=A0 nft will exit anyway.

Uhm... well the point of any sandboxing is always (at least trying to)
prevent any attacks.

Sure, nftables is probably not the most likely program to be abused (in
particular as it usually won't process untrusted input), but still even
nftables can't be 100% sure to never be abused in something like
secretly included malware or so.

As with the first patchset my idea was simply that *if* a .service file
is shared it could as well be proper and use as many sandboxing options
from systemd as possible, serving as and example for e.g. downstream
versions of such .service.


> > I guess nft -f should never write anywhere, or does it? At least it
> > seems to work.
>=20
> nft -f should not write anything.

Wasn't 100% sure whether it might e.g. write to some locations like
/proc/sys/net in special situations.


> > 5. There should be no reason why nft -f needs to access stuff in
> > /tmp
> > or /var/tmp of anything else, so:
> > > PrivateTmp=3Dyes
>=20
> Makes no sense to me.=C2=A0 nft -f won't write anything.

The idea of PrivateTmp=3Dyes (in addition to ProtectSystem=3Dstrict) was
rather to prevent that nftables would be able to read anyone else's
files in /tmp (and /var/tmp), again for sandboxing reasons.



> Exotic? More like estoteric, this is bad.=C2=A0 Service file should be
> small and not rely
> on obscure and maybe not well-tested systemd code paths.

Uhm... do you have any reason to believe that the options below were
less tested? It seems at least some of them are used by system's own
units, so these are probably used on basically every system, and most
of what systemd does there is, AFAIU, merely using stuff the kernel
provides via namespaces.
Also *if* something would actually fail, then nft would probably just
terminate with some error or via some signal and it would be quickly
spotted.


Anyway, as said, none of this needs to be done at all... I merely did
the work to went through all these options and which could be used with
nft -f, so that other could perhaps benefit from that, too.


Cheers,
Chris.
