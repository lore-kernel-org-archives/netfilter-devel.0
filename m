Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65893CD80A4
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 11:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjJJLFc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 07:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjJJLFb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 07:05:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F00AC;
        Tue, 10 Oct 2023 04:05:29 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qqAYF-0001Ys-Q0; Tue, 10 Oct 2023 13:05:23 +0200
Date:   Tue, 10 Oct 2023 13:05:23 +0200
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] iptables 1.8.10 release
Message-ID: <ZSUv81gBDQb2kqHs@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2gznOYqojtGKBm51"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--2gznOYqojtGKBm51
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        iptables 1.8.10

This release contains new features:

- xtables-translate: Support rule insert with index
- Broute table support in ebtables-nft
- nft-variants' debug output (pass multiple '-v' flags) now contains
  sets if present
- Add mld-listener type names to icmp6 match
- Correctly parse meta mark statements in rules even though iptables-nft
  does not emit those

... and fixes:

- Compiler warnings with -Werror=format-security
- Needless install of unsupported xtables.conf file
- Wrong "unknown argument" error message in some corner cases
- ebtables-nft allowed implicitly calling targets by one of their
  options, require '-j <target>' first for consistency with legacy
- Various bugs in ebtables-translate
- Corner-case bug in iptables-nft-restore when deleting a rule inside
  the batch file
- Sloppy rule check command in ip6tables-legacy, producing
  false-positives
- Arptables-nft omitted some inverted options when listing rules
- Parser would not accept long-options with appended argument
  (in form '--opt=arg')
- Ip6tables-nft ignored counter argument ('-c')
- Wrong error message when listing a non-existent chain with
  iptables-nft
- Pointless creation of unused anonymous sets when deleting an
  ebtables-nft rule containing an among match
- Ineffective among match comparison causing ebtables-nft to potentially
  delete the wrong rule
- Sloppy iptables-restore parser accepting junk where chain counters are
  expected
- Missing target name validation in chain rename command
- Icmp match confused type 255 and code 255 with special type "any"
- NDEBUG compiler flag breaks iptables-nft
- Non-functional chain policy counters with iptables-nft
- Zeroing a rule's counters would zero chain policy counters with legacy
  iptables
- Reject '-m conntrack --ctproto 0', it will never match
- Stale meta expression when stripping a match on interface "+" (i.e.,
  any interface name)
- Harmless compiler warning with recent Linux headers

... and documentation updates:

