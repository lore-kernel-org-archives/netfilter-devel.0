From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: lib_RTPPROXY module
Date: Wed, 27 Jun 2007 20:55:16 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706272041120.11120@fbirervta.pbzchgretzou.qr>
References: <002901c7b8e9$7f806480$1401a8c0@nyala>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-86277983-1182970516=:11120"
Cc: netfilter-devel@lists.netfilter.org
To: Tomas Mandys <tomas.mandys@2p.cz>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <002901c7b8e9$7f806480$1401a8c0@nyala>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-86277983-1182970516=:11120
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Jun 27 2007 20:32, Tomas Mandys wrote:
>so I've finally "finished" work on RTPPROXY module, it seems it works
>now for kernel 2.6.17.8.=20
>Could =C3=A4nybody review code? What this module should support is descr=
ibed
>in quoted text bellow and in relatively extensive
>netfilter-rtpptoxy-howto.txt plus in manpages in tar. I'm not sure if
>devel list accepts attachments so here is also the link
>http://www.2p.cz/tmp/netfilter-rtpproxy.tgz.

(1) CRLF line endings -> LF.

(2) I'd suggest writing xtables now. Make it xt_RTPPROXY.

>#include <linux/module.h>
>#include <linux/vmalloc.h>
>#include <linux/skbuff.h>
>#include <linux/ip.h>
>#include <linux/netfilter_ipv4/ip_tables.h>

<linux/netfilter/x_tables.h>

>#include <linux/netfilter_ipv4/ip_conntrack.h>
>#include <linux/netfilter_ipv4/ipt_RTPPROXY.h>
>#include <linux/netfilter_ipv4/ip_nat.h>

These files are probably outdated (use nf_* instead)

>/* override pr_debug to printk even no DEBUG, just for development purpo=
ses */
>#if 1
>#undef pr_debug
>#define pr_debug(fmt,arg...) printk(KERN_DEBUG fmt,##arg)
>#endif

Do not override pr_debug. Override DEBUG instead.

>#define OPPOSITE_GATE(i) (i^1)

Please comment this, it was quite confusing until I read further into the=
 code.

>/* interrupt-context, softirq?? */

hardirq or softirq. It should not make a big difference. (Read: keep it s=
hort
in either case)

