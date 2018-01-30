From: David Fabian <david.fabian@cldn.cz>
Subject: Re: question about UNDEFINE/REDEFINE
Date: Tue, 30 Jan 2018 12:22:35 +0100
Message-ID: <5560485.OA0SLqNG1b@voxel>
References: <3622208.jy4NlOniyd@voxel> <1993002.08LkLsM8EI@voxel> <CAOkSjBiHTwW_9rQhznubKnZ=DJJsySK4qo_XJ3r4PLAmKXt35w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailalternative.uvtmail.cz ([109.205.75.52]:43148 "EHLO
        mail.hosting.cldn.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751262AbeA3LWh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jan 2018 06:22:37 -0500
In-Reply-To: <CAOkSjBiHTwW_9rQhznubKnZ=DJJsySK4qo_XJ3r4PLAmKXt35w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Arturo,

Dne p=C3=A1tek 26. ledna 2018 19:43:18 CET, Arturo Borrero Gonzalez napsal(=
a):
> My suggestion is to simply create one variable per value:
>=20
> define INET_IFACES_VLAN43 =3D { bond0.x, bond3.y}
> define INET_IFACES_VLAN3 =3D { bond3.x, bond3.y}
> define XXX_VLAN43 =3D xxx
> define XXX_VLAN3 =3D xxx
>=20
> you could generate such a file, something like 'defines.nft' and
> include it once in your main ruleset file.

that is exactly the boilerplate that we are trying to avoid. By using=20
consistent (and non-unique) variable names we are able to freely move the=20
rules from one customer to another without rewriting every use of a variabl=
e=20
every time. We also do not want to build a code-generating harness in bash =
(or=20
any other language) since that would sort of defeat the purpose of scriptin=
g=20
in nftables in my eyes. the redefine keyword was just my first idea to solv=
e the=20
problem of a single flat variable scope. There may be a better approach but=
 I=20
think that if nftables wants to have scripting capabilities, some kind of=20
variable scoping (even in flat notation) and more ubiquitous variable use=20
within rules is necessary.

I event went so far and made some experimental patches that allowed me to u=
se=20
string variables and string concatenation in places like interface names an=
d=20
rule targets. With that I was able to create very generic rules and I tied=
=20
them to a customer/VLAN just by changing one or two constants in the header=
 of=20
a file (e.g. the VLAN number). Of course, I had to use redefine in the head=
er.

=2D-=20
S pozdravem,

David Fabian
Cluster Design, s.r.o.

