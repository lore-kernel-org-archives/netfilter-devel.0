From: "James R. Leu" <jleu@mindspring.com>
Subject: Re: [mpls-linux-general] Kernel Compilation
Date: Thu, 24 Oct 2002 11:08:41 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021024110841.B27126@nero.doit.wisc.edu>
References: <046101c27b6e$44e2abc0$1543a8c0@sanches>
Reply-To: jleu@mindspring.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: mpls-linux-general@lists.sourceforge.net,
   RSVP <ds_mpls@atlantis.rug.ac.be>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alexandre Carlos <alexandre@redes.unb.br>
In-Reply-To: <046101c27b6e$44e2abc0$1543a8c0@sanches>; from alexandre@redes.unb.br on Thu, Oct 24, 2002 at 12:01:42PM -0300
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

User mpls-linux kernel patch 1.170.  1.160 had a bug when trying to
compile with netfilter MPLS target (BTW the instructions on the RSVP-TE p=
age
said NOT to turn on the MPLS target .... reading the instructions helps .=
...)

On Thu, Oct 24, 2002 at 12:01:42PM -0300, Alexandre Carlos wrote:
> Hi all,
>=20
> I=B4m trying do colmpile the kernel 2.4.29 to suport rsvp-te with the f=
ollowin
> software and patches
>=20
> KERNEL_2.4.19_MPLS160.patch,
>         iptables-1.2.4-dscp.tgz,
> 	DSMPLS+IP.patch
>         iproute2-current.tar.gz and rsvpd.0.70-rcx.tgz.
>=20
> ipt_MPLS.c: In function `target':
> ipt_MPLS.c:23: warning: passing arg 1 of `mpls_set_nexthop' from
> incompatible pointer type
> ipt_MPLS.c:23: warning: passing arg 2 of `mpls_set_nexthop' makes point=
er
> from integer without a cast
> ipt_MPLS.c:23: too few arguments to function `mpls_set_nexthop'
> ipt_MPLS.c:20: warning: unused variable `i'
> make[3]: ** [ipt_MPLS.o] Erro 1
> make[3]: Saindo do diret=F3rio `/usr/src/linux-2.4.19/net/ipv4/netfilte=
r'
> make[2]: ** [first_rule] Erro 2
> make[2]: Saindo do diret=F3rio `/usr/src/linux-2.4.19/net/ipv4/netfilte=
r'
> make[1]: ** [_subdir_ipv4/netfilter] Erro 2
> make[1]: Saindo do diret=F3rio `/usr/src/linux-2.4.19/net'
> make: ** [_dir_net] Erro 2
>=20
> Can some on help me please?
>=20
> Alex
>=20
>=20
>=20
> -------------------------------------------------------
> This sf.net email is sponsored by: Influence the future=20
> of Java(TM) technology. Join the Java Community=20
> Process(SM) (JCP(SM)) program now.=20
> http://ad.doubleclick.net/clk;4729346;7592162;s?http://www.sun.com/java=
vote
> _______________________________________________
> mpls-linux-general mailing list
> mpls-linux-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/mpls-linux-general

--=20
James R. Leu
