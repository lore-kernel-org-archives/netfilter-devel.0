From: Jan Engelhardt <jengelh@medozas.de>
Subject: Xtables2 snapshot 20090804
Date: Tue,  4 Aug 2009 09:24:44 +0200
Message-ID: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50613 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494AbZHDH0e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


here is my prospected patch queue for 2.6.32. The important changes
are the start of a patch-wise overhaul of the firewall(s), eventually
leading to what I would bless as Xtables2 - a logical continuation of
the x_tables consolidation work done by Patrick McHardy et al in
2006/2007. (Of course it does not yet have everything I wanted, so
it's not a final v2. But it is usable.)

The internal structure of the ruleset is switched from the serialized
blob format (concatenated packed structs) to linked lists. Whereas
classic iptables always exchanges complete tables with the kernel
even if you just add a single rule from userspace, the linked-list
preparatory spadework allows the manipulation of single rules in the
future. Currently, only table-granularity swapping is supported;
appropriate RCU for chains and rules is absent at this time.

iptables compatibility is retained by means of a translation layer.
ip_tables has shown itself to be very forkable, leading to 4 firewall
subimplementations, supporting 7 data formats. The new translation
layer was written in a template fashion (hopefully not too ugly),
consolidating most of ip_tables, ip6_tables, arp_tables and their
compat variants, leading to a drop of LOC by ~50%. Ebtables has not
been touched yet.


It can be retrieved from

	git://dev.medozas.de/linux  xt2-20090804


Jan Engelhardt (103):
      netfilter: xtables: remove xt_TOS v0
      netfilter: xtables: remove xt_CONNMARK v0
      netfilter: xtables: remove xt_MARK v0, v1
      netfilter: xtables: remove xt_connmark v0
      netfilter: xtables: remove xt_conntrack v0
      netfilter: xtables: remove xt_iprange v0
      netfilter: xtables: remove xt_mark v0
      netfilter: xtables: remove obsolete /proc/net/ipt_recent
      netfilter: xtables: remove xt_owner v0
      netfilter: xtables: remove redirecting header files
      netfilter: conntrack: switch hook PFs to nfproto
      netfilter: xtables: switch hook PFs to nfproto
      netfilter: xtables: switch table AFs to nfproto
      netfilter: xtables: remove unneeded gotos in table error paths
      netfilter: xtables: realign struct xt_target_param
      netfilter: iptables: remove unused datalen variable
      netfilter: xtables: use better unconditional check
      netfilter: xtables: ignore unassigned hooks in check_entry_size_and_hooks
      netfilter: xtables: check for unconditionality of policies
      netfilter: xtables: check for standard verdicts in policies
      netfilter: xtables: consolidate table hook functions
      netfilter: xtables: compact table hook functions
      netfilter: xtables: generate nf_hook_ops on-demand
      netfilter: xtables: mark table constant for registering functions
      netfilter: xtables: constify initial table data
      netfilter: xtables: use xt_table for hook instantiation
      netfilter: xtables: generate initial table on-demand
      netfilter: reduce NF_HOOK by one argument
      netfilter: get rid of the grossness in netfilter.h
      netfilter: xtables: print details on size mismatch
      netfilter: xtables: constify args in compat copying functions
      netfilter: xtables: add const qualifiers
      netfilter: xtables: replace XT_ENTRY_ITERATE macro
      netfilter: xtables: optimize call flow around xt_entry_foreach
      netfilter: xtables: replace XT_MATCH_ITERATE macro
      netfilter: xtables: optimize call flow around xt_ematch_foreach
      netfilter: xtables: reduce arguments to translate_table
      netfilter: xtables2: make ip_tables reentrant
      netfilter: xtables: dissolve do_match function
      netfilter: xtables: combine struct xt_match_param and xt_target_param
      netfilter: xtables: substitute temporary defines by final name
      netfilter: xtables: make use of xt_request_find_target
      netfilter: xtables: consolidate code into xt_request_find_match
      netfilter: xtables: deconstify struct xt_action_param for matches
      netfilter: xtables: change hotdrop pointer to direct modification
      netfilter: xtables: combine built-in extension structs
      netfilter: xtables: move functions around
      netfilter: ebtables: change ebt_basic_match to xt convention
      netfilter: xtables: convert basic nfproto match functions into xt matches
      netfilter: xtables2: initial table skeletal functions
      netfilter: xtables2: initial chain skeletal functions
      netfilter: xtables2: initial rule skeletal functions
      netfilter: xtables: alternate size checking in xt_check_match
      netfilter: xtables: alternate size checking in xt_check_target
      netfilter: xtables2: per-rule match skeletal functions
      netfilter: xtables2: per-rule target skeletal functions
      netfilter: xtables2: xt_check_target in combination with xt2 contexts
      netfilter: xtables2: jumpstack (de)allocation functions
      netfilter: xtables2: table traversal
      netfilter: xt_quota: fix wrong return value (error case)
      netfilter: xtables: add xt_quota revision 3
      netfilter: xtables2: make a copy of the ipv6_filter table
      netfilter: xtables2: initial xt1->xt2 translation for tables
      netfilter: xtables2: xt2->xt1 translation - GET_INFO support
      netfilter: xtables2: xt2->xt1 translation - GET_ENTRIES support
      netfilter: xtables2: xt1->xt2 translation - SET_REPLACE support
      netfilter: xtables2: return counters after SET_REPLACE
      netfilter: xtables2: xt1->xt2 translation - ADD_COUNTERS support
      netfilter: xtables2: xt2->xt1 translation - compat GET_INFO support
      netfilter: xtables: use compat_u64 inside struct compat_xt_counters
      netfilter: ip6tables: move mark_chains to xt1_perproto.c
      netfilter: xtables2: xt2<->xt1 translation - compat GET_ENTRIES/SET_REPLACE support
      netfilter: xtables2: compat->normal match data translation
      netfilter: xtables2: compat->normal target data translation
      netfilter: xtables2: outsource code into xts_match_to_xt1 function
      netfilter: xtables2: normal->compat match data translation
      netfilter: xtables2: normal->compat target data translation
      netfilter: xtables2: packet tracing
      netfilter: xtables: turn procfs entries to walk xt2 table list
      netfilter: xtables2: switch ip6's tables to the xt2 table format
      netfilter: ip6tables: remove obsolete packet tracing
      netfilter: ip6tables: remove xt1 GET_INFO code
      netfilter: ip6tables: remove xt1 GET_ENTRIES code
      netfilter: ip6tables: remove unused functions (GET_ENTRIES)
      netfilter: ip6tables: remove xt1 SET_REPLACE code
      netfilter: ip6tables: remove unused functions (SET_REPLACE)
      netfilter: ip6tables: remove xt1 ADD_COUNTERS code
      netfilter: ip6tables: remove xt1/ipv6 registration functions
      netfilter: ip6tables: remove remaining xt1 code
      netfilter: iptables: include xt1_perproto code in ip_tables
      netfilter: iptables: switch to xt2 tables
      netfilter: iptables: remove unused functions
      netfilter: iptables: remove xt1/ipv4 registration functions
      netfilter: iptables: remove remaining xt1 code
      netfilter: xt_quota: enable module lookup via arpt
      netfilter: arptables: include xt1_perproto in arp_tables
      netfilter: arptables: switch to xt2 tables
      netfilter: arptables: remove unused functions
      netfilter: arptables: remove xt1/arp registration functions
      netfilter: arptables: remove remaining xt1 code
      netfilter: xtables1: remove xt1 table handling
      netfilter: xtables1: remove info lock
      netfilter: xtables1: remove compat-userspace code


 Documentation/feature-removal-schedule.txt     |   35 -
 include/linux/netfilter.h                      |   52 +-
 include/linux/netfilter/x_tables.h             |  512 ++++---
 include/linux/netfilter/xt_CONNMARK.h          |    6 -
 include/linux/netfilter/xt_MARK.h              |   17 -
 include/linux/netfilter/xt_connmark.h          |    5 -
 include/linux/netfilter/xt_conntrack.h         |   36 -
 include/linux/netfilter/xt_mark.h              |    5 -
 include/linux/netfilter/xt_quota.h             |   30 +-
 include/linux/netfilter_arp/arp_tables.h       |   41 +-
 include/linux/netfilter_bridge/ebtables.h      |    2 +-
 include/linux/netfilter_ipv4/Kbuild            |   32 -
 include/linux/netfilter_ipv4/ip_tables.h       |   48 +-
 include/linux/netfilter_ipv4/ipt_CLASSIFY.h    |    7 -
 include/linux/netfilter_ipv4/ipt_CONNMARK.h    |   19 -
 include/linux/netfilter_ipv4/ipt_DSCP.h        |   18 -
 include/linux/netfilter_ipv4/ipt_ECN.h         |    4 +-
 include/linux/netfilter_ipv4/ipt_MARK.h        |   18 -
 include/linux/netfilter_ipv4/ipt_NFQUEUE.h     |   16 -
 include/linux/netfilter_ipv4/ipt_TCPMSS.h      |    9 -
 include/linux/netfilter_ipv4/ipt_TOS.h         |   12 -
 include/linux/netfilter_ipv4/ipt_comment.h     |   10 -
 include/linux/netfilter_ipv4/ipt_connbytes.h   |   18 -
 include/linux/netfilter_ipv4/ipt_connmark.h    |    7 -
 include/linux/netfilter_ipv4/ipt_conntrack.h   |   28 -
 include/linux/netfilter_ipv4/ipt_dccp.h        |   15 -
 include/linux/netfilter_ipv4/ipt_dscp.h        |   21 -
 include/linux/netfilter_ipv4/ipt_ecn.h         |    4 +-
 include/linux/netfilter_ipv4/ipt_esp.h         |   10 -
 include/linux/netfilter_ipv4/ipt_hashlimit.h   |   14 -
 include/linux/netfilter_ipv4/ipt_helper.h      |    7 -
 include/linux/netfilter_ipv4/ipt_iprange.h     |   21 -
 include/linux/netfilter_ipv4/ipt_length.h      |    7 -
 include/linux/netfilter_ipv4/ipt_limit.h       |    8 -
 include/linux/netfilter_ipv4/ipt_mac.h         |    7 -
 include/linux/netfilter_ipv4/ipt_mark.h        |    9 -
 include/linux/netfilter_ipv4/ipt_multiport.h   |   15 -
 include/linux/netfilter_ipv4/ipt_owner.h       |   20 -
 include/linux/netfilter_ipv4/ipt_physdev.h     |   17 -
 include/linux/netfilter_ipv4/ipt_pkttype.h     |    7 -
 include/linux/netfilter_ipv4/ipt_policy.h      |   23 -
 include/linux/netfilter_ipv4/ipt_recent.h      |   21 -
 include/linux/netfilter_ipv4/ipt_sctp.h        |  105 --
 include/linux/netfilter_ipv4/ipt_state.h       |   15 -
 include/linux/netfilter_ipv4/ipt_string.h      |   10 -
 include/linux/netfilter_ipv4/ipt_tcpmss.h      |    7 -
 include/linux/netfilter_ipv4/ipt_tos.h         |   13 -
 include/linux/netfilter_ipv6/Kbuild            |   12 +-
 include/linux/netfilter_ipv6/ip6_tables.h      |   48 +-
 include/linux/netfilter_ipv6/ip6t_MARK.h       |    9 -
 include/linux/netfilter_ipv6/ip6t_esp.h        |   10 -
 include/linux/netfilter_ipv6/ip6t_length.h     |    8 -
 include/linux/netfilter_ipv6/ip6t_limit.h      |    8 -
 include/linux/netfilter_ipv6/ip6t_mac.h        |    7 -
 include/linux/netfilter_ipv6/ip6t_mark.h       |    9 -
 include/linux/netfilter_ipv6/ip6t_multiport.h  |   14 -
 include/linux/netfilter_ipv6/ip6t_owner.h      |   18 -
 include/linux/netfilter_ipv6/ip6t_physdev.h    |   17 -
 include/linux/netfilter_ipv6/ip6t_policy.h     |   23 -
 include/net/net_namespace.h                    |    1 +
 include/net/netns/x_tables.h                   |   12 +
 net/bridge/netfilter/ebt_802_3.c               |    2 +-
 net/bridge/netfilter/ebt_among.c               |    2 +-
 net/bridge/netfilter/ebt_arp.c                 |    2 +-
 net/bridge/netfilter/ebt_arpreply.c            |    4 +-
 net/bridge/netfilter/ebt_dnat.c                |    2 +-
 net/bridge/netfilter/ebt_ip.c                  |    2 +-
 net/bridge/netfilter/ebt_ip6.c                 |    2 +-
 net/bridge/netfilter/ebt_limit.c               |    2 +-
 net/bridge/netfilter/ebt_log.c                 |    2 +-
 net/bridge/netfilter/ebt_mark.c                |    2 +-
 net/bridge/netfilter/ebt_mark_m.c              |    2 +-
 net/bridge/netfilter/ebt_nflog.c               |    2 +-
 net/bridge/netfilter/ebt_pkttype.c             |    2 +-
 net/bridge/netfilter/ebt_redirect.c            |    2 +-
 net/bridge/netfilter/ebt_snat.c                |    2 +-
 net/bridge/netfilter/ebt_stp.c                 |    2 +-
 net/bridge/netfilter/ebt_ulog.c                |    2 +-
 net/bridge/netfilter/ebt_vlan.c                |    2 +-
 net/bridge/netfilter/ebtable_broute.c          |    2 +-
 net/bridge/netfilter/ebtable_filter.c          |    8 +-
 net/bridge/netfilter/ebtable_nat.c             |    6 +-
 net/bridge/netfilter/ebtables.c                |  232 ++--
 net/ipv4/netfilter/Kconfig                     |    2 +
 net/ipv4/netfilter/arp_tables.c                | 1582 ++-----------------
 net/ipv4/netfilter/arpt_mangle.c               |    2 +-
 net/ipv4/netfilter/arptable_filter.c           |  114 +-
 net/ipv4/netfilter/ip_tables.c                 | 1979 ++---------------------
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |   19 +-
 net/ipv4/netfilter/ipt_ECN.c                   |    6 +-
 net/ipv4/netfilter/ipt_LOG.c                   |    2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c            |    2 +-
 net/ipv4/netfilter/ipt_NETMAP.c                |    2 +-
 net/ipv4/netfilter/ipt_REDIRECT.c              |    2 +-
 net/ipv4/netfilter/ipt_REJECT.c                |    8 +-
 net/ipv4/netfilter/ipt_ULOG.c                  |    6 +-
 net/ipv4/netfilter/ipt_addrtype.c              |    4 +-
 net/ipv4/netfilter/ipt_ah.c                    |    4 +-
 net/ipv4/netfilter/ipt_ecn.c                   |    4 +-
 net/ipv4/netfilter/iptable_filter.c            |  148 +--
 net/ipv4/netfilter/iptable_mangle.c            |  192 +--
 net/ipv4/netfilter/iptable_raw.c               |  120 +-
 net/ipv4/netfilter/iptable_security.c          |  141 +--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 +-
 net/ipv4/netfilter/nf_nat_rule.c               |   62 +-
 net/ipv4/netfilter/nf_nat_standalone.c         |    8 +-
 net/ipv6/netfilter/Kconfig                     |    1 +
 net/ipv6/netfilter/ip6_tables.c                | 2007 ++----------------------
 net/ipv6/netfilter/ip6t_LOG.c                  |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c               |    8 +-
 net/ipv6/netfilter/ip6t_ah.c                   |    6 +-
 net/ipv6/netfilter/ip6t_eui64.c                |    4 +-
 net/ipv6/netfilter/ip6t_frag.c                 |    6 +-
 net/ipv6/netfilter/ip6t_hbh.c                  |    6 +-
 net/ipv6/netfilter/ip6t_ipv6header.c           |    2 +-
 net/ipv6/netfilter/ip6t_mh.c                   |    6 +-
 net/ipv6/netfilter/ip6t_rt.c                   |    6 +-
 net/ipv6/netfilter/ip6table_filter.c           |  135 +--
 net/ipv6/netfilter/ip6table_mangle.c           |  169 +--
 net/ipv6/netfilter/ip6table_raw.c              |  108 +-
 net/ipv6/netfilter/ip6table_security.c         |  130 +--
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   12 +-
 net/netfilter/Kconfig                          |   13 +-
 net/netfilter/Makefile                         |    1 +
 net/netfilter/x_tables.c                       | 1241 ++++++++++-----
 net/netfilter/xt1_postshared.c                 |   51 +
 net/netfilter/xt1_support.c                    |  590 +++++++
 net/netfilter/xt1_translat.c                   |  649 ++++++++
 net/netfilter/xt_CLASSIFY.c                    |    2 +-
 net/netfilter/xt_CONNMARK.c                    |  136 +--
 net/netfilter/xt_CONNSECMARK.c                 |    2 +-
 net/netfilter/xt_DSCP.c                        |   54 +-
 net/netfilter/xt_HL.c                          |    4 +-
 net/netfilter/xt_LED.c                         |    2 +-
 net/netfilter/xt_MARK.c                        |  165 +--
 net/netfilter/xt_NFLOG.c                       |    2 +-
 net/netfilter/xt_NFQUEUE.c                     |    6 +-
 net/netfilter/xt_NOTRACK.c                     |    2 +-
 net/netfilter/xt_RATEEST.c                     |    2 +-
 net/netfilter/xt_SECMARK.c                     |    2 +-
 net/netfilter/xt_TCPMSS.c                      |   38 +-
 net/netfilter/xt_TCPOPTSTRIP.c                 |    4 +-
 net/netfilter/xt_TPROXY.c                      |    4 +-
 net/netfilter/xt_TRACE.c                       |    2 +-
 net/netfilter/xt_cluster.c                     |    2 +-
 net/netfilter/xt_comment.c                     |    2 +-
 net/netfilter/xt_connbytes.c                   |    2 +-
 net/netfilter/xt_connlimit.c                   |    6 +-
 net/netfilter/xt_connmark.c                    |  103 +--
 net/netfilter/xt_conntrack.c                   |  182 +--
 net/netfilter/xt_dccp.c                        |    6 +-
 net/netfilter/xt_dscp.c                        |   23 +-
 net/netfilter/xt_esp.c                         |    4 +-
 net/netfilter/xt_hashlimit.c                   |   12 +-
 net/netfilter/xt_helper.c                      |    2 +-
 net/netfilter/xt_hl.c                          |    4 +-
 net/netfilter/xt_iprange.c                     |   49 +-
 net/netfilter/xt_length.c                      |    4 +-
 net/netfilter/xt_limit.c                       |    6 +-
 net/netfilter/xt_mac.c                         |    2 +-
 net/netfilter/xt_mark.c                        |   88 +-
 net/netfilter/xt_multiport.c                   |    8 +-
 net/netfilter/xt_osf.c                         |    2 +-
 net/netfilter/xt_owner.c                       |  132 +--
 net/netfilter/xt_physdev.c                     |    2 +-
 net/netfilter/xt_pkttype.c                     |    2 +-
 net/netfilter/xt_policy.c                      |    2 +-
 net/netfilter/xt_quota.c                       |  227 +++-
 net/netfilter/xt_rateest.c                     |    2 +-
 net/netfilter/xt_realm.c                       |    2 +-
 net/netfilter/xt_recent.c                      |  113 +--
 net/netfilter/xt_sctp.c                        |    6 +-
 net/netfilter/xt_socket.c                      |    6 +-
 net/netfilter/xt_state.c                       |    2 +-
 net/netfilter/xt_statistic.c                   |    2 +-
 net/netfilter/xt_string.c                      |    2 +-
 net/netfilter/xt_tcpmss.c                      |    4 +-
 net/netfilter/xt_tcpudp.c                      |   14 +-
 net/netfilter/xt_time.c                        |    2 +-
 net/netfilter/xt_u32.c                         |    2 +-
 net/sched/act_ipt.c                            |   12 +-
 181 files changed, 4060 insertions(+), 8823 deletions(-)
