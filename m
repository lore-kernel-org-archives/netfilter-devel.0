From: "Ranjeet Shetye" <ranjeet.shetye@zultys.com>
Subject: nf_debug.c version 0.2
Date: Wed, 18 Dec 2002 12:49:52 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000001c2a6d7$03cea910$0100a8c0@zultys.com>
References: <20021217230706.GB25448@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0001_01C2A693.F5ACEFB0"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20021217230706.GB25448@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0001_01C2A693.F5ACEFB0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit


This code is more complete and works well enough for me. Let me know if
you run into any problems.

If the interconnection complexity of the various NAT structs intimidates
you, this code should help clear up the internal organization. As
before, use it absolutely SPARINGLY.

Thanks to everyone for pointing out mistakes / corrections /
improvements and helping me.

Ranjeet Shetye
Senior Software Engineer
Zultys Technologies
771 Vaqueros Avenue
Sunnyvale  CA  94085
USA
Ranjeet.Shetye@Zultys.com
http://www.zultys.com/

------=_NextPart_000_0001_01C2A693.F5ACEFB0
Content-Type: application/octet-stream;
	name="nf_debug.h"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nf_debug.h"

=0A=
#ifndef _NF_DEBUG_H_=0A=
#define _NF_DEBUG_H_=0A=
=0A=
/* Written by Ranjeet dot Shetye at Zultys dot com */=0A=
=0A=
#include <linux/types.h>=0A=
#include <linux/init.h>=0A=
#include <linux/netfilter.h>=0A=
#include <linux/ip.h>=0A=
#include <linux/tcp.h>=0A=
#include <linux/if.h>=0A=
=0A=
#include <linux/netfilter_ipv4/ip_nat.h>=0A=
#include <linux/netfilter_ipv4/ip_nat_rule.h>=0A=
#include <linux/netfilter_ipv4/ip_nat_protocol.h>=0A=
=0A=
void my_print_ip_nat_hash (const struct ip_nat_hash * hash);=0A=
void my_print_ip_nat_helper (const struct ip_nat_helper * helper);=0A=
void my_print_ip_conntrack_dir (const enum ip_conntrack_dir * dir);=0A=
void my_print_ip_nat_info_manip (const struct ip_nat_info_manip * manip);=0A=
void my_print_ip_nat_seq (const struct ip_nat_seq * seq);=0A=
void my_print_tcp_conntrack_state (const enum tcp_conntrack * state);=0A=
void my_print_ip_ct_tcp (const struct ip_ct_tcp * tcp);=0A=
void my_print_ip_ct_ftp (const struct ip_ct_ftp * ftp);=0A=
void my_print_ip_ct_irc (const struct ip_ct_irc * irc);=0A=
void my_print_atomic_t (const atomic_t * atom);=0A=
void my_print_ip_ct_icmp (const struct ip_ct_icmp * icmp);=0A=
void my_print_timer_list (const struct timer_list * timerlist);=0A=
void my_print_ip_conntrack_tuple_hash (const struct =
ip_conntrack_tuple_hash * hash);=0A=
void my_print_ip_conntrack_manip_proto (const union =
ip_conntrack_manip_proto * manip_proto);=0A=
void my_print_ip_nat_range (const struct ip_nat_range * range);=0A=
void my_print_nf_conntrack (const struct nf_conntrack * nfc_ptr);=0A=
void my_print_list_head (const struct list_head * list);=0A=
void my_print_ip_conntrack_expect (const struct ip_conntrack_expect * =
expect);=0A=
void my_print_ip_conntrack_helper (const struct ip_conntrack_helper * =
helper);=0A=
void my_print_nf_ct_info (const struct nf_ct_info * info);=0A=
void my_print_ip_nat_info (const struct ip_nat_info * info);=0A=
void my_print_ip_conntrack (const struct ip_conntrack *conntrack);=0A=
void my_print_ip_conntrack_tuple (const struct ip_conntrack_tuple =
*tuple);=0A=
void my_print_ip_nat_manip_type (const enum ip_nat_manip_type * =
maniptype);=0A=
void my_print_ip_conntrack_manip (const struct ip_conntrack_manip * =
manip);=0A=
=0A=
#endif /* _NF_DEBUG_H_ */=0A=

