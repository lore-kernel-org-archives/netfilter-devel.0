From: Peter Volkov <pva@gentoo.org>
Subject: Re: Fwd: ebtables broken for kernel above 2.6.28
Date: Sun, 14 Jun 2009 19:47:14 +0400
Message-ID: <1244994434.11823.4816.camel@localhost>
References: <17923cc80905280124t4ed6cf7m87f91e4444146697@mail.gmail.com>
	 <4A1EB783.4090801@pandora.be>
	 <17923cc80905282251s2ddc50a4n1a44a2b1e6b01cc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jengelh@medozas.de, sachin sanap <sachin.sanap.1gb@gmail.com>,
	buytenh@wantstofly.org, Bart De Schuymer <bdschuym@pandora.be>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:41837 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZFNPrh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:47:37 -0400
In-Reply-To: <17923cc80905282251s2ddc50a4n1a44a2b1e6b01cc5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Could anybody suggest correct fix for this problem? After reading full
thread I'm unsure what to do... BTW, where ebtables (userspace)
development now flows? Does it still uses the sourceforge's CVS server?

Thanks,
--
Peter.

=D0=92 =D0=9F=D1=82=D0=BD, 29/05/2009 =D0=B2 11:21 +0530, sachin sanap =
=D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> Iam facing problem with ebtables binay on 2.6.28 kernel (same binary
> works well with 2.6.27). Its mostly a structure alignment issue with
> standard targets like DROP,ACCEPT etc. Message seen by user is
> "eb_tables: standard target: invalid size 8 !=3D 4"
> Iam trying to fix it, this mail is just to check if its already fixed
> by someone else?
>=20
> Thanks
> -Sachin
>=20
> ---------- Forwarded message ----------
> From: Bart De Schuymer <bdschuym@pandora.be>
> Date: Thu, May 28, 2009 at 9:40 PM
> Subject: Re: ebtables broken for kernel above 2.6.28
> To: sachin sanap <sachin.sanap.1gb@gmail.com>
> Cc: nick@fedchik.org.ua, grzes@gnu.univ.gda.pl
>=20
>=20
> You can ask around on netfilter-devel-owner@vger.kernel.org to see if
> it has been fixed.
>=20
> Regards,
> Bart
=09
--=20
Peter.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
