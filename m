From: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Subject: Re: [PATCHv6 0/3] Interface group patches
Date: Thu, 22 Nov 2007 15:37:29 +0100
Message-ID: <200711221537.29396.wolfgang.walter@studentenwerk.mhn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:53835 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbXKVPLE convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Nov 2007 10:11:04 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

=46rom: Patrick McHardy
> I'm working on the incremental ruleset changing API BTW :)
> One of the changes will be that interface matching is not
> a default part of every rule, and without wildcards it will
> use the ifindex. But since the cost of this feature seems
> pretty low, I don't see a compelling reason against it.

Using ifindex instead of string matching the interface name in -i and -=
o would=20
be a serious problem as it changes the semantics.

1) Now you can match a non existing interface. This is certainly used. =
I.e.=20
with vlan interfaces, ppp etc.
2) Now your rule will match an interface even if the ifindex of the int=
erface=20
changes. This is used (i.e. you activate a backup interface and rename =
it,=20
build new bridges etc.).

If one wants to use the ifindex instead of a string match on the name o=
ne=20
should explicitly request that (i.e. by using "-i =3Deth0" or something=
 like=20
that).

Regards,
--=20
Wolfgang Walter
Studentenwerk M=FCnchen
Anstalt des =F6ffentlichen Rechts
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
