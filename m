From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunoi@info.ucl.ac.be>
Subject: Re: [libipq] Shutdown problem
Date: 04 Jul 2002 09:39:30 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1025768371.1377.59.camel@descartes>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Wei Koong CHAI <eem1wc@eim.surrey.ac.uk>,
	Netfilter list <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: James Morris <jmorris@intercode.com.au>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

le jeu 04-07-2002 =E0 03:47, James Morris a =E9crit :
> On Wed, 3 Jul 2002, Wei Koong CHAI wrote:
>=20
> > that it's not the bridge problem. Most probably, it is with my userspac=
e=20
> > program.=20
>=20
> It shouldn't be possible for the userspace program to cause this.  To=20
> look into this further, I need to know the details of your system=20
> topology, iptables & briding configuration, and all startup and shutdown=20
> messages relating to networking.

I encountered this kind of problem when programming a netfilter module.
And yes, it is probably caused by something in the kernel. I got this
problem when a call to dev_put was missing in my code. The fact that=20
usage count is 14157 (!) consolidates my thought.
Maybe the bridge-nf cause this leak.

- C=E9dric
