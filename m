Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C702496D46
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 19:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791403132; cv=pass; b=n9gBdrnm5p5nQsjO3BCL87aHhNpE8sCRvSsRB6nsxUQtN0vjwqo/v/tdfKnVqAcu/qo56iT7I3zN595JVXvWUi7HQJXLpEph8goSSsnl1yKoHmxj+3jh7IH260ttIYwbTefq9aAKZXM9vpwq4wKr9aodBeO1Kfz8ZJ2oCS8so2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791403132; c=relaxed/simple;
	bh=/Au4bQsPT/L7X3aSl3VXqi/XxxlxAElghQIfekCvvsU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pgoCzutB3lmladB8/8xqVyJrY49Tb1affsFkbbNPKkJQtv+ORV+7hcWxD6PbodedIPvp+Z1oREbJbGJadIT5qwZIux0ss8cgIkXO6qUjH3L3jnGsDJxkJIVniIrDGZYQw0HKT0vm+Fc/M6p3Ya8JX/2nco6mVFbn/uZEp9WFNyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sA2D9NZB; arc=pass smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sA2D9NZB"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3516e7693e9so540848eec.1
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Oct 2026 12:58:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791403131; cv=none;
        d=google.com; s=arc-20260327;
        b=FwRHgsrpD0h5WxVyRRJ8z/SDkKA+UlFzi3tF8KvT4XK+cNU9CuYM0t9RW366wXV13+
         cLJLKGPCigjwea1J07cEjaxsxymvmn5uz5iw78UdiypijoprPCwMGAJn6Jago85jo5qv
         GhiE8AVeTYjEizqdruTw4xTFIPPzPjH7ddPgNUy1Fg/Xc70k2L1aWZ8QkIc5v+KSjtPm
         fP9Yx087KOm0oz6fLvQp5nZxckJ6v/2FrP39E6jLIUKQjPsdZ+A657UaEGYfXty9ZY14
         +nv+JkEsVEvg0Lw4C/EvjQP0d+WEhBWViL3uyg60+v88ZyNLX/3y1IQH8eSjxgrlFkK8
         k6sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8zpL7DZZ6zBvI322aBJwUTuwFfeAPVheDYwWX2xhYrA=;
        fh=SMDBiq8Vptw+jp+8z2vD0uyfM1SCN1XCbI5yBg7Hjtg=;
        b=nmKQjMEBaAH4BWO07cSIRjhhFa6ZR1kvioDth/93EZ84UPD31iODfR7+KqlkjBWqPj
         ibdE6/me4wihYR7TM1Ek4en3e+BZRGwJhXxFDHDZcEwp8o/X5TkmzxyvgqmkpRQAvJLU
         5WiLpgcwYzRrMWGtgiOn/mP39TYX0J2eF+JkWqPZL+tQwUa5Zp2fR2CayF0nl7+pP3rY
         jMuC0ohCZ1w9pEd9eZaLLFgSPx5ZFq8R15roDGw4dbrNJxUp9ys2o2BKfMOjSu57wa12
         RqIbTqALpLofJersFD8Rv+e0T5sa5Si1X2VYVxfMK4rehXLB3Ww4ww20QM6gR+5JDyRd
         RF+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791403131; x=1792007931; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8zpL7DZZ6zBvI322aBJwUTuwFfeAPVheDYwWX2xhYrA=;
        b=sA2D9NZBo5D/q8ulhPWOWcscOhFecMaYIdrOTyfJ1jHuENyH4GPQdyPfbU2bz53Dzo
         9JTsktZ2iuMY1Gh5A6OxfccfXgVbjl2evvJliWGUSmSJ9waTDO02LQ7ExjVEN/lttiqn
         loKVCcvXObePYT+KSOi1bsNOJQVipBca9O6rtQoXtGLed+s4HAhG/XWYsZyIVPtO4qXq
         tHgobUtRTB1aZEcUZ5zGBw4SCmhzczDdCl0bFyn2e1FBCb/oZ/Pp0k11A6UkbQv/BynK
         Di0+XarU6TdZ4o2sCZJ1BJxvS1UKKl4qDbfpMoZ05UAz6pPFSsXm27c/W2ThJDTCvk1E
         ohuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791403131; x=1792007931;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8zpL7DZZ6zBvI322aBJwUTuwFfeAPVheDYwWX2xhYrA=;
        b=Ao/u6Oabuph0OEaiM14UR59926GPuE2MgXgqdNv2PlihEVJ9i1DeemWk7E7/3Vsk0z
         dD0b8Bc/HJdHCny4ZJ6DMv13XEQZNYJuETxZzZEtQXgpqnehanMeJF6UeWo0GjmFttWh
         YDx67GH7Z1vVOsxuHHCHSVzSxqkpIq3UlX4d9a8eajL2Zo6vXDlqP1uuNO8RhW5R/KB/
         MFUMDoldp8AW4SIFb3V86a3PP6nanucGTlB5t6ZW2NjpQj+VzS5WAkEb/QEZpsTXVzqX
         R2tSGK5TawzCHD10ZXt+wuCbSCeolJI4BGB+aYnnQVZwYR+LxIp2PXEYWic5c4EanLy1
         sJ3w==
X-Forwarded-Encrypted: i=1; AKwUvBzZcYmlx9vgDi0Zv9qedhlZdLtQS4cVN5S4GdQsPyE0J8PHupiipDgaBFVHiktZYL4t9PhRVsUYbWc/Xlmru5M=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ8ZAJEmXQ2hzAt/DHEcBMRpEgEAcEkgQQ+F2ghd9o20X91JGTZ
	rHk7jND9GqXQfnMSsL9gN/owQ/fpYiiyF6pXaVl6vB3kVq4qG2H1qpS0RK8xUIuuE40pegipfRB
	/pUBTMVw228Tjuge9Vd4qx9gz6bBBqX8=
