From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: OpenBSD Firewall Failover with pfsync and CARP, Netfilter solutions?
Date: Sun, 4 Apr 2004 13:18:51 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040404101851.GA19532@edu.joroinen.fi>
References: <20040330153008.GH1237@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20040330153008.GH1237@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Mar 30, 2004 at 05:30:08PM +0200, Herve Eychenne wrote:
>  Hi,
>=20
> This is not stricly netfilter related, but it might be of some
> interest for those who are working on this issue for Linux.
> It's always good to stay tuned and see what others are doing.
>=20
> OpenBSD Firewall Failover with pfsync and CARP:
> http://www.countersiege.com/doc/pfsync-carp/
>=20
> UCARP - Common Address Redundancy Protocol (CARP) for Unix:
> http://www.ucarp.org/
>=20

I noticed this one too.. I'm wondering, if there is same functionality
available for Linux ?

ucarp runs on Linux too, as does vrrp, but the pfsync-part seems to be
missing.. ?

Is there any way to synchronize the state tables of two Linux/Netfilter
boxes?

box1: cat /proc/net/ip_conntrack > file
box2: cat file > /proc/net/ip_conntrack

That would be a good start.. :)

-- Pasi K=E4rkk=E4inen
      =20
                                   ^
                                .     .
                                 Linux
                              /    -    \
                             Choice.of.the
                           .Next.Generation.
