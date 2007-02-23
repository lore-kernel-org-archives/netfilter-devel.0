From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] Dump mark even if event is a DESTROY event
Date: Fri, 23 Feb 2007 10:45:23 +0000
Message-ID: <45DEC5C3.9020806@ufomechanic.net>
References: <1171964721.26768.4.camel@localhost.localdomain>	<45DC4052.2010305@netfilter.org>
	<1172063584.5413.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1172063584.5413.18.camel@localhost.localdomain>
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

* Eric Leblond wrote, On 21/02/07 13:13:
> Hi,
>=20
> Le mercredi 21 f=E9vrier 2007 =E0 13:51 +0100, Pablo Neira Ayuso a =E9c=
rit :
>> Hi Eric,
>>
>> I don't see why you may need the mark in the destroy message. You can=20
>> keep a cache in userspace with the connections that belong to a certai=
n=20
>> subset and their marks, then if the mark changes, move such connection=
=20
>> the a different subset. It doesn't make sense to me the idea of=20
>> including the mark in the destroy message since such mark didn't chang=
e=20
>> with regards to the previous event delivered.
>=20
> I do not agree with the idea of having a cache in userspace. It has bee=
n
> coded in kernel and for this kind of stuff, once is enough. I really
> want to avoid all synchronisation problems we could have to do this in
> userspace.
>=20
> Furthermore, mark exists to be able to create subset for other tools
> like tc or ip.


I'm with Eric.  I'm already using a patch like his.

Why keep a cache in user-space when there is already a cache in
kernel-space?

There are two clear choices; the old ulogd that keeps a full cache in
user space and receives every packet over netlink; or conntrack that
keeps a whole cache in kernel-space, updates counters in kernel space
and only sends significant updates over netlink.

To replicate the whole conntrack hash in user-space to avoid sending a
couple of bytes over netlink on connection-destroy is to seek after some
kind of optimization that I don't rightly understand.

Sam
