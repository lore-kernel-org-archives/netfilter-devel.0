From: Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH 1/3] Netfilter: Remove ip_conntrack_tuple_hash "ctrack"
Date: Mon, 24 Jan 2005 11:08:59 +0100
Message-ID: <jellajqguc.fsf@sykes.suse.de>
References: <1105444254.19331.43.camel@localhost.localdomain>
	<m3k6q52ubw.fsf@igel.m5r.de>
	<1106535381.19666.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1106535381.19666.6.camel@localhost.localdomain> (Rusty
	Russell's message of "Mon, 24 Jan 2005 13:56:21 +1100")
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

Rusty Russell <rusty@rustcorp.com.au> writes:

> On Sat, 2005-01-22 at 19:26 +0100, Andreas Schwab wrote:
>> Rusty Russell <rusty@rustcorp.com.au> writes:
>>=20
>> > Index: linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_c=
onntrack_tuple.h
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> > --- linux-2.6.10-bk13-Netfilter.orig/include/linux/netfilter_ipv4/ip=
_conntrack_tuple.h	2005-01-11 21:04:11.743513264 +1100
>> > +++ linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_conn=
track_tuple.h	2005-01-11 21:05:20.015134400 +1100
>> > @@ -64,7 +64,10 @@
>> >  		} u;
>> > =20
>> >  		/* The protocol. */
>> > -		u_int16_t protonum;
>> > +		u8 protonum;
>> > +
>> > +		/* The direction (for tuplehash) */
>> > +		u8 dir;
>> >  	} dst;
>> >  };
>> > =20
>>=20
>> Doesn't this break the iptables conntrack module on big-endian systems=
?
>
> I don't see why... we only need 8 bits for the protocol, and we used to
> use 16 (because we had them).  I wanted to add a field, so I reduced
> protonum to 8 bits and added another 8 bit field.

iptables uses this structure internally.  If it also uses it inside a
kernel interface then you have broken the kernel ABI.

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
Key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
