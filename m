From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: more questions about kernel config options for iptables
Date: 08 Apr 2003 14:59:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049806772.11714.187.camel@elendil.intranet.cartel-securite.net>
References: <Pine.LNX.4.44.0304080806380.10072-100000@dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: iptables mailing list <netfilter@lists.netfilter.org>,
   Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
In-Reply-To: <Pine.LNX.4.44.0304080806380.10072-100000@dell>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le mar 08/04/2003 =E0 14:23, Robert P. J. Day a =E9crit :
> in other words, you're building in a *support system* for unselected
> features, but without actually picking these features, it's not
> doing you much good.  that's why i was thinking that a reworking
> of that entire config menu might be in order -- why let users
> pick what turns out to be a non-functional set of options?

It is not really non-functional. If I were a developper, I could build a
kernel with IP tables selected and no table, just to test the table I am
developping. That's just an example, but I think someone can find some
good reason ;)
I must admit that, from a strict user poijnt of vue, I can't see any
good reason.

> it would make far more sense to have a list of menu options
> that reflects what a user would want to *do*, and have the
> underlying dependencies kept invisible.  a more readable menu
> like:
>=20
>    Basic filtering
>      Connection tracking
>    NAT
>    Packet mangling

This does not reflect reality. Connection tracking does not depend on
basic filtering. It's even completly independent form it. It does not
depend on NAT either.

> gotcha.  if you want masq/NAT, you would have to select
> not only Connection tracking, but IPtables support and,
> within that, "Full NAT".  and that's why i dislike the current
> menu layout.  it would be more reasonable for someone to say,
> "i want NAT", and have the underlying dependencies automatically
> satisfied.

I see your point. But I do think connection tracking has to appear as a
independent choice. But some conntrack dependencies could appear
non-selected. As an example, NAT could appear anyway, and if you were to
select it, then it would automaticly select connection tracking as well.
I don't know if it's possible to do such dependencies into kernel
configuration (in fact, I don't think so).

My 0.02=A4 about this is that I personaly prefer a configuration script
that reflect reality, than something more "user convenient" that could
fool people about the way things work. Netfilter insides, as well as
kernel insides, are already complicated enough to me, for I do not need
stuff that could make me misunderstand something. Reality is that NAT
depends on conntrack. Your point would be to invert this for user's
sake, and this is, imho, a baaaaad thing ;)

I don't know if any of them are reading this thread, but if we could
have some core developper's point of vue about his, would be great.

It is a very tough subject to discuss how kernel configuration must be
presented. I wouldn't show nerd's behaviours, e.g. dumb users do not
compile kernel, but I tend to think that if someone wants to build its
own kernel, then it's up to him to (try to ?) understand how it is going
and what are the choices he's about to make.


Cc netfilter-devel.

--=20
C=E9dric Blancher  <blancher@cartel-securite.fr>
IT systems and networks security - Cartel S=E9curit=E9
Phone : +33 (0)1 44 06 97 87 - Fax: +33 (0)1 44 06 97 99
PGP KeyID:157E98EE  FingerPrint:FA62226DA9E72FA8AECAA240008B480E157E98EE
