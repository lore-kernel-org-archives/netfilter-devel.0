From: Patrick McHardy <kaber@trash.net>
Subject: Re: [2.6.21-rc{3,4} problem]: missing dependency on NF_NAT
Date: Sat, 17 Mar 2007 15:58:46 +0100
Message-ID: <45FC0226.2010305@trash.net>
References: <bd87e7590703170738q2363274fx120630d5d4e3279@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060401000203020202090307"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	linux-kernel@vger.kernel.org
To: Kevin Baradon <kevin.baradon@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <bd87e7590703170738q2363274fx120630d5d4e3279@mail.gmail.com>
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

This is a multi-part message in MIME format.
--------------060401000203020202090307
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Kevin Baradon wrote:
> Compiling kernel 2.6.21-rc3 gives me the following errors :
>=20
>  LD      .tmp_vmlinux1
> net/built-in.o: dans la fonction =AB nfnetlink_parse_nat_proto =BB:
> nf_conntrack_netlink.c:(.text+0x28db9): r=E9f=E9rence ind=E9finie vers =
=AB
> nf_nat_proto_find_get =BB
> [...]
>=20
> Also occurs with 2.6.21-rc4.
> Setting CONFIG_NF_NAT to 'y' fixes problem.


Thanks, I queued this patch, which should fix it.

--------------060401000203020202090307
Content-Type: text/plain;
 name="x"
Content-Disposition: inline;
 filename="x"
Content-Transfer-Encoding: quoted-printable

[NETFILTER]: nf_conntrack_netlink: add missing dependency on NF_NAT

NF_CT_NETLINK=3Dy, NF_NAT=3Dm results in:

 LD      .tmp_vmlinux1
 net/built-in.o: dans la fonction =AB nfnetlink_parse_nat_proto =BB:
 nf_conntrack_netlink.c:(.text+0x28db9): r=E9f=E9rence ind=E9finie vers =AB=
 nf_nat_proto_find_get =BB
 nf_conntrack_netlink.c:(.text+0x28dd6): r=E9f=E9rence ind=E9finie vers =AB=
 nf_nat_proto_put =BB
 net/built-in.o: dans la fonction =AB ctnetlink_new_conntrack =BB:
 nf_conntrack_netlink.c:(.text+0x29959): r=E9f=E9rence ind=E9finie vers =AB=
 nf_nat_setup_info =BB
 nf_conntrack_netlink.c:(.text+0x29b35): r=E9f=E9rence ind=E9finie vers =AB=
 nf_nat_setup_info =BB
 nf_conntrack_netlink.c:(.text+0x29cf7): r=E9f=E9rence ind=E9finie vers =AB=
 nf_nat_setup_info =BB
 nf_conntrack_netlink.c:(.text+0x29de2): r=E9f=E9rence ind=E9finie vers =AB=
 nf_nat_setup_info =BB
 make: *** [.tmp_vmlinux1] Erreur 1=20

Reported by Kevin Baradon <kevin.baradon@gmail.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9b8ea8f4f4091c6e4424b46e8d56bb0366dfd3ee
tree 70c237a3e129df7366ac4a52f6efa142aa0a7d98
parent cd05a1f818073a623455a58e756c5b419fc98db9
author Patrick McHardy <kaber@trash.net> Sat, 17 Mar 2007 15:55:27 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 17 Mar 2007 15:55:27 +01=
00

 net/netfilter/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 253fce3..54698af 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -275,6 +275,7 @@ config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
 	depends on NF_CONNTRACK!=3Dy || NETFILTER_NETLINK!=3Dm
+	depends on NF_NAT=3Dn || NF_NAT
 	help
 	  This option enables support for a netlink-based userspace interface
=20

--------------060401000203020202090307--
