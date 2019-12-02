Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4272AC43215
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 17:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18B4D20848
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 17:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfLBRBX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 12:01:23 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:54060 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbfLBRBX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 12:01:23 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ibp4b-0005EJ-2R; Mon, 02 Dec 2019 18:01:21 +0100
Date:   Mon, 2 Dec 2019 18:01:21 +0100
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter@vger.kernel.org
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: [ANNOUNCE] iptables 1.8.4 release
Message-ID: <20191202170121.GB10243@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

iptables 1.8.4

This release contains the following fixes and enhancements:

libiptc:
 - Generic libiptc.so shared object is no longer built, likely all users
   link to libip4tc.so or libip6tc.so directly.

xtables-restore and xtables-save:
 - Fix for wrong counter format in 'ebtables-nft-save -c' output.
 - Print typical iptables-save comments in arptables- and ebtables-save,
   too.
 - Fix for spurious errors with odd characters in rule comments.

iptables-legacy:
 - Add --suppl-groups option to owner match.
 - Fix nfacct on mixed 64/32bit kernel/userland.

iptables-nft:
 - Avoid endless loop when called as non-root user.
 - Fix for table compatibility checking considering only non-interesting
   tables.
 - Remove support for /etc/xtables.conf.
 - Various performance improvements when dealing with large rulesets.
 - Fix --fragment option on Big Endian.
 - Fix zeroing rule counters with TPROXY target.

iptables-restore:
 - Restore support for '-4' and '-6' prefixes in rule lines.

ebtables-nft:
 - Fix for spurious errors when using '-o' option in user-defined
   chains.
 - Add rudimental support for among match.

iptables-translate:
 - Fix translation for conntrack status EXPECTED.
 - Support SYNPROXY target.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/iptables/downloads.html#iptables-1.8.4

To build the code, libnftnl 1.1.5 is required:

* http://netfilter.org/projects/libnftnl/index.html

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-1.8.4.txt"

Adel Belhouane (1):
  restore legacy behaviour of iptables-restore when rules start with -4/-6

Duncan Roe (1):
  netfilter: hashlimit: prefer PRIu64 to avoid warnings on 32bit platforms

Fernando Fernandez Mancera (1):
  utils: nfnl_osf: fix snprintf -Wformat-truncation warning

Florian Westphal (6):
  extensions/libxt_MASQUERADE.man: random and random-fully are now identical
  nft: exit in case we can't fetch current genid
  ebtables: fix over-eager -o checks on custom chains
  libiptc: axe non-building debug code
  libiptc: silence two comiler warnings
  ipables: xtables-restore: output filename option in help text

Jan Engelhardt (2):
  build: remove -Wl,--no-as-needed and libiptc.so
  src: replace IPTABLES_VERSION by PACKAGE_VERSION

Jose M. Guisado Gomez (1):
  extensions: libxt_SYNPROXY: add xlate method

Joseph C. Sible (1):
  doc: Note REDIRECT case of no IP address

Juliana Rodrigueiro (1):
  extensions: nfacct: Fix alignment mismatch in xt_nfacct_match_info

Lukasz Pawelczyk (1):
  extensions: libxt_owner: Add supplementary groups option

