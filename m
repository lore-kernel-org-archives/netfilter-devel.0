From: James Morris <jmorris@intercode.com.au>
Subject: Re: Libipq and invalid packet_id
Date: Thu, 26 Jun 2003 23:40:40 +1000 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0306262338450.13494-100000@excalibur.intercode.com.au>
References: <1056611194.32622.20.camel@porky>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eric Leblond <eric@regit.org>
In-Reply-To: <1056611194.32622.20.camel@porky>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 26 Jun 2003, Eric Leblond wrote:

> Le jeu 26/06/2003 =E0 02:40, James Morris a =E9crit :
> > On 26 Jun 2003, Eric Leblond wrote:
> > > 	- Is this a wanted feature ?
> >=20
> > No.
>=20
> So I've got other related questions :
> 	- How is memory managed, ie what's happen if we queue a lot of packet
> without setting any verdict ?

There is a tunable queue length, and packets are dropped once it fills up.

> 	- In particular, what's happened if we do successive call to
> ipg_getmessage ? Do ipg_getmessage reuse address space after each call =
?

Do you mean ipq_get_packet() ?  It's just a wrapper which reads one=20
netlink message from your local receive buffer.


- James
--=20
James Morris
<jmorris@intercode.com.au>
