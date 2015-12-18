From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] iptables 1.6.0 release
Date: Fri, 18 Dec 2015 21:04:53 +0100
Message-ID: <20151218200453.GA13109@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Transfer-Encoding: 8bit
Cc: netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
	lwn@lwn.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        iptables 1.6.0

This release includes accumulated fixes and enhancements for the
following matches:

* ah
* connlabel
* cgroup
* devgroup
* dst
* icmp6
* ipcomp
* ipv6header
* quota
* set
* socket
* string

and targets:

* CT
* REJECT
* SET
* SNAT
* SNPT,DNPT
* SYNPROXY
* TEE

We also got rid of the very very old MIRROR and SAME targets and the
unclean match, that were removed from the kernel tree long time ago.
We also got patches to update different aspects of our manpages.

Moreover, this release includes the first official release of the
iptables over nftables infrastructure, which includes the following
utilities:

* iptables-compat
* iptables-compat-save
* iptables-compat-restore
* ip6tables-compat
* ip6tables-compat-save
* ip6tables-compat-restore
* ebtables-compat
* arptables-compat

that have the same getopt-based parser as the native tool, so the
syntax remains the same, eg.

 # iptables-compat -P INPUT DROP
 # iptables-compat -A INPUT -m state --state ESTABLISHED,RELATED
 # iptables-compat -A INPUT -m state --state NEW -p tcp --dport 22 -j ACCEPT
 # iptables-compat -A INPUT -m state --state INVALID -j LOG  --log-prefix "INVALID: "

This infrastructure will allow us to provide an easy path for users to
translate their iptables rulesets to the new nft syntax. Note that
this translation infrastructure and the compat glue code in the nft
userspace tool is still under development, so that is not included in
this release.

The development of ebtables-compat and arptables-compat utilities were
started by Giuseppe Longo, and followed up later on by Arturo Borrero.
This effort was partially covered by the Google Summer of Code
program.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/conntrack-tools/downloads.html
ftp://ftp.netfilter.org/pub/conntrack-tools/

Help us testing and report bugs, thanks!

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="changes-iptables-1.6.0.txt"
Content-Transfer-Encoding: 8bit

Ana Rey (7):
      xtables-standalone: call nft_fini in the error path
      nft: fix memory leaks in nft_xtables_config_load
      iptables: nft: fix memory leaks in nft_fini
      extensions: libxt_devgroup: Fix the path of the group mappings file
      iptables-compat: homogenize error messages
      extensions: devgroup: fix showing and saving of dst-group
      iptables-compat: homogenize error messages with 'R' option

Andreas Herz (3):
      extension: libip6t_ipv6header: fix wrong headername in ipv6header for protocols
      extensions: icmp6: added missing icmpv6 dest-unreach codes
      added missing icmpv6 codes in REJECT

Anton Danilov (1):
      xtables: SET target: Add mapping of meta informations (skbinfo ipset extension)

Arturo Borrero (38):
      iptables-compat: kill add_*() invflags parameter
      nft-compat: create a separated object update type to rename chains
      nft-bridge: fix printing of inverted protocols, addresses
      nft-bridge: fix inversion of builtin matches
      iptables: xtables-eb: delete extra 'policy' printf
      iptables: xtables-eb: user-defined chains default policy is always RETURN
      iptables: xtables-eb: fix renaming of chains
      extensions: add ebt 802_3 extension
      ebtables-compat: fix counter listing
      ebtables-compat: fix printing of extension
      ebtables-compat: fix segfault in rules w/o target
      ebtables-compat: include /etc/ethertypes in tarball
      ebtables-compat: fix ACCEPT printing by simplifying logic
      include: cache copy of Linux header uapi/linux/netfilter_bridge/ebt_802_3.h
      ebtables-compat: add nft rule compat information to bridge rules
      ebtables-compat: prevent options overwrite
      ebtables-compat: prevent same matches to be included multiple times
      ebtables-compat: include rule counters in ebtables rules
      ebtables-compat: fix nft payload bases
      ebtables-compat: add 'ip' match extension
      ebtables-compat: add mark_m match extension
      extensions: cleanup commented code in ebtables-compat extensions
      libxtables: search first for AF-specific extension
      ebtables-compat: call extensions final checks
      ebtables-compat: finish target infrastructure
      ebtables-compat: add mark target extension
      ebtables-compat: add watchers support
      ebtables-compat: add log watcher extension
      arptables-compat: add mangle target extension
      libxt_quota: fix _save() invert syntax
      ebtables-compat: support nflog extension
      arptables-compat: add support for the CLASSIFY target
      arptables-compat: delete extra space in target printing
      ebtables-compat: add support for limit extension
      ebtables-compat: add a bridge-specific exit_error function
      ebtables-compat: fix rule deleting with -D in rules with no target
      list: fix prefetch dummy
      libxtables: find extensions based on family too

