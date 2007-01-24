From: Patrick McHardy <kaber@trash.net>
Subject: Re: PPTP Problem with 2.6.20-rc1 >=
Date: Wed, 24 Jan 2007 21:15:10 +0100
Message-ID: <45B7BE4E.30405@trash.net>
References: <087801c73c89$cb5e00b0$0301a8c0@hercules.decimalint.pt><45B208B0.8050707@trash.net><08ac01c73c9d$fa6ce100$0301a8c0@hercules.decimalint.pt><091101c73ca3$01df0f80$0301a8c0@hercules.decimalint.pt>	<45B23921.9020700@trash.net>	<09a701c73caa$67116a90$0301a8c0@hercules.decimalint.pt>
	<45B23AB7.90301@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020807020806060407000104"
Cc: netfilter-devel@lists.netfilter.org
To: Jorge Bastos <mysql.jorge@decimal.pt>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45B23AB7.90301@trash.net>
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
--------------020807020806060407000104
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> OK thanks. I'll try to reproduce it myself.

Please try these patches, they should fix it.

--------------020807020806060407000104
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: nf_nat: fix ICMP translation with statically linked conntrack

When nf_nat/nf_conntrack_ipv4 are linked statically, nf_nat is initialized
before nf_conntrack_ipv4, which makes the nf_ct_l3proto_find_get(AF_INET)
call during nf_nat initialization return the generic l3proto instead of
the AF_INET specific one. This breaks ICMP error translation since the
generic protocol always initializes the IPs in the tuple to 0.

Change the linking order and put nf_conntrack_ipv4 first.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 15cbfcc41a1fb66f4950a6e30569a13610fa9cf6
tree 9b5e3a371eeaa4e91671818098e28d2058f27ef9
parent eef40519c526f6446a0bf8ecc666af30f2eb5bfa
author Patrick McHardy <kaber@trash.net> Wed, 24 Jan 2007 21:02:56 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 24 Jan 2007 21:02:56 +0100

 net/ipv4/netfilter/Makefile |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 15e741a..ddd2a6e 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -6,6 +6,13 @@ # objects for the standalone - connectio
 ip_conntrack-objs	:= ip_conntrack_standalone.o ip_conntrack_core.o ip_conntrack_proto_generic.o ip_conntrack_proto_tcp.o ip_conntrack_proto_udp.o ip_conntrack_proto_icmp.o
 ip_nat-objs	:= ip_nat_core.o ip_nat_helper.o ip_nat_proto_unknown.o ip_nat_proto_tcp.o ip_nat_proto_udp.o ip_nat_proto_icmp.o
 nf_nat-objs	:= nf_nat_core.o nf_nat_helper.o nf_nat_proto_unknown.o nf_nat_proto_tcp.o nf_nat_proto_udp.o nf_nat_proto_icmp.o
+# objects for l3 independent conntrack
+nf_conntrack_ipv4-objs  :=  nf_conntrack_l3proto_ipv4.o nf_conntrack_proto_icmp.o
+ifeq ($(CONFIG_NF_CONNTRACK_PROC_COMPAT),y)
+ifeq ($(CONFIG_PROC_FS),y)
+nf_conntrack_ipv4-objs	+= nf_conntrack_l3proto_ipv4_compat.o
+endif
+endif
 ifneq ($(CONFIG_NF_NAT),)
 iptable_nat-objs	:= nf_nat_rule.o nf_nat_standalone.o
 else
@@ -20,6 +27,8 @@ ip_nat_h323-objs := ip_nat_helper_h323.o
 
 # connection tracking
 obj-$(CONFIG_IP_NF_CONNTRACK) += ip_conntrack.o
+obj-$(CONFIG_NF_CONNTRACK_IPV4) += nf_conntrack_ipv4.o
+
 obj-$(CONFIG_IP_NF_NAT) += ip_nat.o
 obj-$(CONFIG_NF_NAT) += nf_nat.o
 
