From: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
Subject: Re: policy routing on locally generated packets
Date: 26 Aug 2003 20:47:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1061923668.1220.4.camel@drs0.manchotnetworks.net>
References: <1061813400.1289.36.camel@drs0.manchotnetworks.net>
	<3F4A01BE.1090805@trash.net> <3F4A2795.3030805@trash.net>
	<1061837608.1333.9.camel@drs0.manchotnetworks.net>
	<20030825190750.GH423@oknodo.bof.de>
	<1061887675.1273.37.camel@drs0.manchotnetworks.net>
	<20030826110913.GI423@oknodo.bof.de>
	<1061899307.5437.10.camel@drs0.manchotnetworks.net>
	<1061900059.447.8.camel@descartes>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
In-Reply-To: <1061900059.447.8.camel@descartes>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Bonsoir Cedric,

Yes I know about your patch and actually reccomended it the other day.
It was in fact the the thread concerning routing policly on locally
generated packets that got me started with this thread. It has been a
subject on lartc from time to time, and I thought I might take a stab at
getting it solved.

Although I'm not a programmer, I have a feeling that the OUTPUT ROUTING
process was left out of netfilter for a good reason, although I'm not
adept enough to specifically identify why.

I'm on the road tomorrow, but in the evning, I'll do another post that
includes a schema that will hopefully clarify the issue.

Meilleures Salutations

Charles


On Tue, 2003-08-26 at 14:14, Cedric de Launois wrote:
> Le mar 26/08/2003 =E0 14:01, lartc@manchotnetworks.net a =E9crit :
> > My example of traffic accounting is a very simple one -- I have seen
> > other requests on lartc to mangle packets during the OUTPUT ROUTING
> > process -- doing so makes it application independant. I personally
> > believe that it would be of high benefit, but of course, I am often
> > wrong!
>=20
> Did you try the ROUTE target ?
>=20
> Cedric
>=20
>=20
>=20
