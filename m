From: Jerome de Vivie <jerome.de-vivie@wanadoo.fr>
Subject: Re: match limit with inverse [!]
Date: Sat, 23 Nov 2002 19:24:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DDFC7EC.9A16EB22@wanadoo.fr>
References: <00ae01c292ed$2c125aa0$2a00a8c0@zorro>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: Quoted-Printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Graham- Reg.CA" <graham@reg.ca>,
 	netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Your out of luck. The patch hasn't been applied because it a kernel
header and could disturb older versions of netfilter. The patch is under
http://perso.wanadoo.fr/jerome.de-vivie/ipt/

I hope that core maintainer could applied it now.

Regards,

j.

"Graham- Reg.CA" wrote:
>=20
> Hello,
>=20
> Has the match limit with inverse [!] patch ever been applied to any of =
the
> newer versions of iptables/netfilter?
>=20
> I have a number of DoS attack-type situations and a few special situati=
ons
> (such as limiting outgoing user traffic) that would really benefit from
> this.
>=20
> Putting the exclamation mark in on the command line (as the man pages
> suggest) just seems to be ignored - so we end up dropping all packets b=
elow
> that threshold, not above it.
>=20
> Just wondering if limit ever had the inverse patch (or similar) added t=
o it,
> or if I'm out of luck :(
>=20
> Running Kernel 2.4.18 and a pretty recent version of iptables.
>=20
> Thanks!
>  - Graham.

--=20
J=E9r=F4me de Vivie
