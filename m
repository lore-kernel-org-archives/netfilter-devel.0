From: Oscar Mechanic <oscar@ufomechanic.net>
Subject: Re: bandwidth saving idea
Date: Mon, 11 Jul 2005 15:38:57 +0100
Message-ID: <1121092737.4967.62.camel@OSCARLAPLIN>
References: <20050701004115.34697.qmail@web26507.mail.ukl.yahoo.com>
	<42C853F4.6010702@outerspace.dyndns.org>
	<1121087802.4967.35.camel@OSCARLAPLIN>
	<1121088394.26639.8.camel@localhost.localdomain>
Reply-To: oscar@ufomechanic.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1121088394.26639.8.camel@localhost.localdomain>
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

On Mon, 2005-07-11 at 15:26 +0200, Eric Leblond wrote:=20
> Le lundi 11 juillet 2005 =C3=A0 14:16 +0100, Oscar Mechanic a =C3=A9cri=
t :
> > Machine A sends a packet to machine B. As the packet passes through
> > If the same packet is sent again through A it does not send the paylo=
ad
> > to Machine B but sends the checksum. B sees the checksum finds the
> > payload and replaces the checksum with the payload.
>=20
> Well, there's a problem with protocol like TCP, you've got SEQ number
> and other flags in TCP header that are changing even if the datas
> contained in the packet are the same. Thus your compression protocol is
> not efficient. Even a 1000 unit FIFO is useless. Furthermore, your
> protocol is theoritically wrong, as checksum functions are not
> injective.
>=20
> You better try to set up an ipsec tunnel with compression between the
> two machines. On protocol other than citrix, this can bring you a good
> compression level (30% or more if I recall correctly some tests I've
> made).
>=20
> BR,

Thank you for your response I have looked at ipcomp in detail and find
it a mature and well developed protocol.=20

The TCP flags would have to be short sequenced to numeric codes. The
sequence number I will have to think about, as a single packet in the
stream is fine as it would have the same SEQ number.=20

Products that work similar to this are already available and as they
most probably already using a BSD or Linux as an RTOS we will just have
to wait forever to see the code.

I do not understand "checksum functions are not injective" my intention
was to hold a name=3Dvalue list where name is checksum and value is
payload (or reference to payload on disc/FC/RD).=20

Regards
Oscar Mechanic
