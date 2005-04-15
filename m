From: "Gary W. Smith" <gary@primeexalia.com>
Subject: RE: Modifications to netmap target
Date: Fri, 15 Apr 2005 13:28:33 -0700
Message-ID: <27594E8BA9D5CA458F5EF87D88B6B48F1D52@pxtvjoexd01.pxt.primeexalia.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Pablo Neira" <pablo@eurodev.net>
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

Well, if for some reason I need to access a server using the external IP =
from the firewall itself it would respond to itself and not map it to =
the NAT'd server.=20
=20
What happens for me is that our DNS resolves to the external IP and then =
when the firewall does things like send out alerts via email, etc it =
would bounce to itself.  There were a few other issues that I had a =
couple years ago but I can't remember then off the top of my head.  But =
anyways, putting the rules in the output nat for DNAT always solved =
those problem letting the firewall/gateway know that these addresses =
weren't local to itself.
=20
Try doing a pre/post snat/dnat on the firewall and then try to make a =
connection (such as ssh) the the nat'd IP and you'll see what I mean.  =
You'll still be on the firewall.
=20
We accomplish this with 128 lines of nat'ing in the output chain.  by =
using netmap we drop it to 4 (because I have some subneting going on.
=20
Gary
=20

________________________________

From: Pablo Neira [mailto:pablo@eurodev.net]
Sent: Fri 4/15/2005 1:27 PM
To: Gary W. Smith
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: Modifications to netmap target



Gary W. Smith wrote:
> After talking to Jason over on the netfilter users list about netmap =
target I found that it doesn't support the output chain of nat.
>=20
> I was looking through the code and found that it only registers itself =
with the pre and post route chains.  I was wondering if adding support =
for the output chain was as simple as adding the hook for the local_out =
and then ensuring that the correct modifications are made.  The =
following looks logically correct from looking into some of the source =
code for other modules.  Would more be required to make the ouput nat =
work with netmap?
>=20
> Example.
>         if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << =
NF_IP_POST_ROUTING))) {
>                 DEBUGP(MODULENAME":check: bad hooks %x.\n", =
hook_mask);
>                 return 0;
>         }
> to:
>         if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << =
NF_IP_POST_ROUTING) | (1 << NF_IP_LOCAL_OUT) )) {
>                 DEBUGP(MODULENAME":check: bad hooks %x.\n", =
hook_mask);
>                 return 0;
>         }
>=20
> and
>    if (hooknum =3D=3D NF_IP_PRE_ROUTING)
>                 new_ip =3D (*pskb)->nh.iph->daddr & ~netmask;
>         else
> to:
>    if (hooknum =3D=3D NF_IP_PRE_ROUTING || hooknum =3D=3D =
NF_IP_LOCAL_OUT)
>                 new_ip =3D (*pskb)->nh.iph->daddr & ~netmask;
>         else
>=20
> I put the above changes in and compiled and I was able load the table =
but I'm not sure what the other imacts might be.  Comments would be =
greatly appreciated.
>=20
> /sbin/iptables -t nat -A PREROUTING -d 10.0.0.56/29  -j NETMAP --to =
10.0.0.80/29
> /sbin/iptables -t nat -A POSTROUTING -s 10.0.0.80/29 -j NETMAP --to =
10.0.0.56/29
> /sbin/iptables -t nat -A OUTPUT -d 10.0.0.56/29  -j NETMAP --to =
10.0.0.80/29

There's something that I don't understand yet, why you want to use
NETMAP in the OUTPUT chain ?

--
Pablo