Phil Sutter (92):
  xtables-restore: Fix program names in help texts
  nft: Set socket receive buffer
  nft: Pass nft_handle down to mnl_batch_talk()
  nft: Move send/receive buffer sizes into nft_handle
  xtables-save: Use argv[0] as program name
  ebtables: Fix error message for invalid parameters
  ebtables-save: Fix counter formatting
  xtables-save: Unify *-save header/footer comments
  xtables-save: Fix table compatibility check
  nft: Make nft_for_each_table() more versatile
  xtables-save: Avoid mixed code and declarations
  xtables-save: Pass optstring/longopts to xtables_save_main()
  xtables-save: Make COMMIT line optional
  xtables-save: Pass format flags to do_output()
  arptables-save: Merge into xtables_save_main()
  ebtables-save: Merge into xtables_save_main()
  nft: Set errno in nft_rule_flush()
  xtables: Drop support for /etc/xtables.conf
  doc: Install nft-variant man pages only if enabled
  doc: Install ip{6,}tables-restore-translate.8 man pages
  nft: Drop stale include directive
  iptables-test: Support testing host binaries
  tests/shell: Make ebtables-basic test more verbose
  DEBUG: Print to stderr to not disturb iptables-save
  nft: Use nftnl_*_set_str() functions
  nft: Introduce nft_bridge_commit()
  nft Increase mnl_talk() receive buffer size
  nft: Fix add_bitwise_u16() on Big Endian
  xtables_error() does not return
  nft: Fix typo in nft_parse_limit() error message
  nft: Get rid of NFT_COMPAT_EXPR_MAX define
  tests/shell: Speed up ipt-restore/0004-restore-race_0
  tests: shell: Support running for legacy/nft only
  nft: Fix for add and delete of same rule in single batch
  nft: Make nftnl_table_list_get() fetch only tables
  xtables-restore: Minimize caching when flushing
  nft: Pass nft_handle to flush_cache()
  nft: Avoid nested cache fetching
  nft: Extract cache routines into nft-cache.c
  iptables-test: Run tests in lexical order
  nft-cache: Introduce cache levels
  nft-cache: Fetch only chains in nft_chain_list_get()
  nft-cache: Cover for multiple fetcher invocation
  nft-cache: Support partial cache per table
  nft-cache: Support partial rule cache per chain
  nft: Reduce cache overhead of nft_chain_builtin_init()
  nft: Support nft_is_table_compatible() per chain
  nft: Optimize flushing all chains of a table
  xtables-restore: Treat struct nft_xt_restore_parse as const
  xtables-restore: Use xt_params->program_name
  xtables-restore: Introduce rule counter tokenizer function
  xtables-restore: Constify struct nft_xt_restore_cb
  iptables-restore: Constify struct iptables_restore_cb
  xtables-restore: Drop local xtc_ops instance
  xtables-restore: Drop chain_list callback
  xtables-restore: Fix --table parameter check
  xtables-restore: Unbreak *tables-restore
  nft: Use ARRAY_SIZE() macro in nft_strerror()
  iptables-xml: Use add_param_to_argv()
  xshared: Introduce struct argv_store
  xtables-arp: Use xtables_ipparse_multiple()
  ip6tables, xtables-arp: Drop unused struct pprot
  xshared: Share a common add_command() implementation
  xshared: Share a common implementation of parse_rulenumber()
  Merge CMD_* defines
  xtables-arp: Drop generic_opt_check()
  Replace TRUE/FALSE with true/false
  xtables-arp: Integrate OPT_* defines into xshared.h
  xtables-arp: Drop some unused variables
  xtables-arp: Use xtables_parse_interface()
  nft-arp: Use xtables_print_mac_and_mask()
  xtables-restore: Integrate restore callbacks into struct nft_xt_restore_parse
  xtables-restore: Introduce struct nft_xt_restore_state
  xtables-restore: Introduce line parsing function
  xtables-restore: Remove some pointless linebreaks
  xtables-restore: Allow lines without trailing newline character
  xtables-restore: Improve performance of --noflush operation
  tests: shell: Add ipt-restore/0007-flush-noflush_0
  nft: CMD_ZERO needs a rule cache
  nft: Fix -Z for rules with NFTA_RULE_COMPAT
  nft: family_ops: Pass nft_handle to 'add' callback
  nft: family_ops: Pass nft_handle to 'rule_find' callback
  nft: family_ops: Pass nft_handle to 'print_rule' callback
  nft: family_ops: Pass nft_handle to 'rule_to_cs' callback
  nft: Keep nft_handle pointer in nft_xt_ctx
  nft: Eliminate pointless calls to nft_family_ops_lookup()
  nft: Introduce NFT_CL_SETS cache level
  nft: Support NFT_COMPAT_SET_ADD
  nft: Bore up nft_parse_payload()
  nft: Embed rule's table name in nft_xt_ctx
  nft: Support parsing lookup expression
  nft: bridge: Rudimental among extension support

Quentin Armitage (1):
  extensions: fix iptables-{nft,translate} with conntrack EXPECTED

Shekhar Sharma (1):
  iptables-tests: fix python3

--KsGdsel6WgEHnImy--