Arturo Borrero Gonzalez (1):
      ebtables-compat: fix misplaced function attribute on ebt_print_error()

Dan Wilder (1):
      libxtables: move some code to avoid cautions in vfork man page

Daniel Borkmann (4):
      iptables: snat: add randomize-full support
      iptables: add libxt_cgroup frontend
      cgroup, man: improve man-page bits
      libxt_CT: add support for recently introduced zone options

Domen Puncer (1):
      libxtables: fix getaddrinfo return value usage

Felix Janda (5):
      consistently use <errno.h>
      include: remove libc5 support code
      include: Sync with ethernetdb.h from ebtables
      include Use <stdint.h> types from xtables.h
      include: Sync with upstream kernel headers

Florian Westphal (15):
      Merge branch 'stable-1.4.20'
      iptables.8: --policy is either ACCEPT or DROP
      extensions: libxt_connlabel: do not open config file from _init hook
      man: string: document icase
      tests: split into family and table specific files
      tests: add test case for xt_recent regression
      extensions: remove MIRROR
      extensions: remove SAME target
      extensions: remove 'unclean' match
      extensions: add more test cases for iptables-test.py
      extensions: SNPT,DNPT: fix save/print output
      extensions/libxt_recent.t: add test case for 3.19 regression
      extensions: libip6t_dst: make inversion work
      tests: remove old test cases
      man: using physdev match in OUTPUT is not supported anymore

Giuseppe Longo (33):
      nft: fix leak of rule and chain iterators
      nft: fix leak of chain iterator in nft_rule_list
      xtables: allow to zero chains via -Z
      nft: break loop after found matching chain
      nft: print counter issues
      nft: fix another memleak in nft_rule_list_cb
      xtables: nft: display rule by number via -L
      nft: associate table configuration to handle via nft_init
      nft: fix family operation lookup
      nft: load only the tables of the current family
      nft: refactoring parse operations for more genericity
      xtables: bootstrap ARP compatibility layer for nftables
      xtables: nft-arp: implements is_same op for ARP family
      xtables: arp: add rule replacement support
      xtables: arp: add delete operation
      xtables: arp: zeroing chain counters
      nft: arp: initialize flags in nft_arp_parse_meta
      nft: arp: add parse_target to nft_family_ops_arp
      nft: arp: fix possible string overflow
      nft: adds save_matches_and_target
      nft-arp: adds nft_arp_save_firewall
      xtables-events: prints arp rules
      nft-arp: fix is_same_interfaces arguments
      nft-arp: wrong condition in parse_payload
      nft: replace nft_rule_attr_get_u8
      nft: save: fix the printing of the counters
      nft-arp: remove wrong conditions
      nft: compare layer 4 protocol in first place
      nft: add nft_xt_ctx struct
      nft: fix syntax error in nft_parse_cmp()
      nft-ipv46: replace offset var with ctx->payload.offset
      ebtables-compat: fix print_header
      ebtables-compat: build ebtables extensions

Gustavo Zacarias (1):
      iptables-save: remove dlfcn.h include

Harout Hedeshian (2):
      extensions: libxt_socket: add --restore-skmark option
      extensions: libxt_socket: update man pages and tests for --restore-skmark

Jan Engelhardt (3):
      iptables: link against libnetfilter_conntrack
      build: resolve build error involving libnftnl
      extensions: restore matching any SPI id by default

