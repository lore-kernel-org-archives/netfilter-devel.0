Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D381B0F17;
	Wed,  8 Jan 2025 20:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736367362; cv=none; b=UVhny6Ov4LR+QArXmZuDSfPQWS6htrC+G886nL0YIa3zAflEYwFjFU4KohinQZSKxbyMoUSgR+5B0yTI9vzLOcYsngfVvvZDqwnGtrMf15alCLTOb4BDPt7VcHRgiMerw8/G/5+KNE9qog2Fs7ZI7WQNoYmqgOtFVqRt/eUxp44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736367362; c=relaxed/simple;
	bh=zpoQFkENkNf/uWOtAz1GGrZD2Jaih4a/2+uBohaYQLM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qYLbGTtdWAelpiGgD3J7oRlnjrKDE8XkUW8joBsLyVzJ1RcXBw5dOIU+V+t0DqAdgoDNYBcAc2mtHbnt81EvN+7GK7BlE/9s5OHY2tsO8/z1q+QMLqIaSRtFNb8t+ha3PgZp8A1mA+9/lBAy1oMtbMEYOY7Bwrsvvma2JNFqEEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 03A6D19201C6;
	Wed,  8 Jan 2025 21:15:52 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 4uZHuCNCRCF6; Wed,  8 Jan 2025 21:15:50 +0100 (CET)
Received: from mentat.rmki.kfki.hu (85-238-77-85.pool.digikabel.hu [85.238.77.85])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 10EC219201A2;
	Wed,  8 Jan 2025 21:15:50 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id E55FD142729; Wed,  8 Jan 2025 21:15:49 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id E27871424A2;
	Wed,  8 Jan 2025 21:15:49 +0100 (CET)
Date: Wed, 8 Jan 2025 21:15:49 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
    kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 05/10] netfilter: iptables: Merge ipt_ECN.h to
 ipt_ecn.h
In-Reply-To: <f53d51a9-e6d6-4376-8601-420ac756b7af@freemail.hu>
Message-ID: <db8da369-8750-3760-2615-9783bd0ab37a@netfilter.org>
References: <20250107024120.98288-1-egyszeregy@freemail.hu> <20250107024120.98288-6-egyszeregy@freemail.hu> <eb46258b-0fb2-c0be-f1aa-79497f3dc536@netfilter.org> <f53d51a9-e6d6-4376-8601-420ac756b7af@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-657160873-1736367349=:4693"
X-deepspam: ham 0%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-657160873-1736367349=:4693
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Jan 2025, Sz=C5=91ke Benjamin wrote:

> 2025. 01. 07. 20:26 keltez=C3=A9ssel, Jozsef Kadlecsik =C3=ADrta:
> > On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
> >=20
> > > From: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
> > >=20
> > > Merge ipt_ECN.h to ipt_ecn.h header file.
> > >=20
> > > Signed-off-by: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
> > > ---
> > >   include/uapi/linux/netfilter_ipv4/ipt_ECN.h | 29 +---------------=
-----
> > >   include/uapi/linux/netfilter_ipv4/ipt_ecn.h | 26 ++++++++++++++++=
++
> > >   2 files changed, 27 insertions(+), 28 deletions(-)
> > >=20
> > > diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> > > b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> > > index e3630fd045b8..6727f5a44512 100644
> > > --- a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> > > +++ b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> > > @@ -1,34 +1,7 @@
> > >   /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > > -/* Header file for iptables ipt_ECN target
> > > - *
> > > - * (C) 2002 by Harald Welte <laforge@gnumonks.org>
> > > - *
> > > - * This software is distributed under GNU GPL v2, 1991
> > > - *
> > > - * ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
> > > -*/
> > >   #ifndef _IPT_ECN_TARGET_H
> > >   #define _IPT_ECN_TARGET_H
> > >   -#include <linux/types.h>
> > > -#include <linux/netfilter/xt_DSCP.h>
> > > -
> > > -#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
>=20
> If it is not dropped out in the merged header file, it will cause a bui=
ld
> error because of the previous bad and duplicated header architects in t=
he
> UAPI:
>=20
> In file included from ../net/ipv4/netfilter/ipt_ECN.c:17:
> ../include/uapi/linux/netfilter_ipv4/ipt_ecn.h:17:25: error: expected
> identifier before =E2=80=98(=E2=80=99 token
>  #define IPT_ECN_IP_MASK (~XT_DSCP_MASK)
>                          ^
> ../include/uapi/linux/netfilter_ipv4/ipt_ecn.h:27:2: note: in expansion=
 of
> macro =E2=80=98IPT_ECN_IP_MASK=E2=80=99
>   IPT_ECN_IP_MASK       =3D XT_ECN_IP_MASK,
>   ^~~~~~~~~~~~~~~

Yes, you are right: from the patches themselves the duplicate macro/enum=20
definition of IPT_ECN_IP_MASK were not evident.

Best regards,
Jozsef
--=20
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef=
@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
--8323329-657160873-1736367349=:4693--
