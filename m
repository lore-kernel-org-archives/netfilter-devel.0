Return-Path: <SRS0=kXi6=7Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D308C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 11:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D4E820678
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 11:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgFCL6a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jun 2020 07:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgFCL63 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jun 2020 07:58:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847D1C08C5C0
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2020 04:58:29 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jgS2N-0000nF-Ul; Wed, 03 Jun 2020 13:58:27 +0200
Date:   Wed, 3 Jun 2020 13:58:27 +0200
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter@vger.kernel.org
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: [ANNOUNCE] iptables 1.8.5 release
Message-ID: <20200603115827.GR31506@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

iptables 1.8.5

This release contains the following fixes and enhancements:

xtables-save/xtables-restore:
- Fix parser in `--noflush' mode incorrectly rejecting chain definitions
  and empty lines.
- Fix crash when restoring or dumping while other ruleset changes happen
  in parallel.

iptables-apply:
- Install the script along with `make install'.
- Introduce parameters `-c' (run command) and `-w' (save successfully
  applied rules to file).
- Use `mktemp' instead of `tempfile' for temporary files.

iptables-translate:
- Support `time' match and `NOTRACK' target.
- Fix for special interface names `*', `+' and `eth++'.

ebtables-nft:
- Full among match support, including sets with mixed MAC and MAC+IP
  entries.

extensions:
- connlabel: Numeric labels were rejected if a connlabel.conf existed in
             the system.
- IDLETIMER: Introduce `--alarm' option.

libxtables:
- Introduce xtables_fini() to properly deinit the library and close any
  loaded shared objects.

nfnl_osf:
- Fix lockup after loading the first line from fingerprints file.
- Improve error handling, don't silently exit when deleting a
  non-existing fingerprint.

General:
- Fixes for undefined behaviour.
- Replace a few unsafe calls to strcpy().
- Fix some warnings when compiling with clang.
- Various fixes for valgrind-detected problems such as memory leaks and
  reachable memory at program exit.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/iptables/downloads.html#iptables-1.8.5

To build the code, libnftnl 1.1.6 is required:

* http://netfilter.org/projects/libnftnl/downloads.html#libnftnl-1.1.6

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="iptables-1.8.5.txt"
Content-Transfer-Encoding: 8bit

Arturo Borrero Gonzalez (1):
      .gitignore: add nano/vim swap file

Jeremy Sowden (1):
      extensions: AUDIT: fix man-page typo.

Jose M. Guisado Gomez (1):
      extensions: time: add translation and tests

Laurence J. Lane (6):
      iptables: install iptables-apply script and manpage
      iptables: cleanup "allows to" usage
      extensions: manpages: cleanup hyphens
      libipq: fix spelling in manpage
      iptables: mention iptables-apply(8) in manpages
      extensions: libxt_sctp: add manpage description

Maciej Żenczykowski (7):
      iptables: open eBPF programs in read only mode
      extensions: include strings.h for the definition of ffs()
      iptables: include sys/time.h to fix lack of struct timeval declaration
      libxt_IDLETIMER: fix target v1 help alignment and doc
      libiptc: do not typedef socklen_t on Android
      iptables: flush stdout after every verbose log.
      libip6t_srh.t: switch to lowercase, add /128 suffix, require success

Manoj Basapathi (1):
      extensions: IDLETIMER: Add alarm timer option

Pablo Neira Ayuso (9):
      build: bump dependency on libnftnl
      extensions: libxt_CT: add translation for NOTRACK
      nft-shared: skip check for jumpto if cs->target is unset
      nft: split parsing from netlink commands
      nft: calculate cache requirements from list of commands
      nft: restore among support
      nft: remove cache build calls
      nft: missing nft_fini() call in bridge family
      configure: bump version for 1.8.5 release

Phil Sutter (64):
      extensions: CLUSTERIP: Mark as deprecated in man page
      Fix DEBUG build
      xtables-restore: Fix parser feed from line buffer
      xtables-restore: Avoid access of uninitialized data
      extensions: time: Avoid undefined shift
      extensions: cluster: Avoid undefined shift
      libxtables: Avoid buffer overrun in xtables_compatible_revision()
      xtables-translate: Guard strcpy() call in xlate_ifname()
      extensions: among: Check call to fstat()
      xtables-translate: Fix for interface name corner-cases
      xtables-restore: fix for --noflush and empty lines
      tests: shell: Fix skip checks with --host mode
      xtables-translate: Fix for iface++
      ebtables: among: Support mixed MAC and MAC/IP entries
      nft: Drop pointless assignment
      iptables-test.py: Fix --host mode
      xtables: Align effect of -4/-6 options with legacy
      xtables: Drop -4 and -6 support from xtables-{save,restore}
      xtables: Review nft_init()
      connlabel: Allow numeric labels even if connlabel.conf exists
      nft: cache: Fix nft_release_cache() under stress
      nft: cache: Make nft_rebuild_cache() respect fake cache
      nft: cache: Simplify chain list allocation
      nft: cache: Review flush_cache()
      nft: cache: Fix for unused variable warnings
      nft: cache: Fix iptables-save segfault under stress
      xshared: Drop pointless assignment in add_param_to_argv()
      tests: shell: Improve ipt-restore/0001load-specific-table_0 a bit
      tests: shell: Extend ipt-restore/0004-restore-race_0
      tests: shell: Test -F in dump files
      tests: shell: Add test for nfbz#1391
      ebtables-restore: Drop custom table flush routine
      nft: cache: Eliminate init_chain_cache()
      nft: cache: Init per table set list along with chain list
      nft: cache: Fetch sets per table
      ebtables-restore: Table line to trigger implicit commit
      nft: cache: Simplify rule and set fetchers
      nft: cache: Improve fake cache integration
      nft: cache: Introduce struct nft_cache_req
      nft-cache: Fetch cache per table
      nft-cache: Introduce __fetch_chain_cache()
      nft: cache: Fetch cache for specific chains
      nft: cache: Optimize caching for flush command
      nft: Fix for '-F' in iptables dumps
      tests: shell: Implement --valgrind mode
      nft: cache: Re-establish cache consistency check
      nft: Clear all lists in nft_fini()
      nft: Fix leaks in ebt_add_policy_rule()
      nft: Fix leak when deleting rules
      ebtables: Free statically loaded extensions again
      libxtables: Introduce xtables_fini()
      nft: Use clear_cs() instead of open coding
      arptables: Fix leak in nft_arp_print_rule()
      nft: Fix leak when replacing a rule
      nft: Don't exit early after printing help texts
      iptables-test: Don't choke on empty lines
      nfnl_osf: Fix broken conversion to nfnl_query()
      nfnl_osf: Improve error handling
      nft: Merge nft_*_rule_find() functions
      nft: Drop save_counters callback from family_ops
      doc: libxt_MARK: OUTPUT chain is fine, too
      tests: shell: Fix syntax in ipt-restore/0010-noflush-new-chain_0
      include: Avoid undefined left-shift in xt_sctp.h
      build: bump dependency on libnftnl

gw.2010@tnode.com (1):
      iptables-apply: script and manpage update

Álvaro Santos (1):
      Fixed some man pages typos ('This modules' -> 'This module')


--nFreZHaLTZJo0R7j--