Jiri Popelka (9):
      iptables: fix version in iptables(8)
      update FSF address in license text
      iptables: missing bracket in iptables-save(8)
      iptables-restore.8: missing -T in synopsis
      iptables-restore.8: file to read from can be specified as argument
      iptables-{save,restore}: warn that -b/--binary isn't implemented
      iptables-save: actually parse -M/--modprobe option
      iptables: add optional [seconds] argument to -w
      libxt_tcp: manpage correction

Jozsef Kadlecsik (1):
      Alignment problem between 64bit kernel 32bit userspace

Loganaden Velvindron (1):
      extensions: libxt_TEE: Trim kernel struct to allow deletion

Mart Frauenlob (2):
      extensions: libxt_set: Add missing hyphen to --bytes-eq synopsis in manpage
      libxtables: Print meaningful error message for an invalid MAC address string

Martin Topholm (1):
      extensions: libxt_SYNPROXY: initial manual page

Mike Frysinger (4):
      configure: fix 3rd arg w/AC_ARG_ENABLE
      build: add finer module blacklisting
      libiptc: fix fortify errors in debug code
      iptables: update gitignore list

Nicolas Dichtel (1):
      iptables: fix compilation when lib[mnl|nftables] are not in standard path

Pablo Neira Ayuso (186):
      add iptables unit test infrastructure
      extensions: libipt_ah: add unit test
      extensions: libip6t_ah: add unit test
      extensions: libipt_LOG: add unit test
      extensions: libxt_addrtype: add unit test
      extensions: libip6t_LOG: add unit test
      extensions: libxt_cluster: add unit test
      extensions: libxt_comment: add unit test
      extensions: libxt_AUDIT: add unit test
      extensions: libxt_CHECKSUM: add unit test
      extensions: libxt_CLASSIFY: add unit test
      extensions: libxt_connbytes: add unit test
      extensions: libxt_connlimit: add unit test
      extensions: libxt_connmark: add unit test
      extensions: libxt_CONNMARK: add unit test
      extensions: libxt_hashlimit: add unit test
      extensions: libxt_time: add unit test
      extensions: libxt_length: add unit test
      extensions: libxt_udp: add unit test
      extensions: libxt_tcp: add unit test
      extensions: libxt_tos: add unit test
      extensions: libxt_NFLOG: add unit test
      extensions: libxt_dccp: add unit test
      extensions: libxt_esp: add unit test
      extensions: libxt_helper: add unit test
      extensions: libipt_icmp: add unit test
      extensions: libxt_NFQUEUE: add unit test
      extensions: libipt_ttl.t: add unit test
      extensions: libxt_pkttype: add unit test
      extensions: libxt_CT: add unit test
      extensions: libxt_state: add unit test
      extensions: libxt_string: add unit test
      extensions: libxt_rateest: add unit test
      extensions: libxt_nfacct: add unit test
      extensions: libxt_mark: add unit test
      extensions: libipt_REJECT: add unit test
      extensions: libxt_sctp: add unit test
      extensions: libxt_NOTRACK: add unit test
      extensions: libipt_MASQUERADE: add unit test
      extensions: libxt_standard: add unit test
      extensions: libipt_ECN: add unit test
      extensions: libxt_TRACE: add unit test
      extensions: libxt_TOS: add unit test
      extensions: libxt_DSCP: add unit test
      extensions: libip6t_eui64: add unit test
      extensions: libxt_limit: add unit test
      extensions: libxt_conntrack: add unit test
      extensions: libipt_ULOG: add unit test
      extensions: libxt_multiport: add unit test
      extensions: libip6t_REJECT: add unit test
      extensions: libxt_dscp: add unit test
      extensions: libxt_cpu: add unit test
      extensions: libxt_quota: add unit test
      extensions: libxt_iprange: add unit test
      extensions: libxt_physdev: add unit test
      extensions: libxt_TEE: add unit test
      extensions: libipt_SNAT: add unit test
      extensions: libip6t_DNAT: add unit test
      extensions: libxt_owner: add unit test
      extensions: libxt_MARK: add unit test
      build: don't include tests in released tarball
      use nf_tables and nf_tables compatibility interface
      automatic creation of built-in table and chains
      rework automatic creation of built-in table and chains
      iptables: nft: add -f support
      nft: fix missing rule listing in custom chains with -L
      headers: remove unused compatibility definitions
      iptables: nft: move priority to chain instead of table
      iptables: nft: remove __nft_check_rule
      iptables: nft: use 64-bits handle
      iptables: nft: use chain types
      xtables-restore: add support for dormant tables
      nft: adapt chain rename to recent Patrick's updates
      xtables: fix crash due to using wrong globals
      xtables-restore: fix custom user chain restoration
      xtables: fix compilation warning
      xtables: purge out user-define chains from the kernel
      xtables-restore: support atomic commit
      xtables: nft: add protocol and flags for xtables over nf_tables
      xtables-restore: support test option `-t'
      nft: fix crash if TRACE is used
      xtables: ipv6: fix wrong error if -p is used
      xtables: ipv6: add missing break in nft_parse_payload_ipv6
      xtables: ipv6: fix -D with -p
      add xtables-events
      xtables-restore: add -4 and -6 support
      xtables-save: add -4 and -6 support
      nft: remove license for header file
      xtables: fix missing xtables_exit_error definition
      xtables-standalone: fix error message
      xtables-config: priority has to be per-chain to support
      nft: load tables and chains based on /etc/xtables.conf
      xtables: support family in /etc/xtables.conf file
      xtables-config: fix off by one in parsed strings from /etc/xtables.conf
      xtables: fix missing protocol and invflags
      xtables-config-parser: fix compilation warning
      iptables: update .gitignore
      xtables: add new container xtables_args structure
      xtables: add new nft_ops->post_parse hook
      xtables: remove unused leftover definitions
      xtables: fix compilation due to missing autogenerated header
      nft: don't call nft_init in nft_xtables_config_load
      xtables-restore: output the same error message that iptables-restore uses
      xtables: fix -p protocol
      nft: fix leaks in nft_xtables_config_load
      xtables: remove bogus comment on chain rename
      xtables: nft: remove lots of useless debugging messages
      xtables: do not proceed if nft_init fails
      xtables: fix missing afinfo configuration
      xtables: nft: display rule number via -S
      xtables-events: print usage on wrong arguments
      xtables-events: fix missing newline in table and chain events
      nft: fix built-in chain ordering of the nat table
      src: use nft_*_list_add_tail
      nft: break chain listing if only one if looked for
      nft: fix selective chain display via -S
      xtables: add -I chain rulenum
      xtables: remove bogus comment regarding rule replacement
      nft: no need for rule lookup if no position specified via -I
      xtables: fix typo in add_entry for the IPv6 case
      nft: fix match revision lookup for IPv6
      etc: add default IPv6 table and chain definitions
      xtables: use xtables_rule_matches_free
      nft: fix wrong flags handling in print_firewall_details
      nft: use xtables_print_num
      nft: generalize rule addition family hook
      xtables: nft-arp: fix endianess in nft_arp_parse_payload
      nft: consolidate nft_rule_find for ARP, IPv4 and IPv6
      nft: consolidate nft_rule_new to support ARP
      nft: consolidate nft_rule_* functions to support ARP
      include: cache netfilter_arp kernel headers
      nft: adapt nft_rule_expr_get to use uint32_t instead of size_t
      xtables: batch rule-set updates into one single netlink message
      xtables: fix missing ipt_entry for MASQUERADE target
      nft: pass ipt_entry to ->save_firewall hook
      nft: fix bad length when comparing extension data area
      nft: fix interface wildcard matching
      xtables-events: fix compilation due change in libnftables
      nft: fix inversion of built-in selectors
      nft: fix out of bound memory copy
      nft: fix wrong function to release iterator
      nft: fix inconsistent data type in NFT_EXPR_CMP_OP and NFT_EXPR_META_KEY
      configure: fix wrong reference to the conntrack-tools
      configure: rename --disable-xtables to --disable-nftables
      configure: conditional dependencies for nftables-compat
      xtables-restore: remove dependency with libip4tc
      xtables: add xtables-compat-multi for the nftables compatibility layer
      nft-compat: fix IP6T_F_GOTO flag handling
      nft-compat: fix wrong protocol context in initialization
      Merge branch 'nft-compat'
      iptables.8: update coreteam members from manpage
      Merge branch 'next-3.14'
      iptables: nft: generalize batch infrastructure
      iptables: nft: remove unused code
      iptables: nft: add tables and chains to the batch
      Makefile: fix static compilation iptables-compat without shared libraries
      iptables-compat: fix address prefix
      iptables-compat: nft: use nft_batch_begin and nft_batch_end from libnftnl
      iptables-compat: fix use after free in the batch send path
      iptables-compat: get rid of error reporting via perror
      Merge branch 'tests'
      iptables-compat: nft: fix user chain addition, deletion and rename
      iptables-compat: nft: fix error reporting
      arptables-compat: fix missing error reporting
      arptables-compat: allow to not specify a target
      arptables-compat: get output in sync with arptables -L -n --line-numbers
      arptables-compat: remove save code
      refresh nf_tables.h cached copy
      iptables-compat: fix chain policy reset with iptables -L -n
      iptables-compat: statify unused built-in table/chain functions
      iptables-compat: assume chain policy NF_ACCEPT when creating built-in chains
      iptables-compat: fix empty chains after first invocation of iptables-compat -L
      Merge branch 'ipset'
      nft: bootstrap ebtables-compat
      ebtables-compat: use ebtables_command_state in bootstrap code
      iptables: use flock() instead of abstract unix sockets
      Merge branch 'ebtables-compat'
      xshared: calm down compilation warning
      xtables-compat: remove unused fields from bridge and arp families
      iptables-compat: unset context flags in netlink delinearize step
      Merge branch 'ipset-next'
      extensions: fix several test errors
      iptables-compat: use new symbols in libnftnl
      iptables-compat: Keep xtables-config and xtables-events out from tree
      iptables 1.6.0 release
      iptables: fix static builds

Phil Oester (1):
      iptables-xml: fix segfault if missing space after -A

Ronald Wahl (1):
      libxtables: fix two off-by-one memory corruption bugs

Thomas Woerner (2):
      iptables-compat: Allow to insert into rule_count+1 position
      iptables-compat: Increase rule number only for the selected table and chain

Tomasz Bursztyka (41):
      headers: Make nf_tables.h up to date
      nft: Add support for chain rename options (-E)
      iptables: nft: Fix -D chain rulenum option
      iptables: nft: Refactor __nft_rule_check to return rule handle when relevant
      iptables: nft: Add support for -R option
      xtables: add IPv6 support
      nft: Split nft core to become family independant
      xtables: initialize xtables defaults even on listing rules
      xtables: policy can be changed only on builtin chain
      nft: Set the rule family when creating a new one
      nft: Handle error on adding rule expressions
      xtables: Remove useless parameter to nft_chain_list_find
      nft: add function to test for a builtin chain
      nft: Fix small memory leaks
      xtables: Do not dump before command parsing has been finished
      nft: Remove useless function
      nft: Optimize rule listing when chain and rulenum are provided
      nft: Make internal rule listing callback more generic
      nft: Remove useless test on rulenum in nft_rule_list()
      nft: Generalize nft_rule_list() against current family
      nft: Print unknown target data only when relevant
      nft: convert rule into a command state structure
      xtables: allow to reset the counters of an existing rule
      nft: Fix a minor compilation warning
      nft: skip unset tables on table configuration emulation
      xtables: arp: Store target entry properly and compare them relevantly
      extensions: add arptables' libxt_mangle.c for xtables-arp
      extensions: libxt_mangle: Fixes option issues
      nft: Header inclusion missing
      xtables: arp: Parse properly target options
      nft: fix wrong target size
      xtables: arp: Fix a compilation warning
      xtables: arp: inhibit -l option so only a fixed 6 bytes length arhln can be used
      include: Update nftables API header in sync with kernel's one
      nft: Use new libnftnl library name against former libnftables
      xtables: Add backward compatibility with -w option
      nft: Add useful debug output when a builtin table is created
      nft: A builtin chain might be created when restoring
      nft: Initialize a table only once
      nft: Remove useless error message
      nft: Pass a line after printing out a debug message

Ville Skyttä (1):
      iptables: Spelling fixes

Willem de Bruijn (1):
      include: add linux/filter.h

fan.du (1):
      iptables: Add IPv4/6 IPcomp match support


--BOKacYhQ+x31HxR3--
