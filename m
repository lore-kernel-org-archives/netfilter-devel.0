From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Check returnvalue of nfct_nat()
Date: Mon, 27 Nov 2006 17:24:44 +0100
Message-ID: <456B114C.5000204@trash.net>
References: <1164536011.30244.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030403090603060400060005"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1164536011.30244.10.camel@localhost.localdomain>
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
--------------030403090603060400060005
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Martin Josefsson wrote:
> We need to check the returnvalue of nfct_nat() (and nfct_help())
> Otherwise we end up with the calltraces below.
> 
> Steps to reproduce:
> 1. Slow qemu machine without connectivity to the dns-servers.
> 2. Load nf_nat in the qemu machine.
> 3. Start an ssh to the qemu machine, this takes time as the qemu machine is
>    slow and lacks dns.
> 4. Load iptable_nat in the qemu machine before the ssh has completed.
> 5. Watch it blow up as it tries to use the returnvalue of nfct_nat() on a
>    connection without nat info, I believe it is a resend of a dns-query as it
>    is an udp packet that causes the crash in one of the cases below.

Thanks, I just noticed the same crash when loading iptable_nat over
ssh (it works fine with the additional checks now).

> Some of the checks in the patch might not be strictly neccessary, I havn't
> audited the calls, it was 4 AM :) The check added in nf_nat_fn() should take
> care of things for us...

The nfct_help part is a bit more trickier since not only can
nfct_help return NULL, but nfct_help(ct)->help can become NULL
as well when the helper is unloaded even while it is still
executing. I want to think about this some more, but I went
over the nfct_nat part and added the ones that look necessary,
it came down to only two :)

