Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37D620103D;
	Wed,  8 Jan 2025 20:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736369473; cv=none; b=TQQQyHk52lJ57YeV/Lu+jpRKkZWH9qHkdxmEYpznY+xzKiKaVUZ5ARnUaNECG6GTfyOT7TfD+B0joTYYX8TszfLVDFqp1xiE1dXHr1A8x45Jxi0Ik3jRDC66Dhm98ULSPDV3S/BBU486P6u/IX1s+phGKfxD01EYkfYf6deMFwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736369473; c=relaxed/simple;
	bh=ZjFrCllV1d+ooi8jNJ3k3JG56BJJdYmwztFEoQCViJ0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=K/fFXpczVDC8oollvBD9eQ5bxxh/qETJA4q90QAN+w25mMta1Lc2kS+5Sd5TZOPtXLfRMyIMuFKQwNeYcDzz0jczyz+1fvOjitL+Cv/HHWoqaucESeeaHyvN8rYv0XVoHdHiGdgQy9I9FJdFOX2E8qRU9zxRYAi1UOpygYn71G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id CD55019201C6;
	Wed,  8 Jan 2025 21:51:08 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id qoV9XXzh3VCK; Wed,  8 Jan 2025 21:51:07 +0100 (CET)
Received: from mentat.rmki.kfki.hu (85-238-77-85.pool.digikabel.hu [85.238.77.85])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 6F7BA19201C2;
	Wed,  8 Jan 2025 21:51:06 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 34CE2142729; Wed,  8 Jan 2025 21:51:06 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 311A714064E;
	Wed,  8 Jan 2025 21:51:06 +0100 (CET)
Date: Wed, 8 Jan 2025 21:51:06 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
    kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/10] netfilter: Add message pragma for deprecated
 xt_*.h, ipt_*.h.
In-Reply-To: <0e51464d-301d-4b48-ad38-ca04ff7d9151@freemail.hu>
Message-ID: <2b9c44e0-4527-db29-4e5e-b7ddd41bda8d@netfilter.org>
References: <20250107024120.98288-1-egyszeregy@freemail.hu> <20250107024120.98288-10-egyszeregy@freemail.hu> <1cd443f7-df1e-20cf-cfe8-f38ac72491e4@netfilter.org> <0e51464d-301d-4b48-ad38-ca04ff7d9151@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1266224386-1736369466=:4693"
X-deepspam: ham 0%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1266224386-1736369466=:4693
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Jan 2025, Sz=C5=91ke Benjamin wrote:

> 2025. 01. 07. 20:39 keltez=C3=A9ssel, Jozsef Kadlecsik =C3=ADrta:
> > On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
> >=20
> > > From: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
> > >=20
> > > Display information about deprecated xt_*.h, ipt_*.h files
> > > at compile time. Recommended to use header files with
> > > lowercase name format in the future.
> >=20
> > I still don't know whether adding the pragmas to notify about header=20
> > file deprecation is a good idea.
>=20
> Do you have any other ideas how can you display this information to the=
=20
> users/customers, that it is time to stop using the uppercase header=20
> files then they shall to use its merged lowercase named files instead i=
n=20
> their userspace SW?

Honestly, I don't know. What about Jan's clever idea of having the=20
clashing filenames with identical content, i.e.

ipt_ttl.h:
#ifndef _IPT_TTL_H
#define _IPT_TTL_H
#include <linux/netfilter_ipv4/ipt_ttl_common.h>
#endif _IPT_TTL_H

ipt_TTL.h:
#ifndef _IPT_TTL_H
#define _IPT_TTL_H
#include <linux/netfilter_ipv4/ipt_ttl_common.h>
#endif _IPT_TTL_H

Would cloning such a repo on a case-insensitive filesystem produce errors=
=20
or would work just fine?

Best regards,
Jozsef
--=20
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef=
@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
--8323329-1266224386-1736369466=:4693--
