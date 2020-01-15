Return-Path: <SRS0=+R7G=3E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FAE0C33CB1
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 07:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A3BA214AF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 07:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="sljkh+Vx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgAOH6G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 02:58:06 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:44385 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728932AbgAOH6F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 02:58:05 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 2F61F67400F6;
        Wed, 15 Jan 2020 08:58:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1579075081; x=1580889482; bh=YubHS8eMHx
        etMK2ALaYfcbCTvcLF4NdRq2nd44EM2vQ=; b=sljkh+VxifQqRZSJhe8uJNuxy2
        376fSd+brrgSWFZSazHc6RyHNoMOmXcvleKPyvYxLBUPOHIpiskXNLnsysD93oro
        H55y8eRzZ7xsUPTylPz7d730snEGQa48N2ebDtaip+Yo/it+pBlDVDRaEy42XMgo
        bHPpEwaVtzTYXsWnk=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 15 Jan 2020 08:58:01 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id D09AA67400F8;
        Wed, 15 Jan 2020 08:58:01 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 9A8A320C5E; Wed, 15 Jan 2020 08:58:01 +0100 (CET)
Date:   Wed, 15 Jan 2020 08:58:01 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf-next 0/4] netfilter: conntrack: allow insertion of
 clashing entries
In-Reply-To: <20200114222127.GP795@breakpoint.cc>
Message-ID: <alpine.DEB.2.20.2001150848360.19314@blackhole.kfki.hu>
References: <20200108134500.31727-1-fw@strlen.de> <20200113235309.GM795@breakpoint.cc> <alpine.DEB.2.20.2001142031060.17014@blackhole.kfki.hu> <20200114222127.GP795@breakpoint.cc>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="110363376-1641646667-1579075081=:19314"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1641646667-1579075081=:19314
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 14 Jan 2020, Florian Westphal wrote:

> Kadlecsik J=C3=B3zsef <kadlec@blackhole.kfki.hu> wrote:
> > However, I think there's a general already available solution in iptabl=
es:=20
> > force the same DNAT mapping for the packets of the same socket by the=
=20
> > HMARK target. Something like this:
> >=20
> > -t raw -p udp --dport 53 -j HMARK --hmark-tuple src,sport \
> > =09--hmark-mod 1 --hmark-offset 10 --hmark-rnd 0xdeafbeef
> > -t nat -p udp --dport 53 -m state --state NEW -m mark --mark 10 -j DNAT=
 ..
> > -t nat -p udp --dport 53 -m state --state NEW -m mark --mark 11 -j DNAT=
 ..
>=20
> Yes, HMARK and -m cluster both work, nft has jhash expression.
> So we already have alternatives to provide consistent nat mappings.
>=20
> I doubt that kubernetes will change their rulesets, however.

That'd be sad - those rules are surely not carved in stone...

[By the way, I'd go even further and leave out DNAT completely: put the=20
real nameservers into resolv.conf and be done with it. musl connects them=
=20
parallel anyway and glibc supports the rotate options for ages. What else=
=20
would remain for DNAT? "Hide" the real IP addresses of the name servers?=20
That's just pointless.]

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-1641646667-1579075081=:19314--
