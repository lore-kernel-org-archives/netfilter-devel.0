Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8113DC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 15:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJFPIB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 11:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJFPIA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 11:08:00 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46D7B56D0;
        Thu,  6 Oct 2022 08:07:51 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ogSTT-0002Bt-R5; Thu, 06 Oct 2022 17:07:47 +0200
Date:   Thu, 6 Oct 2022 17:07:47 +0200
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter-announce@lists.netfilter.org
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
        lwn@lwn.net
Subject: [ANNOUNCE] conntrack-tools 1.4.7 release
Message-ID: <Yz7vQ0ku39dUT3Of@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter-announce@lists.netfilter.org, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org, lwn@lwn.net
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qk/Pc/5uyi/BG8zw"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--qk/Pc/5uyi/BG8zw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

conntrack-tools 1.4.7

This release contains new features:

* IPS_HW_OFFLOAD flag specifies that a conntrack entry has been
  offloaded into the hardware
* 'clash_resolve' and 'chaintoolong' stats counters
* Default to unspec family if '-f' flag is absent to improve support for
  dual-stack setups
* Support filtering events by IP address family
* Support flushing per IP address family
* Add "save" output format representing data in conntrack parameters
* Support loading conntrack commands from a batch file, e.g. generated
  by "save" output format
* Annotate portid in events by the program name (if found)
* Accept yes/no as synonyms to on/off in conntrackd.conf
* Support user space helper auto-loading upon daemon startup, relieving
  users from manual 'nfct add helper' calls
* Filter dumps by status on kernel side if possible
* Accept to filter for any status other than SEEN_REPLY using
  'UNREPLIED'
* Use libmnl internally
* Reuse netlink socket for improved performance with bulk CT entry loads
* Remove '-o userspace' flag and always tag user space triggered events
* Introduce '-A' command, a variant of '-I' which does not fail if the
  entry exists already

... and fixes:

* ICMP entry creation would fail when reply data was specified
* Sync zone value also
* Log external inject problems as warning only
* Endianness bug parsing IP addresses
* Ignore conntrack ID when looking up cache entries to allow for stuck
  old ones to be replaced eventually
* Broken parsing of IPv6 M-SEARCH requests in ssdp cthelper
* Eliminate the need for lazy binding in nfct
* Fix for use of unknown protocol values
* Sanitize protocol value parsing, catch illegal values
* Ensure unknown protocol values are included in '-o save' dumps

... and documentation updates:

* Fixed examples in manual
* Refer to nf_conntrack sysctl instead of the deprecated ip_conntrack
  one
* Misc updates to the manual
* Add an older example script creating an active-active setup using the
  cluster match

You can download the new release from:

https://netfilter.org/projects/conntrack-tools/downloads.html#conntrack-tools-1.4.7

To build the code, updated libnetfilter_conntrack 1.0.9 is required:

https://netfilter.org/projects/libnetfilter_conntrack/downloads.html#libnetfilter_conntrack-1.0.9

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--qk/Pc/5uyi/BG8zw
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="changes-conntrack-tools-1.4.7.txt"
Content-Transfer-Encoding: 8bit

Aaron Thompson (1):
  conntrackd: cthelper: ssdp: Fix parsing of IPv6 M-SEARCH requests.

Adam Casella (1):
  conntrackd: cache: fix zone entry uniqueness in external cache

Arturo Borrero Gonzalez (8):
  .gitignore: add nano swap file
  conntrackd: external_inject: report inject issues as warning
  conntrackd: introduce yes & no config values
  tests: introduce new python-based framework for running tests
  tests: introduce some basic testcases for the new conntrack-tools
    testing framework
  tests: introduce replicating scenario and simple icmp test case
  tests: conntrackd: add testcase for missing hashtable buckets and max
    entries
  tests: conntrackd: silence sysctl

Florian Westphal (8):
  conntrack: add support for CLASH_RESOLVED counter
  conntrack: pretty-print the portid
  conntrack: enable kernel-based status filtering with -L -u STATUS
  conntrack: add shorthand mnemonic for UNREPLIED
  conntrack: add support for chaintoolong stat counter
  conntrack: fix compiler warnings
  conntrack: remove -o userspace
  conntrack: unbreak event mode

