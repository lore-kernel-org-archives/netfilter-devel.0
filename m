From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 snapshot 20090804
Date: Tue, 4 Aug 2009 15:16:08 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908041406490.15352@fbirervta.pbzchgretzou.qr>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Fred Moyer <fred@redhotpenguin.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57181 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbZHDNQI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 09:16:08 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Re,


by user request, I'll go into detail.

>Could you break up the last 100+ patches into a couple of bullet
>points for the rest of us?
>
>Obviously something significant is happening, but I'm trying to track
>what that really is.

There are not too many user-visible features in this set, the larger
part is kernel-side code cleanups, polishing, waxing.


>Jan Engelhardt (103):
>      netfilter: xtables: remove xt_TOS v0
>      netfilter: xtables: remove xt_CONNMARK v0
>      netfilter: xtables: remove xt_MARK v0, v1
>      netfilter: xtables: remove xt_connmark v0
>      netfilter: xtables: remove xt_conntrack v0
>      netfilter: xtables: remove xt_iprange v0
>      netfilter: xtables: remove xt_mark v0
>      netfilter: xtables: remove obsolete /proc/net/ipt_recent
>      netfilter: xtables: remove xt_owner v0
>      netfilter: xtables: remove redirecting header files

I start off with a few cleanup patches. Here, old revisions of
extensions are removed. This is nothing the end user would
normally see, as iptables and the kernel side will pick a
revision (call it data format, or something) both have -
this would be, for example, TOS v1. By applying these kernel
patches, the minimal iptables version shifts upwards a bit,
to 1.4.1-rc1, which as released over a year ago.

>      netfilter: conntrack: switch hook PFs to nfproto
>      netfilter: xtables: switch hook PFs to nfproto
>      netfilter: xtables: switch table AFs to nfproto
>      netfilter: xtables: remove unneeded gotos in table error paths
>      netfilter: xtables: realign struct xt_target_param
>      netfilter: iptables: remove unused datalen variable

Cosmetic correctness.

>      netfilter: xtables: use better unconditional check
>      netfilter: xtables: ignore unassigned hooks in check_entry_size_=
and_hooks
>      netfilter: xtables: check for unconditionality of policies
>      netfilter: xtables: check for standard verdicts in policies

=46ixes a missing checking feature R.Russell meant to have implemented
years ago. It is to catch someone sending gibberish "rulesets" to
the kernel, tho that probably does not happen often.

>      netfilter: xtables: consolidate table hook functions
>      netfilter: xtables: compact table hook functions
>      netfilter: xtables: generate nf_hook_ops on-demand
>      netfilter: xtables: mark table constant for registering function=
s
>      netfilter: xtables: constify initial table data
>      netfilter: xtables: use xt_table for hook instantiation
>      netfilter: xtables: generate initial table on-demand

This is for a reduction in runtime memory footprint - about 12-14K of
unswappable kernel memory resting in the initial tables, which really
goes unused if you are not actually initializing a new table (which
is, undoubtly, not something done every second).

>      netfilter: reduce NF_HOOK by one argument
>      netfilter: get rid of the grossness in netfilter.h

I was itched by the comments in netfilter.h ("this is gross"),
so, I cleaned it a little.

>      netfilter: xtables: print details on size mismatch

This is for users and developers alike. Know that dreaded
"ip_tables: foo match: invalid size 8 !=3D 4" in dmesg? It's
pretty ambiguous even for developers (read: me). Which revision?
Was 8 the kernel size or the user size? Now these three questions
are answered by printing the relevant details.

>      netfilter: xtables: constify args in compat copying functions
>      netfilter: xtables: add const qualifiers
>      netfilter: xtables: replace XT_ENTRY_ITERATE macro
>      netfilter: xtables: optimize call flow around xt_entry_foreach
>      netfilter: xtables: replace XT_MATCH_ITERATE macro
>      netfilter: xtables: optimize call flow around xt_ematch_foreach
>      netfilter: xtables: reduce arguments to translate_table

Code cleanup. The serialized blob data format was horrifying enough,
only for the API to put the nail in the coffin.

  IPT_ENTRY_ITERATE(base, size, foo, bar, varargs)

I found myself too often having to open the header file to merely
look for what each argument did. Thus, I turned it into a loop
resembling list_for_each, basically helping myself (and indirectly,
others) to get a clearer understanding.

  xt_entry_foreach(i, base, size)
      foo(i, bar);

N.B.: I could have ignored all these modifications on xt1 and move
directly to the xt2 internal format, but it seemed a little smarter
to reduce the ip_tables.c codes first before removing them as a
whole.

>      netfilter: xtables2: make ip_tables reentrant

This patch makes it possible to track/work on packets created from with=
in
Xtables itself. As you know, iptables provides flow control by means
of jumping to chains (iptables -j foo). For that, a jumpstack needs
to be recorded, but the way it was stored in classic iptables meant
that jumpstack would be overwritten.

The REJECT target for example sends a reply packet itself (using
dst_output) hence something like this would ensue:

  =E2=80=A2 NF_HOOK[INPUT] =E2=86=92 ip6t_do_table =E2=86=92 dst_output
  =E2=86=92 NF_HOOK[OUTPUT] =E2=86=92 ip6t_do_table (!boom!)

That would trash the jumpstack of the first ip6t_do_table entry,
meaning you cannot do further actions on the original packet. There
are not many targets that have this "problem", in the mainline kernel
it's just REJECT, and outside, what I only know of what I
co-authored: xt_TARPIT xt_DELUDE xt_TEE and xt_ECHO. Especially
xt_TEE users will be liking the new reentrancy feature, as they can
now mangle cloned packets (say, tag it with TOS).