- Add missing chunk types to SCTP match help text (use 'iptables -p sctp
  --help' to see them)
- Document possible false negatives when using 'string' match's BM
  algorithm
- Missing return codes 3 and 4 descriptions in iptables man page
- Misc minor fixes in man pages

You can download the new release from:

https://netfilter.org/projects/iptables/downloads.html#iptables-1.8.10

To build the code, libnftnl 1.2.6 is required:

* http://netfilter.org/projects/libnftnl/downloads.html#libnftnl-1.2.6

In case of bugs, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--2gznOYqojtGKBm51
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.8.10.txt"

Alyssa Ross (1):
  build: use pkg-config for libpcap

Arturo Borrero Gonzalez (1):
  iptables-test.py: make explicit use of python3

Florian Westphal (6):
  xtables-eb: fix crash when opts isn't reallocated
  iptables-nft: make builtin tables static
  iptables-nft: remove unused function argument
  include: update nf_tables uapi header
  ebtables-nft: add broute table emulation
  nft-ruleparse: parse meta mark set as MARK target

Jacek Tomasiak (2):
  iptables: Fix setting of ipv6 counters
  iptables: Fix handling of non-existent chains

Jan Engelhardt (1):
  xshared: dissolve should_load_proto

Jan Palus (1):
  nft: move processing logic out of asserts

Jeremy Sowden (1):
  man: string: document BM false negatives

Markus Boehme (1):
  ip6tables: Fix checking existence of rule

Pablo Neira Ayuso (3):
  nft: check for source and destination address in first place
  nft: use payload matching for layer 4 protocol
  nft-bridge: pass context structure to ops->add() to improve anonymous
    set support

Phil Sutter (76):
  extensions: NAT: Fix for -Werror=format-security
  etc: Drop xtables.conf
  Proper fix for "unknown argument" error message
  ebtables: Refuse unselected targets' options
  ebtables-translate: Drop exec_style
  ebtables-translate: Use OPT_* from xshared.h
  ebtables-translate: Ignore '-j CONTINUE'
  ebtables-translate: Print flush command after parsing is finished
  tests: xlate: Support testing multiple individual files
  tests: CLUSTERIP: Drop test file
  nft-shared: Lookup matches in iptables_command_state
  nft-shared: Use nft_create_match() in one more spot
  nft-shared: Simplify using nft_create_match()
  tests: xlate: Properly split input in replay mode
  tests: xlate: Print file names even if specified
  extensions: libebt_redirect: Fix target translation
  extensions: libebt_redirect: Fix for wrong syntax in translation
  extensions: libebt_ip: Do not use 'ip dscp' for translation
  extensions: libebt_ip: Translation has to match on ether type
  ebtables: ip and ip6 matches depend on protocol match
  xtables-translate: Support insert with index
  include: Add missing linux/netfilter/xt_LOG.h
  nft-restore: Fix for deletion of new, referenced rule
  tests: shell: Test for false-positive rule check
  utils: nfbpf_compile: Replace pcap_compile_nopcap()
  nft-shared: Drop unused include
  arptables: Fix parsing of inverted 'arp operation' match
  arptables: Don't omit standard matches if inverted
  xshared: Fix parsing of option arguments in same word
  nft: Introduce nft-ruleparse.{c,h}
  nft: Extract rule parsing callbacks from nft_family_ops
  nft: ruleparse: Create family-specific source files
  tests: shell: Sanitize nft-only/0009-needless-bitwise_0
  nft: Special casing for among match in compare_matches()
  nft: More verbose extension comparison debugging
  nft: Do not pass nft_rule_ctx to add_nft_among()
  nft: Include sets in debug output
  *tables-restore: Enforce correct counters syntax if present
  *tables: Reject invalid chain names when renaming
  ebtables: Improve invalid chain name detection
  tests: shell: Fix and extend chain rename test
  iptables-restore: Drop dead code
  iptables-apply: Eliminate shellcheck warnings
  extensions: libipt_icmp: Fix confusion between 255/255 and any
  tests: libipt_icmp.t: Enable tests with numeric output
  man: iptables.8: Extend exit code description
  man: iptables.8: Trivial spelling fixes
  man: iptables.8: Fix intra page reference
  man: iptables.8: Clarify --goto description
  man: Use HTTPS for links to netfilter.org
  man: iptables.8: Trivial font fixes
  man: iptables-restore.8: Fix --modprobe description
  man: iptables-restore.8: Consistently document -w option
  man: iptables-restore.8: Drop -W option from synopsis
  man: iptables-restore.8: Put 'file' in italics in synopsis
  man: iptables-restore.8: Start paragraphs in upper-case
  man: Trivial: Missing space after comma
  man: iptables-save.8: Clarify 'available tables'
  man: iptables-save.8: Fix --modprobe description
  man: iptables-save.8: Start paragraphs in upper-case
  extensions: libip6t_icmp: Add names for mld-listener types
  nft-ruleparse: Introduce nft_create_target()
  tests: iptables-test: Fix command segfault reports
  nft: Create builtin chains with counters enabled
  Revert "libiptc: fix wrong maptype of base chain counters on restore"
  tests: shell: Test chain policy counter behaviour
  Use SOCK_CLOEXEC/O_CLOEXEC where available
  nft: Pass nft_handle to add_{target,action}()
  nft: Introduce and use bool nft_handle::compat
  Add --compat option to *tables-nft and *-nft-restore commands
  tests: Test compat mode
  Revert --compat option related commits
  tests: shell: Fix for ineffective 0007-mid-restore-flush_0
  nft: Fix for useless meta expressions in rule
  include: linux: Update kernel.h
  build: Bump dependency on libnftnl

Quentin Armitage (1):
  extensions: Fix checking of conntrack --ctproto 0

Victor Julien (1):
  doc: fix example of xt_cpu

Xin Long (1):
  xt_sctp: add the missing chunk types in sctp_help

--2gznOYqojtGKBm51--
