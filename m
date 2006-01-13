From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: new iptables policy match
Date: Fri, 13 Jan 2006 15:18:06 -0600
Message-ID: <925A849792280C4E80C5461017A4B8A26DBB@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, Marco Berizzi <pupilla@hotmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
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

> No, the tunnel endpoints are the hosts using the=20
> tunnel-mode SA, so in this case both firewalls.

OK, so now I'm confused.  And admittedly, IPSEC has made
me crazy for several years.  Which NICs on the firewalls
are the endpoints?  Is this picture better and more accurate?


  LAN             Internet             LAN
 <----+--FW---+-------------+--FW---+----->
      |       |             |       |
NIC with  NIC with      NIC with  NIC with
private    public        public   private
  IP        IP <---------> IP       IP
                   SA
          Tunnel          Tunnel
         endpoint        endpoint

So the public NICs are the tunnel endpoints?

- Greg



-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Friday, January 13, 2006 1:02 AM
To: Greg Scott
Cc: Marco Berizzi; netfilter-devel@lists.netfilter.org
Subject: Re: new iptables policy match


Greg Scott wrote:
> Just to be completely anal because I'm just a skinny
> bald guy from Minnesota - is this ASCII art right?
> If this is right, maybe this would make the man page
> even clearer.  Of course, if it's wrong, that means
> I still don't get it.
>=20
>=20
> LAN    FW   Internet   FW    LAN
> <----+----+----------+----+----->
>      |    |          |    |
> Private  Public   Public  Private
>     IP    IP        IP     IP
>=20
>  Tunnel   SA        SA   Tunnel
>  endpoint                endpoint

No, the tunnel endpoints are the hosts using the tunnel-mode SA, so in
this case both firewalls.
