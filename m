From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Wed, 17 Mar 2004 22:34:20 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403172230510.11069-100000@filer.marasystems.com>
References: <1079551538.1424.23.camel@anduril.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Victor Julien <victor@nk.nl>, <netfilter@lists.netfilter.org>,
   Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric Blancher <blancher@cartel-securite.fr>
In-Reply-To: <1079551538.1424.23.camel@anduril.intranet.cartel-securite.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Mar 2004, Cedric Blancher wrote:

> Le mer 17/03/2004 =E0 19:46, Victor Julien a =E9crit :
> > My program (written in c) creates rules by opening a pipe to=20
> > /sbin/iptables. However this is quite slow with large rulessets and o=
n=20
> > slow hardware. Is there another way, like an iptables librarycall or=20
> > something?
>=20
> You could use iptables libs that stand in /usr/lib/iptables, just like
> iptables does.

Or actually the preferred interface for this type of operations is to use=
=20
iptables-restore, the batch version of iptables. The speed difference fro=
m=20
using iptables-restore and direct calls is pretty minimal by any means.

libiptc is an internal interface of the iptables source tree and is
subject to change at any time. This should not be used directly unless yo=
u=20
have very good reasons.

Regards
Henrik
