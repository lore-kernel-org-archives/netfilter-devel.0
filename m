From: Markus Schaber <markus.schaber@student.uni-ulm.de>
Subject: Re: using a hash table for netfilter tables?
Date: Fri, 25 Apr 2003 08:10:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030425081050.1d2657bf.markus.schaber@student.uni-ulm.de>
References: <20030424184706.GM8524@ns.snowman.net>
	<Pine.LNX.4.33.0304241547520.8241-100000@fantomas.insite.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.33.0304241547520.8241-100000@fantomas.insite.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

Andre Uratsuka Manoel <andre@insite.com.br> schrieb:

> On Thu, 24 Apr 2003, Stephen Frost wrote:
>=20
> > * Andre Uratsuka Manoel (andre@insite.com.br) wrote:

> 	I have to have different rules for 5.000 different IP addresses=20
> and I have to be able to change them any time in any order, in a very=20
> small time.=20

Are those different IP-addresses in a common subnet (or inside a few of
those)?

Then you could take a look at the IP-Pools, as far as I know the most
current (but apparently unmaintained) version is at:

http://gandalf.hjorten.nu/ippool/

Here at the university of Ulm, we tested this version because we have
just the same problem, but due to lack of manpower, we didn't make the
"real switchover" from checkpoint up to now, but it is planned to do it
in the next weeks.

Gru=DF,
Markus

--=20
Schabi's Flohmarkt: http://schabi.de/flohmarkt/

Der Dienstweg ist die Verbindung der Sackgasse mit dem Holzweg!
[DoLi in unibwm.studium]
