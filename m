From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack_proto_sctp.c:(.text+0x2e660): undefined reference
 to `local_bh_disable'
Date: Thu, 01 Jun 2006 13:30:27 +0900 (JST)
Message-ID: <200606010430.k514US1b000030@toshiba.co.jp>
References: <200605311253.54503.toralf.foerster@gmx.de>
	<200606010301.k5131Tk1012237@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Jun__1_13_30_27_2006_338)--"
Content-Transfer-Encoding: 7bit
Cc: toralf.foerster@gmx.de, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <200606010301.k5131Tk1012237@toshiba.co.jp>
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

----Next_Part(Thu_Jun__1_13_30_27_2006_338)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Thu, 01 Jun 2006 12:01:27 +0900 (JST)

> Anyway, I attach a patch make them include spinlock.h and interrupt.h
> like ip_conntrack_netlink.c.

Sorry, I attach this time.

-- Yasuyuki Kozakai

----Next_Part(Thu_Jun__1_13_30_27_2006_338)--
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline; filename="undef-lock_bh.patch"

[NETFILTER] nf_conntrack: Fix undefined references to local_bh_*

  CC      net/netfilter/nf_conntrack_proto_sctp.o
net/netfilter/nf_conntrack_proto_sctp.c: In function `sctp_print_conntr=
ack':
net/netfilter/nf_conntrack_proto_sctp.c:206: warning: implicit declarat=
ion of function `local_bh_disable'
net/netfilter/nf_conntrack_proto_sctp.c:208: warning: implicit declarat=
ion of function `local_bh_enable'
  CC      net/netfilter/nf_conntrack_netlink.o
net/netfilter/nf_conntrack_netlink.c: In function `ctnetlink_dump_table=
':
net/netfilter/nf_conntrack_netlink.c:429: warning: implicit declaration=
 of function `local_bh_disable'
net/netfilter/nf_conntrack_netlink.c:452: warning: implicit declaration=
 of function `local_bh_enable'

Spotted by Toralf F=F6rster

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 867779436005b3b16466146ddd226e2faabee488
tree 6e2d3efc5bab4b2eddf5144d4973de8413c2ad23
parent ba8f5baba79da8eb502f8534c3a8ecb64aceb790
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Jun 20=
06 11:21:52 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Jun=
 2006 11:21:52 +0900

 net/netfilter/nf_conntrack_netlink.c    |    1 +
 net/netfilter/nf_conntrack_proto_sctp.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_co=
nntrack_netlink.c
index bd10eb9..bb9f781 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -29,6 +29,7 @@
 #include <linux/errno.h>
 #include <linux/netlink.h>
 #include <linux/spinlock.h>
+#include <linux/interrupt.h>
 #include <linux/notifier.h>
 =

 #include <linux/netfilter.h>
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf=
_conntrack_proto_sctp.c
index 0c6da49..0839b70 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -28,6 +28,8 @@
 #include <linux/sctp.h>
 #include <linux/string.h>
 #include <linux/seq_file.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
 =

 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_protocol.h>

----Next_Part(Thu_Jun__1_13_30_27_2006_338)----
