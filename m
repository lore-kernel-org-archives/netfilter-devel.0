Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA98B198A06;
	Wed,  8 Jan 2025 20:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736367120; cv=none; b=RBUONo6w7uVaahrRy//6jPvxko08ArVbGppztYzksxRxNUrz7+FAJIc4V+gp3RNSRI4qbd79gRm/qhIoj5tLhC95SAm3+D4REZg1hgDEXN8PFgos6PZq0j08GX+fVZkWTdWWGD+a5SHngpd3IxR5ow3qxKYImHpF/LtElMBEyOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736367120; c=relaxed/simple;
	bh=oatabbBNA9Q9wqlrLxwJ7l+gsc9TbdZrfCbPD4csvno=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=SzKSq4+OKw/Sh9Hqgo/xoRxiJYd6tEQuhlmSLmVPMekPCJfLVr9lNR3UAUzLsTiMFZcBncqLu57cr5BrRG38V4f6HwKfegIZ9rxCuVqySAtGUd1nFqBhCnDTvO2vthOua5yvStTUUUMvmUGrvCn8Ak4Vhb3/tSPFOENVJhMxmYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 6085F5C001C5;
	Wed,  8 Jan 2025 21:11:49 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id uq60o7O87ePj; Wed,  8 Jan 2025 21:11:47 +0100 (CET)
Received: from mentat.rmki.kfki.hu (85-238-77-85.pool.digikabel.hu [85.238.77.85])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id A33005C001C1;
	Wed,  8 Jan 2025 21:11:46 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 5EBF3142729; Wed,  8 Jan 2025 21:11:46 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 5AED31424A2;
	Wed,  8 Jan 2025 21:11:46 +0100 (CET)
Date: Wed, 8 Jan 2025 21:11:46 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>, 
    lorenzo@kernel.org, daniel@iogearbox.net, leitao@debian.org, 
    amiculas@cisco.com, David Miller <davem@davemloft.net>, dsahern@kernel.org, 
    edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 01/10] netfilter: x_tables: Merge xt_DSCP.h to
 xt_dscp.h
In-Reply-To: <98387132-330e-4068-9b71-e98dbcc9cd40@freemail.hu>
Message-ID: <d7190f89-da4d-40df-2910-5e87ca3cd314@netfilter.org>
References: <20250107024120.98288-1-egyszeregy@freemail.hu> <20250107024120.98288-2-egyszeregy@freemail.hu> <4fab5e14-2782-62d2-a32d-54b673201f26@netfilter.org> <98387132-330e-4068-9b71-e98dbcc9cd40@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-2044228773-1736365386=:4693"
Content-ID: <436f2469-2d06-5004-1f60-8efaadced9d6@blackhole.kfki.hu>
X-deepspam: ham 0%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2044228773-1736365386=:4693
Content-Type: text/plain; charset=UTF-8
Content-ID: <de375da8-7330-bc7d-893b-22a6453a4489@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Jan 2025, Sz=C5=91ke Benjamin wrote:

> 2025. 01. 07. 20:23 keltez=C3=A9ssel, Jozsef Kadlecsik =C3=ADrta:
> > On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
> >=20
> > > From: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
> > >=20
> > > Merge xt_DSCP.h to xt_dscp.h header file.
> >=20
> > I think it'd be better worded as "Merge xt_DSCP.h into the xt_dscp.h=20
> > header file." (and in the other patches as well).
>=20
> There will be no any new patchset refactoring anymore just of some=20
> cosmetics change. If you like to change it, feel free to modify it in m=
y=20
> pacthfiles before the final merging. You can do it as a maintainer.

We don't modify accepted patches. It rarely happens when time presses and=
=20
even in that case it is discussed publicly: "sorry, no time to wait for=20
*you* to respin your patch, so I'm going to fix this part, OK?"

But there's no time constrain here. So it'd be strange at the minimum if=20
your submitted patches were modified by a maintainer at merging.

Believe it or not, I'm just trying to help to get your patches into the=20
best shape.
=20
> > > -#ifndef _XT_DSCP_H
> > > -#define _XT_DSCP_H
> > > +#ifndef _UAPI_XT_DSCP_H
> > > +#define _UAPI_XT_DSCP_H
> >=20
> > In the first four patches you added the _UAPI_ prefix to the header=20
> > guards while in the next three ones you kept the original ones. Pleas=
e=20
> > use one style consistently.
>
> Style consistently is done in the following files:
>=20
> - All of xt_*.h files in uppercase name format (old headers for "target=
")
> - All of xt_*.h files in lowercase name format (merged header files)
>=20
> Originally, in these files there was a chaotic state before, it was a=20
> painful for my eyes, this is why they got these changes. In ipt_*.h=20
> files the original codes got a far enough consistently style before,=20
> they was not changed.
>=20
> In my patchsets, It's not my scope/job to make up for the
> improvements/refactoring of the last 10 years.

But you are just introducing new inconsistencies:=20

--- a/include/uapi/linux/netfilter/xt_dscp.h
+++ b/include/uapi/linux/netfilter/xt_dscp.h
...
-#ifndef _XT_DSCP_H
-#define _XT_DSCP_H
+#ifndef _UAPI_XT_DSCP_H
+#define _UAPI_XT_DSCP_H

however

--- a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
...
 #ifndef _IPT_ECN_H
 #define _IPT_ECN_H

Why the "_UAPI_" prefixes are needed in the xt_*.h header files?

Best regards,
Jozsef
--=20
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef=
@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
--8323329-2044228773-1736365386=:4693--
