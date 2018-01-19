From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/32] Netfilter/IPVS updates for net-next
Date: Fri, 19 Jan 2018 20:10:09 +0100
Message-ID: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45130 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755949AbeASTKx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 14:10:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B7ED2EFEAC
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:10:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0AC90DA852
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:10:51 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi David,

The following patchset contains Netfilter/IPVS updates for your net-next
tree. Basically, a new extension for ip6tables, simplification work of
nf_tables that saves us 500 LoC, allow raw table registration before
defragmentation, conversion of the SNMP helper to use the ASN.1 code
generator, unique 64-bit handle for all nf_tables objects and fixes to
address fallout from previous nf-next batch.  More specifically, they
are:

1) Seven patches to remove family abstraction layer (struct nft_af_info)
   in nf_tables, this simplifies our codebase and it saves us 64 bytes per
   net namespace.

2) Add IPv6 segment routing header matching for ip6tables, from Ahmed
   Abdelsalam.

3) Allow to register iptable_raw table before defragmentation, some
   people do not want to waste cycles on defragmenting traffic that is
   going to be dropped, hence add a new module parameter to enable this
   behaviour in iptables and ip6tables. From Subash Abhinov
   Kasiviswanathan. This patch needed a couple of follow up patches to
   get things tidy from Arnd Bergmann.

4) SNMP helper uses the ASN.1 code generator, from Taehee Yoo. Several
   patches for this helper to prepare this change are also part of this
   patch series.

5) Add 64-bit handles to uniquely objects in nf_tables, from Harsha
   Sharma.

6) Remove log message that several netfilter subsystems print at
   boot/load time.

7) Restore x_tables module autoloading, that got broken in a previous
   patch to allow singleton NAT hook callback registration per hook
   spot, from Florian Westphal. Moreover, return EBUSY to report that
   the singleton NAT hook slot is already in instead.

8) Several fixes for the new nf_tables flowtable representation,
   including incorrect error check after nf_tables_flowtable_lookup(),
   missing Kconfig dependencies that lead to build breakage and missing
   initialization of priority and hooknum in flowtable object.

9) Missing NETFILTER_FAMILY_ARP dependency in Kconfig for the clusterip
   target. This is due to recent updates in the core to shrink the hook
   array size and compile it out if no specific family is enabled via
   .config file. Patch from Florian Westphal.

10) Remove duplicated include header files, from Wei Yongjun.

11) Sparse warning fix for the NFPROTO_INET handling from the core
    due to missing static function definition, also from Wei Yongjun.

12) Restore ICMPv6 Parameter Problem error reporting when
    defragmentation fails, from Subash Abhinov Kasiviswanathan.

13) Remove obsolete owner field initialization from struct
    file_operations, patch from Alexey Dobriyan.

14) Use boolean datatype where needed in the Netfilter codebase, from
    Gustavo A. R. Silva.

