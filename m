From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: new iptables policy match
Date: Thu, 12 Jan 2006 11:59:29 -0600
Message-ID: <925A849792280C4E80C5461017A4B8A26DAE@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>, "Marco Berizzi" <pupilla@hotmail.com>
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

Just to be completely anal because I'm just a skinny=20
bald guy from Minnesota - is this ASCII art right?
If this is right, maybe this would make the man page
even clearer.  Of course, if it's wrong, that means
I still don't get it.


LAN    FW   Internet   FW    LAN
<----+----+----------+----+----->
     |    |          |    |
Private  Public   Public  Private
    IP    IP        IP     IP

 Tunnel   SA        SA   Tunnel
 endpoint                endpoint


- Greg Scott


-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of
Patrick McHardy
Sent: Thursday, January 12, 2006 10:31 AM
To: Marco Berizzi
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: new iptables policy match


Marco Berizzi wrote:
> Ok. Here is my suggestion:
>=20
> --tunnel-src addr[/mask]
> matches the source end-point address of the SA. Only valid with --mode

> tunnel
>=20
> --tunnel-dst addr[/mask]
> matches the destination end-point address of the SA. Only valid with=20
> --mode tunnel

Thanks, I've updated the man-page.