>static unsigned int do_target(struct sk_buff **pskb,
>				     const struct net_device *in,
>				     const struct net_device *out,
>				     unsigned int hooknum,
>				     const struct xt_target *target,
>				     const void *targinfo,
>				     void *userinfo)=20
>{
>	const struct ipt_rtpproxy_target_info *info =3D targinfo;
>        struct iphdr *piph;

Stray spaces.

>	struct udphdr *pudph;
>	struct ip_conntrack *ct;
>	enum ip_conntrack_info ctinfo;
>	u_int16_t port, *old_port, new_port;
>	u_int32_t ip, *old_ip, new_ip;
>	int input_gate, sess_no, is_rtcp;
>	struct ipt_rtpproxy_session *sess;
>
>	/* we take care only for UDP protocol */
>	if ((*pskb)->nh.iph->protocol !=3D IPPROTO_UDP)
>		return IPT_CONTINUE;

Remove this UDP check. It can be solved better. (See at the end.)

>	pr_debug("ipt_RTPPROXY: do_target(skb=3D%p, in=3D%p, out=3D%p, hooknum=3D=
%u, targetinfo=3D%p, userinfo=3D%p)\n", *pskb, in, out, hooknum, targinfo=
, userinfo);
>	/* Now we take destination ip:port from tuple, we'll do it instead of (=
*pskb)->nh.iph because
>	 * it's non manipulable part of tuple and it has correct value in both =
PRE_ROUTING/LOCAL_OUT
>	 * and POST_ROUTING (where &(*pskb)->nh.iph->daddr is already rewritten=
 and is useless
>	 * for identification of RTP session). It cannot be a reply (stream in =
opposite direction)=20
>	 * beacuse the replies have different tuple */
>	IP_NF_ASSERT(hooknum=3D=3DNF_IP_PRE_ROUTING || hooknum=3D=3DNF_IP_LOCAL=
_OUT || hooknum=3D=3DNF_IP_POST_ROUTING || hooknum=3D=3DNF_IP_LOCAL_IN);
>	pr_debug("ipt_RTPPROXY: do_target: ip_conntrack_get()\n");
>	ct =3D ip_conntrack_get(*pskb, &ctinfo);
>	/* Connection must be valid and non reply - replies go in via opposite =
gate as originals, but allow CONTINUE not to block common communication n=
ot related to RTP, e.g. DNS */
>	if (ctinfo >=3D IP_CT_IS_REPLY) {
>		pr_debug("ipt_RTPPROXY: do_target: ctinfo >=3D IP_CT_IS_REPLY, IPF_CON=
TINUE\n");
>		return IPT_CONTINUE;
>	}

CodingStyle would sure be good.

>
>	/* get location to rewrite IP:port of UDP header, actually we need only=
 first 8 bytes */
>	pudph =3D (struct udphdr *)((*pskb)->data + (*pskb)->nh.iph->ihl*4);

Do not cast.
skb->nh.iph is also gone in later kernels. Use  piph =3D ip_hdr(skb)  ins=
tead
and go from there (piph->ihl)

>	if (hooknum =3D=3D NF_IP_PRE_ROUTING) {
>		/* when all stuff is running on one box 2xRTP client+RTPPROXY (devel p=
urposes only ?)
>		 * then after POSTROUTING follows PREROUTING immediately and netfilter
>		 * leaves (*pskb)->nfct untouched and RTPPROXY is mystified, source IP=
:port is address of opposite gate.
>		 * conntrack should be invalidated and refreshed
>		 */
>		if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip !=3D (*pskb)->nh.ip=
h->daddr ||=20
>		    ntohs(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.udp.port) !=3D=
 ntohs(pudph->dest)) {
>			pr_debug("ipt_RTPPROXY: do_target: non-corresponding conntrack and de=
st address, local RTP routing?\n");
>			return NF_DROP;
>		#if 0
>			pr_debug("ipt_RTPPROXY: do_target: refreshing conntrack\n");

>			nf_conntrack_put((*pskb)->nfct);  /* causes kernel crash */

Then don't do it :)

>			nf_ct_untrack(*pskb);=20
>			return IPT_CONTINUE;	=09
>			(*pskb)->nfct =3D NULL;
>			it's nt possible to call ip_conntrack_in from module and I don't othe=
r way how to refresh conntrack=20

This does not look logical at all. (Oh never mind, it's #if 0ed. Remove?)

>			if (ip_conntrack_in(hooknum, pskb, in, out, NULL) =3D=3D NF_DROP) {
>				return NF_DROP;
>			}
>			ct =3D ip_conntrack_get(*pskb, &ctinfo);
>			pr_debug("ipt_RTPPROXY: do_target: ctinfo >=3D IP_CT_IS_REPLY, IPF_CO=
NTINUE\n");
>			if (ctinfo >=3D IP_CT_IS_REPLY) {
>				return IPT_CONTINUE;
>			}
>			/* get location to rewrite IP:port of UDP header, actually we need on=
ly first 8 bytes */
>			pudph =3D (struct udphdr *)((*pskb)->data + (*pskb)->nh.iph->ihl*4);
>		#endif
>		}
>	}=09
>
>	IP_NF_ASSERT(ct && (ctinfo < IP_CT_IS_REPLY));
>	ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
>	port =3D ntohs(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.udp.port);
>
>	pr_debug("ipt_RTPPROXY: do_target:{ct->src: %d.%d.%d.%d:%u, ct->dst: %d=
.%d.%d.%d:%u} reply:{ct->src: %d.%d.%d.%d:%u, ct->dst: %d.%d.%d.%d:%u}, c=
tinfo: %u\n",=20
>		NIPQUAD(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip), ntohs(ct->tup=
lehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port),
>		NIPQUAD(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip), ntohs(ct->tup=
lehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.udp.port),
>		NIPQUAD(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip), ntohs(ct->tupleh=
ash[IP_CT_DIR_REPLY].tuple.src.u.udp.port),
>		NIPQUAD(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip), ntohs(ct->tupleh=
ash[IP_CT_DIR_REPLY].tuple.dst.u.udp.port),
>		ctinfo);
>
>	pr_debug("ipt_RTPPROXY: do_target:skb->iph.src: %d.%d.%d.%d:%u, skb->ip=
h.dst: %d.%d.%d.%d:%u\n",=20
>		NIPQUAD((*pskb)->nh.iph->saddr), ntohs(pudph->source),
>		NIPQUAD((*pskb)->nh.iph->daddr), ntohs(pudph->dest)
>		);
>	spin_lock_bh(&ipt_lock);
>	/* ip:port must be a port related to gate_a/b */
>	for (input_gate=3D0, sess=3DNULL; input_gate < IPT_RTPPROXY_MAX_GATE; i=
nput_gate++) {
>		if (ip =3D=3D info->gate[input_gate].ip) {
>			if (port >=3D info->gate[input_gate].port && port < info->gate[input_=
gate].port+2*info->max_sess) {
>				sess_no =3D (port-info->gate[input_gate].port) >> 1;
>				is_rtcp =3D (port-info->gate[input_gate].port) & 0x01; // TODO: chec=
k if may be also even port number
>				sess =3D info->switchboard->sessions + sess_no;
>				break;
>			}
>		}
>	}
>	if (!sess) {
>		spin_unlock_bh(&ipt_lock);
>		pr_debug("ipt_RTPPROXY: do_target: session not found, IPT_CONTINUE\n")=
;
>		return IPT_CONTINUE;
>	}
>=09
>	pr_debug("ipt_RTPPROXY: do_target: session found\n");
>	if (!(*pskb)->tstamp.off_sec)
>		__net_timestamp(*pskb);
>
>	switch (hooknum) {
>		case NF_IP_PRE_ROUTING:
>		case NF_IP_LOCAL_OUT:
>			/* check if session is active */
>			switch (sess->state) {
>				case ipt_rtpproxy_INIT1:
>				case ipt_rtpproxy_INIT2:
>				case ipt_rtpproxy_FORWARD1:
>				case ipt_rtpproxy_FORWARD2:
>					break;
>				default:
>					spin_unlock_bh(&ipt_lock);
>					pr_debug("ipt_RTPPROXY: do_target: sess->state=3D%d, NF_DROP\n", se=
ss->state);
>					return NF_DROP;
>			}
>
>			/* check if session is still active */
>			if (sess->expires < (*pskb)->tstamp.off_sec) {
>				info->switchboard->so.stat.state[sess->state]--;
>				sess->state =3D ipt_rtpproxy_EXPIRED;
>				info->switchboard->so.stat.state[sess->state]++;
>				spin_unlock_bh(&ipt_lock);
>				pr_debug("ipt_RTPPROXY: do_target: session expired, NF_DROP\n");
>				return NF_DROP;
>			}
>
>			if (sess->gate[input_gate].stream[is_rtcp].source.ip !=3D (*pskb)->nh=
.iph->saddr || sess->gate[input_gate].stream[is_rtcp].source.port !=3D nt=
ohs(pudph->source)) {
>				if (sess->gate[input_gate].stream[is_rtcp].learning >=3D (*pskb)->ts=
tamp.off_sec) {
>					/* learn source address:port */
>					sess->gate[input_gate].stream[is_rtcp].source.ip =3D (*pskb)->nh.ip=
h->saddr;
>					sess->gate[input_gate].stream[is_rtcp].source.port =3D ntohs(pudph-=
>source);
>					if (!sess->gate[input_gate].always_learn)
>						sess->gate[input_gate].stream[is_rtcp].learning =3D 0;  /* learn o=
nly once */
>					/* sess->gate[input_gate].learnt =3D (*pskb)->tstamp; */
>				}
>				else {
>					/* drop unlearnable packet silently */
>					spin_unlock_bh(&ipt_lock);
>					pr_debug("ipt_RTPPROXY: do_target: unlearnable packet, NF_DROP\n");
>					return NF_DROP;
>				}
>			}
>			/* rewrite destination address to opposite side (learnt/forced IP:por=
t) */
>			if (sess->gate[OPPOSITE_GATE(input_gate)].stream[is_rtcp].source.ip =3D=
=3D 0) {
>				/* not learnt/received any packet from opposite side, we cannot forw=
ard it */
>				if (sess->gate[OPPOSITE_GATE(input_gate)].stream[is_rtcp].learning >=
=3D (*pskb)->tstamp.off_sec) {
>					/* if we don't missed chance forever to learn opposite address then=
 prolong expires even we cannot forward the packet */
>					sess->expires =3D (*pskb)->tstamp.off_sec+info->expires_timeout;
>				}
>				spin_unlock_bh(&ipt_lock);
>				pr_debug("ipt_RTPPROXY: do_target: no packet received from opposite =
side, NF_DROP\n");
>				return NF_DROP;
>			}
>			switch (sess->state) {
>				case ipt_rtpproxy_INIT2:
>					info->switchboard->so.stat.state[sess->state]--;
>					sess->state =3D ipt_rtpproxy_FORWARD1; /* first forwarded packet */
>					info->switchboard->so.stat.state[sess->state]++;
>					break;=20
>				case ipt_rtpproxy_FORWARD1:
>					if (sess->gate[OPPOSITE_GATE(input_gate)].stream[is_rtcp].last_pack=
et_stamp) {
>						/* we've already got packet from opposite side (of the same stream=
!) */
>						info->switchboard->so.stat.state[sess->state]--;
>						sess->state =3D ipt_rtpproxy_FORWARD2;
>						info->switchboard->so.stat.state[sess->state]++;
>					}
>					break;
>			}=20
>
>			new_ip =3D sess->gate[OPPOSITE_GATE(input_gate)].stream[is_rtcp].sour=
ce.ip;
>			new_port =3D sess->gate[OPPOSITE_GATE(input_gate)].stream[is_rtcp].so=
urce.port;
>
>			sess->gate[input_gate].stat.packets_in++;
>			sess->gate[input_gate].stat.bytes_in +=3D pudph->len;
>			info->switchboard->so.gate[input_gate].stat.packets_in++;
>			info->switchboard->so.gate[input_gate].stat.bytes_in +=3D pudph->len;
>			sess->expires =3D (*pskb)->tstamp.off_sec+info->expires_timeout;
>			sess->gate[input_gate].stream[is_rtcp].last_packet_stamp =3D (*pskb)-=
>tstamp.off_sec;
>			break;
>
>		case NF_IP_POST_ROUTING:
>		case NF_IP_LOCAL_IN:
>			/* rewrite source address to proxy gate */
>			new_ip =3D info->gate[OPPOSITE_GATE(input_gate)].ip;
>			new_port =3D info->gate[OPPOSITE_GATE(input_gate)].port+2*sess_no+is_=
rtcp;
>
>			sess->gate[OPPOSITE_GATE(input_gate)].stat.packets_out++;
>			sess->gate[OPPOSITE_GATE(input_gate)].stat.bytes_out +=3D pudph->len;
>			info->switchboard->so.gate[OPPOSITE_GATE(input_gate)].stat.packets_ou=
t++;
>			info->switchboard->so.gate[OPPOSITE_GATE(input_gate)].stat.bytes_out =
+=3D pudph->len;
>			break;
>
>		default: /* never happens */
>			spin_unlock_bh(&ipt_lock);
>			pr_debug("ipt_RTPPROXY: do_target: unexpected hooknum =3D %d, IPT_CON=
TINUE\n", hooknum);
>			return IPT_CONTINUE;
>	}
>	spin_unlock_bh(&ipt_lock);
>
>	if (!skb_make_writable(pskb, sizeof(*piph))) { /* it changes *pskb !!! =
*/
>		pr_debug("ipt_RTPPROXY: do_target: !skb_make_writable\n");
>                return NF_DROP;
>	}
>
>	pudph =3D (struct udphdr *)((*pskb)->data + (*pskb)->nh.iph->ihl*4);

No cast.

>	switch (hooknum) {
>		case NF_IP_PRE_ROUTING:
>		case NF_IP_LOCAL_OUT:
>			old_ip =3D &(*pskb)->nh.iph->daddr;
>			old_port =3D &pudph->dest;
>			/* dst_release((*pskb)->dst); idea taken from NAT but does not work
>			(*pskb)->dst =3D NULL; */
>			break;
>		case NF_IP_POST_ROUTING:
>		case NF_IP_LOCAL_IN:
>			old_ip =3D &(*pskb)->nh.iph->saddr;
>			old_port =3D &pudph->source;
>			break;
>		default:
>			return NF_DROP;  /* never happen */
>	}
>	#if 0
>	if (hooknum =3D=3D NF_IP_LOCAL_OUT) {
>		/* bug: seems checksum is incorrect for locally generated udp packets,=
 e.g. data not counted, seems also ^0xFFFFed (kernel 2.6.17.8)  */
>		pudph->check =3D 0;
>	}
>	#endif
>	if (pudph->check) {	=09
>		/* rewrite UDP checksum if provided */
>		pudph->check =3D
>			ip_nat_cheat_check(~(*old_ip), new_ip,=20
>			ip_nat_cheat_check((*old_port)^0xFFFF /* do not use '~', it's only u_=
int16 ! */, htons(new_port), pudph->check)
>		);
>	}
>
>	/* rewrite also IP header checksum */
>	(*pskb)->nh.iph->check =3D ip_nat_cheat_check(~(*old_ip), new_ip, (*psk=
b)->nh.iph->check);
>
>	pr_debug("ipt_RTPPROXY: do_target: old_addr: %d.%d.%d.%d:%u, new_addr: =
%d.%d.%d.%d:%u\n", NIPQUAD(*old_ip), ntohs(*old_port), NIPQUAD(new_ip), n=
ew_port);
>	*old_port =3D htons(new_port);
>	*old_ip =3D new_ip;
>
>//	skb->nfcache |=3D NFC_ALTERED;
>	pr_debug("ipt_RTPPROXY: do_target: NF_ACCEPT\n");
>	return NF_ACCEPT;
>}
>
>/* recheck session status and calc statistics by state, ipt_lock+ipt_use=
rcontext_mutex must be aquired */
>static inline void ipt_do_session_audit(struct timeval *stamp, struct ip=
t_rtpproxy_switchboard *switchboard, struct ipt_rtpproxy_session *sess)
>{
>	switch (sess->state) {
>		case ipt_rtpproxy_INIT1:
>		case ipt_rtpproxy_INIT2:
>		case ipt_rtpproxy_FORWARD1:
>		case ipt_rtpproxy_FORWARD2:
>			if (sess->expires < stamp->tv_sec) {
>				switchboard->so.stat.state[sess->state]--;
>				sess->state =3D ipt_rtpproxy_EXPIRED;
>				switchboard->so.stat.state[sess->state]++;
>				switchboard->so.stat.counter.expired++;
>			}=20
>			break;
>		default:
>			break;
>	}
>	switch (sess->state) {
>		case ipt_rtpproxy_EXPIRED:
>		case ipt_rtpproxy_DESTROYED:
>			if (sess->expires + switchboard->so.resurrection_timeout < stamp->tv_=
sec) {
>				switchboard->so.stat.state[sess->state]--;
>				sess->state =3D ipt_rtpproxy_NONE;
>				switchboard->so.stat.state[sess->state]++;
>			}
>		default: ;
>	}
>}
>
>/* userspace related communication, ipt_usercontext_mutex must be aquire=
d */
>static inline struct ipt_rtpproxy_switchboard* ipt_find_switchboard(stru=
ct ipt_rtpproxy_sockopt_in_switchboard *switchboard, int *opposite_flag)
>{
>	struct ipt_rtpproxy_switchboard *p;
>	int j, port_fl;
>
>	/* this is helper, if ip-a=3D=3Dip-b then port-a must not be equal to p=
ort.b but because client may not know port-b=20
>	   we'll find it */
>	port_fl =3D switchboard->gate[0].ip =3D=3D switchboard->gate[OPPOSITE_G=
ATE(0)].ip &&=20
>		  switchboard->gate[0].port =3D=3D switchboard->gate[OPPOSITE_GATE(0)]=
.port;
>
>	for (p =3D switchboard_reg; p ; p =3D p->next ) {
>		for (j=3D0; j<IPT_RTPPROXY_MAX_GATE; j++) {
>			if ( p->so.gate[0].addr.ip =3D=3D switchboard->gate[j].ip &&=20
>			     p->so.gate[0].addr.port =3D=3D switchboard->gate[j].port &&
>			     p->so.gate[OPPOSITE_GATE(0)].addr.ip =3D=3D switchboard->gate[OP=
POSITE_GATE(j)].ip &&
>			     (p->so.gate[OPPOSITE_GATE(0)].addr.port =3D=3D switchboard->gate=
[OPPOSITE_GATE(j)].port || port_fl) ) {
>				switchboard->gate[OPPOSITE_GATE(j)].port =3D p->so.gate[OPPOSITE_GAT=
E(0)].addr.port;  /* meaningful when port_fl */
>				*opposite_flag =3D (j=3D=3D0)?0:1;

*opposite_flag =3D (j !=3D 0); should be sufficient.

>				return p;
>			}
>		}
>	}
>	return NULL;
>}
>
>/* there is no uniq cmd numbering space, 2 separates for GET and SET */
>#define IPT_OPT_SET_CMD 0x8000
>
>static struct ipt_target ipt_rtpproxy_reg =3D {
>	.name =3D "RTPPROXY",
>	.target =3D do_target,
>	.targetsize =3D sizeof(struct ipt_rtpproxy_target_info),
>	.checkentry =3D do_checkentry,
>	.destroy =3D do_destroy,
>	.hooks =3D  (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING) | (1 <=
< NF_IP_LOCAL_OUT) | (1 << NF_IP_LOCAL_IN),
>	.table =3D "mangle",
>	.me =3D THIS_MODULE
	.proto =3D IPPROTO_UDP,
>};

That will limit it to UDP.

>	/* Allocate one page as temporary storage */
>	pr_debug("ipt_RTPPROXY: init(): __get_free_page(GFP_KERNEL)\n");
>	if ((ipt_tmpbuf =3D (void*)__get_free_page(GFP_KERNEL)) =3D=3D NULL) {
>		printk(KERN_ERR "ipt_RTPPROXY: Out of memory for temporary buffer page=
\n");
>		goto error_cleanup;
>	}

Why not use kmalloc instead?



	Jan
--=20
---699020219-86277983-1182970516=:11120--