Jeremy Sowden (9):
  build: remove commented-out macros from configure.ac
  build: quote AC_INIT arguments
  build: replace `AM_PROG_LIBTOOL` and `AC_DISABLE_STATIC` with
    `LT_INIT`
  build: remove yacc-generated header from EXTRA_DIST
  build: clean yacc- and lex-generated files with maintainer-clean
  build: fix dependency-tracking of yacc-generated header
  build: only require bison and flex if the generated files do not exist
  build: remove MAINTAINERCLEANFILES
  build: replace `AM_PROG_LEX` with `AC_PROG_LEX`

Mikhail Sennikovsky (20):
  tests: icmp entry create/delete
  conntrack: fix icmp entry creation
  conntrack: implement save output format
  conntrack.8: man update for opts format support
  conntrack: accept commands from file
  conntrack.8: man update for --load-file support
  tests: saving and loading ct entries, save format
  tests: conntrack -L/-D ip family filtering
  tests/conntrack: script for stress-testing ct load
  conntrack: pass sock to nfct_mnl_*() functions
  conntrack: use libmnl for updating conntrack table
  conntrack: use libmnl for ct entries deletion
  conntrack: use libmnl for flushing conntrack table
  conntrack: use same modifier socket for bulk ops
  conntrack: set reply l4 proto for unknown protocol
  conntrack: fix protocol number parsing
  conntrack: fix -o save dump for unknown protocols
  conntrack: generalize command parsing
  conntrack: use C99 initializer syntax for option map
  conntrack: introduce new -A command

Pablo Neira Ayuso (44):
  conntrack: add support for the IPS_HW_OFFLOAD flag
  conntrack: add a few more tests
  doc: manual: fix conntrack examples
  doc: manual: refer to nf_conntrack sysctl
  doc: manual: general documentation revamp
  conntrack: default to unspec family for dualstack setups
  conntrack: allow to filter event by family
  conntrack: allow to flush per family
  conntrackd: add ip netns test script
  conntrack: add struct ct_cmd
  conntrack: add struct ct_tmpl
  conntrack: add do_command_ct()
  tests: conntrackd: move basic netns scenario setup to shell script
  conntrackd: set default hashtable buckets and max entries if not
    specified
  conntrack: pass command object to callbacks
  conntrack: pass ct_cmd to nfct_filter_init()
  conntrack: pass cmd to nfct_filter()
  conntrack: pass cmd to filter nat, mark and network functions
  conntrack: move options flag to ct_cmd object
  conntrack: add function to print command stats
  conntrack: release options after parsing
  conntrackd: fix endianness bug in IPv4 and IPv6 address
  conntrackd: cthelper: Set up userspace helpers when daemon starts
  doc: manual: Document userspace helper configuration at daemon startup
  conntrackd: cthelper: fix overlapping queue numbers in example file
  src: conntrackd: add #include <linux/netfilter/nfnetlink_queue.h>
  doc: add cluster match script
  conntrackd: do not include conntrack ID in hashtable cmp
  conntrack: pass filter_dump object to nfct_mnl_dump()
  conntrack: enhance mnl_nfct_dump_cb()
  conntrack: use libmnl for listing conntrack table
  conntrack: add nfct_mnl_talk() and nfct_mnl_recv() helper functions
  conntrack: add netlink flags to nfct_mnl_nlmsghdr_put()
  conntrack: use libmnl to create entry
  conntrack: rename nfct_mnl_recv() to __nfct_mnl_dump()
  conntrack: add nfct_mnl_request()
  nfct: remove lazy binding
  conntrack: consolidate socket open call
  conntrackd: build: always add ports to sync message
  conntrack: pass command object to nfct_mnl_request()
  conntrack: update CT_GET to use libmnl
  conntrack: update manpage with new -A command
  conntrack: use IPPROTO_RAW
  conntrack: slightly simplify parse_proto_num() by using strtoul()

Phil Sutter (9):
  hash: Flush tables when destroying
  cache: Fix features array allocation
  Fix potential buffer overrun in snprintf() calls
  helpers: ftp: Avoid ugly casts
  read_config_yy: Drop extra argument from dlog() call
  Don't call exit() from signal handler
  Drop pointless assignments
  connntrack: Fix for memleak when parsing -j arg
  local: Avoid sockaddr_un::sun_path buffer overflow

Yi Yang (1):
  conntrack: fix zone sync issue

Štěpán Němec (1):
  conntrack.8: minor copy edit

--qk/Pc/5uyi/BG8zw--