> Index: nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_core.c
> ===================================================================
> --- nf-2.6.20-nat.quilt.orig/net/ipv4/netfilter/nf_nat_core.c	2006-11-26 03:46:57.000000000 +0100
> +++ nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_core.c	2006-11-26 03:47:14.000000000 +0100
> @@ -98,6 +98,9 @@ static void nf_nat_cleanup_conntrack(str
>  		return;
>  
>  	nat = nfct_nat(conn);
> +	if (!nat)
> +		return;
> +

This one should be unnecessary since we're checking for
IPS_NAT_DONE_MASK already.

>  	write_lock_bh(&nf_nat_lock);
>  	list_del(&nat->info.bysource);
>  	write_unlock_bh(&nf_nat_lock);
> @@ -289,8 +292,8 @@ nf_nat_setup_info(struct nf_conn *conntr
>  		  unsigned int hooknum)
>  {
>  	struct nf_conntrack_tuple curr_tuple, new_tuple;
> -	struct nf_conn_nat *nat = nfct_nat(conntrack);
> -	struct nf_nat_info *info = &nat->info;
> +	struct nf_conn_nat *nat;
> +	struct nf_nat_info *info;
>  	int have_to_hash = !(conntrack->status & IPS_NAT_DONE_MASK);
>  	enum nf_nat_manip_type maniptype = HOOK2MANIP(hooknum);
>  
> @@ -300,6 +303,12 @@ nf_nat_setup_info(struct nf_conn *conntr
>  		     || hooknum == NF_IP_LOCAL_OUT);
>  	BUG_ON(nf_nat_initialized(conntrack, maniptype));
>  
> +	nat = nfct_nat(conntrack);
> +	if (!nat)
> +		return NF_DROP;
> +
> +	info = &nat->info;
> +

This one should be unnecessary as well with the check in
nf_nat_fn() since a conntrack without will never have a
NAT mapping created.

>  	/* What we've got will look like inverse of reply. Normally
>  	   this is what is in the conntrack, except for prior
>  	   manipulations (future optimization: if num_manips == 0,
> @@ -626,6 +635,10 @@ static int __init nf_nat_init(void)
>  static int clean_nat(struct nf_conn *i, void *data)
>  {
>  	struct nf_conn_nat *nat = nfct_nat(i);
> +
> +	if (!nat)
> +		return 0;
> +

This one is needed.

>  	memset(nat, 0, sizeof(nat));
>  	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
>  	return 0;
> Index: nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_helper.c
> ===================================================================
> --- nf-2.6.20-nat.quilt.orig/net/ipv4/netfilter/nf_nat_helper.c	2006-11-26 03:46:56.000000000 +0100
> +++ nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_helper.c	2006-11-26 03:47:14.000000000 +0100
> @@ -56,6 +56,9 @@ adjust_tcp_sequence(u32 seq,
>  	struct nf_nat_seq *this_way, *other_way;
>  	struct nf_conn_nat *nat = nfct_nat(ct);
>  
> +	if (!nat)
> +		return;
> +
>  	DEBUGP("nf_nat_resize_packet: old_size = %u, new_size = %u\n",
>  		(*skb)->len, new_size);
>  
> @@ -329,6 +332,9 @@ nf_nat_sack_adjust(struct sk_buff **pskb
>  	unsigned int dir, optoff, optend;
>  	struct nf_conn_nat *nat = nfct_nat(ct);
>  
> +	if (!nat)
> +		return 0;
> +
>  	optoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct tcphdr);
>  	optend = (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
>  
> @@ -377,6 +383,9 @@ nf_nat_seq_adjust(struct sk_buff **pskb,
>  	struct nf_conn_nat *nat = nfct_nat(ct);
>  	struct nf_nat_seq *this_way, *other_way;
>  
> +	if (!nat)
> +		return 0;
> +
>  	dir = CTINFO2DIR(ctinfo);

These should all be unnecessary since sequence adjustment can
only happen if a NAT helper mangled the packet, which it
shouldn't do in the first place if no NAT is set up.
The checks for IPS_NAT_MASK before calling the hooks make
sure of this.

>  	this_way = &nat->info.seq[dir];
> Index: nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_helper_pptp.c
> ===================================================================
> --- nf-2.6.20-nat.quilt.orig/net/ipv4/netfilter/nf_nat_helper_pptp.c	2006-11-26 03:46:56.000000000 +0100
> +++ nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_helper_pptp.c	2006-11-26 03:47:14.000000000 +0100
> @@ -53,9 +53,14 @@ static void pptp_nat_expected(struct nf_
>  	struct nf_ct_pptp_master *ct_pptp_info;
>  	struct nf_nat_pptp *nat_pptp_info;
>  	struct ip_nat_range range;
> +	struct nf_conn_help *help = nfct_help(master);
> +	struct nf_conn_nat *nat = nfct_nat(master);
>  
> -	ct_pptp_info = &nfct_help(master)->help.ct_pptp_info;
> -	nat_pptp_info = &nfct_nat(master)->help.nat_pptp_info;
> +	if (!help || !nat)
> +		return;
> +
> +	ct_pptp_info = &help->help.ct_pptp_info;
> +	nat_pptp_info = &nat->help.nat_pptp_info;
>  
>  	/* And here goes the grand finale of corrosion... */
>  	if (exp->dir == IP_CT_DIR_ORIGINAL) {
> @@ -129,9 +134,14 @@ pptp_outbound_pkt(struct sk_buff **pskb,
>  	u_int16_t msg;
>  	__be16 new_callid;
>  	unsigned int cid_off;
> +	struct nf_conn_help *help = nfct_help(ct);
> +	struct nf_conn_nat *nat = nfct_nat(ct);
> +
> +	if (!help || !nat)
> +		return NF_DROP;
>  
> -	ct_pptp_info  = &nfct_help(ct)->help.ct_pptp_info;
> -	nat_pptp_info = &nfct_nat(ct)->help.nat_pptp_info;
> +	ct_pptp_info  = &help->help.ct_pptp_info;
> +	nat_pptp_info = &nat->help.nat_pptp_info;
>  
>  	new_callid = ct_pptp_info->pns_call_id;
>  
> @@ -198,9 +208,14 @@ pptp_exp_gre(struct nf_conntrack_expect 
>  	struct nf_conn *ct = expect_orig->master;
>  	struct nf_ct_pptp_master *ct_pptp_info;
>  	struct nf_nat_pptp *nat_pptp_info;
> +	struct nf_conn_help *help = nfct_help(ct);
> +	struct nf_conn_nat *nat = nfct_nat(ct);
>  
> -	ct_pptp_info  = &nfct_help(ct)->help.ct_pptp_info;
> -	nat_pptp_info = &nfct_nat(ct)->help.nat_pptp_info;
> +	if (!help || !nat)
> +		return;
> +
> +	ct_pptp_info  = &help->help.ct_pptp_info;
> +	nat_pptp_info = &nat->help.nat_pptp_info;
>  
>  	/* save original PAC call ID in nat_info */
>  	nat_pptp_info->pac_call_id = ct_pptp_info->pac_call_id;
> @@ -230,8 +245,12 @@ pptp_inbound_pkt(struct sk_buff **pskb,
>  	u_int16_t msg;
>  	__be16 new_pcid;
>  	unsigned int pcid_off;
> +	struct nf_conn_nat *nat = nfct_nat(ct);
> +
> +	if (!nat)
> +		return NF_DROP;
>  
> -	nat_pptp_info = &nfct_nat(ct)->help.nat_pptp_info;
> +	nat_pptp_info = &nat->help.nat_pptp_info;
>  	new_pcid = nat_pptp_info->pns_call_id;

nf_nat_fn() should also help here since the conntrack never has
IPS_NAT_MASK set.

>  
>  	switch (msg = ntohs(ctlh->messageType)) {
> Index: nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_standalone.c
> ===================================================================
> --- nf-2.6.20-nat.quilt.orig/net/ipv4/netfilter/nf_nat_standalone.c	2006-11-26 03:46:56.000000000 +0100
> +++ nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_standalone.c	2006-11-26 03:47:14.000000000 +0100
> @@ -138,6 +138,9 @@ nf_nat_fn(unsigned int hooknum,
>  		return NF_ACCEPT;
>  
>  	nat = nfct_nat(ct);
> +	if (!nat)
> +		return NF_DROP;
> +

This is needed.

>  	switch (ctinfo) {
>  	case IP_CT_RELATED:
>  	case IP_CT_RELATED+IP_CT_IS_REPLY:
> Index: nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_h323.c
> ===================================================================
> --- nf-2.6.20-nat.quilt.orig/net/ipv4/netfilter/nf_nat_h323.c	2006-11-26 03:46:56.000000000 +0100
> +++ nf-2.6.20-nat.quilt/net/ipv4/netfilter/nf_nat_h323.c	2006-11-26 03:47:14.000000000 +0100
> @@ -107,12 +107,18 @@ static int set_sig_addr(struct sk_buff *
>  			unsigned char **data,
>  			TransportAddress *taddr, int count)
>  {
> -	struct nf_ct_h323_master *info = &nfct_help(ct)->help.ct_h323_info;
> +	struct nf_conn_help *help = nfct_help(ct);
> +	struct nf_ct_h323_master *info;
>  	int dir = CTINFO2DIR(ctinfo);
>  	int i;
>  	__be16 port;
>  	union nf_conntrack_address addr;
>  
> +	if (!help)
> +		return 0;
> +
> +	info = &help->help.ct_h323_info;
> +
>  	for (i = 0; i < count; i++) {
>  		if (get_h225_addr(ct, *data, &taddr[i], &addr, &port)) {
>  			if (addr.ip == ct->tuplehash[dir].tuple.src.u3.ip &&
> @@ -196,11 +202,17 @@ static int nat_rtp_rtcp(struct sk_buff *
>  			struct nf_conntrack_expect *rtp_exp,
>  			struct nf_conntrack_expect *rtcp_exp)
>  {
> -	struct nf_ct_h323_master *info = &nfct_help(ct)->help.ct_h323_info;
> +	struct nf_conn_help *help = nfct_help(ct);
> +	struct nf_ct_h323_master *info;
>  	int dir = CTINFO2DIR(ctinfo);
>  	int i;
>  	u_int16_t nated_port;
>  
> +	if (!help)
> +		return 0;
> +
> +	info = &help->help.ct_h323_info;
> +
>  	/* Set expectations for NAT */
>  	rtp_exp->saved_proto.udp.port = rtp_exp->tuple.dst.u.udp.port;
>  	rtp_exp->expectfn = nf_nat_follow_master;
> @@ -343,10 +355,16 @@ static int nat_h245(struct sk_buff **psk
>  		    TransportAddress *taddr, __be16 port,
>  		    struct nf_conntrack_expect *exp)
>  {
> -	struct nf_ct_h323_master *info = &nfct_help(ct)->help.ct_h323_info;
> +	struct nf_conn_help *help = nfct_help(ct);
> +	struct nf_ct_h323_master *info;
>  	int dir = CTINFO2DIR(ctinfo);
>  	u_int16_t nated_port = ntohs(port);
>  
> +	if (!help)
> +		return 0;
> +
> +	info = &help->help.ct_h323_info;
> +
>  	/* Set expectations for NAT */
>  	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
>  	exp->expectfn = ip_nat_h245_expect;
> @@ -431,11 +449,17 @@ static int nat_q931(struct sk_buff **psk
>  		    unsigned char **data, TransportAddress *taddr, int idx,
>  		    __be16 port, struct nf_conntrack_expect *exp)
>  {
> -	struct nf_ct_h323_master *info = &nfct_help(ct)->help.ct_h323_info;
> +	struct nf_conn_help *help = nfct_help(ct);
> +	struct nf_ct_h323_master *info;
>  	int dir = CTINFO2DIR(ctinfo);
>  	u_int16_t nated_port = ntohs(port);
>  	union nf_conntrack_address addr;
>  
> +	if (!help)
> +		return 0;
> +
> +	info = &help->help.ct_h323_info;
> +
>  	/* Set expectations for NAT */
>  	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
>  	exp->expectfn = ip_nat_q931_expect;

Same here as for PPtP.




--------------030403090603060400060005
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 1e7c6a7..ca9400e 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -626,6 +626,9 @@ static int __init nf_nat_init(void)
 static int clean_nat(struct nf_conn *i, void *data)
 {
 	struct nf_conn_nat *nat = nfct_nat(i);
+
+	if (!nat)
+		return 0;
 	memset(nat, 0, sizeof(nat));
 	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
 	return 0;
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index a2f8ebb..f272311 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -138,6 +138,9 @@ nf_nat_fn(unsigned int hooknum,
 		return NF_ACCEPT;
 
 	nat = nfct_nat(ct);
+	if (!nat)
+		return NF_DROP;
+
 	switch (ctinfo) {
 	case IP_CT_RELATED:
 	case IP_CT_RELATED+IP_CT_IS_REPLY:

--------------030403090603060400060005--
