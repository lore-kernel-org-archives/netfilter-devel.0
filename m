Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BB12010F6;
	Wed,  8 Jan 2025 20:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736367644; cv=none; b=Y5xGLqCgPj7xBRers5gl6GtmorjGfXDuccEIaSJEURJLiminfQua9cFGazNfBsJNWtAtV2VruSoDgJnCYAO785sIHY5evQn7QD2dlDSwSABomYJz/Y5ChVekgPXX6TEmpko06zFlBFqWDDtRb3vse4cl6tZAMYvaHH1xjqjsg6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736367644; c=relaxed/simple;
	bh=fyrJ06tTUad57LABbvuD9OqAcUEhbyvdx3gUcVjRGpo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ptHaPEG2eHqrjoAwLf9Cfm1CgN2q96/ihCj7tM74loXsSZeubeqIw4LQEP82jxWj2pXYS0WiEZfoIDuO5bsXemCfhNnb/WnHQdEFeUgUSIS0s6pq+DB8+GYIO8ac22UYOTyhncuaodqyvSIOUs2reqkISBvmr4y1w+gQAO1GtHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 3A16532E01C9;
	Wed,  8 Jan 2025 21:20:35 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id syP9fNfrsg8j; Wed,  8 Jan 2025 21:20:33 +0100 (CET)
Received: from mentat.rmki.kfki.hu (85-238-77-85.pool.digikabel.hu [85.238.77.85])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 387B732E01C5;
	Wed,  8 Jan 2025 21:20:33 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 170B0142729; Wed,  8 Jan 2025 21:20:33 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 1343A1424A2;
	Wed,  8 Jan 2025 21:20:33 +0100 (CET)
Date: Wed, 8 Jan 2025 21:20:33 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
    kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/10] netfilter: Adjust code style of xt_*.h, ipt_*.h
 files.
In-Reply-To: <4cf2e26b-2727-4b50-9ada-56a6be814dca@freemail.hu>
Message-ID: <27838d8f-7664-fdb9-3f8a-5ca812acdf72@netfilter.org>
References: <20250107024120.98288-1-egyszeregy@freemail.hu> <20250107024120.98288-9-egyszeregy@freemail.hu> <2962ec51-4d32-76d9-4229-99001a437963@netfilter.org> <4cf2e26b-2727-4b50-9ada-56a6be814dca@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1932669781-1736367633=:4693"
X-deepspam: ham 0%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1932669781-1736367633=:4693
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Jan 2025, Sz=C5=91ke Benjamin wrote:

> 2025. 01. 07. 20:39 keltez=C3=A9ssel, Jozsef Kadlecsik =C3=ADrta:
> > On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
> >=20
> > > From: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
> > >=20
> > > - Adjust tab indents
> > > - Fix format of #define macros
> >=20
> > I don't really understand why it'd be important to use parentheses=20
> > around plain constant values in macros. The kernel coding style does=20
> > not list it as a requirement, see 12) 4. in=20
> > Documentation/process/coding-style.rst.
>=20
> If it would be more than just a const value, parentheses is a must have=
=20
> thing for it (now for it, it is not critical to have it but better to=20
> get used to this). This is how my hand automatically do it, to avoid th=
e=20
> syntax problem in this coding.

Are you going to "fix" this "issue" in the whole kernel tree?

If yes, then please propose changes to the coding style documentation as=20
well.

If no, then please keep the macros as is because the changes would just=20
introduce more different kind of notations in the source tree.

Best regards,
Jozsef
--=20
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef=
@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
--8323329-1932669781-1736367633=:4693--
