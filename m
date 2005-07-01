From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: CLUSTERIP problems
Date: Fri, 1 Jul 2005 19:22:20 -0400
Message-ID: <876ef97a050701162247540075@mail.gmail.com>
References: <20050628194026.GA2010@packetconsulting.pl>
	<20050630163535.GA11138@packetconsulting.pl>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Piotr Chytla <pch@packetconsulting.pl>
In-Reply-To: <20050630163535.GA11138@packetconsulting.pl>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On 6/30/05, Piotr Chytla <pch@packetconsulting.pl> wrote:
> On Tue, Jun 28, 2005 at 09:40:26PM +0200, Piotr Chytla wrote:
> > I've problem with CLUSTERIP from 2.6.12 kernel, both nodes run debian
> > sarge on 2.6.12.
> >
> >
> [..]
> > On the first machine I have in logs only this :
> >
> > hash=3D1 ct_hash=3D1 not responsible
> >
> > ARP mangling patch for 2.6.12 is applied :
> >
> > http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D2643
> >
> Problem was in wrong header file ipt_CLUSTERIP.h that is diffrent
> between iptables tree and 2.6.12 kernel .
>=20
> It seems that in struct ipt_clusterip_tgt_info, *config pointer
> was moved up.
>=20
> First file ipt_CLUSTERIP.h.20050630 is from iptables tree second
> one from 2.6.12 kernel.
>=20
> --- ipt_CLUSTERIP.h.20050630    2005-03-07 15:00:35.000000000 +0100
> +++ ipt_CLUSTERIP.h     2005-06-17 21:48:29.000000000 +0200
> @@ -18,6 +18,7 @@
>  struct ipt_clusterip_tgt_info {
>=20
>         u_int32_t flags;
> +       struct clusterip_config *config;
>=20
>         /* only relevant for new ones */
>         u_int8_t clustermac[6];
> @@ -26,12 +27,6 @@
>         u_int16_t local_nodes[CLUSTERIP_MAX_NODES];
>         enum clusterip_hashmode hash_mode;
>         u_int32_t hash_initval;
> -
> -#ifdef KERNEL_64_USERSPACE_32
> -       u_int64_t config;
> -#else
> -       struct clusterip_config *config;
> -#endif
>  };
>=20
>  #endif /*_IPT_CLUSTERIP_H_target*/

You should have used the reverse of this. The header with *config at
the bottom and the #ifdef KERNEL_64_USERSPACE_32 is the one to use
with the kernel and iptables, both.

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
