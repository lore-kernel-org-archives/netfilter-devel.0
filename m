Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4EC1E3772;
	Fri,  8 Nov 2024 14:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731077903; cv=none; b=sbyxejXZftOE870XKNvCVhhMpTrnHmDW5mCNTO4lFTWSQzuwZwFvxOU9I2dU3PSy63nX7s7di0vpxjxu8EXmMIORYLI/5j+goUU1Mt2FXcyWCWS4XZl9j2qxMI/6NuJOUVWxGT4WlW9b7XvwhulWTLnh0qj2qxB8vxpXvu1ycg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731077903; c=relaxed/simple;
	bh=9PSeo9wh5Uxi7Cp0HgIdALrWitqTWtG5GR2LQjiWJnY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UU/+G9hW7nzVpfseOJ7ed+JfwZE4aKD2za5mjYARnsrf3uGjlOde5MJAPD02IVzobm8bHQHN1JnY2KoGHv9ileRw0kBB4azL/+pEjfI3y0zXLm3YtgEVCKcHpld3LiEP5MJBLtWPYQowBAsviLbc+6VbLpBwHeb4e+ckUK8n0/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qqroTN9K; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qqroTN9K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ukg+42Q0ORZnlaR0IQWuxwJDybb7eXLMjLuAN9oWdEc=; b=qqroTN9Kp1Nn2RGMAX1LyfyXWm
	Lq50HmuKkiAqKBNoSzAIaklLuHBopcqGY5e83Lxl8cwEHJNC0PgMLUZiEI18sbxieqs2EC1LhR62f
	yHdU18YgWz9T5nXW5NNov5YEF9rSPMZleFcOCPl7xXTOkmAMqehAGIE6wiz9QKNDIHa59v6cf9lZ/
	M6Jgbr4pX0YHy118WOwoRvoYNrXcLZb6h1B9hEqpISdaYHKwuFrcVQPYLnB0XFcDZZJR3ZGnZ8gkg
	QhpINdYir7g+nKUIl75mX0cQzOMCLtdMSbV+6HrhQTpyE5csk6iZjiGW80YJsm+8cofXY3c3lPjfg
	dpF6TxtA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t9QRE-000000003as-28T5;
	Fri, 08 Nov 2024 15:58:16 +0100
Date: Fri, 8 Nov 2024 15:58:16 +0100
From: Phil Sutter <phil@netfilter.org>
To: netfilter <netfilter@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
	lwn@lwn.net
Subject: [ANNOUNCE] iptables 1.8.11 release
Message-ID: <Zy4nCFxZvkkUrjj6@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
	netfilter <netfilter@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
	lwn@lwn.net
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Z2jpFLa81REgb+x8"
Content-Disposition: inline


--Z2jpFLa81REgb+x8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        iptables 1.8.11

This release contains new features:

- New arptables-translate tool
- ebtables-nft:
  - Support for --change-counters command, albeit not atomic
  - Specify rule counters using iptables' '-c N,M' syntax
  - Support --replace and --list-rules commands
  - Support zeroing individual rules
  - Print negations (exclamation marks) extrapositioned (i.e., before
    the match they invert) for consistency with iptables
- iptables-translate:
  - Align protocol name lookups with iptables
  - iptables-translate: Support socket match and TPROXY target
  - iptables-translate: Slightly improved avoidance of redundant 'ip
    protocol'/'meta l4proto' matches
- iptables:
  - Undo numeric protocol printing of v1.8.9 for well-known protocols
    for consistency with iptables-save
  - Enable implicit extension lookup for dccp and ipcomp protocols (so
    no extra '-m <proto>' is needed after '-p <proto>')
- iptables-save: Avoid calls to getprotobynumber() for consistency and
  improved performance with huge rule sets
- libxtables: Support use of both xtables_ipaddr_to_numeric() and
  xtables_ipmask_to_numeric() as parameters to the same function call
- configure: Support disabling use of libnfnetlink
- Prefix xtables-monitor rule events by a typical command (iptables,
  ip6tables) instead of -4/-6 flags for consistency with ebtables and
  arptables events

... and fixes:

- arptables-nft:
  - Ineffective masks when specified in --h-type, --opcode and
    --proto-type matches
  - Wrong formatting of --h-type values and --proto-type masks causing
    misinterpretation by  arptables-restore
