From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: i have problems understanding the "Nat-Reservation"-patch
Date: Wed, 21 Jul 2004 16:23:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1090419794.2471.20.camel@nienna.balabit>
References: <BDEHJGPIKNLKJJBCCFPLAEJKCOAA.listuser@sally.epygi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Markus <listuser@sally.epygi.de>
In-Reply-To: <BDEHJGPIKNLKJJBCCFPLAEJKCOAA.listuser@sally.epygi.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-07-21, sze keltez=E9ssel 15:43-kor Markus ezt =EDrta:
> 1)=20
>  ip_nat_reserved_register(struct ip_conntrack_expect *expect,
> 			 const struct ip_conntrack_manip *manip,
> 			 const u_int16_t proto,
> 			 const struct ip_conntrack_manip *peer)
>=20
>  I understand the manip,proto and peer part, but why do i need=20
>  an expect and for what? Do i have to build one myself, or this
>  a container pointer that already exists?
>=20
> (i am naughty and used __ip_nat_reserved_hash which is doing fine=20
>  for me now but maybe i am missing something, i also have the feeling
>  that the expect is the key to #2)=20

  Actually, the interface of the nat reservations patch was based on the
assumtion that it will be primarily used by NAT helpers, which will
register expectations for secondary channels anyway. Giving this
expectation as an argument of the registration function is important,
because the NAT core has to free those registered reservations, and this
way you get this for free. Actually, tproxy uses a lower-level
interface, however, this way you must take care of unhashing your own
reservations.

  For some background info, see the discussion in the archives:
http://lists.netfilter.org/pipermail/netfilter-devel/2003-November/013152=
.html

> 2)
>  If i have a runtime case where hooknum =3D=3D NF_IP_POST_ROUTING
>  Is there a way to find out if a packet came via=20
>    NF_IP_LOCAL_OUT or via NF_IP_FORWARD ?
>=20
>  I tried to tweak ip_nat_used_tuple with something like
>   	res =3D __ip_nat_reserved_find_tuple(tuple, maniptype);
>=20
> 	if ( res ) {
> -->		if ( hooknum =3D=3D NF_IP_LOCAL_OUT ) {
> 			DEBUGP("ip_nat_used_tuple: IP_NAT_RANGE_USE_RESERVED overwrite for l=
ocal aka reserved for us\n");
> 			..proceed normal as if not reserved...
> 		}
> 	}
>=20
>  Unfortunatly my reservation (as the src is reserved)
>  will be found of course when hooknum =3D=3D NF_IP_POST_ROUTING,
>  but than i can't decide if i can "use" this reservation or not.
>=20
>  I am trying to reserve a certain port for a service
>  running on the same machine as netfilter. Peeking at
>  tproxy i come as far as reserving a manip tuple:
>    say 10.20.10.193:5060 (no peer)
>  It is so far reserved for everyone, now i need a way
>  to "use" this reservation (aka reserved by me), that
>  leads to #3.
>=20
> 3)
>  IP_NAT_RANGE_USE_RESERVED seems to do the trick and
>  i can find from tproxy that it is set as a flag to=20
>  a multi_range (whatever this is). What do i have to
>  do to "use" a simple reservation.=20

  That flag is exactly for telling ip_nat_setup_info() to use the given
tuple even if it clashes with a reservation. Of course this method
requires cooperation of all users of nat reservations, that is, you must
not set that flag unless you are sure, that you managed to reserve
exactly that range which you specify in the multi_range. (Yes, I know,
it is rather ugly that you have to specify that flag in the multi_range,
but unfortunately I cannot see any other way to specify flags to
ip_nat_setup_info(). For TProxy, we've added an extra flags argument to
that function, it would be great for nat-reservations as well. However,
this would mean breaking all NAT helpers in PoM-ng...)

--=20
 Regards,
   Krisztian KOVACS
