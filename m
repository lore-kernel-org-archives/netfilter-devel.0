From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] Check returnvalue of nfct_nat()
Date: Sun, 26 Nov 2006 11:13:31 +0100
Message-ID: <1164536011.30244.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-FR/dXav6tUs8VU2KRfSq"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
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


--=-FR/dXav6tUs8VU2KRfSq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

We need to check the returnvalue of nfct_nat() (and nfct_help())
Otherwise we end up with the calltraces below.

Steps to reproduce:
1. Slow qemu machine without connectivity to the dns-servers.
2. Load nf_nat in the qemu machine.
3. Start an ssh to the qemu machine, this takes time as the qemu machine is
   slow and lacks dns.
4. Load iptable_nat in the qemu machine before the ssh has completed.
5. Watch it blow up as it tries to use the returnvalue of nfct_nat() on a
   connection without nat info, I believe it is a resend of a dns-query as =
it
   is an udp packet that causes the crash in one of the cases below.

Some of the checks in the patch might not be strictly neccessary, I havn't
audited the calls, it was 4 AM :) The check added in nf_nat_fn() should tak=
e
care of things for us...

BUG: unable to handle kernel NULL pointer dereference at virtual address 00=
000000
EIP is at __list_add+0x28/0x70
 [<c01fd66e>] list_add+0x1e/0x20
 [<c8814892>] nf_nat_setup_info+0x292/0x620 [nf_nat]
 [<c886a0d6>] alloc_null_binding_confirmed+0x46/0x60 [iptable_nat]
 [<c886a551>] nf_nat_fn+0x1c1/0x1d0 [iptable_nat]
 [<c886a865>] nf_nat_local_fn+0x65/0xf0 [iptable_nat]
 [<c02879f0>] nf_iterate+0x60/0x90
 [<c0287b82>] nf_hook_slow+0x52/0xd0
 [<c0290f7a>] ip_push_pending_frames+0x3ea/0x4b0
 [<c02b0d4b>] udp_push_pending_frames+0x15b/0x360
 [<c02b1f99>] udp_sendmsg+0x2c9/0x690
 [<c02b84c5>] inet_sendmsg+0x35/0x60
 [<c02650bd>] sock_sendmsg+0xcd/0x100
 [<c0265433>] sys_sendto+0xd3/0x100
 [<c0265492>] sys_send+0x32/0x40
 [<c02662a2>] sys_socketcall+0x142/0x260
 [<c01031f3>] syscall_call+0x7/0xb

or this:

BUG: unable to handle kernel NULL pointer dereference at virtual address 00=
000000
EIP is at __list_add+0x28/0x70
 [<c01fd66e>] list_add+0x1e/0x20
 [<c8814892>] nf_nat_setup_info+0x292/0x620 [nf_nat]
 [<c886a367>] nf_nat_rule_find+0x97/0xc0 [iptable_nat]
 [<c886a46f>] nf_nat_fn+0xdf/0x1d0 [iptable_nat]
 [<c886a5fe>] nf_nat_in+0x3e/0xb0 [iptable_nat]
 [<c02879f0>] nf_iterate+0x60/0x90
 [<c0287b82>] nf_hook_slow+0x52/0xd0
 [<c028de9d>] ip_rcv+0x31d/0x5a0
 [<c026ffbf>] netif_receive_skb+0x23f/0x3b0
 [<c0235d95>] cp_rx_poll+0x235/0x540
 [<c0271d98>] net_rx_action+0xa8/0x160
 [<c0121412>] __do_softirq+0x92/0x120
 [<c0121505>] do_softirq+0x65/0x70
 [<c01218d5>] irq_exit+0x45/0x50
 [<c010ebf7>] smp_apic_timer_interrupt+0xb7/0xe0
 [<c0103ca2>] apic_timer_interrupt+0x2a/0x30
 [<c0101d8c>] cpu_idle+0x6c/0x90
 [<c0100725>] rest_init+0x35/0x40
 [<c03958ee>] start_kernel+0x37e/0x430
 [<00000000>] 0x0

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

---
 net/ipv4/netfilter/nf_nat_core.c        |   17 ++++++++++++++--
 net/ipv4/netfilter/nf_nat_h323.c        |   32 +++++++++++++++++++++++++++=
----
 net/ipv4/netfilter/nf_nat_helper.c      |    9 ++++++++
 net/ipv4/netfilter/nf_nat_helper_pptp.c |   33 +++++++++++++++++++++++++--=
