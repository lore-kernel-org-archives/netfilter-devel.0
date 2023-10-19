Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96ABCDB483
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 11:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbjJSLqS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 07:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbjJSLqR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 07:46:17 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3AE9F;
        Thu, 19 Oct 2023 04:46:12 -0700 (PDT)
Received: from [78.30.34.192] (port=53402 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qtRTZ-002j2d-0X; Thu, 19 Oct 2023 13:46:08 +0200
Date:   Thu, 19 Oct 2023 13:46:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 1.0.9 release
Message-ID: <ZTEW/A8ze+8HrI2u@calendula>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q6Lf2IgjCzW7D6s9"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Q6Lf2IgjCzW7D6s9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.0.9

This release contains enhancements and fixes such as:

- Speed up chain listing:

     # time nft list chain inet raw input
     table inet raw {
         chain input {
             type filter hook input priority filter; policy accept;
             ip6 saddr @bogons6 counter drop
         }
     }

     before:
     real    0m2,913s
     user    0m1,345s
     sys     0m1,568s

     after:
     real    0m0,056s
     user    0m0,018s
     sys     0m0,039s

- Allow custom conntrack timeouts to use time specification (not only
  seconds), e.g.

    table inet x {
        ct timeout customtimeout {
                protocol tcp
                l3proto ip
                policy = { established: 2m, close: 20s }
        }

        chain y {
                type filter hook prerouting priority filter; policy accept;
                tcp dport 8888 ct timeout set "customtimeout"
        }
    }

- Allow to combine dnat with numgen, eg.

     ... dnat to numgen inc mod 8 offset 0xc0a864c8

  where offset 0xc0a864c8 represents 192.168.100.200, to fan out packets
  using stateful DNAT from 192.168.100.200 to 192.168.100.207.

- Allow for using constants as key in dynamic sets.

    table inet x {
        chain y {
                type filter hook input priority 0; policy drop;
                udp dport 45378 add @dynmark { 10.2.3.4 timeout 3s : 0x00000002 }
        }
    }

- Fix get element command with concatenated set:

    table ip filter {
            set test {
                    type ipv4_addr . ether_addr . mark
                    flags interval
                    elements = { 198.51.100.0/25 . 00:0b:0c:ca:cc:10-c1:a0:c1:cc:10:00 . 0x0000006f, }
            }
    }

  then allow to check if element is present with:

    # nft get element ip filter test { 198.51.100.1 . 00:0b:0c:ca:cc:10 . 0x6f }

- Support for matching on the target address of a IPv6 neighbour
  solicitation/advertisement.

    ... icmpv6 type nd-neighbor-solicit icmpv6 taddr 2001:db8::133 counter

- Provide a pyproject.toml config file and legacy setup.py script
  to install Python support. Using pip:

        python -m pip install py/

  or, alternatively, legacy setup.py script:

        cd py && python setup.py install

- Fix incorrect bytecode to set meta and ct mark using smaller size
  selector results in incorrect bytecode, e.g. set meta mark to
  ip dscp header field.

    ... meta mark set ip dscp

  Support for this is available since 1.0.8, but bytecode generation
  was not correct.

- Empty internal cache in -o/--optimize (which implicitly pulls in
  -c/--check mode) otherwise stale objects remain in place, triggering BUG:

     BUG: invalid input descriptor type 151665524
     nft: erec.c:161: erec_print: Assertion `0' failed.
     Aborted

- Fix memleak in prefix evaluation with wildcard interface name

    The following ruleset:

      table ip x {
            chain y {
                    meta iifname { abcde*, xyz }
            }
      }

- Restore interval maps, broken since 1.0.7. e.g.

    table inet filter {
           counter TEST {
                   packets 0 bytes 0
           }

           map testmap {
                   type ipv4_addr : counter
                   flags interval
                   elements = { 192.168.0.0/24 : "TEST" }
           }
    }

- Restore bitwise operations in combination with maps, eg. jump to
  chain depending on bitwise operation on packet mark.

    table ip x {
           map sctm_o0 {
               type mark : verdict
               elements = { 0x00000000 : jump sctm_o0_0, 0x00000001 : jump sctm_o0_1 }
           }

           chain sctm_o0_0 {
                counter
           }

           chain sctm_o0_1 {
                counter
           }

           chain SET_ctmark_RPLYroute {
                   meta mark >> 8 & 0xf vmap @sctm_o0
           }
    }

- Display default burst of 5 packets in limit statement, this was not
  printed for historical reasons, now this is shown in the listing, e.g.

  ... limit rate 400/minute burst 5 packets accept

- Restore use of conntrack label in concatenations, eg.

  ... ct label . ct mark  { 0x1 . 0x1 }

- Do not merge expressions across non-expression statements, e.g.

  .... ether saddr 00:11:22:33:44:55 counter ether type 8021q

  is not merged because the counter statement falls in between these
  two candidate expressions that could be coalesced in one single
  expression to match at ethernet source address offset and the
  ether type field coming next.

- Fix crash with log prefix longer that 127 bytes.

- Fixes for JSON support.

- ... and many unsorted fixes found via proactive code inspection.

... as well as asorted fixes and manpage documentation updates.

See changelog for more details (attached to this email).

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

[ NOTE: We have switched to .tar.xz files for releases. ]

To build the code, libnftnl >= 1.2.6 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--Q6Lf2IgjCzW7D6s9
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.0.9.txt"

Arturo Borrero Gonzalez (1):
      tests/build/run-tests.sh: fix issues reported by shellcheck

Brennan Paciorek (1):
      doc: document add chain device parameter

Florian Westphal (48):
      exthdr: prefer raw_type instead of desc->type
      tests: shell: auto-run kmemleak if its available
      netlink: delinearize: copy set keytype if needed
      rule: allow src/dstnat prios in input and output
      ct expectation: fix 'list object x' vs. 'list objects in table' confusion
      tests: fix inet nat prio tests
      tests: add dynmap datapath add/delete test case
      parser: allow ct timeouts to use time_spec values
      parser: deduplicate map with data interval
      tests: shell: add test case for double-deactivation
      tests: add test with concatenation, vmap and timeout
      tests: add transaction stress test with parallel delete/add/flush and netns deletion
      tests: add one more chain jump in vmap test
      tests: add table validation check
      tests: update bad_expression test case
      tests: 30s-stress: add failslab and abort phase tests
      parser: permit gc-interval in map declarations
      tests/shell: expand vmap test case to also cause batch abort
      evaluate: fix get element for concatenated set
      tests: shell: 0043concatenated_ranges_0: re-enable all tests
      tests/shell: make delete_by_handle test work on older releases
      tests/shell: typeof_integer/raw: prefer @nh for payload matching
      tests: shell: fix dump validation message
      tests: shell: add sample ruleset reproducer
      tests/shell: add and use chain binding feature probe
      tests/shell: skip netdev_chain_0 if kernel requires netdev device
      tests/shell: skip map query if kernel lacks support
      tests/shell: skip inner matching tests if unsupported
      tests/shell: skip bitshift tests if kernel lacks support
      tests/shell: skip some tests if kernel lacks netdev egress support
      tests/shell: skip inet ingress tests if kernel lacks support
      tests/shell: skip destroy tests if kernel lacks support
      tests/shell: skip catchall tests if kernel lacks support
      tests/shell: skip test cases involving osf match if kernel lacks support
      tests/shell: skip test cases if ct expectation and/or timeout lacks support
      tests/shell: skip reset tests if kernel lacks support
      tests: shell: skip adding catchall elements if unuspported
      tests: shell: add feature probe for sets with more than one element
      tests: shell: add feature probe for sctp chunk matching
      tests: shell: skip flowtable-uaf if we lack table owner support
      rule: never merge across non-expression statements
      tests: never merge across non-expression statements redux
      libnftables: refuse to open onput files other than named pipes or regular files
      scanner: restrict include directive to regular files
      tests: never merge across non-expression statements redux 2
      tests: add test for dormant on/off/on bug
      tests: shell: add vlan match test case
      evaluate: suggest != in negation error message

Jeremy Sowden (5):
      py: move package source into src directory
      py: use setup.cfg to configure setuptools
      py: add pyproject.toml to support PEP-517-compatible build-systems
      doc: move man-pages to `dist_man_MANS`
      doc: move man-pages to `MAINTAINERCLEANFILES`

Jorge Ortiz (1):
      evaluate: place byteorder conversion after numgen for IP address datatypes

Nicolas Cavallari (1):
      icmpv6: Allow matching target address in NS/NA, redirect and MLD

Pablo Neira Ayuso (33):
      meta: stash context statement length when generating payload/meta dependency
      update INSTALL file
      tests: shell: extend implicit chain map with flush command
      py: remove setup.py integration with autotools
      libnftables: Drop cache in -c/--check mode
      INSTALL: provide examples to install python bindings
      cache: chain listing implicitly sets on terse option
      evaluate: error out on meter overlap with an existing set/map declaration
      tests: shell: use minutes granularity in sets/0036add_set_element_expiration_0
      evaluate: do not remove anonymous set with protocol flags and single element
      proto: use hexadecimal to display ip frag-off field
      tests: py: extend ip frag-off coverage
      tests: py: debloat frag.t.payload.netdev
      src: use internal_location for unspecified location at allocation time
      src: remove check for NULL before calling expr_free()
      src: simplify chain_alloc()
      rule: set internal_location for table and chain
      evaluate: revisit anonymous set with single element optimization
      doc: describe behaviour of {ip,ip6} length
      evaluate: fix memleak in prefix evaluation with wildcard interface name
      evaluate: expand sets and maps before evaluation
      evaluate: perform mark datatype compatibility check from maps
      limit: display default burst when listing ruleset
      datatype: initialize TYPE_CT_LABEL slot in datatype array
      datatype: initialize TYPE_CT_EVENTBIT slot in datatype array
      tests: py: add map support
      json: expose dynamic flag
      netlink_linearize: skip set element expression in map statement key
      tests: shell: fix spurious errors in sets/0036add_set_element_expiration_0
      json: add missing map statement stub
      doc: remove references to timeout in reset command
      evaluate: validate maximum log statement prefix length
      build: Bump version to 1.0.9

Phil Sutter (21):
      tests: monitor: Summarize failures per test case
      tests: shell: Review test-cases for destroy command
      tests: shell: Stabilize sets/reset_command_0 test
      tests: shell: Stabilize sets/0043concatenated_ranges_0 test
      evaluate: Drop dead code from expr_evaluate_mapping()
      tests: monitor: Fix monitor JSON output for insert command
      tests: monitor: Fix time format in ct timeout test
      tests: monitor: Fix for wrong syntax in set-interval.t
      tests: monitor: Fix for wrong ordering in expected JSON output
      parser_json: Catch wrong "reset" payload
      parser_json: Fix typo in json_parse_cmd_add_object()
      parser_json: Proper ct expectation attribute parsing
      parser_json: Fix flowtable prio value parsing
      parser_json: Fix limit object burst value parsing
      parser_json: Fix synproxy object mss/wscale parsing
      parser_json: Wrong check in json_parse_ct_timeout_policy()
      parser_json: Catch nonsense ops in match statement
      parser_json: Default meter size to zero
      tests: shell: features: Fix table owner flag check
      tests: shell: Fix for failing nft-f/sample-ruleset
      tests: shell: sets/reset_command_0: Fix drop_seconds()

Thomas Haller (121):
      py: return boolean value from Nftables.__[gs]et_output_flag()
      json: use strtok_r() instead of strtok()
      nftutils: add and use wrappers for getprotoby{name,number}_r(), getservbyport_r()
      meta: don't assume time_t is 64 bit in date_type_print()
      meta: use reentrant localtime_r()/gmtime_r() functions
      gitignore: ignore cscope files
      src: add input flags for nft_ctx
      src: add input flag NFT_CTX_INPUT_NO_DNS to avoid blocking
      src: add input flag NFT_CTX_INPUT_JSON to enable JSON parsing
      py: fix exception during cleanup of half-initialized Nftables
      py: extract flags helper functions for set_debug()/get_debug()
      py: add Nftables.{get,set}_input_flags() API
      meta: define _GNU_SOURCE to get strptime() from <time.h>
      src: add <nft.h> header and include it as first
      include: don't define _GNU_SOURCE in public header
      configure: use AC_USE_SYSTEM_EXTENSIONS to get _GNU_SOURCE
      include: include <std{bool,int}.h> via <nft.h>
      configure: drop AM_PROG_CC_C_O autoconf check
      netlink: avoid "-Wenum-conversion" warning in dtype_map_from_kernel()
      netlink: avoid "-Wenum-conversion" warning in parser_bison.y
      datatype: avoid cast-align warning with struct sockaddr result from getaddrinfo()
      evaluate: fix check for truncation in stmt_evaluate_log_prefix()
      src: rework SNPRINTF_BUFFER_SIZE() and handle truncation
      evaluate: don't needlessly clear full string buffer in stmt_evaluate_log_prefix()
      src: suppress "-Wunused-but-set-variable" warning with "parser_bison.c"
      include: drop "format" attribute from nft_gmp_print()
      rule: fix "const static" declaration
      utils: call abort() after BUG() macro
      src: silence "implicit-fallthrough" warnings
      xt: avoid "-Wmissing-field-initializers" for "original_opts"
      tests/shell: rework command line parsing in "run-tests.sh"
      tests/shell: rework finding tests and add "--list-tests" option
      tests/shell: check test names before start and support directories
      tests/shell: export NFT_TEST_BASEDIR and NFT_TEST_TMPDIR for tests
      tests/shell: normalize boolean configuration in environment variables
      tests/shell: print test configuration
      tests/shell: run each test in separate namespace and allow rootless
      tests/shell: interpret an exit code of 77 from scripts as "skipped"
      tests/shell: support --keep-logs option (NFT_TEST_KEEP_LOGS=y) to preserve test output
      tests/shell: move the dump diff handling inside "test-wrapper.sh"
      tests/shell: rework printing of test results
      tests/shell: move taint check to "test-wrapper.sh"
      tests/shell: move valgrind wrapper script to separate script
      tests/shell: support running tests in parallel
      tests/shell: bind mount private /var/run/netns in test container
      tests/shell: skip test in rootless that hit socket buffer size limit
      tests/shell: record the test duration (wall time) in the result data
      tests/shell: fix "0003includepath_0" for different TMPDIR
      tests/shell: set TMPDIR for tests in "test-wrapper.sh"
      tests/shell: return 77/skip for tests that fail to create dummy device
      tests/shell: cleanup result handling in "test-wrapper.sh"
      tests/shell: cleanup print_test_result() and show TAINTED error code
      tests/shell: colorize terminal output with test result
      tests/shell: fix handling failures with VALGRIND=y
      tests/shell: print the NFT setting with the VALGRIND=y wrapper
      tests/shell: don't redirect error/warning messages to stderr
      tests/shell: redirect output of test script to file too
      tests/shell: print "kernel is tainted" separate from test result
      tests/shell: no longer enable verbose output when selecting a test
      tests/shell: record wall time of test run in result data
      tests/shell: set NFT_TEST_JOBS based on $(nproc)
      cache: avoid accessing uninitialized varible in implicit_chain_cache()
      datatype: rename "dtype_clone()" to datatype_clone()
      tests/shell: honor .nodump file for tests without nft dumps
      tests/shell: generate and add ".nft" dump files for existing tests
      tests/shell: add missing ".nodump" file for tests without dumps
      tests/shell: add ".nft" dump files for tests without dumps/ directory
      tests/shell: set valgrind's "--vgdb-prefix=" to orignal TMPDIR
      tests/shell: print number of completed tests to show progress
      tests/shell: skip tests if nft does not support JSON mode
      tests/shell: add "--quick" option to skip slow tests (via NFT_TEST_SKIP_slow=y)
      parser_bison: include <nft.h> for base C environment to "parser_bison.y"
      include: include <stdlib.h> in <nft.h>
      tests/shell: kill running child processes when aborting "run-tests.sh"
      tests/shell: ensure vgdb-pipe files are deleted from "nft-valgrind-wrapper.sh"
      datatype: fix leak and cleanup reference counting for struct datatype
      tests/shell: export NFT_TEST_RANDOM_SEED variable for tests
      tests/shell: add "random-source.sh" helper for random-source for sort/shuf
      tests/shell: add option to shuffle execution order of tests
      tests/shell: remove spurious .nft dump files
      tests/shell: drop unstable dump for "transactions/0051map_0" test
      tests/shell: add missing nft/nodump files for tests
      tests/shell: special handle base path starting with "./"
      tests/shell: in find_tests() use C locale for sorting tests names
      tools: add "tools/check-tree.sh" script to check consistency of nft dumps
      tests/shell: exit 77 from "run-tests.sh" if all tests were skipped
      tests/shell: accept $NFT_TEST_TMPDIR_TAG for the result directory
      tests/shell: honor CLICOLOR_FORCE to force coloring in run-tests.sh
      tests/build: capture more output from "tests/build/run-tests.sh" script
      tests/shell: add feature probing via "features/*.nft" files
      tests/shell: colorize NFT_TEST_SKIP_/NFT_TEST_HAVE_ in test output
      tests/shell: suggest 4Mb /proc/sys/net/core/{wmem_max,rmem_max} for rootless
      tests/shell: cleanup creating dummy interfaces in tests
      tests/shell: implement NFT_TEST_HAVE_json feature detection as script
      tests/shell: check diff in "maps/typeof_maps_0" and "sets/typeof_sets_0" test
      tests/shell: fix preserving ruleset diff after test
      tests/shell: set C locale in "run-tests.sh"
      tests/shell: don't show the exit status for failed tests
      tests/shell: colorize NFT_TEST_HAS_SOCKET_LIMITS
      tests/shell: simplify collecting error result in "test-wrapper.sh"
      netlink: fix leaking typeof_expr_data/typeof_expr_key in netlink_delinearize_set()
      libnftables: drop gmp_init() and mp_set_memory_functions()
      libnftables: move init-once guard inside xt_init()
      tests/shell: run `nft --check` on persisted dump files
      src: fix indentation/whitespace
      proto: add missing proto_definitions for PROTO_DESC_GENEVE
      include: fix missing definitions in <cache.h>/<headers.h>
      netlink: handle invalid etype in set_make_key()
      datatype: use "enum byteorder" instead of int in set_datatype_alloc()
      payload: use enum icmp_hdr_field_type in payload_may_dependency_kill_icmp()
      datatype: return const pointer from datatype_get()
      tests/shell: honor NFT_TEST_FAIL_ON_SKIP variable to fail on any skipped tests
      expression: cleanup expr_ops_by_type() and handle u32 input
      mergesort: avoid cloning value in expr_msort_cmp()
      include: include <string.h> in <nft.h>
      datatype: use xmalloc() for allocating datatype in datatype_clone()
      tests/shell: mount all of "/var/run" in "test-wrapper.sh"
      tests/shell: preserve result directory with NFT_TEST_FAIL_ON_SKIP
      tests/shell: add "-S|--setup-host" option to set sysctl for rootless tests
      tests/shell: add missing "vlan_8021ad_tag.nodump" file
      tests/shell: use bash instead of /bin/sh for tests


--Q6Lf2IgjCzW7D6s9--
