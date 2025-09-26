Received: from fennec.yew.relay.mailchannels.net (fennec.yew.relay.mailchannels.net [23.83.220.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C64F72633
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 04:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.220.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758862569; cv=pass; b=QA8GXhV610dpwnaO2mQmb87CTMiQ7DSmBqtiQsUCKVrmb6v+D4sYvZGq4w4efA/8/uud46JUWbeZ7Ukydzjku6xS+icw0H22pj0ZGhn2UwxsbGi8VIv9nfVq82GSTIVi2y+Jz2b8LxWAHHjR6Mqg4svRZgw7ATaPw71eY+uS/o8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758862569; c=relaxed/simple;
	bh=9kHj4UN25ipJ+Gaa+jiIPyY/O/A8L4ygilwY/V00p28=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZJFTq5Mkocl5786E7XiacoHtCAyJ9NM3e1Rfrb1P03lZxPEs5wJhjm35EDNcU85EsDoqp/+dAp+hPGCiU0fLxkisf7q1WNECtzLJHTauaq5LEFpqqkNoGvOkiaE5uvRR1Gkr5NHDrOwOFjtZM1xr9ZnZBVUvL8tsbR+0f+oj1p8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.220.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 2D8AA8E1791;
	Fri, 26 Sep 2025 02:33:00 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-blue-7.trex.outbound.svc.cluster.local [100.108.36.204])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 63CCA8E1033;
	Fri, 26 Sep 2025 02:32:59 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758853979; a=rsa-sha256;
	cv=none;
	b=h1oG0OSXKB9SxxHsF2ttXtQXtJjBF3ZE2wJ2Fp85RauAB5XSeO1DYdC5lIEisTy4mReWqx
	FssPsrLv3JCpR65q31Rel5QHprz0X+tP/vN6Yb+SMz0jB7CN77BeAca7e/yGlr4QGlWrbF
	4MKgHR20/N095rPP04lXTLD+D3w8+XGfEP257fZsE0dgW1SGRihO1l+0XAqufB7TpPU912
	oD77P6ywLSXHyvp6U3FIQR6Vg4ySKcXSi9raoBrcuIODCH/FoLk+X2BM9+3wpK4bxW88Fp
	H5lRLBogbJVJJSdMv+29Yr5EmRhYQYfehJvYtwU+NGAwh4IOydCfYvAtTERVEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758853979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BbRGAQgu5+27oh7G+kT+Ec18QWnkix6SmNuTryaSZog=;
	b=yTYGArhHY43THf8MXXjG8Nz/j0MR8B1CDvbg0YLa1J5pjTGjD7n/K+3Bk9LB+5dPT8sjEz
	xD0TFJ1WZtHnUtptp7EMXvuhDPhvzh3Zjp7JiQ02kLhP2TyqBjeh5EHxc1rDzKeDCtLVA3
	J6Q9Z7zWf9n7m+EMT4f23Nkghl+1YHz772VbKWcMa0frLNuL1/SwOcgKGdfcqjL/PMUecT
	vKvPDnHIY41l+M16qDvUum+Qgb4f7QE2HZpUakD2ST6LQ9Bv1dQ+sdK3S9jyBxY/eal3Ap
	IUFZlBz8zYyi86Iw9bRShj93TCAhrHu+FuHxGbPGBuEDNIFmnhCJkXfxSZggQQ==
ARC-Authentication-Results: i=1;
	rspamd-65bb85d4cc-s4sfp;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Good
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Arithmetic-Juvenile: 697128d527e17045_1758853980058_88132310
X-MC-Loop-Signature: 1758853980058:3085115631
X-MC-Ingress-Time: 1758853980058
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.108.36.204 (trex/7.1.3);
	Fri, 26 Sep 2025 02:33:00 +0000
Received: from [79.127.207.161] (port=11982 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1yGZ-0000000CiLC-3v2w;
	Fri, 26 Sep 2025 02:32:57 +0000
Message-ID: <abde5a37f69df72e127e0c8dba8d066953ba4fcf.camel@scientia.org>
Subject: Re: nft manpage/wiki issues and improvement ideas
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Date: Fri, 26 Sep 2025 04:32:56 +0200
In-Reply-To: <aNTwsMd8wSe4aKmz@calendula>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
	 <aNTwsMd8wSe4aKmz@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-3 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

Hey.

There's one more... observation (bug?):

What I've been trying to do was, come up with a base rule file (which
basically allows nothing inbound except established,related and some
limited ICMP but everything output).

Like so (but other than the include in output it's not really
interesting):
   #!/usr/sbin/nft -f
  =20
   flush ruleset
  =20
   table inet filter {
   	set deny-icmp_types {
   		type icmp_type
   		elements =3D {source-quench, redirect, echo-request, router-advertisem=
ent, router-solicitation, timestamp-request, timestamp-reply, info-request,=
 info-reply, address-mask-request, address-mask-reply}
   	}
   	set deny-icmpv6_types {
   		type icmpv6_type
   		elements =3D {echo-request, nd-redirect}
   	}
  =20
   	chain input {
   		type filter hook input priority filter
   		policy drop
   	=09
   		ct state established,related accept
   		ct state invalid drop
   	=09
   		iifname lo accept
   	=09
   	=09
   		icmp type @deny-icmp_types drop
   		icmpv6 type @deny-icmpv6_types drop
   	=09
   		meta l4proto {icmp, ipv6-icmp} accept
   	=09
   		include "/etc/nftables/rules.d/*.nft"
   	}
   	chain output {
   		type filter hook output priority filter
   		policy accept
   	=09
   		ct state invalid drop
   	=09
   		##oifname lo accept
   	}
   	chain forward {
   		type filter hook forward priority filter
   		policy drop
   	=09
   		ct state invalid drop
   	}
   }


Now, in /etc/nftables/rules.d/*.nft I would have placed template files
like e.g.:
allow-echo-request.nft:
   delete element inet filter deny-icmp_types {echo-request}
   delete element inet filter deny-icmpv6_types {echo-request}
  =20
So one could do configuration based on whether the files are there or
not, making it easy to update (instead of having one big monolithic
file on some hundreds of university nodes).

I also have e.g.:
50-accept-new-tcp-dports.nft:
   table inet filter {
   	set accept-new-tcp-dports {
   		type inet_service
   	}
   }
  =20
   ct state new tcp dport @accept-new-tcp-dports accept

Which merely adds a "framework" rule and then requires other files that
actually adds ports to the set.
So I could have one for SSH... and a gazillion for dCache (a mass
storage management system used in many big science collaborations, LHC
in my case).


But... these includes fails miserably. ;-)

E.g. for allow-echo-request.nft:
In file included from /etc/nftables/rules.nft:38:3-40:
/etc/nftables/rules.d/allow-echo-request.nft:4:8-14: Error: syntax error, u=
nexpected element, expecting @ or '$'
delete element inet filter deny-icmp_types {echo-request}
       ^^^^^^^
And for 50-accept-new-tcp-dports.nft:
/etc/nftables/rules.d/50-accept-new-tcp-dports.nft:xxx: Error: syntax error=
, unexpected table
table inet filter {
^^^^^

Which I can understand, but it does so even if I remove the surrounding
table inet filter:
In file included from /etc/nftables/rules.nft:xxx:
/etc/nftables/rules.d/50-accept-new-tcp-dports.nft:xxx: Error: syntax error=
, unexpected string, expecting add or update or delete
	set accept-new-tcp-dports {
	    ^^^^^^^^^^^^^^^^^^^^^
at least that I'd have kinda expected to work.


So question is:
What of all that should work? Or is there some special trick one needs
to do when doing an include XXX inside some { } block?

Or may include rather only be used on the "top level"?


Thanks,
Chris.
