From: "Ranjeet Shetye" <ranjeet.shetye@zultys.com>
Subject: Brute force printk routines for looking at netfilter structures
Date: Tue, 17 Dec 2002 12:16:32 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000001c2a609$30f256e0$0100a8c0@zultys.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0001_01C2A5C6.22D22420"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

------=_NextPart_000_0001_01C2A5C6.22D22420
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit


I was trying to understand how the various data values were being
transferred within the connection tracking and the nat modules.
Unfortunately, I dont have the brains of Einstein so I went for the
brute force method.

I slit open Netfilter's guts and printk'd the whole damn thing out. Its
gross, its not kernel-style or systems-style coding, but hey it let me
figure out what was happening inside the netfilter mechanism. I wrote my
own stuff instead of using the builtin print mechanisms cos I want to
see and understand EVERY variable, every pointer, every data value,
EVERYTHING!

Within one day, I have gained more confidence. Now you can too!!!! The
Amazing nf_debug.c method by the Kernel Professor. :D (legal disclaimer:
Results not typical of regular users.)

The kernel works really slowly with all the printks, like its stuck in
molasses. Since I am working with multiple kernel trees, I've put the
original copy in my home directory, and linked to it in the netfilter
dirs of every kernel I am interested in. Modify Makefile to add
nf_debug.o to the list of nat objects, run make dep, make bzimage, and
you should be set to observe a very slow kernel.

The way to use this file is to use it VERY sparingly, and you should
trigger the debug code using a SINGLE packet. YOU HAVE BEEN WARNED!

I am still adding some routines and will post a complete copy once I am
done.

Thanks,
Ranjeet Shetye
Senior Software Engineer
Zultys Technologies
771 Vaqueros Avenue
Sunnyvale  CA  94085
USA
Ranjeet.Shetye@Zultys.com
http://www.zultys.com/