------=_NextPart_000_0001_01C2A693.F5ACEFB0
Content-Type: application/octet-stream;
	name="nf_debug.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nf_debug.c"

=0A=
/* Written by Ranjeet dot Shetye at Zultys dot com */=0A=
=0A=
#include <linux/types.h>=0A=
#include <linux/init.h>=0A=
#include <linux/netfilter.h>=0A=
#include <linux/ip.h>=0A=
#include <linux/tcp.h>=0A=
#include <linux/if.h>=0A=
=0A=
#include <linux/netfilter_ipv4/ip_nat.h>=0A=
#include <linux/netfilter_ipv4/ip_nat_rule.h>=0A=
#include <linux/netfilter_ipv4/ip_nat_protocol.h>=0A=
=0A=
#include "nf_debug.h"=0A=
=0A=
atomic_t nf_debug_indent =3D { 0 };=0A=
=0A=
#if 0=0A=
	/* printk ("%s () at %s:%d ", __FUNCTION__, __FILE__, __LINE__); */\=0A=
#endif /* 0 */=0A=
=0A=
unsigned char tabs[] =3D "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t";=0A=
=0A=
#define NF_DPF(format, args...) \=0A=
{\=0A=
	printk ("%.*s", nf_debug_indent.counter, tabs);\=0A=
	printk (format,##args);\=0A=
}=0A=
=0A=
void my_print_ip_nat_hash (const struct ip_nat_hash * hash)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (hash =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_hash:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_nat_hash::list is of type struct list_head\n");=0A=
	my_print_list_head (&(hash->list));=0A=
=0A=
	NF_DPF ("ip_nat_hash::conntrack is of type struct ip_conntrack\n");=0A=
	my_print_ip_conntrack (hash->conntrack);=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_helper (const struct ip_nat_helper * helper)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (helper =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_helper:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_nat_helper::list is of type struct list_head [helper =
TBD]\n");=0A=
	/* my_print_list_head (&(helper->list)); */=0A=
=0A=
	NF_DPF ("ip_nat_helper::mask is of type struct ip_conntrack_tuple =
[helper TBD]\n");=0A=
	/* my_print_ip_conntrack_tuple (&(helper->mask)); */=0A=
=0A=
	NF_DPF ("ip_nat_helper::tuple is of type struct ip_conntrack_tuple =
[helper TBD]\n");=0A=
	/* my_print_ip_conntrack_tuple (&(helper->tuple)); */=0A=
=0A=
	NF_DPF ("ip_nat_helper::name [helper TBD]\n");=0A=
	/* NF_DPF ("ip_nat_helper::name =3D %s\n", helper->name); */=0A=
=0A=
	NF_DPF ("ip_nat_helper::(*help) [helper TBD]\n");=0A=
	/* NF_DPF ("ip_nat_helper::(*help) =3D %p\n", helper->help); */=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_dir (const enum ip_conntrack_dir * dir)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (dir =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack_dir:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	switch (*dir)=0A=
	{=0A=
		case IP_CT_DIR_MAX:=0A=
			NF_DPF ("ip_conntrack_dir::IP_CT_DIR_MAX\n");=0A=
			break;=0A=
		case IP_CT_DIR_ORIGINAL:=0A=
			NF_DPF ("ip_conntrack_dir::IP_CT_DIR_ORIGINAL\n");=0A=
			break;=0A=
		case IP_CT_DIR_REPLY:=0A=
			NF_DPF ("ip_conntrack_dir::IP_CT_DIR_REPLY\n");=0A=
			break;=0A=
		default:=0A=
			NF_DPF ("ip_conntrack_dir::%d (Unknown)\n", *dir);=0A=
			break;=0A=
	}=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_info_manip (const struct ip_nat_info_manip * manip)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (manip =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_info_manip:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_nat_info_manip::direction is of type u_int8_t\n");=0A=
	my_print_ip_conntrack_dir ((enum ip_conntrack_dir *) =
&(manip->direction));=0A=
=0A=
	NF_DPF ("ip_nat_info_manip::hooknum =3D %u\n", manip->hooknum);=0A=
=0A=
	NF_DPF ("ip_nat_info_manip::maniptype is of type u_int8_t\n");=0A=
	my_print_ip_nat_manip_type ((enum ip_nat_manip_type *) =
&(manip->maniptype));=0A=
=0A=
	NF_DPF ("ip_nat_info_manip::manip is of type struct =
ip_conntrack_manip\n");=0A=
	my_print_ip_conntrack_manip (&(manip->manip));=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_seq (const struct ip_nat_seq * seq)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (seq =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_seq:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_nat_seq::correction_pos =3D %u\n", seq->correction_pos);=0A=
	NF_DPF ("ip_nat_seq::offset_before =3D %d\n", seq->offset_before);=0A=
	NF_DPF ("ip_nat_seq::offset_after =3D %d\n", seq->offset_after);=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_tcp_conntrack_state (const enum tcp_conntrack * state)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (state =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to enum tcp_conntrack:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	switch (*state)=0A=
	{=0A=
		case TCP_CONNTRACK_NONE:=0A=
			NF_DPF ("tcp_conntrack::TCP_CONNTRACK_NONE\n");=0A=
			break;=0A=
		case TCP_CONNTRACK_ESTABLISHED:=0A=
			NF_DPF ("tcp_conntrack::TCP_CONNTRACK_ESTABLISHED\n");=0A=
			break;=0A=
		case TCP_CONNTRACK_SYN_SENT:=0A=
			NF_DPF ("tcp_conntrack::TCP_CONNTRACK_SYN_SENT\n");=0A=
			break;=0A=
		case TCP_CONNTRACK_SYN_RECV:=0A=
			NF_DPF ("tcp_conntrack::TCP_CONNTRACK_SYN_RECV\n");=0A=
			break;=0A=
		case TCP_CONNTRACK_FIN_WAIT:=0A=
			NF_DPF ("tcp_conntrack::TCP_CONNTRACK_FIN_WAIT\n");=0A=
			break;=0A=
		case TCP_CONNTRACK_TIME_WAIT:=0A=
			NF_DPF ("tcp_conntrack::TCP_CONNTRACK_TIME_WAIT\n");=0A=
			break;=0A=
		case TCP_CONNTRACK_CLOSE:=0A=
			NF_DPF ("tcp_conntrack::TCP_CONNTRACK_CLOSE\n");=0A=
			break;=0A=
		case TCP_CONNTRACK_CLOSE_WAIT:=0A=
			NF_DPF ("tcp_conntrack::TCP_CONNTRACK_CLOSE_WAIT\n");=0A=
			break;=0A=
		case TCP_CONNTRACK_LAST_ACK:=0A=
			NF_DPF ("tcp_conntrack::TCP_CONNTRACK_LAST_ACK\n");=0A=
			break;=0A=
		case TCP_CONNTRACK_LISTEN:=0A=
			NF_DPF ("tcp_conntrack::TCP_CONNTRACK_LISTEN\n");=0A=
			break;=0A=
		case TCP_CONNTRACK_MAX:=0A=
			NF_DPF ("tcp_conntrack::TCP_CONNTRACK_MAX\n");=0A=
			break;=0A=
		default:=0A=
			NF_DPF ("tcp_conntrack::%d (Unknown)\n", *state);=0A=
			break;=0A=
	}=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_ct_tcp (const struct ip_ct_tcp * tcp)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (tcp =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_ct_tcp:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_ct_tcp::handshake_ack =3D %u\n", tcp->handshake_ack);=0A=
=0A=
	NF_DPF ("ip_ct_tcp::state is of type enum tcp_conntrack\n");=0A=
	my_print_tcp_conntrack_state (&(tcp->state));=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_ct_ftp (const struct ip_ct_ftp * ftp)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (ftp =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_ct_ftp:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_ct_ftp:: [TBD]\n");=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_ct_irc (const struct ip_ct_irc * irc)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (irc =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_ct_irc:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_ct_irc:: [TBD]\n");=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_atomic_t (const atomic_t * atom)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (atom =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to atomic_t:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("atomic_t::counter =3D %d\n", atom->counter);=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_ct_icmp (const struct ip_ct_icmp * icmp)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (icmp =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_ct_icmp:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_ct_icmp::count is of type atomic_t\n");=0A=
	my_print_atomic_t (&(icmp->count));=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_timer_list (const struct timer_list * timerlist)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (timerlist =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to timer_list:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
	NF_DPF ("timer_list::data =3D %lu\n", timerlist->data);=0A=
	NF_DPF ("timer_list::expires =3D %lu\n", timerlist->expires);=0A=
	NF_DPF ("timer_list::(*function) =3D %p\n", timerlist->function);=0A=
=0A=
	NF_DPF ("timer_list::list is of type struct list_head\n");=0A=
	my_print_list_head (&(timerlist->list));=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_tuple_hash (const struct =
ip_conntrack_tuple_hash * hash)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (hash =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack_tuple_hash:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_conntrack_tuple_hash::list is of type struct list_head\n");=0A=
	my_print_list_head (&(hash->list));=0A=
=0A=
	NF_DPF ("ip_conntrack_tuple_hash::tuple is of type struct =
ip_conntrack_tuple\n");=0A=
	my_print_ip_conntrack_tuple (&(hash->tuple));=0A=
=0A=
	NF_DPF ("ip_conntrack_tuple_hash::ctrack is of type struct ip_conntrack =
* (pointer back to parent)\n");=0A=
	/* my_print_ip_conntrack (hash->ctrack); */=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_manip_proto (const union =
ip_conntrack_manip_proto * manip_proto)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (manip_proto =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack_manip_proto:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_conntrack_manip_proto::Union of all, icmp.id, tcp.port, "=0A=
			"udp.port =3D %d\n", manip_proto->all);=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_range (const struct ip_nat_range * range)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (range =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_range:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_nat_range::flags =3D %d\n", range->flags);=0A=
	NF_DPF ("ip_nat_range::min_ip =3D 0x%08X\n", range->min_ip);=0A=
	NF_DPF ("ip_nat_range::max_ip =3D 0x%08X\n", range->max_ip);=0A=
=0A=
	NF_DPF ("ip_nat_range::min is of type union =
ip_conntrack_manip_proto\n");=0A=
	my_print_ip_conntrack_manip_proto (&(range->min));=0A=
=0A=
	NF_DPF ("ip_nat_range::max is of type union =
ip_conntrack_manip_proto\n");=0A=
	my_print_ip_conntrack_manip_proto (&(range->max));=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_nf_conntrack (const struct nf_conntrack * nfc_ptr)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (nfc_ptr =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to nf_conntrack:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("nf_conntrack::use.counter =3D %d\n", nfc_ptr->use.counter);=0A=
	NF_DPF ("nf_conntrack::(*destroy) =3D %p\n", nfc_ptr->destroy);=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_list_head (const struct list_head * list)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (list =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("list_head:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("list_head::next is of type struct list_head\n");=0A=
	my_print_list_head (list->next);=0A=
=0A=
	NF_DPF ("list_head::prev is of type struct list_head\n");=0A=
	my_print_list_head (list->prev);=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_expect (const struct ip_conntrack_expect * =
expect)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (expect =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack_expect:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_conntrack_expect::expectant is of type struct =
ip_conntrack\n");=0A=
	my_print_ip_conntrack (expect->expectant);=0A=
=0A=
	NF_DPF ("ip_conntrack_expect::list is of type struct list_head\n");=0A=
	my_print_list_head (&(expect->list));=0A=
=0A=
	NF_DPF ("ip_conntrack_expect::mask is of type struct =
ip_conntrack_tuple\n");=0A=
	my_print_ip_conntrack_tuple (&(expect->mask));=0A=
=0A=
	NF_DPF ("ip_conntrack_expect::tuple is of type struct =
ip_conntrack_tuple\n");=0A=
	my_print_ip_conntrack_tuple (&(expect->tuple));=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_helper (const struct ip_conntrack_helper * =
helper)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (helper =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("ip_conntrack_helper:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_conntrack_helper::list is of type struct list_head [helper =
TBD]\n");=0A=
	/* my_print_list_head (helper->list); */=0A=
=0A=
	NF_DPF ("ip_conntrack_helper::mask is of type struct ip_conntrack_tuple =
[helper TBD]\n");=0A=
	/* my_print_ip_conntrack_tuple (&(helper->mask)); */=0A=
=0A=
	NF_DPF ("ip_conntrack_helper::tuple is of type struct =
ip_conntrack_tuple [helper TBD]\n");=0A=
	/* my_print_ip_conntrack_tuple (&(helper->tuple)); */=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_nf_ct_info (const struct nf_ct_info * info)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (info =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to nf_nt_info:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("nf_ct_info::master is of type struct nf_conntrack *\n");=0A=
	my_print_nf_conntrack (info->master);=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_info (const struct ip_nat_info * info)=0A=
{=0A=
	int i =3D 0;=0A=
=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (info =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_info:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_nat_info::byipsproto is of type struct ip_nat_hash\n");=0A=
	my_print_ip_nat_hash (&(info->byipsproto));=0A=
=0A=
	NF_DPF ("ip_nat_info::bysource is of type struct ip_nat_hash\n");=0A=
	my_print_ip_nat_hash (&(info->bysource));=0A=
=0A=
	NF_DPF ("ip_nat_info::helper is of type struct ip_nat_helper *\n");=0A=
	my_print_ip_nat_helper (info->helper);=0A=
=0A=
	NF_DPF ("ip_nat_info::initialized =3D %d\n", info->initialized);=0A=
=0A=
	NF_DPF ("ip_nat_info::manips[IP_NAT_MAX_MANIPS] is an array of type =
struct ip_nat_info_manip\n");=0A=
	for (i =3D 0; i < IP_NAT_MAX_MANIPS; i++)=0A=
	{=0A=
		NF_DPF ("ip_nat_info::manips[%d]\n", i);=0A=
		my_print_ip_nat_info_manip (&(info->manips[i]));=0A=
	}=0A=
=0A=
	NF_DPF ("ip_nat_info::mtype is of type struct ip_nat_mapping_type * =
(deprecated)\n");=0A=
=0A=
	NF_DPF ("ip_nat_info::num_manips =3D %d\n", info->num_manips);=0A=
=0A=
	NF_DPF ("ip_nat_info::seq[IP_CT_DIR_MAX] is an array of type struct =
ip_nat_seq\n");=0A=
	for (i =3D 0; i < IP_CT_DIR_MAX; i++)=0A=
	{=0A=
		NF_DPF ("ip_nat_info::seq[%d]\n", i);=0A=
		my_print_ip_nat_seq (&(info->seq[i]));=0A=
	}=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack (const struct ip_conntrack *conntrack)=0A=
{=0A=
	int i =3D 0;=0A=
=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (conntrack =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_conntrack::ct_general is of type struct nf_conntrack\n");=0A=
	my_print_nf_conntrack (&(conntrack->ct_general));=0A=
=0A=
	NF_DPF ("ip_conntrack::expected is of type struct =
ip_conntrack_expect\n");=0A=
	my_print_ip_conntrack_expect (&(conntrack->expected));=0A=
=0A=
	NF_DPF ("ip_conntrack::help.ct_ftp_info is of type struct ip_ct_ftp\n");=0A=
	my_print_ip_ct_ftp (&(conntrack->help.ct_ftp_info));=0A=
=0A=
	NF_DPF ("ip_conntrack::help.ct_irc_info	is of type struct ip_ct_irc\n");=0A=
	my_print_ip_ct_irc (&(conntrack->help.ct_irc_info));=0A=
=0A=
	NF_DPF ("ip_conntrack::helper is of type struct ip_conntrack_helper\n");=0A=
	my_print_ip_conntrack_helper (conntrack->helper);=0A=
=0A=
	NF_DPF ("ip_conntrack::infos[IP_CT_NUMBER] is an array of type =
nf_ct_info\n");=0A=
	for (i =3D 0; i < IP_CT_NUMBER; i++)=0A=
	{=0A=
		NF_DPF ("ip_conntrack::infos[%d]\n", i);=0A=
		my_print_nf_ct_info (&(conntrack->infos[i]));=0A=
	}=0A=
=0A=
	NF_DPF ("ip_conntrack::master is of type struct nf_ct_info\n");=0A=
	my_print_nf_ct_info (&(conntrack->master));=0A=
=0A=
	NF_DPF ("ip_conntrack::nat is of type struct nat (anonymous)\n");=0A=
	NF_DPF ("ip_conntrack::nat.masq_index=3D%d\n", =
conntrack->nat.masq_index);=0A=
=0A=
	NF_DPF ("ip_conntrack::nat.info is of type struct ip_nat_info\n");=0A=
	my_print_ip_nat_info (&(conntrack->nat.info));=0A=
=0A=
	NF_DPF ("ip_conntrack::Union of tcp of type struct ip_ct_tcp, and icmp =
of type struct ip_ct_icmp\n");=0A=
	my_print_ip_ct_tcp (&(conntrack->proto.tcp));=0A=
	my_print_ip_ct_icmp (&(conntrack->proto.icmp));=0A=
=0A=
	NF_DPF ("ip_conntrack::status =3D %lu\n", conntrack->status);=0A=
=0A=
	NF_DPF ("ip_conntrack::timeout is of type struct timer_list\n");=0A=
	my_print_timer_list (&(conntrack->timeout));=0A=
=0A=
	NF_DPF ("ip_conntrack::tuplehash[IP_CT_DIR_MAX] is an array of type =
struct ip_conntrack_tuple_hash\n");=0A=
	for (i =3D 0; i < IP_CT_DIR_MAX; i++)=0A=
	{=0A=
		NF_DPF ("ip_conntrack::tuplehash[%d]\n", i);=0A=
		my_print_ip_conntrack_tuple_hash (&(conntrack->tuplehash[i]));=0A=
	}=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_tuple (const struct ip_conntrack_tuple *tuple)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (tuple =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack_tuple:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_conntrack_tuple::dst.ip =3D 0x%08X\n", tuple->dst.ip);=0A=
	NF_DPF ("ip_conntrack_tuple::dst.protonum =3D %d\n", =
tuple->dst.protonum);=0A=
	NF_DPF ("ip_conntrack_tuple::Union of dst.u.all, dst.u.icmp.type & =
dst.u.icmp.port, dst.u.tcp.port, "=0A=
			"dst.u.udp.port =3D %d\n", tuple->dst.u.all);=0A=
=0A=
	NF_DPF ("ip_conntrack_tuple::src is of type struct =
ip_conntrack_manip\n");=0A=
	my_print_ip_conntrack_manip (&(tuple->src));=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_manip_type (const enum ip_nat_manip_type * =
maniptype)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (maniptype =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to enum ip_nat_manip_type:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	switch (*maniptype)=0A=
	{=0A=
		case IP_NAT_MANIP_SRC:=0A=
			NF_DPF ("ip_nat_manip_type::IP_NAT_MANIP_SRC\n");=0A=
			break;=0A=
		case IP_NAT_MANIP_DST:=0A=
			NF_DPF ("ip_nat_manip_type::IP_NAT_MANIP_DST\n");=0A=
			break;=0A=
		default:=0A=
			NF_DPF ("ip_nat_manip_type::%d (Unknown)\n", *maniptype);=0A=
			break;=0A=
	}=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_manip (const struct ip_conntrack_manip * =
manip)=0A=
{=0A=
	atomic_inc (&nf_debug_indent);=0A=
=0A=
	if (manip =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack_manip:: is NULL\n");=0A=
		atomic_dec (&nf_debug_indent);=0A=
		return;=0A=
	}=0A=
=0A=
	NF_DPF ("ip_conntrack_manip::ip =3D 0x%08X\n", manip->ip);=0A=
=0A=
	NF_DPF ("ip_conntrack_manip::u is of type struct =
ip_conntrack_manip_proto\n");=0A=
	my_print_ip_conntrack_manip_proto (&(manip->u));=0A=
=0A=
	atomic_dec (&nf_debug_indent);=0A=
	return;=0A=
}=0A=

------=_NextPart_000_0001_01C2A693.F5ACEFB0--
