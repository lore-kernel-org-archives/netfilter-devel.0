From: Eric Leblond <eric@inl.fr>
Subject: Re: libipq Packet queuing Question
Date: Thu, 21 Jul 2005 21:34:56 +0200
Message-ID: <1121974497.5319.5.camel@localhost.localdomain>
References: <E1Dvg7E-0000uW-00@vimh1.rdg.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Duncan Godfrey <d.j.godfrey@reading.ac.uk>
In-Reply-To: <E1Dvg7E-0000uW-00@vimh1.rdg.ac.uk>
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

Le jeudi 21 juillet 2005 =E0 19:49 +0100, Duncan Godfrey a =E9crit :
> Hello,
>=20
> =20
>=20
> Would anyone be able to help me with my libipq development, I'm really
> stuck.

Hi,

You may have a look at nufw (http://www.nufw.org) code which does
intensive use of libipq. Have specially a look in the src/nufw directory
which contains libipq related code.
Doxygen version of one of the file :
	http://www.nufw.org/doxygen/packetsrv_8c.html

> I'm trying to create a QoS app for Linux and I'm using a number of simple
> FIFO queues (just using arrays) to queue the packets before they are
> dispatched in the required order.
>=20
> =20
>=20
> The problem I am having is, apart from my basic knowledge of c, is that y=
ou
> cant queue a pointer. So when you receive the pointer from the method
> ipq_packet_msg_t *m, this cant be queued (e.g. if you queue packets 1,2,3
> they will be dispatched 1,1,1).
>=20
> =20
>=20
> I have tried dereferencing the *m pointer but this doesn't give you a cop=
y
> of the packet it actually seems to give you a blank packet.
>=20
> =20
>=20
> Has anyone designed any packet queuing applications or know of any exampl=
es
> which could point me in the right direction.
>=20
> =20
>=20
> Thank you in advance for your help,
>=20
> =20
>=20
> Duncan Godfrey
>=20