------=_NextPart_000_0001_01C2A5C6.22D22420
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
signed int nf_debug_indent =3D 0;=0A=
=0A=
#define NF_DPF(format, args...) \=0A=
{\=0A=
	/* printk ("%s () at %s:%d ", __FUNCTION__, __FILE__, __LINE__); */\=0A=
	{\=0A=
		int i =3D 0;\=0A=
		for ( i =3D 0; i < nf_debug_indent; i++)\=0A=
		{\=0A=
			printk ("\t");\=0A=
		}\=0A=
	}\=0A=
	printk (format,##args);\=0A=
}=0A=
=0A=
void my_print_ip_nat_manip_type (enum ip_nat_manip_type * maniptype)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (maniptype =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to enum ip_nat_manip_type:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("enum ip_nat_manip_type:: [TBD]\n");=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_hash (struct ip_nat_hash * hash)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (hash =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_hash:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_nat_hash:: [TBD]\n");=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_helper (struct ip_nat_helper * helper)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (helper =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_helper:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_nat_helper:: [TBD]\n");=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_info_manip (struct ip_nat_info_manip * manip)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (manip =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_info_manip:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_nat_info_manip:: [TBD]\n");=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_mapping_type (struct ip_nat_mapping_type * =
mapping_type)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (mapping_type =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_mapping_type:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_nat_mapping_type:: [TBD]\n");=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_seq (struct ip_nat_seq * seq)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (seq =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_seq:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_nat_seq:: [TBD]\n");=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_ct_tcp (struct ip_ct_tcp * tcp)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (tcp =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_ct_tcp:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_ct_tcp:: [TBD]\n");=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_ct_icmp (struct ip_ct_icmp * icmp)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (icmp =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_ct_icmp:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_ct_icmp:: [TBD]\n");=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_timer_list (struct timer_list * timerlist)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (timerlist =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to timer_list:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("timer_list:: [TBD]\n");=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_tuple_hash (struct ip_conntrack_tuple_hash * =
hash)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (hash =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack_tuple_hash:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_conntrack_tuple_hash:: [TBD]\n");=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_manip_proto (union ip_conntrack_manip_proto * =
manip_proto)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (manip_proto =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack_manip_proto:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_conntrack_manip_proto::Union of all, icmp.id, tcp.port, "=0A=
			"udp.port =3D %d\n", manip_proto->all);=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_range (struct ip_nat_range * range)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (range =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_range:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_nat_range::flags =3D %d\n", range->flags);=0A=
	NF_DPF ("ip_nat_range::min_ip =3D 0x%08X\n", range->min_ip);=0A=
	NF_DPF ("ip_nat_range::max_ip =3D 0x%08X\n", range->max_ip);=0A=
	NF_DPF ("ip_nat_range::Union of min and max, of type =
ip_conntrack_manip_proto\n");=0A=
	my_print_ip_conntrack_manip_proto (&(range->max));=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_nf_conntrack (struct nf_conntrack * nfc_ptr)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (nfc_ptr =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to nf_conntrack:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("nf_conntrack::use.counter =3D %d\n", nfc_ptr->use.counter);=0A=
	NF_DPF ("nf_conntrack::(*destroy) =3D %p\n", nfc_ptr->destroy);=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_list_head (struct list_head * list)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (list =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("list_head:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("list_head::next is of type list_head\n");=0A=
	my_print_list_head (list->next);=0A=
	NF_DPF ("list_head::prev is of type list_head\n");=0A=
	my_print_list_head (list->prev);=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_expect (struct ip_conntrack_expect * expect)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (expect =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack_expect:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_conntrack_expect::expectant is of type ip_conntrack\n");=0A=
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
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_helper (struct ip_conntrack_helper * helper)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (helper =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("ip_conntrack_helper:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_conntrack_helper::list is of type struct list_head =
[TBD]\n");=0A=
	/* my_print_list_head (helper->list); */=0A=
=0A=
	NF_DPF ("ip_conntrack_helper::mask is of type struct ip_conntrack_tuple =
[TBD]\n");=0A=
	/* my_print_ip_conntrack_tuple (&(helper->mask)); */=0A=
=0A=
	NF_DPF ("ip_conntrack_helper::tuple is of type struct =
ip_conntrack_tuple [TBD]\n");=0A=
	/* my_print_ip_conntrack_tuple (&(helper->tuple)); */=0A=
=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_nf_ct_info (struct nf_ct_info * info)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (info =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to nf_nt_info:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("nf_ct_info::master is of type struct nf_conntrack *\n");=0A=
	my_print_nf_conntrack (info->master);=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_nat_info (struct ip_nat_info * info)=0A=
{=0A=
	int i =3D 0;=0A=
	nf_debug_indent++;=0A=
=0A=
	if (info =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_nat_info:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
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
	NF_DPF ("ip_nat_info::mtype is of type struct ip_nat_mapping_type *\n");=0A=
	my_print_ip_nat_mapping_type (info->mtype);=0A=
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
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack (struct ip_conntrack *conntrack)=0A=
{=0A=
	int i =3D 0;=0A=
	nf_debug_indent++;=0A=
=0A=
	if (conntrack =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_conntrack::ct_general is of type nf_conntrack\n");=0A=
	my_print_nf_conntrack (&(conntrack->ct_general));=0A=
	NF_DPF ("ip_conntrack::expected is of type ip_conntrack_expect\n");=0A=
	my_print_ip_conntrack_expect (&(conntrack->expected));=0A=
=0A=
	NF_DPF ("ip_conntrack::help.ct_ftp_info is of type ip_ct_ftp [TBD]\n");=0A=
	NF_DPF ("ip_conntrack::help.ct_irc_info	is of type ip_ct_irc [TBD]\n");=0A=
	NF_DPF ("ip_conntrack::helper is of type ip_conntrack_helper\n");=0A=
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
	NF_DPF ("ip_conntrack::master is of type nf_ct_info\n");=0A=
	my_print_nf_ct_info (&(conntrack->master));=0A=
=0A=
	NF_DPF ("ip_conntrack::nat is of type anonymous\n");=0A=
	NF_DPF ("ip_conntrack::nat.masq_index=3D%d\n", =
conntrack->nat.masq_index);=0A=
=0A=
	NF_DPF ("ip_conntrack::nat.info is of type ip_nat_info\n");=0A=
	my_print_ip_nat_info (&(conntrack->nat.info));=0A=
=0A=
	NF_DPF ("ip_conntrack::Union of tcp and icmp, of type anonymous\n");=0A=
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
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_tuple (struct ip_conntrack_tuple *tuple)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (tuple =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack_tuple:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_conntrack_tuple::dst.ip =3D 0x%08X\n", tuple->dst.ip);=0A=
	NF_DPF ("ip_conntrack_tuple::dst.protonum =3D %d\n", =
tuple->dst.protonum);=0A=
	NF_DPF ("ip_conntrack_tuple::Union of dst.u.all, dst.u.icmp.id, =
dst.u.tcp.port, "=0A=
			"dst.u.udp.port =3D %d\n", tuple->dst.u.all);=0A=
	NF_DPF ("ip_conntrack_tuple::src is of type ip_conntrack_manip\n");=0A=
	my_print_ip_conntrack_manip (&(tuple->src));=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_maniptype (enum ip_nat_manip_type maniptype)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (maniptype =3D=3D IP_NAT_MANIP_SRC)=0A=
	{=0A=
		NF_DPF ("ip_nat_manip_type::IP_NAT_MANIP_SRC\n");=0A=
	}=0A=
	else if (maniptype =3D=3D IP_NAT_MANIP_DST)=0A=
	{=0A=
		NF_DPF ("ip_nat_manip_type::IP_NAT_MANIP_DST\n");=0A=
	}=0A=
	else=0A=
	{=0A=
		NF_DPF ("ip_nat_manip_type::maniptype=3D%d (Unknown)\n", maniptype);=0A=
	}=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=
void my_print_ip_conntrack_manip (struct ip_conntrack_manip * manip)=0A=
{=0A=
	nf_debug_indent++;=0A=
	if (manip =3D=3D NULL)=0A=
	{=0A=
		NF_DPF ("pointer to ip_conntrack_manip:: is NULL\n");=0A=
		nf_debug_indent--;=0A=
		return;=0A=
	}=0A=
	NF_DPF ("ip_conntrack_manip::ip =3D 0x%08X\n", manip->ip);=0A=
	NF_DPF ("ip_conntrack_manip::u is of type ip_conntrack_manip_proto\n");=0A=
	my_print_ip_conntrack_manip_proto (&(manip->u));=0A=
	nf_debug_indent--;=0A=
	return;=0A=
}=0A=
=0A=

------=_NextPart_000_0001_01C2A5C6.22D22420
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
void my_print_ip_nat_manip_type (enum ip_nat_manip_type * maniptype);=0A=
void my_print_ip_nat_hash (struct ip_nat_hash * hash);=0A=
void my_print_ip_nat_helper (struct ip_nat_helper * helper);=0A=
void my_print_ip_nat_info_manip (struct ip_nat_info_manip * manip);=0A=
void my_print_ip_nat_mapping_type (struct ip_nat_mapping_type * =
mapping_type);=0A=
void my_print_ip_nat_seq (struct ip_nat_seq * seq);=0A=
void my_print_ip_ct_tcp (struct ip_ct_tcp * tcp);=0A=
void my_print_ip_ct_icmp (struct ip_ct_icmp * icmp);=0A=
void my_print_timer_list (struct timer_list * timerlist);=0A=
void my_print_ip_conntrack_tuple_hash (struct ip_conntrack_tuple_hash * =
hash);=0A=
void my_print_ip_conntrack_manip_proto (union ip_conntrack_manip_proto * =
manip_proto);=0A=
void my_print_ip_nat_range (struct ip_nat_range * range);=0A=
void my_print_nf_conntrack (struct nf_conntrack * nfc_ptr);=0A=
void my_print_list_head (struct list_head * list);=0A=
void my_print_ip_conntrack_expect (struct ip_conntrack_expect * expect);=0A=
void my_print_ip_conntrack_helper (struct ip_conntrack_helper * helper);=0A=
void my_print_nf_ct_info (struct nf_ct_info * info);=0A=
void my_print_ip_nat_info (struct ip_nat_info * info);=0A=
void my_print_ip_conntrack (struct ip_conntrack *conntrack);=0A=
void my_print_ip_conntrack_tuple (struct ip_conntrack_tuple *tuple);=0A=
void my_print_maniptype (enum ip_nat_manip_type maniptype);=0A=
void my_print_ip_conntrack_manip (struct ip_conntrack_manip * manip);=0A=
=0A=
#endif /* _NF_DEBUG_H_ */=0A=
=0A=

------=_NextPart_000_0001_01C2A5C6.22D22420--