- iptables-nft:
  - Wrong error messages in corner-case error conditions
  - Zeroing single rule counters broken (again!)
  - Incorrect combination of inverted payload matches
  - Spurious error when zeroing a specific builtin chain which doesn't
    exist - Calling -Z command with bogus rule number must fail
- libiptc: Corner-case segfault upon renaming a chain
- ebtables-restore:
  - Corner-case bug with --noflush
  - Spurious failures when deleting multiple rules with among matches
- ebtables-nft:
  - Different line number (--Ln) formatting than ebtables-legacy
  - Off-by-one rule number when using -S command with rule number
- iptables-legacy: Broken --wait without timeout
- libxtables: Leak of matches' udata buffer
- Some matches stripped full value ranges from output even if inverted
- Illegal memory access when parsing '-c ""' (i.e., empty string
  argument)
- Inverted full interface wildcards (e.g. '! -i +') stripped from
  iptables-save output
- xtables-monitor:
  - Incorrect output when not called with -4 or -6 options
  - Flush stdout after each line to prevent buffers and help with
    scripting
  - Align output for builtin chains with that of tables
  - Capture arptables chain events, too
  - Empty 'EVENT:' lines printed for ebtables rule changes
- Fix for compiling against musl libc
- xtables-translate: Fix translation of TPROXY target

... and documentation updates:

- Extensions: string: Starting with linux-6.7, pattern matching no
  longer extends past 'to' offset - update the man page accordingly
- Extensions: recent: Clarify ip_list_hash_size default value and
  obsoleted state of ip_pkt_list_tot
- ebtables-nft.8: Note that --concurrent is a NOP
- Misc. typesetting, spelling and grammar fixes in man pages

You can download the new release from:

https://netfilter.org/projects/iptables/downloads.html#iptables-1.8.11

To build the code, libnftnl 1.2.6 is required:

* http://netfilter.org/projects/libnftnl/downloads.html#libnftnl-1.2.6

In case of bugs, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--Z2jpFLa81REgb+x8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.8.11.txt"

Florian Westphal (10):
  arptables-nft: remove ARPT_INV flags usage
  nft-arp: add missing mask support
  nft-arp: add arptables-translate
  arptables-txlate: add test cases
  extensions: MARK: fix arptables support
  extensions: libebt_stp: fix range checking
  extensions: xt_socket: add txlate support for socket match
  extensions: xt_TPROXY: add txlate support
  iptables: tests: add missing make +x
  iptables: tests: shell: use bash, not sh

Jacek Tomasiak (1):
  iptables: Add missing error codes

