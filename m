Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742301CBA02;
	Sat,  4 Jan 2025 14:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736001955; cv=none; b=ZOIYByG/eJDlWlXzJtFxaBCycpomI8rpLuujawWD584+7XGWiYxmYMdf7D0YWOmhsAurKektlSy6cNBvuhy/DSZNK8sb8xHRlapo6pBr3acdJJYSTvOTy84MsAnTxHIca6c0hZSnX4e8WhArGr2L6UxX9BGUH1zRfUIJF7HeuKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736001955; c=relaxed/simple;
	bh=nI+cBuik5ha/E3ImOfPIxhHtKMw0lLdsnwSM43IvvMM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=JHH88uTvICF05KOKxqNIsrj3JrZc0v1WN1VpHe1oa9Q0xDMmJHLAU/lRAQexD3s96dn3SzPJxEUG2rTCCeaXa9IvemKe8ETJ1hTJDSatMjRNKQucE6DC8ow8G5+TICArsMaSLPa4+tK4je+glZJdNsJPHBuMTfWyXtyu6+YgP+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=aUvSzFbJ; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="aUvSzFbJ"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id CA32D19201E6;
	Sat,  4 Jan 2025 15:38:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=content-id:mime-version:references
	:message-id:in-reply-to:from:from:date:date:received:received
	:received:received; s=20151130; t=1736001519; x=1737815920; bh=z
	dwkgOYuKBaOzv2DA3KyMIW4SgOrd0W2F762IUaQ9k0=; b=aUvSzFbJr3MAueODj
	DxRVs8GHcJUeh14WHVy96XjBJZgSv2n0sI9Yelw1l6QWg1HzyIXK/Vn5egGWv8t1
	nfu/MONNAf9Sy+kAwvlpbvaFPYReCTpdGWlmFhi5RC4h34hfelTuYF69HlXqwpqJ
	4eGbGJN9yDwqQQCyseybhMkwOs=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 7cqD-2HhgVca; Sat,  4 Jan 2025 15:38:39 +0100 (CET)
Received: from mentat.rmki.kfki.hu (84-236-122-23.pool.digikabel.hu [84.236.122.23])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 2284319201E5;
	Sat,  4 Jan 2025 15:38:38 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id C900E142841; Sat,  4 Jan 2025 15:38:37 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id C726A1421AE;
	Sat,  4 Jan 2025 15:38:37 +0100 (CET)
Date: Sat, 4 Jan 2025 15:38:37 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
cc: Andrew Lunn <andrew@lunn.ch>, Florian Westphal <fw@strlen.de>, 
    Pablo Neira Ayuso <pablo@netfilter.org>, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    David Miller <davem@davemloft.net>, dsahern@kernel.org, 
    edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which
 has same name.
In-Reply-To: <90b238e6-65d8-4a1d-b59b-e10445e4c61c@freemail.hu>
Message-ID: <8bbcefc0-b004-ce29-02a0-7d6743f29bee@blackhole.kfki.hu>
References: <20250102172115.41626-1-egyszeregy@freemail.hu> <6eab8f06-3f65-42cb-b42e-6ba13f209660@lunn.ch> <90b238e6-65d8-4a1d-b59b-e10445e4c61c@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-519488587-1735849527=:4693"
Content-ID: <34ab9271-bc74-a98e-3e6a-cd76fac738a7@blackhole.kfki.hu>
X-deepspam: dunno 32%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-519488587-1735849527=:4693
Content-Type: text/plain; charset=UTF-8
Content-ID: <6a6a9ac7-23e2-70b0-2d09-856bf605e913@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Jan 2025, Sz=C5=91ke Benjamin wrote:

> > This needs a much stronger argument, since as i already pointed out,=20
> > how many case-insenstive file systems are still in use? Please give=20
> > real world examples of why this matters.
>=20
> All of MacOS and Windows platform are case-insensitive. So it means, wh=
o=20
> like to edit Linux kernel code on them, then build it in a remote SSH=20
> solution, there are lot of them.

As far as I known on Windows 10 and above one can enable case-sensitivity=
=20
for given folders. If one uses WSL, then it's default on and true for all=
=20
subfolders as well. On MacOS one can create case-sensitive volumes.

So if someone wants to develop Linux kernel on these systems, with a=20
little effort, one can create the proper environment for it including the=
=20
case-sensitive directory structure/filesystem.

In my opinion merging the match/target files and thus shrinking the code,=
=20
saving memory are more interesting in your efforts than your original goa=
l=20
- without sprinkling the code with warnings in pragmas.
=20
Best regards,
Jozsef
--8323329-519488587-1735849527=:4693--
