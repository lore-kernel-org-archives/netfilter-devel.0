From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: Routing decision?
Date: Mon, 15 Sep 2003 18:59:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1063645178.814.2.camel@elendil.intranet.cartel-securite.net>
References: <Pine.LNX.4.44.0309151802300.17421-100000@filer.marasystems.com>
	 <3F65E7E7.70105@able.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Henrik Nordstrom <hno@marasystems.com>,
   netfilter-devel@lists.netfilter.org, pieter@able.be
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wim Ceulemans <wim.ceulemans@able.be>
In-Reply-To: <3F65E7E7.70105@able.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le lun 15/09/2003 =E0 18:25, Wim Ceulemans a =E9crit :
> >Why should it if the routing has already been called once?
> Here's why: if you want to mark packets in the OUTPUT chain that are=20
> http traffic, based
> on the destination port. And then based on that mark send the packets t=
o=20
> another routing table
> added with the ip command.

See below...

> >iptables does route the packet a second time if you mangle or NAT the
> >packet.

If the packet is altered in any way (mangling or NATing), then routing
is called again, because the change(s) can change routing decision.
Marking as you mentionned, but also TOS or source address can be routing
keys.

--=20
http://www.netexit.com/~sid/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