@@ -106,13 +115,3 @@ obj-$(CONFIG_IP_NF_ARPFILTER) += arptabl
 
 obj-$(CONFIG_IP_NF_QUEUE) += ip_queue.o
 
-# objects for l3 independent conntrack
-nf_conntrack_ipv4-objs  :=  nf_conntrack_l3proto_ipv4.o nf_conntrack_proto_icmp.o
-ifeq ($(CONFIG_NF_CONNTRACK_PROC_COMPAT),y)
-ifeq ($(CONFIG_PROC_FS),y)
-nf_conntrack_ipv4-objs	+= nf_conntrack_l3proto_ipv4_compat.o
-endif
-endif
-
-# l3 independent conntrack
-obj-$(CONFIG_NF_CONNTRACK_IPV4) += nf_conntrack_ipv4.o

--------------020807020806060407000104
Content-Type: text/x-diff;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: nf_nat_pptp: fix expectation removal

When removing the expectation for the opposite direction, the PPTP NAT
helper initializes the tuple for lookup with the addresses of the
opposite direction, which makes the lookup fail.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a589a7963cc217fa3536e35ca457a942b6eb4505
tree bdf230482bf0cacdce7cd1cad6d268a54c29de76
parent 15cbfcc41a1fb66f4950a6e30569a13610fa9cf6
author Patrick McHardy <kaber@trash.net> Wed, 24 Jan 2007 21:05:28 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 24 Jan 2007 21:05:28 +0100

 net/ipv4/netfilter/nf_nat_pptp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 0ae45b7..5df4fca 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -72,9 +72,9 @@ static void pptp_nat_expected(struct nf_
 		DEBUGP("we are PAC->PNS\n");
 		/* build tuple for PNS->PAC */
 		t.src.l3num = AF_INET;
-		t.src.u3.ip = master->tuplehash[exp->dir].tuple.src.u3.ip;
+		t.src.u3.ip = master->tuplehash[!exp->dir].tuple.src.u3.ip;
 		t.src.u.gre.key = nat_pptp_info->pns_call_id;
-		t.dst.u3.ip = master->tuplehash[exp->dir].tuple.dst.u3.ip;
+		t.dst.u3.ip = master->tuplehash[!exp->dir].tuple.dst.u3.ip;
 		t.dst.u.gre.key = nat_pptp_info->pac_call_id;
 		t.dst.protonum = IPPROTO_GRE;
 	}

--------------020807020806060407000104
Content-Type: text/x-diff;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

[NETFILTER]: nf_conntrack_pptp: fix NAT setup of expected GRE connections

When an expected connection arrives, the NAT helper should be called to
set up NAT similar to the master connection. The PPTP conntrack helper
incorrectly checks whether the _expected_ connection has NAT setup before
calling the NAT helper (which is never the case), instead of checkeing
whether the _master_ connection is NATed.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cff06a5c4c8ff341f49f86100abec1c2d05e800f
tree 800ed269cc0e811d54e144cb640887a232d73a3c
parent a589a7963cc217fa3536e35ca457a942b6eb4505
author Patrick McHardy <kaber@trash.net> Wed, 24 Jan 2007 21:08:09 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 24 Jan 2007 21:08:09 +0100

 net/netfilter/nf_conntrack_pptp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index f0ff00e..c59df3b 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -113,7 +113,7 @@ static void pptp_expectfn(struct nf_conn
 
 	rcu_read_lock();
 	nf_nat_pptp_expectfn = rcu_dereference(nf_nat_pptp_hook_expectfn);
-	if (nf_nat_pptp_expectfn && ct->status & IPS_NAT_MASK)
+	if (nf_nat_pptp_expectfn && ct->master->status & IPS_NAT_MASK)
 		nf_nat_pptp_expectfn(ct, exp);
 	else {
 		struct nf_conntrack_tuple inv_t;

--------------020807020806060407000104--