>      netfilter: xtables: dissolve do_match function
>      netfilter: xtables: combine struct xt_match_param and xt_target_=
param
>      netfilter: xtables: substitute temporary defines by final name
>      netfilter: xtables: make use of xt_request_find_target
>      netfilter: xtables: consolidate code into xt_request_find_match

More cleanups. The amout needed for it just shows how much dust
iptables collected :-)

>      netfilter: xtables: deconstify struct xt_action_param for matche=
s
>      netfilter: xtables: change hotdrop pointer to direct modificatio=
n
>      netfilter: xtables: combine built-in extension structs
>      netfilter: xtables: move functions around

=2E..Preparation work, nicely split into pieces for tracking...

>      netfilter: ebtables: change ebt_basic_match to xt convention
>      netfilter: xtables: convert basic nfproto match functions into x=
t matches

The reason for ip_tables having been forked so much ofter the past
decade is its lack of modularity at the very core, struct
ip6t_entry/ip6t_ip6 for example is a hardcoded component of the
binary xt1 format userspace and kernelspace exchange. Modularizing
that, so I thought, would finally break the frontier that stopped
ip_tables/ip6_tables from further code unification.

So, the basic match structures hardcoded in each of the 4 firewalls
are distilled into regular matches, which can then freely be used in
the xt2 table format like any other match. This is a step towards a
single multiprotocol table for IPv4-IPv6-ARP-etc.

>      netfilter: xtables2: initial table skeletal functions
>      netfilter: xtables2: initial chain skeletal functions
>      netfilter: xtables2: initial rule skeletal functions
>      netfilter: xtables: alternate size checking in xt_check_match
>      netfilter: xtables: alternate size checking in xt_check_target
>      netfilter: xtables2: per-rule match skeletal functions
>      netfilter: xtables2: per-rule target skeletal functions
>      netfilter: xtables2: xt_check_target in combination with xt2 con=
texts
>      netfilter: xtables2: jumpstack (de)allocation functions
>      netfilter: xtables2: table traversal

The xt2 table format. Table/chain/rule setup/construction/teardown.

>      netfilter: xt_quota: fix wrong return value (error case)
>      netfilter: xtables: add xt_quota revision 3

struct ip6t_entry not only housed ip6t_ip6, but also counters.
Similar to how ip6t_ip6 was extruded, the counters of an ip6t_entry
will be modeled using the quota match in its upwards counting mode.

So strictly speaking, there are no implicit counters in xt2 mode -
you add them to your rule when you deem necessary. Of course there
will always be some counters if you use the xt1<->xt2 translation
layer, because classic ip_tables requiers these.

>      netfilter: xtables2: make a copy of the ipv6_filter table
>      netfilter: xtables2: initial xt1->xt2 translation for tables
>      netfilter: xtables2: xt2->xt1 translation - GET_INFO support
>      netfilter: xtables2: xt2->xt1 translation - GET_ENTRIES support
>      netfilter: xtables2: xt1->xt2 translation - SET_REPLACE support
>      netfilter: xtables2: return counters after SET_REPLACE
>      netfilter: xtables2: xt1->xt2 translation - ADD_COUNTERS support
>      netfilter: xtables2: xt2->xt1 translation - compat GET_INFO supp=
ort
>      netfilter: xtables: use compat_u64 inside struct compat_xt_count=
ers
>      netfilter: ip6tables: move mark_chains to xt1_perproto.c
>      netfilter: xtables2: xt2<->xt1 translation - compat GET_ENTRIES/=
SET_REPLACE support
>      netfilter: xtables2: compat->normal match data translation
>      netfilter: xtables2: compat->normal target data translation
>      netfilter: xtables2: outsource code into xts_match_to_xt1 functi=
on
>      netfilter: xtables2: normal->compat match data translation
>      netfilter: xtables2: normal->compat target data translation
>      netfilter: xtables2: packet tracing
>      netfilter: xtables: turn procfs entries to walk xt2 table list

Stepwise wiring up of ip6tables with the xt2 table format. This is
done in a fashion that both classic tables and xt2 tables work,
for the moment.

>      netfilter: xtables2: switch ip6's tables to the xt2 table format
>      netfilter: ip6tables: remove obsolete packet tracing
>      netfilter: ip6tables: remove xt1 GET_INFO code
>      netfilter: ip6tables: remove xt1 GET_ENTRIES code
>      netfilter: ip6tables: remove unused functions (GET_ENTRIES)
>      netfilter: ip6tables: remove xt1 SET_REPLACE code
>      netfilter: ip6tables: remove unused functions (SET_REPLACE)
>      netfilter: ip6tables: remove xt1 ADD_COUNTERS code
>      netfilter: ip6tables: remove xt1/ipv6 registration functions
>      netfilter: ip6tables: remove remaining xt1 code

And since all ip6's tables are using xt2 functions or functions
from the translation layer, the now-unused classic code that is so
duplicated over the kernel gets weeded out, as there are no more
in-tree users.

>      netfilter: iptables: include xt1_perproto code in ip_tables
>      netfilter: iptables: switch to xt2 tables
>      netfilter: iptables: remove unused functions
>      netfilter: iptables: remove xt1/ipv4 registration functions
>      netfilter: iptables: remove remaining xt1 code

Wiring up iptables to xt2.

>      netfilter: xt_quota: enable module lookup via arpt
>      netfilter: arptables: include xt1_perproto in arp_tables
>      netfilter: arptables: switch to xt2 tables
>      netfilter: arptables: remove unused functions
>      netfilter: arptables: remove xt1/arp registration functions
>      netfilter: arptables: remove remaining xt1 code

Same for arptables.

>      netfilter: xtables1: remove xt1 table handling
>      netfilter: xtables1: remove info lock
>      netfilter: xtables1: remove compat-userspace code

Removal of more now-unused functions from x_tables.c as there are no
more in-kernel users.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
