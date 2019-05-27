Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189AEC04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 15:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D933520645
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 15:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfE0P1v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 11:27:51 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:41485 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfE0P1u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 11:27:50 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hVHXO-0005yR-Ag; Mon, 27 May 2019 17:27:48 +0200
Date:   Mon, 27 May 2019 17:27:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] iptables 1.8.3 release
Message-ID: <20190527152745.eml637zpc4vdued3@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mzzdfrlm7ycfbhsg"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--mzzdfrlm7ycfbhsg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        iptables 1.8.3

iptables is the userspace command line program used to configure the
Linux 2.4.x and later packet filtering ruleset. It is targeted towards
system administrators.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/

Happy firewalling.

--mzzdfrlm7ycfbhsg
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-iptables-1.8.3.txt"
Content-Transfer-Encoding: 8bit

Adam Gołębiowski (1):
      extensions: format-security fixes in libip[6]t_icmp

Baruch Siach (5):
      ebtables: vlan: fix userspace/kernel headers collision
      xtables-monitor: fix build with older glibc
      include: fix build with kernel headers before 4.2
      xtables-monitor: fix build with musl libc
      include: extend the headers conflict workaround to in6.h

Florian Westphal (12):
      arptables-nft: use generic expression parsing function
      xtables: rename opcodes to arp_opcodes
      xtables: make all nft_parse_ helpers static
      arptables-nft: fix decoding of hlen on bigendian platforms
      tests: return-codes script is bash specific
      xtables: unify user chain add/flush for restore case
      xtables: add skip flag to objects
      xtables: add and use nft_build_cache
      xtables: add and set "implict" flag on transaction objects
      xtables: handle concurrent ruleset modifications
      tests: add test script for race-free restore
      extensions: SYNPROXY: should not be needed anymore on current kernels

Lucas Stach (1):
      xtables-legacy: add missing config.h include

Pablo Neira Ayuso (19):
      nft: add type field to builtin_table
      nft: move chain_cache back to struct nft_handle
      nft: move initialize to struct nft_handle
      xtables: constify struct builtin_table and struct builtin_chain
      extensions: libip6t_mh: fix bogus translation error
      xshared: check for maximum buffer length in add_param_to_argv()
      man: refer to iptables-translate and ip6tables
      nft: add struct nft_cache
      nft: statify nft_rebuild_cache()
      nft: add __nft_table_builtin_find()
      nft: add flush_cache()
      nft: cache table list
      nft: ensure cache consistency
      nft: keep original cache in case of ERESTART
      nft: don't skip table addition from ERESTART
      nft: don't care about previous state in ERESTART
      nft: do not retry on EINTR
      nft: reset netlink sender buffer size of socket restart
      configure: bump versions for 1.8.3 release

Phil Sutter (84):
      libiptc: Extend struct xtc_ops
      ip6tables-restore: Merge into iptables-restore.c
      ip6tables-save: Merge into iptables-save.c
      xtables: Introduce per table chain caches
      arptables: Support --set-counters option
      ebtables: Use xtables_exit_err()
      xtables: Don't use native nftables comments
      extensions: libipt_realm: Document allowed realm values
      extensions: TRACE: Point at xtables-monitor in documentation
      nft: Simplify nftnl_rule_list_chain_save()
      nft: Review unclear return points
      xtables-restore: Review chain handling
      nft: Review is_*_compatible() routines
      nft: Reduce __nft_rule_del() signature
      nft: Reduce indenting level in flush_chain_cache()
      nft: Simplify per table chain cache update
      nft: Simplify nft_rule_insert() a bit
      nft: Introduce fetch_chain_cache()
      nft: Move nft_rule_list_get() above nft_chain_list_get()
      xtables: Implement per chain rule cache
      nft: Drop nft_chain_list_find()
      xtables: Optimize flushing a specific chain
      xtables: Optimize nft_chain_zero_counters()
      tests: Extend verbose output and return code tests
      xtables: Optimize user-defined chain deletion
      xtables: Optimize list command with given chain
      xtables: Optimize list rules command with given chain
      nft: Make use of nftnl_rule_lookup_byindex()
      nft: Simplify nft_is_chain_compatible()
      nft: Simplify flush_chain_cache()
      xtables: Set errno in nft_rule_check() if chain not found
      nft: Add new builtin chains to cache immediately
      xtables: Fix position of replaced rules in cache
      utils: Add a manpage for nfbpf_compile
      xtables: Fix for inserting rule at wrong position
      xtables: Speed up chain deletion in large rulesets
      arptables-nft: Fix listing rules without target
      arptables-nft: Fix MARK target parsing and printing
      arptables-nft: Fix CLASSIFY target printing
      arptables-nft: Remove space between *cnt= and value
      arptables-nft-save: Fix position of -j option
      arptables-nft: Don't print default h-len/h-type values
      tests: shell: Add arptables-nft verbose output test
      xtables: Catch errors when zeroing rule rounters
      ebtables: Fix rule listing with counters
      nft: Fix potential memleaks in nft_*_rule_find()
      arptables-nft: Set h-type/h-length masks by default, too
      extensions: Fix arptables extension tests
      xtables: Fix for crash when comparing rules with standard target
      xtables: Fix for false-positive rule matching
      Revert "ebtables: use extrapositioned negation consistently"
      xshared: Explicitly pass target to command_jump()
      xtables-save: Fix table not found error message
      nft: Don't assume NFTNL_RULE_USERDATA holds a comment
      nft: Introduce UDATA_TYPE_EBTABLES_POLICY
      ebtables-nft: Support user-defined chain policies
      nft: Eliminate dead code in __nft_rule_list
      xtables: Fix error message when zeroing a non-existent chain
      xtables: Move new chain check to where it belongs
      xtables: Fix error messages in commands with rule number
      xtables: Fix error message for chain renaming
      tests: Extend return codes check by error messages
      arptables: Print space before comma and counters
      xlate-test: Support testing host binaries
      tests/shell: Support testing host binaries
      doc: Install ip{6,}tables-translate.8 manpages
      extensions: AUDIT: Document ineffective --type option
      extensions: Fix ipvs vproto parsing
      extensions: Fix ipvs vproto option printing
      extensions: Add testcase for libxt_ipvs
      extensions: connlabel: Fallback on missing connlabel.conf
      doc: Add arptables-nft man pages
      doc: Adjust arptables man pages
      doc: Add ebtables man page
      doc: Adjust ebtables man page
      xtables-legacy.8: Remove stray colon
      xtables-save: Point at existing man page in help text
      extensions: Install symlinks as such
      man: iptables-save: Add note about module autoloading
      xtables: Don't leak iter in error path of __nft_chain_zero_counters()
      tests: Fix ipt-restore/0004-restore-race_0 testcase
      xtables: Fix for explicit rule flushes
      Drop release.sh
      Revert "build: don't include tests in released tarball"

Sam Banks (1):
      extensions: libxt_osf.: Typo in manpage


--mzzdfrlm7ycfbhsg--
