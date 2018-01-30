From: David Fabian <david.fabian@cldn.cz>
Subject: Re: question about UNDEFINE/REDEFINE
Date: Tue, 30 Jan 2018 12:05:48 +0100
Message-ID: <9368681.Gobf97r6C9@voxel>
References: <3622208.jy4NlOniyd@voxel> <1993002.08LkLsM8EI@voxel> <20180126134549.t5wjq63x7vw7efcw@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailalternative.uvtmail.cz ([109.205.75.52]:59800 "EHLO
        mail.hosting.cldn.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751360AbeA3LFv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jan 2018 06:05:51 -0500
In-Reply-To: <20180126134549.t5wjq63x7vw7efcw@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

Dne p=C3=A1tek 26. ledna 2018 14:45:49 CET, Pablo Neira Ayuso napsal(a):
> 2) Probably even cleaner is to look at 'local' scopes like in bash.
>=20
>  define local IP1 =3D 1.1.1.1
>=20
> so the symbol is bound to this file - consider the content of a file
> determines a given scope. This can be also useful to the nested
> notation.
>=20
> 3) You rework your ruleset to use the notation with nesting :-). But I
> think 2) can be useful for both the flat and nested notation.
>=20
> I'm not asking you to do 2), but I would like to see how a patch that
> adds explicit scoping for the flat ruleset representation looks like.

I know about scopes in the code but unfortunately as you said, the flat=20
notation only has a single scope. Since we are talking about analogy to bas=
h,=20
bash allows me to redefine a variable in the same scope. Variables in nftab=
les=20
feel more like constants which is not necessarily bad as it can prevent som=
e=20
typos but is hard to work with in scripting as it's not that flexible.

=46rom those options you listed I would strongly prefer to have an implicit=
=20
scope for each file included in the flat notation. That way, defining a var=
iable=20
in one file would not collide with the same variable in a sibling include.=
=20
Variables from outer scopes would still be available in inner scopes. For=20
people that would want to have their "global" definitions in a separate=20
include, I would recommend creating a new keyword like global or export tha=
t=20
would tie a variable to the top-level scope and thus make it available to=20
everyone. I don't think that would be that hard to implement and I may try =
to=20
if we agree on it.

Anyway there should definitely be a way to de-register (undefine) a variabl=
e=20
from a scope to prevent a misuse due to typos.

By the way, can we restructure the FW using nesting and still be able to=20
retain all per-customer rules in a single file? Wouldn't that require us to=
=20
split prerouting, postrouting, forward and other rules to separate scopes/
table definitions? That would be highly inconvenient.

=2D-=20
S pozdravem,

David Fabian
Cluster Design, s.r.o.