15) Remove double semicolon in dynset nf_tables expression, from
    Luis de Bethencourt.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit 61ad64080e039dce99a7f8d89b729bbea995e2f7:

  Merge branch 'r8169-improve-runtime-pm' (2018-01-09 12:38:57 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to e55311665286ab2744295575948c2b08dc001bf3:

  netfilter: remove messages print and boot/module load time (2018-01-19 18:39:49 +0100)

----------------------------------------------------------------
Ahmed Abdelsalam (1):
      netfilter: add IPv6 segment routing header 'srh' match

Alexey Dobriyan (1):
      netfilter: delete /proc THIS_MODULE references

Arnd Bergmann (4):
      netfilter: improve flow table Kconfig dependencies
      netfilter: nf_tables: flow_offload depends on flow_table
      netfilter: nf_defrag: mark xt_table structures 'const' again
      netfilter: nf_defrag: move NF_CONNTRACK bits into #ifdef

Florian Westphal (3):
      netfilter: x_tables: unbreak module auto loading
      netfilter: clusterip: make sure arp hooks are available
      netfilter: x_tables: don't return garbage pointer on modprobe failure

Gustavo A. R. Silva (1):
      netfilter: return booleans instead of integers

Harsha Sharma (1):
      netfilter: nf_tables: allocate handle and delete objects via handle

Luis de Bethencourt (1):
      netfilter: nf_tables: Fix trailing semicolon

Pablo Neira Ayuso (10):
      netfilter: nf_tables: remove nhooks field from struct nft_af_info
      netfilter: nf_tables: remove flag field from struct nft_af_info
      netfilter: nf_tables: no need for struct nft_af_info to enable/disable table
      netfilter: nf_tables: remove struct nft_af_info parameter in nf_tables_chain_type_lookup()
      netfilter: nf_tables: add single table list for all families
      netfilter: nf_tables: get rid of pernet families
      netfilter: nf_tables: get rid of struct nft_af_info abstraction
      netfilter: core: return EBUSY in case NAT hook is already in use
      netfilter: nf_tables: set flowtable priority and hooknum field
      netfilter: remove messages print and boot/module load time

Subash Abhinov Kasiviswanathan (2):
      netfilter: nf_defrag: Skip defrag if NOTRACK is set
      netfilter: ipv6: nf_defrag: Pass on packets to stack per RFC2460

Taehee Yoo (5):
      netfilter: nf_nat_snmp_basic: remove useless comment
      netfilter: nf_nat_snmp_basic: remove debug parameter
      netfilter: nf_nat_snmp_basic: replace ctinfo with dir.
      netfilter: nf_nat_snmp_basic: use nf_ct_helper_log
      netfilter: nf_nat_snmp_basic: use asn1 decoder library

Wei Yongjun (3):
      netfilter: nf_tables: fix a typo in nf_tables_getflowtable()
      netfilter: core: make local function __nf_unregister_net_hook static
      netfilter: remove duplicated include

 include/net/netfilter/nf_tables.h            |   48 +-
 include/net/netns/nftables.h                 |    8 +-
 include/uapi/linux/netfilter/nf_tables.h     |   10 +
 include/uapi/linux/netfilter_ipv4.h          |    1 +
 include/uapi/linux/netfilter_ipv6.h          |    1 +
 include/uapi/linux/netfilter_ipv6/ip6t_srh.h |   57 ++
 net/bridge/netfilter/ebtables.c              |    2 -
 net/bridge/netfilter/nf_tables_bridge.c      |   54 +-
 net/ipv4/netfilter/Kconfig                   |    5 +-
 net/ipv4/netfilter/Makefile                  |    6 +
 net/ipv4/netfilter/arp_tables.c              |    1 -
 net/ipv4/netfilter/ip_tables.c               |    1 -
 net/ipv4/netfilter/iptable_raw.c             |   31 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c          |    2 +
 net/ipv4/netfilter/nf_nat_snmp_basic.asn1    |  177 ++++
 net/ipv4/netfilter/nf_nat_snmp_basic.c       | 1286 --------------------------
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c  |  235 +++++
 net/ipv4/netfilter/nf_tables_arp.c           |   49 +-
 net/ipv4/netfilter/nf_tables_ipv4.c          |   49 +-
 net/ipv6/netfilter/Kconfig                   |   12 +-
 net/ipv6/netfilter/Makefile                  |    1 +
 net/ipv6/netfilter/ip6_tables.c              |    1 -
 net/ipv6/netfilter/ip6t_srh.c                |  161 ++++
 net/ipv6/netfilter/ip6table_raw.c            |   31 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c      |   15 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c    |    3 +
 net/ipv6/netfilter/nf_flow_table_ipv6.c      |    1 -
 net/ipv6/netfilter/nf_tables_ipv6.c          |   49 +-
 net/netfilter/Kconfig                        |    6 +-
 net/netfilter/core.c                         |    6 +-
 net/netfilter/ipset/ip_set_core.c            |    3 +-
 net/netfilter/ipvs/ip_vs_app.c               |    1 -
 net/netfilter/ipvs/ip_vs_conn.c              |    2 -
 net/netfilter/ipvs/ip_vs_ctl.c               |    3 -
 net/netfilter/nf_conncount.c                 |    2 +-
 net/netfilter/nf_conntrack_core.c            |    6 -
 net/netfilter/nf_conntrack_expect.c          |    1 -
 net/netfilter/nf_conntrack_netlink.c         |    5 -
 net/netfilter/nf_conntrack_standalone.c      |    2 -
 net/netfilter/nf_log.c                       |    1 -
 net/netfilter/nf_queue.c                     |    2 -
 net/netfilter/nf_synproxy_core.c             |    1 -
 net/netfilter/nf_tables_api.c                |  932 +++++++++----------
 net/netfilter/nf_tables_inet.c               |   49 +-
 net/netfilter/nf_tables_netdev.c             |   70 +-
 net/netfilter/nfnetlink.c                    |    4 -
 net/netfilter/nfnetlink_acct.c               |    2 -
 net/netfilter/nfnetlink_cttimeout.c          |    2 -
 net/netfilter/nfnetlink_log.c                |    1 -
 net/netfilter/nfnetlink_queue.c              |    1 -
 net/netfilter/nft_compat.c                   |   18 +-
 net/netfilter/nft_ct.c                       |   16 +-
 net/netfilter/nft_dynset.c                   |    2 +-
 net/netfilter/nft_flow_offload.c             |    4 +-
 net/netfilter/nft_log.c                      |    4 +-
 net/netfilter/nft_masq.c                     |    2 +-
 net/netfilter/nft_meta.c                     |    4 +-
 net/netfilter/nft_nat.c                      |    2 +-
 net/netfilter/nft_redir.c                    |    2 +-
 net/netfilter/x_tables.c                     |    7 +-
 net/netfilter/xt_hashlimit.c                 |    5 +-
 net/netfilter/xt_ipcomp.c                    |    2 +-
 62 files changed, 1241 insertions(+), 2226 deletions(-)
 create mode 100644 include/uapi/linux/netfilter_ipv6/ip6t_srh.h
 create mode 100644 net/ipv4/netfilter/nf_nat_snmp_basic.asn1
 delete mode 100644 net/ipv4/netfilter/nf_nat_snmp_basic.c
 create mode 100644 net/ipv4/netfilter/nf_nat_snmp_basic_main.c
 create mode 100644 net/ipv6/netfilter/ip6t_srh.c