-----
 net/ipv4/netfilter/nf_nat_standalone.c  |    3 ++
 net/netfilter/nf_conntrack_core.c       |    2 -
 6 files changed, 82 insertions(+), 14 deletions(-)

Index: nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_core.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- nf-2.6.20-nat.quilt.orig/net/ipv4/netfilter/nf_nat_core.c	2006-11-26 03=
:46:57.000000000 +0100
+++ nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_core.c	2006-11-26 03:47:1=
4.000000000 +0100
@@ -98,6 +98,9 @@ static void nf_nat_cleanup_conntrack(str
 		return;
=20
 	nat =3D nfct_nat(conn);
+	if (!nat)
+		return;
+
 	write_lock_bh(&nf_nat_lock);
 	list_del(&nat->info.bysource);
 	write_unlock_bh(&nf_nat_lock);
@@ -289,8 +292,8 @@ nf_nat_setup_info(struct nf_conn *conntr
 		  unsigned int hooknum)
 {
 	struct nf_conntrack_tuple curr_tuple, new_tuple;
-	struct nf_conn_nat *nat =3D nfct_nat(conntrack);
-	struct nf_nat_info *info =3D &nat->info;
+	struct nf_conn_nat *nat;
+	struct nf_nat_info *info;
 	int have_to_hash =3D !(conntrack->status & IPS_NAT_DONE_MASK);
 	enum nf_nat_manip_type maniptype =3D HOOK2MANIP(hooknum);
=20
@@ -300,6 +303,12 @@ nf_nat_setup_info(struct nf_conn *conntr
 		     || hooknum =3D=3D NF_IP_LOCAL_OUT);
 	BUG_ON(nf_nat_initialized(conntrack, maniptype));
=20
+	nat =3D nfct_nat(conntrack);
+	if (!nat)
+		return NF_DROP;
+
+	info =3D &nat->info;
+
 	/* What we've got will look like inverse of reply. Normally
 	   this is what is in the conntrack, except for prior
 	   manipulations (future optimization: if num_manips =3D=3D 0,
@@ -626,6 +635,10 @@ static int __init nf_nat_init(void)
 static int clean_nat(struct nf_conn *i, void *data)
 {
 	struct nf_conn_nat *nat =3D nfct_nat(i);
+
+	if (!nat)
+		return 0;
+
 	memset(nat, 0, sizeof(nat));
 	i->status &=3D ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
 	return 0;
Index: nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_helper.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- nf-2.6.20-nat.quilt.orig/net/ipv4/netfilter/nf_nat_helper.c	2006-11-26 =
03:46:56.000000000 +0100
+++ nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_helper.c	2006-11-26 03:47=
:14.000000000 +0100
@@ -56,6 +56,9 @@ adjust_tcp_sequence(u32 seq,
 	struct nf_nat_seq *this_way, *other_way;
 	struct nf_conn_nat *nat =3D nfct_nat(ct);
=20
+	if (!nat)
+		return;
+
 	DEBUGP("nf_nat_resize_packet: old_size =3D %u, new_size =3D %u\n",
 		(*skb)->len, new_size);
=20
@@ -329,6 +332,9 @@ nf_nat_sack_adjust(struct sk_buff **pskb
 	unsigned int dir, optoff, optend;
 	struct nf_conn_nat *nat =3D nfct_nat(ct);
=20
+	if (!nat)
+		return 0;
+
 	optoff =3D (*pskb)->nh.iph->ihl*4 + sizeof(struct tcphdr);
 	optend =3D (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
=20
@@ -377,6 +383,9 @@ nf_nat_seq_adjust(struct sk_buff **pskb,
 	struct nf_conn_nat *nat =3D nfct_nat(ct);
 	struct nf_nat_seq *this_way, *other_way;
=20
+	if (!nat)
+		return 0;
+
 	dir =3D CTINFO2DIR(ctinfo);
=20
 	this_way =3D &nat->info.seq[dir];
Index: nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_helper_pptp.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- nf-2.6.20-nat.quilt.orig/net/ipv4/netfilter/nf_nat_helper_pptp.c	2006-1=
1-26 03:46:56.000000000 +0100
+++ nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_helper_pptp.c	2006-11-26 =
03:47:14.000000000 +0100
@@ -53,9 +53,14 @@ static void pptp_nat_expected(struct nf_
 	struct nf_ct_pptp_master *ct_pptp_info;
 	struct nf_nat_pptp *nat_pptp_info;
 	struct ip_nat_range range;
+	struct nf_conn_help *help =3D nfct_help(master);
+	struct nf_conn_nat *nat =3D nfct_nat(master);
=20
-	ct_pptp_info =3D &nfct_help(master)->help.ct_pptp_info;
-	nat_pptp_info =3D &nfct_nat(master)->help.nat_pptp_info;
+	if (!help || !nat)
+		return;
+
+	ct_pptp_info =3D &help->help.ct_pptp_info;
+	nat_pptp_info =3D &nat->help.nat_pptp_info;
=20
 	/* And here goes the grand finale of corrosion... */
 	if (exp->dir =3D=3D IP_CT_DIR_ORIGINAL) {
@@ -129,9 +134,14 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	u_int16_t msg;
 	__be16 new_callid;
 	unsigned int cid_off;
+	struct nf_conn_help *help =3D nfct_help(ct);
+	struct nf_conn_nat *nat =3D nfct_nat(ct);
+
+	if (!help || !nat)
+		return NF_DROP;
=20
-	ct_pptp_info  =3D &nfct_help(ct)->help.ct_pptp_info;
-	nat_pptp_info =3D &nfct_nat(ct)->help.nat_pptp_info;
+	ct_pptp_info  =3D &help->help.ct_pptp_info;
+	nat_pptp_info =3D &nat->help.nat_pptp_info;
=20
 	new_callid =3D ct_pptp_info->pns_call_id;
=20
@@ -198,9 +208,14 @@ pptp_exp_gre(struct nf_conntrack_expect=20
 	struct nf_conn *ct =3D expect_orig->master;
 	struct nf_ct_pptp_master *ct_pptp_info;
 	struct nf_nat_pptp *nat_pptp_info;
+	struct nf_conn_help *help =3D nfct_help(ct);
+	struct nf_conn_nat *nat =3D nfct_nat(ct);
=20
-	ct_pptp_info  =3D &nfct_help(ct)->help.ct_pptp_info;
-	nat_pptp_info =3D &nfct_nat(ct)->help.nat_pptp_info;
+	if (!help || !nat)
+		return;
+
+	ct_pptp_info  =3D &help->help.ct_pptp_info;
+	nat_pptp_info =3D &nat->help.nat_pptp_info;
=20
 	/* save original PAC call ID in nat_info */
 	nat_pptp_info->pac_call_id =3D ct_pptp_info->pac_call_id;
@@ -230,8 +245,12 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	u_int16_t msg;
 	__be16 new_pcid;
 	unsigned int pcid_off;
+	struct nf_conn_nat *nat =3D nfct_nat(ct);
+
+	if (!nat)
+		return NF_DROP;
=20
-	nat_pptp_info =3D &nfct_nat(ct)->help.nat_pptp_info;
+	nat_pptp_info =3D &nat->help.nat_pptp_info;
 	new_pcid =3D nat_pptp_info->pns_call_id;
=20
 	switch (msg =3D ntohs(ctlh->messageType)) {
Index: nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_standalone.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- nf-2.6.20-nat.quilt.orig/net/ipv4/netfilter/nf_nat_standalone.c	2006-11=
-26 03:46:56.000000000 +0100
+++ nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_standalone.c	2006-11-26 0=
3:47:14.000000000 +0100
@@ -138,6 +138,9 @@ nf_nat_fn(unsigned int hooknum,
 		return NF_ACCEPT;
=20
 	nat =3D nfct_nat(ct);
+	if (!nat)
+		return NF_DROP;
+
 	switch (ctinfo) {
 	case IP_CT_RELATED:
 	case IP_CT_RELATED+IP_CT_IS_REPLY:
Index: nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_h323.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- nf-2.6.20-nat.quilt.orig/net/ipv4/netfilter/nf_nat_h323.c	2006-11-26 03=
:46:56.000000000 +0100
+++ nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_h323.c	2006-11-26 03:47:1=
4.000000000 +0100
@@ -107,12 +107,18 @@ static int set_sig_addr(struct sk_buff *
 			unsigned char **data,
 			TransportAddress *taddr, int count)
 {
-	struct nf_ct_h323_master *info =3D &nfct_help(ct)->help.ct_h323_info;
+	struct nf_conn_help *help =3D nfct_help(ct);
+	struct nf_ct_h323_master *info;
 	int dir =3D CTINFO2DIR(ctinfo);
 	int i;
 	__be16 port;
 	union nf_conntrack_address addr;
=20
+	if (!help)
+		return 0;
+
+	info =3D &help->help.ct_h323_info;
+
 	for (i =3D 0; i < count; i++) {
 		if (get_h225_addr(ct, *data, &taddr[i], &addr, &port)) {
 			if (addr.ip =3D=3D ct->tuplehash[dir].tuple.src.u3.ip &&
@@ -196,11 +202,17 @@ static int nat_rtp_rtcp(struct sk_buff *
 			struct nf_conntrack_expect *rtp_exp,
 			struct nf_conntrack_expect *rtcp_exp)
 {
-	struct nf_ct_h323_master *info =3D &nfct_help(ct)->help.ct_h323_info;
+	struct nf_conn_help *help =3D nfct_help(ct);
+	struct nf_ct_h323_master *info;
 	int dir =3D CTINFO2DIR(ctinfo);
 	int i;
 	u_int16_t nated_port;
=20
+	if (!help)
+		return 0;
+
+	info =3D &help->help.ct_h323_info;
+
 	/* Set expectations for NAT */
 	rtp_exp->saved_proto.udp.port =3D rtp_exp->tuple.dst.u.udp.port;
 	rtp_exp->expectfn =3D nf_nat_follow_master;
@@ -343,10 +355,16 @@ static int nat_h245(struct sk_buff **psk
 		    TransportAddress *taddr, __be16 port,
 		    struct nf_conntrack_expect *exp)
 {
-	struct nf_ct_h323_master *info =3D &nfct_help(ct)->help.ct_h323_info;
+	struct nf_conn_help *help =3D nfct_help(ct);
+	struct nf_ct_h323_master *info;
 	int dir =3D CTINFO2DIR(ctinfo);
 	u_int16_t nated_port =3D ntohs(port);
=20
+	if (!help)
+		return 0;
+
+	info =3D &help->help.ct_h323_info;
+
 	/* Set expectations for NAT */
 	exp->saved_proto.tcp.port =3D exp->tuple.dst.u.tcp.port;
 	exp->expectfn =3D ip_nat_h245_expect;
@@ -431,11 +449,17 @@ static int nat_q931(struct sk_buff **psk
 		    unsigned char **data, TransportAddress *taddr, int idx,
 		    __be16 port, struct nf_conntrack_expect *exp)
 {
-	struct nf_ct_h323_master *info =3D &nfct_help(ct)->help.ct_h323_info;
+	struct nf_conn_help *help =3D nfct_help(ct);
+	struct nf_ct_h323_master *info;
 	int dir =3D CTINFO2DIR(ctinfo);
 	u_int16_t nated_port =3D ntohs(port);
 	union nf_conntrack_address addr;
=20
+	if (!help)
+		return 0;
+
+	info =3D &help->help.ct_h323_info;
+
 	/* Set expectations for NAT */
 	exp->saved_proto.tcp.port =3D exp->tuple.dst.u.tcp.port;
 	exp->expectfn =3D ip_nat_q931_expect;
Index: nf-2.6.20-nat.quilt/net/netfilter/nf_conntrack_core.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- nf-2.6.20-nat.quilt.orig/net/netfilter/nf_conntrack_core.c	2006-11-26 0=
3:46:57.000000000 +0100
+++ nf-2.6.20-nat.quilt/net/netfilter/nf_conntrack_core.c	2006-11-26 03:47:=
43.000000000 +0100
@@ -859,7 +859,7 @@ void nf_conntrack_alter_reply(struct nf_
 	NF_CT_DUMP_TUPLE(newreply);
=20
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple =3D *newreply;
-	if (!conntrack->master && help->expecting =3D=3D 0)
+	if (!conntrack->master && help && help->expecting =3D=3D 0)
 		help->helper =3D __nf_ct_helper_find(newreply);
 	write_unlock_bh(&nf_conntrack_lock);
 }

--=20
/Martin

--=-FR/dXav6tUs8VU2KRfSq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFaWjLWm2vlfa207ERAnenAKCQQaJqQST/jLZarHXdBOS7vbAFUACggEeX
2MKfH4FHtGVoJipG1t5ysfI=
=ZILj
-----END PGP SIGNATURE-----

--=-FR/dXav6tUs8VU2KRfSq--
