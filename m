From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: Re: The big Picture of all the tables ...
Date: Mon, 06 Jun 2005 10:00:27 +0200
Message-ID: <1118044827.21909.11.camel@descartes.info.ucl.ac.be>
References: <3abe8064b60ddf1a@mayday.cix.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert de Bath <list-netfilter@debath.co.uk>
In-Reply-To: <3abe8064b60ddf1a@mayday.cix.co.uk>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Le samedi 04 juin 2005 =E0 19:10 +0100, Robert de Bath a =E9crit :
> Hi all,
>=20
> I _think_ the attached picture shows all the predefined chains in all
> the tables that the kernel uses in the order that it uses them (except
> for the raw table).

> 4) Is there anything else that can make a packet deviate (cf: DROP)

The ROUTE target (in pom) was initially designed to directly send a
packet on the wire, on a given interface. In such case, the target is
put on the mangle PREROUTING chain, and the packet that matches the
ROUTE target is re-injected _after_ the mangle POSTROUTING chain (so
that conntrack is not confused by strangely routed packets).

If the --continue option of the ROUTE target is used, then the packet is
routed by the target, and continues its journey through the rules. In
your figure, it should now become obvious to beginners why the use of
the --continue option is most useful in mangle POSTROUTING, and useless
on the PREROUTING chain...

Cedric