X-Gm-Gg: AYBFou0qYWAYSb8X60rfyk1oVMvKgJ7ICbKT9Gx1MuLYfHIISFASLlDHkzwGX3DhDjb
	KjKydYkwyx+87SguPJFTPzEUbFroEGeaKfJqerR8Fv+c2BMMWe7iRXgDF4C60aO1+aZZmjYcPZN
	H8NpFPMijFlo+A8Zn1siKYVfDM8V0Jd5gkx0WYFcVZLETsWS6X5aIhy+j8XcLglmnNqwRRSjtAc
	eP1D2w5Hs7nmEUPaS888Bfc+dcSYW9VbQvH6dYMW+PlGKTVwxwZD8s+O0DPOsEQNEJyEFiRFtLn
	5Uh2YxU0xo4HrQGDHWdsjWOrJ2R+xkXKQ346gNZVC9EgfsoyivZV8GzyqvdovtTKd8WYj1u2QcR
	K2tuQdRXb9VTR7ckN2WkFetbgT3sfe25jOtgXYRBQJou6e+hy5KsE8Bw=
X-Received: by 2002:a05:693c:2585:b0:34c:5841:3e12 with SMTP id
 5a478bee46e88-351775c0c78mr329543eec.9.1791403129595; Wed, 07 Oct 2026
 12:58:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <179138670045.80227.4002052840715926590@gmail.com>
 <179138703794.2527009.12321622169213831789@kernel.org> <CAOCBhwE_JmVTmbuzJc8SEU1ROVyrat=7K-wqTQE=Er0gUy4fLA@mail.gmail.com>
 <asahA40Bh9chMyqP@chamomile>
In-Reply-To: <asahA40Bh9chMyqP@chamomile>
From: Joas Antonio <joasantonio108@gmail.com>
Date: Wed, 7 Oct 2026 16:58:37 -0300
X-Gm-Features: AclHuK9TxB_kSB_DjJLwXQo1LRpU43iFtSm3048SpV89-JzHZTHwsKrosJWSDo8
Message-ID: <CAOCBhwFrmp1vGys=4i6Yyn2eMmMAQuxehas-fkhz4aNTRr106g@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_conntrack_sip: only honour Via: port in
 original direction
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev-bot+sinfo@kernel.org, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 07, 2026, Pablo Neira Ayuso wrote:
> Sorry, this cannot be nf material.
> It looks fairly theoretical to me, maybe for correctness patch? Is
> this assuming a rogue server and packet spoofing?

It assumes a rogue (or compromised) SIP peer, but no spoofing: the
peer only uses its own address in the Via: header, so any SIP server
or proxy the client talks to can do it. The effect is limited to that
peer's own flow: it can pick which port >=3D 1024 its datagrams are
delivered to on the NATed host, instead of the mapped port.

So I agree it is not urgent. I will resend it for nf-next as a
correctness fix, with how it was found in the commit message.

Thanks,
Joas


Em qua., 7 de out. de 2026 =C3=A0s 16:44, Pablo Neira Ayuso
<pablo@netfilter.org> escreveu:
>
> On Wed, Oct 07, 2026 at 12:52:19PM -0300, Joas Antonio wrote:
> > Hi,
> >
> > How the issue was discovered: manual code inspection of
> > nf_conntrack_sip.c / nf_nat_sip.c, assisted by an LLM (hence the
> > Assisted-by: tag), while auditing the conntrack helpers for
> > direction-handling issues.
> >
> > I then confirmed it at runtime on 602042bf29f6 (QEMU, arm64) with
> > client -> router -> server network namespaces, the router running
> > nft masquerade and a "sip" ct helper on udp/5060. When the server
> > sends a request with "Via: SIP/2.0/UDP <server-ip>:4444", the client
> > behind the NAT receives that request and a following plain UDP payload
> > on port 4444; with the patch applied both arrive on 5060.
>
> Sorry, this cannot be nf material.
>
> It looks fairly theoretical to me, maybe for correctness patch? Is
> this assuming a rogue server and packet spoofing?
>
> > Thanks,
> > Joas
> >
> >
> > Em qua., 7 de out. de 2026 =C3=A0s 12:30, <netdev-bot+sinfo@kernel.org>=
 escreveu:
> > >
> > > Hi!
> > >
> > > This is an automated message. This series looks like a fix, but its
> > > commit messages seem to be missing some information:
> > >
> > >  - How the issue was discovered, e.g. hit in production, hit during
> > >    development, syzbot report, manual code inspection, LLM or static
> > >    analysis tool scan.
> > >
> > > Please do not repost the series just to address the above. Instead,
> > > reply to this email with the missing information, so that reviewers
> > > can take it into account. If the series needs another revision for
> > > other reasons, please include the information in the commit messages
> > > then.
> > >
> > > The evaluation is done by an LLM so it may be wrong, if you think
> > > that is the case please reply and explain.
> >
> >
> >
> > --
> > Joas Antonio dos Santos
> > Cyber Security Specialist and Ethical Hacker
> > joasantonio108@gmail.com
> > LinkedIn



--=20
Joas Antonio dos Santos
Cyber Security Specialist and Ethical Hacker
joasantonio108@gmail.com
LinkedIn
