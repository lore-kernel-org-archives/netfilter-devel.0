From: "Alexandre Carlos" <alexandre@redes.unb.br>
Subject: Kernel Compilation
Date: Thu, 24 Oct 2002 12:01:42 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <046101c27b6e$44e2abc0$1543a8c0@sanches>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "RSVP" <ds_mpls@atlantis.rug.ac.be>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <mpls-linux-general@lists.sourceforge.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I=B4m trying do colmpile the kernel 2.4.29 to suport rsvp-te with the fol=
lowin
software and patches

KERNEL_2.4.19_MPLS160.patch,
        iptables-1.2.4-dscp.tgz,
	DSMPLS+IP.patch
        iproute2-current.tar.gz and rsvpd.0.70-rcx.tgz.

ipt_MPLS.c: In function `target':
ipt_MPLS.c:23: warning: passing arg 1 of `mpls_set_nexthop' from
incompatible pointer type
ipt_MPLS.c:23: warning: passing arg 2 of `mpls_set_nexthop' makes pointer
from integer without a cast
ipt_MPLS.c:23: too few arguments to function `mpls_set_nexthop'
ipt_MPLS.c:20: warning: unused variable `i'
make[3]: ** [ipt_MPLS.o] Erro 1
make[3]: Saindo do diret=F3rio `/usr/src/linux-2.4.19/net/ipv4/netfilter'
make[2]: ** [first_rule] Erro 2
make[2]: Saindo do diret=F3rio `/usr/src/linux-2.4.19/net/ipv4/netfilter'
make[1]: ** [_subdir_ipv4/netfilter] Erro 2
make[1]: Saindo do diret=F3rio `/usr/src/linux-2.4.19/net'
make: ** [_dir_net] Erro 2

Can some on help me please?

Alex
