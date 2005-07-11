From: Eric Leblond <eric@inl.fr>
Subject: Re: bandwidth saving idea
Date: Mon, 11 Jul 2005 15:26:34 +0200
Message-ID: <1121088394.26639.8.camel@localhost.localdomain>
References: <20050701004115.34697.qmail@web26507.mail.ukl.yahoo.com>
	<42C853F4.6010702@outerspace.dyndns.org>
	<1121087802.4967.35.camel@OSCARLAPLIN>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: oscar@ufomechanic.net
In-Reply-To: <1121087802.4967.35.camel@OSCARLAPLIN>
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

Le lundi 11 juillet 2005 =E0 14:16 +0100, Oscar Mechanic a =E9crit :
> Machine A sends a packet to machine B. As the packet passes through
> If the same packet is sent again through A it does not send the payload
> to Machine B but sends the checksum. B sees the checksum finds the
> payload and replaces the checksum with the payload.

Well, there's a problem with protocol like TCP, you've got SEQ number
and other flags in TCP header that are changing even if the datas
contained in the packet are the same. Thus your compression protocol is
not efficient. Even a 1000 unit FIFO is useless. Furthermore, your
protocol is theoritically wrong, as checksum functions are not
injective.

You better try to set up an ipsec tunnel with compression between the
two machines. On protocol other than citrix, this can bring you a good
compression level (30% or more if I recall correctly some tests I've
made).

BR,
--=20
Eric Leblond <eric@inl.fr>
