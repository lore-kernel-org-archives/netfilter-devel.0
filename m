From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack/NAT module
Date: Tue, 4 Jun 2002 09:56:28 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020604095628.D13631@sunbeam.de.gnumonks.org>
References: <02060312063802.01904@luoqiang>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tgQ0jN0vM+YIGDGO"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: luoqiang <luoqiang@ict.ac.cn>
Content-Disposition: inline
In-Reply-To: <02060312063802.01904@luoqiang>; from luoqiang@ict.ac.cn on Mon, Jun 03, 2002 at 12:06:38PM +0800
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tgQ0jN0vM+YIGDGO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2002 at 12:06:38PM +0800, luoqiang wrote:
> Hi,all
>=20
> Sorry to resend this mail,last mail is not can be seen.
> I am writing a DNAT module to achieve the purpose which is  identical to
>  "iptables -A PREROUTING -t nat -p udp -d 159.226.1.1 --dport 5000 -j DNA=
T=20
> --to 192.168.1.2:5000".
>=20
> host A-------------------------------->host=20
> B------------------------------------->host C
> 159.226.1.2--------------->159.226.1.1/192.168.1.1--------------->192.168=
.1.2
>=20
> I have read the hacking howto and have finished the conntrack module,whic=
h=20
> can be seen in "proc/net/ip_conntrack"=20
> file of host B as"EXPECTING : proto=3D17 src=3D0 dst=3D159.226.1.1 sport=
=3D0=20
> dport=3D5000"
> But something wrong in my nat module.
> After loaded the module, no DNAT happened. :-(
> there are some questions I don't understand.
> 1.what's the function of foo_help in struct ip_nat_helper?I do nothing he=
re.

to mangle (nat) the payload of the master connection (i.e. if it contains
an internal IP address sent by the client behind SNAT to the server).

> 2. what's the function of struct ip_nat_multi_range here?what's the funct=
ion =20
>    of struct ip_nat_range range[0] and  struct ip_nat_range range[1]?(I d=
on't=20
>    know what's the meaning of " hangs off end. ")

hangs off end =3D=3D after the end of the structure

> 3.how to configure the struct ip_nat_multi_range when do DNAT?

look  at line 81... of ip_nat_ftp.c

> 4.if I want to close the port after open it in a module,how I can do?

how do you open a port in a module?  everything you do is creating conntrack
entries and NAT bindings.

> my code is here:
> ......
>   static int foo_nat_expected(struct sk_buff **pksb,
>                           unsigned int hooknum,
>                           struct ip_conntrack *ct,
>                           struct ip_nat_info *info,
>                           struct ip_conntrack *master,
>                           struct ip_nat_info *masterinfo,
>                           unsigned int *verdict)
> =20
>   {
>      struct ip_nat_multi_range mr;
>      u_int32_t newdstip =3D 0x0201a8c0;
>      if (HOOK2MANIP(hooknum)=3D=3DIP_NAT_MANIP_DST){       =20
>  =20
>      mr.rangesize=3D1;
>      mr.range[0].flags =3D IP_NAT_RANGE_PROTO_SPECIFIED;   //  I don't kn=
ow=20
> what's the meaning here

PROTO_SPECIFIED =3D=3D NAT of port
IP =3D=3D NAT of IP address

please look more detailed at the other available examples.

> luoqiang

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--tgQ0jN0vM+YIGDGO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE8/HKsXaXGVTD0i/8RAmLvAKCfeKL222NJVd35UtMjEttw+B/WKgCgtLDC
07W4pBBCMn5lD5AF+SecMFc=
=WSRH
-----END PGP SIGNATURE-----

--tgQ0jN0vM+YIGDGO--