Jan Engelhardt (15):
  man: display number ranges with an en dash
  man: encode minushyphen the way groff/man requires it
  man: encode emdash the way groff/man requires it
  man: encode hyphens the way groff/man requires it
  man: consistent casing of "IPv[46]"
  man: grammar fixes to some manpages
  man: use native bullet point markup
  man: consistent use of \(em in Name sections
  man: remove lone .nh command
  man: repeal manual hyphenation
  man: stop putting non-terminals in italic
  man: copy synopsis markup from iptables.8 to arptables-nft.8
  man: limit targets for -P option synopsis
  man: more backslash-encoding of characters
  man: proper roff encoding for ~ and ^

Jeremy Sowden (7):
  Fix spelling mistakes
  build: format `AM_CPPFLAGS` variables
  build: remove obsolete `AM_LIBTOOL_SILENT` variable
  build: remove unused `AM_VERBOSE_CXX*` variables
  build: use standard automake verbosity variables
  build: add an automake verbosity variable for `ln`
  build: replace `echo -e` with `printf`

Joshua Lant (2):
  iptables: align xt_CONNMARK with current kernel headers
  configure: Determine if musl is used for build

Maxin B. John (1):
  configure: Add option to enable/disable libnfnetlink

Pablo Neira Ayuso (1):
  tests: iptables-test: extend coverage for ip6tables

Phil Sutter (158):
  libiptc: Fix for another segfault due to chain index NULL pointer
  extensions: string: Clarify description of --to
  extensions: string: Adjust description of --to to recent kernel
    changes
  man: use .TP for lists in xt_osf man page
  man: reveal rateest's combination categories
  ebtables: Fix corner-case noflush restore bug
  arptables: Fix formatting of numeric --h-type output
  arptables: Fix --proto-type mask formatting
  extensions: libarpt_standard.t: Add a rule with builtin option masks
  Makefile: Install arptables-translate link and man page
  nft-bridge: nft_bridge_add() uses wrong flags
  xshared: struct xt_cmd_parse::xlate is unused
  xshared: All variants support -v, update OPTSTRING_COMMON
  xshared: Drop needless assignment in --help case
  xshared: Drop pointless CMD_REPLACE check
  tests: xlate: Print failing command line
  ebtables: Drop append_entry() wrapper
  ebtables: Make ebt_load_match_extensions() static
  ebtables: Align line number formatting with legacy
  xshared: do_parse: Ignore '-j CONTINUE'
  ebtables: Implement --change-counters command
  libxtables: Combine the two extension option mergers
  libxtables: Fix guided option parser for use with arptables
  libxtables: Introduce xtables_strtoul_base()
  libxtables: Introduce struct xt_option_entry::base
  extensions: libarpt_mangle: Use guided option parser
  extensions: MARK: arptables: Use guided option parser
  xshared: Introduce xt_cmd_parse_ops::option_name
  xshared: Introduce xt_cmd_parse_ops::option_invert
  xshared: Simplify generic_opt_check()
  xshared: Entirely ignore interface masks when saving rules
  xshared: Do not populate interface masks per default
  nft: Leave interface masks alone when parsing from kernel
  man: Do not escape exclamation marks
  libxtables: xtoptions: Fix for garbage access in
    xtables_options_xfrm()
  libxtables: xtoptions: Fix for non-CIDR-compatible hostmasks
  xshared: do_parse: Skip option checking for CMD_DELETE_NUM
  xshared: Perform protocol value parsing in callback
  xshared: Turn command_default() into a callback
  xshared: Introduce print_help callback (again)
  xshared: Support rule range deletion in do_parse()
  xshared: Support for ebtables' --change-counters command
  ebtables{,-translate}: Convert if-clause to switch()
  ebtables: Change option values to avoid clashes
  ebtables: Pass struct iptables_command_state to print_help()
  ebtables: Make 'h' case just a call to print_help()
  ebtables: Use struct xt_cmd_parse
  xshared: Introduce option_test_and_reject()
  ebtables: Use do_parse() from xshared
  iptables-legacy: Fix for mandatory lock waiting
  tests: iptables-test: Use difflib if dumps differ
  libxtables: xtoptions: Prevent XTOPT_PUT with XTTYPE_HOSTMASK
  libxtables: xtoptions: Support XTOPT_NBO with XTTYPE_UINT*
  libxtables: xtoptions: Implement XTTYPE_ETHERMACMASK
  libxtables: xtoptions: Treat NFPROTO_BRIDGE as IPv4
  ebtables: Support for guided option parser
  extensions: libebt_*: Drop some needless init callbacks
  extensions: libebt_stp: Use guided option parser
  extensions: libebt_arpreply: Use guided option parser
  extensions: libebt_dnat: Use guided option parser
  extensions: libebt_ip6: Use guided option parser
  extensions: libebt_ip: Use guided option parser
  extensions: libebt_log: Use guided option parser
  extensions: libebt_mark: Use guided option parser
  extensions: libebt_nflog: Use guided option parser
  extensions: libebt_snat: Use guided option parser
  extensions: libebt_redirect: Use guided option parser
  extensions: libebt_802_3: Use guided option parser
  extensions: libebt_vlan: Use guided option parser
  extensions: libebt_arp: Use guided option parser
  extensions: libxt_limit: Use guided option parser for NFPROTO_BRIDGE,
    too
  extensions: libebt_pkttype: Use guided option parser
  extensions: libebt_mark_m: Use guided option parser
  extensions: libxt_HMARK: Review HMARK_parse()
  ebtables: Default to extrapositioned negations
  tests: iptables-test: Increase non-fast mode strictness
  nft: ruleparse: Add missing braces around ternary
  libxtables: Fix memleak of matches' udata
  xtables-eb: Eliminate 'opts' define
  xshared: Fix for memleak in option merging with ebtables
  xshared: Introduce xtables_clear_args()
  ebtables: Fix for memleak with change counters command
  extensions: *.t/*.txlate: Test range corner-cases
  libxtables: xtoptions: Assert ranges are monotonic increasing
  libxtables: Reject negative port ranges
  extensions: ah: Save/xlate inverted full ranges
  extensions: frag: Save/xlate inverted full ranges
  extensions: mh: Save/xlate inverted full ranges
  extensions: rt: Save/xlate inverted full ranges
  extensions: esp: Save/xlate inverted full ranges
  extensions: ipcomp: Save inverted full ranges
  nft: Do not omit full ranges if inverted
  extensions: tcp/udp: Save/xlate inverted full ranges
  libxtables: xtoptions: Respect min/max values when completing ranges
  Revert "xshared: Print protocol numbers if --numeric was given"
  libxtables: Add dccp and ipcomp to xtables_chain_protos
  iptables-save: Avoid /etc/protocols lookups
  nft: Fix for broken recover_rule_compat()
  xtables-translate: Leverage stored protocol names
  xlate: Improve redundant l4proto match avoidance
  xlate: libip6t_mh: Fix and simplify plain '-m mh' match
  xshared: Fix parsing of empty string arg in '-c' option
  libxtables: Attenuate effects of functions' internal static buffers
  man: extensions: recent: Clarify default value of ip_list_hash_size
  extensions: libxt_sctp: Add an extra assert()
  ebtables: Include 'bitmask' value when comparing rules
  man: recent: Adjust to changes around ip_pkt_list_tot parameter
  xtables-monitor: Proper re-init for rule's family
  xtables-monitor: Flush stdout after all lines of output
  xtables-monitor: Align builtin chain and table output
  xtables-monitor: Support arptables chain events
  tests: shell: New xtables-monitor test
  xtables-monitor: Fix for ebtables rule events
  xtables-monitor: Ignore ebtables policy rules unless tracing
  xtables-monitor: Print commands instead of -4/-6/-0 flags
  nft: Fix for zeroing non-existent builtin chains
  extensions: recent: New kernels support 999 hits
  nft: cache: Annotate faked base chains as such
  nft: Fix for zeroing existent builtin chains
  extensions: recent: Fix format string for unsigned values
  extensions: conntrack: Use the right callbacks
  nft: cmd: Init struct nft_cmd::head early
  nft: Add potentially missing init_cs calls
  arptables: Fix conditional opcode/proto-type printing
  xshared: Do not omit all-wildcard interface spec when inverted
  extensions: conntrack: Reuse print_state() for old state match
  xshared: Make save_iface() static
  xshared: Move NULL pointer check into save_iface()
  libxtables: Debug: Slightly improve extension ordering debugging
  arptables: Introduce print_iface()
  ebtables: Omit all-wildcard interface specs from output
  ebtables: Zero freed pointers in ebt_cs_clean()
  ebtables: Introduce nft_bridge_init_cs()
  nft: Reduce overhead in nft_rule_find()
  nft: ruleparse: Drop 'iter' variable in
    nft_rule_to_iptables_command_state
  extensions: TPROXY: Fix for translation being non-terminal
  tests: shell: Adjust for recent changes in libnftnl
  tests: iptables-test: Append stderr output to log file
  man: xtables-legacy.8: Join two paragraphs
  man: ebtables-nft.8: Note that --concurrent is a NOP
  gitignore: Ignore generated arptables-translate.8
  xshared: iptables does not support '-b'
  ebtables: Fix for -S with rule number
  nft: Fix for -Z with bogus rule number
  tests: shell: Test some commands involving rule numbers
  tests: iptables-test: Fix for duplicate supposed-to-fail errors
  tests: shell: Fix for 'make distcheck'
  ebtables: Clone extensions before modifying them
  ebtables: Simplify ebt_add_{match,watcher}
  tests: shell: Test ebtables-restore deleting among matches
  tests: iptables-test: Properly assert rule deletion errors
  tests: iptables-test: Extend fast mode docs a bit
  tests: shell: iptables/0010-wait_0 is unreliable
  tests: shell: Print escape sequences with terminals only
  tests: iptables-test: Fix for 'make distcheck'
  tests: xlate-test: Fix for 'make distcheck'
  Makefile.am: Revert to old serial test harness
  libxtables: Hide xtables_strtoul_base() symbol

Sriram Rajagopalan (1):
  nft: Do not combine inverted payload matches

--Z2jpFLa81REgb+x8--
