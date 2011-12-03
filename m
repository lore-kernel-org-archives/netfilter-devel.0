From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: doc: Secure use of iptables and connection tracking helpers
Date: Sat, 03 Dec 2011 14:33:19 +0000
Message-ID: <4EDA332F.2010409@googlemail.com>
References: <1322501576.20587.22.camel@tiger.regit.org>			 <1322906769.8042.4.camel@hakkenden.homenet>		 <1322911416.603.2.camel@ice-age.regit.org>		 <4EDA1BE9.4060703@googlemail.com>	 <1322917503.2568.2.camel@ice-age.regit.org>	 <4EDA2715.7030006@googlemail.com> <1322919966.2568.5.camel@ice-age.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1322919966.2568.5.camel@ice-age.regit.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


> Most of them have been fixed by Jan, I will have a cautious look.
>  =20
Much better (in addition to what I posted previously) :-D :

p.1 "tranfers" should be "transfers"
p.1 "This system lays on parsing of data coming or from the user or fro=
m=20
the server. It is thus subject to attack and this is necessary to take=20
some protections when using connection tracking helpers" should be "The=
=20
system relies on parsing of data coming either from the user or the=20
server. It is, therefore, vulnerable and ("all the necessary=20
precautions"/"great care") must be taken when using connection tracking=
=20
helpers."
p.1 "tracking helpers are thus dependent on" should be "tracking helper=
s=20
are therefore dependent on"
p.2 "and it is thus deactivated by default." should be "and it is=20
therefore deactivated by default."
p.2. "They permit to activate the extended but dangerous features of=20
some protocols." should be "They permit activation of the extended, but=
=20
dangerous, features of some protocols."
p.3 "All iptables lines using =E2=80=9C-m state --state RELATED=E2=80=9D=
 should be used=20
in conjunction with the choice of a helper. Doing that, you " should be=
=20
"The following iptables statement should be used in conjunction with th=
e=20
choice of a helper:- =E2=80=9C-m state --state RELATED=E2=80=9D. By doi=
ng that, you"
p.4 "In particular, you have to do a strict anti-spoofing (has describe=
d=20
below)" should be "In particular, you have to do strict anti-spoofing=20
(as described below)"
p.4 "For example, let=E2=80=99s say we have a FTP server at IP address =
1.2.3.4=20
running on port 2121" should be "For example, let=E2=80=99s say we have=
 FTP=20
server running on IP address 1.2.3.4 and port 2121"
p.4 "We thus recommand NOT to use module options any more, and use the=20
CT target instead" should be "Therefore, the use of module options is=20
NOT recommended any more - please use the CT target instead."
p.4 "Each wanted helper use is then set by using a call to the CT=20
target." should be "Each helper we need to use is then set by a call to=
=20
the CT target."

> Arghh, the only one link I did not update after the renaming of the
> file:
> http://home.regit.org/wp-content/uploads/2011/11/secure-conntrack-hel=
pers.pdf
>
> I'm hidding...
>  =20
No worries, I enjoyed reading this and it was educational for me too!

