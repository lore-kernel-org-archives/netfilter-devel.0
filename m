From: Markus Schaber <markus.schaber@student.uni-ulm.de>
Subject: Re: [Fwd: ACCEPT/DROP]
Date: Sat, 21 Dec 2002 15:12:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021221151236.6415e760.markus.schaber@student.uni-ulm.de>
References: <3E03211E.20900@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3E03211E.20900@cox.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hallo,

Venkatesh Prasad Ranganath <vranganath@cox.net> schrieb:

> I was looking into the iptables implementation and was intrigued about
> how iptables would handle a situation in which we have identical rules
> except for their targets which are contradicting, say ACCEPT and DROP.

This is a problem that _must_ be solved by the human being, because
equality of rules (as for other computer code) _cannot_ be computed.

(Equality of code is a broad area in computer science, e. G. a compiler
maker should be able to prove that the code after the optimization is
equal to the code before. It there is no general algorithm to prove the
equality of code, and it is proven that such an algorithm cannot exist,
except for very special cases. If you're interested in this subject, I
can give you some sources.)
=20
>  By looking at ipt_do_table() function it seems that the first=20
> non-IPT_RETURN  verdict from any standard target will end the
> traversal of a chain of a table, which seems to be a bit odd.  First,
> such conflicting rules must not be allowed.  Even beyond, this fails
> in the situation where you have a dropping rule added after an
> accepting rule.

Yes, and that's how iptables works. The creator of rules has to put the
rules into the correct order (that's why one can insert and remove rules
at arbitrary points).

> For example, a packet from m.n.o.p to a.b.c.d would be accepted at=20
> a.b.c.d because of the first rule, although it had to be dropped=20
> according to the second rule.   And this would result because of the=20
> order in which the rules are added to the table.
>=20
> iptables -A INPUT -d a.b.c.d -j ACCEPT
> iptables -A INPUT -s m.n.o.p -j DROP
>=20
> Is my understanding correct?

Yes.

This is because your rules above say that traffic to a.b.c.d has to be
accepted from everywhere, and for all other possible destinations, drop
traffic from m.n.o.p.

This makes sense e. G. in case m.n.o.p is a portscanner, and you want to
block him except for your mail server a.b.c.d, so that he can answer on
your mailed complaint.

If you want to drop traffic for m.n.o.p even to a.b.c.d, you simply
change the order of the above rules.

>  If so, I am curious to know how nf-hipac behaves in such situations?

I didn't look into nf-hipac this far, but I don't think they can be much
different in this way.

Gru=DF,
Markus

--=20
Markus Schaber - http://www.schabi.de/

Schabi's Flohmarkt unter http://schabi.de/flohmarkt
